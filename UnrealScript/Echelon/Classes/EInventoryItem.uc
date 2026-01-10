////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Name: Basic Item Inventory
//
// Description:
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
class EInventoryItem extends EGamePlayObject
	placeable
	abstract
	native;

// Useful for cams & scope
const REN_DynLight		= 5;
const REN_ThermalVision = 10;
const REN_NightVision	= 11;

var	string					ItemName;
var	string					ItemVideoName;					// Use to display a video of the item in the menu
var	string					Description;
var string                  HowToUseMe;
var	const eInvCategory		Category;
var	int						InventoryTex;
var int						HUDTex;
var(Inventory) int			Quantity;
var(Inventory) const int	MaxQuantity;
var	const bool				bEquipable;						// Exception on Secondary ammo

var	Controller				Controller;

function DrawAdditionalInfo(HUD Hud, ECanvas Canvas);

//------------------------------------------------------------------------
// Description
//		Do own treatment when equipped as current item
//------------------------------------------------------------------------
event Select(EInventory Inv)
{
	GotoState('s_Selected');
}

//------------------------------------------------------------------------
// Description
//		Weapon has been put away / deselected
//------------------------------------------------------------------------
function UnSelect(EInventory Inv)
{
	if (GetStateName() == 's_Selected')
		GotoState('s_Inventory');
}

//---------------------------------------[David Kalina - 12 May 2002]-----
//
// Description
//		Kill old Controller variable -- if it was in the old Controller's
//		inventory, remove the item from that inventory.
//
//------------------------------------------------------------------------

function ResetController()
{
	local EPawn OwnerPawn;

	// if picking up a weapon owned by someone else, remove it from their inventory
	if (Controller != none)
	{
		// Remove it from inventory
		OwnerPawn = EPawn(Controller.Pawn);
		if (OwnerPawn != none)
		{
			OwnerPawn.FullInventory.RemoveItem(self,1);
		}
	}

	Controller = none;
}

//------------------------------------------------------------------------
// Description
//		Set Controller plus bas class processing
//------------------------------------------------------------------------
function bool NotifyPickup(Controller Instigator)
{
	local EInventory Inv;
	Inv = EPawn(Instigator.Pawn).FullInventory;

	ResetController();

	// Controller needs to be set before going into s_Selected
	Controller = Instigator;
	if (Controller == None)
		Log(self$" ERROR: EInventoryItem should always have an owner controller.");

	if (Controller.bIsPlayer)
		EPlayerController(Controller).SendTransmissionMessage(Localize("InventoryItem", ItemName, "Localization\\HUD") $ Localize("Transmission", "PickUp", "Localization\\HUD"), TR_INVENTORY);

	// Add to inventory
	Add(Instigator, Instigator, Inv);

	return true; // no go in hand
}

//------------------------------------------------------------------------
// Description
//		Called from inventory only
//------------------------------------------------------------------------
event bool CanAddThisItem(EInventoryItem ItemToAdd)
{
	// If item is first to be added
	if (ItemToAdd == self)
		return true;

	// Check if the item is a bundle
	if (MaxQuantity > 1)
	{
		// Check if we can add the quantity requested
		if (Quantity < MaxQuantity)
			return true;
	}

	return false;
}

function Throw(Controller Thrower, vector ThrowVelocity)
{
	Super.Throw(Thrower, ThrowVelocity);

	// If an inventory item goes to flying mode, it's because it's been
	// thrown in the air from a pawn, so we gotta remove 1 from the inventory.
	ProcessUseItem();
}

//------------------------------------------------------------------------
// Description
//		Called from any item when needs to remove from inventory
//------------------------------------------------------------------------
function ProcessUseItem()
{
	local EInventory		Inv;
	local EInventoryItem	NextItem;

	// May go into flying mode from an explosion when on ground.
	if (Controller == None)
		return;

	Inv = EPawn(Controller.Pawn).FullInventory;

	// Remove it from inventory
	Inv.RemoveItem(self,1);

	// Equip the next one
	NextItem = Inv.GetItemByClass(self.class.name);
	// Even if None, Epc will take care to fall back on any available weapon
	Inv.SetSelectedItem(NextItem);
}

