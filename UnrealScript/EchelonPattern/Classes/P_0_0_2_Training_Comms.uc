//=============================================================================
// P_0_0_2_Training_Comms
//=============================================================================
class P_0_0_2_Training_Comms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S0_0_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int PoolTopDone;


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

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    PoolTopDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
LookExp:
    Log("Saving Game through Comms Pattern. Lambert asks Sam to move his head");
    PlayerMove(false);
    Sleep(0.5);
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0001L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_99_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0002L", "Localization\\P_0_0_2_Training"), Sound'S0_0_Voice.Play_00_25_01', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0007L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_99_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    SendUnrealEvent('LightL');
    LookTarget('LookLeft', FALSE);
    SendUnrealEvent('LightL');
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0009L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_99_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    SendUnrealEvent('LightR');
    LookTarget('LookRIght', FALSE);
    SendUnrealEvent('LightR');
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0010L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_99_04', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    SendUnrealEvent('LightU');
    LookTarget('lookUp', FALSE);
    SendUnrealEvent('LightU');
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0011L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_99_05', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    SendUnrealEvent('LightD');
    LookTarget('LookDown', FALSE);
    SendUnrealEvent('LightD');
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0012L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_20_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    PlayerMove(true);
    End();
OnTopOfPool:
    Log("");
    CheckFlags(PoolTopDone,TRUE,'DoNothing');
    SetFlags(PoolTopDone,TRUE);
    Sleep(0.2);
    PlayerMove(false);
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0018L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_21_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    PlayerMove(true);
    End();
EndT2:
    Log("");
    PlayerMove(false);
    Speech(Localize("P_0_0_2_Training_Comms", "Speech_0019L", "Localization\\P_0_0_2_Training"), Sound'S0_0_2Voice.Play_00_99_06', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    PlayerMove(true);
    SendPatternEvent('Descriptions','WallJump');
    End();
T2LevelEnd:
    Log("");
    LevelChange("0_0_3_Training.unr");
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

