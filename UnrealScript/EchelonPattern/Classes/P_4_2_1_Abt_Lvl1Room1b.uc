//=============================================================================
// P_4_2_1_Abt_Lvl1Room1b
//=============================================================================
class P_4_2_1_Abt_Lvl1Room1b extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('GoOut');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('GoOut');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('GoOut');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GoOut');
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
        if(P.name == 'EGeorgianSoldier0')
            Characters[1] = P.controller;
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
Start:
    Log("");
    SetFlags(V4_2_1_Abattoir(Level.VarObject).Room1Pass1,TRUE);
    Teleport(1, 'PathNode471');
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode101',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'PathNode99','PathNode99','PathNode101',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
GoOut:
    Log("");
    SetExclusivity(FALSE);
    End();
patrol:
    Log("");
    SetExclusivity(FALSE);
    Sleep(5);
    SetFlags(V4_2_1_Abattoir(Level.VarObject).Room1Pass1,TRUE);
    Teleport(1, 'PathNode471');
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode93',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Wait,8,,,,'EGameplayObject',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(4);
    Goal_Set(1,GOAL_MoveTo,7,,,,'PathNode471',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,6,,'EFocusPoint14',,'PathNode471',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

