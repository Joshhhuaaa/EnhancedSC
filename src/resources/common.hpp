#pragma once
#include "helper.hpp"


inline HWND MainHwnd = nullptr;

inline HMODULE baseModule = GetModuleHandle(NULL);

inline std::filesystem::path sExePath;
inline std::string sExeName;
inline std::string sGameVersion;
