#include "stdafx.h"
#include "restore_eax.hpp"
#include "common.hpp"
#include "logging.hpp"


void RestoreEAX::Initialize()
{
    if (uint8_t* SkeletalLODResult = Memory::PatternScan(baseModule, "FF 92 ?? ?? ?? ?? 89 85", "Restore EAX"))
    {
        Memory::PatchBytes(reinterpret_cast<uintptr_t>(SkeletalLODResult), "\xFF\x92\x20", 3);
        spdlog::info("Restore EAX: Patched instruction.");
    }

}
