#include "stdafx.h"
#include "mouse_xbuttons_support.hpp"
#include <spdlog/spdlog.h>
#include "common.hpp"
#include "hook_dlls.hpp"
#include <safetyhook.hpp>


namespace
{

    /*
    * Add support for mouse XButtons (Mouse4/Mouse5) by hooking UWindowsViewport::ViewportWndProc and handling it ourself by
    * passing it to UWindowsViewport::CauseInputEvent.
    *
    * The UWindowsViewport::CauseInputEvent hook is important because the game tries to check if the mouse button is still pressed by using
    * GetKeyState(iKey) & IS_PRESSED which doesn't work with mouse buttons, so we just hook it and ignore all CauseInputEvent(xbuttons) calls.
    *
    */

    #define UWindowsViewport_ViewportWndProc_OFFSET 0x7E10
    #define UWindowsViewport_CauseInputEvent_OFFSET 0x6A70

    typedef LRESULT(__thiscall* UWindowsViewport_ViewportWndProc_t)(char* pThis, UINT iMessage, WPARAM wParam, LPARAM lParam);
    UWindowsViewport_ViewportWndProc_t orig_ViewportWndProc = nullptr;

    typedef signed int(__thiscall* UWindowsViewport_CauseInputEvent_t)(char* pThis, INT iKey, INT Action, FLOAT Delta);
    UWindowsViewport_CauseInputEvent_t orig_CauseInputEvent = nullptr;

    constexpr UINT IK_MOUSE4 = 193;
    constexpr UINT IK_MOUSE5 = 194;

    constexpr UINT IST_Press = 1;
    constexpr UINT IST_Release = 3;

    safetyhook::InlineHook sh_ViewportWndProc;
    safetyhook::InlineHook sh_CauseInputEvent;

    LRESULT __fastcall OnUWindowsViewport_ViewportWndProc(char* pThis, int edx, UINT iMessage, WPARAM wParam, LPARAM lParam)
    {
        if (iMessage == WM_XBUTTONDOWN || iMessage == WM_XBUTTONUP)
        {
            const UINT button = GET_XBUTTON_WPARAM(wParam);

            UINT iKey = 0;
            if (button == XBUTTON1)
            {
                iKey = IK_MOUSE4;
            }
            else if (button == XBUTTON2)
            {
                iKey = IK_MOUSE5;
            }


            if (iKey != 0)
            {
                const UINT inputState = (iMessage == WM_XBUTTONDOWN) ? IST_Press : IST_Release;
                spdlog::info("Detected key press {}", iKey);
                sh_CauseInputEvent.thiscall<signed int>(pThis, iKey, inputState, 1.0f);
                spdlog::info("CauseInputEvent call done {}", iKey);

                return 0;
            }

            // A different xbutton was pressed, can look into adding support if people are interested
            // Ignore and continue as normal for now
        }

        return sh_ViewportWndProc.thiscall<LRESULT>(pThis, iMessage, wParam, lParam);
    }

    signed int __fastcall OnUWindowsViewport_CauseInputEvent(char* pThis, int edx, INT iKey, INT Action, FLOAT Delta)
    {
        if (iKey == IK_MOUSE4 || iKey == IK_MOUSE5)
        {
            // As part of some routine input state checks, UWindowsViewport::UpdateInput will call this function with IST_Release because GetKeyState(iKey) & IS_PRESSED returns false.
            // We just ignore that call.
            return 1;
        }

        return sh_CauseInputEvent.thiscall<signed int>(pThis, iKey, Action, Delta);
    }



}

void MouseXButtonsSupport::Initialize()
{
    uintptr_t baseAddress = reinterpret_cast<uintptr_t>(g_GameDLLs.WinDrv);
    
    sh_ViewportWndProc = safetyhook::create_inline(
        baseAddress + UWindowsViewport_ViewportWndProc_OFFSET,
        &OnUWindowsViewport_ViewportWndProc
    );

    sh_CauseInputEvent = safetyhook::create_inline(
        baseAddress + UWindowsViewport_CauseInputEvent_OFFSET,
        &OnUWindowsViewport_CauseInputEvent
    );
}
