//=============================================================================
// P_4_1_2_CEmb_LimoSetFlags
//=============================================================================
class P_4_1_2_CEmb_LimoSetFlags extends EPattern;

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
GuardInBoothON:
    Log("GuardInBoothON");
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).GateGuardInPosition,TRUE);
    End();
GuardInBoothOFF:
    Log("GuardInBoothOFF");
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).GateGuardInPosition,FALSE);
    End();

}

