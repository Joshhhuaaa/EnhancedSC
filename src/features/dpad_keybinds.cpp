#include "stdafx.h"

#include "dpad_keybinds.hpp"

#include "common.hpp"
#include "logging.hpp"

void DPadKeybinds::Initialize()
{
    spdlog::info("Checking for DPad Keybinds...");
    std::filesystem::path SplinterCellUserIni = sExePath / "SplinterCellUser.ini";
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

    constexpr const char* Desired9 = R"(Aliases[9]=(Command="Button bDPadUp | PreviousGadget",Alias="DPadUp"))";
    constexpr const char* Desired10 = R"(Aliases[10]=(Command="Button bDPadDown | NextGadget",Alias="DPadDown"))";

    bool found9 = false;
    bool found10 = false;
    bool insideEngineInput = false;
    bool modified = false;
    size_t insertPos = lines.size(); // default to EOF if no section found

    for (size_t i = 0; i < lines.size(); i++)
    {
        std::string& current = lines[i];
        if (current == "[Engine.Input]")
        {
            insideEngineInput = true;
            insertPos = i + 1;
            continue;
        }

        if (insideEngineInput && !current.empty() && current[0] == '[')
        {
            insideEngineInput = false;
        }

        if (insideEngineInput)
        {
            if (current.find("Aliases[9]") == 0)
            {
                if (current != Desired9)
                {
                    current = Desired9;
                    modified = true;
                }
                found9 = true;
            }
            else if (current.find("Aliases[10]") == 0)
            {
                if (current != Desired10)
                {
                    current = Desired10;
                    modified = true;
                }
                found10 = true;
            }
        }
    }

    if (!found9 && insertPos < lines.size())
    {
        lines.insert(lines.begin() + insertPos, Desired9);
        insertPos++;
        modified = true;
    }
    if (!found10 && insertPos < lines.size())
    {
        lines.insert(lines.begin() + insertPos, Desired10);
        modified = true;
    }

    if (modified)
    {
        std::ofstream outFile(SplinterCellUserIni, std::ios::trunc);
        if (!outFile)
        {
            spdlog::error("Error writing ini file {}.", SplinterCellUserIni.string());
            return;
        }
        for (const auto& l : lines)
        {
            outFile << l << "\n";
        }
        spdlog::info("Patched {}", SplinterCellUserIni.string());
    }
    else
    {
        spdlog::info("No changes needed - DPAD keybinds already set.");
    }
}
