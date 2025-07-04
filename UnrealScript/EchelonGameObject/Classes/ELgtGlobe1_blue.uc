class ELgtGlobe1_blue extends EGameplayObjectLight;

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_globe1_OFF'
    bDestroyWhenDestructed=false
    HitPoints=8
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_globe1B')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlobeLightSpark')
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_globe1_blue'
}