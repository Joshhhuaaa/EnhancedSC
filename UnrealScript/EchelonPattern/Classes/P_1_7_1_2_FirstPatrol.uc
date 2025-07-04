//=============================================================================
// P_1_7_1_2_FirstPatrol
//=============================================================================
class P_1_7_1_2_FirstPatrol extends EPattern;

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
        if(P.name == 'spetsnaz0')
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
TelFirstPatrol:
    Log("TelFirstPatrol");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelNodeA');
    KillNPC(1, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
