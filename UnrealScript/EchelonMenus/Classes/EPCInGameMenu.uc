//=============================================================================
//  EPCInGameMenu.uc : In game Menu containing Inventory, Settings, Intel
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/04 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameMenu extends EPCMenuPage
			native;

var EPCTextButton   m_MainMenu, m_GoToGame;
var INT             m_IMainButtonsXPos, m_IMainButtonsHeight, m_IMainButtonsWidth, m_IMainButtonsYPos, m_IGoToGameButtonXPos; 

var EPCInGameMenuMainButtons   m_BInventory ,m_BSaveLoad, m_BSettings, m_BMissionInfo;
var INT             m_IYFirstButtonPos, m_IYButtonOffset, m_IButtonHeight, m_IXButtonPos, m_IButtonWidth;

var EPCInGameMissionInfoArea m_MissionInfoArea;
var EPCInGameInventoryArea   m_InventoryArea;
var EPCInGameSettingsArea    m_SettingsArea;
var EPCInGameSaveLoadArea    m_SaveLoadArea;
var EPCInGameSectionInfoArea m_SectionInfoArea;
var UWindowWindow            m_SelectedArea;

var INT                      m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight;

var EPCMessageBox        m_MessageBoxMain, m_MessageBoxSettings;
var BOOL                 m_bStartGame;  //Return to game after answering the massage box
var BOOL                 m_bAskExitToMenu;

