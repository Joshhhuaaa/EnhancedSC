#include "stdafx.h"
#include "checkpoint_quickload.hpp"

#include "common.hpp"
#include "custom_saves.hpp"
#include "helper.hpp"
#include "hook_dlls.hpp"
#include "logging.hpp"

namespace
{
    // APlayerController::Flags - bit 0x02 is bLoadingTraining
    constexpr unsigned kAPCFlagsOffset           = 0x3C4;
    constexpr uint32_t kAPCFlagBLoadingTraining  = 0x02u;

    // UGameEngine::Client at +0x1C
    constexpr unsigned kEngineClientOffset       = 0x1C;
    // UClient::Viewports TArray at +0x30
    constexpr unsigned kClientViewportsArrOffset = 0x30;
    // UViewport::Actor at +0x34
    constexpr unsigned kViewportActorOffset      = 0x34;

    // UObject memory layout
    constexpr unsigned kUObjectNameOffset  = 0x20;
    constexpr unsigned kUObjectClassOffset = 0x24;

    // SC1 packs UProperty::Offset as uint16_t at +0x44
    constexpr unsigned kUPropertyOffsetField = 0x44;
    // SC1 packs UBoolProperty::BitMask at +0x54
    constexpr unsigned kUBoolPropertyBitMaskField = 0x54;

    // Defer load for N ticks to let HUD render before blocking load
    constexpr int kLoadDeferFrames = 2;

    // Core.dll exports (SC1 uses PBG mangling for const wchar_t*)
    void(__fastcall* g_FName_ctor)(int* /*FName out*/, void* /*edx*/,
                                   const wchar_t* Name, int FindType) = nullptr;
    const wchar_t* (__cdecl* g_Localize)(const wchar_t* Section, const wchar_t* Key,
                                         const wchar_t* Package, const wchar_t* LangExt,
                                         int Optional) = nullptr;
    wchar_t* (__fastcall* g_GetFullName)(void* /*UObject*/, void* /*edx*/,
                                         wchar_t* Buffer) = nullptr;
    void** g_GNullSlot = nullptr;

    // Engine.dll
    SafetyHookInline g_hkUGameEngineExec = {};

    // Echelon.dll
    SafetyHookInline g_hkAEPlayerControllerTick = {};

    // Core.dll - observation hook
    SafetyHookInline g_hkUPropertyCopyCompleteValue = {};

    // bEnableCheckpoints FName cache
    int      g_NameIdx_bEnableCheckpoints = 0;
    int      g_NameIdx_EchelonGameInfo    = 0;

    // Live bEnableCheckpoints flag location (captured from script copy)
    uint32_t* g_BEnableCheckpoints_LiveDWORD = nullptr;
    uint32_t  g_BEnableCheckpoints_BitMask   = 0;

    // Cached APlayerController (updated every frame)
    void* g_LastSeenPC = nullptr;

    // Deferred load state
    int          g_LoadDeferRemaining = 0;
    void*        g_PendingLoadEngine  = nullptr;
    void*        g_PendingLoadPC      = nullptr;
    std::wstring g_PendingLoadCmd;

    std::string WToU8(const wchar_t* w)
    {
        if (w == nullptr)
            return "<null>";
        return Util::WideToUTF8(w);
    }
    std::string WToU8(const std::wstring& w) { return Util::WideToUTF8(w); }

    // Read bEnableCheckpoints from live DWORD (defaults to true if not observed yet)
    bool ReadBEnableCheckpointsLive()
    {
        if (g_BEnableCheckpoints_LiveDWORD == nullptr)
            return true;
        const uint32_t dword = *g_BEnableCheckpoints_LiveDWORD;
        return (dword & g_BEnableCheckpoints_BitMask) != 0;
    }

