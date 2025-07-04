class ELgt2Flurescent extends EGameplayObjectLight;

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_flurescent_2m_OFF'
    bDestroyWhenDestructed=false
    HitPoints=16
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_flurescent_2mB')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ENeonExplode',SpawnOffset=(Z=-115.000000),SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_flurescent_2m'
}