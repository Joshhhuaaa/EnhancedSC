//=============================================================================
// P_1_7_1_2_Kitchen
//=============================================================================
class P_1_7_1_2_Kitchen extends EPattern;

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
        if(P.name == 'spetsnaz8')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz2')
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
MilestoneKitchen:
    Log("MilestoneKitchen");
    ToggleGroupAI(TRUE, 'Kitchen', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SetExclusivity(FALSE);
    Goal_Set(2,GOAL_MoveTo,9,,,,'KitPatrolA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'KitPatrolA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TelKitchen:
    Log("TelKitchen");
    CheckIfIsUnconscious(1,'TelBKitchen');
    Teleport(1, 'TelNodeK');
    KillNPC(1, FALSE, FALSE);
TelBKitchen:
    Log("TelBKitchen");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'TelNodeL');
    KillNPC(2, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
