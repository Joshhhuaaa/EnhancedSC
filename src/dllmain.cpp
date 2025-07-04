#include "common.hpp"
#include <safetyhook.hpp>
#include "logging.hpp"

///Resources
//#include "callbacks.h"
#include "hook_dlls.hpp"
#include "gamevars.hpp"

///Features
#include "intro_skip.hpp"
#include "custom_saves.hpp"
#include "pause_on_focus_loss.hpp"

///Fixes
#include "distance_culling.hpp"
#include "idle_timers.hpp"
#include "mouse_xbuttons_support.hpp"

//Warnings
#include "asi_loader_checks.hpp"

///WIP
//#include "msaa.hpp"
//#include "pause_on_focus_loss.hpp"
//#include "wireframe.hpp"


HWND MainHwnd = nullptr;

HMODULE baseModule = GetModuleHandle(NULL);

// Version
std::string sFixName = "EnhancedSC";
int iConfigVersion = 1; //increment this when making config changes, along with the number at the bottom of the config file
                        //that way we can sanity check to ensure people don't have broken/disabled features due to old config files.

std::filesystem::path sExePath;
std::string sExeName;
std::string sGameVersion;

// Ini
inipp::Ini<char> ini;
std::filesystem::path sConfigFile = "Enhanced.ini";
std::pair DesktopDimensions = { 0,0 };

#pragma region deadcode
/*      Deadcode, not used anymore, just kept for reference / future ideas.



void preCreateDXGIFactory()
{


}

void afterCreateDXGIFactory()
{

}

void preD3D11CreateDevice()
{

}

void afterD3D11CreateDevice()
{

}

// CreateWindowExA Hook
SafetyHookInline CreateWindowExA_hook{};
HWND WINAPI CreateWindowExA_hooked(DWORD dwExStyle, LPCSTR lpClassName, LPCSTR lpWindowName, DWORD dwStyle, int X, int Y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam)
{
    if (bBorderlessMode )
    {
        auto hWnd = CreateWindowExA_hook.stdcall<HWND>(dwExStyle, lpClassName, lpWindowName, WS_POPUP, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
        SetWindowPos(hWnd, HWND_TOP, 0, 0, DesktopDimensions.first, DesktopDimensions.second, NULL);
        spdlog::info("CreateWindowExA: Borderless: ClassName = {}, WindowName = {}, dwStyle = {:x}, X = {}, Y = {}, nWidth = {}, nHeight = {}", lpClassName, lpWindowName, WS_POPUP, X, Y, nWidth, nHeight);
        spdlog::info("CreateWindowExA: Borderless: SetWindowPos to X = {}, Y = {}, cx = {}, cy = {}", 0, 0, (int)DesktopDimensions.first, (int)DesktopDimensions.second);
        MainHwnd = hWnd;
        return hWnd;
    }

    if (bWindowedMode)
    {
        auto hWnd = CreateWindowExA_hook.stdcall<HWND>(dwExStyle, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
        SetWindowPos(hWnd, HWND_TOP, 0, 0, iOutputResX, iOutputResY, NULL);
        spdlog::info("CreateWindowExA: Windowed: ClassName = {}, WindowName = {}, dwStyle = {:x}, X = {}, Y = {}, nWidth = {}, nHeight = {}", lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight);
        spdlog::info("CreateWindowExA: Windowed: SetWindowPos to X = {}, Y = {}, cx = {}, cy = {}", 0, 0, iOutputResX, iOutputResY);
        MainHwnd = hWnd;
        return hWnd;
    }
    

    MainHwnd = CreateWindowExA_hook.stdcall<HWND>(dwExStyle, lpClassName, lpWindowName, dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
    return MainHwnd;
}*/