    // Cache FName indices lazily (FName subsystem not ready at Initialize time)
    void EnsureFNameCacheReady()
    {
        if (g_NameIdx_bEnableCheckpoints != 0 || g_FName_ctor == nullptr)
            return;
        g_FName_ctor(&g_NameIdx_bEnableCheckpoints, nullptr, L"bEnableCheckpoints", 1);
        g_FName_ctor(&g_NameIdx_EchelonGameInfo,    nullptr, L"EchelonGameInfo",    1);
    }

    // UProperty::CopyCompleteValue observer - capture bEnableCheckpoints flag location
    void __fastcall UPropertyCopyCompleteValueHook(void* uProperty, void* edx,
                                                   char* dst, char* src, void* subobjectRoot)
    {
        g_hkUPropertyCopyCompleteValue.unsafe_fastcall(uProperty, edx, dst, src, subobjectRoot);

        EnsureFNameCacheReady();

        if (g_NameIdx_bEnableCheckpoints == 0 || uProperty == nullptr || dst == nullptr)
            return;

        const int propNameIdx = *reinterpret_cast<int*>(
            reinterpret_cast<char*>(uProperty) + kUObjectNameOffset);
        if (propNameIdx != g_NameIdx_bEnableCheckpoints)
            return;

        const uint16_t propOffset = *reinterpret_cast<uint16_t*>(
            reinterpret_cast<char*>(uProperty) + kUPropertyOffsetField);
        const uint32_t propBitMask = *reinterpret_cast<uint32_t*>(
            reinterpret_cast<char*>(uProperty) + kUBoolPropertyBitMaskField);

        g_BEnableCheckpoints_LiveDWORD = reinterpret_cast<uint32_t*>(dst);
        g_BEnableCheckpoints_BitMask   = propBitMask;
    }

    std::filesystem::path FindActiveProfileFolder()
    {
        try
        {
            const auto saveRoot = sExePath / L".." / L"Save";
            if (!std::filesystem::is_directory(saveRoot))
                return {};

            std::filesystem::path best;
            std::filesystem::file_time_type bestTime{};
            bool haveBest = false;

            for (const auto& entry : std::filesystem::directory_iterator(saveRoot))
            {
                if (!entry.is_directory())
                    continue;
                const auto t = entry.last_write_time();
                if (!haveBest || t > bestTime)
                {
                    best     = entry.path();
                    bestTime = t;
                    haveBest = true;
                }
            }

            return haveBest ? best : std::filesystem::path();
        }
        catch (const std::exception&)
        {
            return {};
        }
        catch (...)
        {
            return {};
        }
    }

    std::wstring GetLocalizedCheckpointName()
    {
        if (g_Localize != nullptr)
        {
            const wchar_t* localized = g_Localize(
                L"Common", L"CheckpointName", L"Localization\\Enhanced", nullptr, 0);
            if (localized != nullptr && localized[0] != L'\0'
                && wcscmp(localized, L"CheckpointName") != 0)
            {
                return localized;
            }
        }
        return L"CHECKPOINT";
    }

    // Find newest of QUICKSAVE.<ext> or <base>1/2/3.<ext>
    std::wstring FindMostRecentQuickloadTarget()
    {
        const auto folder = FindActiveProfileFolder();
        if (folder.empty())
            return {};

        const std::wstring base = GetLocalizedCheckpointName();
        const std::wstring ext  = CustomSaves::kSaveExtension;

        std::wstring bestName;
        FILETIME     bestTime{};
        bool         haveBest = false;

        const auto tryName = [&](const std::wstring& name)
        {
            const auto full = folder / (name + ext);
            WIN32_FILE_ATTRIBUTE_DATA fad{};
            if (GetFileAttributesExW(full.c_str(), GetFileExInfoStandard, &fad)
                && !(fad.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))
            {
                if (!haveBest || CompareFileTime(&fad.ftLastWriteTime, &bestTime) > 0)
                {
                    bestName = name;
                    bestTime = fad.ftLastWriteTime;
                    haveBest = true;
                }
            }
        };

        tryName(L"QUICKSAVE");
        tryName(base + L"1");
        tryName(base + L"2");
        tryName(base + L"3");

        return bestName;
    }

