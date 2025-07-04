//=============================================================================
// EDynamicFocusPoint
//		Dynamic version of Focus Point
//		Every EAIController has one that it can move around as it pleases.
//=============================================================================


class EDynamicFocusPoint extends EFocusPoint
	native
	notplaceable;

function PostBeginPlay()
{
	// don't add to focus point list
}

defaultproperties
{
    bStatic=false
    bCollideWhenPlacing=false
}