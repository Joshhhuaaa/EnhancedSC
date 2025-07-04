//=============================================================================
// P_0_0_3_TrainingT3_Hidebody06
//=============================================================================
class P_0_0_3_TrainingT3_Hidebody06 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CongratsPlayed;
var int PatrolStarted;
var int ReachedMidPoint;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('ManDown');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('OffHeard');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('OffSawBody');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('OffSaw');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('OffSaw');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('OffSaw');
            break;
        case AI_UNCONSCIOUS:
            EventJump('OffDamage');
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
        if(P.name == 'ECIASecurity3')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz0')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
        if(P.name == 'ELambert0')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    CongratsPlayed=0;
    PatrolStarted=0;
    ReachedMidPoint=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Setup:
    Log("Startup - Hidebody06");
    ResetNPC(1,FALSE);
    ResetNPC(2,FALSE);
    DisableMessages(FALSE, FALSE);
    End();
CheckIfValid:
    Log("CheckIfValid - HideBody06");
    CheckIfIsUnconscious(1,'OffDamage');
    End();
Completed:
    Log("Completed - HideBody06");
    GoalCompleted('Hide06B');
    SendUnrealEvent('HideBodyRoomLights');
    DisableMessages(TRUE, FALSE);
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,1,,'LookyEnd','LookyEnd','StartNPCHideBody06',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    PlayerMove(false);
    Speech(Localize("P_0_0_3_TrainingT3_Hidebody06", "Speech_0009L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_23', 3, 0, TR_HEADQUARTER, 0, false);
    Close();
    PlayerMove(true);
    End();
OffHeard:
    Log("OffHeard - Hidebody06");
    DisableMessages(TRUE, TRUE);
    Talk(Sound'S0_0_3Voice.Play_00_25_11', 1, , TRUE, 0);
    Jump('Failed');
OffSaw:
    Log("OffSaw - Hidebody06");
    DisableMessages(TRUE, TRUE);
    Talk(Sound'S0_0_3Voice.Play_00_25_12', 1, , TRUE, 0);
    Jump('Failed');
OffSawBody:
    Log("");
    DisableMessages(TRUE, TRUE);
    Talk(Sound'S0_0_3Voice.Play_00_25_13', 1, , TRUE, 0);
    Jump('Failed');
OffDamage:
    Log("OffDamage - Hidebody06");
    CheckIfIsUnconscious(1,'OffDamage2');
    End();
OffDamage2:
    Log("OffDamage2");
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_0_0_3_TrainingT3_Hidebody06", "Speech_0006L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_14', 3, 0, TR_HEADQUARTER, 0, false);
    Jump('Failed');
Failed:
    Log("Failed - HideBody06");
    Close();
Reset:
    Log("Reset - HideBody06");
    QuickSaveLoad(FALSE, TRUE);
    End();
StartPatrol:
    Log("StartPatrol - HideBody06");
    CheckFlags(PatrolStarted,TRUE,'DoNothing');
    CheckIfIsUnconscious(2,'StartPatrol2');
    CheckIfGrabbed(2,'HoldEmTicker');
    End();
HoldEmTicker:
    Log("Ticking every two seconds to see if the guard has been knocked out after being taken conscious into the nook.");
    DisableMessages(TRUE, TRUE);
    CheckIfIsUnconscious(2,'StartPatrol2');
    Sleep(2);
    Jump('HoldEmTicker');
    End();
StartPatrol2:
    Log("StartPatrol2");
    GoalCompleted('HideBody06');
    AddGoal('Hide06B', "", 4, "", "P_0_0_3_TrainingT3_Hidebody06", "Goal_0010L", "Localization\\P_0_0_3_Training", "P_0_0_3_TrainingT3_Hidebody06", "Goal_0011L", "Localization\\P_0_0_3_Training");
    CheckFlags(PatrolStarted,TRUE,'End');
    DisableMessages(FALSE, TRUE);
    SetFlags(PatrolStarted,TRUE);
    Speech(Localize("P_0_0_3_TrainingT3_Hidebody06", "Speech_0007L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_15', 3, 0, TR_HEADQUARTER, 0, false);
    Close();
    Goal_Default(1,GOAL_Patrol,0,,,,'BodySeeker_50',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    DisableMessages(FALSE, FALSE);
    End();
ReachedMidPoint:
    Log("ReachedMidPoint - HideBody06");
    CheckFlags(PatrolStarted,FALSE,'End');
    SetFlags(ReachedMidPoint,TRUE);
    SendUnrealEvent('HideBodyDoor');
    End();
ReachedEndPoint:
    Log("ReachedEndPoint - HideBody06");
    CheckFlags(ReachedMidPoint,TRUE,'Completed');
    End();
WentPastDoor:
    Log("WentPastDoor - HideBody06");
End:
    End();
Cleanup:
    Log("Cleanup - HideBody06");
    Teleport(1, 'NPCTeleport07');
    ResetNPC(1,FALSE);
    Goal_Default(1,GOAL_Guard,9,,,,'NPCTeleport07',,FALSE,,,,);
    Teleport(2, 'NPC2Teleport07');
    ResetNPC(2,FALSE);
    Goal_Default(1,GOAL_Guard,9,,,,'NPC2Teleport07',,FALSE,,,,);
    Teleport(3, 'Lambert07');
    ResetNPC(3,FALSE);
    Goal_Default(3,GOAL_Guard,9,,'PLAYER','PLAYER','Lambert07',,FALSE,,,,);
    End();
Disable:
    Log("Disable - HideBody06");
    DisableMessages(TRUE, FALSE);
    End();
FinaleTeleport:
    Log("Sending Security Guard to finale position");
    Teleport(1, 'SecurityInTeleport');
    ResetGoals(1);
    ChangeState(1,'s_default');
    JumpRandom('ASpot', 0.33, 'BSpot', 0.66, 'CSpot', 1.00, , , , ); 
    End();
ASpot:
    Log("Security guard A Spot behaviour");
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,0,,'ClipboardFocus',,'BodySeekAFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,'ClipboardFocus',,'BodySeekAFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Action,8,,'ClipboardFocus',,'ClipboardFocus','PrsoStNmDD0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    JumpRandom('BSpot', 0.50, 'CSpot', 1.00, , , , , , ); 
    End();
BSpot:
    Log("Security guard B Spot behaviour");
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,0,,'CompFocus',,'BodySeekBFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,'CompFocus',,'BodySeekBFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'RackFocus','RackFocus','RackFocus','MineStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Wait,7,,'RackFocus','RackFocus','RackFocus','MineStNmNt0',FALSE,8,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,6,,'RackFocus','RackFocus','RackFocus','MineStNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    JumpRandom('ASpot', 0.50, 'CSpot', 1.00, , , , , , ); 
    End();
CSpot:
    Log("Security guard C Spot behaviour");
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,0,,'CompFocus',,'BodySeekCFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,'CompFocus',,'BodySeekCFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'CompFocus','CompFocus','CompFocus','KbrdStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Wait,7,,'CompFocus','CompFocus','CompFocus','KbrdStNmNt0',FALSE,6,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,6,,'CompFocus','CompFocus','CompFocus','KbrdStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    JumpRandom('ASpot', 0.50, 'BSpot', 1.00, , , , , , ); 
    End();
ManDown:
    Log("");
    CheckIfIsDead(1,'Murder');
    CheckIfIsDead(2,'Murder');
    End();
Murder:
    SendPatternEvent('T3CommsGroup','BloodyMurder');
DoNothing:
    Log("Doing Nothing");
    End();

}

