//=============================================================================
//  EPCInGameMenu.uc : In game Menu containing Inventory, Settings, Intel
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/04 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameMenu extends EPCMenuPage
			native;

#exec OBJ LOAD FILE=..\Textures\HUD_Enhanced.utx

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

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
// Joshua - Display profile name and difficulty on pause screen
var UWindowLabelControl m_ProfileLabel, m_DifficultyLabel;
var INT                 m_IProfileLabelXPos, m_IProfileLabelYPos, m_IDifficultyLabelXPos;

// Joshua - Controller navigation for section selection
var int  m_selectedSection;  // 0=Inventory, 1=MissionInfo, 2=Settings, 3=SaveLoad
var bool m_bInSection;       // True when inside a section (controlling tabs/content)
var bool m_bJustExitedSection; // True for one frame after exiting a section (to prevent double B press)
var bool m_bBottomButtonsHidden; // Joshua - Track if bottom buttons are currently hidden

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    local string PlayerName;
    local string DifficultyString;

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

    // Joshua - Display profile name and difficulty on pause screen
    m_ProfileLabel = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IProfileLabelXPos, m_IProfileLabelYPos, 200, 18, self));
    m_DifficultyLabel = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IDifficultyLabelXPos, m_IProfileLabelYPos, 200, 18, self));
    m_ProfileLabel.SetLabelText(GetPlayerOwner().playerInfo.PlayerName, TXT_LEFT);
    m_DifficultyLabel.SetLabelText(string(GetPlayerOwner().playerInfo.Difficulty), TXT_RIGHT);
    m_ProfileLabel.Font = F_Normal;
    m_DifficultyLabel.Font = F_Normal;

    PlayerName = GetPlayerOwner().playerInfo.PlayerName;

    switch (GetPlayerOwner().playerInfo.Difficulty)
    {
        case 0:
            DifficultyString = Localize("HUD","Normal","Localization\\HUD");
            break;
        case 1:
            DifficultyString = Localize("HUD","Hard","Localization\\HUD");
            break;
        case 2:
            DifficultyString = Localize("Common","Elite","Localization\\Enhanced");
            break;
        case 3:
            DifficultyString = Localize("Common","HardPermadeath","Localization\\Enhanced");
            break;
        case 4:
            DifficultyString = Localize("Common","ElitePermadeath","Localization\\Enhanced");
            break;
        default:
            DifficultyString = "";
    }

    m_ProfileLabel.SetLabelText(Localize("PlayerStats","Profile","Localization\\Enhanced") @ PlayerName, TXT_LEFT);
    m_DifficultyLabel.SetLabelText(Localize("PlayerStats","Difficulty","Localization\\Enhanced") @ DifficultyString, TXT_RIGHT);
    m_ProfileLabel.TextColor.R = 51;
    m_ProfileLabel.TextColor.G = 51;
    m_ProfileLabel.TextColor.B = 51;
    m_ProfileLabel.TextColor.A = 255;

    m_DifficultyLabel.TextColor.R = 51;
    m_DifficultyLabel.TextColor.G = 51;
    m_DifficultyLabel.TextColor.B = 51;
    m_DifficultyLabel.TextColor.A = 255;

    // Joshua - Initialize auto-scroll variables
    m_heldKey = 0;
    m_keyHoldTime = 0.0;
    m_nextRepeatTime = 0.0;

    ChangeMenuSection(m_BSaveLoad);
}

function Paint(Canvas C, float MouseX, float MouseY)
{
    local bool bControllerMode;

	GetLevel().bIsInGameMenu = true;
    Render(C , MouseX, MouseY);

    bControllerMode = EPCMainMenuRootWindow(Root).m_bControllerModeActive;

    // Joshua - Only call ShowWindow/HideWindow when state changes to avoid breaking keybinds
    if (bControllerMode)
    {
        if (!m_bBottomButtonsHidden)
        {
            m_MainMenu.HideWindow();
            m_GoToGame.HideWindow();
            m_bBottomButtonsHidden = true;
        }
        DrawControllerPrompts(C);
    }
    else
    {
        if (m_bBottomButtonsHidden)
        {
            m_MainMenu.ShowWindow();
            m_GoToGame.ShowWindow();
            m_bBottomButtonsHidden = false;
        }
    }
}

