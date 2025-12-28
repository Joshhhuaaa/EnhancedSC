//=============================================================================
// P_3_2_2_NPP_Bathroom
//=============================================================================
class P_3_2_2_NPP_Bathroom extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Once;
var int Thrice;
var int Twice;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_GRABBED:
            EventJump('Grabbed');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    if (!bInit)
    {
    bInit=TRUE;
    Once=0;
    Thrice=0;
    Twice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Grabbed:
    Log("Pisser grabbed.");
    CheckIfGrabbed(1,'Interrogate');
    End();
Interrogate:
    Log("Interrogating Pisser.");
    CheckFlags(Once,TRUE,'Twice');
    SetFlags(Once,TRUE);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0001L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_01', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0002L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_02', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0003L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_03', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0004L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_04', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0005L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_05', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0006L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_06', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0007L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_07', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0008L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_08', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0017L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_09', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0018L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_10', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0009L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_11', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0010L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_12', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Close();
    End();
Twice:
    Log("Sam has prodded the Inventory tech 2 times.");
    CheckFlags(Twice,TRUE,'Thrice');
    SetFlags(Twice,TRUE);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0011L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_13', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0012L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_14', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0013L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_15', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0014L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_16', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Close();
    End();
Thrice:
    Log("Sam has prodded the Inventory tech 3+ times.");
    CheckFlags(Thrice,TRUE,'Foursies');
    SetFlags(Thrice,TRUE);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0015L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_17', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2.5);
    Close();
    End();
Foursies:
    Log("Sam has prodded the Inventory tech 4+ times.");
    SetFlags(Thrice,FALSE);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_Bathroom", "Speech_0016L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_41_18', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2.5);
    Close();
    End();

}

defaultproperties
{
}
