#pragma once

class SuppressErrorDialogs
{
public:
    static void Initialize();

    static inline bool bShowErrors = true;
};