// Joshua - Draw controller button prompts at the bottom
function DrawControllerPrompts(Canvas C)
{
    local EchelonLevelInfo eLevel;
    local EPlayerController EPC;
    local float PromptX, PromptY;
    local float IconSize;
    local float TextWidth, TextHeight;
    local string PromptText;
    local Color IconColor;
    local Color TextColor;
    local bool bHideAButton;

    eLevel = EchelonLevelInfo(GetLevel());
    if (eLevel == None || eLevel.TMENU == None)
        return;

    EPC = EPlayerController(GetPlayerOwner());

    IconSize = 22;
    PromptY = m_IMainButtonsYPos - 2;
    PromptX = 68;

    IconColor.R = 128;
    IconColor.G = 128;
    IconColor.B = 128;
    IconColor.A = 255;

    TextColor.R = 71;
    TextColor.G = 71;
    TextColor.B = 71;
    TextColor.A = 255;

    C.Font = Root.Fonts[F_Normal];

    // Determine if A button should be hidden
    // Hide A for Inventory when inside tab content (SC-20K, Gadgets, Items are view-only)
    // Hide A for MissionInfo Goals/Notes content (no selectable items)
    bHideAButton = false;
    if (m_bInSection)
    {
        if (m_SelectedArea == m_InventoryArea)
        {
            // Inventory tabs are view-only when inside content, no A button needed
            if (m_InventoryArea.m_bInContent)
            {
                bHideAButton = true;
            }
        }
        else if (m_SelectedArea == m_MissionInfoArea)
        {
            // Hide A when inside Goals (0) or Notes (1) content
            if (m_MissionInfoArea.m_bInContent && (m_MissionInfoArea.m_selectedTab == 0 || m_MissionInfoArea.m_selectedTab == 1))
            {
                bHideAButton = true;
            }
        }
    }

    // (A) Select - shown unless explicitly hidden
    if (!bHideAButton)
    {
        C.DrawColor = IconColor;
        C.SetPos(PromptX, PromptY);
        switch (EPC.ControllerIcon)
        {
            case CI_PlayStation:
                C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.PS2_Cross', IconSize, IconSize, 3, 3, 26, 26);
                break;
            case CI_GameCube:
                C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.GameCube_A', IconSize, IconSize, 3, 3, 26, 26);
                break;
            default: // CI_Xbox or CI_None
                C.DrawTile(Texture'HUD.HUD.ETMENU', IconSize, IconSize, 188, 1, 22, 22);
                break;
        }
        PromptX += IconSize + 8;
        C.DrawColor = TextColor;
        C.SetPos(PromptX, PromptY + 3);
        PromptText = Caps(Localize("HUD", "Select", "Localization\\HUD"));
        C.DrawText(PromptText);
        C.TextSize(PromptText, TextWidth, TextHeight);
        PromptX += TextWidth + 15;
    }

    // (B) Back/Return to Game - always shown
    C.DrawColor = IconColor;
    C.SetPos(PromptX, PromptY);
    switch (EPC.ControllerIcon)
    {
        case CI_PlayStation:
            C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.PS2_Circle', IconSize, IconSize, 3, 3, 26, 26);
            break;
        case CI_GameCube:
            C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.GameCube_B', IconSize, IconSize, 3, 3, 26, 26);
            break;
        default: // CI_Xbox or CI_None
            C.DrawTile(Texture'HUD.HUD.ETMENU', IconSize, IconSize, 139, 0, 22, 22);
            break;
    }
    PromptX += IconSize + 8;
    C.DrawColor = TextColor;
    C.SetPos(PromptX, PromptY + 3);
    // Show "Back" when in section, "Back to Game" when at top level
    //if (m_bInSection)
        PromptText = Caps(Localize("HUD", "Back", "Localization\\HUD"));
    //else
    //  PromptText = Caps(Localize("HUD", "BACK_TO_GAME", "Localization\\HUD"));
    C.DrawText(PromptText);
    C.TextSize(PromptText, TextWidth, TextHeight);
    PromptX += TextWidth + 15;

    // (X) Main Menu - shown at top level (same position as BACK TO GAME button)
    if (!m_bInSection)
    {
        PromptX = m_IGoToGameButtonXPos;  // Position at BACK TO GAME button location
        C.DrawColor = IconColor;
        C.SetPos(PromptX, PromptY);
        switch (EPC.ControllerIcon)
        {
            case CI_PlayStation:
                C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.PS2_Square', IconSize, IconSize, 3, 3, 26, 26);
                break;
            case CI_GameCube:
                C.SetPos(PromptX + 4, PromptY); // Center the 14-wide icon in 22-wide space
                C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.GameCube_X', 14, IconSize, 4, 16, 23, 36);
                break;
            default: // CI_Xbox or CI_None
                C.DrawTile(Texture'HUD.HUD.ETMENU', IconSize, IconSize, 163, 1, 22, 22);
                break;
        }
        PromptX += IconSize + 8;
        C.DrawColor = TextColor;
        C.SetPos(PromptX, PromptY + 3);
        PromptText = Caps(Localize("HUD", "MAINMENU", "Localization\\HUD"));
        C.DrawText(PromptText);
    }
}


