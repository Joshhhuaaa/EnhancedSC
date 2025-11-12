//=============================================================================
// P_5_2_CourtyardAfterShot
//=============================================================================
class P_5_2_CourtyardAfterShot extends EPattern;

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
        if (P.name == 'EEliteForceCristavi12')
            Characters[1] = P.controller;
        if (P.name == 'EEliteForceCristavi9')
            Characters[2] = P.controller;
        if (P.name == 'EEliteForceCristavi10')
            Characters[3] = P.controller;
        if (P.name == 'EEliteForceCristavi11')
            Characters[4] = P.controller;
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
NoExtra:
    Log("NoExtra");
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ResetGoals(4);
    ChangeGroupState('s_alert');
    ePawn(Characters[1].Pawn).Bark_Type = BARK_CombArea;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PostPatrolUpZ',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Search,8,,,,'PostPatrolUpZ',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,9,,,,'UnnamedA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Search,8,,,,'UnnamedA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PostPatrolUpA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Search,8,,,,'PostPatrolUpA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(4,GOAL_MoveTo,9,,,,'GuradEntry',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Search,8,,,,'GuradEntry',,FALSE,,MOVE_Search,,MOVE_Search);
    End();

}

