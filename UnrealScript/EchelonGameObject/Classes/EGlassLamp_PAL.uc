class EGlassLamp_PAL extends EGameplayObjectLight; 

defaultproperties
{
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LGT_glasslamp_PAL01B',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlassLampEmit_PAL',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_MediumLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LGT_glasslamp_PAL00B'
}