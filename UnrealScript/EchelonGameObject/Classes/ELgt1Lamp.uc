class ELgt1Lamp extends EGameplayObjectLight; 

defaultproperties
{
    bDestroyWhenDestructed=false
    HitPoints=1
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_lamp1B')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnOffset=(X=30.000000,Z=30.000000))
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_lamp1A'
    bIsProjectile=true
}