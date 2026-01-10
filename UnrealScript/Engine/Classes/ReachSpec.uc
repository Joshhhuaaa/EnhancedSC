//=============================================================================
// ReachSpec.
//
// A Reachspec describes the reachability requirements between two NavigationPoints
//
//=============================================================================
class ReachSpec extends Object
	native;

var	int		Distance;
var	const NavigationPoint	Start;		// navigationpoint at start of this path
var	const NavigationPoint	End;		// navigationpoint at endpoint of this path (next waypoint or goal)
var	int		CollisionRadius;
var	int		CollisionHeight;
var	int		reachFlags;			// see EReachSpecFlags definition in UnPath.h
var	int		MaxLandingVelocity;
var	byte	bPruned;