/*
void Init_CalculateScreenSize()
{
    iCurrentResX = iInternalResX;
    iCurrentResY = iInternalResY;

    // Calculate aspect ratio
    fAspectRatio = (float)iCurrentResX / (float)iCurrentResY;
    fAspectMultiplier = fAspectRatio / fNativeAspect;

    // HUD variables
    fHUDWidth = iCurrentResY * fNativeAspect;
    fHUDHeight = (float)iCurrentResY;
    fHUDWidthOffset = (float)(iCurrentResX - fHUDWidth) / 2;
    fHUDHeightOffset = 0;
    if (fAspectRatio < fNativeAspect)
    {
        fHUDWidth = (float)iCurrentResX;
        fHUDHeight = (float)iCurrentResX / fNativeAspect;
        fHUDWidthOffset = 0;
        fHUDHeightOffset = (float)(iCurrentResY - fHUDHeight) / 2;
    }


    // Log details about current resolution
    spdlog::info("Current Resolution: Resolution: {}x{}", iCurrentResX, iCurrentResY);
    spdlog::info("Current Resolution: fAspectRatio: {}", fAspectRatio);
    spdlog::info("Current Resolution: fAspectMultiplier: {}", fAspectMultiplier);
    spdlog::info("Current Resolution: fHUDWidth: {}", fHUDWidth);
    spdlog::info("Current Resolution: fHUDHeight: {}", fHUDHeight);
    spdlog::info("Current Resolution: fHUDWidthOffset: {}", fHUDWidthOffset);
    spdlog::info("Current Resolution: fHUDHeightOffset: {}", fHUDHeightOffset);



/*
bool bAspectFix;
bool bHUDFix;
bool bFOVFix;
bool bOutputResolution;
int iOutputResX;
int iOutputResY;
int iInternalResX;
int iInternalResY;
bool bWindowedMode;
bool bBorderlessMode;
bool bFramebufferFix;
bool bLauncherJumpStart;
int iAnisotropicFiltering;
bool bDisableTextureFiltering;
bool bMouseSensitivity;
float fMouseSensitivityXMulti;
float fMouseSensitivityYMulti;
bool bDisableCursor;
*/

