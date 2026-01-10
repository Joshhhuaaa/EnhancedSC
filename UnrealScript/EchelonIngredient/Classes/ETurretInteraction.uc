////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Name: Turret
//
// Description: Process an interaction on a Turret.  For now, this interaction resides in deactivating it
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ETurretInteraction extends EInteractObject;

var ETurretController	TurretController;
var Controller			User;

function string	GetDescription()
{
	return Localize("Interaction", "Turret", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	TurretController = ETurretController(Owner);
	if (TurretController == None)
		Log("ETurretInteraction - InitInteract: Can't InitInteract");

	User = Instigator;
	Instigator.Interaction = self;
	Instigator.GotoState('s_Turret');
}

//------------------------------------------------------------------------
// Description
//		Npc only
//------------------------------------------------------------------------
function Interact(Controller Instigator)
{
	if (Instigator.IsA('EAIController'))
		TurretController.EnableFOF();
}

function PostInteract(Controller Instigator)
{
	User = None;
	Instigator.Interaction = None;
	Instigator.GotoState(,'End');
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;

	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn == None)
		return;

	// get MyKeyPad object rotation axes for positioning
	GetAxes(Owner.Rotation, X, Y, Z);

	MovePos = Owner.Location;
	MovePos += (1.9f * InteractEPawn.CollisionRadius) * X;
	//MovePos += (0.75f * InteractEPawn.CollisionRadius) * Y;
	MovePos.Z = InteractEPawn.Location.Z;

	InteractEPawn.m_locationStart	= InteractEPawn.Location;
	InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd		= MovePos;
	InteractEPawn.m_orientationEnd	= Rotator(-X);
}

function KeyEvent(String Key, EInputAction Action, FLOAT Delta, optional bool bAuto)
{
	TurretController.KeyEvent(Key, Action, Delta);
}

function bool IsAvailable()
{
	local Vector TurretView, CharacterDir;

	// Get Character direction to check if he's in the back of the turret
	TurretView = vect(1,0,0) >> Owner.Rotation;
	CharacterDir = Normal(InteractionPlayerController.Pawn.Location - Owner.Location);
	if (TurretView Dot CharacterDir > 0.6)
		return Super.IsAvailable();
	else
		return false;
}

