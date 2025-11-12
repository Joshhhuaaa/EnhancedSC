//=============================================================================
// P_1_1_2_Tbilisi_UpstairsCops
//=============================================================================
class P_1_1_2_Tbilisi_UpstairsCops extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('UpAlarmSound');
            break;
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
    Log("This pattern governs the use state of the Surveillance room computers.");
ComputerActivity:
    Log("Checking to see if the computer should have info on it or not");
    CheckFlags(V1_1_2Tbilisi(Level.VarObject).BodyFound,FALSE,'DoNothing');
    CheckFlags(V1_1_2Tbilisi(Level.VarObject).GotTape,TRUE,'DoNothing');
    SetFlags(V1_1_2Tbilisi(Level.VarObject).GotTape,TRUE);
    SendPatternEvent('LambertAI','InSecurityRoom');
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

