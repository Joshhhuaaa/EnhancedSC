class EVase_C extends EGamePlayObject;

defaultproperties
{
    bShatterable=true
    HitPoints=300
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_vase02b_chi',Percent=33.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_vase02c_chi',Percent=66.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EVase',SpawnAtDamagePercent=25.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EVase',SpawnAtDamagePercent=50.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EVase',SpawnAtDamagePercent=75.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EVase',SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_vase02_chi'
}