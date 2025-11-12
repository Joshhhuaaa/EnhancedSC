//=============================================================================
// P_4_1_2_CEmb_GateTalk
//=============================================================================
class P_4_1_2_CEmb_GateTalk extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int closing;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('SamDetected');
            break;
        case AI_GRABBED:
            EventJump('SamDetected');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('SamDetected');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('SamDetected');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SamDetected');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('SamDetected');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('SamDetected');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SamDetected');
            break;
        case AI_UNCONSCIOUS:
            EventJump('SamDetected');
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
        if (P.name == 'EChineseSoldier22')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier4')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    closing=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    Talk(Sound'S4_1_2Voice.Play_41_18_01', 1, , TRUE, 0);
    Talk(Sound'S4_1_2Voice.Play_41_18_02', 1, , TRUE, 0);
    Talk(Sound'S4_1_2Voice.Play_41_18_03', 1, , TRUE, 0);
    Talk(Sound'S4_1_2Voice.Play_41_18_04', 1, , TRUE, 0);
    Talk(Sound'S4_1_2Voice.Play_41_18_05', 1, , TRUE, 0);
    Close();
    Goal_Set(1,GOAL_MoveTo,9,,,,'GateGuard',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'ECS13B',,'GateGuard',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(10);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'GateGuard2',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,9,,'ECS13',,'GateGuard2',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(2);
    Talk(Sound'S4_1_2Voice.Play_41_18_06', 1, , TRUE, 0);
    Close();
    SendPatternEvent('BogusTruckPass','ClosingGate');
    End();
SamDetected:
    Log("SamDetected");
    SendPatternEvent('BogusTruckPass','ClosingGate');
    SetExclusivity(FALSE);
    End();

}

