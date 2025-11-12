//=============================================================================
// P_3_1_2_Ship_CRtrap
//=============================================================================
class P_3_1_2_Ship_CRtrap extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CombatReady;
var int pass1;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Combat');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Combat');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Combat');
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
        if (P.name == 'spetsnaz0')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz7')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz10')
            Characters[3] = P.controller;
        if (P.name == 'spetsnaz11')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    CombatReady=0;
    pass1=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
GuardComm:
    Log("Communication between guards");
LvlChek:
    Log("Chek level variable.  pattern RaiseSub must be done befor pattern CRtrap");
    CheckFlags(V3_1_2_ShipYard(Level.VarObject).CRtrapPass1,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    CheckFlags(CombatReady,TRUE,'JumpFin');
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevGuard,TRUE);
    SetFlags(pass1,FALSE);
    Speech(Localize("P_3_1_2_Ship_CRtrap", "Speech_0001L", "Localization/P_3_1_2_ShipYard"), None, 2, 0, TR_NPCS, 0);
    Sleep(3);
    CinCamera(0,'EFocusPoint28','EFocusPoint60');
    Sleep(2);
    CinCamera(1,,);
    Speech(Localize("P_3_1_2_Ship_CRtrap", "Speech_0002L", "Localization/P_3_1_2_ShipYard"), None, 2, 0, TR_NPCS, 0);
    Sleep(3);
    CinCamera(0,'EFocusPoint30','EFocusPoint60');
    Sleep(2);
    CinCamera(1,,);
    Speech(Localize("P_3_1_2_Ship_CRtrap", "Speech_0003L", "Localization/P_3_1_2_ShipYard"), None, 2, 0, TR_NPCS, 0);
    Sleep(1);
Teleport:
    Log("teleport the guard from cube1 to elevator");
    Jump('Charge');
    ResetGroupGoals();
    Teleport(3, 'PathNode205');
    Teleport(4, 'PathNode203');
    Teleport(1, 'PathNode209');
    Teleport(2, 'PathNode201');
    Sleep(1);
