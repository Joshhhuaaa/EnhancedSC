//=============================================================================
//  EPCInGameSaveLoadArea.uc : InGame menu allowing loading a saved game an unlocked level or saving a game
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/08 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameSaveLoadArea extends UWindowDialogClientWindow
			native;

var EPCTextButton   m_LoadGameButton, m_LoadLevelButton, m_SaveGameButton, m_LoadConfirmationButton;
var INT             m_IFirstButtonsXPos, m_IXButtonOffset, m_IButtonsHeight, m_IButtonsWidth, m_IButtonsYPos;
var INT             m_ILoadXPos, m_ILoadYPos, m_ILoadWidth, m_ILoadHeight;

var EPCLevelListBox              m_ListBox;
var EPCFileListBox          m_FileListBox;

var INT                     m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight;
var INT                     m_ISaveListBoxYPos, m_ISaveListBoxHeight;

var EPCInGameSaveGameArea m_SaveArea;

var UWindowLabelControl     m_LName;
var UWindowLabelControl     m_LDate;
var UWindowLabelControl     m_LTime;

var Color                   m_TextColor;
var INT                     m_ILabelHeight, m_NameWidth, m_LDateWidth;

var EPCMessageBox        m_MessageBox;
var EPCMessageBox        m_SavingLoadingMessageBox;
var BOOL                 m_bSkipOne;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var bool                    m_bPendingPrototypeMapLoad; // Joshua - For prototype map warning

// Joshua - Controller navigation
var bool m_bAreaEnabled;     // True when this section is active
var int  m_navRow;           // 0=tabs, 1=list
var int  m_selectedTabIndex; // 0=LoadGame, 1=Levels, 2=SaveGame (visual selection)
var int  m_lastRealTabIndex; // Joshua - The actual tab showing content (0 or 1, not Save)

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{

    // Joshua - Position save area below the tabs (same Y as list boxes) so it doesn't block tab clicks
    m_SaveArea = EPCInGameSaveGameArea(CreateWindow(class'EPCInGameSaveGameArea', 0, m_IListBoxYPos, WinWidth, WinHeight - m_IListBoxYPos, self));
    m_SaveArea.HideWindow();

    m_LoadGameButton = EPCTextButton(CreateControl(class'EPCTextButton', m_IFirstButtonsXPos, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_LoadLevelButton = EPCTextButton(CreateControl(class'EPCTextButton', m_LoadGameButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_SaveGameButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_LoadLevelButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_LoadConfirmationButton= EPCTextButton(CreateControl(class'EPCTextButton',m_ILoadXPos, m_ILoadYPos, m_ILoadWidth, m_ILoadHeight, self));

    m_LoadGameButton.SetButtonText(Caps(Localize("HUD","LOADGAME","Localization\\HUD"))    ,TXT_CENTER);
    m_LoadLevelButton.SetButtonText(Caps(Localize("HUD","LEVELS_TITLE","Localization\\HUD"))    ,TXT_CENTER);
    m_SaveGameButton.SetButtonText(Caps(Localize("HUD","SAVE","Localization\\HUD"))    ,TXT_CENTER);
    m_LoadConfirmationButton.SetButtonText(Caps(Localize("HUD","LOAD","Localization\\HUD"))    ,TXT_CENTER);

    m_LoadGameButton.Font       = EPCMainMenuRootWindow(Root).TitleFont;
    m_LoadLevelButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;
    m_SaveGameButton.Font       = EPCMainMenuRootWindow(Root).TitleFont;
    m_LoadConfirmationButton.Font       = F_Normal;

    m_ListBox           = EPCLevelListBox(CreateControl(class'EPCLevelListBox', m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight, self));
    m_ListBox.Font      = F_Normal;
    m_ListBox.Align     = TXT_CENTER;

    m_FileListBox           = EPCFileListBox(CreateControl(class'EPCFileListBox', m_IListBoxXPos, m_ISaveListBoxYPos, m_IListBoxWidth, m_ISaveListBoxHeight, self));
    m_FileListBox.Font      = F_Normal;
    m_FileListBox.NameWidth = m_NameWidth;
    m_FileListBox.DateWidth = m_LDateWidth;

    m_LName       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IListBoxXPos, m_IListBoxYPos, m_NameWidth, m_ILabelHeight, self));
    m_LName.SetLabelText(Caps(Localize("HUD","NAME","Localization\\HUD")),TXT_LEFT);
    m_LName.Font       = F_Normal;
    m_LName.TextColor  = m_TextColor;
    m_LName.m_fLMarge  = 2;

    m_LDate       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_LName.WinLeft + m_LName.WinWidth, m_IListBoxYPos, m_LDateWidth, m_ILabelHeight, self));
    m_LDate.SetLabelText(Caps(Localize("HUD","DATE","Localization\\HUD")),TXT_LEFT);
    m_LDate.Font       = F_Normal;
    m_LDate.TextColor  = m_TextColor;
    m_LDate.m_fLMarge  = 2;

    m_LTime       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_LDate.WinLeft + m_LDate.WinWidth, m_IListBoxYPos, m_IListBoxWidth - m_LDateWidth - m_NameWidth, m_ILabelHeight, self));
    m_LTime.SetLabelText(Caps(Localize("HUD","TIME","Localization\\HUD")),TXT_LEFT);
    m_LTime.Font       = F_Normal;
    m_LTime.TextColor  = m_TextColor;
    m_LTime.m_fLMarge  = 2;

    ChangeMenuSection(m_LoadGameButton);

}

