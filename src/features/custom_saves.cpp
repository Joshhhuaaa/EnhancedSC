#include "custom_saves.hpp"
#include <spdlog/spdlog.h>

#include "helper.hpp"
#include "hook_dlls.hpp"

void CustomSaves::Initialize()
{

    if (uint8_t* SaveFormat = Memory::PatternScan(g_GameDLLs.Engine, "2E 00 73 00 61 00 76 00 00 00", "Save Format"))
    {
        Memory::PatchBytes((uintptr_t)SaveFormat, "\x2E\x00\x65\x00\x6E\x00\x31\x00", 8);
        spdlog::info("Save Format patched successfully.");
    }
}
