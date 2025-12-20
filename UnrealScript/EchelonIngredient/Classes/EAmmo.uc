class EAmmo extends EInventoryItem;

var int		Ammo;

function EWeapon GetAmmoWeapon(EPlayerController Epc);

function bool NotifyPickup(Controller Instigator)
{
	local EPlayerController Epc;
	local int TransferedBullets;

	Epc = EPlayerController(Instigator);
	if (Epc == None || GetAmmoWeapon(Epc) == None)
	{
		Throw(Instigator, Vect(0,0,0));
		return false;
	}

	//Log("Was"@Ammo@GetAmmoWeapon(Epc).Ammo);

	// Check what's unused in the box
	TransferedBullets = GetAmmoWeapon(Epc).default.MaxAmmo - GetAmmoWeapon(Epc).Ammo;
	// Update weapon clip
	GetAmmoWeapon(Epc).Ammo = Min(GetAmmoWeapon(Epc).Ammo + Ammo, GetAmmoWeapon(Epc).default.MaxAmmo);
	// Update box qty
	Ammo -= TransferedBullets;
	
	//Log("Is"@Ammo@GetAmmoWeapon(Epc).Ammo);

	// Joshua - Improvement: Only show pickup message if ammo was transfered
	if (TransferedBullets > 0)
		Epc.SendTransmissionMessage(Localize("InventoryItem", ItemName, "Localization\\HUD") $ Localize("Transmission", "PickUp", "Localization\\HUD"), TR_INVENTORY);
	

	if (Ammo <= 0)
		Destroy();
	else
	{
		// Joshua - Improvement: Only show pickup message if ammo was transfered
		EPC.SendTransmissionMessage(Localize("Transmission", "NoPickUp", "Localization\\HUD") $ Localize("InventoryItem", ItemName, "Localization\\HUD"), TR_INVENTORY);
		Throw(Instigator, Vect(0,0,0));
	}

	return true; // no go in hand
}

function ProcessUseItem();

defaultproperties
{
    bStaticMeshCylColl=False
}