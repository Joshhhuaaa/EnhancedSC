//=============================================================================
// P_4_1_2_CEmb_WTF
//=============================================================================
class P_4_1_2_CEmb_WTF extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Lambert.uax
#exec OBJ LOAD FILE=..\Sounds\S4_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DogAlreadyDead;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('LaserMicFailure');
            break;
        case AI_DEAD:
            EventJump('WTF');
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
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'ERottweiler0')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    DogAlreadyDead=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
WTF:
    Log("Play this event when Fisher acts like an ass and shoots someone or gets shot.");
    CheckFlags(DogAlreadyDead,TRUE,'ImportantMemberDied');
    CheckIfIsDead(2,'SetDogDead');
    Jump('ImportantMemberDied');
    End();
SetDogDead:
    Log("SetDogDead");
    SetFlags(DogAlreadyDead,TRUE);
    End();
ImportantMemberDied:
    Log("ImportantMemberDied");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0001L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'Lambert.Play_41_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
LambertTruckWarning:
    Log("LambertTruckWarning");
    Sleep(1);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0039L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_21_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0040L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_21_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0041L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_21_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    AddGoal('4_1_15', "", 10, "", "P_4_1_2_CEmb_WTF", "Goal_0042L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_WTF", "Goal_0043L", "Localization\\P_4_1_2ChineseEmbassy");
    // Joshua - Lambert says one alarm and the mission's over (improved for Alarm HUD)
    SetAlarmStage(0);
    EchelonLevelInfo(Level).bOneAlarmLevel = true;
    End();
FeirongFirstLamCall:
    Log("FeirongFirstLamCall");
    Sleep(3);
    GoalCompleted('4_1_2');
    AddGoal('4_1_4', "", 3, "", "P_4_1_2_CEmb_WTF", "Goal_0028L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_WTF", "Goal_0035L", "Localization\\P_4_1_2ChineseEmbassy");
    AddGoal('4_1_20', "", 4, "", "P_4_1_2_CEmb_WTF", "Goal_0029L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_WTF", "Goal_0036L", "Localization\\P_4_1_2ChineseEmbassy");
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0008L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_25_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0009L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_25_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0010L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_25_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0013L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_25_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0014L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_25_05', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
FeirongSecondLamCall:
    Log("FeirongSecondLamCall");
    GoalCompleted('4_1_4');
    GoalCompleted('4_1_20');
    GoalCompleted('4_1_15');
    AddGoal('4_1_5', "", 5, "", "P_4_1_2_CEmb_WTF", "Goal_0030L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_WTF", "Goal_0037L", "Localization\\P_4_1_2ChineseEmbassy");
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0017L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_40_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0018L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_40_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0019L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_40_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0020L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_40_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0021L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_40_05', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0022L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_40_06', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0023L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_40_07', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    IgnoreAlarmStage(TRUE);
    End();
LaserMicFailure:
    Log("LaserMicFailure");
    CheckFlags(V4_1_2ChineseEmbassy(Level.VarObject).LastMikDone,TRUE,'End');
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0025L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_96_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
End:
    End();
LaserMicFailureB:
    Log("LaserMicFailureB");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0038L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_38_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 6);
    End();
GameOver:
    Log("Game Over   -  Follow truck");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0044L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_19_01', 1, 0, TR_HEADQUARTER, 0, true);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0045L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_19_02', 0, 0, TR_HEADQUARTER, 0, true);
    Speech(Localize("P_4_1_2_CEmb_WTF", "Speech_0046L", "Localization\\P_4_1_2ChineseEmbassy"), Sound'S4_1_2Voice.Play_41_19_03', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
PositionIn:
    Log("PositionIn");
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).GatePosition,TRUE);
    End();
PositionOut:
    Log("PositionOut");
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).GatePosition,FALSE);
    End();

}

