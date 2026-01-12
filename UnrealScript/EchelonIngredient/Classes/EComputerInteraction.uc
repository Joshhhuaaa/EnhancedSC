class EComputerInteraction extends EInteractObject;

function string	GetDescription()
{
	return Localize("Interaction", "Computer", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	// Make pawn interact
	Instigator.Interaction = self;
	if (Instigator.GetStateName() == 's_Grab')
		Instigator.GotoState(,'Computer');
	else
		Instigator.GotoState('s_Computer');

}

function bool IsAvailable()
{
	local vector PawnDir, OwnerDir;

	// Check how high keyboard is compared to player Z.  12-15 being the perfect height.
	if (InteractionPlayerController.Pawn.Location.Z - Owner.Location.Z > 20.f)
		return false;

	PawnDir		= Normal(InteractionPlayerController.Pawn.Location - Owner.Location);
	OwnerDir	= vector(Owner.Rotation);
	if ((OwnerDir Cross PawnDir).Z > -0.3f)
		return false;

	return Super.IsAvailable();
}

function Interact(Controller Instigator)
{
	EPlayerController(Instigator).ePawn.PlaySound(Sound'Electronic.Play_Sq_ComputerKeyBoard', SLOT_SFX);

	// Trigger object
	Owner.Trigger(Self, Instigator.Pawn);
}

function PostInteract(Controller Instigator)
{
	local array<EMemoryStick>	FoundMems;
	local int					i;

	// Retreive information
	if (EchelonLevelInfo(Level).GetMemoryStick(FoundMems, Owner))
	{
		for (i = 0; i < FoundMems.Length; i++)
		{
			//Log("Adding memory information in "$Instigator.Pawn$"'s Inventory.");
			FoundMems[i].NotifyPickup(Instigator);
		}

        if (EPlayerController(Instigator) != None)
		{
		    EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "ComputerPickup", "Localization\\HUD"), TR_CONSOLE);

			// Joshua - Show quick data view prompt if enabled
			if (EPlayerController(Instigator).bQuickDataView)
				EPlayerController(Instigator).SendTransmissionMessage(EPlayerController(Instigator).Player.Console.ProcessKeyBindingText(Localize("Transmission", "QuickDataViewPrompt", "Localization\\Enhanced")), TR_CONSOLE);
		}
	}

	// reset interaction
	Instigator.Interaction = None;

	// No reset if in Grab
	if (Instigator.GetStateName() == 's_Grab')
		Instigator.GotoState(,'ComputerEnd');

	EPlayerController(Instigator).ePawn.PlaySound(Sound'Electronic.Stop_Sq_ComputerKeyBoard', SLOT_SFX);

	// destroy when used
	//Destroy(); For Mathieu
}

function SetInteractLocation(Pawn InteractPawn)
{
	local vector MovePos, X,Y,Z;
	local EPawn InteractEPawn;

	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn == None)
		return;

	GetAxes(Owner.Rotation, X,Y,Z);

	// set location depending on state
	MovePos		= Owner.Location;
	MovePos    -= Owner.default.CollisionRadius * Y;
	switch (InteractEPawn.Controller.GetStateName())
	{
	case 's_Computer':
		MovePos    -= InteractEPawn.CollisionRadius * 0.9f * Y;
		break;

	case 's_grab':
		MovePos    -= InteractEPawn.CollisionRadius * 1.7f * Y;
		MovePos    += (10.f) * X;
		break;
	}
	MovePos.Z	= InteractEPawn.Location.Z;									// keep on same Z

	InteractEPawn.m_locationStart		= InteractEPawn.Location;
	InteractEPawn.m_orientationStart	= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd			= MovePos;
	InteractEPawn.m_orientationEnd		= Rotator(Y);
}

defaultproperties
{
    iPriority=9000
}