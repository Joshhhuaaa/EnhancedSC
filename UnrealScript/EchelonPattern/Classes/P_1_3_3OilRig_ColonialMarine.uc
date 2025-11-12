//=============================================================================
// P_1_3_3OilRig_ColonialMarine
//=============================================================================
class P_1_3_3OilRig_ColonialMarine extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int EscortNear;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EUSSoldier0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    EscortNear=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
DieGorman:
    Log("Die Gorman, die die die!!!");
    SendUnrealEvent('KillGorman');
    Teleport(1, 'GormanDeathNode');
    Sleep(0.35);
    KillNPC(1, FALSE, TRUE);
    End();
EscortNear:
    Log("The escort is now near the MachiDistract Group.");
    SetFlags(EscortNear,TRUE);
    End();
EscortFar:
    Log("Near...  Escort is out of MachiDistract range...  far!!");
    SetFlags(EscortNear,FALSE);
    End();
DistanceCheck:
    Log("Checks MachiDistract group for escort distance.");
    CheckFlags(EscortNear,TRUE,'DistanceNear');
    SendPatternEvent('MachiDistractAI','MojoJojo');
    End();
DistanceNear:
    Log("The check has returned that the group is near.");
    SendPatternEvent('JedediahAI','GameOverMan');
    SendPatternEvent('MachiDistractAI','Exclu');
    End();
FirstExplosion:
    Log("EDispatcher functionality for FirstExplosion rolled into a pattern.");
    Sleep(0.2);
    SendUnrealEvent('FirstExplosion1');
    Sleep(0.2);
    SendUnrealEvent('FirstExplosion2');
    Sleep(0.2);
    SendUnrealEvent('FirstExplosion3');
    Sleep(1);
    SendUnrealEvent('FirstExplosion4');
    Sleep(0.25);
    SendUnrealEvent('FirstExplosion5');
    Sleep(1);
    SendUnrealEvent('FirstExplosion6');
    Sleep(0.25);
    SendUnrealEvent('FirstExplosion7');
    Sleep(1.69);
    SendUnrealEvent('FirstExplosion8');
    End();

}