//------------------------------------------------------------------------
// Description
//		Sent from Inventory when added successfully
//------------------------------------------------------------------------
event AddedToInventory()
{
	GotoState('s_Inventory');
}

//------------------------------------------------------------------------
// Description
//		Sent when removed from inventory
//------------------------------------------------------------------------
event RemovedFromInventory()
{
	if (Controller != None && Controller.bIsPlayer)
		EPlayerController(Controller).NotifyLostInventoryItem(self);
}

function Reset()
{
	Super(Actor).Reset();
}

// Do nothing
function BaseChange();

//------------------------------------------------------------------------
// Description
//		Wrapper to put and item into an inventory, link to its owner and set its controller
//		Controller and Owner might not be the same (see EGameplayObject owns an Inventory)
//------------------------------------------------------------------------
function Add(Actor NewOwner, Controller NewController, EInventory Inventory)
{
	local EInventoryItem PrevSecondary, PrevPrimary;
	local EInventoryItem Item;

	// Set its Owner .. not necessary anymore
	if (NewOwner != None)
		SetOwner(NewOwner);

	// Set Controller to process specific message to pawn/controller
	ResetController();
	if (NewController != None)
		Controller = NewController;

	// Add to Inventory
	if (Inventory == None)
		Log(self@"Problem in EInventoryItem::Add inventory == None");

	// Joshua - Save selected items before adding (native code may change selection)
	PrevSecondary = Inventory.BackPackSecSelectedItem;
	PrevPrimary = Inventory.BackPackPrimSelectedItem;

	Inventory.AddInventoryItem(self);
	Inventory.SortInventory();

	// Joshua - Restore selected items by class (object reference may change during add)
	// Set silent restore flag to prevent equip sounds during sort
	Inventory.bSilentRestore = true;

	if (PrevPrimary != None)
	{
		Item = Inventory.GetItemByClass(PrevPrimary.class.Name);
		if (Item != None)
		{
			Inventory.BackPackPrimSelectedItem = Item;
			Item.Select(Inventory);
		}
	}

	if (PrevSecondary != None)
	{
		Item = Inventory.GetItemByClass(PrevSecondary.class.Name);
		if (Item != None)
		{
			Inventory.BackPackSecSelectedItem = Item;
			Item.Select(Inventory);
		}
	}

	// Joshua - Clear silent restore flag
	Inventory.bSilentRestore = false;
}

// Joshua - Implemented in EAirCamera, needs to be called by EPlayerController so declared here
function ClearPreviousCamera() { }
function SwitchToCamera() { }
function bool CanSwitchTo() { return false; } // Default returns false, EAirCamera overrides

// ----------------------------------------------------------------------
// state s_Pickup
// ----------------------------------------------------------------------
state s_Pickup
{
	function BeginState()
	{
		SetOwner(None);
		ResetController();

		// Give interaction
		ResetInteraction();
		if (InteractionClass != None)
			Interaction = Spawn(InteractionClass,self);

		// turn on collision
		SetCollision(true);

		bHidden			= false;
		bCollideWorld	= true;

		SetPhysics(PHYS_Falling);
	}
}

// ----------------------------------------------------------------------
// state s_Inventory
// ----------------------------------------------------------------------
state s_Inventory
{
	function BeginState()
	{
		// Checks
		if (Controller == None)
			Log(self$" ERROR: has no Controller");

		if (Owner == None)
			Log(self$" PROBLEM: has no Owner");

		// Restore valid StaticMesh if it was changed for qty
		if (StaticMesh != default.StaticMesh)
			SetStaticMesh(default.StaticMesh);

		// Inactive, invisible
		ResetInteraction();
		bHidden	= true;

		SetCollision(false);
		bCollideWorld = false;
	}

	function EndState()
	{
		bHidden = false;
	}
}

// ----------------------------------------------------------------------
// state s_Selected
// ----------------------------------------------------------------------
state s_Selected {}

defaultproperties
{
    Category=CAT_ITEMS
    Quantity=1
    MaxQuantity=1
    bEquipable=True
    bPickable=True
    bDamageable=False
    bTravel=True
}