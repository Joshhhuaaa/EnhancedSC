#include "stdafx.h"
#include "controller_rumble.hpp"

#include "helper.hpp"
#include "logging.hpp"
#include "hook_dlls.hpp"

#include <Xinput.h>
#pragma comment(lib, "Xinput.lib")


namespace
{
    constexpr float  RUMBLE_MIN_STRENGTH = 0.0f;
    constexpr float  RUMBLE_MAX_STRENGTH = 1.0f;
    constexpr WORD   RUMBLE_MAX_VALUE = 0xFFFF; // 65535, full motor speed

    void UpdateRumble(const float vibrateStrength, const float shakeStrength)
    {
        const WORD left = static_cast<WORD>(std::clamp(vibrateStrength, RUMBLE_MIN_STRENGTH, RUMBLE_MAX_STRENGTH) * RUMBLE_MAX_VALUE); // low freq motor
        const WORD right = static_cast<WORD>(std::clamp(shakeStrength, RUMBLE_MIN_STRENGTH, RUMBLE_MAX_STRENGTH) * RUMBLE_MAX_VALUE); // high freq motor

        static WORD lastLeft = 0;
        static WORD lastRight = 0;

        // Don't spam the HID stack if the values haven't changed
        if (left == lastLeft && right == lastRight)
        {
            return;
        }
        lastLeft = left;
        lastRight = right;

        XINPUT_VIBRATION vib = { left, right };
        XInputSetState(0, &vib);
    }
}



void ControllerRumble::Fix()
{
    if (!g_ControllerRumble.bEnabled)
    {
        return;
    }
    
    MAKE_HOOK_MID(g_GameDLLs.Engine, "5F 89 4C 24", "Intercept APlayerController::UpdateRumble(float strength)", {
        UpdateRumble(std::bit_cast<float>(ctx.ecx), std::bit_cast<float>(ctx.edx));
        });

}
