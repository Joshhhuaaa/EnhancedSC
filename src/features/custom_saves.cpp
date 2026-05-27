#include "stdafx.h"
#include "custom_saves.hpp"

#include "helper.hpp"
#include "hook_dlls.hpp"
#include "logging.hpp"

void CustomSaves::Initialize()
{

    if (uint8_t* SaveFormat = Memory::PatternScan(g_GameDLLs.Engine, "2E 00 73 00 61 00 76 00 00 00", "Save Format"))
    {
        // Keep replacement length identical to original ".sav"
        static_assert(sizeof(kSaveExtension) - sizeof(wchar_t) == 8,
            "kSaveExtension must match original .sav size");
        Memory::PatchBytes((uintptr_t)SaveFormat,
            reinterpret_cast<const char*>(kSaveExtension),
            sizeof(kSaveExtension) - sizeof(wchar_t));
        spdlog::info("Save Format patched successfully.");
    }
    else
    {
        spdlog::error("---------- OUTDATED DLL ERROR ----------");
        spdlog::error("Failed to locate save format memory pattern in {}.", Memory::GetModuleName(g_GameDLLs.Engine, true));
        spdlog::error("({})", Memory::GetModuleName(g_GameDLLs.Engine, false));
        spdlog::error("This usually means leftover files from an old EnhancedSC install are still in your game folder.");
        spdlog::error("Those old modified DLLs are no longer used - their changes are now built directly into our .ASI mod.");
        spdlog::error("Please reinstall the game to restore the original files, then install the latest version of EnhancedSC.");
        spdlog::error("---------- OUTDATED DLL ERROR ----------");
        std::string MessageBoxMessage = "Failed to locate save format memory pattern in " + Memory::GetModuleName(g_GameDLLs.Engine, true) + ".\n"
                                         "("+ Memory::GetModuleName(g_GameDLLs.Engine, false) +")\n"
                                        "\n"
                                        "This usually means leftover files from an old EnhancedSC install are still in your game folder.\n"
                                        "\n"
                                        "Those old modified DLLs are no longer used - their changes are now built directly into our .ASI mod.\n"
                                        "\n"
                                        "Please reinstall the game to restore the original DLL files, then install the latest version of EnhancedSC.";
        MessageBoxA(nullptr, MessageBoxMessage.c_str(), "EnhancedSC Error", MB_OK | MB_ICONERROR);
        ExitProcess(1);
    }
}