function HideWindow()
{
    Super.HideWindow();
    m_SaveArea.HideWindow();
}

// Joshua - Restore proper tab content when window is shown
function ShowWindow()
{
    Super.ShowWindow();
    // Restore the correct content based on current tab selection
    switch (m_selectedTabIndex)
    {
        case 0:
            m_FileListBox.ShowWindow();
            m_LName.ShowWindow();
            m_LDate.ShowWindow();
            m_LTime.ShowWindow();
            break;
        case 1:
            m_ListBox.ShowWindow();
            break;
        case 2:
            if (m_SaveArea != None)
                m_SaveArea.ShowWindow();
            break;
    }
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);
    // Joshua - Hide PC LOAD button in controller mode (for Load Game and Levels tabs)
    // Keep it visible on Save tab (already hidden by ChangeMenuSection)
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        // Hide LOAD button in controller mode, except on Save tab (where it's already hidden)
        if (m_selectedTabIndex != 2)
            m_LoadConfirmationButton.HideWindow();
    }
    else
    {
        // Show LOAD button in keyboard/mouse mode (unless on Save tab)
        if (m_selectedTabIndex != 2)
            m_LoadConfirmationButton.ShowWindow();
    }
}

function FillListBox()
{
    local int i;
    local EPCListBoxItem L;
    local EPCFileManager FileManager;
    local EPlayerInfo    PlayerInfo;
    local String         Path;    //Do something
	local String		 Name;
    local array<string>  AllParts; // Joshua - Mission unlocked mode

    // Joshua - Added to check for Elite mode
    local EPlayerController EPC;

    PlayerInfo = GetPlayerOwner().playerInfo;
    EPC = EPlayerController(GetPlayerOwner());

    m_FileListBox.Clear();
    //Filling Save Games
    FileManager = EPCMainMenuRootWindow(Root).m_FileManager;
    Path = "..\\Save\\"$PlayerInfo.PlayerName$"\\*.en4"; // Joshua - Enhanced save games are not compatible, changing extension to avoid confusion
    FileManager.DetailedFindFiles(Path);

    for (i = 0; i < FileManager.m_pDetailedFileList.Length; i++)
    {
        L = EPCListBoxItem(m_FileListBox.Items.Append(class'EPCListBoxItem'));

		// Remove the extension (YM)
		Name = FileManager.m_pDetailedFileList[i].Filename;
		Name = Left(Name, Len(Name) - 4);
		L.Caption = Name;

        L.HelpText = FileManager.m_pDetailedFileList[i].FileDate;
        L.m_AltText = FileManager.m_pDetailedFileList[i].FileTime;
		L.szSortByToken = FileManager.m_pDetailedFileList[i].FileCompletTime;
		L.m_bReverseSort = true;
    }
	m_FileListBox.Sort();

    m_ListBox.Clear();

    //Filling Unlocked Levels
    i = 0;
    if (PlayerInfo.LevelUnlock == LU_AllParts && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode)
    {
        AllParts.Length = 31;
        AllParts[0] = "0_0_2_Training";
        AllParts[1] = "0_0_3_Training";
        AllParts[2] = "1_1_0Tbilisi";
        AllParts[3] = "1_1_1Tbilisi";
        AllParts[4] = "1_1_2Tbilisi";
        AllParts[5] = "1_2_1DefenseMinistry";
        AllParts[6] = "1_2_2DefenseMinistry";
        AllParts[7] = "1_3_2CaspianOilRefinery";
        AllParts[8] = "1_3_3CaspianOilRefinery";
        AllParts[9] = "2_1_0CIA";
        AllParts[10] = "2_1_1CIA";
        AllParts[11] = "2_1_2CIA";
        AllParts[12] = "2_2_1_Kalinatek";
        AllParts[13] = "2_2_2_Kalinatek";
        AllParts[14] = "2_2_3_Kalinatek";
        AllParts[15] = "4_1_1ChineseEmbassy";
        AllParts[16] = "4_1_2ChineseEmbassy";
        AllParts[17] = "4_2_1_Abattoir";
        AllParts[18] = "4_2_2_Abattoir";
        AllParts[19] = "4_3_0ChineseEmbassy";
        AllParts[20] = "4_3_1ChineseEmbassy";
        AllParts[21] = "4_3_2ChineseEmbassy";
        AllParts[22] = "5_1_1_PresidentialPalace";
        AllParts[23] = "5_1_2_PresidentialPalace";
        AllParts[24] = "1_6_1_1KolaCell";
        AllParts[25] = "1_7_1_1VselkaInfiltration";
        AllParts[26] = "1_7_1_2Vselka";
        AllParts[27] = "3_2_1_PowerPlant";
        AllParts[28] = "3_2_2_PowerPlant";
        AllParts[29] = "3_4_2Severonickel";
        AllParts[30] = "3_4_3Severonickel";

        for (i = 0; i < AllParts.Length; ++i)
        {
            L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
            L.Caption = AllParts[i];
            L.m_bLocked = false;
        }
    }
    else
    {
        while (PlayerInfo.UnlockedMap[i] != "")
        {
            // Joshua - Unlisting Vselka Submarine as it has been merged into Vselka Infiltration
            if (i == 12)
            {
                i++;
                continue;
            }
            L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
            L.Caption = PlayerInfo.UnlockedMap[i];

            // Original Maps
            if (i < 10)
            {
                if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode) // Joshua - Unlocks all levels, bypassing profile progression
                    L.m_bLocked = false;
                else
                    L.m_bLocked = (i > PlayerInfo.MapCompleted);
            }

            // Joshua - Police Station is automatically unlocked on Elite difficulty or Permadeath mode
            if (i == 1 && (EPC.eGame.bEliteMode || EPC.eGame.bPermadeathMode))
            {
               L.m_bLocked = false;
            }
            // Joshua - Downloadable maps require Presidential Palace to be unlocked in Enhanced
            else if (i >= 10 && i <= 12) // Kola Cell, Vselka
            {
                if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode) // Joshua - Unlocks all levels, bypassing profile progression
                    L.m_bLocked = false;
                else
                    L.m_bLocked = (PlayerInfo.MapCompleted < 9);
            }

            i++;
        }
        // Joshua - Adding cut levels to end of list
        L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
        L.Caption = "3_2_1_PowerPlant";
        if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode)
            L.m_bLocked = false;
        else
            L.m_bLocked = (PlayerInfo.MapCompleted < 9);

        L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
        L.Caption = "3_4_2Severonickel";
        if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode)
            L.m_bLocked = false;
        else
            L.m_bLocked = (PlayerInfo.MapCompleted < 9);
    }
}

