#pragma once

class IdleTimers final
{
public:
    static void Initialize();
    bool bDisableIdleTimer;
};

inline IdleTimers g_IdleTimers;