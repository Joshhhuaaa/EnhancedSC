//=============================================================================
//  EPCSaveGameMenu.uc : Saves games and unlucked maps menu
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/17 * Created by Alexandre Dionne
//=============================================================================
class EPCSaveGameMenu extends EPCMenuPage
                    native;

#exec OBJ LOAD FILE=..\Textures\HUD_Enhanced.utx

var EPCTextButton   m_Back;     // To return to main menu
var INT             m_IBackButtonsXPos, m_IBackButtonsHeight, m_IBackButtonsWidth, m_IBackButtonsYPos;


var EPCTextButton   m_SaveGamesButton;
var EPCTextButton   m_LevelsButton;
var INT             m_iTopButtonsYPos, m_iFSaveGamesXPos, m_iLevelsXPos, m_iTopButtonsWidth;

var EPCTextButton   m_ConfirmationButton;
var INT             m_iConfirmationXPos;

var EPCLevelListBox m_ListBox;
var EPCFileListBox  m_FileListBox;

var INT             m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight;
var INT             m_ISaveListBoxYPos, m_ISaveListBoxHeight;

var UWindowLabelControl     m_LName;
var UWindowLabelControl     m_LDate;
var UWindowLabelControl     m_LTime;

var Color                   m_TextColor;
var INT                     m_ILabelHeight, m_NameWidth, m_LDateWidth;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var bool                    m_bPendingPrototypeMapLoad; // Joshua - For prototype map warning

// Joshua - Controller navigation variables
var int     m_selectedTab;          // 0 = Save Games, 1 = Levels
var int     m_totalTabs;            // Total number of tabs (2)
var bool    m_bInArea;              // True when navigating inside an area
var bool    m_bJustExitedArea;      // Prevents double B press when exiting area
var int     m_selectedSaveIndex;    // Currently selected save game index
var int     m_selectedLevelIndex;   // Currently selected level index

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)


function Created()
{
    Super.Created();
	SetAcceptsFocus();

    m_Back           = EPCTextButton(CreateControl(class'EPCTextButton', m_IBackButtonsXPos, m_IBackButtonsYPos, m_IBackButtonsWidth, m_IBackButtonsHeight, self));
    m_ConfirmationButton = EPCTextButton(CreateControl(class'EPCTextButton', m_iConfirmationXPos, m_IBackButtonsYPos, m_IBackButtonsWidth, m_IBackButtonsHeight, self));
    m_SaveGamesButton    = EPCTextButton(CreateControl(class'EPCTextButton', m_iFSaveGamesXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IBackButtonsHeight, self));
    m_LevelsButton       = EPCTextButton(CreateControl(class'EPCTextButton', m_iLevelsXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IBackButtonsHeight, self));


    m_Back.SetButtonText(Caps(Localize("HUD","Back","Localization\\HUD"))      ,TXT_CENTER);
    m_SaveGamesButton.SetButtonText(Localize("HUD","SAVES","Localization\\HUD")  ,TXT_CENTER);
    m_LevelsButton.SetButtonText(Localize("HUD","LEVELS","Localization\\HUD")    ,TXT_CENTER);
    m_ConfirmationButton.SetButtonText(Localize("HUD","START","Localization\\HUD"),TXT_CENTER);

    m_Back.Font                 = F_Normal;
    m_SaveGamesButton.Font      = F_Normal;
    m_LevelsButton.Font         = F_Normal;
    m_ConfirmationButton.Font   = F_Normal;

    m_ListBox           = EPCLevelListBox(CreateControl(class'EPCLevelListBox', m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight, self));
    m_ListBox.Font      = F_Normal;
    m_ListBox.Align     = TXT_CENTER;

    m_FileListBox           = EPCFileListBox(CreateControl(class'EPCFileListBox', m_IListBoxXPos, m_ISaveListBoxYPos, m_IListBoxWidth, m_ISaveListBoxHeight, self));
    m_FileListBox.Font      = F_Normal;
    m_FileListBox.NameWidth = m_NameWidth;
    m_FileListBox.DateWidth = m_LDateWidth;

    m_LName       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IListBoxXPos, m_IListBoxYPos, m_NameWidth, m_ILabelHeight, self));
    m_LName.SetLabelText(Localize("HUD","NAME","Localization\\HUD"),TXT_LEFT);
    m_LName.Font       = F_Normal;
    m_LName.TextColor  = m_TextColor;
    m_LName.m_fLMarge  = 2;

    m_LDate       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_LName.WinLeft + m_LName.WinWidth, m_IListBoxYPos, m_LDateWidth, m_ILabelHeight, self));
    m_LDate.SetLabelText(Localize("HUD","DATE","Localization\\HUD"),TXT_LEFT);
    m_LDate.Font       = F_Normal;
    m_LDate.TextColor  = m_TextColor;
    m_LDate.m_fLMarge  = 2;

    m_LTime       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_LDate.WinLeft + m_LDate.WinWidth, m_IListBoxYPos, m_IListBoxWidth - m_LDateWidth - m_NameWidth, m_ILabelHeight, self));
    m_LTime.SetLabelText(Localize("HUD","TIME","Localization\\HUD"),TXT_LEFT);
    m_LTime.Font       = F_Normal;
    m_LTime.TextColor  = m_TextColor;
    m_LTime.m_fLMarge  = 2;

    // Joshua - Initialize controller navigation
    m_totalTabs = 2;
    m_selectedTab = 0;
    m_bInArea = false;
    m_bJustExitedArea = false;
    m_selectedSaveIndex = 0;
    m_selectedLevelIndex = 0;

    ChangeTopButtonSelection(m_SaveGamesButton);

}

