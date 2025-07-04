class ELgtburmalamp extends EGameplayObjectLight; 

defaultproperties
{
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_burmalampB')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.ESmallFire',SpawnOffset=(Z=-25.000000))
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_burmalamp'
    LightType=LT_Steady
    LightBrightness=116
    LightHue=25
    LightSaturation=180
    LightRadius=6
}