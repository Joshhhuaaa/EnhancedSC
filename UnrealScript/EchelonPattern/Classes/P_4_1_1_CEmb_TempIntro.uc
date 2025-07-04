//=============================================================================
// P_4_1_1_CEmb_TempIntro
//=============================================================================
class P_4_1_1_CEmb_TempIntro extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_TAKE_DAMAGE:
            EventJump('DeadRinger');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DeadRinger');
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
        if(P.name == 'EFrances0')
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
DeadRinger:
    Log("DeadRinger");
    SendPatternEvent('GameOverBogus','MissionFailed');
    End();
Teleport:
    Log("Teleport France.");
    Teleport(1, 'TeleportFrance');
    End();

}

