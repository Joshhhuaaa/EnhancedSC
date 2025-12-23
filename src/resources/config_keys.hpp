#pragma once
#if !defined(_CRT_SECURE_NO_WARNINGS)
#define _CRT_SECURE_NO_WARNINGS
#endif

namespace ConfigKeys
{
    // INI Section used by Enhanced.ini
    constexpr const char* IniSection = "Echelon.EchelonGameInfo";

    // Graphics
    constexpr const char* DistanceCulling_Section = "Graphics";
    constexpr const char* DistanceCulling_Setting = "Fix LOD Distance";
    constexpr const char* DistanceCulling_IniKey = "bLODDistance";
    constexpr const char* DistanceCulling_Help = "";
    constexpr const char* DistanceCulling_Tooltip = "Disables LOD bias, ensuring models render at full quality at all distances without popping in or out.";

    // Various
    constexpr const char* EnablePauseOnFocusLoss_Section = "Various";
    constexpr const char* EnablePauseOnFocusLoss_Setting = "Pause On Focus Loss";
    constexpr const char* EnablePauseOnFocusLoss_IniKey = "bPauseOnFocusLoss";
    constexpr const char* EnablePauseOnFocusLoss_Help = "";
    constexpr const char* EnablePauseOnFocusLoss_Tooltip = "Pauses the game when the window loses focus (alt-tabbed).";

    constexpr const char* SkipIntroLogos_Section = "Various";
    constexpr const char* SkipIntroLogos_Setting = "Skip Intro Videos";
    constexpr const char* SkipIntroLogos_IniKey = "bSkipIntroVideos";
    constexpr const char* SkipIntroLogos_Help = "";
    constexpr const char* SkipIntroLogos_Tooltip = "Skips the Ubisoft logo and intro video on startup.";

    constexpr const char* DisableMenuIdleTimers_Section = "Various";
    constexpr const char* DisableMenuIdleTimers_Setting = "Disable Inactivity Videos";
    constexpr const char* DisableMenuIdleTimers_IniKey = "bDisableMenuIdleTimer";
    constexpr const char* DisableMenuIdleTimers_Help = "";
    constexpr const char* DisableMenuIdleTimers_Tooltip = "Disables the idle timer in the main menu, preventing demo videos from playing after a period of inactivity.";

    constexpr const char* EnableRumble_Section = "Various";
    constexpr const char* EnableRumble_Setting = "Enable Controller Vibration";
    constexpr const char* EnableRumble_IniKey = "bEnableRumble";
    constexpr const char* EnableRumble_Help = "";
    constexpr const char* EnableRumble_Tooltip = "Enables controller vibration support.";

    // Update Notifications
    constexpr const char* CheckForUpdates_Section = "Update Notifications";
    constexpr const char* CheckForUpdates_Setting = "Check For EnhancedSC Updates";
    constexpr const char* CheckForUpdates_IniKey = "bCheckForUpdates";
    constexpr const char* CheckForUpdates_Help = "";
    constexpr const char* CheckForUpdates_Tooltip = "If EnhancedSC should notify you when launching the game if a new update is available for download.";

    // Internal Settings
    constexpr const char* VerboseLogging_Section = "Internal Settings";
    constexpr const char* VerboseLogging_Setting = "Debug Logging";
    constexpr const char* VerboseLogging_IniKey = "bVerboseLogging";
    constexpr const char* VerboseLogging_Help = "";
    constexpr const char* VerboseLogging_Tooltip = "Enables verbose logging for debugging purposes.";

    // Warnings
    constexpr const char* WarnReadOnlyINIFiles_Section = "Warnings";
    constexpr const char* WarnReadOnlyINIFiles_Setting = "Check for read-only INI files.";
    constexpr const char* WarnReadOnlyINIFiles_IniKey = "bWarnReadOnlyInis";
    constexpr const char* WarnReadOnlyINIFiles_Help = "";
    constexpr const char* WarnReadOnlyINIFiles_Tooltip = "Warns if INI configuration files are set to read-only, which would prevent saving changes.";

    constexpr const char* WarnReadOnlySaveFiles_Section = "Warnings";
    constexpr const char* WarnReadOnlySaveFiles_Setting = "Check for read-only gamesave files.";
    constexpr const char* WarnReadOnlySaveFiles_IniKey = "bWarnReadOnlySaveFiles";
    constexpr const char* WarnReadOnlySaveFiles_Help = "";
    constexpr const char* WarnReadOnlySaveFiles_Tooltip = "Warns if saved game files are set to read-only, which would prevent saving progress.";

}
