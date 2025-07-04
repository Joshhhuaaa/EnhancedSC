//=============================================================================
// P_1_2_1DefMin_LaserSecurity
//=============================================================================
class P_1_2_1DefMin_LaserSecurity extends EPattern;

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
    Log("MilestoneTHEALARM");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).LaserDown,TRUE,'End');
    StartAlarm('Newalarm',1);
End:
    End();

}

