class ELgt1Flurescent extends EGameplayObjectLight;

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_Flurescent_1m_OFF'
    bDestroyWhenDestructed=False
    HitPoints=16
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_flurescent_1mB')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ENeonExplode',SpawnOffset=(Z=-115.000000),SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_MediumLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_flurescent_1m'
    bStaticMeshCylColl=False
}