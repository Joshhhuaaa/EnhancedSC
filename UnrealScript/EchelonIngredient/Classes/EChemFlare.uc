class EChemFlare extends EInventoryItem;

var float	GlowTime;
var float	ScaleGlow;
var bool	Used;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_glowstick;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_glowstick;
    ItemName     = "ChemFlare";
	ItemVideoName = "gd_flare.bik";
    Description  = "ChemFlareDesc";
	HowToUseMe  = "ChemFlareHowToUseMe";
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	EndEvent();
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
		// Make sure to kill light if it's not thrown
		EndEvent();
		Super.BeginState();
	}
}

defaultproperties
{
    GlowTime=30.000000
    ScaleGlow=1.000000
    MaxQuantity=10
    bDynamicLight=true
    StaticMesh=StaticMesh'EMeshIngredient.Item.GreenStick'
    CollisionRadius=1.000000
    CollisionHeight=1.000000
    LightEffect=LE_EOmniAtten
    LightBrightness=153
    LightHue=26
    LightSaturation=59
    bGlowDisplay=false
    MinDistance=1.000000
    MaxDistance=50.000000
    bIsProjectile=true
    Mass=10.000000
}