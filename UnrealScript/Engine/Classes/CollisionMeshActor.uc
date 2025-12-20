//=============================================================================
// CollisionMeshActor.
// An actor that is not drawn and used only for NonZeroExtent collision check
//=============================================================================

class CollisionMeshActor extends StaticMeshActor
	native
	placeable;

defaultproperties
{
    bHidden=True
    bWorldGeometry=True
    bAcceptsProjectors=False
    bUnlit=True
    bShadowCast=False
    bBlockPlayers=True
    bBlockActors=True
    bBlockBullet=False
    bBlockCamera=True
    bBlockNPCShot=False
    bBlockNPCVision=False
    bIsCollisionMesh=True
}