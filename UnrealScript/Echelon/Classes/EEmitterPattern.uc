class EEmitterPattern extends Emitter;

var() PhysicsVolume	LinkedVolume;
var() float			TurnedOffTime;

function Trigger(Actor Other, Pawn EventInstigator, optional name InTag) // UBI MODIF
{
	Log("EEmitterPattern Triggered"@Other);
	//Super.Trigger(Other, EventInstigator);

	Kill();

	if (TurnedOffTime > 0 && LinkedVolume != None)
		SetTimer(TurnedOffTime, false);
}

function Timer()
{
	Log("EEmitterPattern Timer"@TurnedOffTime);
	if (LinkedVolume != None)
		LinkedVolume.SetCollision(false);
}

