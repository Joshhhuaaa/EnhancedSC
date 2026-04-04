#include "stdafx.h"
#include "common.hpp"
#include "config.hpp"

#include <inipp/inipp.h>

#include "check_gamesave_folder.hpp"
#include "logging.hpp"
#include "version_checker.hpp"
#include "config_keys.hpp"

#include "intro_skip.hpp"
#include "distance_culling.hpp"
#include "idle_timers.hpp"
#include "controller_rumble.hpp"
#include "ini_read_state.hpp"
#include "suppress_error_dialogs.hpp"

// -----------------------------------------------------------------------------
// ConfigHelper: A type-safe, case-insensitive, error-checked INI config reader.
// Automatically logs missing/invalid values and exits the thread immediately.
// By Afevis/ShizCalev, 2025.
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Config Logger: caches config values for sorted flush at the end
// -----------------------------------------------------------------------------
namespace ConfigLogger
{
    inline std::map<std::string, std::map<std::string, std::string>> cache;

    template <typename T>
    void Cache(const char* section, const char* setting, const T& value)
    {
        cache[section][setting] = fmt::format("{}", value);
    }

    void Flush()
    {
        spdlog::info("---------- Config Parse Results ----------");
        for (auto& sec : cache)
        {
            spdlog::info("[{}]", sec.first);
            for (auto& kv : sec.second)
            {
                spdlog::info("    {} = {}", kv.first, kv.second);
            }
        }
        spdlog::info("---------- End Config Parse ----------");
    }
}

#define LOG_CONFIG(section, setting, value) \
    ConfigLogger::Cache(section, setting, value)

/*
namespace ConfigHelper
{
    inline void FatalConfigError(const std::string& section, const std::string& key, const std::string& reason)
    {
        std::string message = "[" + sFixName + " Config Helper] Failed to read config key '" + key +
            "' in section '" + section + "': " + reason;

        spdlog::error(message);
        spdlog::error("Please run the {} to update your settings file.", sFixName + " Config Tool");
        Logging::ShowConsole();
        std::cout << message << std::endl;
        std::cout << "Please run the " << sFixName + " Config Tool" << " to update your settings file." << std::endl;

        FreeLibraryAndExitThread(baseModule, 1);
    }

    /// Internal parsing helper
    template <typename T>
    bool TryParse(const std::string& str, T& out)
    {
        std::istringstream iss(str);
        return (iss >> std::boolalpha >> out) ? true : false;
    }

    /// Parses bool values with case-insensitivity and common boolean strings
    template <>
    inline bool TryParse<bool>(const std::string& str, bool& out)
    {
        std::string val = str;
        std::transform(val.begin(), val.end(), val.begin(), ::tolower);
        if (val == "1" || val == "true" || val == "yes" || val == "on")
        {
            out = true;
            return true;
        }
        if (val == "0" || val == "false" || val == "no" || val == "off")
        {
            out = false;
            return true;
        }
        return false;
    }

    /// Generic value loader from INI with hard error on failure
    template <typename T>
    void getValue(const inipp::Ini<char>& ini, const std::string& section, const std::string& key, T& out)
    {
        auto secIt = ini.sections.find(section);
        if (secIt == ini.sections.end())
            FatalConfigError(section, key, "Section not found");

        const auto& keyvals = secIt->second;
        auto keyIt = keyvals.find(key);
        if (keyIt == keyvals.end())
            FatalConfigError(section, key, "Key not found");

        if (!TryParse<T>(keyIt->second, out))
            FatalConfigError(section, key, "Failed to parse value '" + keyIt->second + "'");
    }

    /// Specialization for std::string values (handles quotes)
    template <>
    inline void getValue<std::string>(const inipp::Ini<char>& ini, const std::string& section, const std::string& key, std::string& out)
    {
        auto secIt = ini.sections.find(section);
        if (secIt == ini.sections.end())
            FatalConfigError(section, key, "Section not found");

        const auto& keyvals = secIt->second;
        auto keyIt = keyvals.find(key);
        if (keyIt == keyvals.end())
            FatalConfigError(section, key, "Key not found");

        out = Util::StripQuotes(keyIt->second);
    }
}
*/

