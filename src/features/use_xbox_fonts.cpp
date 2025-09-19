#include "stdafx.h"
#include "use_xbox_fonts.hpp"

#include "common.hpp"
#include "logging.hpp"
namespace
{
    void UpdateXboxFontsINIVar()
    {
        spdlog::info("Syncing bUseXboxFonts in SplinterCell.ini");
        std::filesystem::path SplinterCellUserIni = sExePath / "SplinterCell.ini";
        if (!std::filesystem::exists(SplinterCellUserIni))
        {
            spdlog::warn("SplinterCell.ini not found!");
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
            lines.push_back(line); // getline strips \r\n
        }
        iniFile.close();

        constexpr const char* SectionHeader = "[Echelon.ECanvas]";
        const char* DesiredSetting = g_UseXboxFonts.bXboxFont ? "ETextFont=Font'ETextFont'" : "ETextFont=Font'ETextFontPC'";

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
                if (current.find("ETextFont") == 0)
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

        if (!foundSetting)
        {
            if (insertPos < lines.size())
            {
                // Section exists but missing setting
                lines.insert(lines.begin() + insertPos, DesiredSetting);
            }
            else
            {
                // Section missing -> always append at EOF
                if (!lines.empty() && !lines.back().empty())
                {
                    lines.push_back("");
                }
                lines.push_back(SectionHeader);
                lines.push_back(DesiredSetting);
            }
            modified = true;
        }

        if (modified)
        {
            std::ofstream outFile(SplinterCellUserIni, std::ios::binary | std::ios::trunc);
            if (!outFile)
            {
                spdlog::error("Error writing ini file {}.", SplinterCellUserIni.string());
                return;
            }

            for (const auto& l : lines)
            {
                outFile << l << "\r\n";
            }

            // Ensure exactly one trailing blank line at EOF
            if (lines.empty() || !lines.back().empty())
            {
                outFile << "\r\n";
            }


            spdlog::info("{} bXboxFont updated to: {}", SplinterCellUserIni.string(), DesiredSetting);
        }
        else
        {
#if !defined(RELEASE_BUILD)
            spdlog::info("No changes needed - bXboxFont already set correctly.");
#endif
        }
    }
}


void UseXboxFonts::Toggle()
{
    UpdateXboxFontsINIVar();
}
