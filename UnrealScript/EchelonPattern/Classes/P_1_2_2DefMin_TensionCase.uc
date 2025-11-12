//=============================================================================
// P_1_2_2DefMin_TensionCase
//=============================================================================
class P_1_2_2DefMin_TensionCase extends EPattern;

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
        if (P.name == 'EGeorgianSoldier9')
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
Milestone:
    Log("MilestoneTensionCase");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'StratSecondA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).ElevatorAlerted,FALSE,'GoingToTeleport');
    Goal_Set(1,GOAL_MoveTo,8,,,,'ToLigSwitsh',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
GoingToTeleport:
    Log("GoingToTeleport");
    Goal_Set(1,GOAL_MoveTo,7,,,,'PostGangWb',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,6,,'ChinColaMmmmm','ChinColaMmmmm','PostGangWb',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    ChangeState(1,'s_default');
    End();

}

