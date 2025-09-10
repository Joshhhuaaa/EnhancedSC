#include "stdafx.h"
#include "common.hpp"
#include "logging.hpp"
#include "intro_skip.hpp"

#include "hook_dlls.hpp"

void IntroSkip::Initialize() const
{
    if (!isEnabled)
    {
        return;
    }

    if (uint8_t* IntroSkipScan2 = Memory::PatternScan(g_GameDLLs.Engine, "39 3D ?? ?? ?? ?? 75 ?? 39 3D", "Skip Intro Videos"))
    {
        static SafetyHookMid Initialization3 {};
        Initialization3 = safetyhook::create_mid(IntroSkipScan2,
            [](SafetyHookContext& ctx)
            {
                ctx.edi = 1;
                spdlog::info("Intro movies skipped!");
            });

    }

    if (uint8_t* IntroSkipScan = Memory::PatternScan(g_GameDLLs.Engine, "E8 ?? ?? ?? ?? 6A ?? 6A ?? 68 ?? ?? ?? ?? 56", "Skip Intro Videos (Idle Replay)"))
    {
        Memory::PatchBytes((uintptr_t)IntroSkipScan, "\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90", 20);
    }

}
