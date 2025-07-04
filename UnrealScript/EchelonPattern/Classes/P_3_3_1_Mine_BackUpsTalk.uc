//=============================================================================
// P_3_3_1_Mine_BackUpsTalk
//=============================================================================
class P_3_3_1_Mine_BackUpsTalk extends EPattern;

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
        if(P.name == 'spetsnaz26')
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
Milestone:
    Log("MilestoneBackUpsTalk");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).InterroAlerted,TRUE,'StartPatrol');
    Sleep(1);
addconversationsound:
    Talk(None, 1, , TRUE, 0);
    Talk(None, 2, , TRUE, 0);
    Talk(None, 1, , TRUE, 0);
    Sleep(1);
    Close();
    End();
StartPatrol:
    Log("StartPatrol");
    Goal_Set(2,GOAL_MoveTo,9,,,,'SleepHideB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'PostCaveGuA','PostCaveGuA','SleepHideB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PostCaveGuA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'PostCaveGuA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

defaultproperties
{
}
