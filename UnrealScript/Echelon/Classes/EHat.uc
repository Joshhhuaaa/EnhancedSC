class EHat extends EGameplayObject;

function bool IsSolid()
{
	return StaticMesh.name == 'EliteHelmet' ||
		   StaticMesh.name == 'EliteHelmetGoggle' ||
		   StaticMesh.name == 'ProtectiveHat0' ||
		   StaticMesh.name == 'ProtectiveHat1' ||
		   StaticMesh.name == 'ProtectiveHat2';
}

function Setup()
{
	if (IsSolid())
	{
		bNPCBulletGoTru = false;
		bPlayerBulletGoTru = false;
		HeatOpacity += 0.3;
		bBlockProj = true;
	}
}

function StoppedMoving()
{
	SetCollision(false, false, false);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	// Play sound
	if (DamageType == None && (StaticMesh.name == 'EliteHelmet' || StaticMesh.name == 'EliteHelmetGoggle'))
		PlaySound(Sound'GunCommon.Play_BulletHitHelmet', SLOT_SFX);

	// Notify owner
	if (DamageType == None && ePawn(Owner) != None)
		ePawn(Owner).NotifyShotJustMissed(EventInstigator);

	// If hat is solid and on a head, don't make it fly
	if (IsSolid() && Owner != None)
		return;

	SetOwner(None);
	Velocity = Momentum;
	TakeHit();
	bBlockProj = false; // Won't block interaction
	SetCollision(true, false, false);

	// Making collision more accurante around helmet
	PrePivot.Z = 12;
	SetCollisionSize(7,7);
}

state s_Flying
{
	Ignores Bump;
}

defaultproperties
{
    bDamageable=False
    bNPCBulletGoTru=True
    bPlayerBulletGoTru=True
    CollisionRadius=10.000000
    CollisionHeight=15.000000
    bStaticMeshCylColl=False
    bBlockProj=False
    bBlockNPCVision=False
    HeatOpacity=0.200000
}