// Joshua - ConfigHelper now inserts missing keys with defaults and writes
// them back to the INI file, instead of fatally exiting.
namespace ConfigHelper
{
    // Tracks whether any missing keys were inserted so we can write the INI back
    inline bool bDirtyConfig = false;

    /// Internal parsing helper
    template <typename T>
    bool TryParse(const std::string& str, T& out)
    {
        std::istringstream iss(str);
        return (iss >> std::boolalpha >> out) ? true : false;
    }

    /// Parses bool values with case-insensitivity and common boolean strings
    template <>
    inline bool TryParse<bool>(const std::string& str, bool& out)
    {
        std::string val = str;
        std::transform(val.begin(), val.end(), val.begin(), ::tolower);
        if (val == "1" || val == "true" || val == "yes" || val == "on")
        {
            out = true;
            return true;
        }
        if (val == "0" || val == "false" || val == "no" || val == "off")
        {
            out = false;
            return true;
        }
        return false;
    }

    /// Converts a value to its INI string representation
    template <typename T>
    std::string ToIniString(const T& value)
    {
        std::ostringstream oss;
        oss << value;
        return oss.str();
    }

    template <>
    inline std::string ToIniString<bool>(const bool& value)
    {
        return value ? "True" : "False"; // Joshua - Write as "True"/"False" to match UE2 casing
    }

    /// Generic value loader from INI. If the section or key is missing, inserts the
    /// default value into the ini and logs a warning instead of fatally exiting.
    template <typename T>
    void getValue(inipp::Ini<char>& ini, const std::string& section, const std::string& key, T& out, const T& defaultValue)
    {
        auto& sec = ini.sections[section]; // creates section if missing

        auto keyIt = sec.find(key);
        if (keyIt == sec.end())
        {
            // Key not found — insert default
            out = defaultValue;
            sec[key] = ToIniString(defaultValue);
            bDirtyConfig = true;
            spdlog::warn("[Config] Missing key '{}' in section '{}'. Using default: {}", key, section, ToIniString(defaultValue));
            return;
        }

        if (!TryParse<T>(keyIt->second, out))
        {
            // Parse failed — use default
            out = defaultValue;
            sec[key] = ToIniString(defaultValue);
            bDirtyConfig = true;
            spdlog::warn("[Config] Failed to parse key '{}' in section '{}' (value: '{}'). Using default: {}", key, section, keyIt->second, ToIniString(defaultValue));
        }
    }

    /// Specialization for std::string values (handles quotes)
    template <>
    inline void getValue<std::string>(inipp::Ini<char>& ini, const std::string& section, const std::string& key, std::string& out, const std::string& defaultValue)
    {
        auto& sec = ini.sections[section]; // creates section if missing

        auto keyIt = sec.find(key);
        if (keyIt == sec.end())
        {
            out = defaultValue;
            sec[key] = defaultValue;
            bDirtyConfig = true;
            spdlog::warn("[Config] Missing key '{}' in section '{}'. Using default: {}", key, section, defaultValue);
            return;
        }

        out = Util::StripQuotes(keyIt->second);
    }

    /// Writes the INI back to disk if any defaults were inserted
    void WriteBackIfDirty(const inipp::Ini<char>& ini, const std::filesystem::path& configPath)
    {
        if (!bDirtyConfig)
            return;

        std::ofstream outFile(configPath);
        if (!outFile)
        {
            spdlog::error("[Config] Could not write updated config to '{}'. Missing keys were applied in-memory only.", configPath.string());
            return;
        }

        ini.generate(outFile);
        spdlog::info("[Config] Updated config written to '{}' with missing default values.", configPath.string());
    }
}


