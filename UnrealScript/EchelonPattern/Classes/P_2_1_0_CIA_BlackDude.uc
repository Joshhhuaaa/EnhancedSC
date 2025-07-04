//=============================================================================
// P_2_1_0_CIA_BlackDude
//=============================================================================
class P_2_1_0_CIA_BlackDude extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int bWasAlerted;


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
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
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
        if(P.name == 'ECIAAgent7')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    bWasAlerted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("Start the Black Dude. Send him to the main desktop.");
    CheckFlags(bWasAlerted,TRUE,'DoNothing');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BlackStopA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Wait,8,,,,'BlackStopA','LstnStNmCC0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
DoNothing:
    End();
Alerted:
    Log("Black Dude was alerted.");
    SetFlags(bWasAlerted,TRUE);
    End();

}

