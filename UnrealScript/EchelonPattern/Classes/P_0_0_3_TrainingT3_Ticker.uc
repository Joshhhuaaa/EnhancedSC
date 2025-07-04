//=============================================================================
// P_0_0_3_TrainingT3_Ticker
//=============================================================================
class P_0_0_3_TrainingT3_Ticker extends EPattern;

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

    SetPatternAlwaysTick();
}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start05A:
    Log("Start05A");
    SendPatternEvent('GroupCamera05A','GiveInv');
    Sleep(5);
    Jump('Start05A');
End05A:
    End();
Start05B:
    Log("Start05B");
    SendPatternEvent('GroupCamera05B','GiveInv');
    Sleep(5);
    Jump('Start05B');
End05B:
    End();

}

