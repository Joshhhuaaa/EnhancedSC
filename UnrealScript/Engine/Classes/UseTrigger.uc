//=============================================================================
// UseTrigger: if a player stands within proximity of this trigger, and hits Use, 
// it will send Trigger/UnTrigger to actors whose names match 'EventName'.
//=============================================================================
class UseTrigger extends Triggers;

var() localized string Message;

function UsedBy(Pawn user)
{
	TriggerEvent(Event, user, user);
}

function Touch(Actor Other)
{
}
