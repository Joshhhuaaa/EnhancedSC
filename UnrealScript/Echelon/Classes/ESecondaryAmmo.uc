class ESecondaryAmmo extends EInventoryItem
	abstract native;

var()	int		AmmoVelocity;
var()	Sound	UseSound;
var EMainGun	OwnerGun;
var int         HUDTexSD;

//------------------------------------------------------------------------
// Description		
//		Do own treatment when equipped as current item
//------------------------------------------------------------------------
function Select(EInventory Inv)
{
	Super.Select(Inv);

	if (EMainGun(Inv.BackPackPrimSelectedItem) != None)
	{
		OwnerGun = EMainGun(Inv.BackPackPrimSelectedItem);
		OwnerGun.Link(self);
	}
	// If a secondary ammo is selected, force maingun selection
	else
	{
		//Log("Choosing a sec ammo and force EMainGun to be selected");
		Inv.SetSelectedItem(Inv.GetItemByClass('EMainGun'));
	}
}

//------------------------------------------------------------------------
// Description		
//		Weapon has been put away / deselected
//------------------------------------------------------------------------
function UnSelect(EInventory Inv)
{
	Super.UnSelect(Inv);

	if (OwnerGun != None)
		OwnerGun.Link(None);
}

function ProcessUseItem()
{
	Super.ProcessUseItem();
	OwnerGun = None;
}

state s_Inventory
{
	function EndState()
	{
		Super.EndState();
		bHidden = true; // No unhide
	}
}

state s_Selected
{
	function Use()
	{
		// play sound
		PlaySound(UseSound, SLOT_Interface);

		if (Controller.bIsPlayer)
			SetLocation(EPlayerController(Controller).GetFireStart());
		else
			SetLocation(OwnerGun.Location);

		// throw interface switches our state to s_flying
		Throw(Controller, AmmoVelocity * (Vect(1,0,0) >> Controller.Rotation));
	}
}

state s_Flying
{
	function BeginState()
	{
		Super.BeginState();
		SetRotation(Rotator(Velocity));
	}

	function Bump(Actor Other, optional int Pill)
	{
		// if not a pawn or if hit firing pawn
		if (Controller != None && Other == Controller.Pawn)
			return;

		Super.Bump(Other, Pill);
	}
}

defaultproperties
{
    AmmoVelocity=3000
    Category=CAT_MAINGUN
    bEquipable=false
    bIsProjectile=true
    Mass=60.000000
}