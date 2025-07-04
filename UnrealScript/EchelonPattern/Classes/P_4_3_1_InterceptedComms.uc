//=============================================================================
// P_4_3_1_InterceptedComms
//=============================================================================
class P_4_3_1_InterceptedComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if(P.name == 'EAnna1')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Icomm4307:
    Log("Intercepted Comm 43_07");
    Sleep(1);
    Speech(Localize("P_4_3_1_InterceptedComms", "Speech_0001L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_07_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
Icomm4308:
    Log("Intercepted Enemy Communication 43_08");
    Speech(Localize("P_4_3_1_InterceptedComms", "Speech_0002L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_08_01', 1, 0, TR_NPCS, 0, false);
    Sleep(6);
    Close();
    End();

}

