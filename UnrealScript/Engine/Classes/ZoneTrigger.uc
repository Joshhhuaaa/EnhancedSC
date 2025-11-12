//=============================================================================
// ZoneTrigger.
//=============================================================================
class ZoneTrigger extends Trigger;

//
// Called when something touches the trigger.
//
function Touch(actor Other)
{
	local ZoneInfo Z;
	if (IsRelevant(Other))
	{
		// Broadcast the Trigger message to all matching actors.
		if (Event != '')
			foreach AllActors(class 'ZoneInfo', Z)
				if (Z.ZoneTag == Event)
					Z.Trigger(Other, Other.Instigator);

		if (bTriggerOnceOnly)
			// Ignore future touches.
			SetCollision(False);
	}
}

//
// When something untouches the trigger.
//
function UnTouch(actor Other)
{
	local ZoneInfo Z;
	if (IsRelevant(Other))
	{
		// Untrigger all matching actors.
		if (Event != '')
			foreach AllActors(class 'ZoneInfo', Z)
				if (Z.ZoneTag == Event)
					Z.UnTrigger(Other, Other.Instigator);
	}
}

