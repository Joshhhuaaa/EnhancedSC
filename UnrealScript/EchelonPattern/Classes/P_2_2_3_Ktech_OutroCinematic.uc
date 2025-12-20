//=============================================================================
// P_2_2_3_Ktech_OutroCinematic
//=============================================================================
class P_2_2_3_Ktech_OutroCinematic extends EPattern;

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
        if (P.name == 'EWilkes1')
        {
            Characters[1] = P.controller;
            // Joshua - Make Wilkes invincible before/during cinematic so player can't knockout or kill
            EAIController(Characters[1]).bIgnoreDamage = true;
        }
        if (P.name == 'EMafiaMuscle18')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
        if (P.name == 'EMafiaMuscle19')
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
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
OutroCinematicStart:
    Log("OutroCinematicStart");
    EAIController(Characters[1]).bIgnoreDamage = false; // Joshua - Allow Wilkes to take damage now for scripted death
    Teleport(2, 'OutroCinematicMafiosoTeleport');
    ResetGroupGoals();
    Goal_Default(2,GOAL_Guard,9,,'OutroCinematicTarget02','OutroCinematicTarget02',,,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,9,,'WilkesFocus','WilkesFocus',,,TRUE,5,MOVE_WalkNormal,,MOVE_WalkNormal);
    CinCamera(0, 'OutroCinematicPosition01', 'OutroCinematicTarget01',);
    Sleep(2);
    CinCamera(1, , ,);
    CinCamera(0, 'OutroCinematicPosition02', 'OutroCinematicTarget02',);
    Goal_Set(2,GOAL_Action,9,,'OutroCinematicTarget02','OutroCinematicTarget02',,'PeekStBgRt2',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_Action,);
    Goal_Set(2,GOAL_Attack,9,,'MafiosoTargetA','MafiosoTargetA',,'PeekStNtRt2',TRUE,4,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Action,8,,'OutroCinematicMafioso','OutroCinematicMafioso',,'ReacStNmZZ0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,'OutroCinematicMafioso','OutroCinematicMafioso','WilkesFightingNode','HurtStAlAl0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,'OutroCinematicMafioso','OutroCinematicMafioso','WilkesFightingNodeB',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    SendUnrealEvent('DeathAnimVolume');
    CinCamera(1, , ,);
    CinCamera(0, 'OutroCinematicPosition03', 'OutroCinematicTarget03',);
    ResetGroupGoals();
    ChangeState(1,'s_investigate');
    Goal_Default(1,GOAL_Guard,9,,'MafiosoTargetC','MafiosoTargetC','WilkesFightingNodeB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,9,,'WilkesTargetB','WilkesTargetB',,,TRUE,10,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(2);
    Goal_Set(2,GOAL_Action,9,,'EWilkes','EWilkes',,'PeekStBgRt2',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_Action,);
    Goal_Set(2,GOAL_Attack,9,,'MafiosoTargetC','MafiosoTargetC',,'PeekStNtRt2',TRUE,6,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(3);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'HurtStAlAl0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    KillNPC(1, FALSE, FALSE);
    Sleep(1);
    CinCamera(1, , ,);
    CinCamera(0, 'OutroCinematicPosition04', 'OutroCinematicTarget04',);
    Sleep(3);
    CinCamera(1, , ,);
    SendUnrealEvent('DeathAnimVolume');
    Jump('OspreyHunting');
    End();
OspreyHunting:
    Log("An NPC climbs the ladders and Shoots the Osprey");
    ResetGoals(2);
    ResetGoals(2);
    Goal_Default(2,GOAL_Guard,9,,,,'ShootOspreyNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ShootOspreyNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,8,,'22OSPREY','22OSPREY','ShootOspreyNode',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,9,,'22OSPREY','22OSPREY','OspreyHuntingNode01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'OspreyHuntingNode01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_Attack,8,,'22OSPREY','22OSPREY','OspreyHuntingNode01',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    SetExclusivity(FALSE);
    End();
MissionEnds:
    Log("Mission Success");
    GameOver(true, 0);
    End();

}

