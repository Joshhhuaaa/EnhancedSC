class ELgtGlobe3_yellow extends EGameplayObjectLight; 

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_globe3_OFF'
    bDestroyWhenDestructed=False
    HitPoints=8
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_globe3b')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlobeLightSpark')
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_globe3'
}