Charge:
    Log("guards coming out of the elevator");
    ResetGroupGoals();
    Teleport(3, 'PathNode205');
    Goal_Default(3,GOAL_Patrol,9,,,,'spetsnaz10_0',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Teleport(4, 'PathNode203');
    Goal_Default(4,GOAL_Patrol,9,,,,'spetsnaz11_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Teleport(1, 'PathNode209');
    Goal_Default(1,GOAL_Patrol,9,,,,'spetsnaz0_0',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Teleport(2, 'PathNode201');
    Goal_Default(2,GOAL_Patrol,9,,,,'spetsnaz7_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SetFlags(V3_1_2_ShipYard(Level.VarObject).CRtrapPass1,FALSE);
    Sleep(1);
    DisableMessages(FALSE, FALSE);
    End();
CamElev:
    Log("Set camera for guard elevator");
    CheckFlags(pass1,TRUE,'JumpFin');
    CheckFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,TRUE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    SetFlags(pass1,TRUE);
    CinCamera(0,'EFocusPoint29','EFocusPoint60');
    Sleep(5);
    CinCamera(1,,);
    DisableMessages(FALSE, FALSE);
    End();
Combat:
    Log("Combat pattern once the player is detected.");
    SetFlags(CombatReady,TRUE);
LastZoneChek:
    Log("Jump to last zone of player");
    JumpToLastZoneTouched();
    End();
Zone1:
    Log("Zone1");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,FALSE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(3,GOAL_MoveAndAttack,9,,'EFocusPoint21',,'PathNode611',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,'EFocusPoint21','PLAYER','PathNode611',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveAndAttack,9,,'EFocusPoint22',,'PathNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_Attack,8,,'EFocusPoint22','PLAYER','PathNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'spetsnaz11_600',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint18','PLAYER','spetsnaz11_600',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'spetsnaz11_887',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint20','PLAYER','spetsnaz11_887',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    WaitForGoal(2,GOAL_MoveAndAttack,);
    Goal_Set(1,GOAL_ThrowGrenade,9,,,,'EFocusPoint18',,FALSE,0.4,,,);
    Goal_Set(2,GOAL_ThrowGrenade,9,,,,'EFocusPoint20',,FALSE,0.4,,,);
    Sleep(3);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','spetsnaz11_800',,FALSE,,MOVE_JogAlert,,MOVE_Search);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','spetsnaz11_850',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(1);
    SetExclusivity(FALSE);
    End();
Zone2:
    Log("Zone2");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,FALSE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'PathNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'EFocusPoint21','PLAYER','PathNode',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_MoveAndAttack,9,,'EFocusPoint22',,'PathNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'EFocusPoint22','PLAYER','PathNode',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'spetsnaz10_750',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint21','PLAYER','spetsnaz10_750',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'spetsnaz11_1000',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint22','PLAYER','spetsnaz11_1000',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    DisableMessages(FALSE, FALSE);
    End();
Zone3:
    Log("Zone3");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,FALSE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(4,GOAL_MoveAndAttack,9,,'EFocusPoint2',,'spetsnaz11_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_ThrowGrenade,8,,,,'EFocusPoint12',,FALSE,0.5,,,);
    Goal_Set(4,GOAL_MoveTo,7,,,,'spetsnaz0_900',,FALSE,,,,);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'spetsnaz10_550',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Attack,8,,'PLAYER','PLAYER','spetsnaz10_550',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'EFocusPoint4',,'spetsnaz11_1200',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,,'PLAYER','spetsnaz11_1200',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'EFocusPoint4',,'PathNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint4','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,6,,,,'spetsnaz7_600',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,5,,'EFocusPoint4','PLAYER','spetsnaz7_600',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    DisableMessages(FALSE, FALSE);
    End();
Zone4:
    Log("Zone4");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,FALSE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(4,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','spetsnaz11_400',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'PLAYER','PLAYER','spetsnaz11_400',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'EFocusPoint4','PLAYER','spetsnaz10_550',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint4','PLAYER','spetsnaz10_550',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'EFocusPoint4','PLAYER','PathNode609',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint11','PLAYER','PathNode609',,FALSE,,,,);
    Goal_Set(3,GOAL_MoveTo,9,,'EFocusPoint11','PLAYER','spetsnaz11_1100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(3,GOAL_MoveTo,);
    Goal_Set(3,GOAL_ThrowGrenade,8,,,,'EFocusPoint11',,FALSE,0.5,,,);
    Goal_Default(3,GOAL_Attack,7,,'EFocusPoint11','PLAYER','spetsnaz11_1100',,FALSE,,,,);
    WaitForGoal(3,GOAL_ThrowGrenade,);
    Sleep(2);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','PathNode592',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint11','PLAYER','PathNode592',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    SetExclusivity(FALSE);
    End();
Zone5:
    Log("Zone5");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,FALSE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(3,GOAL_MoveTo,9,,,,'spetsnaz0_100',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Attack,8,,'EFocusPoint9','PLAYER','spetsnaz0_100',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_MoveAndAttack,9,,,,'spetsnaz11_100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'EFocusPoint9','PLAYER','spetsnaz11_100',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode564',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint1','PLAYER','PathNode564',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'spetsnaz10_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint1','PLAYER','spetsnaz10_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    WaitForGoal(4,GOAL_MoveAndAttack,);
    ResetGoals(1);
    Goal_Set(1,GOAL_ThrowGrenade,9,,,,'EFocusPoint1',,FALSE,0.7,,,);
    Goal_Set(1,GOAL_Attack,8,,'EFocusPoint1','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_ThrowGrenade,);
    ResetGoals(4);
    Goal_Set(4,GOAL_ThrowGrenade,9,,,,'EFocusPoint1',,FALSE,0.7,,,);
    Goal_Set(4,GOAL_Attack,8,,'EFocusPoint1','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(4,GOAL_ThrowGrenade,);
    Sleep(3);
    ResetGoals(4);
    Goal_Set(4,GOAL_MoveTo,9,,'PLAYER','PLAYER','PathNode198',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_Attack,8,,'PLAYER','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(2);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','PathNode211',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode211',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(4,GOAL_MoveTo,);
    SetExclusivity(FALSE);
    End();
Zone6:
    Log("Zone6");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,TRUE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(3,GOAL_MoveTo,9,,,,'spetsnaz0_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'PLAYER','PLAYER','spetsnaz0_200',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode564',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode564',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','spetsnaz10_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'PLAYER','PLAYER','spetsnaz10_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','spetsnaz11_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'PLAYER','PLAYER','spetsnaz11_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_Stop,9,,'PLAYER','PLAYER',,,TRUE,2,MOVE_CrouchJog,,MOVE_CrouchJog);
    DisableMessages(FALSE, FALSE);
    End();
Zone7:
    Log("Zone7");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,FALSE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','PathNode185',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint0','PLAYER','PathNode185',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveTo,9,,,,'spetsnaz7_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint0','PLAYER','spetsnaz7_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveAndAttack,9,,'EFocusPoint10','PLAYER','spetsnaz0_800',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'EFocusPoint10','PLAYER','spetsnaz0_800',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,'EFocusPoint0','PLAYER','spetsnaz0_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'EFocusPoint59','PLAYER','spetsnaz0_200',,FALSE,,,,);
    CheckIfIsDead(2,'gren4');
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(2,GOAL_ThrowGrenade,9,,,,'EFocusPoint10',,FALSE,0.5,,,);
    Goal_Default(2,GOAL_Attack,8,,'spetsnaz0_500','PLAYER','spetsnaz7_200',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(2,GOAL_ThrowGrenade,);
    Jump('normal');
gren4:
    Log("4 throw gren insted of 2");
    CheckFlags(CombatReady,FALSE,'JumpFin');
    WaitForGoal(4,GOAL_MoveAndAttack,);
    ResetGoals(4);
    Goal_Set(4,GOAL_MoveTo,9,,,,'spetsnaz7_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_ThrowGrenade,8,,,,'EFocusPoint10',,FALSE,0.5,,,);
    Goal_Default(4,GOAL_Attack,7,,'EFocusPoint10','PLAYER','spetsnaz7_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(4,GOAL_ThrowGrenade,);
normal:
    Log("jump if 2 is alive. so 4 dont throw again");
    CheckFlags(CombatReady,FALSE,'JumpFin');
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode185',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode185',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(1);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'EFocusPoint10','PLAYER','spetsnaz0_500',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Attack,8,,'PLAYER','PLAYER','spetsnaz0_500',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','spetsnaz7_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,7,,'PLAYER','PLAYER','spetsnaz7_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(3,GOAL_MoveAndAttack,);
    SetExclusivity(FALSE);
    End();
Zone8:
    Log("Zone8");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,TRUE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(3,GOAL_MoveTo,9,,,'PLAYER','spetsnaz7_700',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'EFocusPoint6','PLAYER','spetsnaz7_700',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,9,,,'PLAYER','spetsnaz0_1000',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint6','PLAYER','spetsnaz0_1000',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveAndAttack,9,,'EFocusPoint2','PLAYER','spetsnaz10_550',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'EFocusPoint2','PLAYER','spetsnaz10_550',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'EFocusPoint2','PLAYER','spetsnaz0_800',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint2','PLAYER','spetsnaz0_800',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    DisableMessages(FALSE, FALSE);
    End();
Zone9:
    Log("Zone9");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).ElevCamDanger,FALSE);
    CheckFlags(CombatReady,FALSE,'JumpFin');
    DisableMessages(TRUE, TRUE);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'spetsnaz0_1000',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint13','PLAYER','spetsnaz0_1000',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveTo,9,,,,'spetsnaz7_700',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PathNode569',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Attack,8,,'EFocusPoint6','PLAYER','PathNode569',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_MoveTo,9,,,,'spetsnaz0_900',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'EFocusPoint6','PLAYER','spetsnaz0_900',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(2,GOAL_ThrowGrenade,8,,,,'EFocusPoint13',,FALSE,0.5,,,);
    Goal_Default(2,GOAL_Attack,7,,'EFocusPoint13','PLAYER','spetsnaz7_700',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_ThrowGrenade,);
    Goal_Set(1,GOAL_MoveTo,9,,,,'spetsnaz0_1000',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint6','PLAYER','spetsnaz0_1000',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(3);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'spetsnaz0_1200',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint7','PLAYER','spetsnaz0_1200',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'EAzeriColonel0_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint7','PLAYER','EAzeriColonel0_200',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'spetsnaz7_800',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'EFocusPoint7','PLAYER','spetsnaz7_800',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,9,,,,'PathNode569',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(4,GOAL_MoveTo,);
    SetExclusivity(FALSE);
    End();
JumpFin:
    Log("JumpFin");
    DisableMessages(FALSE, FALSE);
    End();

}

defaultproperties
{
}
