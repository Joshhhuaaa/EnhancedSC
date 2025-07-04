//=============================================================================
// P_3_2_2_NPP_RelayRoom
//=============================================================================
class P_3_2_2_NPP_RelayRoom extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Reinforce;
var int Shutter1Alive;
var int Shutter2Alive;
var int Shutter3Alive;


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
        if(P.name == 'EFalseRussianSoldier3')
            Characters[1] = P.controller;
        if(P.name == 'EFalseRussianSoldier2')
            Characters[2] = P.controller;
        if(P.name == 'EFalseRussianSoldier4')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Reinforce=0;
    Shutter1Alive=1;
    Shutter2Alive=1;
    Shutter3Alive=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
DuckHunt:
    Log("Sam has passed the turrets, begin the Duck Hunt gameplay.");
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    Goal_Set(2,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    Goal_Set(3,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
Randomize1:
    Log("First set of 3 selected.");
    Sleep(0.75);
    JumpRandom('SlotOneUp', 0.40, 'SlotOneDown', 0.60, 'SlotTwoUp', 1.00, , , , ); 
    End();
Randomize2:
    Log("Second set of 3 selected.");
    Sleep(0.75);
    JumpRandom('SlotTwoDown', 0.30, 'SlotThreeUp', 0.65, 'SlotThreeDown', 1.00, , , , ); 
    End();
SlotOneUp:
    Log("Triggers ShutterDude1 to shoot standing.");
    JumpRandom('SlotOneUpTeleport1', 0.33, 'SlotOneUpTeleport2', 0.67, 'SlotOneUpTeleport3', 1.00, , , , ); 
SlotOneUpX:
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    SendUnrealEvent('CafeShutter1');
    Sleep(2);
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    SendUnrealEvent('CafeShutter1');
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
SlotOneUpTeleport1:
    Log("Teleport.");
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    Teleport(1, 'Shutter1Node1');
    UpdateGoal(1,'Shutter1Node1',FALSE,MOVE_WalkAlert);
    Jump('SlotOneUpX');
    End();
SlotOneUpTeleport2:
    Log("Teleport.");
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    Teleport(1, 'Shutter1Node2');
    UpdateGoal(1,'Shutter1Node2',FALSE,MOVE_WalkAlert);
    Jump('SlotOneUpX');
    End();
SlotOneUpTeleport3:
    Log("Teleport.");
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    Teleport(1, 'Shutter1Node3');
    UpdateGoal(1,'Shutter1Node3',FALSE,MOVE_WalkAlert);
    Jump('SlotOneUpX');
    End();
SlotOneDown:
    Log("Triggers ShutterDude1 to shoot crouched.");
    JumpRandom('SlotOneDownTeleport1', 0.30, 'SlotOneDownTeleport2', 0.70, 'SlotOneDownTeleport3', 1.00, , , , ); 
SlotOneDownX:
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    SendUnrealEvent('CafeShutter1');
    Sleep(2);
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    SendUnrealEvent('CafeShutter1');
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
SlotOneDownTeleport1:
    Log("Teleport.");
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    Teleport(1, 'Shutter1Node1');
    UpdateGoal(1,'Shutter1Node1',FALSE,MOVE_CrouchWalk);
    Jump('SlotOneDownX');
    End();
SlotOneDownTeleport2:
    Log("Teleport.");
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    Teleport(1, 'Shutter2Node2');
    UpdateGoal(1,'Shutter1Node2',FALSE,MOVE_CrouchWalk);
    Jump('SlotOneDownX');
    End();
SlotOneDownTeleport3:
    Log("Teleport.");
    CheckIfIsDead(1,'Mortus');
    CheckIfIsUnconscious(1,'Mortus');
    Teleport(1, 'Shutter2Node3');
    UpdateGoal(1,'Shutter1Node3',FALSE,MOVE_CrouchWalk);
    Jump('SlotOneDownX');
    End();
SlotTwoUp:
    Log("Triggers ShutterDude2 to shoot standing.");
    JumpRandom('SlotTwoUpTeleport1', 0.30, 'SlotTwoUpTeleport2', 0.70, 'SlotTwoUpTeleport3', 1.00, , , , ); 
SlotTwoUpX:
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    SendUnrealEvent('CafeShutter2');
    Sleep(2);
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    SendUnrealEvent('CafeShutter2');
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
SlotTwoUpTeleport1:
    Log("Teleport.");
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    Teleport(2, 'Shutter2Node1');
    UpdateGoal(2,'Shutter2Node1',FALSE,MOVE_WalkAlert);
    Jump('SlotTwoUpX');
    End();
SlotTwoUpTeleport2:
    Log("Teleport.");
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    Teleport(2, 'Shutter2Node2');
    UpdateGoal(2,'Shutter2Node2',FALSE,MOVE_WalkAlert);
    Jump('SlotTwoUpX');
    End();
SlotTwoUpTeleport3:
    Log("Teleport.");
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    Teleport(2, 'Shutter2Node3');
    UpdateGoal(2,'Shutter2Node3',FALSE,MOVE_WalkAlert);
    Jump('SlotTwoUpX');
    End();
SlotTwoDown:
    Log("Triggers ShutterDude2 to shoot crouched.");
    JumpRandom('SlotTwoDownTeleport1', 0.30, 'SlotTwoDownTeleport2', 0.70, 'SlotTwoDownTeleport3', 1.00, , , , ); 
SlotTwoDownX:
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    SendUnrealEvent('CafeShutter2');
    Sleep(2);
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    SendUnrealEvent('CafeShutter2');
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
SlotTwoDownTeleport1:
    Log("Teleport.");
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    Teleport(2, 'Shutter2Node1');
    UpdateGoal(2,'Shutter2Node1',FALSE,MOVE_CrouchWalk);
    Jump('SlotTwoDownX');
    End();
SlotTwoDownTeleport2:
    Log("Teleport.");
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    Teleport(2, 'Shutter2Node2');
    UpdateGoal(2,'Shutter2Node2',FALSE,MOVE_CrouchWalk);
    Jump('SlotTwoDownX');
    End();
SlotTwoDownTeleport3:
    Log("Teleport.");
    CheckIfIsDead(2,'Mortus');
    CheckIfIsUnconscious(2,'Mortus');
    Teleport(2, 'Shutter2Node3');
    UpdateGoal(2,'Shutter2Node3',FALSE,MOVE_CrouchWalk);
    Jump('SlotTwoDownX');
    End();
SlotThreeUp:
    Log("Triggers ShutterDude3 to shoot standing.");
    JumpRandom('SlotThreeUpTeleport1', 0.30, 'SlotThreeUpTeleport2', 0.70, 'SlotThreeUpTeleport3', 1.00, , , , ); 
SlotThreeUpX:
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    SendUnrealEvent('CafeShutter3');
    Sleep(2);
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    SendUnrealEvent('CafeShutter3');
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
SlotThreeUpTeleport1:
    Log("Teleport.");
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    Teleport(3, 'Shutter3Node1');
    UpdateGoal(3,'Shutter3Node1',FALSE,MOVE_WalkAlert);
    Jump('SlotThreeUpX');
    End();
SlotThreeUpTeleport2:
    Log("Teleport.");
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    Teleport(3, 'Shutter3Node2');
    UpdateGoal(3,'Shutter3Node2',FALSE,MOVE_WalkAlert);
    Jump('SlotThreeUpX');
    End();
SlotThreeUpTeleport3:
    Log("Teleport.");
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    Teleport(3, 'Shutter3Node3');
    UpdateGoal(3,'Shutter3Node3',FALSE,MOVE_WalkAlert);
    Jump('SlotThreeUpX');
    End();
SlotThreeDown:
    Log("Triggers ShutterDude3 to shoot crouched.");
    JumpRandom('SlotThreeDownTeleport1', 0.30, 'SlotThreeDownTeleport2', 0.70, 'SlotThreeDownTeleport3', 1.00, , , , ); 
SlotThreeDownX:
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    SendUnrealEvent('CafeShutter3');
    Sleep(2);
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    SendUnrealEvent('CafeShutter3');
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
SlotThreeDownTeleport1:
    Log("Teleport.");
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    Teleport(3, 'Shutter3Node1');
    UpdateGoal(3,'Shutter3Node1',FALSE,MOVE_CrouchWalk);
    Jump('SlotThreeDownX');
    End();
SlotThreeDownTeleport2:
    Log("Teleport.");
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    Teleport(3, 'Shutter3Node2');
    UpdateGoal(3,'Shutter3Node2',FALSE,MOVE_CrouchWalk);
    Jump('SlotThreeDownX');
    End();
SlotThreeDownTeleport3:
    Log("Teleport.");
    CheckIfIsDead(3,'Mortus');
    CheckIfIsUnconscious(3,'Mortus');
    Teleport(3, 'Shutter3Node3');
    UpdateGoal(3,'Shutter3Node3',FALSE,MOVE_CrouchWalk);
    Jump('SlotThreeDownX');
    End();
Mortus:
    Log("This dude is dead.");
    CheckFlags(Shutter1Alive,TRUE,'ResurrectOne');
    CheckFlags(Shutter2Alive,TRUE,'ResurrectTwo');
    CheckFlags(Shutter3Alive,TRUE,'ResurrectThree');
    Sleep(1);
    Jump('Scoop');
    End();
ResurrectOne:
    Log("Resurrecting dude 1.");
    CheckIfIsDead(1,'Dead1');
    CheckIfIsUnconscious(1,'Dead1');
    Jump('ResurrectTwo');
Dead1:
    SetFlags(Shutter1Alive,FALSE);
    Log("Dude 1 dead.");
    Jump('ResurrectTwo');
    End();
ResurrectTwo:
    Log("Resurrecting dude 2.");
    CheckIfIsDead(2,'Dead2');
    CheckIfIsUnconscious(2,'Dead2');
    Jump('ResurrectThree');
Dead2:
    SetFlags(Shutter2Alive,FALSE);
    Log("Dude 2 dead.");
    Jump('ResurrectThree');
    End();
ResurrectThree:
    Log("Resurrecting dude 3.");
    CheckIfIsDead(3,'Dead3');
    CheckIfIsUnconscious(3,'Dead3');
    Jump('DeathCheck');
Dead3:
    SetFlags(Shutter3Alive,FALSE);
    Log("Dude 3 dead.");
    Jump('DeathCheck');
    End();
DeathCheck:
    Log("Tank, loop it, and check for corpses.");
    CheckFlags(Shutter1Alive,TRUE,'C2');
    CheckFlags(Shutter2Alive,FALSE,'AnnaleeCall');
    CheckFlags(Shutter3Alive,FALSE,'AnnaleeCall');
C2:
    Log("Not dude 1.");
    CheckFlags(Shutter2Alive,TRUE,'Loop');
    CheckFlags(Shutter3Alive,FALSE,'AnnaleeCall');
    Jump('Loop');
    End();
AnnaleeCall:
    Log("2 guys are dead. Calling reinforcements.");
    CheckFlags(Reinforce,TRUE,'Loop');
    SetFlags(Reinforce,TRUE);
    SendPatternEvent('RelayBackupAI','Backup');
Loop:
    JumpRandom('Randomize1', 0.50, 'Randomize2', 1.00, , , , , , ); 
    End();
Implode:
    Log("Sam has gotten close to the doors, kill the pattern.");
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
