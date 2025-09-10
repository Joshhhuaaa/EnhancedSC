#include "stdafx.h"
#include "common.hpp"
#include "gamevars.hpp"
#include "logging.hpp"

void GameVars::Initialize()
{
    //EXAMPLE - currentStage = reinterpret_cast<char const*>(Memory::GetRelativeOffset(Memory::PatternScan(baseModule, "4C 8D 0D ?? ?? ?? ?? 48 8D 15 ?? ?? ?? ?? 4C 8D 05", "MGS 2: GameVars: currentStage", NULL, NULL) + 3));

    ///todo - find all the offsets via cheat engine. uncomment them as they're finished
    //timesFound = reinterpret_cast<int*>(baseModule+0x5);
    //bodiesFound = reinterpret_cast<int*>(baseModule+0x5);
    //alarmsTriggered = reinterpret_cast<int*>(baseModule+0x5);

    //enemiesKnockedOut = reinterpret_cast<int*>(baseModule+0x5);
    //enemiesInjured = reinterpret_cast<int*>(baseModule+0x5);
    //enemiesKilled = reinterpret_cast<int*>(baseModule+0x5);

    //civiliansKnockedOut = reinterpret_cast<int*>(baseModule+0x5);
    //civiliansInjured = reinterpret_cast<int*>(baseModule+0x5);
    //civiliansKilled = reinterpret_cast<int*>(baseModule+0x5);
    
    //bulletsFired = reinterpret_cast<int*>(baseModule+0x5);
    //lightsDestroyed = reinterpret_cast<int*>(baseModule+0x5);
    //objectsDestroyed = reinterpret_cast<int*>(baseModule+0x5);
    //locksPicked = reinterpret_cast<int*>(baseModule+0x5);
    //locksDestroyed = reinterpret_cast<int*>(baseModule+0x5);
    //medkitsUsed = reinterpret_cast<int*>(baseModule + 0x5);
    
    //NPCsInterrogated = reinterpret_cast<int*>(baseModule + 0x5);
}
