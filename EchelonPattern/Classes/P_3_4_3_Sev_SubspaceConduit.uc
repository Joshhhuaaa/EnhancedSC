//=============================================================================
// P_3_4_3_Sev_SubspaceConduit
//=============================================================================
class P_3_4_3_Sev_SubspaceConduit extends EPattern;

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
    Log("This is the travelling without moving data, folding space if you will.");

}

defaultproperties
{
}
