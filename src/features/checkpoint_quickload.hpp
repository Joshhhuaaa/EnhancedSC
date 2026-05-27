#pragma once

class CheckpointQuickload final
{
public:
    // Hook the Core/Engine exports. Called early from
    // InitializeSubsystems(), before Echelon.dll has been loaded.
    void Initialize();

    // Hook AEPlayerController::Tick. Called from dllmain's InitEchelon()
    // once Echelon.dll has been loaded by the game.
    void InitEchelonHooks();
};

inline CheckpointQuickload g_CheckpointQuickload;
