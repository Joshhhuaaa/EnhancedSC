//=============================================================================
//  EPCPlayerMenu.uc : START GAME MENU
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/10 * Created by Alexandre Dionne
//=============================================================================
class EPCPlayerMenu extends EPCMenuPage
                    native;

#exec OBJ LOAD FILE=..\Textures\HUD_Enhanced.utx

var EPCTextButton   m_MainMenu;     // To return to main menu
var INT             m_IMainButtonsXPos, m_IMainButtonsHeight, m_IMainButtonsWidth, m_IMainButtonsYPos;


var EPCTextButton   m_LoadButton;
var EPCTextButton   m_CreateButton;
var INT             m_iTopButtonsYPos, m_iLoadXPos, m_iCreateButtonXPos, m_iTopButtonsWidth;

var EPCTextButton   m_ConfirmationButton;
var INT             m_iConfirmationXPos;

var EPCCreatePlayerArea     m_CreateArea;
var EPCLoadDelPlayerArea    m_LoadDelArea;
var INT             m_iCreateXPos, m_iCreateYPos, m_iCreateWidth, m_iCreateHeight;

// Joshua - Controller navigation variables
var int     m_selectedTab;       // 0 = Load Profile, 1 = New Profile
var int     m_totalTabs;         // Total number of tabs (2)
var bool    m_bInArea;           // True when navigating inside an area
var bool    m_bJustExitedArea;   // Prevents double B press when exiting area

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

// Joshua - Track input mode changes
var bool    m_bPreviousMouseMode; // True if we were in mouse mode last frame


function Created()
{
    Super.Created();
    SetAcceptsFocus();

    m_MainMenu  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_ConfirmationButton = EPCTextButton(CreateControl(class'EPCTextButton', m_iConfirmationXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));

    m_LoadButton    = EPCTextButton(CreateControl(class'EPCTextButton', m_iLoadXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IMainButtonsHeight, self));
    m_CreateButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_iCreateButtonXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IMainButtonsHeight, self));

    m_CreateArea    = EPCCreatePlayerArea(CreateWindow(class'EPCCreatePlayerArea', m_iCreateXPos, m_iCreateYPos, m_iCreateWidth, m_iCreateHeight, self));
    m_CreateArea.HideWindow();

    m_LoadDelArea   = EPCLoadDelPlayerArea(CreateWindow(class'EPCLoadDelPlayerArea', m_iCreateXPos, m_iCreateYPos, m_iCreateWidth, m_iCreateHeight, self));
    m_LoadDelArea.HideWindow();

    m_MainMenu.SetButtonText(Caps(Localize("HUD","MAINMENU","Localization\\HUD"))         ,TXT_CENTER);
    m_LoadButton.SetButtonText(Caps(Localize("HUD","LOADPROFILE","Localization\\HUD"))      ,TXT_CENTER);
    m_LoadButton.HelpText   = Caps(Localize("HUD","LOAD","Localization\\HUD"));
    m_CreateButton.SetButtonText(Caps(Localize("HUD","CREATEPROFILE","Localization\\HUD"))    ,TXT_CENTER);
    m_CreateButton.HelpText = Caps(Localize("HUD","Create","Localization\\HUD"));

    m_MainMenu.Font             = F_Normal;
    m_LoadButton.Font           = F_Normal;
    m_CreateButton.Font         = F_Normal;
    m_ConfirmationButton.Font   = F_Normal;

    // Joshua - Initialize controller navigation
    m_totalTabs = 2;
    m_selectedTab = 0;
    m_bInArea = false;

    // Joshua - Initialize auto-scroll variables
    m_heldKey = 0;
    m_keyHoldTime = 0.0;
    m_nextRepeatTime = 0.0;
}

// Joshua - Detect input mode change and clear profile selection when switching to controller
function BeforePaint(Canvas C, float X, float Y)
{
    local bool bCurrentMouseMode;

    Super.BeforePaint(C, X, Y);

    bCurrentMouseMode = !Root.bDisableMouseDisplay;

    // Detect switch from mouse to controller mode
    if (m_bPreviousMouseMode && !bCurrentMouseMode)
    {
        // Switched from mouse to controller, clear profile selection if not actively in the area
        if (!m_bInArea && m_LoadDelArea != None)
        {
            m_LoadDelArea.ClearSelectionHighlight();
        }
    }

    // Update for next frame
    m_bPreviousMouseMode = bCurrentMouseMode;
}

