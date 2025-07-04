//=============================================================================
// P_2_1_1_CIA_Doorfix
//=============================================================================
class P_2_1_1_CIA_Doorfix extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Alerted;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('RemoveConv');
            break;
        case AI_DEAD:
            EventJump('RemoveConv');
            break;
        case AI_GRABBED:
            EventJump('RemoveConv');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('RemoveConv');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('RemoveConv');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('RemoveConv');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('RemoveConv');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('RemoveConv');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('RemoveConv');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('RemoveConv');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('RemoveConv');
            break;
        case AI_UNCONSCIOUS:
            EventJump('RemoveConv');
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
        if(P.name == 'ECIAMaintenance0')
            Characters[1] = P.controller;
        if(P.name == 'ECIASecurity2')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Alerted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
DoorFixStart:
    Log("waiting to start");
    Sleep(2);
    Goal_Set(1,GOAL_MoveTo,9,,,,'StayThereConvTechA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'EFocusPointSecDoorFix','EFocusPointSecDoorFix','StayThereConvTechA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,1,,,,'Doorfixnode',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Talk(Sound'S2_1_1Voice.Play_21_08_01', 2, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_02', 1, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_03', 2, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_04', 1, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_05', 2, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_06', 1, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_07', 2, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_08', 1, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_09', 2, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_10', 1, , TRUE, 0);
    Talk(Sound'S2_1_1Voice.Play_21_08_11', 2, , TRUE, 0);
    Close();
    ResetGoals(1);
    SendUnrealEvent('DammCommy');
    End();
RemoveConv:
    Log("RemoveConv");
    Close();
    DisableMessages(TRUE, TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Search,9,,,,'StayThereConvTechA',,FALSE,,MOVE_Search,,MOVE_Search);
    End();

}

