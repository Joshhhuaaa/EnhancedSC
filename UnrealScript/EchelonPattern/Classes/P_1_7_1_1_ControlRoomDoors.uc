//=============================================================================
// P_1_7_1_1_ControlRoomDoors
//=============================================================================
class P_1_7_1_1_ControlRoomDoors extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int PatternPlayed;


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
    PatternPlayed=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneControlRoomDoors:
    Log("MilestoneControlRoomDoors");
    StartAlarm('DecompAlarm',1);
    CheckFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).DisableDoor,TRUE,'End');
    CheckFlags(PatternPlayed,TRUE,'End');
    SetFlags(PatternPlayed,TRUE);
    SendUnrealEvent('ControlRoomDoors');
    SetFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).ContDoorsOpen,FALSE);
End:
    End();

}

defaultproperties
{
}
