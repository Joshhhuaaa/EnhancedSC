//=============================================================================
// P_1_7_1_1_WindowLone
//=============================================================================
class P_1_7_1_1_WindowLone extends EPattern;

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
        if(P.name == 'EFalseRussianSoldier2')
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
TelWindowLone:
    Log("TelWindowLone");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelNodeD');
    KillNPC(1, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
