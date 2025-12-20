//=============================================================================
// FocusPoint
//		
//		Marker class used by Level Designers to specify points of interest
//		for patrolling / investigating NPCs.
//
//		Presently used during NPC path-find - once the initial target is
//		visible, the NPC will search for nearby focus points and will turn
//		his attention towards any visible FocusPoints.
//
//=============================================================================


class EFocusPoint extends EInfoPoint
	native
	placeable;

var(AI) float GrenadeTime; //used by default behavior in grenade zones

defaultproperties
{
    bFocusPoint=True
}