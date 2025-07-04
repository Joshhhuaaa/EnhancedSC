class EPorteMetal extends EGameplayObject; 

defaultproperties
{
    HitPoints=200
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_PorteB1',Percent=50.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_PorteB2',Percent=100.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EMirrorspark',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EGlasseScreen',SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_Porte'
}