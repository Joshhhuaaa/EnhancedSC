//=============================================================================
// P_4_3_2_ThermalKeypadC
//=============================================================================
class P_4_3_2_ThermalKeypadC extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int InElevator;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('KeypadCDeadCheck');
            break;
        case AI_UNCONSCIOUS:
            EventJump('KeypadCDeadCheck');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EChineseSoldier2')
            Characters[1] = P.controller;
        if (P.name == 'EAzeriColonel0')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'ESoundTrigger6')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    InElevator=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ThermalKeypadC:
    Log("Series of keypad in the Palace");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).TruckObjectiveDone,FALSE,'TrucksNotDone');
    Goal_Set(1,GOAL_Patrol,9,,,,'ThermalKeypadCSoldierB_100',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
TrucksNotDone:
    Log("TrucksNotDone");
    SendPatternEvent('LambertComms','TruckFailed');
    End();
TryAgain:
    Log("TryAgain");
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ThermalKeypadCNode04',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveTo,'TryAgain');
    Goal_Set(2,GOAL_InteractWith,9,,,,'WareHouseElevatorPanel',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Wait,8,,'PLAYER','PLAYER',,,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
TeleportNPC:
    Log("TeleportNPC");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).SamInElevator,TRUE,'SamInElevator');
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).NPCwentInElev,TRUE);
    Teleport(2, 'ThermalKeypadCNode05');
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ThermalKeypadCNode02',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,8,,,,'ThermalKeypadCNode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
SamInElevator:
    Log("SamInElevator");
    Goal_Set(2,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
ThermalKeypadCPartB:
    Log("");
    ResetGoals(2);
    Goal_Default(2,GOAL_Guard,8,,,,'ThermalKeypadCnode06',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ThermalKeypadCnode06',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveTo,'ThermalKeypadCPartB');
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).CanKillKeypadC,TRUE);
	SoundActors[0].PlaySound(Sound'Gun.Play_MAKASingleShot', SLOT_SFX);
    Sleep(0.3);
	SoundActors[0].PlaySound(Sound'Gun.Play_MAKASingleShot', SLOT_SFX);
    Sleep(0.1);
	SoundActors[0].PlaySound(Sound'Gun.Play_MAKASingleShot', SLOT_SFX);
    Sleep(1);
	SoundActors[0].PlaySound(Sound'Gun.Play_MAKASingleShot', SLOT_SFX);
    KillNPC(2, FALSE, FALSE);
    End();
KeypadCDeadCheck:
    Log("Check which NPC has been killed");
    CheckIfIsDead(2,'KeypadCKillNPC');
    CheckIfIsUnconscious(2,'KeypadCKillNPC');
    End();
KeypadCKillNPC:
    Log("Check If Sam can kill the NPC");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).CanKillKeypadC,TRUE,'KeypadCKillOK');
    SendPatternEvent('LambertComms','KeypadFailedA');
KeypadCKillOK:
    End();
AISeePlayer:
    Log("If the NPC See Sam");
    Goal_Set(2,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    End();

}

