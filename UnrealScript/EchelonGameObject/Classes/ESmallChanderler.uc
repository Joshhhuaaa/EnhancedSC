class ESmallChanderler extends EGamePlayObjectLight;

#exec OBJ LOAD FILE=..\textures\LightGenTex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\LightGenOBJ.usx

defaultproperties
{
    HitPoints=400
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_SmalLChanderlerB1',Percent=20.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_SmallChanderlerB2',Percent=40.000000)
    DamagedMeshes(2)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_SmallChanderlerB3',Percent=60.000000)
    DamagedMeshes(3)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_SmallChanderlerB4',Percent=80.000000)
    DamagedMeshes(4)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_SmallChanderlerB5',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EChanderlerCrystalParticule',SpawnAtDamagePercent=20.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EChanderlerCrystalParticule',SpawnAtDamagePercent=40.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EChanderlerCrystalParticule',SpawnAtDamagePercent=60.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EChanderlerCrystalParticule',SpawnAtDamagePercent=80.000000)
    SpawnableObjects(4)=(SpawnClass=Class'EchelonEffect.EChanderlerCrystalParticule',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(5)=(SpawnClass=Class'EchelonEffect.EMirrorspark',SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_SmallChanderlerB0'
    DrawScale=4.000000
}