    // Match "LOADGAME" or "QUICKLOAD" prefix (bare, no FILENAME= args)
    bool IsBareLoadGameCommand(const wchar_t* cmd)
    {
        if (cmd == nullptr)
            return false;

        while (*cmd == L' ' || *cmd == L'\t')
            ++cmd;

        auto matchVerb = [&](const wchar_t* verb, int len) -> bool
        {
            for (int i = 0; i < len; ++i)
            {
                if (cmd[i] == 0 || towupper(cmd[i]) != verb[i])
                    return false;
            }
            const wchar_t after = cmd[len];
            return after == 0 || after == L' ' || after == L'\t';
        };

        bool isQuickload = matchVerb(L"QUICKLOAD", 9);
        bool isLoadgame  = !isQuickload && matchVerb(L"LOADGAME", 8);
        if (!isQuickload && !isLoadgame)
            return false;

        // LOADGAME with FILENAME= is user's explicit choice
        if (isLoadgame)
        {
            for (const wchar_t* p = cmd + 8; *p; ++p)
            {
                if (towupper(p[0]) == L'F' && towupper(p[1]) == L'I'
                    && towupper(p[2]) == L'L' && towupper(p[3]) == L'E'
                    && towupper(p[4]) == L'N' && towupper(p[5]) == L'A'
                    && towupper(p[6]) == L'M' && towupper(p[7]) == L'E'
                    && p[8] == L'=')
                {
                    return false;
                }
            }
        }

        return true;
    }

    void* GetActivePlayerController(void* engine)
    {
        if (engine == nullptr)
            return nullptr;
        void* client = *reinterpret_cast<void**>(
            reinterpret_cast<char*>(engine) + kEngineClientOffset);
        if (client == nullptr)
            return nullptr;
        void** viewportsData = *reinterpret_cast<void***>(
            reinterpret_cast<char*>(client) + kClientViewportsArrOffset);
        if (viewportsData == nullptr)
            return nullptr;
        void* viewport = viewportsData[0];
        if (viewport == nullptr)
            return nullptr;
        return *reinterpret_cast<void**>(
            reinterpret_cast<char*>(viewport) + kViewportActorOffset);
    }

    void RunDeferredLoad()
    {
        if (g_PendingLoadEngine == nullptr || g_PendingLoadCmd.empty())
            return;

        void* out = (g_GNullSlot != nullptr) ? *g_GNullSlot : nullptr;

        // Execute through trampoline to avoid re-entry; level transition tears down current PC
        g_hkUGameEngineExec.unsafe_fastcall<int>(
            g_PendingLoadEngine, nullptr,
            g_PendingLoadCmd.c_str(), out);

        g_PendingLoadEngine = nullptr;
        g_PendingLoadPC     = nullptr;
        g_PendingLoadCmd.clear();
    }

    int __fastcall AEPlayerControllerTickHook(void* self, void* edx, int a2, int a3)
    {
        g_LastSeenPC = self;

        if (g_LoadDeferRemaining > 0 && g_PendingLoadPC == self)
        {
            if (--g_LoadDeferRemaining == 0)
                RunDeferredLoad();
        }
        return g_hkAEPlayerControllerTick.unsafe_fastcall<int>(self, edx, a2, a3);
    }

