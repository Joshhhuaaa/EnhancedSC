//=============================================================================
// LineOfSightTrigger
// triggers its event when player looks at it from close enough
// ONLY WORKS IN SINGLE PLAYER (or for the local client on a listen server)
// You could implement a multiplayer version using a tick function and PlayerCanSeeMe(),
// but that would have more performance cost
//=============================================================================
class LineOfSightTrigger extends Triggers
	native;

var() float MaxViewDist;	// maximum distance player can be from this trigger to trigger it
var   float OldTickTime;
var() bool  bEnabled;
var	  bool  bTriggered;		
var() name	SeenActorTag;	// tag of actor which triggers this trigger when seen
var	  actor SeenActor;
var() int MaxViewAngle;		// how directly a player must be looking at SeenActor center (in degrees)
var float RequiredViewDir;	// how directly player must be looking at SeenActor - 1.0 = straight on, 0.75 = barely on screen

function PostBeginPlay()
{
	Super.PostBeginPlay();

	RequiredViewDir = cos(MaxViewAngle * PI / 180);
	if ((SeenActorTag != '') && (SeenActorTag != 'None'))
		ForEach AllActors(class'Actor',SeenActor,SeenActorTag)
			break;
}

event PlayerSeesMe(PlayerController P)
{
	TriggerEvent(Event,self,P.Pawn);
	bTriggered = true;
}

function Trigger(actor Other, Pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
{
	bEnabled = true;
}

defaultproperties
{
    MaxViewDist=3000.000000
    bEnabled=True
    MaxViewAngle=15
    bCollideActors=False
}