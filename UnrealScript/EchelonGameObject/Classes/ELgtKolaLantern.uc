class ELgtkolalantern extends EGameplayObjectLight;

defaultproperties
{
    bDestroyWhenDestructed=false
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_kolalanternB')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle')
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_kolalanternA'
}