function ShowWindow()
{
    Super.ShowWindow();
    FillListBox();

    // Joshua - Hide button labels in controller mode
    UpdateButtonLabelsForInputMode();
}

// Joshua - Show/hide button labels based on controller mode
function UpdateButtonLabelsForInputMode()
{
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        // Controller mode - hide buttons entirely (we show prompts instead)
        m_Back.HideWindow();
        m_ConfirmationButton.HideWindow();
    }
    else
    {
        // Keyboard/mouse mode - show buttons with labels
        m_Back.ShowWindow();
        m_ConfirmationButton.ShowWindow();

        m_Back.SetButtonText(Caps(Localize("HUD","Back","Localization\\HUD")), TXT_CENTER);
        m_ConfirmationButton.SetButtonText(Localize("HUD","START","Localization\\HUD"), TXT_CENTER);
    }
}

// Joshua - Called when controller mode changes (from Root)
function OnControllerModeChanged(bool bControllerMode)
{
    UpdateButtonLabelsForInputMode();
}


function FillListBox()
{
    local int i;
    local EPCListBoxItem L;
    local EPCFileManager FileManager;
    local EPlayerInfo    PlayerInfo;
    local String         Path;    //Do something
	local String         Name;
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

	// Joshua - Store the newest save game filename in EPlayerController
	if (m_FileListBox.Items.Next != None)
		EPC.LastSaveName = EPCListBoxItem(m_FileListBox.Items.Next).Caption;
	else
		EPC.LastSaveName = "";

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

function Paint(Canvas C, float MouseX, float MouseY)
{
    Render(C , MouseX, MouseY);

    // Joshua - Draw controller button prompts when in controller mode
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        DrawControllerPrompts(C);
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

    eLevel = EchelonLevelInfo(GetLevel());
    if (eLevel == None || eLevel.TMENU == None)
        return;

    EPC = EPlayerController(GetPlayerOwner());

    IconSize = 22;
    PromptY = m_IBackButtonsYPos - 2; // Same Y as bottom buttons, raised 2 pixels
    PromptX = 68; // Start from left (BACK button position)

    IconColor.R = 128;
    IconColor.G = 128;
    IconColor.B = 128;
    IconColor.A = 255;

    TextColor.R = 71;
    TextColor.G = 71;
    TextColor.B = 71;
    TextColor.A = 255;

    C.Font = Root.Fonts[F_Normal];

    // (A) Select - always shown
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
            C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].TextureOwner, IconSize, IconSize,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Origin.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Origin.Y,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Size.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Size.Y);
            break;
    }
    PromptX += IconSize + 8;
    C.DrawColor = TextColor;
    C.SetPos(PromptX, PromptY + 3);
    PromptText = Caps(Localize("HUD", "Select", "Localization\\HUD"));
    C.DrawText(PromptText);
    C.TextSize(PromptText, TextWidth, TextHeight);
    PromptX += TextWidth + 15;

    // (B) Back - always shown
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
            C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].TextureOwner, IconSize, IconSize,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Origin.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Origin.Y,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Size.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Size.Y);
            break;
    }
    PromptX += IconSize + 8;
    C.DrawColor = TextColor;
    C.SetPos(PromptX, PromptY + 3);
    PromptText = Caps(Localize("HUD", "Back", "Localization\\HUD"));
    C.DrawText(PromptText);
}