/*
// Aspect ratio + HUD stuff
float fNativeAspect = (float)16 / 9;
float fAspectRatio;
float fAspectMultiplier;
float fHUDWidth;
float fHUDHeight;
float fDefaultHUDWidth = (float)1280;
float fDefaultHUDHeight = (float)720;
float fHUDWidthOffset;
float fHUDHeightOffset;
float fMGS2_EffectScaleX;
float fMGS2_EffectScaleY;
int iCurrentResX;
int iCurrentResY;


    /*
    /*
    inipp::get_value(ini.sections["Output Resolution"], "Enabled", bOutputResolution);
    inipp::get_value(ini.sections["Output Resolution"], "Width", iOutputResX);
    inipp::get_value(ini.sections["Output Resolution"], "Height", iOutputResY);
    inipp::get_value(ini.sections["Output Resolution"], "Windowed", bWindowedMode);
    inipp::get_value(ini.sections["Output Resolution"], "Borderless", bBorderlessMode);
    inipp::get_value(ini.sections["Internal Resolution"], "Width", iInternalResX);
    inipp::get_value(ini.sections["Internal Resolution"], "Height", iInternalResY);
    inipp::get_value(ini.sections["Anisotropic Filtering"], "Samples", iAnisotropicFiltering);
    inipp::get_value(ini.sections["Disable Texture Filtering"], "DisableTextureFiltering", bDisableTextureFiltering);
    inipp::get_value(ini.sections["Framebuffer Fix"], "Enabled", bFramebufferFix);
    inipp::get_value(ini.sections["Launcher Config"], "LauncherJumpStart", bLauncherJumpStart);*/

    //inipp::get_value(ini.sections["MG1 Custom Loading Screens"], "Enabled", g_MG1CustomLoadingScreens.isEnabled);
     /*
    inipp::get_value(ini.sections["Mouse Sensitivity"], "Enabled", bMouseSensitivity);
    inipp::get_value(ini.sections["Mouse Sensitivity"], "X Multiplier", fMouseSensitivityXMulti);
    inipp::get_value(ini.sections["Mouse Sensitivity"], "Y Multiplier", fMouseSensitivityYMulti);
    inipp::get_value(ini.sections["Disable Mouse Cursor"], "Enabled", bDisableCursor);
    inipp::get_value(ini.sections["Texture Buffer"], "SizeMB", iTextureBufferSizeMB);
    inipp::get_value(ini.sections["Fix Aspect Ratio"], "Enabled", bAspectFix);
    inipp::get_value(ini.sections["Fix HUD"], "Enabled", bHUDFix);
    inipp::get_value(ini.sections["Fix FOV"], "Enabled", bFOVFix);
    inipp::get_value(ini.sections["Launcher Config"], "SkipLauncher", bLauncherConfigSkipLauncher);



    // Log config parse
    spdlog::info("Config Parse: bOutputResolution: {}", bOutputResolution);
    if (iOutputResX == 0 || iOutputResY == 0)
    {
        iOutputResX = DesktopDimensions.first;
        iOutputResY = DesktopDimensions.second;
    }
    spdlog::info("Config Parse: iOutputResX: {}", iOutputResX);
    spdlog::info("Config Parse: iOutputResY: {}", iOutputResY);
    spdlog::info("Config Parse: bWindowedMode: {}", bWindowedMode);
    spdlog::info("Config Parse: bBorderlessMode: {}", bBorderlessMode);
    if (iInternalResX == 0 || iInternalResY == 0)
    {
        iInternalResX = iOutputResX;
        iInternalResY = iOutputResY;
    }
    spdlog::info("Config Parse: iInternalResX: {}", iInternalResX);
    spdlog::info("Config Parse: iInternalResY: {}", iInternalResY);
    spdlog::info("Config Parse: iAnisotropicFiltering: {}", iAnisotropicFiltering);
    if (iAnisotropicFiltering < 0 || iAnisotropicFiltering > 16)
    {
        iAnisotropicFiltering = std::clamp(iAnisotropicFiltering, 0, 16);
        spdlog::info("Config Parse: iAnisotropicFiltering value invalid, clamped to {}", iAnisotropicFiltering);
    }
    spdlog::info("Config Parse: bDisableTextureFiltering: {}", bDisableTextureFiltering);
    spdlog::info("Config Parse: bFramebufferFix: {}", bFramebufferFix);

    spdlog::info("Config Parse: bMouseSensitivity: {}", bMouseSensitivity);
    spdlog::info("Config Parse: fMouseSensitivityXMulti: {}", fMouseSensitivityXMulti);
    spdlog::info("Config Parse: fMouseSensitivityYMulti: {}", fMouseSensitivityYMulti);
    spdlog::info("Config Parse: bDisableCursor: {}", bDisableCursor);
    spdlog::info("Config Parse: iTextureBufferSizeMB: {}", iTextureBufferSizeMB); //g_TextureBufferSize

    if (eGameType & (MG|MGS2|MGS3|LAUNCHER))
    {
        if (bDisableCursor)
        {
            // Launcher | MG/MG2 | MGS 2 | MGS 3: Disable mouse cursor
            // Thanks again emoose!
            uint8_t* MGS2_MGS3_MouseCursorScanResult = Memory::PatternScanSilent(baseModule, "BA 00 7F 00 00 33 ?? FF ?? ?? ?? ?? ?? 48 ?? ??");
            if (eGameType & LAUNCHER)
            {
                unityPlayer = GetModuleHandleA("UnityPlayer.dll");
                MGS2_MGS3_MouseCursorScanResult = Memory::PatternScanSilent(unityPlayer, "BA 00 7F 00 00 33 ?? FF ?? ?? ?? ?? ?? 48 ?? ??");
            }

            if (MGS2_MGS3_MouseCursorScanResult)
            {
                if (eGameType & LAUNCHER)
                {
                    spdlog::info("Launcher | MG/MG2 | MGS 2 | MGS 3: Mouse Cursor: Address is {:s}+{:x}", sExeName.c_str(), (uintptr_t)MGS2_MGS3_MouseCursorScanResult - (uintptr_t)unityPlayer);
                }
                else
                {
                    spdlog::info("Launcher | MG/MG2 | MGS 2 | MGS 3: Mouse Cursor: Address is {:s}+{:x}", sExeName.c_str(), (uintptr_t)MGS2_MGS3_MouseCursorScanResult - (uintptr_t)baseModule);
                }
                // The game enters 32512 in the RDX register for the function USER32.LoadCursorA to load IDC_ARROW (normal select arrow in windows)
                // Set this to 0 and no cursor icon is loaded
                Memory::PatchBytes((uintptr_t)MGS2_MGS3_MouseCursorScanResult + 0x2, "\x00", 1);
                spdlog::info("Launcher | MG/MG2 | MGS 2 | MGS 3: Mouse Cursor: Patched instruction.");
            }
            else if (!MGS2_MGS3_MouseCursorScanResult)
            {
                spdlog::error("Launcher | MG/MG2 | MGS 2 | MGS 3: Mouse Cursor: Pattern scan failed.");
            }
        }
    }

    if ((bDisableTextureFiltering || iAnisotropicFiltering > 0) && (eGameType & (MGS2|MGS3)))
    {
        uint8_t* MGS3_SetSamplerStateInsnScanResult = Memory::PatternScanSilent(baseModule, "48 8B ?? ?? ?? ?? ?? 44 39 ?? ?? 38 ?? ?? ?? 74 ?? 44 89 ?? ?? ?? ?? ?? ?? EB ?? 48 ?? ??");
        if (MGS3_SetSamplerStateInsnScanResult)
        {
            spdlog::info("MGS 2 | MGS 3: Texture Filtering: Address is {:s}+{:x}", sExeName.c_str(), (uintptr_t)MGS3_SetSamplerStateInsnScanResult - (uintptr_t)baseModule);

            static SafetyHookMid SetSamplerStateInsnXMidHook{};
            SetSamplerStateInsnXMidHook = safetyhook::create_mid(MGS3_SetSamplerStateInsnScanResult + 0x7,
                [](SafetyHookContext& ctx)
                {
                    // [rcx+rax+0x438] = D3D11_SAMPLER_DESC, +0x14 = MaxAnisotropy
                    *reinterpret_cast<int*>(ctx.ecx + ctx.eax + 0x438 + 0x14) = iAnisotropicFiltering;

                    // Override filter mode in r9d with aniso value and run compare from orig game code
                    // Game code will then copy in r9d & update D3D etc when r9d is different to existing value
                    //0x1 = D3D11_FILTER_MIN_MAG_POINT_MIP_LINEAR (Linear mips is essentially perspective correction.) 0x55 = D3D11_FILTER_ANISOTROPIC
                    ctx.r9 = bDisableTextureFiltering ? 0x1 : 0x55;
                });

        }
        else if (!MGS3_SetSamplerStateInsnScanResult)
        {
            spdlog::error("MGS 2 | MGS 3: Texture Filtering: Pattern scan failed.");
        }
    }

    if (eGameType & MGS3 && bMouseSensitivity)
    {
        // MG 1/2 | MGS 2 | MGS 3: MouseSensitivity
        uint8_t* MGS3_MouseSensitivityScanResult = Memory::PatternScanSilent(baseModule, "F3 0F ?? ?? ?? F3 0F ?? ?? 66 0F ?? ?? ?? 0F ?? ?? 66 0F ?? ?? 8B ?? ??");
        if (MGS3_MouseSensitivityScanResult)
        {
            spdlog::info("MGS 3: Mouse Sensitivity: Address is {:s}+{:x}", sExeName.c_str(), (uintptr_t)MGS3_MouseSensitivityScanResult - (uintptr_t)baseModule);

            static SafetyHookMid MouseSensitivityXMidHook{};
            MouseSensitivityXMidHook = safetyhook::create_mid(MGS3_MouseSensitivityScanResult,
                [](SafetyHookContext& ctx)
                {
                    ctx.xmm0.f32[0] *= fMouseSensitivityXMulti;
                });

            static SafetyHookMid MouseSensitivityYMidHook{};
            MouseSensitivityYMidHook = safetyhook::create_mid(MGS3_MouseSensitivityScanResult + 0x2E,
                [](SafetyHookContext& ctx)
                {
                    ctx.xmm0.f32[0] *= fMouseSensitivityYMulti;
                });
        }
        else if (!MGS3_MouseSensitivityScanResult)
        {
            spdlog::error("MGS 3: Mouse Sensitivity: Pattern scan failed.");
        }
    }
    */

