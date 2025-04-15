//=============================================================================
// The light class.
//=============================================================================
class Light extends Actor
	placeable
	native;

#exec Texture Import File=Textures\S_Light.pcx  Name=S_Light Mips=Off MASKED=1 NOCONSOLE

defaultproperties
{
    bStatic=true
    bHidden=true
    bNoDelete=true
    Texture=Texture'S_Light'
    bMovable=false
    CollisionRadius=24.0000000
    CollisionHeight=24.0000000
    LightType=LT_Steady
    LightBrightness=128
    LightSaturation=255
    LightRadius=32
    LightPeriod=32
    LightCone=128
    VolumeBrightness=64
}