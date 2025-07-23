#include "idle_timers.hpp"

#include <spdlog/spdlog.h>
#include "helper.hpp"
#include "hook_dlls.hpp"


void IdleTimers::Initialize()
{

    if (uint8_t* IdleTimerResult = Memory::PatternScan(g_GameDLLs.Engine, "DF E0 25 ?? ?? ?? ?? 75 ?? A1", "Idle Timer"))
    {
        static SafetyHookMid IdleTimerHook;
        IdleTimerHook = safetyhook::create_mid(IdleTimerResult, [](SafetyHookContext& ctx)
            {
                // After fnstsw ax, eax contains the FPU status word in ax.
                // The next instruction is: and eax, 4100h
                // To force the jump, set eax to any nonzero value with 0x4100 bits set.
                ctx.eax = 0x4100;
                spdlog::info("Idle Timer: Idle timer override applied.");
            });
        LOG_HOOK(IdleTimerHook, "Idle Timer");
    }
}
