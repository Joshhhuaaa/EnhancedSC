class EMicroWaveA extends EGameplayObject;

#exec OBJ LOAD FILE=..\StaticMeshes\EGO_OBJ.usx

defaultproperties
{
    bShatterable=True
    HitPoints=400
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_MicroWave01B',Percent=25.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_MicroWave02B',Percent=50.000000)
    DamagedMeshes(2)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_MicroWave03B',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnAtDamagePercent=25.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnAtDamagePercent=50.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EGlasseScreen',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_LittleWindowDestroyed'
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_MicroWave00B'
}