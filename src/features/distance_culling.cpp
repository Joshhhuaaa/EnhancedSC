#include "stdafx.h"
#include "distance_culling.hpp"
#include "common.hpp"
#include "hook_dlls.hpp"
#include "logging.hpp"


void DistanceCulling::Initialize() const
{
    if (!isEnabled)
    {
        spdlog::info("Distance Culling: Feature is disabled in config.");
        return;
    }
    if (uint8_t* SkeletalLODResult = Memory::PatternScan(g_GameDLLs.Engine, "A8 ?? 0F 84 ?? ?? ?? ?? A8 ?? 0F 85 ?? ?? ?? ?? 83 F9", "Skeletal LOD"))
    {
        
        static SafetyHookMid SkeletalLODMidHook {};
        SkeletalLODMidHook = safetyhook::create_mid(SkeletalLODResult,
            [](SafetyHookContext& ctx)
            {
                ctx.ecx = 0xA;
            });
        LOG_HOOK(SkeletalLODMidHook, "Skeletal LOD")
    }

}
