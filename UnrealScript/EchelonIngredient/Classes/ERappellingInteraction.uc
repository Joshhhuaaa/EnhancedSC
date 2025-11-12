class ERappellingInteraction extends EInteractObject;

function string	GetDescription()
{
	return Localize("Interaction", "Rappel", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	local EPlayerController EPC;
	local ERappellingObject RO;

	EPC = EPlayerController(Instigator);
	RO = ERappellingObject(Owner);
	Owner.bBlockPlayers = false;

	// Set rappelling height in PlayerController
	EPC.m_Elongation = RO.Location.Z - RO.RappellingHeight;

	// Set max Up direction for rappelling, Can't use bsp trace for there's windows in the way
	if (Instigator.bIsPlayer)
		EPC.m_HoistStOffset = Owner.ToWorld(Owner.CollisionHeight * Vect(0,0,-1));

	// Make pawn interact
	Instigator.Interaction = self;
	Instigator.GotoState('s_Rappelling', 'FromTop');

	// Create Rope
	if (RO.Rope == None)
		RO.Rope = Spawn(class'ERapelRopeActor', RO);

	if (RO.Rope != None)
	{
		EPC.RapelRope = RO.Rope;
	}
}

function PostInteract(Controller Instigator)
{
	// reset interaction
	Instigator.Interaction = None;

	Owner.bBlockPlayers = true;
}

function SetInteractLocation(Pawn InteractPawn)
{
	local EPawn		ePawn;
	local Vector	DestPos, DestRot;

	ePawn = EPawn(InteractPawn);
	if (ePawn == None)
		return;

	DestRot		= Owner.ToWorldDir(vect(1,0,0));
	DestPos		= Owner.Location;
	DestPos	   	+= (ePawn.CollisionRadius + Owner.default.CollisionRadius + 1) * DestRot;
	DestPos.Z	= ePawn.Location.Z;

	ePawn.m_locationStart	= ePawn.Location;
	ePawn.m_locationEnd		= DestPos;
	ePawn.m_orientationStart= ePawn.Rotation;
	ePawn.m_orientationEnd	= Rotator(-DestRot);
}

