#pragma once

class DistanceCulling final
{
public:
    void Initialize() const;
    bool isEnabled;
};

inline DistanceCulling g_DistanceCulling;


