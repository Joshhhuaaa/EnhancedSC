class EAIEvent extends Actor
	native;


var AIEventType		EventType;
var Vector			EventLocation;
var Actor			EventTarget;
var Actor			EventActor;
var BroadCastType	EventBroadcastType;
var	float			ReceivedTime;
var Controller		Instigator;
var NoiseType		EventNoiseType;


function Reset()
{
	EventType			= AI_NONE;
	EventLocation		= vect(0,0,0);
	EventTarget			= None;
	EventActor			= None;
	EventBroadcastType	= BC_SELF_DIRECTED;
	EventNoiseType		= NOISE_None;
}


function Set(EAIEvent source)
{
	EventType			= source.EventType;
	EventLocation		= source.EventLocation;
	EventTarget			= source.EventTarget;
	EventActor			= source.EventActor;
	EventNoiseType		= source.EventNoiseType;

	EventBroadcastType	= source.EventBroadcastType;
}

defaultproperties
{
    bHidden=True
}