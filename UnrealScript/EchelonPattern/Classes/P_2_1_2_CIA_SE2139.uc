//=============================================================================
// P_2_1_2_CIA_SE2139
//=============================================================================
class P_2_1_2_CIA_SE2139 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int bdone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('ProjAlert');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('ProjAlert');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('ProjAlert');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('ProjAlert');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('ProjAlert');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('ProjAlert');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('ProjAlert');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('ProjAlert');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('ProjAlert');
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
        if (P.name == 'ECIABureaucrat42')
            Characters[1] = P.controller;
        if (P.name == 'ECIABureaucrat43')
            Characters[2] = P.controller;
        if (P.name == 'ECIABureaucrat44')
            Characters[3] = P.controller;
        if (P.name == 'ECIAAgent0')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    bdone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start_SE2139:
    Log("Auditorium conversation starts");
    CheckFlags(bdone,TRUE,'end');
    SetFlags(bdone,TRUE);
    Goal_Set(1,GOAL_Action,9,,,,,'SignStNmRt0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,8,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_39_01', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_39_02', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Action,7,,,,,'SignStNmRt0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,6,,,,,'TalkStNmAA0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,5,,,,,'SignStNmRt0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,4,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_39_03', 1, , TRUE, 0);
    ResetGoals(4);
    Goal_Set(4,GOAL_MoveTo,9,,,,'ProgGg',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(4,GOAL_Guard,8,,'EFocusPoint17','EFocusPoint17','ProgGg',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'CellStNmBg0',FALSE,,,,);
    Goal_Default(1,GOAL_Wait,8,,,,,'CellStNmBB0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_39_04', 1, , TRUE, 0);
    ResetGoals(3);
    Goal_Set(3,GOAL_Action,9,,,,,'PrsoAsNmFdA',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_39_05', 1, , TRUE, 0);
    Close();
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'CellStNmCC0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,8,,,,,'CellStNmAA0',FALSE,,,,);
    Goal_Default(1,GOAL_Wait,7,,,,,'CellStNmBB0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_39_06', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_39_07', 1, , TRUE, 0);
    Close();
    ResetGoals(3);
    Goal_Set(3,GOAL_Action,9,,,,,'WaitAsNmBgB',FALSE,-1,,,);
    Goal_Set(3,GOAL_Action,8,,,,,'SittAsAlUp0',FALSE,,,,);
    Goal_Set(3,GOAL_MoveTo,7,,,,'PathNode6',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,6,,,,'PathNode33',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,5,,,,'PathNode5',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,4,,'EFocusPoint16',,'PathNode117',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Wait,4,,'EFocusPoint16',,'PathNode117','LeanStNmAA0',FALSE,,,,);
    Sleep(1);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'SittAsNmUp0',FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PathNode31',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,7,,,,'PathNode34',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,6,,'EFocusPoint15',,'PathNode118',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Wait,5,,'EFocusPoint15',,'PathNode118','LstnStNmAA0',FALSE,,,,);
    End();
ProjAlert:
    Log("ProjAlert");
    Close();
    DisableMessages(TRUE, TRUE);
end:
    End();

}

