class ECompSony extends EComputerSystem;

#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

defaultproperties
{
    bShatterable=True
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_Tour2b2',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EcameraEclats',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.ElightDarkSmoke',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EExplosionComputer',SpawnOffset=(Z=15.000000),SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_ComputerDestroyed'
    StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_CompSony'
}