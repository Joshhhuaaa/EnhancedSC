//=============================================================================
// P_1_7_1_1_Upstairs
//=============================================================================
class P_1_7_1_1_Upstairs extends EPattern;

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
        if(P.name == 'spetsnaz23')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz24')
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
MilestoneUpstairs:
    Log("MilestoneUpstairs");
    ToggleGroupAI(TRUE, 'Upstairs', 'TurretMeat', 'BarrelsOFun', 'SubFirstTeam', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Teleport(1, 'UpstairsTelA');
    Teleport(2, 'UpstairsTelB');
    Goal_Set(1,GOAL_MoveTo,9,,,,'LongWay',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'DoorFourthFloor','DoorFourthFloor','LongWay',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(5);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PreLongWay',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Guard,8,,'DoorFourthFloor','DoorFourthFloor','PreLongWay',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
TelUpstairs:
    Log("TelUpstairs");
    CheckIfIsUnconscious(1,'TelUpstairsB');
    Teleport(1, 'TelNodeDD');
    KillNPC(1, FALSE, FALSE);
TelUpstairsB:
    Log("TelUpstairsB");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'TelNodeEE');
    KillNPC(2, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
