#include "stdafx.h"
#include "check_gamesave_folder.hpp"

#include "common.hpp"
#include "logging.hpp"
void CheckGamesaveFolderWritable::CheckStatus()
{
    const std::filesystem::path baseSave = sExePath.parent_path().parent_path() / "Save";
    spdlog::info("Verifying gamesave directory is writeable: {}", baseSave.string());

    const std::vector<std::filesystem::path> baseFolders = {
        baseSave,
        baseSave / "Profiles",
        baseSave / "Sam"
    };

    bool success = true;

    // Make sure all save folders exist
    for (const auto& dir : baseFolders)
    {
        try
        {
            if (!std::filesystem::exists(dir))
            {
                spdlog::info("Directory '{}' does not exist. Creating...", dir.string());
                std::filesystem::create_directories(dir);
            }
        }
        catch (const std::exception& ex)
        {
            Logging::ShowConsole();
            std::cerr << "Error creating folder '" << dir << "': " << ex.what() << std::endl;
            spdlog::error("Failed to create folder '{}': {}", dir.string(), ex.what());
            success = false;
        }
    }

    if (!success)
    {
        return;
    }

    // Make sure all save folders are writable.
    try
    {
        for (const auto& entry : std::filesystem::recursive_directory_iterator(baseSave))
        {
            if (!entry.is_directory())
            {
                continue;
            }

            const auto& dir = entry.path();
            const auto testFile = dir / "write_test.tmp";

            std::error_code ec;
            std::filesystem::remove(testFile, ec);
            if (ec)
            {
                Logging::ShowConsole();
                std::cerr << "ERROR: Failed to remove leftover save test file from a previous launch in " << dir << ": " << ec.message() << std::endl;
                std::cerr << "ERROR: This typically indicates that the folder is set to read-only, which breaks game saving." << std::endl;
                spdlog::error("Failed to remove leftover test file from previous launch in '{}': {}", dir.string(), ec.message());
                success = false;
                continue;
            }

            std::ofstream ofs(testFile, std::ios::out | std::ios::trunc);
            if (!ofs.is_open())
            {
                Logging::ShowConsole();
                std::cerr << "ERROR: Cannot write to " << dir << std::endl;
                std::cerr << "ERROR: This typically indicates that the folder is set to read-only, which breaks game saving." << std::endl;
                spdlog::error("Cannot write to directory '{}'. Please check folder permissions.", dir.string());

                success = false;
                continue;
            }

            ofs << "test";
            ofs.close();

            std::filesystem::remove(testFile, ec);
            if (ec)
            {
                spdlog::error("Failed to remove temporary save test file in '{}': {}", dir.string(), ec.message());
                success = false;
                continue;
            }
        }
    }
    catch (const std::exception& ex)
    {
        Logging::ShowConsole();
        std::cerr << "Error while checking save folder writability: " << ex.what() << std::endl;
        spdlog::error("Exception while checking save folder writability: {}", ex.what());
        success = false;
    }

    if (!success)
    {
        return;
    }

    if (!CheckSaveFiles)
    {
        spdlog::info("All gamesave folders are writable. Save file read-only check disabled by config.");
        return;
    }

    spdlog::info("All gamesave folders are writable. Checking individual save files for read-only attribute.");

    size_t readOnlyCount = 0;

    for (const auto& entry : std::filesystem::recursive_directory_iterator(baseSave))
    {
        if (!entry.is_regular_file())
        {
            continue;
        }

        const auto& filePath = entry.path();

        if (Util::IsFileReadOnly(filePath))
        {
            Logging::ShowConsole();

            std::wcout << L"[WARNING: READ-ONLY FILE] " << filePath << std::endl;
            spdlog::warn("Detected read-only save file: {}", filePath.string());
            ++readOnlyCount;
        }
    }

    if (readOnlyCount > 0)
    {
        std::cout << "\nWARNING: " << readOnlyCount << " file" << (readOnlyCount > 1 ? "s are" : " is") << " set to read-only in the Save folder." << std::endl;
        std::cout << "Game saving may fail until these files are made writable.\n" << std::endl;

        spdlog::warn("{} save file{} detected as read-only.", readOnlyCount, (readOnlyCount > 1 ? "s" : ""));
        spdlog::warn("Game saving may fail until these files are made writable.");
    }
    else
    {
        spdlog::info("All gamesave folders and files verified as writable.");
    }

}