void Config::Read()
{
    std::filesystem::path pConfigFile = sExePath / "Enhanced.ini";

    std::ifstream iniFile(pConfigFile.string());
    if (!iniFile)
    {
        spdlog::error("Error opening ini file {}.", pConfigFile.string());
        Logging::ShowConsole();
        std::cout << "Error opening ini file " << pConfigFile.string() << "." << std::endl;
        return FreeLibraryAndExitThread(baseModule, 1);
    }

    spdlog::info("Config file: {}", pConfigFile.string());

    inipp::Ini<char> ini;
    ini.parse(iniFile);
    // Joshua - Duplicate keys (like EditPackages=value1, EditPackages=value2 in SplinterCell.ini) are valid for array configs
    // Commenting out error logging to avoid false warnings
    /*
    if (!ini.errors.empty())
    {
        spdlog::error("Error parsing ini file, encountered {} errors:", ini.errors.size());
        Logging::ShowConsole();
        for (auto err : ini.errors)
        {
            spdlog::error(err);
            std::cout << err << std::endl;
        }
    }
    */

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bDisableMenuIdleTimer", g_IdleTimers.bDisableIdleTimer, false);
    LOG_CONFIG(ConfigKeys::DisableMenuIdleTimers_Section, ConfigKeys::DisableMenuIdleTimers_Setting, g_IdleTimers.bDisableIdleTimer);

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bLODDistance", g_DistanceCulling.isEnabled, true);
    LOG_CONFIG(ConfigKeys::DistanceCulling_Section, ConfigKeys::DistanceCulling_Setting, g_DistanceCulling.isEnabled);

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bSkipIntroVideos", g_IntroSkip.isEnabled, false);
    LOG_CONFIG(ConfigKeys::SkipIntroLogos_Section, ConfigKeys::SkipIntroLogos_Setting, g_IntroSkip.isEnabled);

    /*ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bPauseOnFocusLoss", g_PauseOnFocusLoss.shouldPause);
    LOG_CONFIG(ConfigKeys::EnablePauseOnFocusLoss_Section, ConfigKeys::EnablePauseOnFocusLoss_Setting, g_PauseOnFocusLoss.shouldPause);*/

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bEnableRumble", g_ControllerRumble.bEnabled, true);
    LOG_CONFIG(ConfigKeys::EnableRumble_Section, ConfigKeys::EnableRumble_Setting, g_ControllerRumble.bEnabled);

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bShowErrors", SuppressErrorDialogs::bShowErrors, false);
    LOG_CONFIG(ConfigKeys::ShowErrors_Section, ConfigKeys::ShowErrors_Setting, SuppressErrorDialogs::bShowErrors);

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bCheckForUpdates", bShouldCheckForUpdates, true);
    LOG_CONFIG(ConfigKeys::CheckForUpdates_Section, ConfigKeys::CheckForUpdates_Setting, bShouldCheckForUpdates);

    bConsoleUpdateNotifications = bShouldCheckForUpdates;

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bWarnReadOnlyInis", CheckINIReadPermissions::Enabled, true);
    LOG_CONFIG(ConfigKeys::WarnReadOnlyINIFiles_Section, ConfigKeys::WarnReadOnlyINIFiles_Setting, CheckINIReadPermissions::Enabled);

    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bWarnReadOnlySaveFiles", CheckGamesaveFolderWritable::CheckSaveFiles, true);
    LOG_CONFIG(ConfigKeys::WarnReadOnlySaveFiles_Section, ConfigKeys::WarnReadOnlySaveFiles_Setting, CheckGamesaveFolderWritable::CheckSaveFiles);

    bool bSteamDeckMode = false;
    ConfigHelper::getValue(ini, "Echelon.EchelonGameInfo", "bSteamDeckMode", bSteamDeckMode, false); // Not actually used, just to verify config key exists.


    ConfigLogger::Flush();

    // Write back any missing keys that were filled in with defaults
    ConfigHelper::WriteBackIfDirty(ini, pConfigFile);
}
