#pragma once
#if !defined(_CRT_SECURE_NO_WARNINGS)
#define _CRT_SECURE_NO_WARNINGS
#endif

namespace ConfigKeys
{
    constexpr const char* DistanceCulling_Section = "Graphics";
    constexpr const char* DistanceCulling_Setting = "Fix LOD Distance";

    constexpr const char* EnablePauseOnFocusLoss_Section = "Various";
    constexpr const char* EnablePauseOnFocusLoss_Setting = "Pause On Focus Loss";

    // Tweaks
    constexpr const char* SkipIntroLogos_Section = "Various";
    constexpr const char* SkipIntroLogos_Setting = "Skip Intro Videos";

    // Tweaks
    constexpr const char* DisableMenuIdleTimers_Section = "Various";
    constexpr const char* DisableMenuIdleTimers_Setting = "Disable Menu Idle Timers";

    constexpr const char* UseXboxFonts_Section = "Various";
    constexpr const char* UseXboxFonts_Setting = "Use Xbox Fonts";

    constexpr const char* EnableRumble_Section = "Various";
    constexpr const char* EnableRumble_Setting = "Enable Controller Rumble";

    // Internal
    constexpr const char* CheckForUpdates_Section = "Update Notifications";
    constexpr const char* CheckForUpdates_Setting = "Check For EnhancedSC Updates";

    constexpr const char* VerboseLogging_Section = "Internal Settings";
    constexpr const char* VerboseLogging_Setting = "Debug Logging";

    // Warnings
    constexpr const char* WarnReadOnlyINIFiles_Section = "Warnings";
    constexpr const char* WarnReadOnlyINIFiles_Setting = "Check for read-only INI files.";

}
