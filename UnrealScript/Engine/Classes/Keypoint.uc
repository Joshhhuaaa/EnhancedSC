//=============================================================================
// Keypoint, the base class of invisible actors which mark things.
//=============================================================================
class Keypoint extends Actor
	abstract
	placeable
	native;

// Sprite.
#exec Texture Import File=Textures\Keypoint.pcx Name=S_Keypoint Mips=Off MASKED=1 NOCONSOLE

defaultproperties
{
    bStatic=true
    bHidden=true
    Texture=Texture'S_Keypoint'
    CollisionRadius=10.000000
    CollisionHeight=10.000000
}