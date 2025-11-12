//=============================================================================
// P_2_2_1_Ktech_InterceptedComms
//=============================================================================
class P_2_2_1_Ktech_InterceptedComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Icomm2216Triggered;


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
        if (P.name == 'EMafiaMuscle13')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle11')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Icomm2216Triggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
IComm2216:
    Log("Intercepted Enemy Communication 22_16");
    CheckFlags(Icomm2216Triggered,TRUE,'AlreadyTriggered');
    SetFlags(Icomm2216Triggered,TRUE);
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0001L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_16_01', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0002L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_16_02', 2, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0003L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_16_03', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
IComm2217:
    Log("Intercepted Enemy Communication 22_17");
    CheckIfIsDead(1,'AlreadyTriggered');
    CheckIfIsUnconscious(1,'AlreadyTriggered');
    CheckIfIsDead(2,'AlreadyTriggered');
    CheckIfIsUnconscious(2,'AlreadyTriggered');
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0004L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_17_01', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0005L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_17_02', 2, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0006L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_17_03', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0007L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_17_04', 2, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_1_Ktech_InterceptedComms", "Speech_0008L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_17_05', 1, 0, TR_NPCS, 0, false);
    Close();
AlreadyTriggered:
    End();

}

