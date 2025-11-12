//=============================================================================
// P_3_3_1_Mine_HQGoingOut
//=============================================================================
class P_3_3_1_Mine_HQGoingOut extends EPattern;

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
        if (P.name == 'spetsnaz7')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz3')
            Characters[2] = P.controller;
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
Milestone:
    Log("Milestone");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).BridgeAlerted,TRUE,'BridgeWasNotStealth');
BridgeWasStealth:
    Log("BridgeWasStealth");
    ChangeGroupState('s_investigate');
    Goal_Set(1,GOAL_MoveTo,9,,,,'AlarmGuardingNuevo',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'ware24','ware24','AlarmGuardingNuevo',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RoofHQAA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'SnipePointHQRoofAAA','SnipePointHQRoofAAA','RoofHQAA',,FALSE,,MOVE_WalkNormal,,MOVE_CrouchWalk);
    End();
BridgeWasNotStealth:
    Log("BridgeWasNotStealth");
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'AlarmGuardingNuevo',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Guard,8,,'ware24','ware24','AlarmGuardingNuevo',,FALSE,,MOVE_Search,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RoofHQZZ',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Patrol,8,,,,'RoofHQZZ',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).OutsideHQAlerted,TRUE);
    End();

}

defaultproperties
{
}