function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_MainMenu:
			if (m_SettingsArea.m_SoundsArea.m_bModified || m_SettingsArea.m_GraphicArea.m_bModified || m_SettingsArea.m_ControlsArea.m_bModified || m_SettingsArea.m_EnhancedArea.m_bModified) // Joshua - Added Enhanced area
			{
				m_bAskExitToMenu = true;
				m_heldKey = 0;
				m_keyHoldTime = 0;
				m_MessageBoxSettings = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD")), Caps(Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
			}
			else
			{
				m_bAskExitToMenu = false;
				m_heldKey = 0;
				m_keyHoldTime = 0;
	            m_MessageBoxMain = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","QUITCURRENTGAME","Localization\\HUD")), Localize("OPTIONS","QUITCURRENTGAMEMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
			}
            break;
        case m_GoToGame:
            // Joshua - No longer using window for Save tab
			if (GetPlayerOwner().CanGoBackToGame() /*&& !m_SaveLoadArea.m_SaveArea.WindowIsVisible()*/)
			{
				if (m_SettingsArea.m_SoundsArea.m_bModified || m_SettingsArea.m_GraphicArea.m_bModified || m_SettingsArea.m_ControlsArea.m_bModified || m_SettingsArea.m_EnhancedArea.m_bModified) // Joshua - Added Enhanced area
				{
					m_bStartGame = true;    //Return to game after Message box
					m_heldKey = 0;
					m_keyHoldTime = 0;
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
                if (m_SettingsArea.m_SoundsArea.m_bModified || m_SettingsArea.m_GraphicArea.m_bModified || m_SettingsArea.m_ControlsArea.m_bModified || m_SettingsArea.m_EnhancedArea.m_bModified) // Joshua - Added Enhanced area
                {
                    m_heldKey = 0;
                    m_keyHoldTime = 0;
                    m_MessageBoxSettings = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD")), Caps(Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
                }

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
            // Joshua - Remember controller mode for main menu (use Player.Console which persists across levels)
            GetPlayerOwner().Player.Console.bStartInControllerMode = EPCMainMenuRootWindow(Root).m_bControllerModeActive;
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
            m_SettingsArea.m_EnhancedArea.SaveOptions();  // Joshua - Added Enhanced area

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
        m_SettingsArea.m_EnhancedArea.m_bModified = false;  // Joshua - Added Enhanced area

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

    // Joshua - Sync controller navigation state
    SyncSectionIndex();
}

function GoToSaveLoadArea()
{
	ChangeMenuSection(m_BSaveLoad);
	m_SaveLoadArea.ChangeMenuSection(m_SaveLoadArea.m_LoadGameButton);
}

// Joshua - Go directly to Data Details page for a specific recon (datastick)
// Used when player pauses while a new datastick notification is showing
function GoToDataDetails(ERecon Recon)
{
	if (Recon == None)
		return;

	// Navigate to Mission Info -> Data tab first (for proper back navigation)
	ChangeMenuSection(m_BMissionInfo);
	m_MissionInfoArea.ChangeMenuSection(m_MissionInfoArea.m_DataButton);
	m_MissionInfoArea.m_DataArea.FillListBox();

	// Now switch directly to the data details page
	Root.ChangeCurrentWidget(WidgetID_InGameDataDetails);
	EPCMainMenuRootWindow(Root).m_InGameDataDetailsWidget.SetDataInfo(Recon);

	// Joshua - Mark that we came from QuickView so Back button can return to game directly
	EPCMainMenuRootWindow(Root).m_InGameDataDetailsWidget.m_bFromQuickView = true;
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

	// Joshua - Sync controller navigation after potential section change
	SyncSectionIndex();
}

function ChangeMenuSection(UWindowButton _SelectMe)
{
    // Joshua - If controller is focused into a section, exit it first
    // This keeps controller state in sync when mouse clicks a different section
    if (m_bInSection)
    {
        m_bInSection = false;
        m_InventoryArea.EnableArea(false);
        m_MissionInfoArea.EnableArea(false);
        m_SettingsArea.EnableArea(false);
        m_SaveLoadArea.EnableArea(false);
    }

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
    m_SettingsArea.m_EnhancedArea.m_bFirstRefresh = true;  // Joshua - Added Enhanced area

	if (_SelectMe != m_InventoryArea)
		m_InventoryArea.SetCurrentItem(0);

    switch (_SelectMe)
    {
    case m_BInventory:
        m_InventoryArea.ShowWindow();
        m_SelectedArea = m_InventoryArea;
        // Joshua - In controller mode when just hovering (not in section),
        // suppress video and clear item display (similar to Xbox)
        if (EPCMainMenuRootWindow(Root).m_bControllerModeActive && !m_bInSection)
        {
            m_InventoryArea.m_bSuppressVideoOnSetCurrentItem = true;
            m_InventoryArea.SetCurrentItem(m_InventoryArea.m_ISelectedItem);
            m_InventoryArea.m_bSuppressVideoOnSetCurrentItem = false;
            m_InventoryArea.ClearItemContentDisplay();
        }
        else
        {
            m_InventoryArea.SetCurrentItem(m_InventoryArea.m_ISelectedItem);
        }
        m_selectedSection = 0;  // Joshua - Sync controller section index
        break;
    case m_BMissionInfo:
        m_MissionInfoArea.ShowWindow();
        m_SelectedArea = m_MissionInfoArea;
        m_selectedSection = 1;  // Joshua - Sync controller section index
        break;
    case m_BSettings:
        m_SettingsArea.ShowWindow();
        m_SelectedArea =  m_SettingsArea;
        m_selectedSection = 2;  // Joshua - Sync controller section index
        break;
    case m_BSaveLoad:
        m_SaveLoadArea.ShowWindow();
        m_SelectedArea = m_SaveLoadArea;
        m_selectedSection = 3;  // Joshua - Sync controller section index
        break;
    }
}


// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    // Check if keybind message box is open before calling Super
    // This prevents Super from closing the box, which would cause the check to fail
    local bool bMessageBoxOpen;
    bMessageBoxOpen = (m_SettingsArea != None && m_SettingsArea.m_ControlsArea != None && m_SettingsArea.m_ControlsArea.m_MessageBox != None);

    // Check if any message box is open
    if (m_MessageBoxSettings != None || m_MessageBoxMain != None)
        bMessageBoxOpen = true;

    Super.WindowEvent(Msg, C, X, Y, Key);

    // If keybind message box was open, don't process any controller input
    // This prevents section changes while rebinding keys
    if (bMessageBoxOpen)
        return;

    // Joshua - If we just exited a section (SectionExited was called during Super.WindowEvent),
    // ignore this input event to prevent the B press from being processed twice
    if (Msg == WM_KeyDown && m_bJustExitedSection)
    {
        m_bJustExitedSection = false;
        return;
    }

    // Only handle input when not in a section (handle on KeyDown for responsiveness)
    if (Msg == WM_KeyDown && !m_bInSection)
    {
        // Track held key for auto-repeat (only for navigation keys)
        if (Key == 212 || Key == 196 || Key == 213 || Key == 197)
        {
            if (m_heldKey != Key)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0.0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        // Handle section buttons navigation
        switch (Key)
        {
            // A Button - Select
            case 200:
                EnterSection();
                break;

            // B Button - Back to game
            case 201:
                Notify(m_GoToGame, DE_Click);
                break;

            // X Button - Main Menu
            case 202:
                Root.PlayClickSound();
                Notify(m_MainMenu, DE_Click);
                break;

            // Up - Previous section
            case 196:
            case 212:
                SelectPreviousSection();
                break;

            // Down - Next section
            case 197:
            case 213:
                SelectNextSection();
                break;
        }
    }
    else if (Msg == WM_KeyUp)
    {
        // Clear held key on release
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0.0;
        }
    }
}

