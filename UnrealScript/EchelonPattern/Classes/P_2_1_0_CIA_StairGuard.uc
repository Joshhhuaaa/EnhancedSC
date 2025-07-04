//=============================================================================
// P_2_1_0_CIA_StairGuard
//=============================================================================
class P_2_1_0_CIA_StairGuard extends EPattern;

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
        if(P.name == 'ECIASecurity9')
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
    Log("");
    CheckFlags(bWasAlerted,TRUE,'DoNothing');
    Goal_Default(1,GOAL_Patrol,9,,,,'Yorda_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
DoNothing:
    End();
Alerted:
    Log("Basement Security guard was alerted.");
    SetFlags(bWasAlerted,TRUE);
    End();

}

