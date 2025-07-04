//=============================================================================
// MatSubAction: Base class for Matinee sub actions.
//
// A Matinee action can have any number of sub actions.  These sub actions
// are executed while the main action is running.
//=============================================================================

#exec Texture Import File=Textures\SubActionFOV.pcx Name=SubActionFOV Mips=Off NOCONSOLE
#exec Texture Import File=Textures\SubActionTrigger.pcx Name=SubActionTrigger Mips=Off NOCONSOLE
#exec Texture Import File=Textures\SubActionOrientation.pcx Name=SubActionOrientation Mips=Off NOCONSOLE
#exec Texture Import File=Textures\SubActionFade.pcx Name=SubActionFade Mips=Off NOCONSOLE
#exec Texture Import File=Textures\SubActionGameSpeed.pcx Name=SubActionGameSpeed Mips=Off NOCONSOLE
#exec Texture Import File=Textures\SubActionSceneSpeed.pcx Name=SubActionSceneSpeed Mips=Off NOCONSOLE

class MatSubAction extends MatObject
	abstract
	native;

enum ESAStatus
{
	SASTATUS_Waiting,	// Waiting to execute
	SASTATUS_Running,	// Is currently executing
	SASTATUS_Ending,	// Is one tick away from expiring
	SASTATUS_Expired,	// Has executed and finished (ignore for rest of scene)
};

var(Time)		float		Delay;		// Seconds before it actually executes
var(Time)		float		Duration;	// How many seconds it should take to complete

var				texture		Icon;		// The icon to use in the matinee UI
var				ESAStatus	Status;		// The status of this subaction
var				string		Desc;		// Desc used by the editor and engine stats

var				transient float		PctStarting;
var				transient float		PctEnding;
var				transient float		PctDuration;

defaultproperties
{
    Desc="N/A"
}