    int __fastcall UGameEngineExecHook(void* self, void* edx, const wchar_t* cmd, void* out)
    {
        if (!IsBareLoadGameCommand(cmd))
            return g_hkUGameEngineExec.unsafe_fastcall<int>(self, edx, cmd, out);

        if (!ReadBEnableCheckpointsLive())
            return g_hkUGameEngineExec.unsafe_fastcall<int>(self, edx, cmd, out);

        const std::wstring target = FindMostRecentQuickloadTarget();

        if (target.empty())
            return g_hkUGameEngineExec.unsafe_fastcall<int>(self, edx, cmd, out);

        if (target == L"QUICKSAVE")
            return g_hkUGameEngineExec.unsafe_fastcall<int>(self, edx, cmd, out);

        void* pc = GetActivePlayerController(self);
        if (pc == nullptr && g_LastSeenPC != nullptr)
            pc = g_LastSeenPC;

        // Build rewritten command with extension (matches menu format)
        wchar_t modified[200];
        swprintf_s(modified, L"Loadgame FILENAME=%s%s",
                   target.c_str(), CustomSaves::kSaveExtension);

        if (pc != nullptr)
        {
            // Set bLoadingTraining flag so HUD draws "QUICKLOADING..." box
            uint32_t* flags = reinterpret_cast<uint32_t*>(
                reinterpret_cast<char*>(pc) + kAPCFlagsOffset);
            *flags |= kAPCFlagBLoadingTraining;

            g_PendingLoadEngine  = self;
            g_PendingLoadPC      = pc;
            g_PendingLoadCmd     = modified;
            g_LoadDeferRemaining = kLoadDeferFrames;
            return 1;
        }

        // No PC available - execute inline without HUD deferral
        return g_hkUGameEngineExec.unsafe_fastcall<int>(
            self, edx, modified, out);
    }
}

void CheckpointQuickload::Initialize()
{
    // Resolve Core.dll exports
    g_FName_ctor = reinterpret_cast<decltype(g_FName_ctor)>(GetProcAddress(
        g_GameDLLs.Core, "??0FName@@QAE@PBGW4EFindName@@@Z"));
    g_Localize = reinterpret_cast<decltype(g_Localize)>(GetProcAddress(
        g_GameDLLs.Core, "?Localize@@YAPBGPBG000H@Z"));
    g_GetFullName = reinterpret_cast<decltype(g_GetFullName)>(GetProcAddress(
        g_GameDLLs.Core, "?GetFullName@UObject@@QBEPBGPAG@Z"));
    g_GNullSlot = reinterpret_cast<void**>(GetProcAddress(
        g_GameDLLs.Core, "?GNull@@3PAVFOutputDevice@@A"));

    // Hook UProperty::CopyCompleteValue to capture bEnableCheckpoints location
    uint8_t* pCopyCompleteValue = reinterpret_cast<uint8_t*>(GetProcAddress(
        g_GameDLLs.Core, "?CopyCompleteValue@UProperty@@UBEXPAX0PAVUObject@@@Z"));
    if (pCopyCompleteValue != nullptr)
    {
        g_hkUPropertyCopyCompleteValue = safetyhook::create_inline(
            pCopyCompleteValue, &UPropertyCopyCompleteValueHook);
    }

    // Hook UGameEngine::Exec for F8 interception
    uint8_t* pExec = reinterpret_cast<uint8_t*>(GetProcAddress(
        g_GameDLLs.Engine, "?Exec@UGameEngine@@UAEHPBGAAVFOutputDevice@@@Z"));
    if (pExec != nullptr)
    {
        g_hkUGameEngineExec = safetyhook::create_inline(
            pExec, &UGameEngineExecHook);
    }
}

void CheckpointQuickload::InitEchelonHooks()
{
    if (g_GameDLLs.Echelon == nullptr)
        return;

    // Hook AEPlayerController::Tick for deferred load countdown
    uint8_t* pAPCTick = reinterpret_cast<uint8_t*>(GetProcAddress(
        g_GameDLLs.Echelon, "?Tick@AEPlayerController@@UAEHMW4ELevelTick@@@Z"));
    if (pAPCTick != nullptr)
    {
        g_hkAEPlayerControllerTick = safetyhook::create_inline(
            pAPCTick, &AEPlayerControllerTickHook);
    }
}
