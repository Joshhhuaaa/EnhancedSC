class EExtincteur extends EGameplayObject; 

defaultproperties
{
    bShatterable=true
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_Extincteur',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'Echelon.EExtincteurEmitter',SpawnOnImpact=True,SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_Extincteur'
    CollisionPrimitive=StaticMesh'EGO_OBJ.GenObjGO.GO_Extincteur_col'
    bStaticMeshCylColl=false
    bBlockBullet=false
    bCPBlockBullet=true
}