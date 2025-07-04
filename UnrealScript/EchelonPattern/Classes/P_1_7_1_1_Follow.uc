//=============================================================================
// P_1_7_1_1_Follow
//=============================================================================
class P_1_7_1_1_Follow extends EPattern;

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
MilestoneFollow:
    Log("MilestoneFollow");
    ToggleGroupAI(TRUE, 'Follow', 'Captain', 'Dormitory', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Goal_Set(1,GOAL_MoveTo,9,,,,'FollowHeadsThere',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,8,,,,'OfficechairB',,FALSE,,MOVE_Sit,,MOVE_Sit);
    End();
TelFollow:
    Log("TelFollow");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelNodeA');
    KillNPC(1, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