#pragma endregion deadcode

void Init_ReadConfig()
{
    // Initialise config
    std::ifstream iniFile((sExePath / sConfigFile).string());
    if (!iniFile)
    {
        return FreeLibraryAndExitThread(baseModule, 1);
    }
    spdlog::info("Config file: {}", (sExePath / sConfigFile).string());
    ini.parse(iniFile);

    // Grab desktop resolution
    DesktopDimensions = Util::GetPhysicalDesktopDimensions();


    // Read ini file
    g_DistanceCulling.isEnabled = Util::stringToBool(ini.sections["Echelon.EchelonGameInfo"]["bLODDistance"]);
    spdlog::info("Config Parse: Fix LOD Distance: {}", g_DistanceCulling.isEnabled);

    g_IntroSkip.isEnabled = Util::stringToBool(ini.sections["Echelon.EchelonGameInfo"]["bSkipIntroVideos"]);
    spdlog::info("Config Parse: Skip Intro Videos: {}", g_IntroSkip.isEnabled);

    g_PauseOnFocusLoss.shouldPause = Util::stringToBool(ini.sections["Echelon.EchelonGameInfo"]["bPauseOnFocusLoss"]);
    spdlog::info("Config Parse: Pause on Focus Loss: {}", g_PauseOnFocusLoss.shouldPause);

}

