//=============================================================================
// P_3_1_1_Ship_ActivateGate
//=============================================================================
class P_3_1_1_Ship_ActivateGate extends EPattern;

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
OpenGate:
    Log("A hit to the swtchbox opens the main gate");
    SendUnrealEvent('gateswitch');
    End();

}

defaultproperties
{
}
