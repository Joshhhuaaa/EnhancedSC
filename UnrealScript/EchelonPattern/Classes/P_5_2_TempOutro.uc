//=============================================================================
// P_5_2_TempOutro
//=============================================================================
class P_5_2_TempOutro extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    PlayerMove(false);
    SendUnrealEvent('OSPlast');
    SendPatternEvent('SniperExtractionTEam','AllStopShooting');
    GameOver(true, 0);
    End();

}

