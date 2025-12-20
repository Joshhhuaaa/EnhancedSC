class ELgttallspot extends EGameplayObjectLight;

defaultproperties
{
    bDestroyWhenDestructed=False
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_tallspotB')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EBreakingLightSpark')
    HitSound(0)=Sound'DestroyableObjet.Play_LittleWindowDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_tallspotA'
}