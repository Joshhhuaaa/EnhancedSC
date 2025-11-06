#include "stdafx.h"
#include "common.hpp"

#include "logging.hpp"

#pragma comment(lib,"Version.lib")

namespace Memory
{

    void PatchBytes(uintptr_t address, const char* pattern, unsigned int numBytes)
    {
        DWORD oldProtect;
        VirtualProtect((LPVOID)address, numBytes, PAGE_EXECUTE_READWRITE, &oldProtect);
        memcpy((LPVOID)address, pattern, numBytes);
        VirtualProtect((LPVOID)address, numBytes, oldProtect, &oldProtect);
    }
   
    static HMODULE GetThisDllHandle()
    {
        MEMORY_BASIC_INFORMATION info;
        size_t len = VirtualQueryEx(GetCurrentProcess(), (void*)GetThisDllHandle, &info, sizeof(info));
        assert(len == sizeof(info));
        return len ? (HMODULE)info.AllocationBase : NULL;
    }

    std::string GetModuleVersion(HMODULE module)
    {
        auto dosHeader = (PIMAGE_DOS_HEADER)module;
        auto ntHeaders = (PIMAGE_NT_HEADERS)((std::uint8_t*)module + dosHeader->e_lfanew);
        std::time_t time = ntHeaders->FileHeader.TimeDateStamp;
        // Extract date components
        std::tm* time_info = std::localtime(&time);
        int year = time_info->tm_year + 1900; // Years since 1900
        int month = time_info->tm_mon + 1;    // Months since January (0-11)
        int day = time_info->tm_mday;

        return std::to_string(year) + "-" + std::to_string(month) + "-" + std::to_string(day);
    }



    std::string GetModuleName(const HMODULE hMod, const bool filenameOnly = true)
    {
        char path[MAX_PATH];
        DWORD len = GetModuleFileNameA(hMod, path, MAX_PATH);
        if (len == 0)
        {
            return {};
        }

        if (filenameOnly)
        {
            return std::filesystem::path(path).filename().string();
        }

        return std::string(path, len);
    }

    // CSGOSimple's pattern scan
    // https://github.com/OneshotGH/CSGOSimple-master/blob/master/CSGOSimple/helpers/utils.cpp
    std::uint8_t* PatternScanSilent(void* module, const char* signature)
    {
        static auto pattern_to_byte = [](const char* pattern) {
            auto bytes = std::vector<int>{};
            auto start = const_cast<char*>(pattern);
            auto end = const_cast<char*>(pattern) + strlen(pattern);

            for (auto current = start; current < end; ++current) {
                if (*current == '?') {
                    ++current;
                    if (*current == '?')
                        ++current;
                    bytes.push_back(-1);
                }
                else {
                    bytes.push_back(strtoul(current, &current, 16));
                }
            }
            return bytes;
        };

        auto dosHeader = (PIMAGE_DOS_HEADER)module;
        auto ntHeaders = (PIMAGE_NT_HEADERS)((std::uint8_t*)module + dosHeader->e_lfanew);

        auto sizeOfImage = ntHeaders->OptionalHeader.SizeOfImage;
        auto patternBytes = pattern_to_byte(signature);
        auto scanBytes = reinterpret_cast<std::uint8_t*>(module);

        auto s = patternBytes.size();
        auto d = patternBytes.data();

        for (auto i = 0ul; i < sizeOfImage - s; ++i) {
            bool found = true;
            for (auto j = 0ul; j < s; ++j) {
                if (scanBytes[i + j] != d[j] && d[j] != -1) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return &scanBytes[i];
            }
        }
        return nullptr;
    }

    std::uint8_t* PatternScan(void* module, const char* signature, const char* prefix)
    {
        std::uint8_t* foundPattern = PatternScanSilent(module, signature);
        if (foundPattern)
        {
            spdlog::info("{}: Pattern scan found. Address: {:s}+{:x}", prefix, sExeName.c_str(), (uintptr_t)foundPattern - (uintptr_t)baseModule);
        }
        else
        {

            spdlog::error("---------- PATTERN SCAN FAILURE ----------");
            spdlog::error("{}: Pattern scan failed.", prefix);
            spdlog::error("---------- PATTERN SCAN FAILURE ----------");
        }
        return foundPattern;
    }