// Joshua - Tick function for auto-repeat section navigation
function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    // Only auto-repeat when not in a section and a key is held
    if (m_bInSection || m_heldKey == 0)
        return;

    m_keyHoldTime += DeltaTime;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Navigate up - DPadUp (212) or AnalogUp (196)
        if (m_heldKey == 212 || m_heldKey == 196)
        {
            SelectPreviousSection();
        }
        // Navigate down - DPadDown (213) or AnalogDown (197)
        else if (m_heldKey == 213 || m_heldKey == 197)
        {
            SelectNextSection();
        }

        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

// Select previous section (up) - wraps around
function SelectPreviousSection()
{
    local int newSection;

    if (m_selectedSection > 0)
        newSection = m_selectedSection - 1;
    else
        newSection = 3;  // Wrap to bottom (SaveLoad)

    // Check for pending settings changes before switching
    if (HasPendingSettingsChanges() && newSection != 2)  // 2 = Settings
    {
        // Clear held key state to prevent auto-scroll while message box is shown
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_MessageBoxSettings = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD")), Caps(Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
    }

    m_selectedSection = newSection;
    UpdateSectionSelection();
    Root.PlayClickSound();
}

// Select next section (down) - wraps around
function SelectNextSection()
{
    local int newSection;

    if (m_selectedSection < 3)
        newSection = m_selectedSection + 1;
    else
        newSection = 0;  // Wrap to top (Inventory)

    // Check for pending settings changes before switching
    if (HasPendingSettingsChanges() && newSection != 2)  // 2 = Settings
    {
        // Clear held key state to prevent auto-scroll while message box is shown
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_MessageBoxSettings = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD")), Caps(Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
    }

    m_selectedSection = newSection;
    UpdateSectionSelection();
    Root.PlayClickSound();
}

