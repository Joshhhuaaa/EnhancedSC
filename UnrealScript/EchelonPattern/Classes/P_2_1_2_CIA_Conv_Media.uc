//=============================================================================
// P_2_1_2_CIA_Conv_Media
//=============================================================================
class P_2_1_2_CIA_Conv_Media extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('DropIT');
            break;
        case AI_DEAD:
            EventJump('DropIT');
            break;
        case AI_GRABBED:
            EventJump('DropIT');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('DropIT');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('DropIT');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('DropIT');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('DropIT');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('DropIT');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('DropIT');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('DropIT');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('DropIT');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DropIT');
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
        if (P.name == 'ECIAAgent10')
            Characters[1] = P.controller;
        if (P.name == 'ECIAAgent11')
            Characters[2] = P.controller;
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
start_media:
    Log("Start media room scripted event");
    Talk(Sound'S2_1_2Voice.Play_21_10_01', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_02', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_03', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_10_04', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_05', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_10_06', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_07', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_15', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_10_08', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_16', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_09', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_17', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_10', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_18', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_11', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_19', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_12', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_10_13', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_10_14', 1, , TRUE, 0);
    Close();
    Goal_Set(2,GOAL_MoveTo,9,,,,'GuardInShadowShowoffA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PathNode155',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,7,,,,'officewait',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Wait,6,,'ECompSonyLcd11',,'Echair1','ReadAsNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_Sit);
    End();
DropIT:
    Log("DropIT");
    Close();
    End();

}

