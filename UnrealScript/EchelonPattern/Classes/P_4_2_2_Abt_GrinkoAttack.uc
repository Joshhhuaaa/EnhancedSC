//=============================================================================
// P_4_2_2_Abt_GrinkoAttack
//=============================================================================
class P_4_2_2_Abt_GrinkoAttack extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int UPorDOWN;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('Fin');
            break;
        // Joshua - The player must kill Grinko to complete the mission, a knockout will no longer complete the objective
        //case AI_UNCONSCIOUS:
        //    EventJump('Fin');
        //    break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local EInventoryItem Inv;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EGrinko0')
        {
            Characters[1] = P.controller;

            // Joshua - Apply custom skin to Grinko's AK-47
            Inv = EPawn(P).FullInventory.GetItemByClass('EAK_47');
            if (Inv != None)
            {
                Inv.Skins[0] = Texture'ETexIngredient.Weapons.ak47_Grinko';
            }
            
            EAIController(Characters[1]).bAllowKill = true;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bWasFound = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    UPorDOWN=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SpawnG:
    Log("");
    Teleport(1, 'PathNode27');
    ResetGoals(1);
    Goal_Default(1,GOAL_Attack,9,,'PathNode249',,'PathNode27',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Main:
    Log("");
    SendPatternEvent('EGroupAI28','KillGrinko');
Action:
    Log("");
    JumpRandom('PositionA', 0.50, 'PositionB', 1.00, , , , , ,); 
PositionA:
    Log("");
    JumpRandom('PosAstanding', 0.40, 'PosAcrouch', 1.00, , , , , ,); 
PosAstanding:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode261',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode261',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(3);
    JumpRandom('PositionA2', 0.30, 'PositionB', 0.80, 'PosAcrouch', 1.00, , , ,); 
PosAcrouch:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode261',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode261',,TRUE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(3);
    JumpRandom('PositionA2', 0.30, 'PositionB', 0.80, 'PosAstanding', 1.00, , , ,); 
PositionA2:
    Log("");
    JumpRandom('PosA2standing', 0.40, 'PosA2crouch', 1.00, , , , , ,); 
PosA2standing:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode254',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode254',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(3);
    JumpRandom('PositionA', 0.70, 'PosA2crouch', 1.00, , , , , ,); 
PosA2crouch:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode254',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode254',,TRUE,,MOVE_WalkAlert,,MOVE_CrouchWalk);
    Sleep(3);
    JumpRandom('PositionA', 0.70, 'PosA2standing', 1.00, , , , , ,); 
PositionB:
    Log("");
    JumpRandom('PosBstanding', 0.40, 'PosBcrouch', 1.00, , , , , ,); 
PosBstanding:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode258',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode258',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(3);
    JumpRandom('PositionA', 0.45, 'PositionB2', 0.70, 'PositionC', 0.85, 'PosBcrouch', 1.00, ,); 
PosBcrouch:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode258',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode258',,TRUE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(3);
    JumpRandom('PositionA', 0.45, 'PositionB2', 0.70, 'PositionC', 0.85, 'PosBstanding', 1.00, ,); 
PositionB2:
    Log("");
    JumpRandom('PosB2standing', 0.40, 'PosB2crouch', 1.00, , , , , ,); 
PosB2standing:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode260',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode260',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(3);
    JumpRandom('PositionB', 0.40, 'PositionC', 0.80, 'PosB2crouch', 1.00, , , ,); 
PosB2crouch:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode260',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','PathNode260',,TRUE,,MOVE_WalkAlert,,MOVE_CrouchWalk);
    Sleep(3);
    JumpRandom('PositionB', 0.40, 'PositionC', 0.80, 'PosB2standing', 1.00, , , ,); 
PositionC:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode331',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,'PLAYER','PathNode266',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,7,,,'PLAYER','PathNode269',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    JumpRandom('PosCstanding', 0.40, 'PosCcrouch', 1.00, , , , , ,); 
PosCstanding:
    Log("");
    Goal_Default(1,GOAL_Attack,5,,,'PLAYER','PathNode269',,TRUE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Jump('JumpOut');
PosCcrouch:
    Log("");
    Goal_Default(1,GOAL_Attack,5,,,'PLAYER','PathNode269',,TRUE,,MOVE_CrouchJog,,MOVE_CrouchJog);
JumpOut:
    Log("");
    Sleep(3);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode266',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,'PLAYER','PathNode331',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    JumpRandom('PositionA', 0.30, 'PositionB', 0.50, 'PositionB2', 1.00, , , ,); 
Fin:
    Log("");
    SetFlags(V4_2_2_Abattoir(Level.VarObject).DeadGrinko,TRUE);
    End();
JumpFin:
    Log("");
    End();

}

