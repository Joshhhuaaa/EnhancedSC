//=============================================================================
// P_1_2_1DefMin_FirstNPCPattern
//=============================================================================
class P_1_2_1DefMin_FirstNPCPattern extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
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
        if (P.name == 'EGeorgianCop3')
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
    Log("MilestoneFirstNPCPattern");
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNodelibrary',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,8,,'BookFocusForBoth','BookFocusForBoth','PathNodelibrary','LookStNmUp0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,7,,'BookFocusForBoth','BookFocusForBoth','PathNodelibrary','LookStNmDn0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,6,,,,'ClownChairZ',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Wait,5,,,,'FouelletZchair','ReadAsNmNt0',FALSE,,MOVE_Sit,,MOVE_Sit);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).FirstNPCAlerted,TRUE);
    End();

}

