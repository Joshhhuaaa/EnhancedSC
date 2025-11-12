//=============================================================================
// P_1_7_1_2_PreControl
//=============================================================================
class P_1_7_1_2_PreControl extends EPattern;

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
        if (P.name == 'spetsnaz21')
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
MilestonePreControl:
    Log("MilestonePreControl");
    ToggleGroupAI(TRUE, 'PreControl', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PreContD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'PreContD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TelPreControl:
    Log("TelPreControl");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelNodeV');
    KillNPC(1, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
