//=============================================================================
// CollisionMeshActor.
// An actor that is not drawn and used only for NonZeroExtent collision check
//=============================================================================

class CollisionMeshActor extends StaticMeshActor
	native
	placeable;

defaultproperties
{
    bHidden=true
    bWorldGeometry=true
    bAcceptsProjectors=false
    bUnlit=true
    bShadowCast=false
    bBlockPlayers=true
    bBlockActors=true
    bBlockBullet=false
    bBlockCamera=true
    bBlockNPCShot=false
    bBlockNPCVision=false
    bIsCollisionMesh=true
}