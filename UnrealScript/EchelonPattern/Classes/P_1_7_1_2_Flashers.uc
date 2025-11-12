//=============================================================================
// P_1_7_1_2_Flashers
//=============================================================================
class P_1_7_1_2_Flashers extends EPattern;

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
        if (P.name == 'spetsnaz3')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz4')
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
MilestoneFlashers:
    Log("MilestoneFlashers");
    ToggleGroupAI(TRUE, 'Flashers', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'RepairRoomPathE',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'RepairRoomPathE',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TelFlashers:
    Log("TelFlashers");
    CheckIfIsUnconscious(1,'TelBFlashers');
    Teleport(1, 'TelNodeE');
    KillNPC(1, FALSE, FALSE);
TelBFlashers:
    Log("TelBFlashers");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'TelNodeF');
    KillNPC(2, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