function Notify(UWindowDialogControl C, byte E)
{
    local String Error;

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_LoadGameButton:
        case m_LoadLevelButton:
			ChangeMenuSection(UWindowButton(C));
			break;
        case m_SaveGameButton:
			if (GetPlayerOwner().CanSaveGame())
			{
				ChangeMenuSection(UWindowButton(C));
			}
            break;
        case m_SaveArea.m_OKButton:
            if (m_SaveArea.GetSaveName() != "")
            {
                SaveGame();
                // Joshua - Don't switch tabs here! Only switch after save actually succeeds
                // The tab switch now happens in GameSaved() when save is confirmed
            }
            break;
        case m_SaveArea.m_CancelButton:
            m_SaveArea.Clear();
            m_SaveArea.HideWindow();
            // Joshua - Cancel button returns to the last real tab (the one with actual content)
            m_navRow = 0;
            m_selectedTabIndex = m_lastRealTabIndex;
            if (m_lastRealTabIndex == 0)
                ChangeMenuSection(m_LoadGameButton);
            else
                ChangeMenuSection(m_LoadLevelButton);
            break;
        case m_LoadConfirmationButton:
            Load();
            break;
        case m_ListBox:
        case m_FileListBox:
            // Joshua - Mouse clicked on list, sync controller nav to list level
            m_navRow = 1;
            break;
        }
    }
    if ((E == DE_DoubleClick) && ((C == m_ListBox) || (C == m_FileListBox)))
    {
        Load();
    }
}

