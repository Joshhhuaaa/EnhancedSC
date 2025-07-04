//=============================================================================
// P_3_2_2_NPP_EphemeralChimp
//=============================================================================
class P_3_2_2_NPP_EphemeralChimp extends EPattern;

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
Timer:
    Log("Starts the 20 second timer.");
    Sleep(15);
    Log("5 seconds remaining...");
    Sleep(5);
    SendPatternEvent('RelayBackupAI','Release');
    End();

}

defaultproperties
{
}
