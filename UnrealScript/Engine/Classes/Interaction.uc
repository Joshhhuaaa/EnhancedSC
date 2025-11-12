// ====================================================================
//  Class:  Engine.Interaction
//  
//  Each individual Interaction is a jumping point in UScript.  The should
//  be the foundatation for any subsystem that requires interaction with
//  the player (such as a menu).  
//
//  Interactions take on two forms, the Global Interaction and the Local
//  Interaction.  The GI get's to process data before the LI and get's
//  render time after the LI, so in essence the GI wraps the LI.
//
//  A dynamic array of GI's are stored in the InteractionMaster while
//  each Viewport contains an array of LIs.
//
//
// (c) 2001, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class Interaction extends Interactions
	  native;

var bool bActive;			// Is this interaction Getting Input
var bool bVisible;			// Is this interaction being Displayed
var bool bRequiresTick; 	// Does this interaction require game TICK

// These entries get filled out upon creation.

var Player ViewportOwner;		// Pointer to the ViewPort that "Owns" this interaction or none if it's Global
var InteractionMaster Master;	// Pointer to the Interaction Master

//-----------------------------------------------------------------------------
// natives.

native function Initialize();							// setup the state system and stack frame
native function bool ConsoleCommand(coerce string S);	// Executes a console command

// ***********************************************************************************************
// * BEGIN UBI MODIF Adionne (21 Nov 2002)
// ***********************************************************************************************
//allows the console to know we just saved a file usefull for refresh of lists in menus
event GameSaved(bool success);
event GameLoaded(bool success);
event PopCD();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


// ***********************************************************************************************
// * BEGIN UBI MODIF Adionne (25 Nov 2002)
// ***********************************************************************************************
event ShowFakeWindow(); //This will allow showing the menu system ingame
event HideFakeWindow();
event ShowGameMenu(bool GoToSaveLoadArea);
event ShowMainMenu();
event LeaveGame(ELeaveGame _bwhatToDo);
event ResetMainMenu();

//clauzon to stop sound correctly in the menus when doing alt tab
event ExitAltTab();
event EnterAltTab();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************



// ====================================================================
// FindAction - Translate the InputKey given into the action name associated
//				with it				
// ====================================================================
native(3501) final function string FindAction(EInputKey key);

// WorldToScreen converts a vector in the world 

// ====================================================================
// WorldToScreen - Returns the X/Y screen coordinates in to a viewport of a given vector
// in the world. 
// ====================================================================
native function vector WorldToScreen(vector Location, optional vector CameraLocation, optional rotator CameraRotation);

// ====================================================================
// ScreenToWorld - Converts an X/Y screen coordinate in to a world vector
// ====================================================================
native function vector ScreenToWorld(vector Location, optional vector CameraLocation, optional rotator CameraRotation); 

// ====================================================================
// Initialized - Called directly after an Interaction Object has been created
// and Initialized.  Should be subclassed
// ====================================================================

event Initialized(); 


// ====================================================================
// Message - This event allows interactions to receive messages
// ====================================================================

function Message(coerce string Msg, float MsgLife)
{
} // Message

// ====================================================================
// ====================================================================
// Input Routines - These two routines are the entry points for input.  They both
// return true if the data has been processed and should now discarded.

// Both functions should be handled in a subclass of Interaction
// ====================================================================
// ====================================================================

function bool KeyType(out EInputKey Key)
{
	return false;	
}

function bool KeyEvent(out EInputKey Key, out EInputAction Action, FLOAT Delta)
{
	return false;
}

// ====================================================================
// ====================================================================
// Render Routines - All Interactions recieve both PreRender and PostRender
// calls.

// Both functions should be handled in a subclass of Interaction
// ====================================================================
// ====================================================================


function PreRender(Canvas Canvas);
function PostRender(Canvas Canvas);

// ====================================================================
// SetFocus - This function cases the Interaction to gain "focus" in the interaction
// system.  Global interactions's focus superceed locals.
// ====================================================================

function SetFocus()
{
	Master.SetFocusTo(self,ViewportOwner);

} // SetFocus
	
// ====================================================================
// Tick - By default, Interactions do not get ticked, but you can
// simply turn on bRequiresTick.
// ====================================================================

function Tick(float DeltaTime);

defaultproperties
{
    bActive=true
}