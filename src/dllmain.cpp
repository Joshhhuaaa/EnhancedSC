#include "stdafx.h"
#include "common.hpp"
#include "config.hpp"
#include "logging.hpp"

///Resources
//#include "callbacks.h"
#include "hook_dlls.hpp"
#include "gamevars.hpp"

///Features
#include "intro_skip.hpp"
#include "custom_saves.hpp"
#include "dpad_keybinds.hpp"
#include "pause_on_focus_loss.hpp"

///Fixes
#include "restore_eax.hpp"
#include "distance_culling.hpp"
#include "idle_timers.hpp"
#include "mouse_xbuttons_support.hpp"

//Warnings
#include "asi_loader_checks.hpp"
#include "steam_deck_features.hpp"
#include "submodule_initiailization.hpp"
#include "use_xbox_fonts.hpp"
#include "version_checker.hpp"

///WIP
//#include "msaa.hpp"
//#include "pause_on_focus_loss.hpp"
//#include "wireframe.hpp"

void Initbinw32() //g_GameDLLs.binkw32
{
}

void InitDareAudio() //g_GameDLLs.DareAudio
{
}
void Initeax() //g_GameDLLs.eax
{
}
void InitEchelon() //g_GameDLLs.Echelon
{
}
void InitEchelonHUD() //g_GameDLLs.EchelonHUD
{
    IdleTimers::Initialize();

}
void InitEchelonIngredient() //g_GameDLLs.EchelonIngredient
{
}
void InitEchelonMenus() //g_GameDLLs.EchelonMenus
{
}
void InitEditor() //g_GameDLLs.Editor
{
}
void InitSNDdbgV() //g_GameDLLs.SNDdbgV
{
}
void InitSNDDSound3DDLL_VBR() //g_GameDLLs.SNDDSound3DDLL_VBR
{
}
void InitSNDext_VBR() //g_GameDLLs.SNDext_VBR
{
}
void InitUWindow() //g_GameDLLs.UWindow
{
}
void InitWinDrv() //g_GameDLLs.WinDrv
{}

void InitD3DDrv() //g_GameDLLs.D3DDrv
{
    MouseXButtonsSupport::Initialize();
}

void InitializeSubsystems()
{
    INITIALIZE(g_Logging.LogSysInfo());
    INITIALIZE(Init_ASILoaderSanityChecks());
    if (Util::iequals(sExeName, "Splintercell.exe"))
    {
        INITIALIZE(SteamDeckFeatures::Toggle());
        INITIALIZE(g_GameDLLs.Initialize());
        /* At this point Core, Engine, GeometricEvent, and Window dll's are hooked.
        Things reliant on binkw32, D3DDrv, DareAudio, eax, Echelon, EchelonHUD, EchelonIngredient, EchelonMenus, Editor, SNDdbgV, SNDDSound3DDLL_VBR, SNDext_VBR, UWindow, and WinDrv
        need to be hooked via the above Init functions, as they're loaded after ASI loader finishes everything. */

        INITIALIZE(g_GameVars.Initialize());
        INITIALIZE(Config::Read()); 
        INITIALIZE(CustomSaves::Initialize());
        INITIALIZE(g_DistanceCulling.Initialize());
        INITIALIZE(g_IntroSkip.Initialize());
        INITIALIZE(RestoreEAX::Initialize());
        INITIALIZE(DPadKeybinds::Initialize());
        INITIALIZE(UseXboxFonts::Toggle());

        INITIALIZE(CheckForUpdates());
    }
    else
    {
        spdlog::error("Game not detected. Please ensure you are running the correct game executable.");
    }
}


std::mutex mainThreadFinishedMutex;
std::condition_variable mainThreadFinishedVar;
bool mainThreadFinished = false;


DWORD __stdcall Main(void*)
{
    g_Logging.initStartTime = std::chrono::high_resolution_clock::now();
    Logging::Initialize();
    INITIALIZE(InitializeSubsystems());

    // Signal any threads (e.g., the GetStartupInfoA hook) that are waiting for initialization to finish.
    {
        std::lock_guard lock(mainThreadFinishedMutex);
        mainThreadFinished = true;
    }
    mainThreadFinishedVar.notify_all();

    return true;
}



std::mutex gmhMutex;
bool gmhHookCalled = false;
static HMODULE(WINAPI* GetModuleHandleA_Fn)(LPCSTR lpModuleName);
static HMODULE WINAPI GetModuleHandleA_Hook(LPCSTR lpModuleName)
{
    std::lock_guard lock(gmhMutex);

    if (!gmhHookCalled)
    {
        gmhHookCalled = true;

        // Restore the original so future calls bypass our hook.
        Memory::WriteIAT(baseModule, "KERNEL32.dll", "GetModuleHandleA", GetModuleHandleA_Fn);

        // Stall main thread until initialization finishes.
        std::unique_lock finishedLock(mainThreadFinishedMutex);
        mainThreadFinishedVar.wait(finishedLock, []
            {
                return mainThreadFinished;
            });
    }

    // Forward to the next function (real GetModuleHandleA or another hook).
    return reinterpret_cast<decltype(GetModuleHandleA_Fn)>(GetModuleHandleA_Fn)(lpModuleName);
}


BOOL APIENTRY DllMain(HMODULE hModule,
    DWORD  ul_reason_for_call,
    LPVOID lpReserved
)
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
    {

        HMODULE k32 = GetModuleHandleA("KERNEL32.dll");
        if (k32)
        {
            void* currentIAT = Memory::ReadIAT(baseModule, "KERNEL32.dll", "GetModuleHandleA");
            GetModuleHandleA_Fn = reinterpret_cast<decltype(GetModuleHandleA_Fn)>(currentIAT);
            Memory::WriteIAT(baseModule, "KERNEL32.dll", "GetModuleHandleA", &GetModuleHandleA_Hook);
        }

        SetProcessDPIAware();

        if (HANDLE mainHandle = CreateThread(NULL, 0, Main, 0, CREATE_SUSPENDED, 0))
        {
            SetThreadPriority(mainHandle, THREAD_PRIORITY_TIME_CRITICAL); // set our Main thread priority higher than the games thread
            ResumeThread(mainHandle);
            CloseHandle(mainHandle);
        }
        break;

    }
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}
