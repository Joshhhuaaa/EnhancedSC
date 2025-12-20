//=============================================================================
// LookTarget
//
// A convenience actor that you can point a matinee camera at.
//
// Isn't bStatic so you can attach these to movers and such.
//
//=============================================================================
class LookTarget extends KeyPoint
	placeable
	native;

// Sprite.
#exec Texture Import File=Textures\LookTarget.pcx Name=S_LookTarget Mips=Off MASKED=1 NOCONSOLE

defaultproperties
{
    bStatic=False
    Texture=Texture'S_LookTarget'
}