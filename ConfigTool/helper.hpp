#pragma once
#include <filesystem>
#include <string>

namespace Helper
{
    std::filesystem::path FindASILocation(std::string fileName);


    enum class VersionCompareResult
    {
        Older = -1,
        Equal = 0,
        Newer = 1
    };

    // Compare two semantic-style version strings (e.g. "32.0.15.8130" vs "32.0.15.9000")
    VersionCompareResult CompareSemanticVersion(const std::string& currentVersion, const std::string& targetVersion);

    std::string GetFileDescription(const std::string& filePath);

    [[nodiscard]] bool IsSteamOS();

}
