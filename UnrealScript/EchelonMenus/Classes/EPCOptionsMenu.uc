//=============================================================================
//  EPCOptionsMenu.uc : User option menu
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/10 * Created by Alexandre Dionne
//=============================================================================
class EPCOptionsMenu extends EPCMenuPage
                    native;

#exec OBJ LOAD FILE=..\Textures\HUD_Enhanced.utx

var EPCTextButton   m_MainMenu, m_ResetToDefault;
var INT             m_IMainButtonsXPos, m_IMainButtonsHeight, m_IMainButtonsWidth, m_IMainButtonsYPos;
var INT             m_IResetToDefaultXPos;

var EPCTextButton   m_Controls;
var EPCTextButton   m_Graphics;
var EPCTextButton   m_Sounds;
var INT             m_iSectionButtonsYPos, m_iFirstSectionButtonsXPos, m_iSectionButtonsXOffset, m_iSectionButtonsWidth;


var EPCVideoConfigArea      m_GraphicArea;
var EPCSoundConfigArea      m_SoundsArea;
var EPCControlsConfigArea   m_ControlsArea;


var INT                  m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight;

var EPCMessageBox        m_MessageBox;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
// Joshua - Enhanced settings tab
var EPCTextButton   m_Enhanced;
var EPCEnhancedConfigArea   m_EnhancedArea;

