//=============================================================================
// InterpolationPoint.
// Used as destinations to move the camera to in Matinee scenes.
//=============================================================================
class InterpolationPoint extends Keypoint
	native;

#exec Texture Import File=Textures\IntrpPnt.pcx Name=S_Interp Mips=Off MASKED=1 NOCONSOLE

defaultproperties
{
    Texture=Texture'S_Interp'
    bDirectional=True
}