function Notify(UWindowDialogControl C, byte E)
{
	if (E == DE_Click)
	{
        switch (C)
        {
        case m_Back:
            ResetAreas(); // Joshua - Reset areas when leaving via Back button
            Root.ChangeCurrentWidget(WidgetID_Previous);
            break;
        case m_LevelsButton:
            ChangeTopButtonSelection(EPCTextButton(C));
            m_bInArea = false; // Joshua - Mouse clicked tab, exit area mode
            break;
        case m_SaveGamesButton:
            ChangeTopButtonSelection(EPCTextButton(C));
            m_bInArea = false; // Joshua - Mouse clicked tab, exit area mode
            break;
        case m_ConfirmationButton:
            ConfirmButtonPressed();
            break;
        }
    }
    if ((E == DE_DoubleClick) && ((C == m_ListBox) || (C == m_FileListBox)))
    {
        ConfirmButtonPressed();
    }
}

//------------------------------------------------------------------------
// Joshua - Prototype map warning
//------------------------------------------------------------------------
function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    if (Result == MR_OK && m_bPendingPrototypeMapLoad)
    {
        m_bPendingPrototypeMapLoad = false;
        LoadSelectedMap();
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

function EscapeMenu()
{
	if (!EPCConsole(Root.Console).bInGameMenuActive)
	{
		Root.PlayClickSound();
		ResetAreas(); // Joshua - Reset areas when leaving via Escape
		Notify(m_Back, DE_Click);
	}
}

function ConfirmButtonPressed()
{
    // Joshua - Check if this is a prototype map that needs a warning
    if (!m_SaveGamesButton.m_bSelected &&
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
    local EPlayerController EPC; // Joshua - For LastSaveName

	// Check valid CD in
	if (!EPCMainMenuRootWindow(Root).CheckCD())
		return;

    EPC = EPlayerController(GetPlayerOwner()); // Joshua - For LastSaveName

    if (m_SaveGamesButton.m_bSelected)
    {
        if (m_FileListBox.SelectedItem != None)
        {
			// Joshua - Store pending load name in Console (survives load) to restore after
			EPCConsole(Root.Console).PendingLoadSaveName = EPCListBoxItem(m_FileListBox.SelectedItem).Caption;
			// Added extension (.sav) (YM)
            Error = GetPlayerOwner().ConsoleCommand("LoadGame Filename="$EPCListBoxItem(m_FileListBox.SelectedItem).Caption$".en4"); // Joshua - Enhanced save games are not compatible, changing extension to avoid confusion
        }
        else
            return;
    }
    else
    {
        if ((EPCListBoxItem(m_ListBox.SelectedItem) != None) && (!EPCListBoxItem(m_ListBox.SelectedItem).m_bLocked))
        {
			Error = GetPlayerOwner().ConsoleCommand("Open "$EPCListBoxItem(m_ListBox.SelectedItem).Caption);
			EPCConsole(Root.Console).ReturnToGame();
        }
        else
            return;
    }

    if (Error == "")
        EPCConsole(Root.Console).LaunchGame();
    else
        log("Load Error:"@Error);
}

function ChangeTopButtonSelection(EPCTextButton _SelectMe)
{
    m_SaveGamesButton.m_bSelected    =  false;
    m_LevelsButton.m_bSelected       =  false;

    _SelectMe.m_bSelected            =  true;

    switch (_SelectMe)
    {
    case m_SaveGamesButton:
        m_ListBox.HideWindow();
        m_FileListBox.ShowWindow();
        m_LName.ShowWindow();
        m_LDate.ShowWindow();
        m_LTime.ShowWindow();
        m_selectedTab = 0; // Joshua - Track selected tab
        break;
    case m_LevelsButton:
        m_ListBox.ShowWindow();
        m_FileListBox.HideWindow();
        m_LName.HideWindow();
        m_LDate.HideWindow();
        m_LTime.HideWindow();
        m_selectedTab = 1; // Joshua - Track selected tab
        break;
    }
}

// Joshua - Highlight the selected tab
function HighlightSelectedTab(int tabIndex)
{
    m_SaveGamesButton.m_bSelected = false;
    m_LevelsButton.m_bSelected = false;

    switch (tabIndex)
    {
        case 0:
            m_SaveGamesButton.m_bSelected = true;
            break;
        case 1:
            m_LevelsButton.m_bSelected = true;
            break;
    }
}

// Joshua - Select a tab and show its corresponding list
function SelectTab(int tabIndex)
{
    m_selectedTab = tabIndex;
    HighlightSelectedTab(tabIndex);

    if (tabIndex == 0)
    {
        m_ListBox.HideWindow();
        m_FileListBox.ShowWindow();
        m_LName.ShowWindow();
        m_LDate.ShowWindow();
        m_LTime.ShowWindow();
    }
    else
    {
        m_ListBox.ShowWindow();
        m_FileListBox.HideWindow();
        m_LName.HideWindow();
        m_LDate.HideWindow();
        m_LTime.HideWindow();
    }
}

// Joshua - Get the number of save games
function int GetSaveGameCount()
{
    return m_FileListBox.Items.Count();
}

// Joshua - Get the number of levels
function int GetLevelCount()
{
    return m_ListBox.Items.Count();
}

// Joshua - Get save game item at index
function UWindowListBoxItem GetSaveGameAtIndex(int Index)
{
    return UWindowListBoxItem(m_FileListBox.Items.FindEntry(Index));
}

// Joshua - Get level item at index
function UWindowListBoxItem GetLevelAtIndex(int Index)
{
    return UWindowListBoxItem(m_ListBox.Items.FindEntry(Index));
}

// Joshua - Select save game at index
function SelectSaveGameAtIndex(int Index)
{
    local UWindowListBoxItem Item;
    local int Count;

    Count = GetSaveGameCount();
    if (Count == 0)
        return;

    if (Index < 0)
        Index = 0;
    if (Index >= Count)
        Index = Count - 1;

    m_selectedSaveIndex = Index;

    Item = GetSaveGameAtIndex(Index);
    if (Item != None)
    {
        m_FileListBox.SetSelectedItem(Item);
        m_FileListBox.MakeSelectedVisible();
    }
}

// Joshua - Select level at index
function SelectLevelAtIndex(int Index)
{
    local UWindowListBoxItem Item;
    local int Count;

    Count = GetLevelCount();
    if (Count == 0)
        return;

    if (Index < 0)
        Index = 0;
    if (Index >= Count)
        Index = Count - 1;

    m_selectedLevelIndex = Index;

    Item = GetLevelAtIndex(Index);
    if (Item != None)
    {
        m_ListBox.SetSelectedItem(Item);
        m_ListBox.MakeSelectedVisible();
    }
}

// Joshua - Enter the selected area
function EnterArea()
{
    m_bInArea = true;

    if (m_selectedTab == 0)
    {
        // Save Games tab
        if (GetSaveGameCount() > 0)
        {
            m_selectedSaveIndex = 0;
            SelectSaveGameAtIndex(m_selectedSaveIndex);
        }
    }
    else
    {
        // Levels tab
        if (GetLevelCount() > 0)
        {
            m_selectedLevelIndex = 0;
            SelectLevelAtIndex(m_selectedLevelIndex);
        }
    }
}

// Joshua - Exit the area back to tab selection
function ExitArea()
{
    m_bInArea = false;

    // Clear selection when exiting - must also clear SelectedItem reference
    // so SetSelectedItem will properly set bSelected=true on re-entry
    if (m_FileListBox.SelectedItem != None)
    {
        m_FileListBox.SelectedItem.bSelected = false;
        m_FileListBox.SelectedItem = None;
    }
    if (m_ListBox.SelectedItem != None)
    {
        m_ListBox.SelectedItem.bSelected = false;
        m_ListBox.SelectedItem = None;
    }

    HighlightSelectedTab(m_selectedTab);
}

// Joshua - Called when exiting an area back to tab selection (for B button)
function AreaExited()
{
    m_bInArea = false;
    // NOTE: Don't set m_bJustExitedArea here because B is already fully processed
    // in HandleListNavigation before this is called. Setting it would consume the
    // next key press (like Right to switch tabs).

    // Clear selection when exiting - must also clear SelectedItem reference
    // so SetSelectedItem will properly set bSelected=true on re-entry
    if (m_FileListBox.SelectedItem != None)
    {
        m_FileListBox.SelectedItem.bSelected = false;
        m_FileListBox.SelectedItem = None;
    }
    if (m_ListBox.SelectedItem != None)
    {
        m_ListBox.SelectedItem.bSelected = false;
        m_ListBox.SelectedItem = None;
    }

    HighlightSelectedTab(m_selectedTab);
}

// Joshua - Reset all areas when leaving the menu
function ResetAreas()
{
    m_bInArea = false;
    m_bJustExitedArea = false;
    m_heldKey = 0;  // Joshua - Clear held key to prevent auto-scroll persisting
    m_keyHoldTime = 0;

    // Clear selection - also clear SelectedItem reference for consistency
    if (m_FileListBox.SelectedItem != None)
    {
        m_FileListBox.SelectedItem.bSelected = false;
        m_FileListBox.SelectedItem = None;
    }
    if (m_ListBox.SelectedItem != None)
    {
        m_ListBox.SelectedItem.bSelected = false;
        m_ListBox.SelectedItem = None;
    }
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    local int ItemCount;

    Super.WindowEvent(Msg, C, X, Y, Key);

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
        if (m_bJustExitedArea)
        {
            m_bJustExitedArea = false;
            return;
        }

        // Route based on whether we're in a list or at tabs
        if (!m_bInArea)
        {
            // Track repeatable keys for tabs (left/right)
            if (Key == 214 || Key == 198 || Key == 215 || Key == 199)
            {
                if (Key != m_heldKey)
                {
                    m_heldKey = Key;
                    m_keyHoldTime = 0;
                    m_nextRepeatTime = m_initialDelay;
                }
            }
            HandleTabsRowInput(Key);
        }
        else
        {
            // Track repeatable keys when in list navigation
            if (Key == 212 || Key == 196 || Key == 213 || Key == 197)
            {
                // New key press - reset repeat timing
                if (Key != m_heldKey)
                {
                    m_heldKey = Key;
                    m_keyHoldTime = 0;
                    m_nextRepeatTime = m_initialDelay;
                }
            }
            HandleListNavigation(Key);
        }
    }
}
// Joshua - Handle input when on tabs row
function HandleTabsRowInput(int Key)
{
    // Left - switch tabs
    if (Key == 214 || Key == 198)
    {
        Root.PlayClickSound();
        m_selectedTab = (m_selectedTab - 1 + m_totalTabs) % m_totalTabs;
        SelectTab(m_selectedTab);
    }
    // Right - switch tabs
    else if (Key == 215 || Key == 199)
    {
        Root.PlayClickSound();
        m_selectedTab = (m_selectedTab + 1) % m_totalTabs;
        SelectTab(m_selectedTab);
    }
    // A button - enter the list
    else if (Key == 200)
    {
        if ((m_selectedTab == 0 && GetSaveGameCount() > 0) ||
            (m_selectedTab == 1 && GetLevelCount() > 0))
        {
            Root.PlayClickSound();
            m_bInArea = true;
            EnterArea();
        }
    }
    // B button - go back to main menu
    else if (Key == 201)
    {
        if (EPCMainMenuRootWindow(Root).m_MessageBox == None)
        {
            Root.PlayClickSound();
            ResetAreas();
            Notify(m_Back, DE_Click);
        }
    }
}

// Joshua - Handle list navigation (for normal mode and auto-repeat)
function HandleListNavigation(int Key)
{
    local int ItemCount;

    // Sync controller index with current mouse selection before navigating
    SyncControllerWithMouseSelection();

    if (m_selectedTab == 0)
    {
        // Save Games navigation
        ItemCount = GetSaveGameCount();

        // Navigate down - DPadDown (213) or AnalogDown (197)
        if (Key == 213 || Key == 197)
        {
            if (ItemCount > 0 && m_selectedSaveIndex < ItemCount - 1)
            {
                Root.PlayClickSound();
                m_selectedSaveIndex = m_selectedSaveIndex + 1;
                SelectSaveGameAtIndex(m_selectedSaveIndex);
            }
            // At bottom - do nothing, must press B to exit
        }
        // Navigate up - DPadUp (212) or AnalogUp (196)
        else if (Key == 212 || Key == 196)
        {
            if (ItemCount > 0 && m_selectedSaveIndex > 0)
            {
                Root.PlayClickSound();
                m_selectedSaveIndex = m_selectedSaveIndex - 1;
                SelectSaveGameAtIndex(m_selectedSaveIndex);
            }
            // At top - do nothing, must press B to exit
        }
        // A button - confirm selection (200)
        else if (Key == 200)
        {
            if (m_FileListBox.SelectedItem != None)
            {
                Root.PlayClickSound();
                ConfirmButtonPressed();
            }
        }
        // B button - exit to tabs (201)
        else if (Key == 201)
        {
            Root.PlayClickSound();
            m_bInArea = false;
            AreaExited();
        }
    }
    else
    {
        // Levels navigation
        ItemCount = GetLevelCount();

        // Navigate down - DPadDown (213) or AnalogDown (197)
        if (Key == 213 || Key == 197)
        {
            if (ItemCount > 0 && m_selectedLevelIndex < ItemCount - 1)
            {
                Root.PlayClickSound();
                m_selectedLevelIndex = m_selectedLevelIndex + 1;
                SelectLevelAtIndex(m_selectedLevelIndex);
            }
            // At bottom - do nothing, must press B to exit
        }
        // Navigate up - DPadUp (212) or AnalogUp (196)
        else if (Key == 212 || Key == 196)
        {
            if (ItemCount > 0 && m_selectedLevelIndex > 0)
            {
                Root.PlayClickSound();
                m_selectedLevelIndex = m_selectedLevelIndex - 1;
                SelectLevelAtIndex(m_selectedLevelIndex);
            }
            // At top - do nothing, must press B to exit
        }
        // A button - confirm selection (200)
        else if (Key == 200)
        {
            // Only load if not locked
            if (m_ListBox.SelectedItem != None && !EPCListBoxItem(m_ListBox.SelectedItem).m_bLocked)
            {
                Root.PlayClickSound();
                ConfirmButtonPressed();
            }
        }
        // B button - exit to tabs (201)
        else if (Key == 201)
        {
            Root.PlayClickSound();
            m_bInArea = false;
            AreaExited();
        }
    }
}

// Joshua - Tick function to handle auto-repeat for held keys
function Tick(float Delta)
{
    Super.Tick(Delta);

    // No key held, nothing to repeat
    if (m_heldKey == 0)
        return;

    m_keyHoldTime += Delta;

    // Check if it's time to repeat
    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        if (m_bInArea)
        {
            // Repeat list navigation (up/down)
            if (m_heldKey == 212 || m_heldKey == 196 || m_heldKey == 213 || m_heldKey == 197)
            {
                HandleListNavigation(m_heldKey);
            }
        }
        else
        {
            // Repeat tab navigation (left/right)
            if (m_heldKey == 214 || m_heldKey == 198 || m_heldKey == 215 || m_heldKey == 199)
            {
                HandleTabsRowInput(m_heldKey);
            }
        }

        // Schedule next repeat
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

// Joshua - Sync controller selection index with current mouse selection
function SyncControllerWithMouseSelection()
{
    local UWindowListBoxItem Item;
    local int Index;

    if (m_selectedTab == 0)
    {
        // Save Games tab - find index of currently selected item
        if (m_FileListBox.SelectedItem != None)
        {
            Index = 0;
            Item = UWindowListBoxItem(m_FileListBox.Items.Next);
            while (Item != None)
            {
                if (Item == m_FileListBox.SelectedItem)
                {
                    m_selectedSaveIndex = Index;
                    return;
                }
                Index++;
                Item = UWindowListBoxItem(Item.Next);
            }
        }
    }
    else
    {
        // Levels tab - find index of currently selected item
        if (m_ListBox.SelectedItem != None)
        {
            Index = 0;
            Item = UWindowListBoxItem(m_ListBox.Items.Next);
            while (Item != None)
            {
                if (Item == m_ListBox.SelectedItem)
                {
                    m_selectedLevelIndex = Index;
                    return;
                }
                Index++;
                Item = UWindowListBoxItem(Item.Next);
            }
        }
    }
}

defaultproperties
{
    m_IBackButtonsXPos=68
    m_IBackButtonsHeight=18
    m_IBackButtonsWidth=240
    m_IBackButtonsYPos=353
    m_iTopButtonsYPos=143
    m_iFSaveGamesXPos=85
    m_iLevelsXPos=323
    m_iTopButtonsWidth=230
    m_iConfirmationXPos=330
    m_IListBoxXPos=83
    m_IListBoxYPos=175
    m_IListBoxWidth=475
    m_IListBoxHeight=155
    m_ISaveListBoxYPos=193
    m_ISaveListBoxHeight=137
    m_TextColor=(R=51,G=51,B=51,A=255)
    m_ILabelHeight=18
    m_NameWidth=224
    m_LDateWidth=135
    m_initialDelay=0.5
    m_repeatRate=0.1
}