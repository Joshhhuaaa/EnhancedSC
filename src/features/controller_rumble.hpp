#pragma once

class ControllerRumble
{
public:
    static void Fix();
    bool bEnabled = false;
};

inline ControllerRumble g_ControllerRumble;