    uintptr_t GetAbsolute(uintptr_t address) noexcept
    {
        return (address + 4 + *reinterpret_cast<std::int32_t*>(address));
    }

    uintptr_t GetRelativeOffset(uint8_t* addr) noexcept
    {
        return reinterpret_cast<uintptr_t>(addr) + 4 + *reinterpret_cast<int32_t*>(addr);
    }

    BOOL HookIAT(HMODULE callerModule, char const* targetModule, const void* targetFunction, void* detourFunction)
    {
        auto* base = (uint8_t*)callerModule;
        const auto* dos_header = (IMAGE_DOS_HEADER*)base;
        const auto nt_headers = (IMAGE_NT_HEADERS*)(base + dos_header->e_lfanew);
        const auto* imports = (IMAGE_IMPORT_DESCRIPTOR*)(base + nt_headers->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);

        for (int i = 0; imports[i].Characteristics; i++)
        {
            const char* name = (const char*)(base + imports[i].Name);
            if (lstrcmpiA(name, targetModule) != 0)
                continue;

            void** thunk = (void**)(base + imports[i].FirstThunk);

            for (; *thunk; thunk++)
            {
                const void* import = *thunk;

                if (import != targetFunction)
                    continue;

                DWORD oldState;
                if (!VirtualProtect(thunk, sizeof(void*), PAGE_READWRITE, &oldState))
                    return FALSE;

                *thunk = detourFunction;

                VirtualProtect(thunk, sizeof(void*), oldState, &oldState);

                return TRUE;
            }
        }
        return FALSE;
    }
    // Read the current IAT entry (without changing it)
    void* ReadIAT(HMODULE callerModule, const char* targetModule, const char* targetFunction)
    {
        uint8_t* base = reinterpret_cast<uint8_t*>(callerModule);
        auto dos_header = reinterpret_cast<IMAGE_DOS_HEADER*>(base);
        auto nt_headers = reinterpret_cast<IMAGE_NT_HEADERS*>(base + dos_header->e_lfanew);
        auto imports = reinterpret_cast<IMAGE_IMPORT_DESCRIPTOR*>(
            base + nt_headers->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);

        for (int i = 0; imports[i].Characteristics; ++i)
        {
            const char* dllName = reinterpret_cast<const char*>(base + imports[i].Name);
            if (_stricmp(dllName, targetModule) != 0)
                continue;

            auto origFirstThunk = reinterpret_cast<IMAGE_THUNK_DATA*>(base + imports[i].OriginalFirstThunk);
            auto firstThunk = reinterpret_cast<IMAGE_THUNK_DATA*>(base + imports[i].FirstThunk);

            for (; origFirstThunk->u1.AddressOfData; ++origFirstThunk, ++firstThunk)
            {
                auto importByName = reinterpret_cast<IMAGE_IMPORT_BY_NAME*>(base + origFirstThunk->u1.AddressOfData);
                if (strcmp(reinterpret_cast<const char*>(importByName->Name), targetFunction) != 0)
                    continue;

                return reinterpret_cast<void*>(firstThunk->u1.Function);
            }
        }

        return nullptr;
    }

