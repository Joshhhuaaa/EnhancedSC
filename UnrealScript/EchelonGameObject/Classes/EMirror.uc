class EMirror extends EGamePlayObject;

defaultproperties
{
    bShatterable=true
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_Breack_Miror',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EMirrorspark',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_LittleWindowDestroyed'
    bDynamicLight=true
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_miror'
}