//------------------------------------------------------------------------
// Joshua - Check if selected map is a prototype map
//------------------------------------------------------------------------
function bool IsPrototypeMap(string MapName)
{
    return (MapName == "3_2_1_PowerPlant" ||
            MapName == "3_2_2_PowerPlant" ||
            MapName == "3_4_2Severonickel" ||
            MapName == "3_4_3Severonickel");
}

function Load()
{
    // Joshua - Check if this is a prototype map that needs a warning
    if (!m_LoadGameButton.m_bSelected &&
        EPCListBoxItem(m_ListBox.SelectedItem) != None &&
        !EPCListBoxItem(m_ListBox.SelectedItem).m_bLocked &&
        IsPrototypeMap(EPCListBoxItem(m_ListBox.SelectedItem).Caption))
    {
        m_bPendingPrototypeMapLoad = true;
        EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "PrototypeMap", "Localization\\Enhanced"), Localize("Common", "PrototypeMapWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);
        return;
    }

    LoadSelectedMap();
}

//------------------------------------------------------------------------
// Joshua - Converted to load selected map
//------------------------------------------------------------------------
function LoadSelectedMap()
{
	local String Error;
	local bool noLoadMap;

	// Check valid CD in
	if (!EPCMainMenuRootWindow(Root).CheckCD())
		return;

    if (m_LoadGameButton.m_bSelected)
    {
        if (m_FileListBox.SelectedItem != None)
        {
			// Joshua - Store pending load name in Console (survives load) to restore after
			EPCConsole(Root.Console).PendingLoadSaveName = EPCListBoxItem(m_FileListBox.SelectedItem).Caption;
			// Added extension (.sav) (YM)
            Error = GetPlayerOwner().ConsoleCommand("LoadGame Filename="$EPCListBoxItem(m_FileListBox.SelectedItem).Caption$".en4"); // Joshua - Enhanced save games are not compatible, changing extension to avoid confusion
			noLoadMap = true;
        }
        else
            return;

    }
    else
    {
        if ((EPCListBoxItem(m_ListBox.SelectedItem) != None) && (!EPCListBoxItem(m_ListBox.SelectedItem).m_bLocked))
        {
			Error = GetPlayerOwner().ConsoleCommand("Open "$EPCListBoxItem(m_ListBox.SelectedItem).Caption);
        }
        else
            return;
    }


    if (Error == "")
	{
		if (noLoadMap)
			MakeSaveLoadMessageBox(false);
	}
    else
        log("Load Error:"@Error);
}

function GameSaved(bool success)
{
	if (m_SavingLoadingMessageBox != None)
		m_SavingLoadingMessageBox.RestoreFromSave();

	if (success)
	{
	    FillListBox();

		// Joshua - Update LastSaveName with the newly saved game
		EPlayerController(GetPlayerOwner()).LastSaveName = m_SaveArea.GetSaveName();

		// Close de messagebox
		if (m_SavingLoadingMessageBox != None)
		{
			m_SavingLoadingMessageBox.Notify(m_SavingLoadingMessageBox.m_OKButton, DE_Click);
			EPCConsole(Root.Console).ReturnToGame();
		}
	}
	else
	{
		// Show error message
		if (m_SavingLoadingMessageBox != None)
			m_SavingLoadingMessageBox.SetupText(Localize("HUD", "SAVEFAILED", "Localization\\HUD"));
	}
}

