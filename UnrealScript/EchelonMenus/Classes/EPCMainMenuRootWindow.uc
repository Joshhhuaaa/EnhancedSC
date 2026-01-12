//=============================================================================
//  EPCMainMenuRootWindow.uc : Root of all children windows
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/03 * Created by Alexandre Dionne
//=============================================================================
class EPCMainMenuRootWindow extends UWindowRootWindow
                native;


#exec OBJ LOAD FILE=..\Sounds\Interface.uax

//
// NORMAL FONT - to be commented if font needed needs to be extended
//

#exec Font IMPORT NAME=ETextFont         FILE="..\Textures\Font\txt_integration.pcx"
#exec Font IMPORT NAME=ETextFontXbox     FILE="..\Textures\Font\txt_integration_xbox.pcx"
#exec Font IMPORT NAME=ETextFontGameCube FILE="..\Textures\Font\txt_integration_gamecube.pcx"
#exec Font IMPORT NAME=ETitleFont        FILE="..\Textures\Font\titre_regular_integration.pcx"
#exec Font IMPORT NAME=ETitleBoldFont    FILE="..\Textures\Font\titre_bold_integration.pcx"
#exec Font IMPORT NAME=EHUDFont          FILE="..\Textures\Font\txt_hud.pcx"
#exec Font IMPORT NAME=EMissionFont      FILE="..\Textures\Font\txt_mission.pcx"

//
// EXTENDED FONT - to be commented if font needed is simple a-z
//

// #exec new TrueTypeFontFactory Name=LocalizedTrueType FontName="Arial" Height=12 AntiAlias=1 CharactersPerPage=128 Path=d:\splintercellpcc\system\localization Wildcard=*.rus
// Joshua - Commented out because to disable Russian language font


var EPCFileManager      m_FileManager;

var UWindowWindow		m_CurrentWidget;
var UWindowWindow       m_PreviousWidget;
var EPCMainMenu         m_MainMenuWidget;
var EPCVideoMenu        m_CreditsWidget;
var EPCVideoMenu		m_IntroWidget;
var EPCPlayerMenu       m_PlayerWidget;
var EPCOptionsMenu      m_OptionsWidget;
var EPCSaveGameMenu     m_SaveGameWidget;
var EPCInGameMenu       m_InGameMenu;
var EPCInGameDataDetailsMenu m_InGameDataDetailsWidget;
var EPCIngameFakeWindow m_FakeWidget;

var EPCPopUpController  m_MessageBoxCW;
var EPCMessageBox		m_MessageBox;

var Texture             ETPixel;
var Material            PdaBorder;
var Texture             PdaBackGround;

var BOOL                bSkipLaptopOverlay;
var config INT          TitleFont;          //Because some text don't fit in some languages, this allows to change the font from the ini file
var config BOOL         ForceSmallFonts;    //To fix localizations problems

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var bool m_bControllerModeActive;  // Joshua - True when using controller, False when using keyboard/mouse

function PlayClickSound()
{
	GetPlayerOwner().PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
}

native(1182) final function bool IsTimeDemo();

