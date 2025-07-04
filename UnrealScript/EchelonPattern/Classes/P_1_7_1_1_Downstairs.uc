//=============================================================================
// P_1_7_1_1_Downstairs
//=============================================================================
class P_1_7_1_1_Downstairs extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\water.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('KillSoundDownstairs');
            break;
        case AI_GRABBED:
            EventJump('KillSoundDownstairs');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('KillSoundDownstairs');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('KillSoundDownstairs');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('KillSoundDownstairs');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('KillSoundDownstairs');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('KillSoundDownstairs');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('KillSoundDownstairs');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('KillSoundDownstairs');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('KillSoundDownstairs');
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
        if(P.name == 'spetsnaz6')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz7')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'spetsnaz6')
            SoundActors[0] = A;
        if(A.name == 'spetsnaz7')
            SoundActors[1] = A;
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
MilestoneDownstairs:
    Log("MilestoneDownstairs");
    ToggleGroupAI(TRUE, 'Downstairs', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Goal_Set(1,GOAL_MoveTo,9,,,,'otherurinoirnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(2.5);
    Goal_Set(2,GOAL_MoveTo,9,,,,'toiletnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'urinoirB','urinoirB','otherurinoirnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Guard,8,,'urinoir','urinoir','toiletnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,1,,'posterfocusA','posterfocusA','RoomAP',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Patrol,1,,,,'PostPissPathA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Talk(Sound'S3_1_1Voice.Play_31_37_01', 1, , FALSE, 0);
    Sleep(2.5);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmBg0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S3_1_1Voice.Play_31_37_02', 2, , FALSE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
	SoundActors[0].PlaySound(Sound'water.Play_NpcPee', SLOT_SFX);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S3_1_1Voice.Play_31_37_03', 1, , FALSE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,9,,,,,'PissStNmBg0',FALSE,,,,);
    WaitForGoal(2,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
	SoundActors[1].PlaySound(Sound'water.Play_NpcPee', SLOT_SFX);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(2,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,9,,,,,'PissStNmEd0',FALSE,,,,);
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    WaitForGoal(2,GOAL_Action,);
    Goal_Set(2,GOAL_Action,9,,,,,'PissStNmNt0',FALSE,,,,);
    ResetGoals(1);
    WaitForGoal(2,GOAL_Action,);
    Goal_Set(2,GOAL_Action,9,,,,,'PissStNmEd0',FALSE,,,,);
	SoundActors[1].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    WaitForGoal(2,GOAL_Action,);
    ResetGoals(2);
    Talk(Sound'S3_1_1Voice.Play_31_37_06', 2, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_37_07', 1, , TRUE, 0);
    End();
KillSoundDownstairs:
    Log("KillSoundDownstairs");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
	SoundActors[1].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    End();
TelDownstairs:
    Log("TelDownstairs");
    CheckIfIsUnconscious(1,'TelDownstairsB');
    Teleport(1, 'TelNodeE');
    KillNPC(1, FALSE, FALSE);
TelDownstairsB:
    Log("TelDownstairsB");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'TelNodeF');
    KillNPC(2, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
