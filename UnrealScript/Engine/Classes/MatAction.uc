//=============================================================================
// MatAction: Base class for Matinee actions.
//=============================================================================

class MatAction extends MatObject
	abstract
	native;

var()		interpolationpoint	IntPoint;	// The interpolation point that we want to move to/wait at.
var()		string				Comment;	// User can enter a comment here that will appear on the GUI viewport

var(Time)	float	Duration;		// How many seconds this action should take

var(Sub)	export	editinline	array<MatSubAction>	SubActions;		// Sub actions are actions to perform while the main action is happening

var(Path) bool		bSmoothCorner;			// true by default - when one control point is adjusted, other is moved to keep tangents the same
var(Path) vector	StartControlPoint;		// Offset from the current interpolation point
var(Path) vector	EndControlPoint;		// Offset from the interpolation point we're moving to (InPointName)

var		transient array<vector> SampleLocations;
var		transient float	PctStarting;
var		transient float	PctEnding;
var		transient float	PctDuration;

defaultproperties
{
    bSmoothCorner=True
    StartControlPoint=(X=800.000000,Y=800.000000,Z=0.000000)
    EndControlPoint=(X=-800.000000,Y=-800.000000,Z=0.000000)
}