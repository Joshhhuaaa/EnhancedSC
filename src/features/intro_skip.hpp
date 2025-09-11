#pragma once

class IntroSkip final
{
public:
    bool isEnabled;
    void Initialize() const;
};

inline IntroSkip g_IntroSkip;
