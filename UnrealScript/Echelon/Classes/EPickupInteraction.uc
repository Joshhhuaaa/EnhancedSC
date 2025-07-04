class EPickupInteraction extends EInteractObject;

var name PreviousItemClass;

function string	GetDescription()
{
	if( Owner.IsA('EInventoryItem') )
		return Localize("InventoryItem", EInventoryItem(Owner).ItemName, "Localization\\HUD");


	else if( Owner.bIsGamePlayObject )
		return Localize("GameplayObject", string(EGameplayObject(Owner).ObjectName), "Localization\\HUD");
	else
		return string(Owner.class.name);
		
}

function InitInteract( Controller Instigator )
{	
	local float				PickupHeight;
	local EPlayerController Epc;
	local EInventoryItem	Item;
	Item = EInventoryItem(Owner);

	// If it's a EGameplayObject, just pick it up and leave in hands 
	// If it's an inventoryItem and enough space in inventory
	if( Item == None || EPawn(Instigator.Pawn).FullInventory.CanAddItem(Item) )
	{
		Epc = EPlayerController(Instigator);
		PickupHeight = Owner.Location.Z - Epc.ePawn.Location.Z;
		//Log("PickupHeight"@PickupHeight@0.3f * -Epc.ePawn.CollisionHeight);

		if( PickupHeight > 0.3f * -Instigator.Pawn.CollisionHeight )
		{
			//Log("High object");
			Epc.JumpLabel = 'PickupHigh';
		}
		else
		{
			//Log("Low object");
			Epc.JumpLabel = 'PickupLow';
		}

		// Remove collision on picked up object
		Owner.SetCollision(false);

		Instigator.Interaction = self;
		Instigator.GotoState('s_PickUp');

		return;
	}
	else if( Instigator.bIsPlayer )
		EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "NoPickUp", "Localization\\HUD") $ Localize("InventoryItem", Item.ItemName, "Localization\\HUD"), TR_INVENTORY);


	EPlayerController(Instigator).ReturnFromInteraction();
}

function Interact( Controller Instigator )
{
	// Trigger object
	Owner.Trigger(Self, Instigator.Pawn);

	if( !Instigator.bIsPlayer )
		return;

	EPlayerController(Instigator).ePawn.PlaySound(Sound'FisherFoley.Play_FisherPickUpObject', SLOT_SFX);

	// backup selected item by class in case we pick up an item of the same class
	if( EPlayerController(Instigator).ePawn.HandItem != None )
		PreviousItemClass = EPlayerController(Instigator).ePawn.HandItem.class.name;
	// Change to picked up item
	EPlayerController(Instigator).ChangeHandObject(EGameplayObject(Owner), !Owner.IsA('EInventoryItem'));
}

function PostInteract( Controller Instigator )
{
	local EPlayerController Epc;
	Epc = EPlayerController(Instigator);

	// reset interaction
	Instigator.Interaction = None;

	if( Epc.ePawn.HandItem != Owner )
	{
		Log("ERROR: Owner["$Owner$"] was not picked up in PostInteract by "$Instigator);
		return;
	}

	// Restore collision on picked up object
	Owner.SetCollision(true);

	// if true, owner is in inventory
	if( EGameplayObject(Owner).NotifyPickup(Instigator) && Instigator.bIsPlayer )
	{
		if( PreviousItemClass != '' )
		{
			//Log("PreviousItemClass"@PreviousItemClass);
			Epc.ePawn.FullInventory.SetSelectedItem(Epc.ePawn.FullInventory.GetItemByClass(PreviousItemClass));
		}
		else
		{
			//Log("Nothing in hands");
		EPlayerController(Instigator).ChangeHandObject(None);
	}
}
}

function SetInteractLocation( Pawn InteractPawn )
{
	local Vector X, Y, Z, MovePos;
	local Rotator ItemDir;
	local EPawn InteractEPawn;
	InteractEPawn = EPawn(InteractPawn);

	if( InteractEPawn == None )
		return;

	ItemDir = Rotator(Owner.Location - InteractEPawn.Location);
	GetAxes(ItemDir, X, Y, Z);

	// Set this for MoveToDestination
	MovePos = Owner.Location;
	MovePos -= InteractEPawn.CollisionRadius * X;
	MovePos.Z = InteractEPawn.Location.Z;

	InteractEPawn.m_locationStart		= InteractEPawn.Location;
	InteractEPawn.m_orientationStart	= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd			= MovePos;
	InteractEPawn.m_orientationEnd.Yaw	= ItemDir.Yaw;
	InteractEPawn.m_orientationEnd.Pitch= 0;
	InteractEPawn.m_orientationEnd.Roll = 0;
}

defaultproperties
{
    iPriority=10000
}