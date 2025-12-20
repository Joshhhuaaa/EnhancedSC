class EExtincteur extends EGameplayObject; 

defaultproperties
{
    bShatterable=True
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_Extincteur',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'Echelon.EExtincteurEmitter',SpawnOnImpact=True,SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_Extincteur'
    CollisionPrimitive=StaticMesh'EGO_OBJ.GenObjGO.GO_Extincteur_col'
    bStaticMeshCylColl=False
    bBlockBullet=False
    bCPBlockBullet=True
}