function GameLoaded(bool success)
{
	if (m_SavingLoadingMessageBox != None)
		m_SavingLoadingMessageBox.RestoreFromSave();

	if (success)
	{
		// Close de messagebox
		if (m_SavingLoadingMessageBox != None)
		{
			m_SavingLoadingMessageBox.Notify(m_SavingLoadingMessageBox.m_OKButton, DE_Click);
			EPCConsole(Root.Console).ReturnToGame();
		}
	}
	else
	{
		// Show error message
		if (m_SavingLoadingMessageBox != None)
			m_SavingLoadingMessageBox.SetupText(Localize("HUD", "LOADFAILED", "Localization\\HUD"));
	}
}

function MakeSaveLoadMessageBox(bool saving)
{
	m_SavingLoadingMessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, "", "", MB_OK, MR_OK, MR_OK);

	if (saving)
		m_SavingLoadingMessageBox.SetupText(Localize("HUD", "SAVING", "Localization\\HUD"));
	else
		m_SavingLoadingMessageBox.SetupText(Localize("HUD", "LOADING", "Localization\\HUD"));

	m_SavingLoadingMessageBox.SetupForSave();
}

function ChangeMenuSection(UWindowButton _SelectMe)
{

    switch (_SelectMe)
    {
    case m_LoadGameButton:
        m_LoadGameButton.m_bSelected    =  true;
        m_LoadLevelButton.m_bSelected   =  false;
        m_SaveGameButton.m_bSelected    =  false;
        m_ListBox.HideWindow();
        m_FileListBox.ShowWindow();
        m_LName.ShowWindow();
        m_LDate.ShowWindow();
        m_LTime.ShowWindow();
        m_SaveArea.HideWindow();
        m_LoadConfirmationButton.ShowWindow();  // Joshua - Show LOAD button for Load Game tab
        m_selectedTabIndex = 0;  // Joshua - Keep m_selectedTabIndex in sync
        m_lastRealTabIndex = 0;  // Joshua - Track real content tab
        break;
    case m_LoadLevelButton:
        m_LoadGameButton.m_bSelected    =  false;
        m_LoadLevelButton.m_bSelected   =  true;
        m_SaveGameButton.m_bSelected    =  false;
        m_ListBox.ShowWindow();
        m_FileListBox.HideWindow();
        m_LName.HideWindow();
        m_LDate.HideWindow();
        m_LTime.HideWindow();
        m_SaveArea.HideWindow();
        m_LoadConfirmationButton.ShowWindow();  // Joshua - Show LOAD button for Levels tab
        m_selectedTabIndex = 1;  // Joshua - Keep m_selectedTabIndex in sync
        m_lastRealTabIndex = 1;  // Joshua - Track real content tab
        break;
    case m_SaveGameButton:
        // Joshua - Save tab is now a real tab that shows the save dialog as its content
        m_LoadGameButton.m_bSelected    =  false;
        m_LoadLevelButton.m_bSelected   =  false;
        m_SaveGameButton.m_bSelected    =  true;  // Always highlight Save button when on Save tab
        m_ListBox.HideWindow();
        m_FileListBox.HideWindow();
        m_LName.HideWindow();
        m_LDate.HideWindow();
        m_LTime.HideWindow();
        m_SaveArea.Clear();
        m_SaveArea.ShowWindow();
        m_LoadConfirmationButton.HideWindow();  // Joshua - Hide LOAD button on Save tab
        m_selectedTabIndex = 2;  // Joshua - Keep m_selectedTabIndex in sync
        // Joshua - Don't update m_lastRealTabIndex, Save is now a real tab
        break;
    }

}

