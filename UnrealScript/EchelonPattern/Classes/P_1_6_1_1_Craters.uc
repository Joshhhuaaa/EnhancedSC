//=============================================================================
// P_1_6_1_1_Craters
//=============================================================================
class P_1_6_1_1_Craters extends EPattern;

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
        if(P.name == 'spetsnaz22')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz19')
            Characters[2] = P.controller;
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
TelOut:
    Log("TelOut");
    CheckIfIsUnconscious(1,'TelOutB');
    Teleport(1, 'LockOutB');
    KillNPC(1, FALSE, TRUE);
TelOutB:
    Log("TelOutB");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'LockOutA');
    KillNPC(2, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}
