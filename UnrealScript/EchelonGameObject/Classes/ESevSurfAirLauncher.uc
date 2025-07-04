class ESevSurfAirLauncher extends EGameplayObjectPattern;

defaultproperties
{
    HitPoints=200
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.SEV_ObjGO.GO_SurfAirMiss00B',Percent=50.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.SEV_ObjGO.GO_SurfAirMiss01B',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ESurfAirMissPropulsion',SpawnOffset=(X=-70.000000,Y=-78.000000,Z=38.000000),SpawnAtDamagePercent=50.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.ESurfAirMissPropulsion',SpawnOffset=(X=-70.000000,Y=78.000000,Z=38.000000),SpawnAtDamagePercent=50.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EExplosion',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(4)=(SpawnClass=Class'EchelonEffect.ESurfAirMissExplosion',SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'EGO_OBJ.SEV_ObjGO.GO_SurfAirMiss00B'
}