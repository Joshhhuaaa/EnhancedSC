//=============================================================================
// P_5_2_InterceptedComm
//=============================================================================
class P_5_2_InterceptedComm extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax

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
        if (P.name == 'EEliteForce10')
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
Milestone:
    Log("Milestone");
    Speech(Localize("P_5_2_InterceptedComm", "Speech_0001L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_35_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();

}

