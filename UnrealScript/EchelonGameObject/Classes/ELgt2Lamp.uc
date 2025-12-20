class ELgt2Lamp extends EGameplayObjectLight;

defaultproperties
{
    bDestroyWhenDestructed=False
    HitPoints=1
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_lamp2B')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnOffset=(X=30.000000,Z=30.000000))
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_lamp2A'
    bIsProjectile=True
}