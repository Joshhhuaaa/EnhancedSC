#include "stdafx.h"
#include "asi_loader_checks.hpp"
#include "common.hpp"
#include "logging.hpp"

constexpr const char* kRequiredVCRuntimeVersion = "14.44.35211";
constexpr const char* kVCRuntimeDownloadURL = "https://aka.ms/vs/17/release/vc_redist.x86.exe";

[[noreturn]] static void ShowRuntimeErrorAndExit(const std::string& message, const std::string& detectedVersion = "")
{
    spdlog::error("Please install the latest Microsoft Visual C++ 2015-2022 Redistributable (x86) from {}", kVCRuntimeDownloadURL);
    std::string msg = message;

    if (!detectedVersion.empty())
    {
        msg += "\n\nDetected version: " + detectedVersion +
            "\nRequired version: " + std::string(kRequiredVCRuntimeVersion) + " or newer.";
    }

    msg += "\n\nWould you like to open the download link now?";

    int result = MessageBoxA(
        NULL,
        msg.c_str(),
        "Microsoft Visual C++ Redistributable",
        MB_ICONERROR | MB_YESNO
    );

    if (result == IDYES)
    {
        ShellExecuteA(NULL, "open",
            kVCRuntimeDownloadURL,
            NULL, NULL, SW_SHOWNORMAL);
    }

    ExitProcess(1); // hard exit
}

static bool CheckVCRuntimeInstalled()
{
    if (Util::IsSteamOS())
    {
        return true;
    }

    HKEY hKey;
    const TCHAR* subKey = TEXT("SOFTWARE\\WOW6432Node\\Microsoft\\VisualStudio\\14.0\\VC\\Runtimes\\x86");

    if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, subKey, 0, KEY_READ, &hKey) != ERROR_SUCCESS)
    {
        spdlog::error("Microsoft Visual C++ 2015-2022 Redistributable (x86) not installed");
        ShowRuntimeErrorAndExit(
            "Microsoft Visual C++ 2015-2022 Redistributable (x86) not installed.\n\nPlease install the required runtimes."
        );
    }

    DWORD installed = 0;
    DWORD size = sizeof(installed);
    if (RegQueryValueEx(hKey, TEXT("Installed"), nullptr, nullptr, (LPBYTE)&installed, &size) != ERROR_SUCCESS || installed != 1)
    {
        RegCloseKey(hKey);
        spdlog::error("Microsoft Visual C++ 2015-2022 Redistributable (x86) is not installed properly.");
        ShowRuntimeErrorAndExit(
            "Microsoft Visual C++ 2015-2022 Redistributable (x86) is not installed.\n\nPlease install the required runtimes."
        );
    }

    DWORD major = 0, minor = 0, bld = 0;
    DWORD dsize = sizeof(DWORD);

    if (RegQueryValueEx(hKey, TEXT("Major"), nullptr, nullptr, (LPBYTE)&major, &dsize) != ERROR_SUCCESS ||
        RegQueryValueEx(hKey, TEXT("Minor"), nullptr, nullptr, (LPBYTE)&minor, &dsize) != ERROR_SUCCESS ||
        RegQueryValueEx(hKey, TEXT("Bld"), nullptr, nullptr, (LPBYTE)&bld, &dsize) != ERROR_SUCCESS)
    {
        RegCloseKey(hKey);
        spdlog::error("VC++ runtime registry values (Major/Minor/Bld) are missing or corrupt.");
        ShowRuntimeErrorAndExit(
            "VC++ runtime registry values (Major/Minor/Bld) are missing or corrupt.\n\nPlease reinstall the required runtimes."
        );
    }

    RegCloseKey(hKey);

    std::string versionOut = std::to_string(major) + "." +
        std::to_string(minor) + "." +
        std::to_string(bld);

    if (Util::compareSemVer(versionOut, kRequiredVCRuntimeVersion) < 0)
    {
        spdlog::error("VC++ runtime version {} is too old, required >= {}", versionOut, kRequiredVCRuntimeVersion);
        ShowRuntimeErrorAndExit(
            "Microsoft Visual C++ 2015-2022 Redistributable (x86) is outdated.\n\nPlease install the latest runtimes.",
            versionOut
        );
    }

    return true;
}


void Init_ASILoaderSanityChecks()
{
    if (!CheckVCRuntimeInstalled())
    {
        return;
    }
    


}
