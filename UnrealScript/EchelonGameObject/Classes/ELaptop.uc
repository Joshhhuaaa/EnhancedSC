class ELaptop extends EGameplayObject;

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	Super.TakeDamage(Damage, EventInstigator, HitLocation, HitNormal, Momentum, DamageType, PillTag);

	if (!bDamageable)
		return;

	// Stop ambient sound at first damage
	if (StaticMesh != default.StaticMesh)
	{
		// Remove interaction
		ResetInteraction();

		PlaySound(AmbientStopSound, SLOT_SFX);
	}
}

// Joshua - Always remove interaction when laptop is destroyed, this handles cases where ProcessDamage is called directly (bShatterable objects)
event Destructed()
{
	ResetInteraction();
	SetCollision(false, false, false); // Joshua - Disable collision when destroyed
	Super.Destructed();
}

defaultproperties
{
    bShatterable=True
    HitPoints=400
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_laptop_00B',Percent=25.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_laptop_01B',Percent=50.000000)
    DamagedMeshes(2)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_laptop_03B',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ELaptopEmitter',SpawnAtDamagePercent=25.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.ElightDarkSmoke',SpawnAtDamagePercent=25.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.ELaptopEmitter',SpawnAtDamagePercent=50.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.ElightDarkSmoke',SpawnAtDamagePercent=50.000000)
    SpawnableObjects(4)=(SpawnClass=Class'EchelonEffect.ELaptopEmitter',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_CameraDestroyed'
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_laptop'
}