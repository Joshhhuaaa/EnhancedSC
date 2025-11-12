//=============================================================================
// Projectile.
//
// A delayed-hit projectile that moves around for some time after it is created.
//=============================================================================
class Projectile extends Actor
	abstract
	native;

//-----------------------------------------------------------------------------
// Projectile variables.

// Motion information.
var		float   Speed;               // Initial speed of projectile.
var		float   MaxSpeed;            // Limit on speed of projectile (0 means no limit)
var		float	TossZ;

// Damage attributes.
var   float    Damage; 
var	  float	   DamageRadius;        
var   float	   MomentumTransfer; // Momentum magnitude imparted by impacting projectile.
var   class<DamageType>	   MyDamageType;

// Projectile sound effects
var   sound    SpawnSound;		// Sound made when projectile is spawned.
var   sound	   ImpactSound;		// Sound made when projectile hits something.

// explosion effects
var   class<Projector> ExplosionDecal;
var   float		ExploWallOut;	// distance to move explosions out from wall

//==============
// Encroachment
function bool EncroachingOn(actor Other)
{
	if ((Other.Brush != None) || (Brush(Other) != None))
		return true;
		
	return false;
}

//==============
// Touching
singular function Touch(Actor Other)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, VelDir;
	local bool bBeyondOther;
	local float BackDist, DirZ;

	if ((Other.bBlockActors && Other.bBlockPlayers))
	{
		if (Velocity == vect(0,0,0))
		{
			ProcessTouch(Other,Location);
			return;
		}
		
		//get exact hitlocation - trace back along velocity vector
		bBeyondOther = ((Velocity Dot (Location - Other.Location)) > 0);
		VelDir = Normal(Velocity);
		DirZ = sqrt(VelDir.Z);
		BackDist = Other.CollisionRadius * (1 - DirZ) + Other.CollisionHeight * DirZ;
		if (bBeyondOther)
			BackDist += VSize(Location - Other.Location);
		else
			BackDist -= VSize(Location - Other.Location);

	 	HitActor = Trace(HitLocation, HitNormal, Location, Location - 1.1 * BackDist * VelDir, true);
		if (HitActor == Other)
			ProcessTouch(Other, HitLocation); 
		else if (bBeyondOther)
			ProcessTouch(Other, Other.Location - Other.CollisionRadius * VelDir);
		else
			ProcessTouch(Other, Location);
	}
}

function ProcessTouch(Actor Other, Vector HitLocation)
{
	if (Other != Instigator)
		Explode(HitLocation,Normal(HitLocation - Other.Location));
}

function HitWall (vector HitNormal, actor Wall)
{
	if (Mover(Wall) != None)
		Wall.TakeDamage(Damage, instigator, Location, HitNormal, MomentumTransfer * Normal(Velocity), MyDamageType);

	//MakeNoise(1.0);   UBI MODIF DAK ECHELON - removing obsolete calls

	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	if ((ExplosionDecal != None))
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

static function vector GetTossVelocity(Pawn P, Rotator R)
{
	local vector V;

	V = Vector(R);
	V *= ((P.Velocity Dot V) * 0.4 + Default.Speed);
	V.Z += Default.TossZ;
	return V;
}

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dkalina (9 Apr 2001)
// * Purpose : So Weapon can always send an Eject() message .. maybe not necessary
// * but it simplifies things for the time being
// ***********************************************************************************************
function Eject(Vector Vel);
// ***********************************************************************************************
// * END UBI MODIF 
// * dkalina (9 Apr 2001)
// ***********************************************************************************************

defaultproperties
{
    MaxSpeed=2000.000000
    TossZ=100.000000
    DamageRadius=220.000000
    MyDamageType=Class'DamageType'
    Physics=PHYS_Projectile
    DrawType=DT_Mesh
    LifeSpan=140.000000
    Texture=Texture'S_Camera'
    CollisionRadius=0.000000
    CollisionHeight=0.000000
    bCollideActors=true
    bCollideWorld=true
}