// Case-insensitive string comparison helper
static bool iequals(const std::string& a, const std::string& b) {
    return a.size() == b.size() &&
        std::equal(a.begin(), a.end(), b.begin(), [](char a, char b) {
            return std::tolower(static_cast<unsigned char>(a)) == std::tolower(static_cast<unsigned char>(b));
        });
}



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
    INITIALIZE(g_MouseXButtonsSupport.Initialize());
}

void InitializeSubsystems()
{
    INITIALIZE(g_Logging.LogSysInfo());
    INITIALIZE(Init_ASILoaderSanityChecks());
    if (iequals(sExeName, "Splintercell.exe"))
    {
        INITIALIZE(g_GameDLLs.Initialize());
        /* At this point Core, Engine, GeometricEvent, and Window dll's are hooked.
        Things reliant on binkw32, D3DDrv, DareAudio, eax, Echelon, EchelonHUD, EchelonIngredient, EchelonMenus, Editor, SNDdbgV, SNDDSound3DDLL_VBR, SNDext_VBR, UWindow, and WinDrv
        need to be hooked via the above Init functions, as they're loaded after ASI loader finishes everything. */

        INITIALIZE(g_GameVars.Initialize());
        INITIALIZE(Init_ReadConfig()); 
        INITIALIZE(g_CustomSaves.Initialize());
        INITIALIZE(g_IdleTimers.Initialize());
        INITIALIZE(g_DistanceCulling.Initialize());
        INITIALIZE(g_IntroSkip.Initialize());


    }
    else
    {
        spdlog::error("Game not detected. Please ensure you are running the correct game executable.");
    }
}

DWORD __stdcall Main(void*)
{
    g_Logging.initStartTime = std::chrono::high_resolution_clock::now();
    g_Logging.Initialize();
    INITIALIZE(InitializeSubsystems());
    return true;
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
        SetProcessDPIAware();

        HANDLE mainHandle = CreateThread(NULL, 0, Main, 0, CREATE_SUSPENDED, 0);
        if (mainHandle)
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
