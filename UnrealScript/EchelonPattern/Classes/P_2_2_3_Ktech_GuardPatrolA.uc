//=============================================================================
// P_2_2_3_Ktech_GuardPatrolA
//=============================================================================
class P_2_2_3_Ktech_GuardPatrolA extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AISeePlayer');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('AISeePlayer');
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
        if(P.name == 'EMafiaMuscle3')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle4')
            Characters[2] = P.controller;
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
GuardPatrolA:
    Log("GuardPatrolA");
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'GuardPatrolANode03',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'GuardPatrolANode04',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(5);
    Talk(Sound'S2_2_3Voice.Play_22_58_01', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_58_02', 2, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_58_03', 1, , TRUE, 0);
    Close();
    WaitForGoal(1,GOAL_MoveTo,);
    WaitForGoal(2,GOAL_MoveTo,);
    ChangeGroupState('s_investigate');
    Goal_Set(1,GOAL_MoveTo,9,,,,'GuardPatrolANode08',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'GuardPatrolANode07',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Guard,8,,,,'GuardPatrolANode08',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Guard,8,,,,'GuardPatrolANode07',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    WaitForGoal(2,GOAL_MoveTo,);
    ChangeGroupState('s_default');
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'GuardPatrolANode09',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'GuardPatrolANode10',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'GuardPatrolAFocus01',,'GuardPatrolANode09',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Guard,8,,'GuardPatrolAFocus02',,'GuardPatrolANode10',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
AISeePlayer:
    Log("AISeePlayer");
    Close();
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER','GuardPatrolANode05',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,9,,'PLAYER','PLAYER','GuardPatrolANode06',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SetExclusivity(FALSE);
    End();

}

