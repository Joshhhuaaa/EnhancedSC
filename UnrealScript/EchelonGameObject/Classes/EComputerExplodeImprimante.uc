class EComputerExplodeImprimante extends EGameplayObject; 

defaultproperties
{
    bShatterable=True
    HitPoints=200
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_OFF_comp_printB1',Percent=50.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_OFF_comp_printB2',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ElightDarkSmoke',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EExplosionComputer',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EcameraEclats',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EFeuilleUp',SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_OFF_comp_print'
}