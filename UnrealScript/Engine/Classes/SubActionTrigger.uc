//=============================================================================
// SubActionTrigger:
//
// Fires off a trigger.
//=============================================================================
class SubActionTrigger extends MatSubAction
	native;

var(Trigger)	name	EventName;		// The event to trigger

defaultproperties
{
    Icon=Texture'SubActionTrigger'
    Desc="Trigger"
}