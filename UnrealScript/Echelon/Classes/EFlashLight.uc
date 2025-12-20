class EFlashLight extends EGameplayObject;

#exec OBJ LOAD FILE=..\textures\ETexRenderer.utx 

function PostBeginPlay()
{
	Super.PostBeginPlay();

	ToggleLight(false);
}

function ToggleLight(bool bOn)
{
	UsesSpotLightBeam = bOn;
	if (bOn)
	{
		LightType = LT_Steady;
	}
	else
	{
		LightType = LT_None;
	}

	if (Level.Game.PlayerC.ShadowMode == 0)
	{
		LightEffect=LE_Spotlight;
	}
}

defaultproperties
{
    StaticMesh=StaticMesh'EMeshCharacter.spetsnaz.headset'
    bDontAffectEchelonLighting=True
    CollisionRadius=16.000000
    CollisionHeight=2.000000
    bCollideActors=False
    LightType=LT_Steady
    LightEffect=LE_ESpotShadowDistAtten
    LightBrightness=255
    LightHue=72
    LightSaturation=232
    LightRadius=80
    LightCone=20
    bInvalidateLightCachingIfMoved=True
    UsesSpotLightBeam=True
    VolumeInitialAlpha=10
    MinDistance=4.000000
    MaxDistance=1500.000000
    SpotHeight=2.500000
    SpotWidth=2.500000
}