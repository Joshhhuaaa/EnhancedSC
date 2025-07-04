
class ELightCelling_green extends EGamePlayObjectLight;

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.UnbreakableLight.LIG_Celling_OFF'
    bDestroyWhenDestructed=false
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.UnbreakableLight.LIG_CellingB')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlobeLightSpark')
    HitSound(0)=Sound'DestroyableObjet.Play_MediumLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.UnbreakableLight.LIG_celling_green'
}