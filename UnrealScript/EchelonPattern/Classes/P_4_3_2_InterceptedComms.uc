//=============================================================================
// P_4_3_2_InterceptedComms
//=============================================================================
class P_4_3_2_InterceptedComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DocFireSpoken;


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
    DocFireSpoken=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
AlarmTrucks:
    Log("Intercepted Enemy Communication 43_34 'Alarm Trucks'");
    SetProfileDeletion();
    Speech(Localize("P_4_3_2_InterceptedComms", "Speech_0001L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_34_01', 1, 0, TR_NPCS, 0, false);
    Close();
    GameOver(false, 0);
    End();
TruckRollout:
    Log("Intercepted Enemy Communication 43_36 'Truck Rollout'");
    Speech(Localize("P_4_3_2_InterceptedComms", "Speech_0002L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_36_01', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_4_3_2_InterceptedComms", "Speech_0003L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_36_02', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
DocumentFire:
    Log("");
    CheckFlags(DocFireSpoken,TRUE,'DoNothing');
    SetFlags(DocFireSpoken,TRUE);
    Speech(Localize("P_4_3_2_InterceptedComms", "Speech_0004L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_42_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

