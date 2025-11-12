//=============================================================================
// P_1_2_1DefMin_ColonelJob
//=============================================================================
class P_1_2_1DefMin_ColonelJob extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int ColAlert;
var int DoorUnlocked;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ColDead');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('AlarmRun');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('AlarmRun');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AlarmRun');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('AlarmRun');
            break;
        case AI_UNCONSCIOUS:
            EventJump('ColDead');
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
        if (P.name == 'EAzeriColonel0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
        if (P.name == 'ELambert0')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    ColAlert=0;
    DoorUnlocked=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneColonelJob");
    SendUnrealEvent('KitchenAeration');
    SendUnrealEvent('ColVolForSafe');
    Teleport(1, 'ColoSafeTelA');
    Sleep(0.50);
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'CaptainHelper_500',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,8,,,,'NodeTochairrr',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,7,,,,'ColTrone',,TRUE,,MOVE_Sit,,MOVE_Sit);
    Goal_Default(1,GOAL_Wait,6,,,,'ColTrone','WaitAsNmFd0',FALSE,,MOVE_Sit,,MOVE_Sit);
    End();
DoorFlag:
    Log("DoorFlag");
    SetFlags(DoorUnlocked,TRUE);
    End();
AlarmRun:
    Log("AlarmRun");
    CheckFlags(DoorUnlocked,TRUE,'GoFalse');
    SetFlags(ColAlert,TRUE);
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,TRUE,,,,);
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'VCtoAlarmBoxC',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_InteractWith,8,,,,'EAlarmPanelColonelBound',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_InteractWith,);
    ResetGoals(1);
    SetExclusivity(FALSE);
    End();
ColDead:
    Log("ColDead");
    CheckFlags(DoorUnlocked,TRUE,'End');
    SetProfileDeletion();
    SendPatternEvent('LaserDoneBogusGroup','LamTalkOff');
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_2_1DefMin_ColonelJob", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_1_Voice.Play_11_95_01', 2, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
End:
    Log("End");
    End();
HintRetinal:
    Log("HintRetinal");
    Speech(Localize("P_1_2_1DefMin_ColonelJob", "Speech_0002L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_21_01', 1, 0, TR_NPCS, 0, false);
    AddNote("", "P_1_2_1DefMin_ColonelJob", "Note_0003L", "Localization\\P_1_2_1DefenseMinistry");
    Speech(Localize("P_1_2_1DefMin_ColonelJob", "Speech_0004L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_21_02', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_1_2_1DefMin_ColonelJob", "Speech_0005L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_21_03', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
GoFalse:
    Log("GoFalse");
    SetExclusivity(FALSE);
    End();

}

