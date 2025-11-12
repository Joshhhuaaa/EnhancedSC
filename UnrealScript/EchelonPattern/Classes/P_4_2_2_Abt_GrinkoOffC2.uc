//=============================================================================
// P_4_2_2_Abt_GrinkoOffC2
//=============================================================================
class P_4_2_2_Abt_GrinkoOffC2 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('DeadAll');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GetToDefaut');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DeadAll');
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
        if (P.name == 'EAzeriColonel3')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
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
MAIN:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode260',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode341',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveTo,7,,,,'PathNode304',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_ThrowGrenade,6,,'PathNode6','PathNode6',,,FALSE,0.5,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,5,,'PathNode312','PLAYER','PathNode304',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    WaitForGoal(1,GOAL_ThrowGrenade,);
    Sleep(4);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode6',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,8,,'EUSPrisoner3','EUSPrisoner3','PathNode6',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Attack,7,,'EUSPrisoner4','EUSPrisoner4','PathNode6',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Attack,6,,'EUSPrisoner5','EUSPrisoner5','PathNode6',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,5,,,,'PathNode6',,FALSE,,MOVE_WalkAlert,,MOVE_CrouchJog);
Fin:
    Log("");
    End();
DeadAll:
    Log("");
    SetExclusivity(TRUE);
    SetFlags(V4_2_2_Abattoir(Level.VarObject).DeadC2,TRUE);
    SendPatternEvent('EGroupAI24','SquadCount');
    Sleep(1);
    End();
GetToDefaut:
    Log("");
    SetExclusivity(FALSE);
    Jump('Fin');
JumpFin:
    Log("");
    End();
SpawnC:
    Log("");
    Teleport(1, 'PathNode335');
    ResetGoals(1);
    Goal_Default(1,GOAL_Attack,9,,'PathNode333',,'PathNode335',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    End();

}