function Created()
{
    Super.Created();
	SetAcceptsFocus();

    m_FileManager = New(None) class'EPCFileManager';

    m_MainMenuWidget = EPCMainMenu(CreateWindow(class'EPCMainMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
    m_MainMenuWidget.HideWindow();

    m_CreditsWidget = EPCVideoMenu(CreateWindow(class'EPCVideoMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
	m_CreditsWidget.HideWindow();
	m_CreditsWidget.m_VideoName="credits.bik";

    m_PlayerWidget = EPCPlayerMenu(CreateWindow(class'EPCPlayerMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
	m_PlayerWidget.HideWindow();

    m_SaveGameWidget = EPCSaveGameMenu(CreateWindow(class'EPCSaveGameMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
    m_SaveGameWidget.HideWindow();

    m_OptionsWidget = EPCOptionsMenu(CreateWindow(class'EPCOptionsMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
	m_OptionsWidget.HideWindow();

    m_InGameMenu = EPCInGameMenu(CreateWindow(class'EPCInGameMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
	m_InGameMenu.HideWindow();

    m_InGameDataDetailsWidget= EPCInGameDataDetailsMenu(CreateWindow(class'EPCInGameDataDetailsMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
    m_InGameDataDetailsWidget.HideWindow();

    m_FakeWidget= EPCIngameFakeWindow(CreateWindow(class'EPCIngameFakeWindow', WinLeft, WinTop, WinWidth, WinHeight,self));
    m_FakeWidget.HideWindow();

	m_IntroWidget = EPCVideoMenu(CreateWindow(class'EPCVideoMenu', WinLeft, WinTop, WinWidth, WinHeight,self));
	m_IntroWidget.HideWindow();
	m_IntroWidget.m_VideoName="videointro.bik";

    m_MessageBoxCW = EPCPopUpController(CreateWindow(class'EPCPopUpController', WinLeft, WinTop, WinWidth, WinHeight,self));

    // Joshua - Check if we should start in controller mode (quit from in-game menu via controller)
    CheckStartInControllerMode();

    if (EPCConsole(Console).HideMenusAtStart || IsTimeDemo())
        EPCConsole(Console).LaunchGame();
    else
        ChangeCurrentWidget(WidgetID_MainMenu);

}

function ResetMenus()
{
    //This function is called when we return to main menu,
    //Add here any new widget that need to reset after we went
    //in the main menu
}

function ChangeCurrentWidget(eGameWidgetID widgetID)
{

    bSkipLaptopOverlay = false;
	EPCConsole(Console).bInGameMenuActive = false;
	EPCConsole(Console).bMainMenuActive = true;


	m_OptionsWidget.m_ControlsArea.m_bFirstRefresh = true;
	m_OptionsWidget.m_SoundsArea.m_bFirstRefresh = true;
	m_OptionsWidget.m_GraphicArea.m_bFirstRefresh = true;
	m_OptionsWidget.m_EnhancedArea.m_bFirstRefresh = true; // Joshua - Enhanced area settings


    if (m_CurrentWidget != None)
    {
        m_CurrentWidget.HideWindow();
    }

    switch (widgetID)
	{
    case WidgetID_None :
		EPCConsole(Console).bMainMenuActive = false;
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = None;
		break;
    case WidgetID_MainMenu :
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_MainMenuWidget;
		m_CurrentWidget.ShowWindow();
		break;
    case WidgetID_Credits:
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_CreditsWidget;
		m_CurrentWidget.ShowWindow();
        break;
    case WidgetID_Options:
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_OptionsWidget;
		m_CurrentWidget.ShowWindow();
        break;
    case WidgetID_Player:
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_PlayerWidget;
		m_CurrentWidget.ShowWindow();
        break;
    case WidgetID_SaveGames:
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_SaveGameWidget;
		m_CurrentWidget.ShowWindow();
        break;
    case WidgetID_Intro:
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_IntroWidget;
		m_CurrentWidget.ShowWindow();
		break;
    case WidgetID_InGameDataDetails :
		EPCConsole(Console).bMainMenuActive = false;
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_InGameDataDetailsWidget;
		m_CurrentWidget.ShowWindow();
		break;
    case WidgetID_InGameMenu :
		EPCConsole(Console).bMainMenuActive = false;
		EPCConsole(Console).bInGameMenuActive = true;
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_InGameMenu;
		m_CurrentWidget.ShowWindow();
        m_InGameMenu.Reset();
		break;
    case WidgetID_FakeWindow :
		EPCConsole(Console).bMainMenuActive = false;
        m_PreviousWidget    = m_CurrentWidget;
		m_CurrentWidget     = m_FakeWidget;
		m_CurrentWidget.ShowWindow();
		break;
    case WidgetID_Previous:           //Used For back button in in-game full screen menus
        if (m_PreviousWidget != None)
        {
            m_CurrentWidget     = m_PreviousWidget;
            m_PreviousWidget    = None;
            m_CurrentWidget.ShowWindow();
        }
        break;
	default :
		break;
	}
}

function GameSaved(bool success)
{
	if (m_InGameMenu.WindowIsVisible())
		m_InGameMenu.GameSaved(success);
}

function GameLoaded(bool success)
{
	if (m_InGameMenu.WindowIsVisible())
	    m_InGameMenu.GameLoaded(success);
}

// Joshua - Override to detect mouse movement and switch to mouse mode
function MoveMouse(float X, float Y)
{
	// If mouse actually moved, switch to mouse mode
	if (X != MouseX || Y != MouseY)
	{
		if (m_bControllerModeActive)
		{
			m_bControllerModeActive = false;
			bDisableMouseDisplay = false;
			OnControllerModeChanged(false);
		}
	}

	Super.MoveMouse(X, Y);
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local bool bWasControllerMode;
	local bool bKeybindPopupActive;

	bWasControllerMode = m_bControllerModeActive;

	// Joshua - Check if keybind popup is active (in main menu or in-game settings)
	bKeybindPopupActive = false;
	if (m_OptionsWidget != None && m_OptionsWidget.m_ControlsArea != None && m_OptionsWidget.m_ControlsArea.m_MessageBox != None)
		bKeybindPopupActive = true;
	if (m_InGameMenu != None && m_InGameMenu.m_SettingsArea != None && m_InGameMenu.m_SettingsArea.m_ControlsArea != None && m_InGameMenu.m_SettingsArea.m_ControlsArea.m_MessageBox != None)
		bKeybindPopupActive = true;

	// Joshua - Block all controller input when keybind popup is active
	// A or B button closes the popup, other controller keys are ignored
	if (bKeybindPopupActive && Msg == WM_KeyDown && Key >= 196 && Key <= 215)
	{
		if (Key == 200 || Key == 201) // A or B button - close the popup
		{
			PlayClickSound();
			m_MessageBoxCW.Result = MR_Cancel;
			m_MessageBoxCW.Close();
			// Clear the message box reference
			if (m_OptionsWidget != None && m_OptionsWidget.m_ControlsArea != None)
				m_OptionsWidget.m_ControlsArea.m_MessageBox = None;
			if (m_InGameMenu != None && m_InGameMenu.m_SettingsArea != None && m_InGameMenu.m_SettingsArea.m_ControlsArea != None)
				m_InGameMenu.m_SettingsArea.m_ControlsArea.m_MessageBox = None;
		}
		return; // Block all controller input during keybind popup
	}

	// Joshua - Auto-detect controller vs keyboard based on input
	if (Msg == WM_KeyDown || Msg == WM_KeyUp)
	{
		// Controller keys are 196-215
		if (Key >= 196 && Key <= 215)
		{
			m_bControllerModeActive = true;
			bDisableMouseDisplay = true;

			if (!bWasControllerMode)
				OnControllerModeChanged(true);
		}
		else if (Key > 0)
		{
			m_bControllerModeActive = false;
			bDisableMouseDisplay = false;

			if (bWasControllerMode)
				OnControllerModeChanged(false);
		}
	}
	// Mouse events also disable controller mode
	else if (Msg == WM_LMouseDown || Msg == WM_RMouseDown || Msg == WM_MMouseDown ||
	         Msg == WM_MouseWheelUp || Msg == WM_MouseWheelDown)
	{
		m_bControllerModeActive = false;
		bDisableMouseDisplay = false;  // Show mouse cursor for mouse input

		if (bWasControllerMode)
			OnControllerModeChanged(false);
	}

	if (Msg == WM_Paint)
	{
		if (Console.GetStateName() == 'UWindow')
		{
			Paint(C, X, Y);
			PaintClients(C, X, Y);
			AfterPaint(C, X, Y);
		}
	}
	else
		Super.WindowEvent(Msg, C, X, Y, Key);
}

// Joshua - Called when controller mode changes
// bControllerMode: true = switched to controller, false = switched to keyboard/mouse
function OnControllerModeChanged(bool bControllerMode)
{
	// When switching to controller mode, move mouse cursor off-screen to clear hover effects
	if (bControllerMode)
	{
		Root.SetMousePos(0, 0);
	}

	// Notify in-game menu to update tab selections
	if (m_InGameMenu != None && m_InGameMenu.WindowIsVisible())
	{
		m_InGameMenu.OnControllerModeChanged(bControllerMode);
	}

	// Notify player menu to update button labels
	if (m_PlayerWidget != None && m_PlayerWidget.WindowIsVisible())
	{
		m_PlayerWidget.OnControllerModeChanged(bControllerMode);
	}

	// Notify save game menu to update button labels
	if (m_SaveGameWidget != None && m_SaveGameWidget.WindowIsVisible())
	{
		m_SaveGameWidget.OnControllerModeChanged(bControllerMode);
	}

	// Notify options menu to update button labels
	if (m_OptionsWidget != None && m_OptionsWidget.WindowIsVisible())
	{
		m_OptionsWidget.OnControllerModeChanged(bControllerMode);
	}
}

// Joshua - Check if we should start in controller mode (called at menu creation)
// This is used when quitting to main menu via controller - the flag is set in Player.Console (Interaction)
function CheckStartInControllerMode()
{
	if (GetPlayerOwner().Player.Console.bStartInControllerMode)
	{
		m_bControllerModeActive = true;
		bDisableMouseDisplay = true;
		GetPlayerOwner().Player.Console.bStartInControllerMode = false;  // Clear the flag after using it
	}
}

// Check valid CD in
function bool CheckCD()
{
	if (!m_FileManager.ValidateCD())
	{
		PopCD();
		return false;
	}
	return true;
}

function PopCD()
{
    // MClarke - MC2
	//m_MessageBox = m_MessageBoxCW.CreateMessageBox(self, "POPCD", Localize("HUD", "CD_WARNING", "Localization\\HUD"), MB_OK, MR_OK);
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
	if (m_MessageBox != W)
		return;
	m_MessageBox = None;
	CheckCD();
}

function AfterPaint(Canvas C, float X, float Y)
{
	if (bSkipLaptopOverlay)
		return;
    if (m_CurrentWidget != None || m_MessageBox != None)
	    PostRender(C , X, Y);
}


function SetupFonts()
{
	local EchelonGameInfo GameInfo;

	//
	// NORMAL FONT
	//
    if (ForceSmallFonts)
    {
        Fonts[F_Normal]     = Font'ETextFont';
	    Fonts[F_Bold]       = Font'ETextFont';
	    Fonts[F_Large]      = Font'ETextFont';
	    Fonts[F_LargeBold]  = Font'ETextFont';
    }
    else
    {
		// Joshua - Check font type from game info
		GameInfo = EchelonGameInfo(GetPlayerOwner().Level.Game);
		if (GameInfo != None)
		{
			switch(GameInfo.FontType)
			{
				case Font_PC:
				case Font_Xbox: // Joshua - Xbox font remains the PC font in PC menus due to the Xbox font being too large
					Fonts[F_Normal] = Font'ETextFont';
					break;
				case Font_GameCube:
					Fonts[F_Normal] = Font'ETextFontGameCube';
					break;
				default:
					Fonts[F_Normal] = Font'ETextFont';
					break;
			}
		}
		else
		{
			Fonts[F_Normal] = Font'ETextFont';
		}

	    Fonts[F_Bold]       = Font'EMissionFont';
	    Fonts[F_Large]      = Font'ETitleFont';
	    Fonts[F_LargeBold]  = Font'ETitleBoldFont';
		//Fonts[4]			= Font'ETextFontXbox'; // Joshua - Xbox Font support
		//Fonts[5]			= Font'ETextFontGameCube'; // Joshua - GameCube Font support
    }

	//
	// EXTENDED FONT
	//
    //Fonts[F_Normal]     = Font'LocalizedTrueType';
	//Fonts[F_Bold]       = Font'LocalizedTrueType';
	//Fonts[F_Large]      = Font'LocalizedTrueType';
	//Fonts[F_LargeBold]  = Font'LocalizedTrueType';
	// Joshua - Commented out because to disable Russian language font
}

defaultproperties
{
    ETPixel=Texture'HUD.HUD.ETPixel'
    PdaBorder=Shader'HUD.HUD.ETMENU_specu'
    PdaBackGround=Texture'HUD.HUD.palm_bkg'
    TitleFont=2
    LookAndFeelClass="EchelonMenus.EchelonMenusLookAndFeel"
}