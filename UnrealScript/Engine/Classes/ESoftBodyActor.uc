class ESoftBodyActor extends Actor native;

struct SBAttachment
{
	var()	actor	AttachedActor;
	var()	int		Hook;
	var()	int		TargetX;
	var()	int		TargetZ;
};

var notextexport ESoftBody SoftBody;

var(SoftBody) array<SBAttachment> Attach;
var(SoftBody) array<plane> collPlanes;
var(SoftBody) array<RangeVector> collBoxes;
var(SoftBody) array<plane> collSpheres;
var(SoftBody) vector Gravity;
var(SoftBody) vector windMin;
var(SoftBody) vector windMax;
var(SoftBody) float windUScale;
var(SoftBody) float windVScale;
var(SoftBody) float windUPan;
var(SoftBody) float windVPan;
var(SoftBody) float friction;
var(SoftBody) float collRepulse;
var(SoftBody) float dragForce;
var(SoftBody) float hitDamping;
var(SoftBody) int	nbIter;
var(SoftBody) int	nbNormalizeIter;
var(SoftBody) int	collSubDiv;
var(SoftBody) bool  collActor;
var(SoftBody) bool  attachPreferX;
var(SoftBody) bool  attachFlipZ;
var bool  pillsTest;

native(1137) final function SBBulletHit(vector Momentum);
native(1138) final function SBExplosionHit(vector Center, vector Momentum);
native(1164) final function RemoveAttach(actor attach);

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	if (DamageType == class'Crushed')
		SBExplosionHit(HitLocation, Momentum);
	else
		SBBulletHit(Momentum);
}

function BulletWentTru(Actor Instigator, vector HitLocation, vector HitNormal, vector Momentum, Material HitMaterial)
{
	SBBulletHit(Momentum);
}

event CollidedBy(Actor Instigator)
{
}

event Detach(Actor Other)
{
	RemoveAttach(Other);
}

defaultproperties
{
    Gravity=(X=0.000000,Y=0.000000,Z=-980.000000)
    dragForce=60.000000
    hitDamping=1.000000
    nbIter=1
    nbNormalizeIter=1
    CollisionRadius=1.000000
    CollisionHeight=1.000000
    bCollideActors=True
    bBlockProj=True
    bBlockBullet=True
    bIsSoftBody=True
    bIsTouchable=False
    bIsNPCRelevant=False
    bIsPlayerRelevant=False
    bEdShouldSnap=True
}