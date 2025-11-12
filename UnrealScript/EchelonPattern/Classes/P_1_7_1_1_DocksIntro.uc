//=============================================================================
// P_1_7_1_1_DocksIntro
//=============================================================================
class P_1_7_1_1_DocksIntro extends EPattern;

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
        if (P.name == 'spetsnaz1')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz3')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz2')
            Characters[3] = P.controller;
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
TelDocksIntro:
    Log("TelDocksIntro");
    CheckIfIsUnconscious(1,'TelDocksIntroB');
    Teleport(1, 'TelNodeN');
    KillNPC(1, FALSE, FALSE);
TelDocksIntroB:
    Log("TelDocksIntroB");
    CheckIfIsUnconscious(2,'TelDocksIntroD');
    Teleport(2, 'TelNodeO');
    KillNPC(2, FALSE, FALSE);
TelDocksIntroD:
    Log("TelDocksIntroD");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'TelNodeQ');
    KillNPC(3, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
