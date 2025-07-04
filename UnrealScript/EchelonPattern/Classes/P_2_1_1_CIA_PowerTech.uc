//=============================================================================
// P_2_1_1_CIA_PowerTech
//=============================================================================
class P_2_1_1_CIA_PowerTech extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_1Voice.uax

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
        if(P.name == 'ECIAMaintenance2')
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
MilestoneNumbers:
    Log("MilestoneNumbers");
    Talk(Sound'S2_1_1Voice.Play_21_11_01', 1, , TRUE, 0);
    Close();
    End();

}

