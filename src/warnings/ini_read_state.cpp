#include "stdafx.h"
#include "ini_read_state.hpp"

#include "common.hpp"
#include "logging.hpp"


namespace
{
    bool IsFileReadOnly(const std::filesystem::path& path)
    {
        DWORD attrs = GetFileAttributesW(path.wstring().c_str());
        if (attrs == INVALID_FILE_ATTRIBUTES)
        {
            std::wcerr << L"[ERROR] Failed to get attributes for: " << path << std::endl;
            spdlog::error("Failed to get attributes for file: {}", path.string());
            return false;
        }

        return (attrs & FILE_ATTRIBUTE_READONLY) != 0;
    }
}

void CheckINIReadPermissions::CheckStatus()
{
    if (!Enabled)
    {
        return;
    }

    const std::filesystem::path& rootFolder = sExePath;
    spdlog::info("Checking .ini files for read-only status in directory: {}", rootFolder.string());

    size_t readOnlyCount = 0;
    for (const auto& entry : std::filesystem::recursive_directory_iterator(rootFolder))
    {
        if (!entry.is_regular_file())
        {
            continue;
        }

        const auto& filePath = entry.path();

        if (_wcsicmp(filePath.extension().c_str(), L".ini") != 0)
        {
            continue;
        }

        if (IsFileReadOnly(filePath))
        {

            Logging::ShowConsole();

            std::wcout << L"[WARNING: READ-ONLY FILE] " << filePath << std::endl;
            spdlog::warn("Detected read-only .ini file: {}", filePath.string());
            ++readOnlyCount;
        }
    }

    if (readOnlyCount > 0)
    {
        std::cout << "\nWARNING: " << readOnlyCount << " .ini file" << (readOnlyCount > 1 ? "s are" : " is") << " set to read-only." << std::endl;
        std::cout << "Settings menus may not function as intended until these files are made writable.\n" << std::endl;

        spdlog::warn("{} .ini file{} detected as read-only.", readOnlyCount, (readOnlyCount > 1 ? "s" : ""));
        spdlog::warn("Settings menus may not function as intended until these files are made writable.");
    }
    else
    {
        spdlog::info("All .ini files checked succesfully.");
    }
}