function ShowWindow()
{
    Super.ShowWindow();
    ChangeTopButtonSelection(m_LoadButton);

    // Joshua - Reset navigation state when showing window
    m_selectedTab = 0;
    m_bInArea = false;

    // Joshua - Disable the LoadDelArea so user must press A to enter list again
    m_LoadDelArea.EnableArea(false);

    // Joshua - Hide button labels in controller mode
    UpdateButtonLabelsForInputMode();

    UpdateNavigationHighlight();
}

// Joshua - Show/hide button labels based on controller mode
function UpdateButtonLabelsForInputMode()
{
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        // Controller mode - hide buttons entirely (we show prompts instead)
        m_MainMenu.HideWindow();
        m_ConfirmationButton.HideWindow();
        m_LoadDelArea.m_DeleteButton.HideWindow();
        m_CreateArea.m_ResetAllButton.HideWindow();
    }
    else
    {
        // Keyboard/mouse mode - show buttons with labels
        m_MainMenu.ShowWindow();
        m_ConfirmationButton.ShowWindow();
        m_LoadDelArea.m_DeleteButton.ShowWindow();
        m_CreateArea.m_ResetAllButton.ShowWindow();

        m_MainMenu.SetButtonText(Caps(Localize("HUD","MAINMENU","Localization\\HUD")), TXT_CENTER);

        // Confirmation button text depends on selected tab
        if (m_selectedTab == 0)
            m_ConfirmationButton.SetButtonText(m_LoadButton.HelpText, TXT_CENTER);
        else
            m_ConfirmationButton.SetButtonText(m_CreateButton.HelpText, TXT_CENTER);

        m_LoadDelArea.m_DeleteButton.SetButtonText(Caps(Localize("HUD","DELETEPROFILE","Localization\\HUD")), TXT_CENTER);
        m_CreateArea.m_ResetAllButton.SetButtonText(Caps(Localize("HUD","CLEARALL","Localization\\HUD")), TXT_CENTER);
    }
}

function Paint(Canvas C, float MouseX, float MouseY)
{
    Render(C, MouseX, MouseY);

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
    PromptY = m_IMainButtonsYPos - 2; // Same Y as bottom buttons, raised 2 pixels
    PromptX = 68; // Start from left

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
    C.TextSize(PromptText, TextWidth, TextHeight);

    // Tab-specific prompts - only show when in area (tab is in focus)
    // Start at confirmation button position (where LOAD/CREATE was)
    if (m_bInArea)
    {
        PromptX = m_iConfirmationXPos; // Start where LOAD/CREATE button was

        if (m_selectedTab == 0)
        {
            // Load Profile tab: (X) Delete Profile
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
                    C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].TextureOwner, IconSize, IconSize,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Origin.X,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Origin.Y,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Size.X,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Size.Y);
                    break;
            }
            PromptX += IconSize + 8;
            C.DrawColor = TextColor;
            C.SetPos(PromptX, PromptY + 3);
            PromptText = Caps(Localize("HUD", "DELETEPROFILE", "Localization\\HUD"));
            C.DrawText(PromptText);
        }
        else
        {
            // New Profile tab: (X) Create Profile, (Y) Clear All if on profile name or Info if on Elite/Permadeath
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
                    C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].TextureOwner, IconSize, IconSize,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Origin.X,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Origin.Y,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Size.X,
                        eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_x].Size.Y);
                    break;
            }
            PromptX += IconSize + 8;
            C.DrawColor = TextColor;
            C.SetPos(PromptX, PromptY + 3);
            PromptText = Caps(Localize("HUD", "Create", "Localization\\HUD"));
            C.DrawText(PromptText);
            C.TextSize(PromptText, TextWidth, TextHeight);
            PromptX += TextWidth + 15;

            // Show (Y) Clear All if profile name is focused, or (Y) Info if on Elite/Permadeath
            if (m_CreateArea != None && m_CreateArea.ShouldShowYButton())
            {
                C.DrawColor = IconColor;
                C.SetPos(PromptX, PromptY);
                switch (EPC.ControllerIcon)
                {
                    case CI_PlayStation:
                        C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.PS2_Triangle', IconSize, IconSize, 3, 3, 26, 26);
                        break;
                    case CI_GameCube:
                        C.SetPos(PromptX, PromptY + 3); // Center the 15-tall icon in 22-tall space
                        C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.GameCube_Y', IconSize, 15, 14, 4, 37, 26);
                        break;
                    default: // CI_Xbox or CI_None
                        C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].TextureOwner, IconSize, IconSize,
                            eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Origin.X,
                            eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Origin.Y,
                            eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Size.X,
                            eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Size.Y);
                        break;
                }
                PromptX += IconSize + 8;
                C.DrawColor = TextColor;
                C.SetPos(PromptX, PromptY + 3);
                if (m_CreateArea.IsProfileNameFocused())
                    PromptText = Caps(Localize("HUD", "CLEARALL", "Localization\\HUD"));
                else
                    PromptText = Caps(Localize("Common", "Info", "Localization\\Enhanced"));
                C.DrawText(PromptText);
            }
        }
    }
}


