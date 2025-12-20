class ShadowBitmapMaterial extends BitmapMaterial
	native;

var const transient int	TextureInterfaces[3];
var const transient int NumStaticMesh;
var const transient int	StaticMeshCount[50];
var transient bool bFirstFrame;
var const transient bool bHaveSoftBody;
var const transient float last_pos[3];
var const transient int last_rot[3];
var const transient float proj_zdist;
var const transient float proj_radius;
var Projector proj;
var bool	Dirty;
var Material	SpotTexture;

//
//	Default properties
//

defaultproperties
{
    Dirty=True
    Format=TEXF_RGBA8
    UClampMode=TC_Clamp
    VClampMode=TC_Clamp
    BorderColor=(R=128,G=128,B=128,A=255)
    UBits=8
    VBits=8
    USize=512
    VSize=512
    UClamp=512
    VClamp=512
}