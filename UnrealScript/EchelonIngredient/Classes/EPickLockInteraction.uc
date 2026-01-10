class EPickLockInteraction extends EPopObjectInteraction;

var ELockpick			LockPick;
var ESwingingDoor		MyDoor;
var EPickLockSystem		PLS;

function PostBeginPlay();

function Set(ESwingingDoor door, ELockPick pick)
{
	MyDoor = door;
	LockPick = pick;
}

function InitInteract(Controller Instigator)
{
	PLS = spawn(class'EPickLockSystem');
	if (PLS == None)
		Log(self$" ERROR: Couldn't spawn pick lock system");
	// For base processing in EPopObjectInteraction
	SetOwner(PLS);

	Super.InitInteract(Instigator);

	Pls.Init(Instigator, self);
}

function Interact(Controller Instigator)
{
	MyDoor.Unlock();
}

function PostInteract(Controller Instigator)
{
	// reset interaction
	Instigator.Interaction	= None;
	InteractionController	= None;

	EPlayerController(Instigator).ReturnFromInteraction();

	// Send transmission
	if (!MyDoor.Locked)
		EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "DoorPick", "Localization\\HUD"), TR_CONSOLE);

	LockPick.Interaction = None;

	if (PLS != None)
		PLS.Destroy();
	Destroy();
}

function ProcessAxis(Controller C, float aForward, float aStrafe, float XAxis, float YAxis)
{
	if (PLS != None)
		PLS.MoveAxis(aForward, aStrafe);
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	local bool isSideFront;

	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn == None)
		return;

	GetAxes(MyDoor.MyKnob.Rotation, X, Y, Z);
	// Get door opening direction
	isSideFront = MyDoor.GetPawnSide(InteractPawn) == ESide_Front;
	if (!isSideFront)
		Y = -Y;

	MovePos	 = MyDoor.MyKnob.Location;
	MovePos	-= 1.2f * InteractEPawn.CollisionRadius * Y;
	MovePos -= 0.8f * InteractEPawn.CollisionRadius * X;
	MovePos.Z	= InteractEPawn.Location.Z;

	InteractEPawn.m_locationStart	= InteractEPawn.Location;
	InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd		= MovePos;
	if (isSideFront)
		InteractEPawn.m_orientationEnd	= Rotator(Y) - Rot(0,7000,0);
	else
		InteractEPawn.m_orientationEnd	= Rotator(Y) + Rot(0,7000,0);
}

defaultproperties
{
    ViewRelativeLocation=(X=40.000000,Y=10.000000,Z=2.000000)
    ViewRelativeRotation=(Pitch=-1000,Yaw=28000,Roll=0)
    bCollideActors=False
}