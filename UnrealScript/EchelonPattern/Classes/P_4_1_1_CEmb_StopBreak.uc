//=============================================================================
// P_4_1_1_CEmb_StopBreak
//=============================================================================
class P_4_1_1_CEmb_StopBreak extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('AiSeePlayer');
            break;
        case AI_DEAD:
            EventJump('AiSeePlayer');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('AiSeePlayer');
            break;
        case AI_REVIVED:
            EventJump('AiSeePlayer');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('AiSeePlayer');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('AiSeePlayer');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('AiSeePlayer');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AiSeePlayer');
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
        if (P.name == 'EChineseSoldier5')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier9')
            Characters[2] = P.controller;
        if (P.name == 'EChineseSoldier8')
            Characters[3] = P.controller;
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
Milestone:
    Log("Milestone");
    Goal_Default(1,GOAL_Patrol,9,,,,'ECSExtra1_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,9,,,,'ECS411010_500',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Patrol,9,,,,'ECS411009_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Wait,9,,,,,,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Wait,9,,,,,,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Wait,9,,,,,,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S4_1_1Voice.Play_41_14_01', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_14_02', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_14_03', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_14_04', 2, , TRUE, 0);
    Close();
    ResetGroupGoals();
    SetExclusivity(FALSE);
    End();
AiSeePlayer:
    Log("AiSeePlayer");
    ResetGroupGoals();
    Goal_Default(1,GOAL_Patrol,9,,,,'ECSExtra1_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,9,,,,'ECS411010_500',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Patrol,9,,,,'ECS411009_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    SetExclusivity(FALSE);
    End();

}