function SaveGame()
{
    local String Error;
	local String saveName;

	Error = "";
	saveName = m_SaveArea.GetSaveName();
	if (saveName!="")
	{
		Error = GetPlayerOwner().ConsoleCommand("SAVEGAME FILENAME="$saveName);
	}

    if (Error == "ALREADY_EXIST")
    {
        m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SAVEGAMEEXISTS","Localization\\HUD")), Caps(Localize("OPTIONS","SAVEGAMEEXISTSMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
    }
	else if (Error == "INVALID_NAME")
	{
		EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, "Error, invalid file name", "Bad File Name", MB_OK, MR_OK, MR_OK);
	}
    else if ((Error != ""))
    {
        log("Save File Impossible"@Error);
    }
	else
	{
		MakeSaveLoadMessageBox(true);
	}
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    // Joshua - Prototype map warning
    if (Result == MR_OK && m_bPendingPrototypeMapLoad)
    {
        m_bPendingPrototypeMapLoad = false;
        LoadSelectedMap();
        return;
    }

    if (W == m_MessageBox)
    {
        m_MessageBox = None;

        if (Result == MR_Yes)
        {
            GetPlayerOwner().ConsoleCommand("SAVEGAME FILENAME="$m_SaveArea.GetSaveName()@"OVERWRITE=TRUE");
			MakeSaveLoadMessageBox(true);
        }
        else
        {
            // Joshua - User said No to overwrite confirmation, stay on Save tab
            // Clear the save name so they can enter a different name
            m_SaveArea.Clear();
            // Keep save area visible, stay on Save tab, return to navRow 0
            m_navRow = 0;
        }
    }
}

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
            ProfilePath = "..\\Save\\" $ EPC.playerInfo.PlayerName;
            FileManager.DeleteDirectory(ProfilePath, true);

            GetLevel().ConsoleCommand("Open menu\\menu");
            return;
        }
    }

    // Hide save dialog if it was left open
    if (m_SaveArea != None)
        m_SaveArea.HideWindow();

    // Joshua - Reset controller navigation state
    m_navRow = 0;

	if (m_LoadLevelButton.m_bSelected)
		ChangeMenuSection(m_LoadLevelButton);
	else
		ChangeMenuSection(m_LoadGameButton);

    FillListBox();
}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    m_bAreaEnabled = bEnable;
    if (bEnable)
    {
        m_navRow = 0;  // Start at tab level
        // Joshua - If on Save tab, make sure save area controller mode is disabled (user must press A to activate)
        if (m_selectedTabIndex == 2 && m_SaveArea != None)
            m_SaveArea.DisableControllerMode();
        // Restore tab selection visual when entering
        UpdateTabSelection();
        EnsureListSelection();
    }
    else
    {
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
        // In controller mode, hide tab selection bar when not in this section
        if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
        {
            ClearTabSelections();
        }
    }
}

// Joshua - Clear all tab selection visuals (for controller mode when section is not active)
function ClearTabSelections()
{
    m_LoadGameButton.m_bSelected = false;
    m_LoadLevelButton.m_bSelected = false;
    m_SaveGameButton.m_bSelected = false;
}

// Joshua - Restore tab selection based on m_selectedTabIndex (when switching to keyboard/mouse)
function RestoreTabSelection()
{
    UpdateTabSelection();
}

// Joshua - Called when global controller mode changes (from EPCInGameMenu)
function OnControllerModeChanged(bool bControllerMode)
{
    // Only propagate to the save dialog if we're actually inside it (navRow 1 on Save tab)
    // This prevents the save area from activating when pressing B to switch to controller mode
    // while at tab level or section selection level
    if (m_SaveArea != None && m_SaveArea.bWindowVisible && m_bAreaEnabled && m_navRow == 1 && m_selectedTabIndex == 2)
    {
        m_SaveArea.OnControllerModeChanged(bControllerMode);
    }
}

function SyncTabIndex()
{
    if (m_LoadGameButton.m_bSelected)
    {
        m_selectedTabIndex = 0;
        m_lastRealTabIndex = 0;
    }
    else if (m_LoadLevelButton.m_bSelected)
    {
        m_selectedTabIndex = 1;
        m_lastRealTabIndex = 1;
    }
    else if (m_SaveGameButton.m_bSelected)
    {
        m_selectedTabIndex = 2;
        // m_lastRealTabIndex stays as it was
    }
    else
    {
        m_selectedTabIndex = 0;
        m_lastRealTabIndex = 0;
    }
}

function EnsureListSelection()
{
    local UWindowListBox ListBox;

    // Only manage list selection when we're at the list level (not tab level)
    if (m_navRow != 1)
        return;

    ListBox = GetActiveListBox();
    if (ListBox != None && ListBox.SelectedItem == None && ListBox.Items.Next != None)
    {
        ListBox.SetSelectedItem(UWindowListBoxItem(ListBox.Items.Next));
    }
    if (ListBox != None)
        ListBox.MakeSelectedVisible();
}

function UWindowListBox GetActiveListBox()
{
    if (m_LoadGameButton.m_bSelected)
        return m_FileListBox;
    else if (m_LoadLevelButton.m_bSelected)
        return m_ListBox;
    return None;
}

