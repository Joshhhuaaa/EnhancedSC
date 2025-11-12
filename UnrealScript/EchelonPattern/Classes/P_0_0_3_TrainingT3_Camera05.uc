//=============================================================================
// P_0_0_3_TrainingT3_Camera05
//=============================================================================
class P_0_0_3_TrainingT3_Camera05 extends EPattern;

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
        if (A.name == 'eCamera0')
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
    Log("Setup - Camera05");
    CinCamera(0, 'Cam3Cam', 'Cam3Foc',);
    Sleep(5);
    CinCamera(1, , ,);
    Sleep(0.05);
    SendUnrealEvent('ThirdCamSafeWall');
    SendPatternEvent('T3DescGroup','SetSaveTrue');
    SendPatternEvent('T3DescGroup','Camera05');
    End();
CheckIfValid:
    Log("CheckIfValid - Camera05");
    SendUnrealEvent('Cam3Foc');
	SoundActors[0].PlaySound(Sound'Electronic.Stop_CameraScan', SLOT_SFX);
Completed:
    Log("Completed - Camera05");
    PlayerMove(false);
    GoalCompleted('Camera05');
    SendPatternEvent('T3CommsGroup','HideBody06');
    End();
Failed:
    Log("Failed - Camera05");
    PlayerMove(false);
    Sleep(2);
    Speech(Localize("P_0_0_3_TrainingT3_Camera05", "Speech_0001L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_13', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    Sleep(2);
Reset:
    Log("Reset - Camera05");
    QuickSaveLoad(FALSE, TRUE);
    End();

}

