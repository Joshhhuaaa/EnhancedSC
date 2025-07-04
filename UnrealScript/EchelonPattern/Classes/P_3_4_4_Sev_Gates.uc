//=============================================================================
// P_3_4_4_Sev_Gates
//=============================================================================
class P_3_4_4_Sev_Gates extends EPattern;

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
    Log("This pattern controls the two locked gates in the level.");
OpenFirstSet:
    Log("The first set of gates are being opened permanently.");
    SendUnrealEvent('Gate01');
    End();

}

defaultproperties
{
}
