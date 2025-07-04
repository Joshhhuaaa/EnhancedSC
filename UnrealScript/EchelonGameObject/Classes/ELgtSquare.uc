class ELgtSquare extends EGameplayObjectLight;

defaultproperties
{
    bDestroyWhenDestructed=false
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_Spot_SQ_B')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EBreakingLightSpark')
    HitSound(0)=Sound'DestroyableObjet.Play_BigLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_Spot_SQ'
}