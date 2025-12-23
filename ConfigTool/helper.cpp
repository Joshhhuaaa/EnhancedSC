#include "pch.h"
#include "helper.hpp"
#include <wx/filefn.h>
#include <wx/log.h>


namespace Helper
{
    std::filesystem::path FindASILocation(std::string fileName)
    {
        static const std::array<std::string, 4> paths = { "", "plugins", "scripts", "update" };

        std::filesystem::path base = wxGetCwd().ToStdString();

        for (const auto& p : paths)
        {
            std::filesystem::path filePath = base / p / (fileName + ".asi");
            if (std::filesystem::exists(filePath))
            {
                return filePath.parent_path();
            }
        }
        wxLogError("Unable to locate %s.asi in %s and the other supported ASI directories.", fileName, wxGetCwd());
        return {};
    }

    static std::vector<int> parseVersionString(const std::string& versionStr)
    {
        std::vector<int> parts;
        std::istringstream ss(versionStr);
        std::string token;

        while (std::getline(ss, token, '.'))
        {
            if (token.empty())
            {
                parts.push_back(0);
                {
                    continue;
                }
            }

            size_t i = 0;
            while (i < token.size() && std::isdigit(static_cast<unsigned char>(token[i])))
                ++i;

            int value = (i > 0) ? std::stoi(token.substr(0, i)) : 0;
            parts.push_back(value);

            if (i < token.size())
            {
                // take first suffix letter -> 'a' = 1, 'b' = 2, etc.
                char c = static_cast<char>(std::tolower(token[i]));
                if (c >= 'a' && c <= 'z')
                {
                    parts.push_back((c - 'a') + 1);
                }
                else
                {
                    parts.push_back(1); // fallback for weird suffix
                }
            }
        }

        return parts;
    }

    VersionCompareResult CompareSemanticVersion(const std::string& currentVersion,
        const std::string& targetVersion)
    {
        std::vector<int> currentParts = parseVersionString(currentVersion);
        std::vector<int> targetParts = parseVersionString(targetVersion);

        size_t n = std::max(currentParts.size(), targetParts.size());
        currentParts.resize(n, 0);
        targetParts.resize(n, 0);

        for (size_t i = 0; i < n; ++i)
        {
            if (currentParts[i] < targetParts[i])
            {
                return VersionCompareResult::Older;
            }
            if (currentParts[i] > targetParts[i])
            {
                return VersionCompareResult::Newer;
            }
        }
        return VersionCompareResult::Equal;
    }

    std::string GetFileDescription(const std::string& filePath)
    {
        DWORD handle = 0;
        DWORD size = GetFileVersionInfoSizeA(filePath.c_str(), &handle);
        if (size > 0)
        {
            std::vector<BYTE> versionInfo(size);
            if (GetFileVersionInfoA(filePath.c_str(), handle, size, versionInfo.data()))
            {
                void* buffer = nullptr;
                UINT sizeBuffer = 0;
                if (VerQueryValueA(versionInfo.data(), R"(\VarFileInfo\Translation)", &buffer, &sizeBuffer))
                {
                    auto translations = static_cast<WORD*>(buffer);
                    size_t translationCount = sizeBuffer / sizeof(WORD) / 2; // Each translation is two WORDs (language and code page)
                    for (size_t i = 0; i < translationCount; ++i)
                    {
                        WORD language = translations[i * 2];
                        WORD codePage = translations[i * 2 + 1];
                        // Construct the query string for the file description
                        std::ostringstream subBlock;
                        subBlock << R"(\StringFileInfo\)" << std::hex << std::setw(4) << std::setfill('0') << language
                            << std::setw(4) << std::setfill('0') << codePage << R"(\ProductName)";
                        if (VerQueryValueA(versionInfo.data(), subBlock.str().c_str(), &buffer, &sizeBuffer))
                        {
                            return std::string(static_cast<char*>(buffer), sizeBuffer - 1);
                        }
                    }
                }
            }
        }
        return "File description not found.";
    }

    bool IsSteamOS()
    {
        static bool bCheckedSteamDeck = false;
        static bool bIsSteamDeck = false;
        if (bCheckedSteamDeck)
        {
            return bIsSteamDeck;
        }
        bCheckedSteamDeck = true;
        // Check for Proton/Steam Deck environment variables
        if (std::getenv("STEAM_COMPAT_CLIENT_INSTALL_PATH") || std::getenv("STEAM_COMPAT_DATA_PATH") || std::getenv("XDG_SESSION_TYPE"))
        {
            bIsSteamDeck = true;
        }
        return bIsSteamDeck;
    }
}