    // Write a new pointer into the IAT entry (unconditionally)
    BOOL WriteIAT(HMODULE callerModule, const char* targetModule, const char* targetFunction, void* detourFunction)
    {
        uint8_t* base = reinterpret_cast<uint8_t*>(callerModule);
        auto dos_header = reinterpret_cast<IMAGE_DOS_HEADER*>(base);
        auto nt_headers = reinterpret_cast<IMAGE_NT_HEADERS*>(base + dos_header->e_lfanew);
        auto imports = reinterpret_cast<IMAGE_IMPORT_DESCRIPTOR*>(
            base + nt_headers->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);

        for (int i = 0; imports[i].Characteristics; ++i)
        {
            const char* dllName = reinterpret_cast<const char*>(base + imports[i].Name);
            if (_stricmp(dllName, targetModule) != 0)
                continue;

            auto origFirstThunk = reinterpret_cast<IMAGE_THUNK_DATA*>(base + imports[i].OriginalFirstThunk);
            auto firstThunk = reinterpret_cast<IMAGE_THUNK_DATA*>(base + imports[i].FirstThunk);

            for (; origFirstThunk->u1.AddressOfData; ++origFirstThunk, ++firstThunk)
            {
                auto importByName = reinterpret_cast<IMAGE_IMPORT_BY_NAME*>(base + origFirstThunk->u1.AddressOfData);
                if (strcmp(reinterpret_cast<const char*>(importByName->Name), targetFunction) != 0)
                    continue;

                DWORD oldProtect;
                if (!VirtualProtect(&firstThunk->u1.Function, sizeof(void*), PAGE_EXECUTE_READWRITE, &oldProtect))
                    return FALSE;

                firstThunk->u1.Function = reinterpret_cast<ULONG_PTR>(detourFunction);

                VirtualProtect(&firstThunk->u1.Function, sizeof(void*), oldProtect, &oldProtect);

                return TRUE;
            }
        }

        return FALSE;
    }

}

namespace Util
{
#if !defined(RELEASE_BUILD)
    void DumpContext(const safetyhook::Context& ctx)
    {
        spdlog::info("\n"
            // General-purpose 32-bit registers
            "EAX = 0x{:X}\t| EBX = 0x{:X}\t| ECX = 0x{:X}\t| EDX = 0x{:X}\n"
            "ESI = 0x{:X}\t| EDI = 0x{:X}\t| EBP = 0x{:X}\t| ESP = 0x{:X}\n"
            "EIP = 0x{:X}\n"
            // XMM floats
            "XMM0 = {:g}\t| XMM1 = {:g}\t| XMM2 = {:g}\t| XMM3 = {:g}\n"
            "XMM4 = {:g}\t| XMM5 = {:g}\t| XMM6 = {:g}\t| XMM7 = {:g}\n",
            ctx.eax, ctx.ebx, ctx.ecx, ctx.edx,
            ctx.esi, ctx.edi, ctx.ebp, ctx.esp,
            ctx.eip,
            ctx.xmm0.f32[0], ctx.xmm1.f32[0], ctx.xmm2.f32[0], ctx.xmm3.f32[0],
            ctx.xmm4.f32[0], ctx.xmm5.f32[0], ctx.xmm6.f32[0], ctx.xmm7.f32[0]
        );
    }

    void DumpBytes(uint64_t address)
    {
        BYTE* fn = reinterpret_cast<BYTE*>(address);
        spdlog::info("First 6 bytes at address:");
        for (int i = 0; i < 6; ++i)
        {
            spdlog::info("  0x{:02X}", fn[i]);
        }
    }
#endif


    bool IsProcessRunning(const std::filesystem::path& fullPath)
    {
        HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (snapshot == INVALID_HANDLE_VALUE)
        {
            return false;
        }

        PROCESSENTRY32W entry {};
        entry.dwSize = sizeof(entry);

        bool found = false;

        if (Process32FirstW(snapshot, &entry))
        {
            do
            {
                HANDLE hProcess = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, entry.th32ProcessID);
                if (hProcess)
                {
                    wchar_t buf[MAX_PATH];
                    DWORD size = MAX_PATH;
                    if (QueryFullProcessImageNameW(hProcess, 0, buf, &size))
                    {
                        if (_wcsicmp(buf, fullPath.c_str()) == 0)
                        {
                            found = true;
                        }
                    }
                    CloseHandle(hProcess);
                    if (found) break;
                }
            } while (Process32NextW(snapshot, &entry));
        }

