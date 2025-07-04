class ELgtBodySpot extends EGameplayObjectLight;

defaultproperties
{
    OffMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_bodyspot_OFF'
    HitPoints=60
    HitSound(0)=Sound'DestroyableObjet.Play_LittleLightDestroyed'
    StaticMesh=StaticMesh'LightGenOBJ.breakablelight.LIG_BodySpot'
    LightType=LT_Steady
    LightEffect=LE_ESpotShadowDistAtten
    LightBrightness=200
    LightHue=50
    LightSaturation=225
}