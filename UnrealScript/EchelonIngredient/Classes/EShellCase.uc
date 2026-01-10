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
	else
	{
		// Joshua - Remove shell cases when MAX_SHELL_CASES is reached (oldest first), not by lifespan
		AddShellCaseToLevel();
		LifeSpan = 0;
	}
}

// Joshua - Add shell case to level tracking
function AddShellCaseToLevel()
{
	local EchelonLevelInfo eLevel;
	local Projectile OldestShell;

	eLevel = EchelonLevelInfo(Level);

	if (eLevel != None)
	{
		// If we're at capacity, destroy the oldest shell case
		if (eLevel.AllShellCases.Length >= eLevel.MAX_SHELL_CASES)
		{
			OldestShell = eLevel.AllShellCases[0];
			eLevel.AllShellCases.Remove(0, 1);

			if (OldestShell != None)
				OldestShell.Destroy();
		}

		eLevel.AllShellCases[eLevel.AllShellCases.Length] = self;
	}
}

// Joshua - Remove shell case from level tracking when destroyed
function Destroyed()
{
	local EchelonLevelInfo eLevel;
	local int i;

	eLevel = EchelonLevelInfo(Level);

	// Find and remove this shell case from the tracking array
	for (i = 0; i < eLevel.AllShellCases.Length; i++)
	{
		if (eLevel.AllShellCases[i] == self)
		{
			eLevel.AllShellCases.Remove(i, 1);
			break;
		}
	}

	Super.Destroyed();
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
    LifeSpan=3.000000
    StopSoundsWhenKilled=True
    bCollideActors=False
    HeatIntensity=0.800000
    Mass=1.000000
    bBounce=True
    bFixedRotationDir=True
}