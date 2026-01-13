//=============================================================================
// P_1_1_2_Tbilisi_LambertComms
//=============================================================================
class P_1_1_2_Tbilisi_LambertComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Vehicules.uax
#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DoorGoalAdded;


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
    local Light L;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
        if (P.name == 'EAnna0')
            Characters[2] = P.controller;
    }

    // Joshua - Removing HeatRadius from all light actors
    if (!bInit)
    {
        ForEach AllActors(Class'Light', L)
        {
            if (L.name == 'ELight100' || L.name == 'ELight101' || L.name == 'Light29' ||
                L.name == 'Light23' || L.name == 'Light31' || L.name == 'Light24')
            {
                L.HeatRadius = 0;
            }
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    DoorGoalAdded=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is the pattern for Lamberts communications");
OpenDoor:
    Log("Sam has opened the door to the Precinct.");
    CheckFlags(DoorGoalAdded,TRUE,'DoNothing');
    SetFlags(DoorGoalAdded,TRUE);
    GoalCompleted('PRECINCT');
    AddGoal('BLAUSTEIN', "", 4, "", "P_1_1_2_Tbilisi_LambertComms", "Goal_0054L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_LambertComms", "Goal_0055L", "Localization\\P_1_1_2Tbilisi");
    End();
AtStation:
    Log("Sam has located the bodies.");
    SetFlags(V1_1_2Tbilisi(Level.VarObject).BodyFound,TRUE);
    GoalCompleted('BLAUSTEIN');
    AddGoal('ACCESS', "", 3, "", "P_1_1_2_Tbilisi_LambertComms", "Goal_0038L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_LambertComms", "Goal_0048L", "Localization\\P_1_1_2Tbilisi");
    AddNote("", "P_1_1_2_Tbilisi_LambertComms", "Note_0039L", "Localization\\P_1_1_2Tbilisi");
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0023L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_30_01', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0024L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_30_02', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0025L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_30_03', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0026L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_30_04', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0027L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_30_05', 0, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0028L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_30_06', 1, 1, TR_HEADQUARTER, 0, false);
    Close();
    CheckFlags(V1_1_2Tbilisi(Level.VarObject).GotTape,TRUE,'OpenSaysMe');
    End();
InSecurityRoom:
    Log("Sam has the tapes for the morgue cameras.");
    SendUnrealEvent('OpenCopGates');
    SendUnrealEvent('VanTriggerVolume');
    SetFlags(V1_1_2Tbilisi(Level.VarObject).GateOpen,TRUE);
    GoalCompleted('ACCESS');
    IgnoreAlarmStage(TRUE);
    AddGoal('EXTRACT', "", 2, "", "P_1_1_2_Tbilisi_LambertComms", "Goal_0040L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_LambertComms", "Goal_0049L", "Localization\\P_1_1_2Tbilisi");
    AddNote("", "P_1_1_2_Tbilisi_LambertComms", "Note_0041L", "Localization\\P_1_1_2Tbilisi");
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0030L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_35_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0031L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_35_02', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0032L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_35_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0033L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_35_04', 2, 1, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0034L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_2Voice.Play_11_35_05', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
MeetWilkes:
    Log("Sam has met with Wilkes on the street.");
    Close();
    SendUnrealEvent('VanTriggerVolume');
    CheckFlags(V1_1_2Tbilisi(Level.VarObject).GateOpen,FALSE,'DoNothing');
    SendUnrealEvent('MissionCompleteTrigger');
    SendUnrealEvent('WilkesVanStart');
	PlaySound(Sound'Vehicules.Play_EchelonVanStart', SLOT_Ambient);
    Sleep(2);
	PlaySound(Sound'Vehicules.Play_EchelonVanStop', SLOT_Ambient);
    End();
MissionComplete:
    Log("Mission is completed");
    PlayerMove(false);
    GoalCompleted('EXTRACT');
    GameOver(true, 0);
    End();
Murder:
    Log("Sam has killed a civilian");
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    CheckFlags(VGame(EchelonGameInfo(Level.Game).VarObject).GameVar1,TRUE,'SecondKilled');
    SetFlags(VGame(EchelonGameInfo(Level.Game).VarObject).GameVar1,TRUE);
    SetExclusivity(FALSE);
    DisableMessages(FALSE, FALSE);
    Sleep(2);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0042L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_Voice.Play_11_90_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
SecondKilled:
    Log("");
    SetProfileDeletion();
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Sleep(2);
    Speech(Localize("P_1_1_2_Tbilisi_LambertComms", "Speech_0050L", "Localization\\P_1_1_2Tbilisi"), Sound'S1_1_Voice.Play_11_90_02', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 2);
    End();
Ending:
    Log("Checking to see if its okay to send in Wilkes and end level.");
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

