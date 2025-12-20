class ETurret extends ESensor;

#exec OBJ LOAD FILE=..\Animations\ESkelIngredients.ukx

// Aim at chest
function float GetHeightFactor()
{
	return 0.0;
}

// Premisse .. Target is a pawn
function bool ProcessDetectedPawn()
{
	return EPawn(Target).Health <= 0;
}

function SpawnShellCase()
{
	local Projectile s;
	local vector ejectVel, ejectLoc;
	local rotator ejectRot;
	local Coords boneCoords;

	boneCoords = GetBoneCoords(HeadBone);
	ejectLoc = boneCoords.Origin + (35.0f * boneCoords.ZAxis);
	ejectRot = Rotator(boneCoords.XAxis);

	s = Spawn(class'EShellCaseTurret', self, , ejectLoc, ejectRot);	
	if (s != None)
	{
		ejectVel = boneCoords.YAxis * (150.0 + (FRand() * 40.0 - 20.0));
		s.Eject(ejectVel);
	}
}

defaultproperties
{
    PatrolSpeed=8
    RotationVelocity=6000
    SensorType=DETECT_Heat
    SensorThreshold=0.010000
    SensorDetectionType=SCAN_AllChangedActors
    FollowUponDetection=True
    ShootUponDetection=True
    BulletsPerMinute=180.000000
    BulletDamage=100
    SoundAlert=Sound'Gun.Play_TurretDetection'
    SoundFire=Sound'Gun.Play_TurretInfiniteShot'
    SoundFire_End=Sound'Gun.StopGo_TurretShotEnd'
    SoundReverse=Sound'Gun.Play_TurretScanSwitch'
    SoundDisable=Sound'Gun.StopGo_TurretDisable'
    bDamageable=False
    Mesh=SkeletalMesh'ESkelIngredients.m249Mesh'
    CollisionRadius=30.000000
    CollisionHeight=60.000000
    bBlockProj=False
    bBlockBullet=False
    bBlockNPCVision=False
}