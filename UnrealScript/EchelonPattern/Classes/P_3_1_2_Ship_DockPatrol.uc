//=============================================================================
// P_3_1_2_Ship_DockPatrol
//=============================================================================
class P_3_1_2_Ship_DockPatrol extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'EMafiaMuscle10')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz5')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz2')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
    ResetGroupGoals();
    Goal_Default(1,GOAL_Patrol,9,,,,'EMafiaMuscle10_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'spetsnaz2_100',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,8,,,,'spetsnaz2_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(2);
    Goal_Default(3,GOAL_Patrol,9,,,,'spetsnaz5_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
Out1:
    Log("");
    Sleep(5);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode221',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPoint8',,'PathNode221',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
KillSwitch:
    Log("");
    KillNPC(1, FALSE, FALSE);
    KillNPC(2, FALSE, FALSE);
    KillNPC(3, FALSE, FALSE);
    End();

}

defaultproperties
{
}
