//=============================================================================
// P_3_3_1_Mine_StartSecPatrol
//=============================================================================
class P_3_3_1_Mine_StartSecPatrol extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
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
        if (P.name == 'spetsnaz1')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz4')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz24')
            Characters[3] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
StartPatrolNow:
    Log("StartPatrolNowStartSecPatrol");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).FirstHousesAlerted,TRUE,'QuickFlash');
    Goal_Set(1,GOAL_MoveTo,9,,,,'SpBarry_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Default(1,GOAL_Patrol,8,,,,'SpBarry_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Jump('SniperScript');
    End();
QuickFlash:
    Log("QuickFlash");
    Goal_Set(1,GOAL_MoveTo,9,,,,'SpBarry_200',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'SpBarry_200',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Jump('SniperScript');
    End();
SniperScript:
    Log("SniperScript");
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'SniperNodeAA',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Guard,8,,'SniperFocusCentA','SniperFocusCentA','SniperNodeAA',,FALSE,,MOVE_CrouchJog,,MOVE_JogAlert);
    Sleep(8);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'SniperNodeBB',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Guard,8,,'SniperFocusCentB','SniperFocusCentB','SniperNodeBB',,FALSE,,MOVE_CrouchJog,,MOVE_JogAlert);
    Sleep(9);
    Jump('SniperScript');
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).SecondPlazaAlerted,TRUE);
    End();

}

defaultproperties
{
}
