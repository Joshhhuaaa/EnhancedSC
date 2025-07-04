//=============================================================================
// P_3_3_1_Mine_Dormitory
//=============================================================================
class P_3_3_1_Mine_Dormitory extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_GRABBED:
            EventJump('FalseIt');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('FalseIt');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('FalseIt');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('FalseIt');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('FalseIt');
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
        if(P.name == 'spetsnaz12')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz13')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz39')
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
Milestone:
    Log("MilestoneDormitory");
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0004L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0005L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0006L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0007L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0008L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0009L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(1);
    Close();
    ChangeState(3,'s_alert');
    SetFlashLight(3, TRUE);
    Goal_Set(3,GOAL_MoveTo,9,,,,'Dorm4',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(3,GOAL_MoveTo,);
    Goal_Set(3,GOAL_Wait,9,,,,'Dorm4',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_Dormitory", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_NPCS, 0, false);
    Sleep(1);
    Close();
    ChangeState(2,'s_alert');
    ChangeState(1,'s_alert');
    SetFlashLight(2, TRUE);
    SetFlashLight(1, TRUE);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Dorm3',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,9,,'Dorm4','Dorm4','DormNew',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Guard,9,,'Dorm4','Dorm4','DormNew',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(2,GOAL_Guard,9,,'Dorm4','Dorm4','Dorm3',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
addconversationsound:
    Talk(None, 2, , TRUE, 0);
    Sleep(1);
    Close();
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    SetFlashLight(1, TRUE);
    SetFlashLight(2, TRUE);
    SetFlashLight(3, TRUE);
    CheckFlags(V3_3_1MiningTown(Level.VarObject).PowerHouseAlerted,TRUE,'PowerAlerted');
    Goal_Set(3,GOAL_MoveTo,9,,,,'CameraOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Patrol,8,,,,'CameraOne',,FALSE,,MOVE_Search,,MOVE_Search);
    Jump('PowerStealth');
PowerAlerted:
    Log("PowerAlerted");
    Goal_Set(3,GOAL_MoveTo,9,,,,'CLookUnder2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Patrol,8,,,,'CLookUnder2',,FALSE,,MOVE_Search,,MOVE_Search);
PowerStealth:
    Log("PowerStealth");
    Goal_Set(2,GOAL_MoveTo,9,,,,'Dormi4',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Patrol,8,,,,'Dormi4',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_MoveTo,9,,,,'LookUnderDormi',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'LookUnderDormi',,FALSE,,MOVE_Search,,MOVE_Search);
    End();
Alerted:
    Log("Alerted");
    SetExclusivity(FALSE);
    SetFlags(V3_3_1MiningTown(Level.VarObject).DormitoryAlerted,TRUE);
    End();
FalseIt:
    Log("FalseIt");
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
