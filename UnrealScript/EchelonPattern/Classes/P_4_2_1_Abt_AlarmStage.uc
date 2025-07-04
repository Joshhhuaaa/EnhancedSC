//=============================================================================
// P_4_2_1_Abt_AlarmStage
//=============================================================================
class P_4_2_1_Abt_AlarmStage extends EPattern;

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
AlarmStageON:
    Log("AS ON");
    IgnoreAlarmStage(FALSE);
    End();
AlarmStageOFF:
    Log("AS OFF");
    IgnoreAlarmStage(TRUE);
    End();

}

