class PlayerInput extends Object within PlayerController
	config(User)
	native
	transient;

var globalconfig	bool	bInvertMouse;
var globalconfig	bool	bFireToDrawGun;
var globalconfig	int     MouseSensitivity; // will be set between 0 and 100
var float shouldMouseInvert; // fake name for CD protection

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
const simDeltaTime = 0.033333f; // Joshua - Made mouse sensitivity frame rate independent by using a consistent DeltaTime
var bool bStopInputAlternate; // Joshua - alternate bStopInput flag needed for inventory and player stats
//=============================================================================
// Input related functions.

// Postprocess the player's input.
event PlayerInput(float simDeltaTime)
{
	local float mouseSpeedUp;

	mouseSpeedUp = (float(MouseSensitivity) / 50.0);

	// Add mouse
    aTurn += (aMouseX / simDeltaTime) * mouseSpeedUp;
    aLookUp += (aMouseY / simDeltaTime) * mouseSpeedUp;

	if (bInvertMouse)
		aLookUp = -aLookUp;

	if (bStopInput || bStopInputAlternate)
	{
		AStrafe = 0;
		AForward = 0;
		bFire = 0;
	}

	if (bStopInputAlternate)
	{
		bDuck = 0;
	}

	// Handle walking.
	HandleWalking();
}

defaultproperties
{
    shouldMouseInvert=1.000000
}