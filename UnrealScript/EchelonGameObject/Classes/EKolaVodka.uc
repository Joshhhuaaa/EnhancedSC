class EKolaVodka extends EGameplayObject; 

function ProcessDamage(int Damage, class<DamageType> DamageType, Vector HitLocation, Vector HitNormal)
{
	Super.ProcessDamage(Damage, DamageType, HitLocation, HitNormal);

	if (HitPoints <= 100)
	{
		bPickable = false;
		ResetInteraction();
	}
}

defaultproperties
{
    bPickable=true
    bPushable=true
    bShatterable=true
    HitPoints=300
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.Kola_ObjGO.GO_KolaVODKA3b',Percent=33.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.Kola_ObjGO.GO_KolaVODKA2b',Percent=66.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnAtDamagePercent=66.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnAtDamagePercent=33.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnAtDamagePercent=100.000000)
    ExplosionNoiseRadius=1500.000000
    HitSound(0)=Sound'ThrowObject.Play_Random_BottleBreak'
    BounceSound=Sound'ThrowObject.Play_Random_BottleImpact'
    bAcceptsProjectors=false
    StaticMesh=StaticMesh'EGO_OBJ.Kola_ObjGO.GO_KolaVODKA'
    SoundRadiusSaturation=450.000000
    CollisionRadius=5.000000
    CollisionHeight=5.000000
    bIsProjectile=true
    Mass=45.000000
}