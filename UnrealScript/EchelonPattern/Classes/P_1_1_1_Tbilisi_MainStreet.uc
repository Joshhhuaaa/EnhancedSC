//=============================================================================
// P_1_1_1_Tbilisi_MainStreet
//=============================================================================
class P_1_1_1_Tbilisi_MainStreet extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int PatLoop;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('MainStreetLaw');
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

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EGeorgianCop2')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianCop3')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    PatLoop=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("Delete This Pattern");

}