// Joshua - Check if any settings areas have pending changes
function bool HasPendingSettingsChanges()
{
    return (m_SettingsArea.m_SoundsArea.m_bModified ||
            m_SettingsArea.m_GraphicArea.m_bModified ||
            m_SettingsArea.m_ControlsArea.m_bModified ||
            m_SettingsArea.m_EnhancedArea.m_bModified);
}

// Update visual selection based on m_selectedSection
function UpdateSectionSelection()
{
    switch (m_selectedSection)
    {
        case 0: ChangeMenuSection(m_BInventory); break;
        case 1: ChangeMenuSection(m_BMissionInfo); break;
        case 2: ChangeMenuSection(m_BSettings); break;
        case 3: ChangeMenuSection(m_BSaveLoad); break;
    }
}

// Enter the currently selected section
function EnterSection()
{
    m_bInSection = true;
    m_heldKey = 0;  // Joshua - Clear held key when entering section
    m_keyHoldTime = 0;
    Root.PlayClickSound();

    // Enable controller navigation for the selected section
    switch (m_selectedSection)
    {
        case 0: m_InventoryArea.EnableArea(true); break;
        case 1: m_MissionInfoArea.EnableArea(true); break;
        case 2: m_SettingsArea.EnableArea(true); break;
        case 3: m_SaveLoadArea.EnableArea(true); break;
    }
}

