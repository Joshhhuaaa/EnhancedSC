	////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Name: InteractObject
//
// Description: Basic object for interactions
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

class EInteractObject extends Actor
	abstract
	native;

var int					iPriority;
var bool				bSeeToInteract;
var PlayerController	InteractionPlayerController;	// Only used in Touch, UnTouch and Tick. DONT use it in InitInteract, Interact, or PostInteract!!!

function string	GetDescription();
function InitInteract(Controller Instigator);
function Interact(Controller Instigator);
function PostInteract(Controller Instigator);
function SetInteractLocation(Pawn InteractPawn);
function KeyEvent(String Key, EInputAction Action, FLOAT Delta, optional bool bAuto);
function ProcessAxis(Controller C, float aForward, float aStrafe, float XAxis, float YAxis);
function LockOwner(bool bLocked);

function PostBeginPlay()
{
	Super.PostBeginPlay();
	// At least bigger than Owner Collision size
	SetCollisionSize(Owner.CollisionRadius + 50, Owner.CollisionHeight + 50);
	// To make the InteractObject always follow its owner
	SetBase(Owner);
}

//------------------------------------------------------------------------
// Description		
//		DestroyActor won't call the UnTouch on this actor so call this manually
//------------------------------------------------------------------------
function Destroyed()
{
	if (InteractionPlayerController != None)
		InteractionPlayerController.IManager.RemoveInteractionObj(Self);

	Super.Destroyed();
}

//------------------------------------------------------------------------
// Description		
//		Never change the priority by hand
//------------------------------------------------------------------------
function SetPriority(int iNewPriority)
{
	local bool OldCollideActors;
	OldCollideActors = bCollideActors;

	if (OldCollideActors)
	SetCollision(false);
	
	iPriority = iNewPriority;

	if (OldCollideActors)
	SetCollision(true);
}

//------------------------------------------------------------------------
// Description		
//		Used to Know if interaction can be used .. 
//		Test Collision, Orientation and availability here.
//------------------------------------------------------------------------
function bool IsAvailable()
{
	local vector HitLocation, HitNormal;
	local Actor TraceHit;

	// Dont check pawns
	TraceHit = Trace(HitLocation, HitNormal, InteractionPlayerController.Pawn.Location, Location, true,,,, true);

	//log("	IsAvailable 0 -- HitActor : " $ TraceHit $ "  HitLocation :  " $ HitLocation $ "  TRACE from : " $ InteractionPlayerController.Pawn.Location $ " to : " $ Location);

	// Quick check from Location to Location
	if (TraceHit == None || TraceHit == InteractionPlayerController.Pawn)
		return true;

	// Else check with higher point on player's body
	TraceHit = Trace(HitLocation, HitNormal, InteractionPlayerController.Pawn.ToWorld(0.7f * InteractionPlayerController.Pawn.CollisionHeight * Vect(0,0,1)), Location, true,,,, true);

	//log("	IsAvailable 1 -- HitActor : " $ TraceHit $ "  HitLocation :  " $ HitLocation $ "  TRACE from : " $ InteractionPlayerController.Pawn.Location $ " to : " $ Location);

	return TraceHit == None || TraceHit == InteractionPlayerController.Pawn;
}

function Touch(actor Other)
{
	local Pawn P;

	P = Pawn(Other);
	if (P == None || !P.bIsPlayerPawn || P.Controller == None)
		return;

	InteractionPlayerController = PlayerController(P.Controller);

	//log(self$" Touch--AddToManager."@InteractionPlayerController.CanAddInteract(self)@IsAvailable()); 

	if (InteractionPlayerController.CanAddInteract(self) && IsAvailable())
		InteractionPlayerController.IManager.AddInteractionObj(Self);
	else
		UnTouch(Other);
}

function UnTouch(actor Other)
{
	local Pawn P;

	P = Pawn(Other);
	if (P == None || !P.bIsPlayerPawn || InteractionPlayerController == None)
		return;

	//log(self$" UnTouch--RemoveInteractionObj called."); 

	InteractionPlayerController.IManager.RemoveInteractionObj(Self);
	InteractionPlayerController = None;
}

defaultproperties
{
    iPriority=999999
    bHidden=True
    bCollideActors=True
    bIsNPCRelevant=False
}