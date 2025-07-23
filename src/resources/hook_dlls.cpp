#include "hook_dlls.hpp"
#include "callbacks.h"
#include "logging.hpp"
#include "submodule_initiailization.hpp"

extern void Initbinw32();
extern void InitD3DDrv();
extern void InitDareAudio();
extern void Initeax();
extern void InitEchelon();
extern void InitEchelonHUD();
extern void InitEchelonIngredient();
extern void InitEchelonMenus();
extern void InitEditor();
extern void InitSNDdbgV();
extern void InitSNDDSound3DDLL_VBR();
extern void InitSNDext_VBR();
extern void InitUWindow();
extern void InitWinDrv();


static void Hookbinw32()
{
    g_GameDLLs.binkw32 = GetModuleHandleA("binkw32.dll");
    if (!g_GameDLLs.binkw32)
    {
        spdlog::error("GameDLLs: binkw32.dll failed to load.");
        return;
    }
    INITIALIZEDLL(Initbinw32());
}

static void HookD3DDrv()
{
    g_GameDLLs.D3DDrv = GetModuleHandleA("D3DDrv.dll");
    if (!g_GameDLLs.D3DDrv)
    {
        spdlog::error("GameDLLs: D3DDrv.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitD3DDrv());
}

static void HookDareAudio()
{
    g_GameDLLs.DareAudio = GetModuleHandleA("DareAudio.dll");
    if (!g_GameDLLs.DareAudio)
    {
        spdlog::error("GameDLLs: DareAudio.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitDareAudio());
}

static void Hookeax()
{
    g_GameDLLs.eax = GetModuleHandleA("eax.dll");
    if (!g_GameDLLs.eax)
    {
        spdlog::error("GameDLLs: eax.dll failed to load.");
        return;
    }
    INITIALIZEDLL(Initeax());
}

static void HookEchelon()
{
    g_GameDLLs.Echelon = GetModuleHandleA("Echelon.dll");
    if (!g_GameDLLs.Echelon)
    {
        spdlog::error("GameDLLs: Echelon.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitEchelon());
}

static void HookEchelonHUD()
{
    g_GameDLLs.EchelonHUD = GetModuleHandleA("EchelonHUD.dll");
    if (!g_GameDLLs.EchelonHUD)
    {
        spdlog::error("GameDLLs: EchelonHUD.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitEchelonHUD());
}

static void HookEchelonIngredient()
{
    g_GameDLLs.EchelonIngredient = GetModuleHandleA("EchelonIngredient.dll");
    if (!g_GameDLLs.EchelonIngredient)
    {
        spdlog::error("GameDLLs: EchelonIngredient.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitEchelonIngredient());
}

static void HookEchelonMenus()
{
    g_GameDLLs.EchelonMenus = GetModuleHandleA("EchelonMenus.dll");
    if (!g_GameDLLs.EchelonMenus)
    {
        spdlog::error("GameDLLs: EchelonMenus.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitEchelonMenus());
}
static void HookEditor()
{
    g_GameDLLs.Editor = GetModuleHandleA("Editor.dll");
    if (!g_GameDLLs.Editor)
    {
        spdlog::error("GameDLLs: Editor.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitEditor());
}

static void HookSNDdbgV()
{
    g_GameDLLs.SNDdbgV = GetModuleHandleA("SNDdbgV.dll");
    if (!g_GameDLLs.SNDdbgV)
    {
        spdlog::error("GameDLLs: SNDdbgV.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitSNDdbgV());
}

static void HookSNDDSound3DDLL_VBR()
{
    g_GameDLLs.SNDDSound3DDLL_VBR = GetModuleHandleA("SNDDSound3DDLL_VBR.dll");
    if (!g_GameDLLs.SNDDSound3DDLL_VBR)
    {
        spdlog::error("GameDLLs: SNDDSound3DDLL_VBR.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitSNDDSound3DDLL_VBR());
}

static void HookSNDext_VBR()
{
    g_GameDLLs.SNDext_VBR = GetModuleHandleA("SNDext_VBR.dll");
    if (!g_GameDLLs.SNDext_VBR)
    {
        spdlog::error("GameDLLs: SNDext_VBR.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitSNDext_VBR());
}

static void HookUWindow()
{
    g_GameDLLs.UWindow = GetModuleHandleA("UWindow.dll");
    if (!g_GameDLLs.UWindow)
    {
        spdlog::error("GameDLLs: UWindow.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitUWindow());
}

static void HookWinDrv()
{
    g_GameDLLs.WinDrv = GetModuleHandleA("WinDrv.dll");
    if (!g_GameDLLs.WinDrv)
    {
        spdlog::error("GameDLLs: WinDrv.dll failed to load.");
        return;
    }
    INITIALIZEDLL(InitWinDrv());
}

void GameDLLs::Initialize()
{
// Initialize all game DLL module handles to nullptr
    // Load game DLLs
    if ((Core = GetModuleHandleA("Core.dll")) == nullptr) spdlog::error("GameDLLs: Core.dll failed to load.");
    if ((Engine = GetModuleHandleA("Engine.dll")) == nullptr) spdlog::error("GameDLLs: Engine.dll failed to load.");
    if ((GeometricEvent = GetModuleHandleA("GeometricEvent.dll")) == nullptr) spdlog::error("GameDLLs: GeometricEvent.dll failed to load.");
    if ((Window = GetModuleHandleA("Window.dll")) == nullptr) spdlog::error("GameDLLs: Window.dll failed to load.");


    std::call_once(CallbackHandler::flag, []()
        {
            CallbackHandler::RegisterCallback(L"binkw32.dll", Hookbinw32);
            CallbackHandler::RegisterCallback(L"D3DDrv.dll", HookD3DDrv);
            CallbackHandler::RegisterCallback(L"DareAudio.dll", HookDareAudio);
            CallbackHandler::RegisterCallback(L"eax.dll", Hookeax);
            CallbackHandler::RegisterCallback(L"Echelon.dll", HookEchelon);
            CallbackHandler::RegisterCallback(L"EchelonHUD.dll", HookEchelonHUD);
            CallbackHandler::RegisterCallback(L"EchelonIngredient.dll", HookEchelonIngredient);
            CallbackHandler::RegisterCallback(L"Editor.dll", HookEditor);
            CallbackHandler::RegisterCallback(L"SNDdbgV.dll", HookSNDdbgV);
            CallbackHandler::RegisterCallback(L"SNDDSound3DDLL_VBR.dll", HookSNDDSound3DDLL_VBR);
            CallbackHandler::RegisterCallback(L"UWindow.dll", HookUWindow);
            CallbackHandler::RegisterCallback(L"WinDrv.dll", HookWinDrv);
            CallbackHandler::RegisterCallback(L"EchelonMenus.dll", HookEchelonMenus);
            CallbackHandler::RegisterCallback(L"SNDext_VBR.dll", HookSNDext_VBR);
        });
    spdlog::info("GameDLLs: All hooks registered.");
}
