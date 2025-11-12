//=============================================================================
// P_1_7_1_2_BridgeLazies
//=============================================================================
class P_1_7_1_2_BridgeLazies extends EPattern;

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
        if (P.name == 'spetsnaz6')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz15')
            Characters[2] = P.controller;
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
MilestoneBridgeLazies:
    Log("MilestoneBridgeLazies");
    Sleep(35);
    Goal_Set(2,GOAL_MoveTo,9,,,,'GoCheckA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
TelBridgeLazies:
    Log("TelBridgeLazies");
    CheckIfIsUnconscious(1,'TelABridgeLazies');
    Teleport(1, 'TelNodeO');
    KillNPC(1, FALSE, FALSE);
TelABridgeLazies:
    Log("TelABridgeLazies");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'TelNodeP');
    KillNPC(2, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
