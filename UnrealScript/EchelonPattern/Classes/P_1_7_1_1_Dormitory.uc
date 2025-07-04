//=============================================================================
// P_1_7_1_1_Dormitory
//=============================================================================
class P_1_7_1_1_Dormitory extends EPattern;

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
        if(P.name == 'spetsnaz20')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz18')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz19')
            Characters[3] = P.controller;
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
TelDormitory:
    Log("TelDormitory");
    CheckIfIsUnconscious(1,'TelDormitoryB');
    Teleport(1, 'TelNodeG');
    KillNPC(1, FALSE, FALSE);
TelDormitoryB:
    Log("TelDormitoryB");
    CheckIfIsUnconscious(2,'TelDormitoryC');
    Teleport(2, 'TelNodeH');
    KillNPC(2, FALSE, FALSE);
TelDormitoryC:
    Log("TelDormitoryC");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'TelNodeI');
    KillNPC(3, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
