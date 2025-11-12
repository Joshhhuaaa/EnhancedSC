//================================================================================
// EHandLight.
//================================================================================

class EHandLight extends EGameplayObject;

var int DiminutionRate;

function TakeHit()
{
	GotoState('s_Rotating');
}

state s_Rotating
{
	function BeginState()
	{
		bBounce				= true;
		bCollideWorld		= true;
		SetPhysics(PHYS_Falling);
		bFixedRotationDir = true;
		RotationRate.Yaw = 100000 + 100000 * FRand();
		if (FRand() > 0.5)
			RotationRate.Yaw = -RotationRate.Yaw;
		DiminutionRate = 100000;
	}

	function TakeHit()
	{
		BeginState();
	}

	function HitWall(Vector HitNormal, Actor Wall)
	{
		local float Speed;
		local bool bPlayBounce;
		local EGameplayObject HitGo;
		local EVolume V;

		// Reflect on no-wall or pawn
		//	Velocity += Wall.Velocity;
		if (Wall == None || !Wall.bIsSoftBody)
			Velocity = 0.5 * ((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping //1+coef

		// Maybe not needed...
		if (VSize(Velocity) > 2000.0)
			Velocity = Normal(Velocity) * 2000.0;
		
		Speed = VSize(Velocity);

		// if pawn, will slow down on its reflected trajectory
		// if softbody, will slow down on its normal trajectory
		if (Wall != None && (Wall.bIsSoftBody || Wall.bIsPawn))
		{
			Velocity.X *= 0.2;
			Velocity.Y *= 0.2;
		}

		//RotationRate.Yaw = RotationRate.Yaw * 0.75;

		// Dont stop for SoftBody
		if (((speed < 60 && HitNormal.Z > 0.7) || !bBounce) && (Wall == None || !Wall.bIsSoftBody))
		{
			SetPhysics(PHYS_Rotating);
			bBounce = false;

			StoppedMoving();
		}
		else if (speed > 40) 
		{
			bPlayBounce = true;

			ForEach TouchingActors(class'EVolume',V)
			{
				if (V.bLiquid)
					bPlayBounce = false;
			}

			if (bPlayBounce && (Wall == None || !Wall.bIsSoftBody))
				PlaySound(BounceSound, SLOT_SFX);
		}

		if (HitNoiseRadius > 0)
		{			
			MakeNoise(HitNoiseRadius, NOISE_Object_Falling, 250.0f);
		}
	}


	function Landed(vector HitNormal)
	{
		SetPhysics(PHYS_Rotating);
	}

	function Tick(float DeltaTime)
	{
		RotationRate.Yaw = Clamp(RotationRate.Yaw, 0, RotationRate.Yaw - DiminutionRate * DeltaTime);
		if (RotationRate.Yaw <= 0)
		{
			SetPhysics(PHYS_None);
			GotoState('');
		}
	}
}

defaultproperties
{
    bDestroyWhenDestructed=False
    HitPoints=0
    bAcceptsProjectors=False
    StaticMesh=StaticMesh'EMeshIngredient.Item.FlashLight'
    DrawScale=2.000000
    bDontAffectEchelonLighting=True
    CollisionRadius=6.000000
    CollisionHeight=1.000000
    LightType=LT_Steady
    LightEffect=LE_ESpotShadowDistAtten
    LightBrightness=255
    LightHue=30
    LightSaturation=237
    bLightCachingValid=True
    UsesSpotLightBeam=True
    VolumeTotalFalloffScale=0.500000
    VolumeInitialAlpha=6
    TurnOffDistance=2000.000000
    MinDistance=2.000000
    SpotHeight=1.000000
    SpotWidth=1.000000
    Mass=60.000000
}
