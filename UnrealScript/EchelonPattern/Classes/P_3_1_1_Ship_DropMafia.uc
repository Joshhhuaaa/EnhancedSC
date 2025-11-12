//=============================================================================
// P_3_1_1_Ship_DropMafia
//=============================================================================
class P_3_1_1_Ship_DropMafia extends EPattern;

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

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Go:
    Log("set up guards");
    Goal_Set(1,GOAL_InteractWith,9,,,,'ELightSwitch9',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode147',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,7,,'EMafiaMuscle_400',,'PathNode147',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode319',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Guard,8,,'EFocusPoint9',,'PathNode319',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();

}

defaultproperties
{
}
