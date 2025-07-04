class ELgt4Flurescent extends EGameplayObjectLight; 

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.UnbreakableLight.LIG_flurescent_3_OFF'
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.UnbreakableLight.LIG_flurescent_3mb',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ENeonExplode',SpawnOffset=(Z=-120.000000),SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.UnbreakableLight.LIG_flurescent_3m'
}