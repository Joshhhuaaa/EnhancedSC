//=============================================================================
// P_3_2_1_NPP_Reinforcements1
//=============================================================================
class P_3_2_1_NPP_Reinforcements1 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int OneSent;
var int TwoSent;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('OneDown');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Exclu');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Exclu');
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
        if(P.name == 'EFalseRussianSoldier9')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    OneSent=0;
    TwoSent=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Send:
    Log("The outside alarm has been activated, reinforcement 1 possibly incoming.");
    CheckFlags(OneSent,TRUE,'SendTwo');
    SetFlags(OneSent,TRUE);
    SetExclusivity(FALSE);
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'RunLikeHell',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,6,,,,'Olly_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
SendTwo:
    Log("The SECOND outside alarm has been activated, reinforcements incoming.");
    CheckFlags(TwoSent,TRUE,'Nada');
    SetFlags(TwoSent,TRUE);
    SendPatternEvent('Reinforcements2','Send');
    End();
Nada:
    End();
Exclu:
    Log("Resets exclusivity of Reinforcement 1 guard.");
    SetExclusivity(FALSE);
    End();
OneDown:
    Log("Link to max filter.");
    SendPatternEvent('GasTankAI','OneDown');
    End();

}

defaultproperties
{
}
