//=============================================================================
// P_0_0_3_Training_T3_Comms
//=============================================================================
class P_0_0_3_Training_T3_Comms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S0_0_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
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
StartGarage:
    InventoryManager(0, true, '', 1, true, class 'EOpticCable', false); // Joshua - Optic Cable added to Training
    Log("Opening start garage door test");
    IgnoreAlarmStage(TRUE);
    SendUnrealEvent('StartDoor');
    Goal_Default(1,GOAL_Guard,1,,'RetryDoor','RetryDoor','Lambert01',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
OpenDoor01:
    Log("OpenDoor01");
    SendPatternEvent('GroupKeypad03','Disable');
    SendPatternEvent('GroupRetinal04','Disable');
    SendPatternEvent('GroupHideBody06','Disable');
    SendPatternEvent('GroupStickyShocker10','Disable');
    PlayerMove(false);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0005L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_23_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    AddGoal('OpenDoor01', "", 10, "", "P_0_0_3_Training_T3_Comms", "Goal_0021L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0034L", "Localization\\P_0_0_3_Training");
    Close();
    Sleep(1);
    PlayerMove(true);
    SendPatternEvent('T3DescGroup','HUD');
    End();
LockPick02:
    Log("LockPick02");
    PlayerMove(false);
    Goal_Default(1,GOAL_Guard,9,,'PLAYER','PLAYER','Lambert02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    AddGoal('LockPick02', "", 9, "", "P_0_0_3_Training_T3_Comms", "Goal_0023L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0035L", "Localization\\P_0_0_3_Training");
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0051L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_07', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    PlayerMove(true);
    SendPatternEvent('T3DescGroup','LockPick02');
    End();
Keypad03:
    Log("Keypad03");
    PlayerMove(false);
    Goal_Default(1,GOAL_Guard,5,,'PLAYER','PLAYER','Lambert03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0008L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_24_01', 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    AddGoal('Keypad03', "", 8, "", "P_0_0_3_Training_T3_Comms", "Goal_0009L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0036L", "Localization\\P_0_0_3_Training");
    Close();
    Sleep(0.5);
    PlayerMove(true);
    SendUnrealEvent('InterrogateSafeWall');
    SendPatternEvent('T3DescGroup','SetSaveTrue');
    SendPatternEvent('T3DescGroup','Keypad03');
    SendPatternEvent('GroupKeypad03','Setup');
    End();
Retinal04:
    Log("Retinal04");
    PlayerMove(false);
    Goal_Default(1,GOAL_Guard,5,,'PLAYER','PLAYER','Lambert04',,FALSE,,,,);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0010L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_26_01', 1, 0, TR_HEADQUARTER, 0, false);
    AddGoal('Retinal04', "", 7, "", "P_0_0_3_Training_T3_Comms", "Goal_0013L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0037L", "Localization\\P_0_0_3_Training");
    Close();
    Sleep(0.5);
    PlayerMove(true);
    SendUnrealEvent('RetinalSafeWall');
    SendPatternEvent('T3DescGroup','SetSaveTrue');
    SendPatternEvent('T3DescGroup','Retinal04');
    SendPatternEvent('GroupRetinal04','Setup');
    End();
CameraA05:
    Log("CameraA05");
    PlayerMove(false);
    Goal_Default(1,GOAL_Guard,9,,,,'Lambert05',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0014L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_27_01', 1, 0, TR_HEADQUARTER, 0, false);
    AddGoal('CameraA05', "", 6, "", "P_0_0_3_Training_T3_Comms", "Goal_0018L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0038L", "Localization\\P_0_0_3_Training");
    Close();
    Sleep(0.5);
    SendPatternEvent('T3DescGroup','SetSaveTrue');
    SendPatternEvent('T3DescGroup','CameraA05');
    End();
CameraB05:
    Log("CameraB05");
    PlayerMove(false);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0045L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_08', 1, 0, TR_HEADQUARTER, 0, false);
    AddGoal('CameraB05', "", 5, "", "P_0_0_3_Training_T3_Comms", "Goal_0046L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0047L", "Localization\\P_0_0_3_Training");
    Close();
    Sleep(0.5);
    SendPatternEvent('GroupCamera05B','Setup');
    End();
Camera05:
    Log("Camera05");
    PlayerMove(false);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0048L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_09', 1, 0, TR_HEADQUARTER, 0, false);
    AddGoal('Camera05', "", 5, "", "P_0_0_3_Training_T3_Comms", "Goal_0049L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0050L", "Localization\\P_0_0_3_Training");
    Close();
    SendPatternEvent('GroupCamera05','Setup');
    End();
HideBody06:
    Log("HideBody06");
    PlayerMove(false);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0024L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_10', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('HideBody06', "", 5, "", "P_0_0_3_Training_T3_Comms", "Goal_0025L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0039L", "Localization\\P_0_0_3_Training");
    Close();
    Sleep(0.5);
    PlayerMove(true);
    SendUnrealEvent('HideBodySafeWall');
    SendPatternEvent('T3DescGroup','SetSaveTrue');
    SendPatternEvent('T3DescGroup','HideBody06');
    SendPatternEvent('GroupHideBody06','Setup');
    End();
Sound07:
    Log("Sound07");
    PlayerMove(false);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0019L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_29_01', 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    AddGoal('Sound07', "", 3, "", "P_0_0_3_Training_T3_Comms", "Goal_0020L", "Localization\\P_0_0_3_Training", "P_0_0_3_Training_T3_Comms", "Goal_0040L", "Localization\\P_0_0_3_Training");
    Close();
    Sleep(0.5);
    PlayerMove(true);
    SendUnrealEvent('SoundSafeWall');
    SendPatternEvent('T3DescGroup','SetSaveTrue');
    SendPatternEvent('T3DescGroup','Sound07');
    End();
BloodyMurder:
    Log("Sam has murdered someone");
    SetProfileDeletion();
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Speech(Localize("P_0_0_3_Training_T3_Comms", "Speech_0052L", "Localization\\P_0_0_3_Training"), Sound'S0_0_Voice.Play_00_17_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 0);
DoNothing:
    Log("Doing nothing");
    End();

}

