//=============================================================================
// P_3_1_2_Ship_Subdoors
//=============================================================================
class P_3_1_2_Ship_Subdoors extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SwitchSubDoors:
    Log("Switches door positions");
    SendUnrealEvent('subdoors');
    End();

}

defaultproperties
{
}