function ClearListSelection()
{
    // Clear selection from both list boxes
    // Need to clear the bSelected flag on the item before clearing SelectedItem
    if (m_FileListBox != None)
    {
        if (m_FileListBox.SelectedItem != None)
            m_FileListBox.SelectedItem.bSelected = false;
        m_FileListBox.SelectedItem = None;
    }
    if (m_ListBox != None)
    {
        if (m_ListBox.SelectedItem != None)
            m_ListBox.SelectedItem.bSelected = false;
        m_ListBox.SelectedItem = None;
    }
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    // Don't process controller input when area is not enabled
    // Still let mouse/paint events through
    if (!m_bAreaEnabled)
    {
        // Block controller keys when area is not enabled
        if (Msg == WM_KeyDown && Key >= 196 && Key <= 215)
            return;

        Super.WindowEvent(Msg, C, X, Y, Key);
        return;
    }

    // Must check B button BEFORE calling Super to prevent parent from handling it
    if (Msg == WM_KeyDown && Key == 201)
    {
        // Handle B button ourselves
        if (m_navRow == 1)
        {
            // In list/save area - go back to tabs, clear list selection
            m_navRow = 0;
            ClearListSelection();
            // Joshua - If in Save area, disable controller mode and clear the text
            if (m_selectedTabIndex == 2 && m_SaveArea != None)
            {
                m_SaveArea.Clear();
            }
            // Stop any auto-repeat
            m_heldKey = 0;
            m_keyHoldTime = 0;
            Root.PlayClickSound();
        }
        else if (m_navRow == 0)
        {
            // At tabs - exit to section selection
            Root.PlayClickSound();
            EPCInGameMenu(ParentWindow).SectionExited();
        }
        return;  // Don't let B reach parent
    }

    Super.WindowEvent(Msg, C, X, Y, Key);

    // Skip one frame after save dialog closes (to prevent re-opening)
    if (m_bSkipOne)
    {
        m_bSkipOne = false;
        return;
    }

    // Track key releases for auto-repeat
    if (Msg == WM_KeyUp)
    {
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0;
            m_nextRepeatTime = 0;
        }
        return;
    }

    if (Msg == WM_KeyDown)
    {
        // Track repeatable keys (directional keys only)
        if (Key == 212 || Key == 196 || Key == 213 || Key == 197 ||
            Key == 214 || Key == 198 || Key == 215 || Key == 199)
        {
            if (Key != m_heldKey)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        HandleKeyDown(Key);
    }
}

function HandleKeyDown(int Key)
{
    // Joshua - When at navRow 1 on Save tab, forward controller input to save area
    if (m_navRow == 1 && m_selectedTabIndex == 2 && m_SaveArea != None)
    {
        // Only forward A and directional keys, B is handled separately in WindowEvent
        if (Key == 200 || Key == 196 || Key == 197 || Key == 198 || Key == 199 ||
            Key == 212 || Key == 213 || Key == 214 || Key == 215)
        {
            m_SaveArea.HandleControllerInput(Key);
        }
        return;
    }

    switch (Key)
    {
        // A Button - Enter list or activate
        case 200:
            if (m_navRow == 0)
            {
                // Joshua - All tabs now enter row 1 on A press
                // For Save tab, this activates the save dialog for controller input
                if (m_selectedTabIndex == 2)
                {
                    // Save tab - activate save dialog for controller navigation
                    m_navRow = 1;
                    m_SaveArea.EnableControllerMode();
                    Root.PlayClickSound();
                }
                else
                {
                    // Load/Levels tabs - enter list
                    m_navRow = 1;
                    EnsureListSelection();
                    Root.PlayClickSound();
                }
            }
            else if (m_navRow == 1)
            {
                // In list - load selected
                Load();
            }
            break;

        // B Button - handled in WindowEvent before Super call

        // Up
        case 196:
        case 212:
            if (m_navRow == 1)
                NavigateListUp();
            break;

        // Down
        case 197:
        case 213:
            if (m_navRow == 1)
                NavigateListDown();
            break;

        // Left
        case 198:
        case 214:
            if (m_navRow == 0)
                SelectPrevTab();
            break;

        // Right
        case 199:
        case 215:
            if (m_navRow == 0)
                SelectNextTab();
            break;
    }
}

function SelectPrevTab()
{
    // SaveGame tab (index 2) might not always be available
    local int maxTab;

    if (GetPlayerOwner().CanSaveGame())
        maxTab = 2;
    else
        maxTab = 1;

    // Wrap-around: left on LoadGame goes to Save (or Levels if save unavailable)
    m_selectedTabIndex = (m_selectedTabIndex - 1 + maxTab + 1) % (maxTab + 1);
    UpdateTabSelection();
    Root.PlayClickSound();
}

