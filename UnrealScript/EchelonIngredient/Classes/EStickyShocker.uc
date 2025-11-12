class EStickyShocker extends ESecondaryAmmo;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

var float fWaterPlanZ;

/*-----------------------------------------------------------------------------
    Function :      PostBeginPlay

    Description:    -
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
	Super.PostBeginPlay();
    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_stickyshocker;
    HUDTexSD     = EchelonLevelInfo(Level).TICON.qi_ic_stickyshocker_sd;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_stickyshocker;
    ItemName     = "StickyShocker";
	ItemVideoName = "gd_sticky_shocker.bik";
    Description  = "StickyShockerDesc";
	HowToUseMe  = "StickyShockerHowToUseMe";
}

state s_Flying
{
	function Touch(Actor Other)
	{
		local EPawn				P;
		local EVolume			Volume;	
		local EVolumeTrigger	VolumeTrigger;

		// While EVolumeTrigger is not a volume
		Volume			= EVolume(Other);
		VolumeTrigger	= EVolumeTrigger(Other);

		fWaterPlanZ = -1.f;

		if ((VolumeTrigger != None && VolumeTrigger.bLiquid) ||
			(Volume != None && Volume.bLiquid))
		{
			fWaterPlanZ = Location.Z;

			ForEach Other.TouchingActors(class'EPawn', P)
			{
				// Electrocute only within 6 meters
				if (VSize(P.Location - Location) < 600)
				ElectocutePawn(P);
			}

			PlaySound(Sound'FisherEquipement.Play_FN2000StickyShocker', SLOT_SFX);
		}

		Super.Touch(Other);
	}

	function Bump(Actor Other, optional int Pill)
	{
		// don't hit shooter but can do damage on anything else ...
		if (Other == Controller.Pawn)
			return;

		if (Other.bIsPawn)
		{
			PlaySound(Sound'FisherEquipement.Play_FN2000StickyShocker', SLOT_SFX);
			ElectocutePawn(Other);
		}
		else
			Super.Bump(Other, Pill);
	}

	function ElectocutePawn(Actor Other)
	{
		local int		damage;
		local Vector	Pos;

		StoppedMoving();

		if (EPawn(Other) != None && EPawn(Other).bIsPlayerPawn)
			return;

		if (EPawn(Other) != None)
			damage = Pawn(Other).Health / 2;
		else
			damage = 4;

		Other.TakeDamage(damage, Controller.Pawn, Location, Velocity, Velocity, class'EElectrocuted');

		if (fWaterPlanZ != -1.f)
		{
			Pos = Other.Location;
			Pos.Z = fWaterPlanZ;
			spawn(class'ELiquidElectricity', self,,Pos);
		}
	}

	function StoppedMoving()
	{
		Destroy();
	}
}

function Select(EInventory Inv)
{
	Super.Select(Inv);
	PlaySound(Sound'Interface.Play_FisherEquipSpMunition', SLOT_Interface);
}

defaultproperties
{
    MaxQuantity=5
    StaticMesh=StaticMesh'EMeshIngredient.Item.StickyShocker'
    CollisionRadius=4.000000
    CollisionHeight=2.000000
}