//=============================================================================
// Player start location.
//=============================================================================
class PlayerStart extends NavigationPoint
	placeable
	native;

#exec Texture Import File=Textures\S_Player.pcx Name=S_Player Mips=Off MASKED=1 NOCONSOLE

defaultproperties
{
    Texture=Texture'S_Player'
    CollisionRadius=40.000000
    CollisionHeight=88.000000
    bDirectional=True
}