function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_MainMenu:
            ResetAreas(); // Joshua - Reset areas when leaving via Main Menu button
            Root.ChangeCurrentWidget(WidgetID_MainMenu);
            break;

        case m_CreateButton:
        case m_LoadButton:
            ChangeTopButtonSelection(EPCTextButton(C));
            break;

        case m_ConfirmationButton:
            ConfirmButtonPressed();
            break;
        }
    }
}

function EscapeMenu()
{
	if (!EPCConsole(Root.Console).bInGameMenuActive)
	{
		Root.PlayClickSound();
		// Joshua - Reset areas when leaving via Escape
		ResetAreas();
		Notify(m_MainMenu, DE_Click);
	}
}

// Joshua - Reset all enabled areas when leaving the menu
function ResetAreas()
{
    m_bInArea = false;
    m_heldKey = 0;  // Joshua - Clear held key to prevent auto-scroll persisting
    m_keyHoldTime = 0;
    m_LoadDelArea.EnableArea(false);
    m_CreateArea.EnableArea(false);
}

function ConfirmButtonPressed()
{
    local String Error;

    // Joshua - Added for Elite mode
    local EPlayerController EPC;

    EPC = EPlayerController(GetPlayerOwner());

    ///////////////////////////////////////////////////////////////////////////////////
    //                  CREATE A PROFILE
    /////////////////////////////////////////////////////////////////////////////////
    if ((m_CreateButton.m_bSelected == true))
    {
		if (m_CreateArea.GetProfileName() != "")
		{
			//Saving desired difficulty level
			GetPlayerOwner().playerInfo.Difficulty = m_CreateArea.GetDifficulty();

			// No map completed yet, we just created a profile.
			GetPlayerOwner().playerInfo.MapCompleted = 0;

            if (EPC.playerInfo.Difficulty == 2 || EPC.playerInfo.Difficulty == 4) // Elite or Elite Permadeath
                EPC.eGame.bEliteMode = true;
            else
                EPC.eGame.bEliteMode = false;

            if (EPC.playerInfo.Difficulty > 2) // Permadeath toggle
                EPC.eGame.bPermadeathMode = true;
            else
                EPC.eGame.bPermadeathMode = false;

            EPC.eGame.SaveEnhancedOptions();

			Error = GetPlayerOwner().ConsoleCommand("SAVEPROFILE NAME="$m_CreateArea.GetProfileName());

			if (Error == "")
			{
				GetLevel().ConsoleCommand("Open "$GetPlayerOwner().playerInfo.UnlockedMap[0]);
				EPCConsole(Root.Console).LaunchGame();
				m_CreateArea.Reset();
			}
			else if (Error == "ALREADY_EXIST")
			{
				EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","PROFILEEXISTS","Localization\\HUD"), Localize("OPTIONS","PROFILEEXISTSMESSAGE","Localization\\HUD"), MB_OK, MR_OK, MR_OK);
			}
			else if (Error == "INVALID_NAME")
			{
				EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, "Error, invalid file name", "Bad File Name", MB_OK, MR_OK, MR_OK);
			}
			else    ///////////////////error///////////////////////////
				log("Create Profile Impossible"@Error);
		}
    }
    ///////////////////////////////////////////////////////////////////////////////////
    //                  LOAD A PROFILE
    /////////////////////////////////////////////////////////////////////////////////
    else //Load Profile
    {
        if (m_LoadDelArea.m_ListBox.SelectedItem != None)
        {
            //We should only have valid profiles listed so we can't load a wrong profile
            GetPlayerOwner().ConsoleCommand("LOADPROFILE NAME="$EPCListBoxItem(m_LoadDelArea.m_ListBox.SelectedItem).Caption);
            if (EPC.playerInfo.Difficulty == 2 || EPC.playerInfo.Difficulty == 4) // Elite or Elite Permadeath
                EPC.eGame.bEliteMode = true;
            else
                EPC.eGame.bEliteMode = false;

            if (EPC.playerInfo.Difficulty > 2) // Permadeath toggle
                EPC.eGame.bPermadeathMode = true;
            else
                EPC.eGame.bPermadeathMode = false;

            EPC.eGame.SaveEnhancedOptions();
            Root.ChangeCurrentWidget(WidgetID_SaveGames);
        }
    }
}

