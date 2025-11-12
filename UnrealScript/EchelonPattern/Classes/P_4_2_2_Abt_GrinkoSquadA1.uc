//=============================================================================
// P_4_2_2_Abt_GrinkoSquadA1
//=============================================================================
class P_4_2_2_Abt_GrinkoSquadA1 extends EPattern;

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
        if (P.name == 'spetsnaz0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if (P.name == 'spetsnaz2')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
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
    Log("A1 Main");
MOVEMENT:
    Log("SUB PROGRAM MOVEMENT");
Step1:
    Log("A1step1");
    ResetGoals(1);
    ResetGoals(2);
    Teleport(1, 'PathNode251');
    Teleport(2, 'PathNode334');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode261',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode261',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'PathNode254',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PathNode254',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,7,,,'PLAYER','PathNode254',,FALSE,0,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveTo,'F1');
    Sleep(1);
F1:
    CheckIfIsDead(1,'f1dead');
    CheckIfIsUnconscious(1,'f1dead');
    Jump('Step2');
f1dead:
    CheckIfIsDead(2,'DeadAll');
    CheckIfIsUnconscious(2,'DeadAll');
Step2:
    Log("A1Step2");
    ResetGoals(2);
    Goal_Default(2,GOAL_Attack,9,,,'PLAYER','PathNode254','PeekStNtLt2',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(2);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode277',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode279',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,7,,'PathNode326','PLAYER','PathNode279',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(2);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'PathNode276',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,8,,,,'PathNode278',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveTo,7,,,,'PathNode278',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Attack,6,,'PathNode294','PLAYER','PathNode278',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(2,GOAL_MoveTo,'F2');
    Sleep(1);
F2:
    CheckIfIsDead(1,'f2dead');
    CheckIfIsUnconscious(1,'f2dead');
    Jump('Step3');
f2dead:
    CheckIfIsDead(2,'DeadAll');
    CheckIfIsUnconscious(2,'DeadAll');
Step3:
    Log("A1step3");
    UpdateGoal(1,'PathNode279',TRUE,MOVE_WalkAlert);
    Sleep(0.5);
    UpdateGoal(2,'PathNode278',TRUE,MOVE_WalkAlert);
    Sleep(1.5);
    UpdateGoal(1,'PathNode279',FALSE,MOVE_CrouchJog);
    Sleep(0.5);
    UpdateGoal(2,'PathNode278',FALSE,MOVE_CrouchJog);
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode279',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'PathNode326','PLAYER','PathNode279',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveTo,'F3');
    Sleep(1);
F3:
    CheckIfIsDead(1,'f3dead');
    CheckIfIsUnconscious(1,'f3dead');
    Jump('Step4');
f3dead:
    CheckIfIsDead(2,'DeadAll');
    CheckIfIsUnconscious(2,'Step4');
Step4:
    Log("A1step4");
    UpdateGoal(2,'PathNode278',TRUE,MOVE_JogAlert);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode327',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'PathNode296','PLAYER','PathNode327',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode279',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PathNode288',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,7,,'PathNode326','PLAYER','PathNode288',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveTo,'F4');
    Sleep(1);
F4:
    CheckIfIsDead(1,'f4dead');
    CheckIfIsUnconscious(1,'f4dead');
    Jump('Step5');
f4dead:
    CheckIfIsDead(2,'DeadAll');
    CheckIfIsUnconscious(2,'DeadAll');
Step5:
    Log("A1step5");
    ResetGroupGoals();
    Goal_Default(1,GOAL_Attack,9,,'PathNode314','PLAYER','PathNode327',,TRUE,3,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,'EFocusPoint68b',,'PathNode290',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_ThrowGrenade,8,,'EFocusPoint68b','EFocusPoint68b',,,FALSE,0.8,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Attack,7,,'PathNode326','PLAYER','PathNode290',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(6);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode329',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode337',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,7,,,,'PathNode311',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,6,,,,'PathNode507',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,5,,'ELongDan0','ELongDan0',,,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Attack,4,,'EChineseDignitary0','EChineseDignitary0',,,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Attack,3,,'EChineseDignitary1','EChineseDignitary1',,,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,2,,'EFocusPoint19',,'PathNode507',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'PathNode297',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,8,,,,'PathNode299',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,7,,,,'PathNode308',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,6,,,,'PathNode312',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,5,,,,'PathNode6',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,4,,'EUSPrisoner3','EUSPrisoner3','PathNode6',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_Attack,3,,'EUSPrisoner4','EUSPrisoner4','PathNode6',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Attack,2,,'EUSPrisoner5','EUSPrisoner5','PathNode6',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,1,,'EFocusPoint73',,'PathNode6',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,'Fin');
    WaitForGoal(2,GOAL_MoveTo,'Fin');
    Sleep(2);
    Jump('Fin');
Fire1:
    Log("Stand up and fire");
    UpdateGoal(1,,TRUE,MOVE_JogAlert);
    Sleep(0.5);
    UpdateGoal(2,,TRUE,MOVE_JogAlert);
    Sleep(1.5);
    UpdateGoal(1,,FALSE,MOVE_CrouchJog);
    Sleep(0.5);
    UpdateGoal(2,,FALSE,MOVE_CrouchJog);
    Sleep(1);
    Jump('Fin');
DeadAll:
    Log("A1 DeadAll");
    SetFlags(V4_2_2_Abattoir(Level.VarObject).DeadA1,TRUE);
    SendPatternEvent('EGroupAI24','SquadCount');
    SendPatternEvent('EGroupAI12','MAIN');
    Sleep(1);
    End();
Fin:
    Log("fin a1");
    Sleep(1);
    CheckIfIsDead(1,'TestDeathB');
    CheckIfIsUnconscious(1,'TestDeathB');
    Jump('Fin');
TestDeathB:
    Log("");
    CheckIfIsDead(2,'DeadAll');
    CheckIfIsUnconscious(2,'DeadAll');
    Jump('Fin');

}

