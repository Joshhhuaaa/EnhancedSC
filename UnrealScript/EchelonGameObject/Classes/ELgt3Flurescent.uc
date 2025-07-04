class ELgt3Flurescent extends EGameplayObjectLight; 

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.breakablelight.Fluo3_off'
    HitPoints=16
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.Fluo_3b',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ENeonExplode',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_MediumLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.Fluo_3a'
}