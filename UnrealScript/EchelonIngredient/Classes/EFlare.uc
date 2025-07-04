class EFlare extends EInventoryItem
	native;

var		float			LifeTime;
var		bool			BurnedUp;
var		EFlareParticle	FlareLight;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// manage quantity
	if( Quantity == 1 )
		SetStaticMesh(StaticMesh'EMeshIngredient.Item.Flare');
	else if( Quantity <= 5 )
		SetStaticMesh(StaticMesh'EMeshIngredient.Item.FlarePack_5');
	else
		SetStaticMesh(StaticMesh'EMeshIngredient.Item.FlarePack_10');

	HeatIntensity = 0;

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_flare;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_flares;
    ItemName     = "Flare";
	ItemVideoName = "gd_flare.bik";
    Description  = "FlareDesc";
	HowToUseMe  = "FlareHowToUseMe";
}

function bool NotifyPickup( Controller Instigator )
{
	// Try destroying Flarelight upon pickup if it exists
	EndEvent();
	return Super.NotifyPickup(Instigator);
}

function EndEvent()
{
	if( FlareLight == None )
		return;

	FlareLight.Kill();
	FlareLight = None;

	HeatIntensity = 0.0f;
	PlaySound(Sound'FisherEquipement.Stop_FlareBurn', SLOT_SFX);
}

state s_Selected
{
	function Use()
	{
		Super.Use();

		if( BurnedUp )
			return;

		FlareLight = spawn(class'EFlareParticle', self);
		FlareLight.SetLifeTime(LifeTime);

		HeatIntensity = default.HeatIntensity;
		BurnedUp = true;

		PlaySound(Sound'FisherEquipement.Play_FlareBurn', SLOT_SFX);

		// Use EGameplayObject::Throw CHANGE_Object
		Level.AddChange(self, CHANGE_Flare);
	}
}

state s_Inventory
{
	function BeginState()
	{
		// Make sure to kill particles if it's not thrown
		EndEvent();
		Super.BeginState();
	}
}

defaultproperties
{
    Lifetime=10.000000
    MaxQuantity=10
    HitNoiseRadius=500.000000
    StaticMesh=StaticMesh'EMeshIngredient.Item.Flare'
    CollisionRadius=2.000000
    CollisionHeight=2.000000
    HeatIntensity=0.800000
    bIsProjectile=true
    Mass=15.000000
}