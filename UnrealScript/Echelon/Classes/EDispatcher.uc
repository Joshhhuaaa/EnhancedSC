//=============================================================================
// EDispatcher: receives one trigger (corresponding to its name) as input,
// then triggers a set of specifid events with optional delays.
//=============================================================================
class EDispatcher extends Triggers;

#exec Texture Import File=..\Engine\Textures\Echelon\Dispatch.pcx Name=S_Dispatcher Mips=Off Flags=2 NOCONSOLE

//-----------------------------------------------------------------------------
// EDispatcher variables.

var() name  OutEvents[8]; // Events to generate.
var() float OutDelays[8]; // Relative delays before generating events.
var int i;                // Internal counter.

//=============================================================================
// EDispatcher logic.

//
// When EDispatcher is triggered...
//
function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{
	Instigator = EventInstigator;
	gotostate('Dispatch');
}

//
// Dispatch events.
//
state Dispatch
{
	ignores trigger;

Begin:
	for (i = 0; i < ArrayCount(OutEvents); i++)
	{
		if ((OutEvents[i] != '') && (OutEvents[i] != 'None'))
		{
			Sleep(OutDelays[i]);
			TriggerEvent(OutEvents[i],self,Instigator);
		}
	}
	GotoState('');
}

defaultproperties
{
    Texture=Texture'S_Dispatcher'
}