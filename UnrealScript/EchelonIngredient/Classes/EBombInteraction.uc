class EBombInteraction extends EInteractObject;

function string	GetDescription()
{
	return Localize("Interaction", "Bomb", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	Instigator.Interaction = self;
	EPlayerController(Instigator).JumpLabel = 'DefuseStand';
	Owner.AddSoundRequest(Sound'FisherEquipement.Play_WallMineFix', SLOT_SFX, 1.5f);
	Instigator.GotoState('s_DisableWallMine');
}

function Interact(Controller Instigator)
{
	// Trigger object
	Owner.Trigger(Self, Instigator.Pawn);
	Instigator.GotoState(,'Aborted');
}

function PostInteract(Controller Instigator)
{
	Instigator.Interaction = None;
	Destroy();
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;

	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn == none)
		return;

	GetAxes(Owner.Rotation, X, Y, Z);

	MovePos = Owner.Location;
	MovePos += 1.1f * InteractEPawn.CollisionRadius * X;
	MovePos.Z = InteractEPawn.Location.Z;

	InteractEPawn.m_locationStart	= InteractEPawn.Location;
	InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd		= MovePos;
	InteractEPawn.m_orientationEnd	= Rotator(-X);
}


