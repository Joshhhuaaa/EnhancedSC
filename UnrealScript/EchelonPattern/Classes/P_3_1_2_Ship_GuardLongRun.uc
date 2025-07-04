//=============================================================================
// P_3_1_2_Ship_GuardLongRun
//=============================================================================
class P_3_1_2_Ship_GuardLongRun extends EPattern;

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
        if(P.name == 'spetsnaz22')
            Characters[1] = P.controller;
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
Go:
    Log("teleport and start guard long run");
    ResetGoals(1);
    ChangeState(1,'s_alert');
    Teleport(1, 'PathNode183');
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode180',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,'EFocusPoint1',,'PathNode182',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_ThrowGrenade,7,,'EFocusPoint2','EFocusPoint2',,,FALSE,0.6,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Attack,6,,'EFocusPoint2','PLAYER','PathNode182',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();

}

defaultproperties
{
}
