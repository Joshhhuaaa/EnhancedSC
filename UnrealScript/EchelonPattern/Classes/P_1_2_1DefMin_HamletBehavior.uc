//=============================================================================
// P_1_2_1DefMin_HamletBehavior
//=============================================================================
class P_1_2_1DefMin_HamletBehavior extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\water.uax
#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Alerted');
            break;
        case AI_DEAD:
            EventJump('Death');
            break;
        case AI_GRABBED:
            EventJump('Alerted');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Alerted');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Alerted');
            break;
        case AI_RELEASED:
            EventJump('FreeNow');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('Alerted');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Death');
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
        if(P.name == 'EHamlet0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
        if(P.name == 'ELambert0')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EHamlet0')
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
Milestone:
    Log("Milestone");
    Goal_Set(1,GOAL_MoveTo,9,,,,'Pissnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Action,8,,'PissFocuss','PissFocuss',,'PissStNmBg0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
	SoundActors[0].PlaySound(Sound'water.Play_NpcPee', SLOT_SFX);
    Goal_Set(1,GOAL_Action,7,,'PissFocuss','PissFocuss',,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,6,,'PissFocuss','PissFocuss',,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,5,,'PissFocuss','PissFocuss',,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,4,,'PissFocuss','PissFocuss',,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,3,,'PissFocuss','PissFocuss',,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,2,,'PissFocuss','PissFocuss',,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,1,,'PissFocuss','PissFocuss',,'PissStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    Goal_Set(1,GOAL_Action,0,,'PissFocuss','PissFocuss',,'PissStNmEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,7,,,,'CarNodee',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Guard,6,,'CarNodeF','CarNodeF','CarNodee',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,8,,,,,'CiggStNmBg0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Default(1,GOAL_Wait,9,,,,,'CiggStNmPf0',FALSE,,,,);
    End();
Death:
    Log("Death");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).InterroDone,FALSE,'KillBeforeInt');
    CheckIfIsUnconscious(1,'End');
    Sleep(3);
    Speech(Localize("P_1_2_1DefMin_HamletBehavior", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_16_01', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_1DefMin_HamletBehavior", "Speech_0002L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_16_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_1DefMin_HamletBehavior", "Speech_0003L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_16_03', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
KillBeforeInt:
    Log("KillBeforeInt");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    SetExclusivity(TRUE);
    Speech(Localize("P_1_2_1DefMin_HamletBehavior", "Speech_0004L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_1_Voice.Play_11_95_01', 2, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 6);
    End();
FreeNow:
    Log("FreeNow");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).InterroDone,FALSE,'End');
    SendPatternEvent('LambertLaser','Milestone');
    End();
Alerted:
    Log("Alerted");
	SoundActors[0].PlaySound(Sound'water.Stop_NpcPee', SLOT_SFX);
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).HamletAlerted,TRUE);
End:
    End();

}

