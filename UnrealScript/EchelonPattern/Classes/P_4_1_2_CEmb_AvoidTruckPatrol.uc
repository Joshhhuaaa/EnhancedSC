//=============================================================================
// P_4_1_2_CEmb_AvoidTruckPatrol
//=============================================================================
class P_4_1_2_CEmb_AvoidTruckPatrol extends EPattern;

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
        if (P.name == 'EChineseSoldier5')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier0')
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
Milestone:
    Log("Milestone - Avoid truck patrol");
    Goal_Default(1,GOAL_Patrol,9,,,,'ECS412012_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

