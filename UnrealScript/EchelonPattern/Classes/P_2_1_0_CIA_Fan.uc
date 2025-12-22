//=============================================================================
// P_2_1_0_CIA_Fan
//=============================================================================
class P_2_1_0_CIA_Fan extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_0Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Machine.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyRestarted;
var int FanSuccess;
var int TimerStarted;


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
    local EVolume Volume;

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

    if (!bInit)
    {
        // Joshua - Prevent both checkpoints from being triggered
        EVolume(GetMatchingActor('FromFirst')).bIsAnEventtrigger = true;
        EVolume(GetMatchingActor('FromFirst')).bTriggerOnlyOnce = true;
        EVolume(GetMatchingActor('FromFirst')).GroupTag = 'FanSystem';
        EVolume(GetMatchingActor('FromFirst')).JumpLabel = 'FanSave';
        EVolume(GetMatchingActor('FromSecond')).bIsAnEventtrigger = true;
        EVolume(GetMatchingActor('FromSecond')).bTriggerOnlyOnce = true;
        EVolume(GetMatchingActor('FromSecond')).GroupTag = 'FanSystem';
        EVolume(GetMatchingActor('FromSecond')).JumpLabel = 'TrapSave';


        ForEach AllActors(class'EVolume', Volume)
        {
            if (Volume.name == 'EVolume2' || Volume.name == 'EVolume4')
            {
                Volume.GroupTag = 'FanSystem';
            }
        }
    
        // Joshua - Adjusting timer for Elite mode
        if (IsEliteMode())
        {
            ForEach AllActors(class'ETimer', Timer)
            {
                if (Timer.Name == 'ETimer0')
                {
                    Timer.TimerDelay = 59.0; // 99.0
                    Timer.CriticalDelay = 10.0; // Timer goes red if under 10 seconds
                    Timer.GroupTag = 'FanSystem';
                }
                if (Timer.Name == 'ETimer1')
                {
                    Timer.TimerDelay = 60.0; // 100.0
                    Timer.CriticalDelay = 10.0; // Timer goes red if under 10 seconds
                    Timer.GroupTag = 'FanSystem';
                }
            }
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    AlreadyRestarted=0;
    FanSuccess=0;
    TimerStarted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{
Begin: // Joshua – Moved fan logic from P_2_1_0_CIA_Comms to avoid a bug where early events could lock the dialogue box
    Sleep(0.1);
FanStop:
    Log("");
    CheckFlags(V2_1_0CIA(Level.VarObject).LambertIntroDone,FALSE,'Begin');
    Sleep(3);
BeginFanTimer:
    SetFlags(TimerStarted,TRUE);
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
	SoundActors[0].PlaySound(Sound'Machine.Play_BigFanStart', SLOT_SFX);
	SoundActors[0].PlaySound(Sound'Machine.Play_BigFan', SLOT_SFX);
    End();
FanSuccess:
    Log("Sam gets past the fan");
    SetFlags(FanSuccess,TRUE);
    Sleep(0.25);
    CheckFlags(TimerStarted,FALSE,'FanSuccessEarly'); // Joshua - If player has entered before timer has started, handle differently
    SendUnrealEvent('FanStop');
    Jump('FanReStart');
    End();
FanSuccessEarly:
    Log("Fan success before timer started");
    CheckFlags(AlreadyRestarted,TRUE,'FanMissEnd');
    SetFlags(AlreadyRestarted,TRUE);
    SendUnrealEvent('VentFan1');
    SoundActors[0].PlaySound(Sound'Machine.Play_BigFanStart', SLOT_SFX);
    SoundActors[0].PlaySound(Sound'Machine.Play_BigFan', SLOT_SFX);
    Sleep(1);
    Jump('blam3');
    End();
FanMiss:
    Log("");
    CheckFlags(FanSuccess,TRUE,'FanMissEnd');
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0017L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_06_01', 1, 1, TR_HEADQUARTER, 0, false);
    AddNote("", "P_2_1_0_CIA_Comms", "Note_0052L", "Localization\\P_2_1_0CIA");
    Close(); // Joshua - This Close() is okay because FanMiss speech is separate/later
FanMissEnd:
    End();
FanSave: // Joshua - Prevent both checkpoints from being triggered
    EVolume(GetMatchingActor('FromSecond')).bSavegame = false;
    End();
TrapSave: // Joshua - Prevent both checkpoints from being triggered
    EVolume(GetMatchingActor('FromFirst')).bSavegame = false;
    End();

}

