//=============================================================================
// P_4_3_0_FeirongWatching
//=============================================================================
class P_4_3_0_FeirongWatching extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('FeirongDied');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('FeirongRunning');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('FeirongRunning');
            break;
        case AI_UNCONSCIOUS:
            EventJump('FeirongDied');
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
        if(P.name == 'EFeirong0')
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
FeirongRunning:
    Log("FeirongRunning");
    DisableMessages(TRUE, FALSE);
    Goal_Set(1,GOAL_Action,9,,,,,'ReacStAlFd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_MoveTo,9,,,,'FeirongAlarmPoint',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_InteractWith,8,,,,'FeirongPanel',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'FeirongLeavingNode01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Wait,6,,,,'FeirongLeavingNode01',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    End();
FeirongDied:
    Log("If Feirong dies or is knocked");
    DisableMessages(FALSE, TRUE);
    SendPatternEvent('LambertComms','GenericFail');
    End();

}