// Joshua - Controller navigation variables
var INT             m_selectedTab;       // 0 = Controls, 1 = Graphics, 2 = Sounds, 3 = Enhanced
var INT             m_totalTabs;         // Total number of tabs (4)
var bool            m_bInArea;           // True when navigating inside an area
var bool            m_bJustExitedArea;   // Prevents double B press when exiting area

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
	SetAcceptsFocus();
    m_MainMenu  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_MainMenu.SetButtonText(Caps(Localize("HUD","MAINMENU","Localization\\HUD")) ,TXT_CENTER);
    m_MainMenu.Font = F_Normal;

    m_ResetToDefault = EPCTextButton(CreateControl(class'EPCTextButton', m_IResetToDefaultXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_ResetToDefault.SetButtonText(Caps(Localize("OPTIONS","RESETTODEFAULT","Localization\\HUD")) ,TXT_CENTER);
    m_ResetToDefault.Font = F_Normal;


    m_Controls    = EPCTextButton(CreateControl(class'EPCTextButton', m_iFirstSectionButtonsXPos, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Graphics    = EPCTextButton(CreateControl(class'EPCTextButton', m_Controls.WinLeft + m_iSectionButtonsWidth + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Sounds      = EPCTextButton(CreateControl(class'EPCTextButton', m_Graphics.WinLeft + m_iSectionButtonsWidth + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    // Joshua - Enhanced settings
    m_Enhanced    = EPCTextButton(CreateControl(class'EPCTextButton', m_Sounds.WinLeft + m_iSectionButtonsWidth + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));

    m_Controls.SetButtonText(Caps(Localize("HUD","CONTROLS","Localization\\HUD")) ,TXT_CENTER);
    m_Graphics.SetButtonText(Caps(Localize("HUD","GRAPHICS","Localization\\HUD")) ,TXT_CENTER);
    m_Sounds.SetButtonText(Caps(Localize("HUD","SOUNDS","Localization\\HUD")) ,TXT_CENTER);
    // Joshua - Enhanced settings
    m_Enhanced.SetButtonText(Caps(Localize("HUD","Enhanced","Localization\\Enhanced")) ,TXT_CENTER);

    m_Controls.Font         = F_Normal;
    m_Graphics.Font         = F_Normal;
    m_Sounds.Font           = F_Normal;
    m_Enhanced.Font         = F_Normal;  // Joshua - Enhanced settings

    m_GraphicArea = EPCVideoConfigArea(CreateWindow(class'EPCVideoConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_GraphicArea.HideWindow();

    m_SoundsArea = EPCSoundConfigArea(CreateWindow(class'EPCSoundConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_SoundsArea.HideWindow();

    m_ControlsArea = EPCControlsConfigArea(CreateWindow(class'EPCControlsConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_ControlsArea.HideWindow();

    // Joshua - Enhanced settings
    m_EnhancedArea = EPCEnhancedConfigArea(CreateWindow(class'EPCEnhancedConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_EnhancedArea.HideWindow();


    ChangeTopButtonSelection(m_Controls);

    // Joshua - Initialize controller navigation
    m_selectedTab = 0;
    m_totalTabs = 4;  // Controls, Graphics, Sounds, Enhanced
    m_bInArea = false;

    // Joshua - Initialize auto-scroll variables
    m_heldKey = 0;
    m_keyHoldTime = 0.0;
    m_nextRepeatTime = 0.0;
}

// Joshua - Highlight the selected tab
function HighlightSelectedTab(INT selectedTab_)
{
    switch (selectedTab_)
    {
        case 0:
            ChangeTopButtonSelection(m_Controls);
            break;
        case 1:
            ChangeTopButtonSelection(m_Graphics);
            break;
        case 2:
            ChangeTopButtonSelection(m_Sounds);
            break;
        case 3:
            ChangeTopButtonSelection(m_Enhanced);
            break;
    }
}

// Joshua - Enter the selected tab's content area
function SelectTab(INT selectedTab_)
{
    // First disable all areas to prevent stale controller input
    m_ControlsArea.EnableArea(false);
    m_GraphicArea.EnableArea(false);
    m_SoundsArea.EnableArea(false);
    m_EnhancedArea.EnableArea(false);

    m_bInArea = true;
    switch (selectedTab_)
    {
        case 0:
            m_ControlsArea.EnableArea(true);
            break;
        case 1:
            m_GraphicArea.EnableArea(true);
            break;
        case 2:
            m_SoundsArea.EnableArea(true);
            break;
        case 3:
            m_EnhancedArea.EnableArea(true);
            break;
    }
}

// Joshua - Exit from the current tab's content area back to tab selection
function ExitArea()
{
    m_bInArea = false;
    m_heldKey = 0;  // Joshua - Clear held key to prevent auto-scroll persisting
    m_keyHoldTime = 0;
    m_ControlsArea.EnableArea(false);
    m_GraphicArea.EnableArea(false);
    m_SoundsArea.EnableArea(false);
    m_EnhancedArea.EnableArea(false);
}

function ChangeTopButtonSelection(EPCTextButton _SelectMe)
{
    // Joshua - Disable all child areas when tab changes (safety check for mouse switching)
    m_ControlsArea.EnableArea(false);
    m_GraphicArea.EnableArea(false);
    m_SoundsArea.EnableArea(false);
    m_EnhancedArea.EnableArea(false);

    // Joshua - If we were in an area, exit back to tab level
    if (m_bInArea)
    {
        m_bInArea = false;
    }

    m_Controls.m_bSelected      =  false;
    m_Graphics.m_bSelected      =  false;
    m_Sounds.m_bSelected        =  false;
    m_Enhanced.m_bSelected      =  false; // Joshua - Enhanced settings

    m_GraphicArea.HideWindow();
    m_SoundsArea.HideWindow();
    m_ControlsArea.HideWindow();
    m_EnhancedArea.HideWindow(); // Joshua - Enhanced settings

    switch (_SelectMe)
    {
    case m_Controls:
        m_Controls.m_bSelected      =  true;
        m_ControlsArea.ShowWindow();
        m_selectedTab = 0;
        break;
    case m_Graphics:
        m_Graphics.m_bSelected      =  true;
        m_GraphicArea.ShowWindow();
        m_selectedTab = 1;
        break;
    case m_Sounds:
        m_Sounds.m_bSelected      =  true;
        m_SoundsArea.ShowWindow();
        m_selectedTab = 2;
        break;
    case m_Enhanced: // Joshua - Enhanced settings
        m_Enhanced.m_bSelected      =  true;
        m_EnhancedArea.ShowWindow();
        m_selectedTab = 3;
        break;
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
    PromptY = m_IMainButtonsYPos - 2; // Same Y as bottom buttons, raised 2 pixels
    PromptX = 68; // Start from left (Main Menu button position)

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
    PromptX += TextWidth + 15;

    // (X) Reset to Default - at Reset to Default button position
    PromptX = m_IResetToDefaultXPos;
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
    PromptText = Caps(Localize("OPTIONS", "RESETTODEFAULT", "Localization\\HUD"));
    C.DrawText(PromptText);
    C.TextSize(PromptText, TextWidth, TextHeight);
    PromptX += TextWidth + 15;

    // (Y) Info - shown only in Controls or Enhanced areas when current item has info
    if (ShouldShowInfoPrompt())
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
        PromptText = Caps(Localize("Common", "Info", "Localization\\Enhanced"));
        C.DrawText(PromptText);
    }
}

// Joshua - Check if Info prompt should be shown (only in Controls/Enhanced/Sound areas when item has info)
function bool ShouldShowInfoPrompt()
{
    // Check if Controls area is active (tab 0) and has an info item selected
    if (m_selectedTab == 0 && m_ControlsArea != None && m_ControlsArea.m_bEnableArea)
    {
        return m_ControlsArea.CurrentItemHasInfo();
    }

    // Check if Sound area is active (tab 2) and has an info item selected
    if (m_selectedTab == 2 && m_SoundsArea != None && m_SoundsArea.m_bEnableArea)
    {
        return m_SoundsArea.CurrentItemHasInfo();
    }

    // Check if Enhanced area is active (tab 3) and has an info item selected
    if (m_selectedTab == 3 && m_EnhancedArea != None && m_EnhancedArea.m_bEnableArea)
    {
        return m_EnhancedArea.CurrentItemHasInfo();
    }

    return false;
}

function ShowWindow()
{
    Super.ShowWindow();

	if (m_ControlsArea.m_bFirstRefresh)
		m_ControlsArea.Refresh();
	if (m_SoundsArea.m_bFirstRefresh)
		m_SoundsArea.Refresh();
    if (m_GraphicArea.m_bFirstRefresh)
		m_GraphicArea.Refresh();
    if (m_EnhancedArea.m_bFirstRefresh) // Joshua - Enhanced settings
		m_EnhancedArea.Refresh();

    // Joshua - Hide button labels in controller mode
    UpdateButtonLabelsForInputMode();
}

// Joshua - Show/hide button labels based on controller mode
function UpdateButtonLabelsForInputMode()
{
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        // Controller mode - hide buttons entirely (we show prompts instead)
        m_MainMenu.HideWindow();
        m_ResetToDefault.HideWindow();
    }
    else
    {
        // Keyboard/mouse mode - show buttons with labels
        m_MainMenu.ShowWindow();
        m_ResetToDefault.ShowWindow();

        m_MainMenu.SetButtonText(Caps(Localize("HUD","MAINMENU","Localization\\HUD")), TXT_CENTER);
        m_ResetToDefault.SetButtonText(Caps(Localize("OPTIONS","RESETTODEFAULT","Localization\\HUD")), TXT_CENTER);
    }
}

// Joshua - Called when controller mode changes (from Root)
function OnControllerModeChanged(bool bControllerMode)
{
    UpdateButtonLabelsForInputMode();

    if (!bControllerMode)
    {
        // Joshua - Clear item highlighting when switching to mouse (no item selection on mouse)
        m_ControlsArea.ClearHighlight();
        m_GraphicArea.ClearHighlight();
        m_SoundsArea.ClearHighlight();
        m_EnhancedArea.ClearHighlight();
    }
    else
    {
        // Joshua - Restore highlight when controller mode is re-enabled
        m_ControlsArea.RestoreHighlight();
        m_GraphicArea.RestoreHighlight();
        m_SoundsArea.RestoreHighlight();
        m_EnhancedArea.RestoreHighlight();
    }
}


function Notify(UWindowDialogControl C, byte E)
{

    if (E == DE_Click)
    {
        switch (C)
        {
        case m_MainMenu:
            if (m_SoundsArea.m_bModified || m_GraphicArea.m_bModified || m_ControlsArea.m_bModified || m_EnhancedArea.m_bModified)
                m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD"), Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
            else
            {
                ExitArea(); // Joshua - Reset areas when leaving via Main Menu button
                Root.ChangeCurrentWidget(WidgetID_MainMenu);
            }
            break;

        case m_Controls:
        case m_Graphics:
        case m_Sounds:
        case m_Enhanced: // Joshua - Enhanced settings
            ChangeTopButtonSelection(EPCTextButton(C));
            break;
        case m_ResetToDefault:
            if (m_Controls.m_bSelected)
            {
                m_ControlsArea.ResetToDefault();
            }
            else if (m_Graphics.m_bSelected)
            {
                m_GraphicArea.ResetToDefault();
            }
            else if (m_Sounds.m_bSelected)
            {
                m_SoundsArea.ResetToDefault();
            }
            else if (m_Enhanced.m_bSelected)
            {
                m_EnhancedArea.ResetToDefault();
            }
            break;
        }
    }
}

//Go Back to main menu with escape:
function EscapeMenu()
{
	if (!EPCConsole(Root.Console).bInGameMenuActive &&
	   m_ControlsArea.m_MessageBox == none)
	{
		Root.PlayClickSound();
		// Joshua - Reset areas when leaving via Escape
		ExitArea();
		Notify(m_MainMenu, DE_Click);
	}
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    local EPCGameOptions GO;

    if (m_MessageBox == W)
    {
        m_MessageBox = None;

        if (Result == MR_Yes)
        {
			GO = class'Actor'.static.GetGameOptions();
			GO.oldResolution = GO.Resolution;
			GO.oldEffectsQuality = GO.EffectsQuality;
			GO.oldShadowResolution = GO.ShadowResolution;

            //We chose to accept Settings Change
            m_GraphicArea.SaveOptions();
            m_SoundsArea.SaveOptions();
            m_ControlsArea.SaveOptions();
            m_EnhancedArea.SaveOptions();

            GO.UpdateEngineSettings();
        }
        else
        {
            //We chose to deny settings change
            GetPlayerOwner().LoadKeyboard();    //We make sure we don't take any keyboard modification in consideration
        }

        ExitArea(); // Joshua - Reset areas when leaving via message box
        Root.ChangeCurrentWidget(WidgetID_MainMenu);
    }

}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    super.WindowEvent(Msg, C, X, Y, Key);

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
        // Only handle navigation when not inside an area
        if (!m_bInArea)
        {
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

            // Navigate left through tabs - DPadLeft (214) or AnalogLeft (198)
            if (Key == 214 || Key == 198)
            {
                Root.PlayClickSound();
                m_selectedTab = (m_selectedTab - 1 + m_totalTabs) % m_totalTabs;
                HighlightSelectedTab(m_selectedTab);
            }
            // Navigate right through tabs - DPadRight (215) or AnalogRight (199)
            else if (Key == 215 || Key == 199)
            {
                Root.PlayClickSound();
                m_selectedTab = (m_selectedTab + 1) % m_totalTabs;
                HighlightSelectedTab(m_selectedTab);
            }
            // Select/Enter the current tab's area - A button (200)
            else if (Key == 200)
            {
                Root.PlayClickSound();
                SelectTab(m_selectedTab);
            }
            // Go back to main menu - B button (201)
            else if (Key == 201)
            {
                if (EPCMainMenuRootWindow(Root).m_MessageBox == None)
                {
                    Root.PlayClickSound();
                    ExitArea();
                    Notify(m_MainMenu, DE_Click);
                }
            }
        }

        // Reset to Default - X button (202) - works both in tab selection and inside areas
        if (Key == 202)
        {
            Root.PlayClickSound();
            Notify(m_ResetToDefault, DE_Click);
        }
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
        // Navigate left through tabs
        if (m_heldKey == 214 || m_heldKey == 198)
        {
            Root.PlayClickSound();
            m_selectedTab = (m_selectedTab - 1 + m_totalTabs) % m_totalTabs;
            HighlightSelectedTab(m_selectedTab);
        }
        // Navigate right through tabs
        else if (m_heldKey == 215 || m_heldKey == 199)
        {
            Root.PlayClickSound();
            m_selectedTab = (m_selectedTab + 1) % m_totalTabs;
            HighlightSelectedTab(m_selectedTab);
        }

        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

// Joshua - Called by config areas when they want to exit back to tab selection
function AreaExited()
{
    m_bInArea = false;
    m_bJustExitedArea = true; // Prevent B button from immediately going to main menu
}

defaultproperties
{
    m_IMainButtonsXPos=68
    m_IMainButtonsHeight=18
    m_IMainButtonsWidth=240
    m_IMainButtonsYPos=353
    m_IResetToDefaultXPos=330
    m_iSectionButtonsYPos=143
    m_iFirstSectionButtonsXPos=86
    m_iSectionButtonsXOffset=5
    m_iSectionButtonsWidth=113 // Joshua - Reduced from 153 to fit "Enhanced" button in Settings
    m_IAreaXPos=83
    m_IAreaYPos=175
    m_IAreaWidth=475
    m_IAreaHeight=155
    m_initialDelay=0.5
    m_repeatRate=0.1
}