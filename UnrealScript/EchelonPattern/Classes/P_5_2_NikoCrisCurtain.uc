//=============================================================================
// P_5_2_NikoCrisCurtain
//=============================================================================
class P_5_2_NikoCrisCurtain extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CutSceneDone;
var int NikoDeadNow;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('DeadBase');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('NikoOnlyKnockedOrRiccochet');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('NikoOnlyKnockedOrRiccochet');
            break;
        case AI_UNCONSCIOUS:
            EventJump('NikoOnlyKnockedOrRiccochet');
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
        if (P.name == 'EEliteForceCristavi8')
            Characters[1] = P.controller;
        if (P.name == 'ELambert0')
            Characters[2] = P.controller;
        if (P.name == 'EFikrat0')
            Characters[3] = P.controller;
        if (P.name == 'ENikoladze2')
        {
            Characters[4] = P.controller;
            EAIController(Characters[4]).bAllowKill = true;
            EAIController(Characters[4]).bAllowKnockout = true;
            EAIController(Characters[4]).bWasFound = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    CutSceneDone=0;
    NikoDeadNow=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    Goal_Set(3,GOAL_MoveTo,9,,,,'CrisPreChairAa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Wait,8,,'NikoToMorgue','NikoToMorgue','ChaiseHauteCris','TalkAsNmBB0',FALSE,,MOVE_Sit,,MOVE_Sit);
    Goal_Set(4,GOAL_MoveTo,9,,,,'NikoLastNodee',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(4,GOAL_Wait,8,,'Cristavi','Cristavi','ChaiseHauteNiko','TalkAsNmAA0',FALSE,,MOVE_Sit,,MOVE_Sit);
    Sleep(0.50);
    CinCamera(0, 'CameraPosOne', 'CameraFocOne',);
    Sleep(3);
    CinCamera(0, 'segonneCAMcsnik', 'CameraFocOne',);
    Sleep(8);
    CinCamera(1, , ,);
    SetFlags(CutSceneDone,TRUE);
    Sleep(1);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0023L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_61_01', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    Sleep(1);
    LaserMicSession(0,'MikWin',0,'');
    Talk(Sound'S5_1_2Voice.Play_51_69_01', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_69_02', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_69_03', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_69_04', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_69_05', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_01', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_02', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_03', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_04', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_05', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_06', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_07', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_08', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_09', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_10', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_11', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_12', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_13', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_14', 4, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_15', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_70_16', 4, , TRUE, 0);
    LaserMicSession(1,,100,'SlowLeaving');
    Jump('SlowLeaving');
    End();
DeadBase:
    Log("DeadBase");
    CheckFlags(NikoDeadNow,TRUE,'IsCrisDead');
    CheckIfIsDead(4,'NikoFinallyDead');
IsCrisDead:
    CheckIfIsDead(3,'CrisDied');
    Jump('NikoOnlyKnockedOrRiccochet');
    End();
NikoFinallyDead:
    Log("NikoFinallyDead");
    LaserMicSession(1,,100,'SlowLeaving');
    Close();
    GoalCompleted('5_1_6');
    IgnoreAlarmStage(TRUE);
    DisableMessages(TRUE, FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    LockDoor('KitDoorToExtr', FALSE, TRUE);
    SetFlags(NikoDeadNow,TRUE);
    SetFlags(V5_1_2_PresidentialPalace(Level.VarObject).NikoDEAD,TRUE);
    SendPatternEvent('DoorOpener','Milestone');
    Sleep(1);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0001L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_80_01', 2, 0, TR_HEADQUARTER, 0, false);
    CheckIfIsDead(3,'CrisDiedAfter'); // Joshua - Check one more time if Cristavi is dead
    SendPatternEvent('Courtyard','NoExtra');
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0008L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_80_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0009L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_80_03', 2, 2, TR_HEADQUARTER, 0, false);
    AddGoal('5_1_7', "", 1, "", "P_5_2_NikoCrisCurtain", "Goal_0002L", "Localization\\P_5_1_2_PresidentialPalace", "P_5_2_NikoCrisCurtain", "Goal_0022L", "Localization\\P_5_1_2_PresidentialPalace");
    Close();
    Sleep(2);
firstset:
    Log("firstset");
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0010L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_01', 1, 0, TR_NPCS, 0, false);
    Sleep(3);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0011L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_02', 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0012L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_03', 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0013L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_04', 1, 0, TR_NPCS, 0, false);
    Sleep(5);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0014L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_05', 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0015L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_06', 1, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0024L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_07', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0016L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_08', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0017L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_09', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0018L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_10', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0019L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_11', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0020L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_12', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0021L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_81_13', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
NikoOnlyKnockedOrRiccochet:
    Log("NikoOnlyKnockedOrRiccochet");
    CheckFlags(CutSceneDone,FALSE,'End');
    LaserMicSession(1,,100,'SlowLeaving');
    Close();
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
SlowLeaving:
    Log("SlowLeaving");
    Close();
    ResetGroupGoals();
    ChangeGroupState('s_investigate');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(4,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
CrisDied:
    Log("CrisDied");
    LaserMicSession(1,,100,'SlowLeaving');
    Close();
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,9,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Guard,8,,,,'ShotInCrisWinHidHereA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    PlayerMove(false);
    Speech(Localize("P_5_2_NikoCrisCurtain", "Speech_0005L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_72_01', 2, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
CrisDiedAfter: // Joshua - Check one more time if Cristavi is dead
    Log("CrisDiedAfter");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_5_2_GoalUpdate", "Speech_0014L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_Voice.Play_51_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
End:
    End();

}

