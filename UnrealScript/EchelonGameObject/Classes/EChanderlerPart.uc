class EChanderlerPart extends EGamePlayObjectLight;

#exec OBJ LOAD FILE=..\textures\LightGenTex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\LightGenOBJ.usx

defaultproperties
{
    HitPoints=600
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_ChanderlerParts1B1')
    DamagedMeshes(1)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_ChanderlerParts1B2',Percent=20.000000)
    DamagedMeshes(2)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_ChanderlerParts1B3',Percent=40.000000)
    DamagedMeshes(3)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_ChanderlerParts1B4',Percent=60.000000)
    DamagedMeshes(4)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_ChanderlerParts1B5',Percent=80.000000)
    DamagedMeshes(5)=(StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_ChanderlerParts1B6',Percent=100.000000)
    SpawnableObjects(0)=(SpawnAlwaysOn=True,SpawnClass=Class'EchelonEffect.EChanderlerCrystalParticule',SpawnOnImpact=True)
    SpawnableObjects(5)=(SpawnClass=Class'EchelonEffect.EMirrorspark',SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_ChanderlerParts1B0'
}