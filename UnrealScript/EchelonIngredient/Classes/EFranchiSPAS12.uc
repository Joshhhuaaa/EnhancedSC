class EFranchiSPAS12 extends ETwoHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

var int		NbFrags;		// Nb bullets when firing
var int		SpreadDegree;	// Spread cone

function TraceFire()
{
	local Actor HitActor, ASpark;
	local Rotator AdjustedAim;
	local vector HitLocation, HitNormal, StartTrace, EndTrace, ModifiedEndTrace, ShotDirection;
	local int i, PillTag;
	local Material HitMaterial;
	local EWallHit Spark;
	local Rotator projRot;

	if (Controller == None)
		Log("WEAPON WARNING : TraceFire() has no Controller Owner");

	MakeNoise(FireNoiseRadius, NOISE_Gunfire);

	// get basic start and end positions
	StartTrace	= GetFireStart();
	EndTrace = StartTrace + Controller.AdjustTarget(GetFireEnd() - StartTrace);	
	ShotDirection = Normal(EndTrace - StartTrace);

	for (i = 0; i < NbFrags; i++)
	{
		EndTrace = StartTrace + ShootingRange * GetVectorFrom(Rotator(ShotDirection), SpreadDegree);

		HitActor = Controller.Pawn.TraceBone(PillTag, HitLocation, HitNormal, EndTrace, StartTrace, HitMaterial, true);
		//Log("Hitting"@HitActor@"on bone"@PillTag);

		// Be sure that the intention of the NPC is not to shoot another NPC
		if (!Controller.bIsPlayer && EAIController(Controller).TargetActorToFire != HitActor)
			HitActor = None;
		
		if (HitActor == none)
			continue;

		SpawnWallHit(HitActor, HitLocation, HitNormal, HitMaterial);
		
		if (HitActor != self && HitActor != Controller.Pawn && !HitActor.bWorldGeometry) 
			HitActor.TakeDamage(BaseDamage, Controller.Pawn, HitLocation, HitNormal, Normal(HitLocation - GetFireStart()) * BaseMomentum, None, PillTag);
	}
}

event bool IsROFModeAvailable(ERateOfFireMode rof)
{
	switch (rof)
	{
	case ROF_Single : 
		return true;
	case ROF_Burst : 
	case ROF_Auto :	
		return false;
	}
}

defaultproperties
{
    NbFrags=15
    SpreadDegree=10
    Ammo=20
    MaxAmmo=20
    ClipAmmo=8
    ClipMaxAmmo=8
    RateOfFire=0.750000
    BaseDamage=25
    BaseMomentum=40000
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_SP12SingleShot'
    ReloadSound=Sound'Gun.Play_SP12Reload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    ShootingRange=1500
    NPCPreferredDistance=1000
    EjectedClass=Class'EShellCaseSG'
    EjectedOffset=(X=14.861800,Y=1.505800,Z=8.530100)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=69.000000,Y=0.000000,Z=9.000000)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.spas'
}