//=============================================================================
// P_0_0_3_TrainingT3_Camera05A
//=============================================================================
class P_0_0_3_TrainingT3_Camera05A extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Electronic.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AllLightOut;
var int LightAOut;
var int LightBOut;
var int LightCOut;
var int LightDOut;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Failed');
            break;
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
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'eCamera2')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    AllLightOut=0;
    LightAOut=0;
    LightBOut=0;
    LightCOut=0;
    LightDOut=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Setup:
    Log("Setup - Camera05A");
    CinCamera(0, 'Cam1Cam', 'Cam1Foc',);
    Sleep(5);
    CinCamera(1, , ,);
    SendPatternEvent('T3DescGroup','Save');
    Sleep(1);
    SendUnrealEvent('FirstCamSafeWall');
    PlayerMove(true);
    InventoryManager(0, true, '', 1, true, class 'EFn7', false);
    SendPatternEvent('GroupTicker','Start05A');
    End();
CheckIfValid:
    Log("CheckIfValid - Camera05A");
Completed:
    Log("Completed - Camera05A");
    SendPatternEvent('GroupTicker','End05A');
    PlayerMove(false);
    SendPatternEvent('T3CommsGroup','CameraB05');
    End();
Failed:
    Log("Failed - Camera05A");
    SendPatternEvent('GroupTicker','End05A');
    PlayerMove(false);
    Sleep(2);
    Speech(Localize("P_0_0_3_TrainingT3_Camera05A", "Speech_0001L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_13', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    Sleep(2);
Reset:
    Log("Reset - Camera05A");
    QuickSaveLoad(FALSE, TRUE);
    End();
GiveInv:
    Log("GiveInv");
    InventoryManager(0, true, '', 50, false, , true);
    End();
LightA:
    Log("Shot Light A");
    SetFlags(LightAOut,TRUE);
    Jump('LightChecker');
    End();
LightB:
    Log("Shot Light B");
    SetFlags(LightBOut,TRUE);
    Jump('LightChecker');
    End();
LightC:
    Log("Shot Light C");
    SetFlags(LightCOut,TRUE);
    Jump('LightChecker');
    End();
LightD:
    Log("Shot Light D");
    SetFlags(LightDOut,TRUE);
    Jump('LightChecker');
    End();
LightChecker:
    Log("Checking all lights");
    CheckFlags(LightAOut,FALSE,'DoNothing');
    CheckFlags(LightBOut,FALSE,'DoNothing');
    CheckFlags(LightCOut,FALSE,'DoNothing');
    CheckFlags(LightDOut,FALSE,'DoNothing');
    Jump('FlagAndNV');
    End();
FlagAndNV:
    Log("Sending the Night Vision Pop-Up.");
    SendPatternEvent('T3DescGroup','NVTip');
    End();
CamOff:
    Log("Switching Camera Off");
    GoalCompleted('CameraA05');
    SendUnrealEvent('Cam1Foc');
	SoundActors[0].PlaySound(Sound'Electronic.Stop_CameraScan', SLOT_SFX);
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

