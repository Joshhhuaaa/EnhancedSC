//=============================================================================
// P_3_1_2_Ship_GuardPSRL
//=============================================================================
class P_3_1_2_Ship_GuardPSRL extends EPattern;

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
        if (P.name == 'spetsnaz23')
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
Go:
    Log("Tetleport a guard on and to activate the Sub footbridge");
    CheckFlags(V3_1_2_ShipYard(Level.VarObject).HNGpsrlPass1,TRUE,'passOK');
    End();
passOK:
    Log("flag is ok");
    ResetGoals(1);
    Teleport(1, 'PathNode308');
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint27',,'PathNode308',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPoint27',,'PathNode307',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

defaultproperties
{
}
