//=============================================================================
// P_1_2_1DefMin_CourtPatrols
//=============================================================================
class P_1_2_1DefMin_CourtPatrols extends EPattern;

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
        if (P.name == 'EGeorgianCop9')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianCop5')
            Characters[2] = P.controller;
        if (P.name == 'EGeorgianCop10')
            Characters[3] = P.controller;
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
MilestoneCourtPatrols:
    Log("MilestoneCourtPatrols");
    DisableMessages(TRUE, FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'CenterCourtyard_300',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'CenterCourtyard_300',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'NECourtyard_300',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'NECourtyard_300',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_InteractWith,9,,,,'ELightSwitchCourtyardLights',,FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,8,,,,'CourPatOne_500',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Patrol,7,,,,'CourPatOne_500',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    SetExclusivity(FALSE);
    End();
BustsIn:
    Log("BustsIn");
    SetExclusivity(FALSE);
    End();

}

