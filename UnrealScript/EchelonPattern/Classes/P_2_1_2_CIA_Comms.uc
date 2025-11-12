//=============================================================================
// P_2_1_2_CIA_Comms
//=============================================================================
class P_2_1_2_CIA_Comms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S2_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Addedcommentplayed;
var int chatdone;
var int pass1;


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
        if (P.name == 'ELambert7')
            Characters[1] = P.controller;
        if (P.name == 'EMitch7')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    Addedcommentplayed=0;
    chatdone=0;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Hack:
    Log("Hack");
    SetFlags(V2_1_2CIA(Level.VarObject).mitchcomp,TRUE);
    SendUnrealEvent('FirstCheckP');
    SendUnrealEvent('OutCheck');
    SendUnrealEvent('DeleteVolumeCola');
    SendPatternEvent('EGroupAI2','Start');
    SendPatternEvent('mediagroup','DropIT');
    GoalCompleted('GoalPC');
    AddNote("", "P_2_1_2_CIA_Comms", "Note_0086L", "Localization\\P_2_1_2CIA");
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0001L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_30_01', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0002L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_30_02', 1, 1, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0003L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_30_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(1);
    SetFlags(V2_1_2CIA(Level.VarObject).ordertokidnap,TRUE);
    AddGoal('GoalKidnapA', "", 4, "", "P_2_1_2_CIA_Comms", "Goal_0083L", "Localization\\P_2_1_2CIA", "P_2_1_2_CIA_Comms", "Goal_0084L", "Localization\\P_2_1_2CIA");
    AddNote("", "P_2_1_2_CIA_Comms", "Note_0085L", "Localization\\P_2_1_2CIA");
    SetFlags(V2_1_2CIA(Level.VarObject).LambertTalks,TRUE);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0067L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_31_01', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0071L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_31_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0072L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_31_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    SetFlags(V2_1_2CIA(Level.VarObject).LambertTalks,FALSE);
    End();
TheBaxterGuy:
    Log("");
    CheckFlags(Addedcommentplayed,TRUE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).MitchReachSmoke,TRUE,'ProceedBaxterGuy');
    Jump('AddedLambertComment');
    End();
ProceedBaxterGuy:
    Log("ProceedBaxterGuy");
    CheckIfGrabbed(2,'ProceedFurtherBaxterGuy');
    CheckIfIsUnconscious(2,'ProceedFurtherBaxterGuy');
    End();
ProceedFurtherBaxterGuy:
    Log("ProceedFurtherBaxterGuy");
    CheckFlags(pass1,TRUE,'JumpFin');
    SetFlags(pass1,TRUE);
    AddGoal('GoalKidnapB', "", 3, "", "P_2_1_2_CIA_Comms", "Goal_0076L", "Localization\\P_2_1_2CIA", "P_2_1_2_CIA_Comms", "Goal_0077L", "Localization\\P_2_1_2CIA");
    AddRecon(class 'EReconPicJackBaxter');
    AddRecon(class 'EReconFullTextJackBaxter');
    SendPatternEvent('Van_conversation','TelGuys');
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0080L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_32_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    DisableMessages(FALSE, FALSE);
    End();
JumpFin:
    Log("JumpFinComms");
    End();
start_chatty_cia_cop:
    Log("Lambert tells Sam about the cop and wilkes situation ");
    CheckFlags(V2_1_2CIA(Level.VarObject).ordertokidnap,FALSE,'JumpFin');
    CheckIfIsUnconscious(2,'ProceedChatyy');
    CheckIfGrabbed(2,'ProceedChatyy');
    End();
ProceedChatyy:
    Log("ProceedChatyy");
    CheckFlags(chatdone,TRUE,'JumpFin');
    SetFlags(chatdone,TRUE);
    DisableMessages(TRUE, TRUE);
    AddGoal('GoalCop', "", 2, "", "P_2_1_2_CIA_Comms", "Goal_0078L", "Localization\\P_2_1_2CIA", "P_2_1_2_CIA_Comms", "Goal_0079L", "Localization\\P_2_1_2CIA");
    SendUnrealEvent('WareHouseSave');
    SendPatternEvent('EGroupAI1','DickTel');
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0081L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_41_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0021L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_41_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0022L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_41_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0023L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_41_04', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0024L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_41_05', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    DisableMessages(FALSE, FALSE);
    End();
SetupPart2:
    Log("setup goal for part2");
    Sleep(1);
    AddRecon(class 'EReconPicMitDoughert');
    AddRecon(class 'EReconFullTextMitDoughert');
    AddNote("", "P_2_1_2_CIA_Comms", "Note_0052L", "Localization\\P_2_1_2CIA");
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0063L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_24_01', 1, 1, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0064L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_24_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0065L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_24_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
MitchKO:
    Log("sam grab mitch to early");
    CheckFlags(V2_1_2CIA(Level.VarObject).ordertokidnap,TRUE,'TheBaxterGuy');
FromWilkesAndBaxterKO:
    Log("FromWilkesAndBaxterKOorKillDough");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0055L", "Localization\\P_2_1_2CIA"), Sound'S2_1_Voice.Play_21_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
AddedLambertComment:
    Log("AddedLambertComment");
    CheckIfIsUnconscious(2,'ProceedAddComm');
    CheckIfGrabbed(2,'ProceedAddComm');
    End();
ProceedAddComm:
    Log("ProceedAddComm");
    SetFlags(Addedcommentplayed,TRUE);
    Speech(Localize("P_2_1_2_CIA_Comms", "Speech_0082L", "Localization\\P_2_1_2CIA"), Sound'S2_1_2Voice.Play_21_96_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
StopPatternItsOver:
    Log("StopPatternItsOver");
    Close();
    DisableMessages(TRUE, TRUE);
    End();

}

