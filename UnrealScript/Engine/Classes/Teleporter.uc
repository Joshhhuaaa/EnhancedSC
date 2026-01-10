class Teleporter extends NavigationPoint
	placeable
	native;

var() string URL;
var() name ProductRequired;
var() bool    bChangesVelocity; // Set velocity to TargetVelocity.
var() bool    bChangesYaw;      // Sets yaw to teleporter's Rotation.Yaw
var() bool    bReversesX;       // Reverses X-component of velocity.
var() bool    bReversesY;       // Reverses Y-component of velocity.
var() bool    bReversesZ;       // Reverses Z-component of velocity.
var() bool	  bEnabled;			// Teleporter is turned on;
var() vector  TargetVelocity;   // If bChangesVelocity, set target's velocity to this.
var Actor TriggerActor;		//used to tell AI how to trigger me
var Actor TriggerActor2;
var float LastFired;
function PostBeginPlay()
{
}

function FindTriggerActor()
{
}

// Accept an actor that has teleported in.
function bool Accept(actor Incoming, Actor Source)
{
	return true;
}

function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
{
}

// Teleporter was touched by an actor.
function Touch(actor Other)
{
}

function Actor SpecialHandling(Pawn Other)
{
	return None;
}


