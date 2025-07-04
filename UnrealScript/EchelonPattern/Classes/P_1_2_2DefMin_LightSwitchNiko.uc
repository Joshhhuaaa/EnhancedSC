//=============================================================================
// P_1_2_2DefMin_LightSwitchNiko
//=============================================================================
class P_1_2_2DefMin_LightSwitchNiko extends EPattern;

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
Milestone:
    Log("Milestone");
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).NikoLight,TRUE,'WasOn');
WasOff:
    Log("WasOff");
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).NikoLight,TRUE);
    End();
WasOn:
    Log("WasOn");
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).NikoLight,FALSE);
    End();

}

