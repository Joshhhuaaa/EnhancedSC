//=============================================================================
// P_3_1_1_Ship_CRTrap
//=============================================================================
class P_3_1_1_Ship_CRTrap extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


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
        if (P.name == 'spetsnaz13')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz15')
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
Start:
    Log("");
OpenDoor:
    Log("open door between CR and Hangar");
    SendUnrealEvent('Mover11');
TakePosition:
    Log("set guards in position");
    ResetGroupGoals();
    Teleport(1, 'PathNode128');
    Teleport(2, 'PathNode97');
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode94',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint25','PLAYER','PathNode94',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode98',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint25','PLAYER','PathNode98',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
Advance:
    Log("");
    Sleep(6);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','PathNode118',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode118',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode115',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode115',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(4);
    Log("Frag 1");
    Goal_Set(2,GOAL_ThrowGrenade,6,,'EFocusPoint40','EFocusPoint40',,,TRUE,0.7,,,);
    Goal_Default(2,GOAL_Attack,5,,'EFocusPoint25','PLAYER','PathNode115',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(3);
    Goal_Set(1,GOAL_ThrowGrenade,6,,'EFocusPoint41','EFocusPoint41',,,TRUE,0.7,,,);
    Goal_Default(1,GOAL_Attack,5,,'EFocusPoint25','PLAYER','PathNode118',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(5);
    Goal_Set(1,GOAL_MoveAndAttack,4,,,'PLAYER','PathNode127',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,3,,'PathNode136','PLAYER','PathNode127',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_MoveAndAttack,4,,,'PLAYER','PathNode126',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Attack,3,,'PathNode138','PLAYER','PathNode126',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(4);
    ResetGroupGoals();
    Log("Frag2");
    Goal_Default(1,GOAL_Attack,9,,'EFocusPoint42','PLAYER','PathNode127',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_ThrowGrenade,9,,'EFocusPoint43','EFocusPoint43',,,TRUE,0.8,,,);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint43','PLAYER','PathNode126',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(3);
    Goal_Set(1,GOAL_ThrowGrenade,8,,'EFocusPoint42','EFocusPoint42',,,TRUE,0.8,,,);
    Goal_Set(1,GOAL_Attack,7,,'EFocusPoint42','PLAYER','PathNode127',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(3);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,'EFocusPoint42',,'PathNode203',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint42','PLAYER','PathNode203',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'EFocusPoint43',,'PathNode202',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint43','PLAYER','PathNode202',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(4);
    SetExclusivity(FALSE);
    End();
JumpFin:
    Log("");
    End();

}

defaultproperties
{
}
