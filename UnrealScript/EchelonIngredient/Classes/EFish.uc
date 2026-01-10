class EFish extends EGameplayObject;

#exec OBJ LOAD FILE=..\textures\ETexIngredient.utx
#exec OBJ LOAD FILE=..\Animations\ESkelIngredients.ukx

function rotator GetStillRotation(vector HitNormal)
{
	return FindSlopeRotation(HitNormal, Rotation);
}

function StoppedMoving()
{
	Super.StoppedMoving();

	SetTimer(FRand() * 25.f,false);
}

function Timer()
{
	GotoState('');
	PlayAnim('dead');
}

auto state s_Swimming
{
	Ignores Timer;

	function BeginState()
	{
		LoopAnim('swim');
		SetCollisionSize(default.CollisionRadius, 12 * DrawScale);
	}

	function Bump(Actor Other, optional int Pill)
	{
		if (Base == None || Other != Owner)
			return;

		SetBase(None);
	}
}

state s_Flying
{
	function BeginState()
	{
		local vector FishVel;
		FishVel.X = (FRand() - 0.5f) * 250;
		FishVel.Y = (FRand() - 0.5f) * 250;
		Velocity = FishVel;

		SetCollisionSize(default.CollisionRadius, default.CollisionHeight);

		AnimEnd(0);

		Super.BeginState();

		bFixedRotationDir	= false;
		SetRotation(Rot(0,0,0));
	}

	function AnimEnd(int Channel)
	{
		PlayAnim('flip', FRand() * 2.f, 0.1);
	}
}

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'ESkelIngredients.fishMesh'
    CollisionRadius=2.000000
    CollisionHeight=5.000000
    bCollideWorld=True
    bBlockProj=False
    bBlockNPCVision=False
    bBlockPeeking=False
    HeatIntensity=0.800000
    bIsSoftBody=True
}