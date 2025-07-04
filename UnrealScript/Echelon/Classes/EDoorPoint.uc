//=============================================================================
// EDoorPoint.
//
// Point that represents the start/end of a door-interaction navigation.
// Needs to be native and in Echelon so that I can control the generation
// of reachspecs.
//
//=============================================================================


class EDoorPoint extends NavigationPoint
	placeable
	native;


var	EDoorMover Door;		// pointer to the door mover which we refer to

defaultproperties
{
    bDoorPoint=true
    bDoNotUseAsHidePoint=true
}