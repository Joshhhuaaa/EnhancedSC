//=============================================================================
// P_3_1_2_Ship_HangarSniperB
//=============================================================================
class P_3_1_2_Ship_HangarSniperB extends EPattern;

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
        if(P.name == 'spetsnaz4')
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
Start:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode41',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_ThrowGrenade,8,,'EMovableFocusPoint1','EMovableFocusPoint1',,,FALSE,0.8,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
move:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode41',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Attack,8,,'EMovableFocusPoint0','PLAYER','PathNode41',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(8);
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
