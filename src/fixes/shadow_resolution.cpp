#include "shadow_resolution.hpp"
#include <spdlog/spdlog.h>
#include "common.hpp"
#include "hook_dlls.hpp"


void ShadowResolution::Initialize() const
{
    if (!isEnabled)
    {
        spdlog::info("Shadow Resolution feature is config disabled.");
        return;
    }
    if (uint8_t* SkeletalLODResult = Memory::PatternScan(g_GameDLLs.Engine, "A1 ?? ?? ?? ?? 8B 08 8A 41", "Skeletal LOD"))
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
