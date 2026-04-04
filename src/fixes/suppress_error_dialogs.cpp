#include "stdafx.h"
#include "suppress_error_dialogs.hpp"

#include <spdlog/spdlog.h>

#include <safetyhook.hpp>

namespace
{
    safetyhook::InlineHook shMessageBoxA;
    safetyhook::InlineHook shMessageBoxW;

    int WINAPI HookedMessageBoxA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType)
    {
        if (!SuppressErrorDialogs::bShowErrors)
            return IDOK;
        return shMessageBoxA.stdcall<int>(hWnd, lpText, lpCaption, uType);
    }

    int WINAPI HookedMessageBoxW(HWND hWnd, LPCWSTR lpText, LPCWSTR lpCaption, UINT uType)
    {
        if (!SuppressErrorDialogs::bShowErrors)
            return IDOK;
        return shMessageBoxW.stdcall<int>(hWnd, lpText, lpCaption, uType);
    }
}

void SuppressErrorDialogs::Initialize()
{
    spdlog::info("Show error dialogs is {}", bShowErrors ? "enabled" : "disabled");

    if (!bShowErrors)
    {
        shMessageBoxA = safetyhook::create_inline(&MessageBoxA, HookedMessageBoxA);
        shMessageBoxW = safetyhook::create_inline(&MessageBoxW, HookedMessageBoxW);
    }
}
