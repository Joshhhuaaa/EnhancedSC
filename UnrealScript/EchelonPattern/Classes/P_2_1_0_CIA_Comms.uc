//=============================================================================
// P_2_1_0_CIA_Comms
//=============================================================================
class P_2_1_0_CIA_Comms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_0Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Machine.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyRestarted;
var int FanSuccess;


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
        if (P.name == 'ELambert1')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'EFanBladeCIA2')
            SoundActors[0] = A;
    }

    // Joshua - Adjusting timer for Elite mode
    if (IsEliteMode())
    {
        ForEach AllActors(class'ETimer', Timer)
        {
            if (Timer.Name == 'ETimer1')
                Timer.TimerDelay = 60.0; // 100.0
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    AlreadyRestarted=0;
    FanSuccess=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    // Joshua - Enhanced change: CIA HQ is a one alarm level until accessing the central server (Elite difficulty)
    if (IsEliteMode())
        EchelonLevelInfo(Level).bOneAlarmLevel = true;
    Log("");
    Sleep(2.5);
    SendUnrealEvent('VentFan5');
    SendUnrealEvent('CleanMover');
    SendUnrealEvent('EElevatorButton7');
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0045L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_05_01', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('GoalServer', "", 8, "", "P_2_1_0_CIA_Comms", "Goal_0046L", "Localization\\P_2_1_0CIA", "P_2_1_0_CIA_Comms", "Goal_0047L", "Localization\\P_2_1_0CIA");
    AddGoal('GoalFatality', "", 10, "", "P_2_1_0_CIA_Comms", "Goal_0048L", "Localization\\P_2_1_0CIA", "P_2_1_0_CIA_Comms", "Goal_0049L", "Localization\\P_2_1_0CIA");
    if (IsEliteMode()) // Joshua - Enhanced change: Removing the one alarm limit, player has accessed CIA central server
        AddGoal('GoalAlarm', "", 6, "", "P_2_1_0_CIA_Comms", "Goal_0050L", "Localization\\P_2_1_0CIA", "P_2_1_0_CIA_Comms", "Goal_0051L", "Localization\\P_2_1_0CIA");
    AddNote("", "P_2_1_0_CIA_Comms", "Note_0050L", "Localization\\P_2_1_0CIA");
Notetvsion:
    AddNote("", "P_2_1_0_CIA_Comms", "Note_0068L", "Localization\\P_2_1_0CIA");
    AddRecon(class 'EReconMapCIA1');
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0002L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_05_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0003L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_05_03', 1, 1, TR_HEADQUARTER, 0, false);
    Close();
FanStop:
    Log("");
    Sleep(3);
BeginFanTimer:
    SendUnrealEvent('FanStop');
    SendUnrealEvent('FanReStart');
    Sleep(1);
blam3:
    Log("");
    SendUnrealEvent('EElevatorButton1');
    SendUnrealEvent('EElevatorButton5');
    SendUnrealEvent('EElevatorButton6');
    SendUnrealEvent('EElevatorButton7');
    End();
FanReStart:
    Log("");
    CheckFlags(AlreadyRestarted,TRUE,'FanMissEnd');
    SetFlags(AlreadyRestarted,TRUE);
    SendUnrealEvent('VentFan1');
	SoundActors[0].    PlaySound(Sound'Machine.Play_BigFanStart', SLOT_SFX);
	SoundActors[0].    PlaySound(Sound'Machine.Play_BigFan', SLOT_SFX);
    End();
FanSuccess:
    Log("Sam gets past the fan");
    SetFlags(FanSuccess,TRUE);
    Sleep(0.25);
    SendUnrealEvent('FanStop');
    Jump('FanReStart');
    End();
FanMiss:
    Log("");
    CheckFlags(FanSuccess,TRUE,'FanMissEnd');
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0017L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_06_01', 1, 1, TR_HEADQUARTER, 0, false);
    AddNote("", "P_2_1_0_CIA_Comms", "Note_0052L", "Localization\\P_2_1_0CIA");
    Close();
FanMissEnd:
    End();
StopItsOver:
    Log("StopItsOver");
    Close();
    DisableMessages(TRUE, TRUE);
    End();

}

