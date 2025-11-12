//=============================================================================
// P_1_1_2_BreakWindow
//=============================================================================
class P_1_1_2_BreakWindow extends EPattern;

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
        if (P.name == 'EGeorgianCop0')
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
GateOpen:
    Log("This is the pattern to bring in the guard after the gate opens.");
    SendPatternEvent('LambertAI','DeadDrop');
    SendUnrealEvent('MoreviGates');
    ResetGroupGoals();
    ChangeState(1,'s_default');
    Teleport(1, 'IgnatEnterPoint');
    Goal_Default(1,GOAL_Patrol,0,,,,'Ignat_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Ignat10Pattern',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