// Called by child sections when B is pressed at tab level
function SectionExited()
{
    m_bInSection = false;
    m_bJustExitedSection = true; // Joshua - Flag to ignore next input event (prevents double B press)

    // Joshua - Clear held key to prevent the B press that triggered this from being processed
    m_heldKey = 0;
    m_keyHoldTime = 0;

    // Disable all section areas
    m_InventoryArea.EnableArea(false);
    m_MissionInfoArea.EnableArea(false);
    m_SettingsArea.EnableArea(false);
    m_SaveLoadArea.EnableArea(false);
}

// Sync section index when menu opens (in case visual selection changed externally)
function SyncSectionIndex()
{
    if (m_BInventory.m_bSelected) m_selectedSection = 0;
    else if (m_BMissionInfo.m_bSelected) m_selectedSection = 1;
    else if (m_BSettings.m_bSelected) m_selectedSection = 2;
    else if (m_BSaveLoad.m_bSelected) m_selectedSection = 3;

    m_bInSection = false;
    m_heldKey = 0;  // Joshua - Clear held key when menu opens
    m_keyHoldTime = 0;

    // Joshua - Disable all areas when syncing (ensure clean state)
    m_InventoryArea.EnableArea(false);
    m_MissionInfoArea.EnableArea(false);
    m_SettingsArea.EnableArea(false);
    m_SaveLoadArea.EnableArea(false);

    // Always clear tab selections first (ensures clean state)
    m_SaveLoadArea.ClearTabSelections();
    m_MissionInfoArea.ClearTabSelections();
    m_InventoryArea.ClearTabSelections();
    m_SettingsArea.ClearTabSelections();

    // If not in controller mode, immediately restore them for keyboard/mouse
    if (!EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        m_SaveLoadArea.RestoreTabSelection();
        m_MissionInfoArea.RestoreTabSelection();
        m_InventoryArea.RestoreTabSelection();
        m_SettingsArea.RestoreTabSelection();
    }
}

// Joshua - Called when input mode switches between controller and keyboard/mouse
function OnControllerModeChanged(bool bControllerMode)
{
    // Pass to SaveLoadArea (for the save dialog button selectors)
    if (m_SaveLoadArea != None)
    {
        m_SaveLoadArea.OnControllerModeChanged(bControllerMode);
    }

    // Pass to SettingsArea (for child config area item selection)
    if (m_SettingsArea != None)
    {
        m_SettingsArea.OnControllerModeChanged(bControllerMode);
    }

    if (bControllerMode)
    {
        // Switched to controller mode
        if (m_bInSection)
        {
            // Joshua - Re-enable the currently selected section's area
            // This fixes softlock when switching from mouse to controller while in a section
            switch (m_selectedSection)
            {
                case 0: m_InventoryArea.EnableArea(true); break;
                case 1: m_MissionInfoArea.EnableArea(true); break;
                case 2: m_SettingsArea.EnableArea(true); break;
                case 3: m_SaveLoadArea.EnableArea(true); break;
            }
        }
        else
        {
            // Not in a section - clear tab selections
            m_SaveLoadArea.ClearTabSelections();
            m_MissionInfoArea.ClearTabSelections();
            m_InventoryArea.ClearTabSelections();
            m_SettingsArea.ClearTabSelections();

            // Joshua - If Inventory section is selected (hovering), hide video/scrollbar
            if (m_selectedSection == 0 && m_InventoryArea.WindowIsVisible())
            {
                m_InventoryArea.ClearItemContentDisplay();
            }
        }
    }
    else
    {
        // Switched to keyboard/mouse mode, restore tab selections for all areas
        m_SaveLoadArea.RestoreTabSelection();
        m_MissionInfoArea.RestoreTabSelection();
        m_InventoryArea.RestoreTabSelection();
        m_SettingsArea.RestoreTabSelection();

        // Joshua - If Inventory section is selected, show video/scrollbar for mouse
        if (m_selectedSection == 0 && m_InventoryArea.WindowIsVisible())
        {
            m_InventoryArea.RestoreItemContentDisplay();
        }
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
	//=============================================================================
	// Enhanced Variables
	//=============================================================================
    m_IProfileLabelXPos=60
    m_IProfileLabelYPos=393
    m_IDifficultyLabelXPos=381
    m_initialDelay=0.5
    m_repeatRate=0.1
}