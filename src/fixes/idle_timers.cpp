#include "stdafx.h"
#include "idle_timers.hpp"

#include "helper.hpp"
#include "hook_dlls.hpp"
#include "logging.hpp"


void IdleTimers::Initialize()
{
    if (!g_IdleTimers.bDisableIdleTimer)
    {
        return;
    }
    spdlog::info("IdleTimers: Initializing...");

    if (uint8_t* IdleTimerResult = Memory::PatternScan(g_GameDLLs.EchelonHUD, "D8 1D ?? ?? ?? ?? DF E0 25 ?? ?? ?? ?? 75 ?? A1", "Demo Timer"))
    {
        uintptr_t baseAddress = reinterpret_cast<uintptr_t>(g_GameDLLs.EchelonHUD);
        float* target = reinterpret_cast<float*>(baseAddress + 0x3D8A4);
        DWORD oldProtect;
        VirtualProtect(target, sizeof(float), PAGE_EXECUTE_READWRITE, &oldProtect);
        *target = std::numeric_limits<float>::max();
        VirtualProtect(target, sizeof(float), oldProtect, &oldProtect);
        spdlog::info("IdleTimers: Patched demo idle timer.");
    }
}
