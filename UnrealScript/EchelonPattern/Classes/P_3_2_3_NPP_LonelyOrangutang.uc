//=============================================================================
// P_3_2_3_NPP_LonelyOrangutang
//=============================================================================
class P_3_2_3_NPP_LonelyOrangutang extends EPattern;

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
TheEnd:
    Log("Mission Completed.");
    GameOver(true, 0);
    End();

}

defaultproperties
{
}
