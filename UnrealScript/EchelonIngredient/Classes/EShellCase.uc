class EShellCase extends Projectile
	abstract
	notplaceable;

var bool bHasBounced;
var int numBounces;
var sound ShellSound;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (Level.bDropDetail)
	{
		bCollideWorld = false;
		LifeSpan = 1.5;
	}
}

function HitWall(vector HitNormal, actor Wall)
{
	local vector RealHitNormal;

	if (Level.bDropDetail)
	{
		Destroy();
		return;
	}
	if (bHasBounced && ((numBounces > 3) || (FRand() < 0.85) || (Velocity.Z > -50)))
		bBounce = false;
	numBounces++;
	if (numBounces > 3)
	{
		Destroy();
		return;
	}

	PlaySound(ShellSound, SLOT_SFX);

	RealHitNormal = HitNormal;
	HitNormal = Normal(HitNormal + 0.4 * VRand());
	if ((HitNormal Dot RealHitNormal) < 0)
		HitNormal *= -0.5; 
	Velocity = 0.5 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
	RandSpin(100000);
	bHasBounced = true;
}

function Landed(vector HitNormal)
{
	local rotator RandRot;

	if (Level.bDropDetail)
	{
		Destroy();
		return;
	}

	if (numBounces > 3)
	{
		Destroy();
		return;
	}
	
	SetPhysics(PHYS_None);
	RandRot = Rotation;
	RandRot.Pitch = 0;
	RandRot.Roll = 0;
	SetRotation(RandRot);
}

function Eject(Vector Vel)
{
	SetPhysics(PHYS_Falling);
	Velocity = Vel;
	RandSpin(100000);
}

defaultproperties
{
    MaxSpeed=1000.000000
    DrawType=DT_StaticMesh
    LifeSpan=30.000000 // Joshua - Incrased from 3.0 to 30.0 before despawning
    StopSoundsWhenKilled=True
    bCollideActors=False
    HeatIntensity=0.800000
    Mass=1.000000
    bBounce=True
    bFixedRotationDir=True
}