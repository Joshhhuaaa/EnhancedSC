//=============================================================================
// P_3_3_1_Mine_BridgeAction
//=============================================================================
class P_3_3_1_Mine_BridgeAction extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'spetsnaz21')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz22')
            Characters[2] = P.controller;
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
Milestone:
    Log("MilestoneBridgeAction");
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_BridgeAction", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_BridgeAction", "Speech_0004L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_NPCS, 0, false);
    Sleep(1);
    Close();
    ChangeState(1,'s_alert');
    ChangeState(2,'s_alert');
    SetFlashLight(1, TRUE);
    SetFlashLight(2, TRUE);
    CheckFlags(V3_3_1MiningTown(Level.VarObject).DormitoryAlerted,TRUE,'NotStealthWay');
StealthWay:
    Log("StealthWay");
    Goal_Set(1,GOAL_MoveTo,9,,,,'Ware1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(0.50);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Ware1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
JumpedFromNotStealth:
    Goal_Set(1,GOAL_MoveTo,8,,,,'SpTarence_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'Dorm4',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,6,,,,'Dorm4',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'SpTarence_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,7,,,,'DormNew',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,6,,'Trigga','Trigga','DormNew',,FALSE,,,,);
    End();
NotStealthWay:
    Log("NotStealthWay");
    Goal_Set(1,GOAL_MoveTo,9,,,,'SpTarence_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,'BehindOldWareP','BehindOldWareP','SpTarence_300',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,9,,,,'SpTarence_100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'BehindOldWareP',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Guard,7,,'BitchLookPointBrideA','BitchLookPointBrideA','BehindOldWareP',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(23);
    ResetGroupGoals();
    Jump('JumpedFromNotStealth');
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).BridgeAlerted,TRUE);
    End();

}

defaultproperties
{
}
