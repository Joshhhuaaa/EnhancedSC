//=============================================================================
// P_4_1_2_CEmb_Alley
//=============================================================================
class P_4_1_2_CEmb_Alley extends EPattern;

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
        if (P.name == 'EChineseSoldier4')
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
WalkwayGuard:
    Log("This triggers the soldier on the walkway.");
    Goal_Set(1,GOAL_MoveTo,9,,,,'ECSAlleyDude_900',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'ECSAlleyDude_900',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

