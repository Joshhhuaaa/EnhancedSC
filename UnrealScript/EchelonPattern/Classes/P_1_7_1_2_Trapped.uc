//=============================================================================
// P_1_7_1_2_Trapped
//=============================================================================
class P_1_7_1_2_Trapped extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_3_2Voice.uax

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
        if(P.name == 'spetsnaz25')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz12')
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
MilestoneTrapped:
    Log("MilestoneTrapped");
    ToggleGroupAI(TRUE, 'Trapped', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Teleport(1, 'PreContF');
    Teleport(2, 'PreContE');
    Goal_Set(1,GOAL_Guard,9,,,,'PreContF',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Guard,9,,,,'PreContE',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S3_3_2Voice.Play_33_56_01', 2, , TRUE, 0);
    Talk(Sound'S3_3_2Voice.Play_33_56_02', 1, , TRUE, 0);
    Talk(Sound'S3_3_2Voice.Play_33_56_03', 2, , TRUE, 0);
    Talk(Sound'S3_3_2Voice.Play_33_56_04', 1, , TRUE, 0);
    Close();
    SetExclusivity(FALSE);
    SendUnrealEvent('ServerDoor');
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'SpathS',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Patrol,8,,,,'SpathS',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,9,,,,'SpathU',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Patrol,8,,,,'SpathU',,FALSE,,MOVE_Search,,MOVE_Search);
    End();

}

defaultproperties
{
}
