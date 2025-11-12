//=============================================================================
// P_3_1_2_Ship_GuardCrane
//=============================================================================
class P_3_1_2_Ship_GuardCrane extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (P.name == 'spetsnaz1')
            Characters[1] = P.controller;
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
CraneGuardB:
    Log("");
    Sleep(2);
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,,,'ELight39',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    CinCamera(0, 'ELight41', 'ELight40',);
    Sleep(3);
    CinCamera(1, , ,);
    End();
GetOut:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'spetsnaz15_0',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Patrol,8,,,,'spetsnaz15_0',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    End();

}

defaultproperties
{
}
