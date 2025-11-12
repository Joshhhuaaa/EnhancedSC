//=============================================================================
// P_1_7_1_2_LambertGoals
//=============================================================================
class P_1_7_1_2_LambertGoals extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S3_1_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S3_3_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Door.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int SubWentDown;
var int TorpedoDoorOpen;


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
    local Actor A;
    local ETimer Timer; // Joshua - Adjusting timer for Elite mode

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EFalseRussianSoldier1')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'ESoundTrigger0')
            SoundActors[0] = A;
        if (A.name == 'ESoundTrigger1')
            SoundActors[1] = A;
    }

    // Joshua - Adjusting timer for Elite mode
    if (IsEliteMode())
    {
        ForEach AllActors(class'ETimer', Timer)
        {
            if (Timer.Name == 'ETimer0')
                Timer.TimerDelay = 120.0; // 150.0
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    SubWentDown=0;
    TorpedoDoorOpen=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SubEnteredLambertGoals:
    Log("SubEnteredLambertGoals");
    SendUnrealEvent('TorpedoDoorZX');
    AddGoal('LOCK', "", 3, "", "P_1_7_1_2_LambertGoals", "Goal_0039L", "Localization\\P_1_7_1_2Vselka", "P_1_7_1_2_LambertGoals", "Goal_0040L", "Localization\\P_1_7_1_2Vselka");
    AddGoal('TRACE', "", 4, "", "P_1_7_1_2_LambertGoals", "Goal_0018L", "Localization\\P_1_7_1_2Vselka", "P_1_7_1_2_LambertGoals", "Goal_0019L", "Localization\\P_1_7_1_2Vselka");
    AddNote("", "P_1_7_1_2_LambertGoals", "Note_0042L", "Localization\\P_1_7_1_2Vselka");
    AddNote("", "P_1_7_1_2_LambertGoals", "Note_0043L", "Localization\\P_1_7_1_2Vselka");
    Speech(Localize("P_1_7_1_2_LambertGoals", "Speech_0020L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_1_1Voice.Play_31_28_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_2_LambertGoals", "Speech_0021L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_1_1Voice.Play_31_28_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_2_LambertGoals", "Speech_0022L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_1_1Voice.Play_31_28_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
LightsOneLambertGoals:
    Log("LightsOneLambertGoals");
    Sleep(3);
    SendUnrealEvent('LigCasA');
    Sleep(0.5);
    SendUnrealEvent('LigCasB');
    Sleep(0.2);
    SendUnrealEvent('LigCasC');
    End();
HackedLambertGoals:
    Log("HackedLambertGoals");
    Sleep(1);
    IgnoreAlarmStage(TRUE);
    SendUnrealEvent('DisableFirstPart');
    SendUnrealEvent('ServerDoor');
    SendPatternEvent('FirstPatrol','TelFirstPatrol');
    SendPatternEvent('GoodDorms','TelGoodDorms');
    SendPatternEvent('Flashers','TelFlashers');
    SendPatternEvent('BeforeCargo','TelBeforeCargo');
    SendPatternEvent('CargoGuys','TelCargoGuys');
    SendPatternEvent('Kitchen','TelKitchen');
    SendPatternEvent('DormsTeam','TelDormsTeam');
    SendPatternEvent('BottomThree','TelBottomThree');
    SendPatternEvent('PreControl','TelPreControl');
    SendPatternEvent('BridgeLazies','TelBridgeLazies');
    GoalCompleted('TRACE');
    Speech(Localize("P_1_7_1_2_LambertGoals", "Speech_0037L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_1_2Voice.Play_31_35_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_2_LambertGoals", "Speech_0038L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_1_2Voice.Play_31_35_02', 1, 0, TR_HEADQUARTER, 0, false);
    SendUnrealEvent('TrappedLS');
    Sleep(1);
    Speech(Localize("P_1_7_1_2_LambertGoals", "Speech_0025L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_1_2Voice.Play_31_35_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_2_LambertGoals", "Speech_0028L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_3_2Voice.Play_33_54_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    ShakeCamera(380, 10700, 310);
	SoundActors[0].    PlaySound(None, SLOT_Ambient);
    Sleep(5);
    AddNote("", "P_1_7_1_2_LambertGoals", "Note_0032L", "Localization\\P_1_7_1_2Vselka");
    AddGoal('TORPEDO', "", 1, "", "P_1_7_1_2_LambertGoals", "Goal_0033L", "Localization\\P_1_7_1_2Vselka", "P_1_7_1_2_LambertGoals", "Goal_0034L", "Localization\\P_1_7_1_2Vselka");
    AddGoal('RUN', "", 2, "", "P_1_7_1_2_LambertGoals", "Goal_0035L", "Localization\\P_1_7_1_2Vselka", "P_1_7_1_2_LambertGoals", "Goal_0036L", "Localization\\P_1_7_1_2Vselka");
    SetFlags(SubWentDown,TRUE);
    SendPatternEvent('Trapped','MilestoneTrapped');
    End();
TorpedoDoorLambertGoals:
    Log("TorpedoDoorLambertGoals");
    CheckFlags(SubWentDown,FALSE,'End');
    CheckFlags(TorpedoDoorOpen,TRUE,'End');
    CinCamera(0, 'GameOverCSpos', 'GameOverCSfoc',);
    Sleep(1);
	SoundActors[1].    PlaySound(Sound'Door.Play_SubDoorOpen', SLOT_SFX);
    SendUnrealEvent('TorpedoDoor');
    Sleep(4);
    CinCamera(1, , ,);
    SendUnrealEvent('TorpedoDoorZX');
    GoalCompleted('TORPEDO');
    SetFlags(TorpedoDoorOpen,TRUE);
    SendUnrealEvent('AllLightsOff');
    SendUnrealEvent('AlarmLightsOn');
    SendPatternEvent('TorpedoDefendA','MilestoneTorpedoDefendA');
    SendPatternEvent('TorpedoDefendB','MilestoneTorpedoDefendB');
    SendPatternEvent('TorpedoDefendC','MilestoneTorpedoDefendC');
    SendPatternEvent('TorpedoGizmo','SpeechTorpedoGizmo');
    End();
ClosingTorpedoLambertGoals:
    Log("ClosingTorpedoLambertGoals");
    CinCamera(0, 'GameOverCSpos', 'GameOverCSfoc',);
    Sleep(1.5);
    SendUnrealEvent('TorpedoCriticalHatch');
MissedTorpedoLambertGoals:
    Log("MissedTorpedoLambertGoals");
    SetProfileDeletion();
    GameOver(false, 6);
    End();
CompleteLambertGoals:
    Log("CompleteLambertGoals");
    GoalCompleted('RUN');
    GameOver(true, 0);
End:
    End();

}

defaultproperties
{
}
