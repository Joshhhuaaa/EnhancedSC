class EGameInteraction extends EInteraction;

#exec OBJ LOAD FILE=..\Sounds\Interface.uax

var EInteractObject ExitInteraction;
var bool bInteracting;
var bool bAltHeld; // Joshua - Track Alt key state for Alt+F4

function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local string actionName;
	actionName = FindAction(Key);

	if( Epc.Level.Pauser != None )
		return false;

        // Joshua - Track Alt key state for Alt+F4
	if( Key == IK_Alt )
	{
		if( Action == IST_Press || Action == IST_Hold )
			bAltHeld = true;
		else if( Action == IST_Release )
			bAltHeld = false;
	}
	
	// Joshua - Alt+F4 to quit the game
	if( bAltHeld && Action == IST_Press && Key == IK_F4 )
	{
		if (!Epc.bProfileDeletionPending)
			Epc.ConsoleCommand("QUIT");
		return true;
	}

	// Joshua - Adding NumPad support for keypads
	if( Action == IST_Press )
	{
		if( Epc.GetStateName() == 's_KeyPadInteract' )
		{
			// NumPad binds take priority if there's a conflic
			if( Key == IK_NumPad0 )
			{
				Epc.KeyEvent("Keypad_NumPad0", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad1 )
			{
				Epc.KeyEvent("Keypad_NumPad1", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad2 )
			{
				Epc.KeyEvent("Keypad_NumPad2", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad3 )
			{
				Epc.KeyEvent("Keypad_NumPad3", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad4 )
			{
				Epc.KeyEvent("Keypad_NumPad4", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad5 )
			{
				Epc.KeyEvent("Keypad_NumPad5", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad6 )
			{
				Epc.KeyEvent("Keypad_NumPad6", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad7 )
			{
				Epc.KeyEvent("Keypad_NumPad7", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad8 )
			{
				Epc.KeyEvent("Keypad_NumPad8", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPad9 )
			{
				Epc.KeyEvent("Keypad_NumPad9", Action, Delta);
				return true;
			}
			else if( Key == IK_NumPadPeriod )
			{
				Epc.KeyEvent("Keypad_NumPadPeriod", Action, Delta);
				return true;
			}
			else if( Key == IK_GreyStar )
			{
				Epc.KeyEvent("Keypad_GreyStar", Action, Delta);
				return true;
			}
			else if( Key == IK_Backspace )
			{
				Epc.KeyEvent("Keypad_Backspace", Action, Delta);
				return true;
			}
		}
	}

	if( Action == IST_Press || Action == IST_Hold )
	{
		//clauzon 9/17/2002 replaced a switch checking the key pressed by the mapped action test.
		if(actionName == "Interaction")
		{
			if( Epc.IManager.GetNbInteractions() > 0 && 
				Epc.CanInteract() &&
				!Epc.bStopInput )							// Prevent interacting in cinematic
			{			
				bInteracting = true;

				// Go into GameInteraction menu
				//Log("Interaction pressed with"$Epc.IManager.GetNbInteractions()$" interaction on stack");
				GotoState('s_GameInteractionMenu');
				 
				return true; // grabbed
			}		
		}
	}

//=============================================================================
// Joshua - Bind controller input based on scheme
//=============================================================================

	switch (Epc.ControllerScheme)
	{
		case CS_Default:
			Epc.SetKey("Joy1 Interaction", "");
			Epc.SetKey("Joy2 Duck", "");
			Epc.SetKey("Joy3 Scope", "");
			Epc.SetKey("Joy4 Jump", "");
			Epc.SetKey("Joy5 Whistle", ""); // Joshua - Adding whistle to default layout
			Epc.SetKey("Joy6 QuickInventory", "");
			Epc.SetKey("Joy7 AltFire", "");
			Epc.SetKey("Joy8 Fire", "");
			Epc.SetKey("Joy9 PlayerStats", "");
			Epc.SetKey("Joy10 FullInventory", "");
			Epc.SetKey("Joy11 BackToWall", ""); // Joshua - Xbox used Joy5 originally but we addeds whistling
			Epc.SetKey("Joy12 ResetCamera", "");
			Epc.SetKey("Joy13 DPadUp", "");
			Epc.SetKey("Joy14 DPadDown", "");
			Epc.SetKey("Joy15 DPadLeft", "");
			Epc.SetKey("Joy16 DPadRight", "");
			Epc.SetKey("AnalogUp MoveForward", "");
			Epc.SetKey("AnalogDown MoveBackward", "");
			Epc.SetKey("AnalogLeft StrafeLeft", "");
			Epc.SetKey("AnalogRight StrafeRight", "");
			Epc.SetKey("JoyX \"Axis aStrafe DeadZone=0.3\"", "");
			Epc.SetKey("JoyY \"Axis aForward DeadZone=0.3\"", "");
			Epc.SetKey("JoyZ \"Axis aTurn DeadZone=0.3\"", "");
			Epc.SetKey("JoyV \"Axis aLookUp DeadZone=0.3\"", "");
			
			if (Epc.GetStateName() == 's_FirstPersonTargeting' || Epc.GetStateName() == 's_PlayerSniping' || Epc.GetStateName() == 's_PlayerBTWTargeting')
			{
				Epc.SetKey("Joy1 ReloadGun", ""); // Joshua - Xbox used Joy5 originally but added whistling
				Epc.SetKey("Joy4 Snipe", "");
				Epc.SetKey("Joy11 SwitchROF", "");
			}

			if (Epc.IManager.GetNbInteractions() > 0 && Epc.CanInteract())
			{
				Epc.SetKey("Joy1 Interaction", "");
			}
			break;

		case CS_Pandora:
			Epc.SetKey("Joy1 Interaction", "");
			Epc.SetKey("Joy2 Duck", "");
			Epc.SetKey("Joy3 Scope", "");
			Epc.SetKey("Joy4 Jump", "");
			Epc.SetKey("Joy5 QuickInventory", "");
			Epc.SetKey("Joy6 Whistle", "");
			Epc.SetKey("Joy7 AltFire", "");
			Epc.SetKey("Joy8 Fire", "");
			Epc.SetKey("Joy9 PlayerStats", "");
			Epc.SetKey("Joy10 FullInventory", "");
			Epc.SetKey("Joy11 BackToWall", "");
			Epc.SetKey("Joy12 ResetCamera", "");
			Epc.SetKey("Joy13 DPadUp", "");
			Epc.SetKey("Joy14 DPadDown", "");
			Epc.SetKey("Joy15 DPadLeft", "");
			Epc.SetKey("Joy16 DPadRight", "");
			Epc.SetKey("AnalogUp MoveForward", "");
			Epc.SetKey("AnalogDown MoveBackward", "");
			Epc.SetKey("AnalogLeft StrafeLeft", "");
			Epc.SetKey("AnalogRight StrafeRight", "");
			Epc.SetKey("JoyX \"Axis aStrafe DeadZone=0.3\"", "");
			Epc.SetKey("JoyY \"Axis aForward DeadZone=0.3\"", "");
			Epc.SetKey("JoyZ \"Axis aTurn DeadZone=0.3\"", "");
			Epc.SetKey("JoyV \"Axis aLookUp DeadZone=0.3\"", "");

			if (Epc.GetStateName() == 's_FirstPersonTargeting' || Epc.GetStateName() == 's_PlayerSniping' || Epc.GetStateName() == 's_PlayerBTWTargeting')
			{
				Epc.SetKey("Joy1 ReloadGun", "");
				Epc.SetKey("Joy11 SwitchROF", ""); // Joshua - Pandora used both thumbsticks to snipe because it had no ROF
				Epc.SetKey("Joy12 Snipe", "");
			}


			if (Epc.IManager.GetNbInteractions() > 0 && Epc.CanInteract())
			{
				Epc.SetKey("Joy1 Interaction", "");
			}
			break;

		case CS_PlayStation:
			Epc.SetKey("Joy1 Interaction", "");
			Epc.SetKey("Joy2 Duck", "");
			Epc.SetKey("Joy3 QuickInventory", "");
			Epc.SetKey("Joy4 Jump", "");
			Epc.SetKey("Joy5 Whistle", "");
			Epc.SetKey("Joy6 Scope", "");
			Epc.SetKey("Joy7 AltFire", ""); // Joshua - AltFire was moved to the triggers, since PS4/PS5 controllers are now more common
			Epc.SetKey("Joy8 Fire", ""); // Joshua - Fire was moved to the triggers, since PS4/PS5 controllers are now more common
			Epc.SetKey("Joy9 PlayerStats", "");
			Epc.SetKey("Joy10 FullInventory", "");
			Epc.SetKey("Joy11 BackToWall", "");
			Epc.SetKey("Joy12 ResetCamera", "");
			Epc.SetKey("Joy13 DPadUp", "");
			Epc.SetKey("Joy14 DPadDown", "");
			Epc.SetKey("Joy15 DPadLeft", "");
			Epc.SetKey("Joy16 DPadRight", "");
			Epc.SetKey("AnalogUp MoveForward", "");
			Epc.SetKey("AnalogDown MoveBackward", "");
			Epc.SetKey("AnalogLeft StrafeLeft", "");
			Epc.SetKey("AnalogRight StrafeRight", "");
			Epc.SetKey("JoyX \"Axis aStrafe DeadZone=0.3\"", "");
			Epc.SetKey("JoyY \"Axis aForward DeadZone=0.3\"", "");
			Epc.SetKey("JoyZ \"Axis aTurn DeadZone=0.3\"", "");
			Epc.SetKey("JoyV \"Axis aLookUp DeadZone=0.3\"", "");

			if (Epc.GetStateName() == 's_FirstPersonTargeting' || Epc.GetStateName() == 's_PlayerSniping' || Epc.GetStateName() == 's_PlayerBTWTargeting')
			{
				Epc.SetKey("Joy1 ReloadGun", ""); // Joshua - PlayStation used Joy5 originally but added whistling
				Epc.SetKey("Joy11 SwitchROF", "");
				Epc.SetKey("Joy12 Snipe", "");
			}


			if (Epc.IManager.GetNbInteractions() > 0 && Epc.CanInteract())
			{
				Epc.SetKey("Joy1 Interaction", "");
			}
			break;

		case CS_User: // Joshua - No hardcoded binds, custom controller bindings using SplinterCellUser.ini
			break;

	}

//=============================================================================
// Joshua - Shared state bindings
//=============================================================================

	// Joshua - Workaround to prevent controller from interrupting mission failed state before it reloads the last save
	if(Epc.myHUD.IsPlayerGameOver())
	{
		Epc.SetKey( "Joy1 None", "");
		Epc.SetKey( "Joy8 None", "");
		Epc.SetKey( "Joy10 None", "");
	}

//=============================================================================
// Joshua - Automatically toggle controller mode
//=============================================================================

	if (Epc.InputMode == IM_Auto)
	{
		if (
			Key == IK_Joy1  || Key == IK_Joy2  || Key == IK_Joy3  || Key == IK_Joy4  ||
			Key == IK_Joy5  || Key == IK_Joy6  || Key == IK_Joy7  || Key == IK_Joy8  ||
			Key == IK_Joy9  || Key == IK_Joy10 || Key == IK_Joy11 || Key == IK_Joy12 ||
			Key == IK_Joy13 || Key == IK_Joy14 || Key == IK_Joy15 || Key == IK_Joy16 ||
			Key == IK_JoyX  || Key == IK_JoyY  || Key == IK_JoyZ  || Key == IK_JoyR  ||
			Key == IK_JoyU  || Key == IK_JoyV  || Key == IK_AnalogUp || Key == IK_AnalogDown ||
			Key == IK_AnalogLeft || Key == IK_AnalogRight
		)
		{
			if (!Epc.eGame.bUseController &&
				!Epc.IsInQuickInv() &&
				Epc.GetStateName() != 's_KeyPadInteract' &&
				Epc.GetStateName() != 's_PickLock') 
			{
				Epc.eGame.bUseController = true;
				Epc.m_curWalkSpeed = 5;
			}
		}
		else if (Key != IK_MouseX && Key != IK_MouseY)
		{
			if (Epc.eGame.bUseController &&
				!Epc.IsInQuickInv() &&
				Epc.GetStateName() != 's_KeyPadInteract' &&
				Epc.GetStateName() != 's_PickLock')
			{
				Epc.eGame.bUseController = false;
			}
		}
	}
	else if (Epc.InputMode == IM_Keyboard)
		Epc.eGame.bUseController = false;
	else if (Epc.InputMode == IM_Controller)
		Epc.eGame.bUseController = true;


	BindSnipe();
	BindWhistle();
	BindToggleHUD();
	BindPlayerStats();
	
	return false; // continue input processing
}

state s_GameInteractionMenu
{
	function BeginState()
	{
		if (Epc.bInteractionPause) // Joshua - Adding interaction pause option
			Epc.SetPause(true);
		else
			Epc.bStopInput = true;

		Epc.IManager.SelectedInteractions = 1;
		
		// Add exit button, spawn it only the first time in
		if( ExitInteraction == None )
			ExitInteraction = Epc.IManager.spawn(class'EExitInteraction', Epc.IManager);
		Epc.IManager.ShowExit(ExitInteraction);

		//Log("Interaction menu in");
		Enable('Tick');
	}

	function EndState()
	{
		if( Epc.IManager.GetCurrentInteraction() == None )
			Log("ERROR: Interaction not valid on stack.");

		if (Epc.bInteractionPause) // Joshua - Adding interaction pause option
			Epc.SetPause(false);
		else
			Epc.bStopInput = false;

		//Log("Interaction menu .. Interaction released .. initInteract");
		Epc.IManager.GetCurrentInteraction().InitInteract(Epc);
		Epc.IManager.SelectedInteractions = -1;

		// Remove exit button
		Epc.IManager.ShowExit(None);
	}

	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local string actionName;
		actionName = FindAction(Key);

		// Joshua - If only the Exit option remains, autoamtically exit Interaction Menu
		if (!Epc.bInteractionPause && Epc.IManager.GetNbInteractions() <= 1)
		{
			bInteracting = false;
			GotoState('');
		}
		
		if( Action == IST_Press )
		{
			//clauzon 9/17/2002 replaced a switch checking the key pressed by the mapped action test.
			if(actionName=="MoveForward" || Key == IK_MouseWheelUp || actionName == "DPadUp") // Joshua - Adding controller support for interaction box
			{
				if( Epc.IManager.SelectNextItem() )
				{
					//Log("Interaction menu UP");
					Epc.EPawn.playsound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
				}				
			}
			else if(actionName == "MoveBackward" || Key == IK_MouseWheelDown || actionName == "DPadDown") // Joshua - Adding controller support for interaction box
			{
				if( Epc.IManager.SelectPreviousItem() )
				{
					//Log("Interaction menu DOWN");
					Epc.EPawn.playsound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
				}
			}
		}
		else if( Action == IST_Release )
		{
			if(actionName=="Interaction")
			{
				bInteracting = false;
				// Exit GameInteraction menu
				//Log("Interaction released");
				GotoState('');
			}
		}
		return true;
	} 
}

// Joshua - Function to bind Sniper to Middle Mouse
// Only binds if Middle Mouse is free and Sniper isn't already bound to another key
function BindSnipe()
{
    local byte SnipeKeyByte;
    local byte MiddleMouseKeyByte;
    local string BoundAction;
    local bool bSnipeBound;
    
    MiddleMouseKeyByte = 4; // Value for 'MiddleMouse'
    
    // Check if already bound to a key
    MiddleMouseKeyByte = Epc.GetKey("Snipe", false);
    
    // Don't consider controller keys (196-215) as bindings
    if(MiddleMouseKeyByte != 0 && !(MiddleMouseKeyByte >= 196 && MiddleMouseKeyByte <= 215))
    {
        bSnipeBound = true;
    }
    
    if(!bSnipeBound)
    {
        BoundAction = Epc.GetActionKey(MiddleMouseKeyByte);
        
        if(BoundAction == "" || BoundAction == "None")
        {
            Epc.SetKey("MiddleMouse Snipe", "");
        }
    }
}

// Joshua - Function to bind Whistle to V key
// Only binds if V is free and Whistle isn't already bound to another key
function BindWhistle()
{
    local byte WhistleKeyByte;
    local byte VKeyByte;
    local string BoundAction;
    local bool bWhistleBound;
    
    VKeyByte = 86; // Value for 'V'
    
    // Check if already bound to a key
    WhistleKeyByte = Epc.GetKey("Whistle", false);
    
    // Don't consider controller keys (196-215) as bindings
    if(WhistleKeyByte != 0 && !(WhistleKeyByte >= 196 && WhistleKeyByte <= 215))
    {
        bWhistleBound = true;
    }
    
    if(!bWhistleBound)
    {
        BoundAction = Epc.GetActionKey(VKeyByte);
        
        if(BoundAction == "" || BoundAction == "None")
        {
            Epc.SetKey("V Whistle", "");
        }
    }
}

// Joshua - Function to bind ToggleHUD to F1 key
// Only binds if F1 is free and ToggleHUD isn't already bound to another key
function BindToggleHUD()
{
    local byte ToggleHUDKeyByte;
    local byte F1KeyByte;
    local string BoundAction;
    local bool bToggleHUDBound;
    
    F1KeyByte = 112; // Value for 'F1'
    
    // Check if already bound to a key
    ToggleHUDKeyByte = Epc.GetKey("ToggleHUD", false);
    
    // Don't consider controller keys (196-215) as bindings
    if(ToggleHUDKeyByte != 0 && !(ToggleHUDKeyByte >= 196 && ToggleHUDKeyByte <= 215))
    {
        bToggleHUDBound = true;
    }
    
    if(!bToggleHUDBound)
    {
        BoundAction = Epc.GetActionKey(F1KeyByte);
        
        if(BoundAction == "" || BoundAction == "None")
        {
            Epc.SetKey("F1 ToggleHUD", "");
        }
    }
}

// Joshua - Function to bind PlayerStats to Tab key
// Bind ToggleStats to Tab key if it's not already bound elsewhere
function BindPlayerStats()
{
    local byte PlayerStatsKeyByte;
    local byte TabKeyByte;
    local string BoundAction;
    local bool bToggleStatsBound;
    
    TabKeyByte = 9; // Value for 'Tab'
    
    // Check if already bound to a key
    PlayerStatsKeyByte = Epc.GetKey("PlayerStats", false);
    
    // Don't consider controller keys (196-215) as bindings
    if(PlayerStatsKeyByte != 0 && !(PlayerStatsKeyByte >= 196 && PlayerStatsKeyByte <= 215))
    {
        bToggleStatsBound = true;
    }
    
    if(!bToggleStatsBound)
    {        BoundAction = Epc.GetActionKey(TabKeyByte);
        
        if(BoundAction == "" || BoundAction == "None")
        {
            Epc.SetKey("Tab PlayerStats", "");
        }
    }
}