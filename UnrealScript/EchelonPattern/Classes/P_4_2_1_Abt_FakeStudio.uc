//=============================================================================
// P_4_2_1_Abt_FakeStudio
//=============================================================================
class P_4_2_1_Abt_FakeStudio extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('MoveOut');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('GoDefaut');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('GoDefaut');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('GoDefaut');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('GoDefaut');
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
        if(P.name == 'spetsnaz9')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'spetsnaz9')
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
Position1:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint40',,'PathNode59',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,8,,,,'EFocusPoint40',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,'EFocusPoint39',,'PathNode70',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Wait,8,,,,'EFocusPoint39','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Position2:
    Log("");
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode84',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PathNode54',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,7,,'StaticMeshActor1173',,'PathNode63',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Wait,6,,'StaticMeshActor1173','PathNode63',,,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode68',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,'EFocusPoint42',,'PathNode67',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,7,,'EFocusPoint42','PathNode67',,,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
BeamOut:
    Log("BeamOut");
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    ResetGoals(1);
    ResetGoals(2);
    Teleport(1, 'PathNode214');
    Teleport(2, 'PathNode215');
    KillNPC(1, FALSE, FALSE);
    KillNPC(2, FALSE, FALSE);
    End();
GrinkoBackTalk:
    Log("");
    SendPatternEvent('EGroupAI18','GrinkoTalk');
    End();
GoDefaut:
    Log("GoDefaut");
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.Stop_42_35_01', SLOT_Barks);
    SetExclusivity(FALSE);
    End();
JumpFin:
    Log("");
    End();
MoveOut:
    Log("MoveOut");
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    SendPatternEvent('EGroupAI18','AlarmINstudio');
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode296',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Wait,8,,,,'PathNode296',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,'BeamOut');
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode297',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Wait,8,,,,'PathNode297',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveTo,'BeamOut');
    Jump('BeamOut');

}

