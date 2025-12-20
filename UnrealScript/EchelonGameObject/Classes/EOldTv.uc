class EOldTv extends EGamePlayObjectLight;

defaultproperties
{
    bDestroyWhenDestructed=False
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_OLDTVb',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EBreakingLightSpark',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EExplosionComputer',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_ScreenDestroyed'
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_OldTV'
    bIsProjectile=True
}