function ChangeTopButtonSelection(EPCTextButton _SelectMe)
{
    local bool bControllerMode;

    bControllerMode = EPCMainMenuRootWindow(Root).m_bControllerModeActive;

    // Joshua - Disable all areas when tab changes (handles mouse clicking different tab while in area)
    m_LoadDelArea.EnableArea(false);
    m_CreateArea.EnableArea(false);

    // Joshua - Exit area mode when switching tabs
    if (m_bInArea)
    {
        m_bInArea = false;
    }

    m_LoadButton.m_bSelected    =  false;
    m_CreateButton.m_bSelected  =  false;

    _SelectMe.m_bSelected       =  true;

    m_ConfirmationButton.SetButtonText(_SelectMe.HelpText, TXT_CENTER);

    if (_SelectMe == m_LoadButton)
    {
        m_LoadDelArea.ShowWindow();
        m_CreateArea.HideWindow();
        m_selectedTab = 0;

        // Only show/hide buttons based on controller mode
        if (!bControllerMode)
        {
            m_LoadDelArea.m_DeleteButton.ShowWindow();
            m_CreateArea.m_ResetAllButton.HideWindow();
        }
        else
        {
            m_LoadDelArea.m_DeleteButton.HideWindow();
            m_CreateArea.m_ResetAllButton.HideWindow();
        }
    }
    else
    {
        m_LoadDelArea.HideWindow();
        m_CreateArea.ShowWindow();
        m_selectedTab = 1;

        // Only show/hide buttons based on controller mode
        if (!bControllerMode)
        {
            m_LoadDelArea.m_DeleteButton.HideWindow();
            m_CreateArea.m_ResetAllButton.ShowWindow();
        }
        else
        {
            m_LoadDelArea.m_DeleteButton.HideWindow();
            m_CreateArea.m_ResetAllButton.HideWindow();
        }
    }

}

// Joshua - Highlight the selected tab
function HighlightSelectedTab(int tabIndex)
{
    m_LoadButton.m_bSelected = false;
    m_CreateButton.m_bSelected = false;

    switch (tabIndex)
    {
        case 0:
            m_LoadButton.m_bSelected = true;
            break;
        case 1:
            m_CreateButton.m_bSelected = true;
            break;
    }
}

// Joshua - Select a tab and show its corresponding area
function SelectTab(int tabIndex)
{
    local bool bControllerMode;

    bControllerMode = EPCMainMenuRootWindow(Root).m_bControllerModeActive;

    m_selectedTab = tabIndex;
    HighlightSelectedTab(tabIndex);

    if (tabIndex == 0)
    {
        m_LoadDelArea.ShowWindow();
        m_CreateArea.HideWindow();

        // Only show/hide buttons based on controller mode
        if (!bControllerMode)
        {
            m_LoadDelArea.m_DeleteButton.ShowWindow();
            m_CreateArea.m_ResetAllButton.HideWindow();
        }
        else
        {
            m_LoadDelArea.m_DeleteButton.HideWindow();
            m_CreateArea.m_ResetAllButton.HideWindow();
        }

        m_ConfirmationButton.SetButtonText(m_LoadButton.HelpText, TXT_CENTER);
    }
    else
    {
        m_LoadDelArea.HideWindow();
        m_CreateArea.ShowWindow();

        // Only show/hide buttons based on controller mode
        if (!bControllerMode)
        {
            m_LoadDelArea.m_DeleteButton.HideWindow();
            m_CreateArea.m_ResetAllButton.ShowWindow();
        }
        else
        {
            m_LoadDelArea.m_DeleteButton.HideWindow();
            m_CreateArea.m_ResetAllButton.HideWindow();
        }

        m_ConfirmationButton.SetButtonText(m_CreateButton.HelpText, TXT_CENTER);
    }
}