        CloseHandle(snapshot);
        return found;
    }


    int findStringInVector(const std::string& str, const std::initializer_list<std::string>& search)
    {
        std::string lowerStr = str;
        std::transform(lowerStr.begin(), lowerStr.end(), lowerStr.begin(), ::tolower);

        for (auto it = search.begin(); it != search.end(); ++it)
        {
            std::string lower = *it;
            std::transform(lower.begin(), lower.end(), lower.begin(), ::tolower);

            if (lowerStr == lower)
                return static_cast<int>(std::distance(search.begin(), it));
        }
        return 0;
    }



    // Convert an UTF8 string to a wide Unicode String
    std::wstring UTF8toWide(const std::string& str)
    {
        if (str.empty()) return std::wstring();
        int size_needed = MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), NULL, 0);
        std::wstring wstrTo(size_needed, 0);
        MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), &wstrTo[0], size_needed);
        return wstrTo;
    }

    std::string WideToUTF8(const std::wstring& wstr)
    {
        if (wstr.empty()) return {};

        int sizeNeeded = WideCharToMultiByte(
            CP_UTF8, 0,
            wstr.data(), (int)wstr.size(),
            nullptr, 0, nullptr, nullptr
        );

        std::string result(sizeNeeded, 0);
        WideCharToMultiByte(
            CP_UTF8, 0,
            wstr.data(), (int)wstr.size(),
            result.data(), sizeNeeded,
            nullptr, nullptr
        );

        return result;
    }


    std::pair<int, int> GetPhysicalDesktopDimensions()
    {
        if (DEVMODE devMode { .dmSize = sizeof(DEVMODE) }; EnumDisplaySettings(nullptr, ENUM_CURRENT_SETTINGS, &devMode))
            return { devMode.dmPelsWidth, devMode.dmPelsHeight };
        return {};
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

    ///Scans all valid ASI directories for any .asi files matching the fileName.
    bool CheckForASIFiles(std::string fileName, bool checkForDuplicates, bool setFixPath, const char* checkCreationDate)
    {
        std::array<std::string, 4> paths = { "", "plugins", "scripts", "update" };
        std::filesystem::path foundPath;
        bool bFoundOnce = false;
        for (const auto& path : paths)
        {
            auto filePath = sExePath / path / (fileName + ".asi");
            if (std::filesystem::exists(filePath))
            {
                if (checkCreationDate)
                {
                    auto fileTime = std::filesystem::last_write_time(filePath);
                    auto fileTimeChrono = std::chrono::system_clock::to_time_t(std::chrono::clock_cast<std::chrono::system_clock>(fileTime));
                    std::tm fileCreationTime = *std::localtime(&fileTimeChrono);
                    std::tm checkDate = {};
                    std::istringstream ss(checkCreationDate);
                    ss >> std::get_time(&checkDate, "%Y-%m-%d");
                    if (ss.fail() || std::mktime(&fileCreationTime) >= std::mktime(&checkDate))
                    {
                        continue;
                    }
                }
                if (bFoundOnce)
                {
                    std::string errorMessage = "DUPLICATE FILE ERROR: Duplicate " + fileName + ".asi installations found! Please make sure to delete any old versions!\n";
                    errorMessage.append("DUPLICATE FILE ERROR - Installation 1: ").append((sExePath / foundPath / (fileName + ".asi")).string().append("\n"));
                    errorMessage.append("DUPLICATE FILE ERROR - Installation 2: ").append(filePath.string());
                    spdlog::error("{}", errorMessage);
                    Logging::ShowConsole();
                    std::cout << errorMessage << std::endl;
                    FreeLibraryAndExitThread(baseModule, 1);
                }
                foundPath = path;
                if (setFixPath)
                {
                    sFixPath = foundPath;
                }
                if (!checkForDuplicates)
                {
                    return TRUE;
                }
                bFoundOnce = true;
            }
        }
        return FALSE;
    }

    std::string GetNameAtIndex(const std::initializer_list<std::string>& list, int index)
    {
        if (index >= 0 && index < static_cast<int>(list.size()))
        {
            auto it = list.begin();
            std::advance(it, index);
            return *it;
        }
        return "Unknown";
    }

    std::string GetUppercaseNameAtIndex(const std::initializer_list<std::string>& list, int index)
    {
        if (index >= 0 && index < static_cast<int>(list.size()))
        {
            auto it = list.begin();
            std::advance(it, index);
            std::string name = *it;
            std::transform(name.begin(), name.end(), name.begin(), ::toupper);
            return name;
        }
        return "UNKNOWN";
    }

    bool IsSteamOS()
    {
        if (g_Logging.bCheckedSteamDeck)
        {
            return g_Logging.bIsSteamDeck;
        }

        g_Logging.bCheckedSteamDeck = true;

        // Check for Proton/Steam Deck environment variables
        if (std::getenv("STEAM_COMPAT_CLIENT_INSTALL_PATH") || std::getenv("STEAM_COMPAT_DATA_PATH") || std::getenv("XDG_SESSION_TYPE"))
        {
            g_Logging.bIsSteamDeck = true;
            return true;
        }
        return false;
    }

    std::string StripQuotes(const std::string& value)
    {
        if (value.size() >= 2 && value.front() == '"' && value.back() == '"')
        {
            std::string s = value.substr(1, value.size() - 2);
            // Handle escaped quotes
            size_t pos = 0;
            while ((pos = s.find("\\\"", pos)) != std::string::npos)
            {
                s.replace(pos, 2, "\"");
                pos += 1;
            }
            return s;
        }
        return value;
    }


    std::string GetParentProcessName()
    {
        DWORD currentPid = GetCurrentProcessId();
        DWORD parentPid = 0;

        HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (snapshot == INVALID_HANDLE_VALUE)
        {
            return {};
        }

        PROCESSENTRY32 pe;
        pe.dwSize = sizeof(PROCESSENTRY32);

        if (Process32First(snapshot, &pe))
        {
            do
            {
                if (pe.th32ProcessID == currentPid)
                {
                    parentPid = pe.th32ParentProcessID;
                    break;
                }
            } while (Process32Next(snapshot, &pe));
        }
        CloseHandle(snapshot);

        if (parentPid == 0)
        {
            return {};
        }

        HANDLE hParent = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, parentPid);
        if (!hParent)
        {
            return {};
        }

        char exePath[MAX_PATH] = {};
        DWORD size = sizeof(exePath);
        if (!QueryFullProcessImageNameA(hParent, 0, exePath, &size))
        {
            CloseHandle(hParent);
            return {};
        }
        CloseHandle(hParent);

        std::string name = exePath;
        size_t pos = name.find_last_of("\\/");
        if (pos != std::string::npos)
        {
            name = name.substr(pos + 1);
        }

        // lowercase normalize
        std::transform(name.begin(), name.end(), name.begin(), ::tolower);
        return name;
    }

    bool IsProcessParent(const std::string& exeName)
    {
        std::string parent = GetParentProcessName();
        if (parent.empty())
        {
            return false;
        }

        std::string target = exeName;
        std::transform(target.begin(), target.end(), target.begin(), ::tolower);
        return parent == target;
    }

    // Case-insensitive string comparison helper
    bool iequals(const std::string& a, const std::string& b)
    {
        return a.size() == b.size() &&
            std::equal(a.begin(), a.end(), b.begin(), [](char a, char b)
                {
                    return std::tolower(static_cast<unsigned char>(a)) == std::tolower(static_cast<unsigned char>(b));
                });
    }

    int compareSemVer(const std::string& a, const std::string& b)
    {
        auto parse = [](const std::string& s)
            {
                std::vector<int> parts;
                std::istringstream ss(s);
                std::string token;

                while (std::getline(ss, token, '.'))
                {
                    if (token.empty())
                    {
                        parts.push_back(0);
                        continue;
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
            };

        std::vector<int> va = parse(a);
        std::vector<int> vb = parse(b);

        size_t n = std::max(va.size(), vb.size());
        va.resize(n, 0);
        vb.resize(n, 0);

        for (size_t i = 0; i < n; ++i)
        {
            if (va[i] < vb[i]) return -1;
            if (va[i] > vb[i]) return 1;
        }
        return 0;
    }


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
