//=============================================================================
// P_2_1_1_CIA_OutOfElevator
//=============================================================================
class P_2_1_1_CIA_OutOfElevator extends EPattern;

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
        if (P.name == 'ECIAAgent8')
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
Start:
    Log("");
    Sleep(3);
    Teleport(1, 'PathNode81');
    ResetGoals(1);
    Sleep(0.25);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ECIAAgent8_400',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'ECIAAgent8_400',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