// Joshua - Called when exiting an area back to tab selection
function AreaExited()
{
    m_bInArea = false;
    // NOTE: Don't set m_bJustExitedArea here because B is already fully processed
    // in the area's WindowEvent before this is called.
    HighlightSelectedTab(m_selectedTab);
}

// Joshua - Update visual highlighting based on current navigation state
function UpdateNavigationHighlight()
{
    // Keep the active tab button selected
    m_LoadButton.m_bSelected = (m_selectedTab == 0);
    m_CreateButton.m_bSelected = (m_selectedTab == 1);

    // Clear bottom button highlights (not selectable via controller anymore)
    m_MainMenu.m_bSelected = false;
    m_ConfirmationButton.m_bSelected = false;
}

// Joshua - Called when controller mode changes (from Root)
function OnControllerModeChanged(bool bControllerMode)
{
    UpdateButtonLabelsForInputMode();

    // Propagate to CreatePlayerArea
    if (m_CreateArea != None)
        m_CreateArea.OnControllerModeChanged(bControllerMode);
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    local bool bWasInArea;

    // Save state before Super.WindowEvent, because child areas may call AreaExited()
    // which changes m_bInArea during the Super call
    bWasInArea = m_bInArea;

    Super.WindowEvent(Msg, C, X, Y, Key);

    // Track key releases for auto-repeat
    if (Msg == WM_KeyUp)
    {
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0;
        }
    }

    if (Msg == WM_KeyDown)
    {
        // If we were inside an area when this event started, let the area handle input
        // (the area may have already called AreaExited() by now)
        if (bWasInArea)
            return;

        // If we just exited an area, consume this input and clear the flag
        if (m_bJustExitedArea)
        {
            m_bJustExitedArea = false;
            return;
        }

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

        // Handle tabs row navigation (only row available now)
        HandleTabsRowInput(Key);
    }
}

// Joshua - Tick function for auto-repeat tab navigation
function Tick(float Delta)
{
    Super.Tick(Delta);

    // Only repeat tabs when not in area
    if (m_heldKey == 0 || m_bInArea)
        return;

    m_keyHoldTime += Delta;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        HandleTabsRowInput(m_heldKey);
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
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
        UpdateNavigationHighlight();
    }
    // Right - switch tabs
    else if (Key == 215 || Key == 199)
    {
        Root.PlayClickSound();
        m_selectedTab = (m_selectedTab + 1) % m_totalTabs;
        SelectTab(m_selectedTab);
        UpdateNavigationHighlight();
    }
    // A button - enter the current area
    else if (Key == 200)
    {
        if (m_selectedTab == 0)
        {
            // Don't enter Load Profile area if list is empty
            if (m_LoadDelArea.GetProfileCount() == 0)
            {
                // Play a different sound or no sound to indicate can't enter
                return;
            }
            Root.PlayClickSound();
            m_bInArea = true;
            m_LoadDelArea.EnableArea(true);
        }
        else
        {
            Root.PlayClickSound();
            m_bInArea = true;
            m_CreateArea.EnableArea(true);
        }
    }
    // B button - go back to main menu (only when not in area)
    else if (Key == 201)
    {
        if (!m_bInArea)
        {
            Root.PlayClickSound();
            ResetAreas();
            Root.ChangeCurrentWidget(WidgetID_MainMenu);
        }
    }
}

defaultproperties
{
    m_IMainButtonsXPos=68
    m_IMainButtonsHeight=18
    m_IMainButtonsWidth=240
    m_IMainButtonsYPos=353
    m_iTopButtonsYPos=143
    m_iLoadXPos=85
    m_iCreateButtonXPos=323
    m_iTopButtonsWidth=230
    m_iConfirmationXPos=330
    m_iCreateXPos=83
    m_iCreateYPos=175
    m_iCreateWidth=475
    m_iCreateHeight=155
    m_initialDelay=0.5
    m_repeatRate=0.1
}