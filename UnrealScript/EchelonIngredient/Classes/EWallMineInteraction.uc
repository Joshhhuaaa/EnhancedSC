class EWallMineInteraction extends EInteractObject;

var EWallMine	WallMine;
var	bool		DefuseSuccessful;
var bool		bInteractedWith;

function string	GetDescription()
{
	return Localize("Interaction", "WallMine", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	local float				DefuseHeight;
	local EPlayerController Epc;

	WallMine = EWallMine(Owner);
	if (WallMine == None)
		Log("EWallMineInteraction problem with Owner");

	DefuseSuccessful = !WallMine.Emitting;
	WallMine.Defuser = Instigator;
	bInteractedWith = false;

	Instigator.Interaction = self;

	DefuseHeight = WallMine.Location.Z - Instigator.Pawn.Location.Z;

	if (Instigator.bIsPlayer)
	{
		Epc = EPlayerController(Instigator);
		//Log("defuse height"@DefuseHeight);

		if (DefuseHeight > 60)
		{
			//Log("High mine while crouched");
			Epc.JumpLabel = 'DefuseStand';
		}
		else if (DefuseHeight > 25)
		{
			//Log("High mine while standing");
			Epc.JumpLabel = 'DefuseStand';
		}
		else if (DefuseHeight > 0)
		{
			//Log("Low mine while crouched");
			Epc.JumpLabel = 'DefuseCrouch';
		}
		else
		{
			//Log("Low mine while standing");
			Epc.JumpLabel = 'DefuseCrouch';
		}
	}

	// Remove collision to be able to uncrouch in defuse if high wallmine while crouch
	WallMine.SetCollision(Owner.bCollideActors, Owner.bBlockActors, false);

	Instigator.GotoState('s_DisableWallMine');
}

//---------------------------------------[David Kalina - 18 Nov 2001]-----
// 
// Description
//		If called, the wall mine is successfully defused.  
//		NPC has a random chance of failure.
//		After this function is called, the WallMine becomes inactive and resets the Pickup Interaction.
// 
//------------------------------------------------------------------------
function Defuse(Controller Instigator)
{
	local EAIController AI;
	
	// check for defuse success from 
	AI = EAIController(Instigator);
	
	if (AI != none && AI.EPawn != none)
	{
		if (FRand() < AI.EPawn.DefuseMinePercentage)
			DefuseSuccessful = true;
	}


}

function Interact(Controller Instigator)
{
	local EAIController AI;

	// AI does not call PostInteract directly
	AI = EAIController(Instigator);
	if (AI != none)
		Defuse(AI);
	// Will activate or deactivate wall mine ONLY if interacted with 
	else
	{
		bInteractedWith = true;
		WallMine.Deactivate(DefuseSuccessful);
	}

	// Check if can deactivate now
	// Unsuccessful
	if (!DefuseSuccessful)
	{
		WallMine.Detonate(Instigator);
		Instigator.GotoState(,'Aborted');
	}
	// AI
	else if (AI != None)
		PostInteract(Instigator);
	// Player
	else if (EPawn(Instigator.Pawn).FullInventory.CanAddItem(WallMine))
	{
		EPlayerController(Instigator).ChangeHandObject(WallMine);
		Instigator.GotoState(,'SheathMine');
	}
	// Player can't pickup wall mine
	else
	{
		WallMine.GotoState('');			// Stop doing the emitting stuff
		WallMine.Interaction = None;	// Remove link to this interaction
		WallMine.StoppedMoving();		// bPickable = true and Interaction = None will spawn a pickup interaction
		Instigator.GotoState(,'Aborted');
	}
}

function PostInteract(Controller Instigator)
{
	// Restore collision from InitInteract
	Owner.SetCollision(Owner.bCollideActors, Owner.bBlockActors, true);

	WallMine.Defuser = None;
	Instigator.Interaction = None;

	if (Instigator.bIsPlayer && bInteractedWith)
	{
		// Success & wallmine in inventory
		if (EPawn(Instigator.Pawn).HandItem == WallMine)
	{
		EGameplayObject(Owner).NotifyPickup(Instigator);
		EPlayerController(Instigator).ChangeHandObject(None);
		}
		// Success but wallmine couldn't be carried
		else if (DefuseSuccessful)
		{
			EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "NoPickUp", "Localization\\HUD") $ Localize("InventoryItem", WallMine.ItemName, "Localization\\HUD"), TR_INVENTORY);			
		}

		Destroy();
	}
	else if (!Instigator.bIsPlayer && DefuseSuccessful)
	{
		// Wallmine will be idle on wall + give back pickup interaction
		WallMine.InteractionClass = class'EPickupInteraction';
		WallMine.Interaction = Spawn(WallMine.InteractionClass, WallMine);
		
		Destroy();
	}
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	local vector HitLocation, HitNormal;

    if (WallMine == None)
    {
	    WallMine = EWallMine(Owner);
    }

	if (WallMine == None)
    {
		Log("EWallMineInteraction problem with Owner");
    }
	
	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn == none)
		return;

	// get WallMine object rotation axes for positioning
	GetAxes(WallMine.Rotation, X, Y, Z);
	
	MovePos = WallMine.Location;
		MovePos += InteractEPawn.CollisionRadius * X;

	if (InteractEPawn.bIsPlayerPawn)
	{
		MovePos.Z	= InteractEPawn.Location.Z;									// keep on same Z
	}
	else
	{
		if (Trace(HitLocation, HitNormal, MovePos + vect(0,0,-200), MovePos,,,,,true) != None)
		{
			HitLocation.Z += InteractEPawn.CollisionHeight;
			MovePos = HitLocation;
		}
	}
	
	InteractEPawn.m_locationStart	= InteractEPawn.Location;
	InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd		= MovePos;
	InteractEPawn.m_orientationEnd	= Rotator(-X);
}

defaultproperties
{
    iPriority=20000
}