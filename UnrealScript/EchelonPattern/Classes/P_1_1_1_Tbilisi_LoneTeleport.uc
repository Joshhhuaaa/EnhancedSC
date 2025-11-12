//=============================================================================
// P_1_1_1_Tbilisi_LoneTeleport
//=============================================================================
class P_1_1_1_Tbilisi_LoneTeleport extends EPattern;

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
        if (P.name == 'EGeorgianCop2')
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
    Log("This pattern brings Leon into the map.");
LeonBlink:
    Log("Teleporting Leon");
    Teleport(1, 'Leon_0');
    ResetGroupGoals();
    ChangeState(1,'s_default');
    Goal_Default(1,GOAL_Patrol,0,,,,'Leon_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

