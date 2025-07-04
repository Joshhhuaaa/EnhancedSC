//=============================================================================
// AntiPortalActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
//=============================================================================

class AntiPortalActor extends Actor
	native
	placeable;

defaultproperties
{
    DrawType=DT_AntiPortal
    bEdShouldSnap=true
}