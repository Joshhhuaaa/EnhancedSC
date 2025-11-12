//=============================================================================
// P_0_0_3_TrainingT3_Camera05B
//=============================================================================
class P_0_0_3_TrainingT3_Camera05B extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Electronic.uax
#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (A.name == 'eCamera1')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Setup:
    Log("Setup - Camera05B");
    CinCamera(0, 'Cam2Cam', 'Cam2Foc',);
    Sleep(5);
    CinCamera(1, , ,);
    Sleep(1);
    PlayerMove(true);
    SendUnrealEvent('SecondCamSafeWall');
    SendPatternEvent('T3DescGroup','SetSaveTrue');
    SendPatternEvent('T3DescGroup','CameraB05');
    SendPatternEvent('GroupTicker','Start05B');
    End();
CheckIfValid:
    Log("CheckIfValid - Camera05B.");
    InventoryManager(0, false, '', 0, true, class 'EFn7', false);
    LockDoor('Door05B05', FALSE, TRUE);
    End();
Completed:
    Log("Completed - Camera05B");
    SendPatternEvent('GroupTicker','End05B');
    SendPatternEvent('T3CommsGroup','Camera05');
    End();
CamOff:
    Log("Turning off the camera");
    GoalCompleted('CameraB05');
    SendUnrealEvent('Cam2Foc');
	SoundActors[0].PlaySound(Sound'Electronic.Stop_CameraScan', SLOT_SFX);
    End();
Failed:
    Log("Failed - Camera05B");
    SendPatternEvent('GroupTicker','End05B');
    PlayerMove(false);
    Sleep(2);
    Speech(Localize("P_0_0_3_TrainingT3_Camera05B", "Speech_0003L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_13', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Close();
    Sleep(0.5);
Reset:
    Log("Reset - Camera05B");
    QuickSaveLoad(FALSE, TRUE);
    End();
GiveInv:
    Log("GiveInv");
    InventoryManager(0, true, '', 50, false, , true);
    End();

}

