//=============================================================================
// P_3_2_1_NPP_RoofTop
//=============================================================================
class P_3_2_1_NPP_RoofTop extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Triggered;


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
        if (P.name == 'EFalseRussianSoldier3')
            Characters[1] = P.controller;
        if (P.name == 'EFalseRussianSoldier5')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Triggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
RoofTop:
    Log("Begins the pattern when Sam reaches the roof.");
    CheckFlags(Triggered,TRUE,'Nada');
    SetFlags(Triggered,TRUE);
    Speech(Localize("P_3_2_1_NPP_RoofTop", "Speech_0001L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_23_01', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_1_NPP_RoofTop", "Speech_0002L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_23_02', 2, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_1_NPP_RoofTop", "Speech_0003L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_23_03', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_1_NPP_RoofTop", "Speech_0004L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_23_04', 2, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Close();
    Goal_Default(1,GOAL_Patrol,9,,,,'GeddyLee_0',,FALSE,,,,);
Nada:
    End();
GasTank:
    Log("Gastank gameplay.");
    Sleep(2);
    SendUnrealEvent('GasTank');
    Sleep(10);
    SendUnrealEvent('GasTank');
    End();

}

defaultproperties
{
}
