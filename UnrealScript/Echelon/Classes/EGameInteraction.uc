class EGameInteraction extends EInteraction;

#exec OBJ LOAD FILE=..\Sounds\Interface.uax

var EInteractObject ExitInteraction;
var bool bInteracting;
var bool bForceExited; // Joshua - Force exit the interaction menu when the player dies

function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
{
	local string actionName;
	actionName = FindAction(Key);

	if (Epc.Level.Pauser != None)
		return false;

	//=============================================================================
	// Joshua - Automatically toggle controller mode
	//=============================================================================
	if (Epc.InputMode == IM_Auto)
	{
		if (Key == IK_Joy1  || Key == IK_Joy2  || Key == IK_Joy3  || Key == IK_Joy4  ||
			Key == IK_Joy5  || Key == IK_Joy6  || Key == IK_Joy7  || Key == IK_Joy8  ||
			Key == IK_Joy9  || Key == IK_Joy10 || Key == IK_Joy11 || Key == IK_Joy12 ||
			Key == IK_Joy13 || Key == IK_Joy14 || Key == IK_Joy15 || Key == IK_Joy16 ||
			Key == IK_JoyX  || Key == IK_JoyY  || Key == IK_JoyZ  || Key == IK_JoyR  ||
			Key == IK_JoyU  || Key == IK_JoyV  || Key == IK_AnalogUp || Key == IK_AnalogDown ||
			Key == IK_AnalogLeft || Key == IK_AnalogRight)
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

	// Joshua - Block all input when in mission failed state, only allow specific keys
	if (Epc.bMissionFailedQuickMenu && !Epc.eGame.bPermaDeathMode && Epc.myHUD.IsPlayerGameOver())
	{
		// Joshua - Allow camera movement
		if (Key == IK_MouseX || Key == IK_MouseY || Key == IK_JoyZ || Key == IK_JoyV)
			return false;

		if (Action == IST_Press)
		{
			// Joshua - Block all quick menu actions until 2 seconds have passed
			if (Epc.MissionQuickMenuTimer < 2.0)
			{
				return true;
			}

			// Joshua - Handle confirmation dialog if active
			if (Epc.bMissionFailedShowConfirmation)
			{
				// Joshua - Enable fake mouse if we switched from controller to keyboard during confirmation
				if (!Epc.eGame.bUseController)
				{
					Epc.FakeMouseToggle(true);
				}
				else
				{
					Epc.FakeMouseToggle(false);
				}
				
				// Joshua - Toggle Yes/No selecton
				if (actionName == "StrafeLeft" || actionName== "StrafeRight" || actionName == "DPadLeft" || actionName == "DPadRight") 
				{
					Epc.bMissionFailedConfirmYes = !Epc.bMissionFailedConfirmYes;
					return true;
				}

				// Joshua - Confirm selection
				else if (Key == IK_Space || Key == IK_Enter || Key == IK_Joy1)
				{
					Epc.EPawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
										
					if (Epc.bMissionFailedConfirmYes)
					{
						// Joshua - Turn off fake mouse before restarting or quitting
						Epc.FakeMouseToggle(false);
						
						if (Epc.iMissionFailedConfirmAction == 1)
						{
							Epc.bMissionFailedQuickMenu = false;
							Epc.RestartMission();
							return true;
						}
						else if (Epc.iMissionFailedConfirmAction == 2)
						{
							Epc.bMissionFailedQuickMenu = false;
							Epc.QuitToMainMenu();
							return true;
						}
					}
					else
					{
						Epc.FakeMouseToggle(false);
						Epc.bMissionFailedShowConfirmation = false;
						Epc.iMissionFailedConfirmAction = 0;
					}
					
					return true;
				}
				// Joshua - Cancel confirmation
				else if (Key == IK_Escape || Key == IK_Joy2)
				{
					Epc.FakeMouseToggle(false);
					Epc.bMissionFailedShowConfirmation = false;
					Epc.iMissionFailedConfirmAction = 0;
					return true;
				}
				// Joshua - Allow left mouse clicks to pass through for mouse handling in EGameMenuHUD Tick
				else if (Key == IK_LeftMouse)
				{
					return false;
				}
				
				return true;
			}

			// Joshua - Normal menu
			if (Key == IK_Space || Key == IK_Joy1)
			{
				Epc.myHUD.GotoState('s_Mission', 'BeginLoadLastSave');
				return true;
			}
			else if (Key == IK_LeftMouse || Key == IK_Joy4)
			{
				ViewportOwner.Console.ShowGameMenu(true);
				return true;
			}
			else if (Key == IK_Enter || Key == IK_Joy3)
			{
				// Show restart confirmation
				Epc.bMissionFailedShowConfirmation = true;
				Epc.iMissionFailedConfirmAction = 1;
				Epc.bMissionFailedConfirmYes = false;

				Epc.EPawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);

				if (!Epc.eGame.bUseController)
					Epc.FakeMouseToggle(true);

				return true;
			}
			else if (Key == IK_Escape || Key == IK_Joy2)
			{
				// Show quit confirmation
				Epc.bMissionFailedShowConfirmation = true;
				Epc.iMissionFailedConfirmAction = 2;
				Epc.bMissionFailedConfirmYes = false;

				Epc.EPawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);

				if (!Epc.eGame.bUseController)
					Epc.FakeMouseToggle(true);

				return true;
			}
		}
		return true;
	}
	
	// Joshua - Adding NumPad support for keypads
	if (Action == IST_Press)
	{
		if (Epc.GetStateName() == 's_KeyPadInteract')
		{
			// NumPad binds take priority if there's a conflict
			if (Key == IK_NumPad0)
			{
				Epc.KeyEvent("Keypad_NumPad0", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad1)
			{
				Epc.KeyEvent("Keypad_NumPad1", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad2)
			{
				Epc.KeyEvent("Keypad_NumPad2", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad3)
			{
				Epc.KeyEvent("Keypad_NumPad3", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad4)
			{
				Epc.KeyEvent("Keypad_NumPad4", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad5)
			{
				Epc.KeyEvent("Keypad_NumPad5", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad6)
			{
				Epc.KeyEvent("Keypad_NumPad6", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad7)
			{
				Epc.KeyEvent("Keypad_NumPad7", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad8)
			{
				Epc.KeyEvent("Keypad_NumPad8", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPad9)
			{
				Epc.KeyEvent("Keypad_NumPad9", Action, Delta);
				return true;
			}
			else if (Key == IK_NumPadPeriod)
			{
				Epc.KeyEvent("Keypad_NumPadPeriod", Action, Delta);
				return true;
			}
			else if (Key == IK_GreyStar)
			{
				Epc.KeyEvent("Keypad_GreyStar", Action, Delta);
				return true;
			}
			else if (Key == IK_Backspace)
			{
				Epc.KeyEvent("Keypad_Backspace", Action, Delta);
				return true;
			}
		}
	}

	if (Action == IST_Press || Action == IST_Hold)
	{
		//clauzon 9/17/2002 replaced a switch checking the key pressed by the mapped action test.
		if (actionName == "Interaction")
		{
			if (Epc.IManager.GetNbInteractions() > 0 && 
				Epc.CanInteract() &&
				!Epc.bStopInput) // Prevent interacting in cinematic
			{			
				bInteracting = true;

				// Go into GameInteraction menu
				//Log("Interaction pressed with"$Epc.IManager.GetNbInteractions()$" interaction on stack");
				GotoState('s_GameInteractionMenu');
				 
				return true; // Grabbed
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
			Epc.SetKey("Joy5 Whistle", "");
			Epc.SetKey("Joy6 QuickInventory", "");
			Epc.SetKey("Joy7 AltFire", "");
			Epc.SetKey("Joy8 Fire", "");
			Epc.SetKey("Joy9 PlayerStats", "");
			Epc.SetKey("Joy10 FullInventory", "");
			Epc.SetKey("Joy11 BackToWall", "");
			if (Epc.bBinoculars)
				Epc.SetKey("Joy12 Snipe", "");
			else
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

			if (Epc.GetStateName() == 's_FirstPersonTargeting' ||
				Epc.GetStateName() == 's_RappellingTargeting' ||
				Epc.GetStateName() == 's_PlayerBTWTargeting' ||
				Epc.GetStateName() == 's_HOHFUTargeting' ||
				Epc.GetStateName() == 's_PlayerSniping' ||
				Epc.GetStateName() == 's_SplitSniping' ||
				Epc.GetStateName() == 's_RappellingSniping')
			{
				Epc.SetKey("Joy1 ReloadGun", "");
				Epc.SetKey("Joy11 SwitchROF", "");
				Epc.SetKey("Joy12 Snipe", "");
			}

			if (Epc.IManager.GetNbInteractions() > 0 && Epc.CanInteract())
			{
				Epc.SetKey("Joy1 Interaction", "");
			}
			break;

		case CS_Xbox:
			Epc.SetKey("Joy1 Interaction", "");
			Epc.SetKey("Joy2 Duck", "");
			Epc.SetKey("Joy3 Scope", "");
			Epc.SetKey("Joy4 Jump", "");
			if (Epc.bWhistle)
				Epc.SetKey("Joy5 Whistle", "");
			else
				Epc.SetKey("Joy5 BackToWall", "");
			Epc.SetKey("Joy6 QuickInventory", "");
			Epc.SetKey("Joy7 AltFire", "");
			Epc.SetKey("Joy8 Fire", "");
			Epc.SetKey("Joy9 PlayerStats", "");
			Epc.SetKey("Joy10 FullInventory", "");
			if (Epc.bWhistle)
				Epc.SetKey("Joy11 BackToWall", "");
			else
				Epc.SetKey("Joy11 None", "");
			if (Epc.bBinoculars)
				Epc.SetKey("Joy12 Snipe", "");
			else
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
			
			if (Epc.GetStateName() == 's_FirstPersonTargeting' ||
				Epc.GetStateName() == 's_RappellingTargeting' ||
				Epc.GetStateName() == 's_PlayerBTWTargeting' ||
				Epc.GetStateName() == 's_HOHFUTargeting' ||
				Epc.GetStateName() == 's_PlayerSniping' ||
				Epc.GetStateName() == 's_SplitSniping' ||
				Epc.GetStateName() == 's_RappellingSniping')
			{
				if (Epc.bWhistle)
					Epc.SetKey("Joy1 ReloadGun", "");
				else
					Epc.SetKey("Joy1 Interaction", "");
				Epc.SetKey("Joy4 Snipe", "");
				if (Epc.bWhistle)
					Epc.SetKey("Joy5 Whistle", "");
				else
					Epc.SetKey("Joy5 ReloadGun", "");
				Epc.SetKey("Joy12 ResetCamera", "");
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
			if (Epc.bBinoculars)
				Epc.SetKey("Joy12 Snipe", "");
			else
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

			if (Epc.GetStateName() == 's_FirstPersonTargeting' ||
				Epc.GetStateName() == 's_RappellingTargeting' ||
				Epc.GetStateName() == 's_PlayerBTWTargeting' ||
				Epc.GetStateName() == 's_HOHFUTargeting' ||
				Epc.GetStateName() == 's_PlayerSniping' ||
				Epc.GetStateName() == 's_SplitSniping' ||
				Epc.GetStateName() == 's_RappellingSniping')
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
	/*if (Epc.myHUD.IsPlayerGameOver())
	{
		Epc.SetKey("Joy1 LoadLastSave", "");
		Epc.SetKey("Joy2 QuitToMainMenu", "");
		Epc.SetKey("Joy4 Interaction", "");
		
	}*/

	BindSnipe();
	BindWhistle();
	BindToggleHUD();
	BindPreviousGadget();
	BindNextGadget();
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
		if (ExitInteraction == None)
			ExitInteraction = Epc.IManager.spawn(class'EExitInteraction', Epc.IManager);
		Epc.IManager.ShowExit(ExitInteraction);

		//Log("Interaction menu in");
		Enable('Tick');
	}

	function EndState()
	{
		if (Epc.IManager.GetCurrentInteraction() == None)
			Log("ERROR: Interaction not valid on stack.");

		if (Epc.bInteractionPause) // Joshua - Adding interaction pause option
			Epc.SetPause(false);
		else
			Epc.bStopInput = false;

		// Joshua - Force exit the interaction menu when the player dies
		if (!bForceExited)
		{
			//Log("Interaction menu .. Interaction released .. initInteract");
			Epc.IManager.GetCurrentInteraction().InitInteract(Epc);
		}
		else
		{
			bForceExited = false;
		}
		
		Epc.IManager.SelectedInteractions = -1;

		// Remove exit button
		Epc.IManager.ShowExit(None);
	}

	function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
	{
		local string actionName;
		actionName = FindAction(Key);

		// Joshua - Allow mouse movement to pass through for camera control
		if (Key == IK_MouseX || Key == IK_MouseY)
			return false;

		// Joshua - If only the Exit option remains, autoamtically exit Interaction Menu
		if (!Epc.bInteractionPause && Epc.IManager.GetNbInteractions() <= 1)
		{
			bInteracting = false;
			GotoState('');
		}
		
		if (Action == IST_Press)
		{
			//clauzon 9/17/2002 replaced a switch checking the key pressed by the mapped action test.
			if (actionName == "MoveForward" || Key == IK_MouseWheelUp || actionName == "DPadUp") // Joshua - Adding controller support for interaction box
			{
				// Joshua - Invert interaction list support
				if ((Epc.bInvertInteractionList && Epc.IManager.SelectPreviousItem()) || (!Epc.bInvertInteractionList && Epc.IManager.SelectNextItem()))
				{
					//Log("Interaction menu UP");
					Epc.EPawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
				}				
			}
			else if (actionName == "MoveBackward" || Key == IK_MouseWheelDown || actionName == "DPadDown") // Joshua - Adding controller support for interaction box
			{
				// Joshua - Invert interaction list support
				if ((Epc.bInvertInteractionList && Epc.IManager.SelectNextItem()) || (!Epc.bInvertInteractionList && Epc.IManager.SelectPreviousItem()))
				{
					//Log("Interaction menu DOWN");
					Epc.EPawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
				}
			}
		}
		else if (Action == IST_Release)
		{
			if (actionName == "Interaction")
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

// Joshua - Force exit the interaction menu when the player dies
function ForceExitInteractionMenu()
{
	// Only exit if we're currently in the interaction menu state
	if (IsInState('s_GameInteractionMenu'))
	{
		bForceExited = true;
		bInteracting = false;
		GotoState('');
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
	SnipeKeyByte = Epc.GetKey("Snipe", false);

	// Don't consider controller keys (196-215) as bindings
	if (SnipeKeyByte != 0 && !(SnipeKeyByte >= 196 && SnipeKeyByte <= 215))
	{
		bSnipeBound = true;
	}

	if (!bSnipeBound)
	{
		BoundAction = Epc.GetActionKey(MiddleMouseKeyByte);

		if (BoundAction == "" || BoundAction == "None")
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
	if (WhistleKeyByte != 0 && !(WhistleKeyByte >= 196 && WhistleKeyByte <= 215))
	{
		bWhistleBound = true;
	}

	if (!bWhistleBound)
	{
		BoundAction = Epc.GetActionKey(VKeyByte);

		if (BoundAction == "" || BoundAction == "None")
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
	if (ToggleHUDKeyByte != 0 && !(ToggleHUDKeyByte >= 196 && ToggleHUDKeyByte <= 215))
	{
		bToggleHUDBound = true;
	}

	if (!bToggleHUDBound)
	{
		BoundAction = Epc.GetActionKey(F1KeyByte);

		if (BoundAction == "" || BoundAction == "None")
		{
			Epc.SetKey("F1 ToggleHUD", "");
		}
	}
}

// Joshua - Function to bind PreviousGadget to 4 key
// Only binds if 4 is free and PreviousGadget isn't already bound to another key
function BindPreviousGadget()
{
	local byte PreviousGadgetKeyByte;
	local byte Num4KeyByte;
	local string BoundAction;
	local bool bPreviousGadgetBound;

	Num4KeyByte = 52; // Value for '4'

	// Check if already bound to a key
	PreviousGadgetKeyByte = Epc.GetKey("PreviousGadget", false);

	// Don't consider controller keys (196-215) as bindings
	if (PreviousGadgetKeyByte != 0 && !(PreviousGadgetKeyByte >= 196 && PreviousGadgetKeyByte <= 215))
	{
		bPreviousGadgetBound = true;
	}

	if (!bPreviousGadgetBound)
	{
		BoundAction = Epc.GetActionKey(Num4KeyByte);

		if (BoundAction == "" || BoundAction == "None")
		{
			Epc.SetKey("4 PreviousGadget", "");
		}
	}
}

// Joshua - Function to bind NextGadget to 5 key
// Only binds if 5 is free and NextGadget isn't already bound to another key
function BindNextGadget()
{
	local byte NextGadgetKeyByte;
	local byte Num5KeyByte;
	local string BoundAction;
	local bool bNextGadgetBound;

	Num5KeyByte = 53; // Value for '5'

	// Check if already bound to a key
	NextGadgetKeyByte = Epc.GetKey("NextGadget", false);

	// Don't consider controller keys (196-215) as bindings
	if (NextGadgetKeyByte != 0 && !(NextGadgetKeyByte >= 196 && NextGadgetKeyByte <= 215))
	{
		bNextGadgetBound = true;
	}

	if (!bNextGadgetBound)
	{
		BoundAction = Epc.GetActionKey(Num5KeyByte);

		if (BoundAction == "" || BoundAction == "None")
		{
			Epc.SetKey("5 NextGadget", "");
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
	if (PlayerStatsKeyByte != 0 && !(PlayerStatsKeyByte >= 196 && PlayerStatsKeyByte <= 215))
	{
		bToggleStatsBound = true;
	}

	if (!bToggleStatsBound)
	{
		BoundAction = Epc.GetActionKey(TabKeyByte);

		if (BoundAction == "" || BoundAction == "None")
		{
			Epc.SetKey("Tab PlayerStats", "");
		}
	}
}
