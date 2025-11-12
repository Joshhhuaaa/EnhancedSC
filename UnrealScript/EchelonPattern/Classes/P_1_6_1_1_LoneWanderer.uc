//=============================================================================
// P_1_6_1_1_LoneWanderer
//=============================================================================
class P_1_6_1_1_LoneWanderer extends EPattern;

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
        if (P.name == 'spetsnaz9')
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
MilestoneLoneWanderer:
    Log("MilestoneLoneWanderer");
    Goal_Set(1,GOAL_MoveTo,9,,,,'Closet',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'Closet',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Tel:
    Log("Tel");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelOOTWlone');
    KillNPC(1, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}
