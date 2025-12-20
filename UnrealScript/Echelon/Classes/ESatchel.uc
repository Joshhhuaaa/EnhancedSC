class ESatchel extends EGameplayObject
	notplaceable;

var EPawn Holder;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Holder = EPawn(Owner);
	if (Holder == None)
		Log(self$" ERROR: Satchel owner should be an EPawn.");
	else
		Holder.AttachToBone(self, 'SatchelBone');
}

function bool NotifyPickup(Controller Instigator)
{
	local array<EMemoryStick>	FoundMems;
	local EInventoryItem		item;
	local int					i;
	local bool					bFound, bNotEmpty;

	// Should not happen
	if (Holder == None)
		return false;

	// Distribute items to Instigator
	for (i = 0; i < Holder.SatchelItems.Length; i++)
	{
		if (Holder.SatchelItems[i] != None)
		{
			bFound = true;

			item = Spawn(Holder.SatchelItems[i], Instigator);
			if (EPawn(Instigator.Pawn).FullInventory.CanAddItem(item))
			{
				item.NotifyPickup(Instigator);
				// General msg already in notify pickup
				//if (Instigator.bIsPlayer)
				//	EPlayerController(Instigator).SendTransmissionMessage(item.ItemName $ Localize("Transmission", "SatchelFind", "Localization\\HUD"), TR_INVENTORY);

				Holder.SatchelItems[i] = None;
			}
			else
			{
				bNotEmpty = true;

				if (Instigator.bIsPlayer)
					EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "NoPickUp", "Localization\\HUD") $ Localize("InventoryItem", Item.ItemName, "Localization\\HUD"), TR_INVENTORY);

				item.Destroy();
			}
		}
	}

	// Look for mem stick
	if (EchelonLevelInfo(Level).GetMemoryStick(FoundMems, Holder))
	{
		for (i = 0; i < FoundMems.Length; i++)
		{
			bFound = true;
			Log("Adding memory information in "$Instigator.Pawn$"'s Inventory.");
			FoundMems[i].NotifyPickup(Instigator);
		}

		if (EPlayerController(Instigator) != None)
			EPlayerController(Instigator).SendTransmissionMessage(Localize("GameplayObject", string(FoundMems[0].ObjectName), "Localization\\HUD") $ 
																  Localize("Transmission", "SatchelFind", "Localization\\HUD"), 
																  TR_INVENTORY);
	}

	if (!bFound)
		Log(self$" ERROR :  Satchel containing nothing");

	// if not empty, assuming already in Flying
	if (bNotEmpty)
		Throw(Instigator, Vect(0,0,0));
	else
		Destroy();

	return true; // no go in hand
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	if (EventInstigator == Owner) // dont fly off if shot by owner
		return;

	SetOwner(None);
	GotoState('s_Flying');

	if (damageType == none)
		PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);

	MakeNoise(200, NOISE_Ricochet);
}

function StoppedMoving()
{
	// flag this before the Super:: call
	bPickable = true;
	// Set pickup interaction
	Super.StoppedMoving();
	// Set satchel priority to less than Npc interaction priority
	if (Interaction != None && Holder != None && Holder.Interaction != None)
		Interaction.SetPriority(Holder.Interaction.iPriority - 1);
}

state s_Flying
{
	function BeginState()
	{
		bAcceptsProjectors = true;
		Super.BeginState();
		SetCollision(true, false, false);
	}
}

defaultproperties
{
    ObjectName="Satchel"
    bDamageable=False
    bAcceptsProjectors=False
    StaticMesh=StaticMesh'EMeshIngredient.Object.Satchel'
    bNPCBulletGoTru=True
    CollisionRadius=5.000000
    CollisionHeight=7.000000
    bStaticMeshCylColl=False
    bBlockProj=False
    bBlockNPCVision=False
}