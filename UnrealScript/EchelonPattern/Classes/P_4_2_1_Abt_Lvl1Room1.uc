//=============================================================================
// P_4_2_1_Abt_Lvl1Room1
//=============================================================================
class P_4_2_1_Abt_Lvl1Room1 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\water.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Dead');
            break;
        case AI_GRABBED:
            EventJump('Dead');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('JumpFin');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SamDiscover');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('SamDiscover');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('SamDiscover');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SamDiscover');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Dead');
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
        if(P.name == 'EGeorgianSoldier8')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz11')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EGeorgianSoldier8')
            SoundActors[0] = A;
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
Step1:
    Log("Sam move through the room, a guard is derange.");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode104',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Default(1,GOAL_Wait,8,,'EFocusPoint45',,,'KbrdStNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
StartPissSound:
    Log("");
	SoundActors[0].PlaySound(Sound'water.Play_NpcPee', SLOT_SFX);
    End();
SamDiscover:
    Log("Sam is discover.  two more guard are teleport in the coridor");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).Room1Pass1,TRUE,'JumpFin');
    SetExclusivity(FALSE);
    SendPatternEvent('EGroupAI4','Start');
    End();
Dead:
    Log("");
    CheckIfGrabbed(1,'StopPiss');
    CheckIfIsDead(1,'StopPiss');
    CheckIfIsUnconscious(1,'StopPiss');
Blam2:
    Log("");
    CheckIfIsDead(2,'CallPatrol');
    CheckIfIsUnconscious(2,'CallPatrol');
    End();
StopPiss:
    Log("");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    Jump('Blam2');
JumpFin:
    Log("");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    SetExclusivity(FALSE);
    End();
CallPatrol:
    Log("");
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).Room1Pass1,TRUE,'JumpFin');
    SendPatternEvent('EGroupAI4','patrol');
    SetExclusivity(FALSE);
    End();
What:
    Log("");
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).Room1Pass1,TRUE,'JumpFin');
    SetExclusivity(TRUE);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,'EExtincteur0',,'PathNode209',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_MoveTo,);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EExtincteur0',,,'LookStNmDn0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Action,8,,'EExtincteur0',,,'LookStNmLt0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,7,,'EExtincteur0',,,'LookStNmRt0',FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,6,,'ESwingingDoor21',,'PathNode472',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,5,,'ESwingingDoor21',,'PathNode472',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_MoveTo,);
    Sleep(6);
    ResetGoals(2);
    Goal_Default(2,GOAL_MoveTo,9,,'EFocusPoint45',,'PathNode95',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'EFocusPoint45',,'PathNode95',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    SetExclusivity(FALSE);
    WaitForGoal(2,GOAL_MoveTo,);
    Sleep(4);
    Goal_Set(2,GOAL_MoveTo,8,,'PathNode90',,'PathNode100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,7,,'PathNode90',,'PathNode100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

