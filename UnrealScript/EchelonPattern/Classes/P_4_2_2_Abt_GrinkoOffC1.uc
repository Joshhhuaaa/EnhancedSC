//=============================================================================
// P_4_2_2_Abt_GrinkoOffC1
//=============================================================================
class P_4_2_2_Abt_GrinkoOffC1 extends EPattern;

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
        if (P.name == 'EAzeriColonel1')
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
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode254',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode288',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,7,,'EFocusPoint80','EFocusPoint80','PathNode290',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_ThrowGrenade,6,,'EFocusPoint80','EFocusPoint80',,,FALSE,0.8,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_ThrowGrenade,);
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode329',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,'EFocusPoint3',,'PathNode308',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_ThrowGrenade,7,,'EFocusPoint3','EFocusPoint3',,,FALSE,0.5,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_ThrowGrenade,);
    Sleep(4);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode507',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,8,,'ELongDan0','ELongDan0','PathNode507',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Attack,7,,'EChineseDignitary0','EChineseDignitary0','PathNode507',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Attack,6,,'EChineseDignitary1','EChineseDignitary1','PathNode507',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,5,,,,'PathNode507',,FALSE,,MOVE_WalkAlert,,MOVE_CrouchJog);
Fin:
    Log("");
    End();
DeadAll:
    Log("");
    SetExclusivity(TRUE);
    SetFlags(V4_2_2_Abattoir(Level.VarObject).DeadC1,TRUE);
    SendPatternEvent('EGroupAI24','SquadCount');
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).GrinkoSpeechTriggered,TRUE,'JumpFin'); // Joshua - Keep track if Grinko already did his speech
    SendPatternEvent('EGroupAI27','GrinkoSpeach2'); // Joshua - Colonel Bagrat fix
    Sleep(1);
    End();
GetToDefaut:
    Log("");
    SetExclusivity(FALSE);
    End();
JumpFin:
    Log("");
    End();
SpawnC:
    Log("");
    Teleport(1, 'PathNode336');
    ResetGoals(1);
    Goal_Default(1,GOAL_Attack,9,,'PathNode253',,'PathNode336',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    End();

}

