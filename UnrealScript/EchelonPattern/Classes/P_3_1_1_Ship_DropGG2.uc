//=============================================================================
// P_3_1_1_Ship_DropGG2
//=============================================================================
class P_3_1_1_Ship_DropGG2 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('SetGuard');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SetGuard');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('SetGuard');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('SetGuard');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SetGuard');
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
        if (P.name == 'spetsnaz5')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle0')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SetGuard:
    Log("guard take defensive position");
    CheckFlags(pass1,TRUE,'Jumpfin');
    DisableMessages(TRUE, FALSE);
    SetFlags(pass1,TRUE);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode168',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint71','PLAYER','PathNode168',,FALSE,,MOVE_JogAlert,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_InteractWith,9,,,,'EAlarmPanel9',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PathNode161',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,7,,'EFocusPoint71','EFocusPoint71','PathNode161',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
CloseCombat:
    Log("close combat routine");
    CheckFlags(pass1,FALSE,'Jumpfin');
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'PathNode158',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint7','PLAYER','PathNode158',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(2);
    ResetGoals(1);
    Goal_Default(1,GOAL_Attack,9,,'PLAYER','PLAYER','PathNode168',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(4);
    SetExclusivity(FALSE);
    DisableMessages(FALSE, FALSE);
    End();
G2attk:
    Log("guard2 attack");
    CheckFlags(pass1,FALSE,'Jumpfin');
    Goal_Default(2,GOAL_Attack,6,,'EFocusPoint71','PLAYER','PathNode161',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
Jumpfin:
    Log("");
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
