//=============================================================================
// P_0_0_3_Training_T3_Desc
//=============================================================================
class P_0_0_3_Training_T3_Desc extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CamAVidPlayed;
var int WithSave;


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

    if( !bInit )
    {
    bInit=TRUE;
    CamAVidPlayed=0;
    WithSave=0;
    }

    SetPatternAlwaysTick();
}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
HUD:
    Log("Hud info");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0057L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0058L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0059L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    End();
OpenDoor01:
    Log("OpenDoor01");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0011L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0033L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_MOVE_DOWN_MASK | KEY_INTERACTION_MASK, FALSE);
    End();
LockPick02:
    Log("LockPick02");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0001L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_MOVE_UP_MASK | KEY_MOVE_DOWN_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK | KEY_QUICK_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0056L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_MOVE_UP_MASK | KEY_MOVE_DOWN_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0066L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    End();
Keypad03:
    Log("Keypad03");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0038L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0005L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0006L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_FIRE_MASK, FALSE);
    FreezeTraining();
    CheckFlags(WithSave,TRUE,'Save');
    End();
Retinal04:
    Log("Retinal04");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0040L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0041L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_MOVE_UP_MASK | KEY_MOVE_DOWN_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK | KEY_INTERACTION_MASK, FALSE);
    FreezeTraining();
    CheckFlags(WithSave,TRUE,'Save');
    End();
CameraA05:
    Log("CameraA05");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0042L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0043L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0060L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_FIRE_MASK, FALSE);
    FreezeTraining();
    CheckFlags(CamAVidPlayed,TRUE,'DoNothing');
    SetFlags(CamAVidPlayed,TRUE);
    SendPatternEvent('GroupCamera05A','Setup');
    End();
CameraB05:
    Log("");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0050L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0065L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    CheckFlags(WithSave,TRUE,'Save');
    End();
Camera05:
    Log("");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0051L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    PlayerMove(true);
    CheckFlags(WithSave,TRUE,'Save');
    End();
HideBody06:
    Log("HideBody06");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0013L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_FIRE_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0014L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0015L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK | KEY_MOVE_UP_MASK | KEY_MOVE_DOWN_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK | KEY_INTERACTION_MASK, FALSE);
    FreezeTraining();
    CheckFlags(WithSave,TRUE,'Save');
    End();
Sound07:
    Log("Sound07");
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0010L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0064L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    CheckFlags(WithSave,TRUE,'Save');
    End();
NVTip:
    Log("Giving the player the Night Vision Tip");
    Sleep(1);
    AddTrainingData(Localize("P_0_0_3_Training_T3_Desc", "Training_0062L", "Localization\\P_0_0_3_Training"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    End();
DoNothing:
    Log("Doing Nothing");
    End();
Save:
    Log("");
    SetFlags(WithSave,FALSE);
    QuickSaveLoad(TRUE, FALSE);
    End();
SetSaveTrue:
    Log("");
    SetFlags(WithSave,TRUE);
    End();

}

