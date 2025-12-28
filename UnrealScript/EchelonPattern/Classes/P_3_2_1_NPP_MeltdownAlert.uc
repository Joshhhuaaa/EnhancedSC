//=============================================================================
// P_3_2_1_NPP_MeltdownAlert
//=============================================================================
class P_3_2_1_NPP_MeltdownAlert extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_1Voice.uax

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
Flip:
    Log("Sam has flipped a cooling rod switch.");
    CheckFlags(Once,FALSE,'One');
    CheckFlags(Twice,FALSE,'Two');
    CheckFlags(Thrice,FALSE,'Three');
    Log("SUCCESS!!!");
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_MeltdownAlert", "Speech_0002L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_25_01', 1, 0, TR_NPCS, 0, false);
    Sleep(0.8); // Joshua - Added delay to prevent a bug where the typing sound continues if a cinematic interrupts Sam's computer interaction
    SendPatternEvent('Evac1AI','Cannibal');
    SendPatternEvent('HallwayAlarmAI','Meltdown');
    Sleep(25);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_MeltdownAlert", "Speech_0005L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_25_01', 1, 0, TR_HEADQUARTER, 0, false);
    End();
One:
    Log("One cylinder deactivated.");
    SetFlags(Once,TRUE);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_MeltdownAlert", "Speech_0001L", "Localization\\P_3_2_1_PowerPlant"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Close();
    End();
Two:
    Log("Two cylinders deactivated.");
    SetFlags(Twice,TRUE);
    SendPatternEvent('HalfMeltdownAlertAI','HoppityHop');
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_MeltdownAlert", "Speech_0003L", "Localization\\P_3_2_1_PowerPlant"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Close();
    End();
Three:
    Log("Three cylinders deactivated.");
    SetFlags(Thrice,TRUE);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_MeltdownAlert", "Speech_0004L", "Localization\\P_3_2_1_PowerPlant"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Close();
    End();

}

defaultproperties
{
}
