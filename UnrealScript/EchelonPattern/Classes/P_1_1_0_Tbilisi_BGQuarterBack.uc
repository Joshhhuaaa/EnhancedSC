//=============================================================================
// P_1_1_0_Tbilisi_BGQuarterBack
//=============================================================================
class P_1_1_0_Tbilisi_BGQuarterBack extends EPattern;

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
    Log("This pattern is a governor whose only purpose is to send pattern events to other patterns to move and control the background civilians.");
StartZone:
    Log("This label sends to the civilian AIs near the start point.");
    SendPatternEvent('BGOsip','AOsip');
    Sleep(2);
    SendPatternEvent('BGLazar','ALazar');
    Sleep(2);
    SendPatternEvent('BGAnton','AAnton');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

