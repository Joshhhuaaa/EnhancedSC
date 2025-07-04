//=============================================================================
// P_1_7_1_2_BeforeCargo
//=============================================================================
class P_1_7_1_2_BeforeCargo extends EPattern;

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
        if(P.name == 'spetsnaz5')
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
MilestoneBeforeCargo:
    Log("MilestoneBeforeCargo");
    ToggleGroupAI(TRUE, 'BeforeCargo', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'AnPathCatA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'AnPathCatA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TelBeforeCargo:
    Log("TelBeforeCargo");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelNodeG');
    KillNPC(1, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
