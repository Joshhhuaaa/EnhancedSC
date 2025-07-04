//=============================================================================
// P_4_2_2_Abt_GrinkoSquadA2
//=============================================================================
class P_4_2_2_Abt_GrinkoSquadA2 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'spetsnaz4')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
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
MAIN:
    Log("MAIN SQUAD A2");
MOVEMENT:
    Log("SUB PROGRAM MOVEMENT");
Step1:
    Log("A2step1");
    ResetGoals(1);
    Teleport(1, 'PathNode330');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode260',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode260',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,7,,,'PLAYER','PathNode260','PeekStNtRt2',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,'F1');
    Sleep(3);
F1:
    CheckIfIsDead(1,'DeadAll');
    CheckIfIsUnconscious(1,'DeadAll');
Step2:
    Log("A2Step2");
    ResetGoals(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode272',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode273',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveTo,7,,,,'PathNode273',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,6,,'PathNode294','PLAYER','PathNode273',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveTo,'F2');
    Sleep(3);
F2:
    CheckIfIsDead(1,'DeadAll');
    CheckIfIsUnconscious(1,'DeadAll');
Step3:
    Log("");
    UpdateGoal(1,,TRUE,MOVE_WalkAlert);
    Sleep(2);
    UpdateGoal(1,,FALSE,MOVE_CrouchJog);
    Sleep(0.5);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode273',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'PathNode294','PLAYER','PathNode273',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveTo,'F3');
    Sleep(3);
F3:
    CheckIfIsDead(1,'DeadAll');
    CheckIfIsUnconscious(1,'DeadAll');
Step4:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode325',,FALSE,,MOVE_CrouchJog,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Attack,8,,'PathNode298','PLAYER','PathNode325',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(2);
F4:
    CheckIfIsDead(1,'DeadAll');
    CheckIfIsUnconscious(1,'DeadAll');
Step5:
    Log("");
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint76',,'PathNode325',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_ThrowGrenade,8,,'EFocusPoint76','EFocusPoint76',,,FALSE,0.9,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_ThrowGrenade,);
    Goal_Default(1,GOAL_Attack,7,,'PathNode300','PLAYER','PathNode341',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(4);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode298',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode301',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,7,,'EFocusPoint79','PLAYER','PathNode301',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(4);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode304',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode6',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,7,,'EUSPrisoner3','EUSPrisoner3','PathNode6',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Attack,6,,'EUSPrisoner4','EUSPrisoner4','PathNode6',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Attack,5,,'EUSPrisoner5','EUSPrisoner5','PathNode6',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,4,,,,'PathNode6',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(1);
    Jump('Fin');
Fire1:
    Log("Stand up and fire");
    UpdateGoal(1,,TRUE,MOVE_JogAlert);
    Sleep(1.5);
    UpdateGoal(1,,FALSE,MOVE_CrouchJog);
    Sleep(1);
    Jump('Fin');
DeadAll:
    Log("");
    SetFlags(V4_2_2_Abattoir(Level.VarObject).DeadA2,TRUE);
    SendPatternEvent('EGroupAI24','SquadCount');
    SendPatternEvent('EGroupAI19','MAIN');
    Sleep(1);
    End();
Fin:
    Log("");
    CheckIfIsDead(1,'DeadAll');
    CheckIfIsUnconscious(1,'DeadAll');
    Sleep(2);
    Jump('Fin');

}

