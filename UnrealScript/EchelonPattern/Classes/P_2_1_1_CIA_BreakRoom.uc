//=============================================================================
// P_2_1_1_CIA_BreakRoom
//=============================================================================
class P_2_1_1_CIA_BreakRoom extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('DropAllBreaked');
            break;
        case AI_GRABBED:
            EventJump('DropAllBreaked');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('DropAllBreaked');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('DropAllBreaked');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('DropAllBreaked');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('DropAllBreaked');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('DropAllBreaked');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('DropAllBreaked');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('DropAllBreaked');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('DropAllBreaked');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DropAllBreaked');
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
        if(P.name == 'ECIAAgent5')
            Characters[1] = P.controller;
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
BreakRoomStart:
    Log("Three employees discuss the recent terror attack");
    Sleep(1);
    Goal_Set(1,GOAL_Wait,9,,,,,'CellStNmAA0',FALSE,,,,);
    Goal_Default(1,GOAL_Patrol,1,,,,'PathNodeNoNumber',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_1_1Voice.Play_21_12_01', 1, , TRUE, 0);
    Close();
    Sleep(4);
    Talk(Sound'S2_1_1Voice.Play_21_12_03', 1, , TRUE, 0);
    Close();
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNodeNoNumber',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'PathNodeNoNumber',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
DropAllBreaked:
    Log("DropAllBreaked");
    Close();
    DisableMessages(TRUE, TRUE);
    End();

}

