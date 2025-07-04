class PlayerInput extends Object within PlayerController
	config(User)
	native
	transient;

var globalconfig	bool	bInvertMouse;
var globalconfig	bool	bFireToDrawGun;
var globalconfig	int     MouseSensitivity; // will be set between 0 and 100
var float shouldMouseInvert; // fake name for CD protection

//=============================================================================
// Input related functions.

// Postprocess the player's input.
event PlayerInput( float DeltaTime )
{
	local float mouseSpeedUp;

	mouseSpeedUp = (float(MouseSensitivity) / 50.0);

	// Add mouse
	aTurn += (aMouseX / DeltaTime) * mouseSpeedUp * (shouldMouseInvert * shouldMouseInvert);
	aLookUp += (aMouseY / DeltaTime) * mouseSpeedUp * shouldMouseInvert;

	if(bInvertMouse)
		aLookUp = -aLookUp;

	if( bStopInput )
	{
		AStrafe = 0;
		AForward = 0;
		bFire = 0;
	}

	// Handle walking.
	HandleWalking();
}

defaultproperties
{
    shouldMouseInvert=1.000000
}