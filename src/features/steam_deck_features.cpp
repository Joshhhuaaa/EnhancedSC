#include "stdafx.h"
#include "steam_deck_features.hpp"

#include "common.hpp"
#include "logging.hpp"

namespace
{
    void UpdateSteamDeckINIVar()
    {
        spdlog::info("Syncing bSteamDeckMode in Enhanced.ini");
        std::filesystem::path SplinterCellUserIni = sExePath / "Enhanced.ini";
        if (!std::filesystem::exists(SplinterCellUserIni))
        {
            spdlog::warn("SplinterCellUser.ini not found!");
            return;
        }

        std::ifstream iniFile(SplinterCellUserIni.string());
        if (!iniFile)
        {
            spdlog::error("Error opening ini file {}.", SplinterCellUserIni.string());
            return;
        }

        std::vector<std::string> lines;
        std::string line;
        while (std::getline(iniFile, line))
        {
            lines.push_back(line);
        }
        iniFile.close();

        constexpr const char* SectionHeader = "[Echelon.EchelonGameInfo]";
        const char* DesiredSetting = Util::IsSteamOS() ? "bSteamDeckMode=True" : "bSteamDeckMode=False";

        bool insideSection = false;
        bool foundSetting = false;
        bool modified = false;
        size_t insertPos = lines.size();

        for (size_t i = 0; i < lines.size(); i++)
        {
            std::string& current = lines[i];
            if (current == SectionHeader)
            {
                insideSection = true;
                insertPos = i + 1;
                continue;
            }

            if (insideSection && !current.empty() && current[0] == '[')
            {
                insideSection = false;
            }

            if (insideSection)
            {
                if (current.find("bSteamDeckMode") == 0)
                {
                    if (current != DesiredSetting)
                    {
                        current = DesiredSetting;
                        modified = true;
                    }
                    foundSetting = true;
                }
            }
        }

        if (!foundSetting && insertPos < lines.size())
        {
            lines.insert(lines.begin() + insertPos, DesiredSetting);
            modified = true;
        }

        if (modified)
        {
            std::filesystem::path tmpPath = SplinterCellUserIni;
            tmpPath += ".tmp";

            if (std::filesystem::exists(tmpPath))
            {
                std::filesystem::remove(tmpPath);
            }

            std::ofstream outFile(tmpPath, std::ios::trunc);
            if (!outFile)
            {
                spdlog::error("Error writing tmp ini file {}.", tmpPath.string());
                return;
            }
            for (const auto& l : lines)
            {
                outFile << l << "\n";
            }

            outFile.close();

            std::filesystem::rename(tmpPath, SplinterCellUserIni);
            spdlog::info("{} SteamDeck mode updated to: {}", SplinterCellUserIni.string(), DesiredSetting);
        }
        else
        {
#if !defined(RELEASE_BUILD)
            spdlog::info("No changes needed - SteamDeckMode already set correctly.");
#endif
        }
    }
}


void SteamDeckFeatures::Toggle()
{
    UpdateSteamDeckINIVar();
}
