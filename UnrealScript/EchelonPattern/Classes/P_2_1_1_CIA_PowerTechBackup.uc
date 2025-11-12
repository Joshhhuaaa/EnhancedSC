//=============================================================================
// P_2_1_1_CIA_PowerTechBackup
//=============================================================================
class P_2_1_1_CIA_PowerTechBackup extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Start');
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
        if (P.name == 'ECIASecurity13')
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
Start:
    Log("");
    DisableMessages(TRUE, FALSE);
    Teleport(1, 'PathNode189');
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LookingForYou;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    End();

}