function SelectNextTab()
{
    // SaveGame tab (index 2) might not always be available
    local int maxTab;

    if (GetPlayerOwner().CanSaveGame())
        maxTab = 2;
    else
        maxTab = 1;

    // Wrap-around: right on Save goes to LoadGame
    m_selectedTabIndex = (m_selectedTabIndex + 1) % (maxTab + 1);
    UpdateTabSelection();
    Root.PlayClickSound();
}

function UpdateTabSelection()
{
    // Hide save area when switching away from Save tab
    if (m_SaveArea != None && m_selectedTabIndex != 2)
        m_SaveArea.HideWindow();

    switch (m_selectedTabIndex)
    {
        case 0: ChangeMenuSection(m_LoadGameButton); break;
        case 1: ChangeMenuSection(m_LoadLevelButton); break;
        case 2:
            // Joshua - Save tab is now a real tab - just show the content without activating controller mode
            // Controller mode is activated when user presses A on the tab
            if (GetPlayerOwner().CanSaveGame())
            {
                ChangeMenuSection(m_SaveGameButton);
                // Don't enable controller mode here - user must press A first
            }
            else
            {
                // Can't save - go back to the real tab
                m_selectedTabIndex = m_lastRealTabIndex;
                UpdateTabSelection();
            }
            break;
    }
    // Joshua - Only ensure list selection for non-Save tabs at navRow 0
    if (m_selectedTabIndex != 2)
        EnsureListSelection();
}

function NavigateListUp()
{
    local UWindowListBox ListBox;
    local UWindowListBoxItem PrevItem;

    ListBox = GetActiveListBox();
    if (ListBox == None || ListBox.SelectedItem == None)
        return;

    PrevItem = UWindowListBoxItem(ListBox.SelectedItem.Prev);
    if (PrevItem != None && PrevItem != ListBox.Items)
    {
        ListBox.SetSelectedItem(PrevItem);
        ListBox.MakeSelectedVisible();
        Root.PlayClickSound();
    }
}

function NavigateListDown()
{
    local UWindowListBox ListBox;
    local UWindowListBoxItem NextItem;

    ListBox = GetActiveListBox();
    if (ListBox == None || ListBox.SelectedItem == None)
        return;

    NextItem = UWindowListBoxItem(ListBox.SelectedItem.Next);
    if (NextItem != None)
    {
        ListBox.SetSelectedItem(NextItem);
        ListBox.MakeSelectedVisible();
        Root.PlayClickSound();
    }
}

// Joshua - Tick function for auto-repeat scrolling and tab navigation
function Tick(float Delta)
{
    Super.Tick(Delta);

    if (!m_bAreaEnabled || m_heldKey == 0)
        return;

    // Auto-repeat for list scrolling (navRow 1) or tab navigation (navRow 0)
    if (m_navRow == 1)
    {
        // Only repeat up/down for list
        if (m_heldKey != 212 && m_heldKey != 196 && m_heldKey != 213 && m_heldKey != 197)
            return;
    }
    else if (m_navRow == 0)
    {
        // Only repeat left/right for tabs
        if (m_heldKey != 214 && m_heldKey != 198 && m_heldKey != 215 && m_heldKey != 199)
            return;
    }
    else
    {
        return;
    }

    m_keyHoldTime += Delta;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        HandleKeyDown(m_heldKey);
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

defaultproperties
{
    m_IFirstButtonsXPos=6
    m_IXButtonOffset=148
    m_IButtonsHeight=18
    m_IButtonsWidth=144
    m_IButtonsYPos=5
    m_iLoadXPos=120
    m_ILoadYPos=223
    m_ILoadWidth=200
    m_ILoadHeight=18
    m_IListBoxXPos=8
    m_IListBoxYPos=37
    m_IListBoxWidth=432
    m_IListBoxHeight=175
    m_ISaveListBoxYPos=55
    m_ISaveListBoxHeight=157
    m_TextColor=(R=51,G=51,B=51,A=255)
    m_ILabelHeight=18
    m_NameWidth=210
    m_LDateWidth=128
    m_initialDelay=0.5
    m_repeatRate=0.1
}