//=============================================================================
// P_4_1_2_CEmb_FeirongGuards
//=============================================================================
class P_4_1_2_CEmb_FeirongGuards extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('FeirongGuards');
            break;
        case AI_GRABBED:
            EventJump('FeirongGuards');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('FeirongGuards');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('FeirongGuards');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('FeirongGuards');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('FeirongGuards');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('FeirongGuards');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('FeirongGuards');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('FeirongGuards');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('FeirongGuards');
            break;
        case AI_UNCONSCIOUS:
            EventJump('FeirongGuards');
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
        if(P.name == 'EChineseSoldier25')
            Characters[1] = P.controller;
        if(P.name == 'EChineseSoldier26')
            Characters[2] = P.controller;
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
FeirongGuards:
    Log("FeirongGuards");
    CheckFlags(V4_1_2ChineseEmbassy(Level.VarObject).LastMikDone,TRUE,'LaserMicDone');
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    SendPatternEvent('LambertBogus','LaserMicFailureB');
LaserMicDone:
    End();

}