function Created()
{

    m_MainMenu  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_MainMenu.SetButtonText(Caps(Localize("HUD","MAINMENU","Localization\\HUD")) ,TXT_CENTER);
    m_MainMenu.Font = F_Normal;

    m_GoToGame = EPCTextButton(CreateControl(class'EPCTextButton', m_IGoToGameButtonXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_GoToGame.SetButtonText(Caps(Localize("HUD","BACK_TO_GAME","Localization\\HUD")) ,TXT_CENTER);
    m_GoToGame.Font = F_Normal;

    m_BInventory = EPCInGameMenuMainButtons(CreateControl(class'EPCInGameMenuMainButtons', m_IXButtonPos, m_IYFirstButtonPos, m_IButtonWidth, m_IButtonHeight, self));    
    m_BInventory.SetupTextures(EchelonLevelInfo(GetLevel()).TICON.inv_ic_inv);
    m_BInventory.ToolTipString = Caps(Localize("HUD","INVENTORY","Localization\\HUD"));

    m_BMissionInfo = EPCInGameMenuMainButtons(CreateControl(class'EPCInGameMenuMainButtons', m_IXButtonPos, m_BInventory.Wintop + m_IButtonHeight + m_IYButtonOffset, m_IButtonWidth, m_IButtonHeight, self));
    m_BMissionInfo.SetupTextures(EchelonLevelInfo(GetLevel()).TICON.inv_ic_goals_notes);    
    m_BMissionInfo.ToolTipString = Caps(Localize("HUD","MISSIONINFORMATION","Localization\\HUD"));
    
    m_BSettings = EPCInGameMenuMainButtons(CreateControl(class'EPCInGameMenuMainButtons', m_IXButtonPos, m_BMissionInfo.Wintop + m_IButtonHeight + m_IYButtonOffset, m_IButtonWidth, m_IButtonHeight, self));
    m_BSettings.SetupTextures(EchelonLevelInfo(GetLevel()).TICON.inv_ic_menus);
    m_BSettings.ToolTipString = Caps(Localize("HUD","SETTINGS","Localization\\HUD"));

    m_BSaveLoad = EPCInGameMenuMainButtons(CreateControl(class'EPCInGameMenuMainButtons', m_IXButtonPos, m_BSettings.Wintop + m_IButtonHeight + m_IYButtonOffset, m_IButtonWidth, m_IButtonHeight, self));
    m_BSaveLoad.SetupTextures(EchelonLevelInfo(GetLevel()).TICON.inv_ic_save);
    m_BSaveLoad.ToolTipString = Caps(Localize("HUD","SAVELOAD","Localization\\HUD"));

    m_MissionInfoArea = EPCInGameMissionInfoArea(CreateWindow(class'EPCInGameMissionInfoArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_InventoryArea = EPCInGameInventoryArea(CreateWindow(class'EPCInGameInventoryArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));    
    m_SettingsArea = EPCInGameSettingsArea(CreateWindow(class'EPCInGameSettingsArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));    
    m_SaveLoadArea = EPCInGameSaveLoadArea(CreateWindow(class'EPCInGameSaveLoadArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));    
    m_SectionInfoArea = EPCInGameSectionInfoArea(CreateWindow(class'EPCInGameSectionInfoArea', m_IAreaXPos - 8, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    
    ChangeMenuSection(m_BSaveLoad);
 
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	GetLevel().bIsInGameMenu = true;
    Render(C , MouseX, MouseY);	
}


function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_MainMenu:            
			if (m_SettingsArea.m_SoundsArea.m_bModified || m_SettingsArea.m_GraphicArea.m_bModified || m_SettingsArea.m_ControlsArea.m_bModified || m_SettingsArea.m_EnhancedArea.m_bModified) // Joshua - Added Enhance area
			{
				m_bAskExitToMenu = true;
				m_MessageBoxSettings = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD")), Caps(Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
			}
			else
			{
				m_bAskExitToMenu = false;
	            m_MessageBoxMain = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","QUITCURRENTGAME","Localization\\HUD")), Localize("OPTIONS","QUITCURRENTGAMEMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
			}
            break;   
        case m_GoToGame:
			if (GetPlayerOwner().CanGoBackToGame() && !m_SaveLoadArea.m_SaveArea.WindowIsVisible())
			{
				if (m_SettingsArea.m_SoundsArea.m_bModified || m_SettingsArea.m_GraphicArea.m_bModified || m_SettingsArea.m_ControlsArea.m_bModified || m_SettingsArea.m_EnhancedArea.m_bModified) // Joshua - Added Enhance area
				{
					m_bStartGame = true;    //Return to game after Message box
					m_MessageBoxSettings = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD")), Caps(Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
				}                
				else
					EPCConsole(Root.Console).LaunchGame();           
			}
            
            break;
        case m_BInventory:
        case m_BMissionInfo:
        case m_BSettings:        
        case m_BSaveLoad:        
            if (UWindowButton(C).m_bSelected == false)
            {
                if (m_SettingsArea.m_SoundsArea.m_bModified || m_SettingsArea.m_GraphicArea.m_bModified || m_SettingsArea.m_ControlsArea.m_bModified || m_SettingsArea.m_EnhancedArea.m_bModified) // Joshua - Added Enhance area
                    m_MessageBoxSettings = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD")), Caps(Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);

                ChangeMenuSection(UWindowButton(C));
            }                
            break;

        }
    }
    if (E == DE_Enter)
    {
        switch (C)
        {
        case m_BInventory:
        case m_BMissionInfo:
        case m_BSettings:        
        case m_BSaveLoad:
			switch (C)
			{
			case m_BInventory:
				m_SectionInfoArea.WinTop = m_BInventory.WinTop + 11;
				break;
			case m_BMissionInfo:
				m_SectionInfoArea.WinTop = m_BMissionInfo.WinTop + 11;
				break;
			case m_BSettings:
				m_SectionInfoArea.WinTop = m_BSettings.WinTop + 11;
				break;
			case m_BSaveLoad:
				m_SectionInfoArea.WinTop = m_BSaveLoad.WinTop + 11;
				break;
			}
	        m_SectionInfoArea.SetHelpText(C.ToolTipString);
			m_SectionInfoArea.ShowWindow();    
            break;
        }
    }
    if (E == DE_Exit)
    {
        switch (C)
        {
        case m_BInventory:
        case m_BMissionInfo:
        case m_BSettings:        
        case m_BSaveLoad:
			m_SectionInfoArea.HideWindow();
            break;
        }
    }
}

//Go Back to main menu with escape:
function EscapeMenu()
{
	if (m_SaveLoadArea.m_bSkipOne)
	{
		Root.PlayClickSound();
		m_SaveLoadArea.m_bSkipOne = false;
	}
	else if (m_SettingsArea.m_ControlsArea.m_MessageBox == none)
		Notify(m_GoToGame, DE_Click);
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{  
    local EPCGameOptions GO;

    if ((m_MessageBoxMain != None) && (m_MessageBoxMain == W))
    {
        m_MessageBoxMain = None;

        if (Result == MR_Yes)
        {
			GetLevel().ConsoleCommand("Open menu\\menu");
        }
    }    
    else if ((m_MessageBoxSettings != None) && (m_MessageBoxSettings == W))
    {

        m_MessageBoxSettings = None;

        if (Result == MR_Yes)
        {
            //We chose to accept Settings Change
			GO = class'Actor'.static.GetGameOptions();
			GO.oldResolution = GO.Resolution;
			GO.oldEffectsQuality = GO.EffectsQuality;
			GO.oldShadowResolution = GO.ShadowResolution;

            m_SettingsArea.m_GraphicArea.SaveOptions();
            m_SettingsArea.m_SoundsArea.SaveOptions();
            m_SettingsArea.m_ControlsArea.SaveOptions();
            m_SettingsArea.m_EnhancedArea.SaveOptions();  // Joshua - Added Enhance area
            
            GO.UpdateEngineSettings();
			
        }
        else
        {
            //We chose to deny settings change
            GetPlayerOwner().LoadKeyboard();    //We make sure we don't take any keyboard modification in consideration
        }
            
		m_SettingsArea.m_GraphicArea.m_bModified  = false;
		m_SettingsArea.m_SoundsArea.m_bModified   = false;
		m_SettingsArea.m_ControlsArea.m_bModified = false;
        m_SettingsArea.m_EnhancedArea.m_bModified = false;  // Joshua - Added Enhance area
        
        if (m_bStartGame)
        {
            m_bStartGame = false;
            EPCConsole(Root.Console).LaunchGame();
        }
		else if (m_bAskExitToMenu)
		{
			m_bAskExitToMenu = false;
			m_MessageBoxMain = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","QUITCURRENTGAME","Localization\\HUD")), Localize("OPTIONS","QUITCURRENTGAMEMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
		}

        
    }
	GetLevel().bIsInGameMenu = false;
}

//A New game  was saved refresh the menu list
function GameSaved(bool success)
{
	if (m_SaveLoadArea.WindowIsVisible())
		m_SaveLoadArea.GameSaved(success);
}

function GameLoaded(bool success)
{
	if (m_SaveLoadArea.WindowIsVisible())
		m_SaveLoadArea.GameLoaded(success);
}

//Called when we return from game
function Reset()
{
    local EPlayerController EPC;
    local EPCFileManager FileManager;
    local String ProfilePath;

    EPC = EPlayerController(GetPlayerOwner());

    if (EPC.eGame.bPermadeathMode && EPC.bProfileDeletionPending)
    {
        FileManager = EPCMainMenuRootWindow(Root).m_FileManager;
        if (FileManager != None)
        {
            ProfilePath = "..\\Save\\"$EPC.playerInfo.PlayerName;
            FileManager.DeleteDirectory(ProfilePath, true);
            
            GetLevel().ConsoleCommand("Open menu\\menu");
            return;
        }
    }     

    m_MissionInfoArea.Reset();
    m_InventoryArea.Reset();
    m_SaveLoadArea.Reset();
    m_SettingsArea.Reset();   
}

function GoToSaveLoadArea()
{
	ChangeMenuSection(m_BSaveLoad);
	m_SaveLoadArea.ChangeMenuSection(m_SaveLoadArea.m_LoadGameButton);
}

function CheckSubMenu()
{
	local EPlayerController EPC;

	EPC = EPlayerController(GetPlayerOwner());

	if (EPC != None && (EPC.bNewGoal || EPC.bNewNote || EPC.bNewRecon))
	{
		ChangeMenuSection(m_BMissionInfo);
		m_MissionInfoArea.SelectArea(EPC.bNewGoal, EPC.bNewNote, EPC.bNewRecon);
	}
}

function ChangeMenuSection(UWindowButton _SelectMe)
{
    m_BInventory.m_bSelected    =  false;
    m_BMissionInfo.m_bSelected  =  false;
    m_BSettings.m_bSelected     =  false;
    m_BSaveLoad.m_bSelected     =  false;
    
    _SelectMe.m_bSelected     =  true;

    m_MissionInfoArea.HideWindow();
    m_InventoryArea.HideWindow();
    m_SettingsArea.HideWindow();
    m_SaveLoadArea.HideWindow();
    m_SectionInfoArea.HideWindow();

	m_SettingsArea.m_GraphicArea.m_bFirstRefresh  = true;
	m_SettingsArea.m_SoundsArea.m_bFirstRefresh   = true;
	m_SettingsArea.m_ControlsArea.m_bFirstRefresh = true;
    m_SettingsArea.m_EnhancedArea.m_bFirstRefresh = true;  // Joshua - Added Enhance area

	if (_SelectMe != m_InventoryArea)
		m_InventoryArea.SetCurrentItem(0);

    switch (_SelectMe)
    {
    case m_BInventory:
        m_InventoryArea.ShowWindow();
        m_SelectedArea = m_InventoryArea;
		m_InventoryArea.SetCurrentItem(m_InventoryArea.m_ISelectedItem);
        break;
    case m_BMissionInfo:
        m_MissionInfoArea.ShowWindow();
        m_SelectedArea = m_MissionInfoArea;
        break;
    case m_BSettings:
        m_SettingsArea.ShowWindow();
        m_SelectedArea =  m_SettingsArea;
        break;
    case m_BSaveLoad:
        m_SaveLoadArea.ShowWindow();
        m_SelectedArea = m_SaveLoadArea;
        break;
    }
}

defaultproperties
{
    m_IMainButtonsXPos=68
    m_IMainButtonsHeight=18
    m_IMainButtonsWidth=240
    m_IMainButtonsYPos=353
    m_IGoToGameButtonXPos=330
    m_IYFirstButtonPos=95
    m_IYButtonOffset=5
    m_IButtonHeight=57
    m_IXButtonPos=70
    m_IButtonWidth=47
    m_IAreaXPos=126
    m_IAreaYPos=90
    m_IAreaWidth=450
    m_IAreaHeight=250
}