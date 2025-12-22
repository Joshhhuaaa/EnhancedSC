class EChemFlare extends EInventoryItem;

var float	GlowTime;
var float	ScaleGlow;
var bool	Used;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	HeatIntensity = 0; // Joshua - Chem Flare will now generate heat

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_glowstick;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_glowstick;
    ItemName     = "ChemFlare";
	ItemVideoName = "gd_flare.bik";
    Description  = "ChemFlareDesc";
	HowToUseMe  = "ChemFlareHowToUseMe";
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	//EndEvent(); // Joshua - Chem Flare will no longer end when taking damage
	Super.TakeDamage(Damage, EventInstigator, HitLocation, HitNormal, Momentum, DamageType);
}

function bool NotifyPickup(Controller Instigator)
{
	// Try destroying Flarelight upon pickup if it exists
	EndEvent();
	return Super.NotifyPickup(Instigator);
}

function EndEvent()
{
	if (!Used)
		return;

	bGlowDisplay = false;
	GlowTime = 0;
	ScaleGlow = 0;
	LightType = LT_None;
	HeatIntensity = 0.0f; // Joshua - Chem Flare will now generate heat
}

function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (!Used || GlowTime <= 0)
		return;

	GlowTime -= DeltaTime;

	// Last second is fading the light/glow
	if (GlowTime > 1)
		return;

	ScaleGlow -= DeltaTime;
	LightBrightness = ScaleGlow * default.LightBrightness;

	if (ScaleGlow <= 0)
	{
		EndEvent();
		GotoState('s_Dying');
	}
}

state s_Selected
{
	function Use()
	{
		Super.Use();

		if (Used)
			return;

		Used = true;
		bGlowDisplay = true;
		
		// Joshua - Initialize GlowTime and ScaleGlow
		GlowTime = default.GlowTime; 
		ScaleGlow = default.ScaleGlow;
		
		HeatIntensity = default.HeatIntensity; // Joshua - Chem Flare will now generate heat

		if (Level.Game.PlayerC.ShadowMode == 0)
		{
			LightEffect = LE_None;
		}

		LightType = LT_Steady;

		// Use EGameplayObject::Throw CHANGE_Object
		Level.AddChange(self, CHANGE_Flare);
	}
}

state s_Inventory
{
	function BeginState()
	{
		// Joshua - Don't kill the flare if it's still within GlowTime, only stop the glow display from rendering in inventory
		if (Used && GlowTime > 0)
		{
			bGlowDisplay = false;
		}
		else
		{
			EndEvent();
		}
		Super.BeginState();
	}
}

defaultproperties
{
    GlowTime=30.000000
    ScaleGlow=1.000000
    MaxQuantity=10
    bDynamicLight=True
    StaticMesh=StaticMesh'EMeshIngredient.Item.GreenStick'
    CollisionRadius=1.000000
    CollisionHeight=1.000000
    LightEffect=LE_None //LE_EOmniAtten // Joshua - Xbox used LE_EOmniAtten, but it seems to cause rendering issues on PC
    LightBrightness=153
    LightHue=26
    LightSaturation=59
    bGlowDisplay=False
    MinDistance=1.000000
    MaxDistance=50.000000
	HeatIntensity=0.800000 // Joshua - Chem Flare will now generate heat
    bIsProjectile=True
    Mass=10.000000
}