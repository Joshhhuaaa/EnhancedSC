//=============================================================================
// P_1_7_1_1_Walking
//=============================================================================
class P_1_7_1_1_Walking extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\water.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('KillSoundWalking');
            break;
        case AI_GRABBED:
            EventJump('KillSoundWalking');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('KillSoundWalking');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('KillSoundWalking');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('KillSoundWalking');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('KillSoundWalking');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('KillSoundWalking');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('KillSoundWalking');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('KillSoundWalking');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('KillSoundWalking');
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
        if (P.name == 'spetsnaz9')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'spetsnaz9')
            SoundActors[0] = A;
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
MilestoneWalking:
    Log("MilestoneWalking");
    Goal_Set(1,GOAL_MoveTo,9,,,,'toiletnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'urinoir','urinoir','toiletnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,1,,,,'TurretNodeA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(2.5);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmBg0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
	SoundActors[0].PlaySound(Sound'water.Play_NpcPee', SLOT_SFX);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    ResetGoals(1);
    End();
KillSoundWalking:
    Log("KillSoundWalking");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    End();
TelWalking:
    Log("TelWalking");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelNodeC');
    KillNPC(1, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
