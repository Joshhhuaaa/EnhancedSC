class EThermalMine extends EGameplayObject;

var() float GrowModifier;
var() float Delay;
var() float DetectionRadius;
var Emitter ThermalEmitter;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// set radius like heat radius
	SetCollisionSize(DetectionRadius, CollisionHeight);
	HeatRadius = DetectionRadius;
}

function Destructed()
{
	Super.Destructed();
	GotoState('');
}

auto state s_Emitting
{
	function BeginState()
	{
		HeatIntensity = 0;
		GrowModifier  = Abs(GrowModifier);
		SetTimer(Delay, false);
		ThermalEmitter = spawn(class'Echelon.EThermalMineEmitter', self);
	}

	function EndState()
	{
		HeatIntensity = 0;
		ThermalEmitter.Destroy();
	}

	function Timer()
	{
		Enable('Tick');
	}

	function Tick(float DeltaTime)
	{
		if (HeatIntensity + DeltaTime * GrowModifier > default.HeatIntensity && GrowModifier > 0)
		{
			GrowModifier = -Abs(GrowModifier);
			HeatIntensity = default.HeatIntensity;
			return;
		}
		else if (HeatIntensity + DeltaTime * GrowModifier < 0 && GrowModifier < 0)
		{
			GrowModifier = Abs(GrowModifier);
			HeatIntensity = 0;

			// When down to 0, set timer
			if (Delay > 0)
			{
				Disable('Tick');
				SetTimer(Delay, false);
			}

			return;
		}

		// adjust heat intensity
		HeatIntensity += DeltaTime * GrowModifier;
	}

	function Touch(Actor Other)
	{
		if (Other.bIsPawn)
			DestroyObject();
	}
}

defaultproperties
{
    GrowModifier=0.350000
    DetectionRadius=250.000000
    bExplodeWhenDestructed=True
    ExplosionClass=Class'EchelonEffect.EMineExplosion'
    ExplosionDamageClass=Class'Engine.Crushed'
    bHidden=True
    StaticMesh=StaticMesh'EMeshIngredient.Item.FragGrenade'
    DrawScale3D=(X=3.000000,Y=3.000000,Z=0.500000)
    bBlockProj=False
    LightType=LT_Steady
    HeatIntensity=1.000000
    bIsTouchable=True
}