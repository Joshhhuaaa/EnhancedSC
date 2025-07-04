class ELgtSpot extends EGameplayObjectLight;

defaultproperties
{
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.Lig_Spot_brk',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlobeLightSpark',SpawnOffset=(Z=-80.000000))
    HitSound(0)=Sound'DestroyableObjet.Play_LittleWindowDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.UnbreakableLight.Lig_Spot2_RD'
}