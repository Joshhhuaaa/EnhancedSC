class EMainGun extends ESniperGun
	abstract;

// Tages
var int				BulletsAccuracy;
var EInventoryItem	SecondaryAmmo;

event SetSecondaryAmmo(EInventoryItem Item)
{
	SecondaryAmmo = Item;
}

function bool SwitchROF()
{
    // switch ROF
    if( !bSniperMode )
    {
        switch( eROFMode )
        {
        case ROF_Single:
			eROFMode = ROF_Burst;
            break;

        case ROF_Burst:
            eROFMode = ROF_Auto;
            break;

        case ROF_Auto:
            eROFMode = ROF_Single;
            break;
        }
    }

    return !bSniperMode;
}

function bool IsROFModeAvailable(ERateOfFireMode rof)
{
    switch( rof )
    {
        case ROF_Single:
		case ROF_Burst:
        case ROF_Auto:
            return true;

        default:
            return false;
    }
}


//------------------------------------------------------------------------
// Description		
//		Do own treatment when selected in inventory
//------------------------------------------------------------------------
function Select( EInventory Inv )
{
	Super.Select(Inv);

	PlaySound(Sound'Interface.Play_FisherEquipAutoRifle', SLOT_Interface);

	// Get secondary Ammo
	// if there's already one selected
	if( Inv.BackPackSecSelectedItem != None )
		Link(ESecondaryAmmo(Inv.BackPackSecSelectedItem));
}

function AddedToInventory()
{
	EPlayerController(Controller).TCheck(2, BulletsAccuracy);
	EPlayerController(Controller).MainGun = self;
	Super.AddedToInventory();
}

function bool NotifyPickup( Controller Instigator )
{
	local EPlayerController Epc;
	
	Super.NotifyPickup(Instigator);

	// Set as Player HandGun
	Epc = EPlayerController(Controller);
	Epc.ePawn.FullInventory.SetSelectedItem(self);
	Epc.SheathWeapon();
	
	return false;
}

//------------------------------------------------------------------------
// Description		
//		Link the maingun to its ammo
//------------------------------------------------------------------------
function Link( ESecondaryAmmo Ammo )
{
	SecondaryAmmo		= Ammo;

	if( Ammo != None )
		Ammo.OwnerGun = self;
}

function bool CanAddThisItem( EInventoryItem ItemToAdd )
{
	return ItemToAdd == self;
}

function Fire()
{
	Log(BulletsAccuracy);
	// Normal behavior
	if( BulletsAccuracy == -1 )
		Super.Fire();
	else if( BulletsAccuracy > 0 )
	{
		BulletsAccuracy--;
		Super.Fire();
	}
}

// ----------------------------------------------------------------------
// state s_Selected - Let's use the SecondaryAmmo .. only defined here in EMainGun
// ----------------------------------------------------------------------
state s_Selected
{
	function AltFire()
	{
		// no secondary fire in sniper mode
		if( bSniperMode )
			return;

		Super.AltFire();

		if( SecondaryAmmo != None )
		{
			// let's use the secondary ammo
			PlaySound(Sound'FisherEquipement.Play_FN2000Launch', SLOT_SFX);
			SecondaryAmmo.Use();
			Level.RumbleShake(0.06, 1.0);
		}
	}
}

// ----------------------------------------------------------------------
// state s_Inventory - Must keep this gun always Visible
// ----------------------------------------------------------------------
state s_Inventory
{
	function BeginState()
	{
		Super.BeginState();
		bHidden	= false;
	}
}

defaultproperties
{
    BulletsAccuracy=-1
    Category=CAT_MAINGUN
    bPickable=true
}