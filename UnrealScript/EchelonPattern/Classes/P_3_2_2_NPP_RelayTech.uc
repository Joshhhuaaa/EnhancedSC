//=============================================================================
// P_3_2_2_NPP_RelayTech
//=============================================================================
class P_3_2_2_NPP_RelayTech extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_2Voice.uax

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
        if (P.name == 'EMercenaryTechnician1')
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
Relay:
    Log("Mojo");
    Talk(Sound'S3_2_2Voice.Play_32_42_01', 1, , TRUE, 0);
    Sleep(8);
    Close();
    End();

}

defaultproperties
{
}
