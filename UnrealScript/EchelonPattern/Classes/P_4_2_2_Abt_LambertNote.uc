//=============================================================================
// P_4_2_2_Abt_LambertNote
//=============================================================================
class P_4_2_2_Abt_LambertNote extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S4_2_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int LongDanPass1;
var int pass1;


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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'ELongDan0')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EGrinko0')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    LongDanPass1=0;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
LonDanTalk:
    Log("");
    Jump('MeetLongDan');
JumpLongDanMove:
    Log("");
    CheckFlags(LongDanPass1,TRUE,'Fin');
    Jump('MeetLongDan');
LambertStart:
    Log("Lambert comm while in the van in the begining.");
MeetLongDan:
    Log("Meet Long Dan");
    Talk(Sound'S4_2_2Voice.Play_42_50_01', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_50_02', 0, , TRUE, 0);
    GoalCompleted('LocateSoldier');
    ResetGoals(2);
    Goal_Default(2,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S4_2_2Voice.Play_42_50_03', 2, , TRUE, 0);
    Goal_Default(2,GOAL_Action,8,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S4_2_2Voice.Play_42_50_04', 0, , TRUE, 0);
    Goal_Default(2,GOAL_Action,7,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S4_2_2Voice.Play_42_50_05', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_50_06', 0, , TRUE, 0);
    Goal_Default(2,GOAL_Action,5,,,,,'TalkStNmDD0',FALSE,,,,);
    Talk(Sound'S4_2_2Voice.Play_42_50_07', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_50_08', 0, , TRUE, 0);
    Goal_Default(2,GOAL_Action,4,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S4_2_2Voice.Play_42_50_09', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_50_10', 0, , TRUE, 0);
    Goal_Default(2,GOAL_Action,3,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S4_2_2Voice.Play_42_50_11', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_50_12', 0, , TRUE, 0);
    Goal_Default(2,GOAL_Action,2,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S4_2_2Voice.Play_42_50_13', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_50_14', 0, , TRUE, 0);
    Goal_Default(2,GOAL_Action,1,,,,,'LstnStNmBB0',FALSE,,,,);
blam2:
    Talk(Sound'S4_2_2Voice.Play_42_50_15', 2, , TRUE, 0);
    EndConversation();
SkipLD:
    AddNote("", "P_4_2_2_Abt_LambertNote", "Note_0039L", "Localization\\P_4_2_2_Abattoir");
    Sleep(0.5);
    SendUnrealEvent('EVolume5');
    Sleep(0.5);
    SendPatternEvent('EGroupAI24','Main');
    End();
LongDanMove:
    Log("");
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,'PathNode322',,'PathNode480',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'PathNode322',,'PathNode480',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
KillGrinko:
    Log("Lambert tell Sam he need to kill grinko");
    Sleep(0.5);
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).GDstopLambertGoal,TRUE,'Fin');
    AddGoal('KillGrinko', "", 1, "", "P_4_2_2_Abt_LambertNote", "Goal_0054L", "Localization\\P_4_2_2_Abattoir", "P_4_2_2_Abt_LambertNote", "Goal_0055L", "Localization\\P_4_2_2_Abattoir");
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0029L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_56_01', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0030L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_56_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0031L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_56_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0032L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_56_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0033L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_56_05', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Fin:
    Log("");
    End();
HostageDEAD:
    Log("");
HostageSam:
    Log("");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0048L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_Voice.Play_42_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
HostageSoldier:
    Log("HostageSoldier");
    DisableMessages(TRUE, TRUE);
    Sleep(0.5);
cam1:
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).HostageType,TRUE,'cam2');
    CinCamera(0, 'EFocusPoint74', 'EFocusPoint75',);
    Jump('JumpCam');
cam2:
    Log("");
    CinCamera(0, 'EFocusPoint20', 'EFocusPoint19',);
JumpCam:
    Log("");
    SetProfileDeletion();
    Sleep(3);
    CinCamera(1, , ,);
    PlayerMove(false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0060L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_68_01', 1, 0, TR_HEADQUARTER, 0, true);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0061L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_68_02', 0, 0, TR_HEADQUARTER, 0, true);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0062L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_68_03', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    Sleep(0.5);
    GameOver(false, 0);
    End();
LambertLastCall:
    Log("");
    GoalCompleted('ProtectHostages');
    Sleep(1.5);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0049L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_75_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0050L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_75_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0051L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_75_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_2_Abt_LambertNote", "Speech_0052L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_75_04', 0, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(true, 0);
    End();

}

