class ELgtcellingTBI extends EGameplayObjectLight;

defaultproperties
{
    bDestroyWhenDestructed=false
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.TBI_cellingB')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlobeLightSpark')
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.TBI_cellingON'
}