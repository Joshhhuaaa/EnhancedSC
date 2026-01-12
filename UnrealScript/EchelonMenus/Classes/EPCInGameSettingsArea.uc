//=============================================================================
//  EPCInGameSettingsArea.uc : In Game Options Area
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/06 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameSettingsArea extends EPCOptionsMenu
                native;

#exec OBJ LOAD FILE=..\Textures\HUD_Enhanced.utx

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var bool m_bAreaEnabled;  // True when this section is active for controller input

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    m_Controls    = EPCTextButton(CreateControl(class'EPCTextButton', m_iFirstSectionButtonsXPos, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Graphics    = EPCTextButton(CreateControl(class'EPCTextButton', m_Controls.WinLeft + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Sounds      = EPCTextButton(CreateControl(class'EPCTextButton', m_Graphics.WinLeft + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    // Joshua - Enhanced settings
    m_Enhanced    = EPCTextButton(CreateControl(class'EPCTextButton', m_Sounds.WinLeft + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));

    m_Controls.SetButtonText(Caps(Localize("HUD","CONTROLS","Localization\\HUD")) ,TXT_CENTER);
    m_Graphics.SetButtonText(Caps(Localize("HUD","GRAPHICS","Localization\\HUD")) ,TXT_CENTER);
    m_Sounds.SetButtonText(Caps(Localize("HUD","SOUNDS","Localization\\HUD")) ,TXT_CENTER);
    // Joshua - Enhanced settings
    m_Enhanced.SetButtonText(Caps(Localize("HUD","Enhanced","Localization\\Enhanced")) ,TXT_CENTER);

    m_Controls.Font         = EPCMainMenuRootWindow(Root).TitleFont;
    m_Graphics.Font         = EPCMainMenuRootWindow(Root).TitleFont;
    m_Sounds.Font           = EPCMainMenuRootWindow(Root).TitleFont;
    m_Enhanced.Font         = EPCMainMenuRootWindow(Root).TitleFont;  // Joshua - Enhanced settings

    m_GraphicArea = EPCVideoConfigArea(CreateWindow(class'EPCInGameVideoConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_GraphicArea.HideWindow();

    m_SoundsArea = EPCSoundConfigArea(CreateWindow(class'EPCInGameSoundConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_SoundsArea.HideWindow();

    // Joshua - Enhanced settings
    m_EnhancedArea = EPCEnhancedConfigArea(CreateWindow(class'EPCInGameEnhancedConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_EnhancedArea.HideWindow();

    m_ControlsArea = EPCControlsConfigArea(CreateWindow(class'EPCInGameControlsConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_ControlsArea.HideWindow();

    ChangeTopButtonSelection(m_Controls);

    // Joshua - Initialize auto-scroll variables
    m_heldKey = 0;
    m_keyHoldTime = 0.0;
    m_nextRepeatTime = 0.0;
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
    m_Enhanced.m_bSelected      =  false;  // Joshua - Enhanced settings

    m_GraphicArea.HideWindow();
    m_SoundsArea.HideWindow();
    m_ControlsArea.HideWindow();
    m_EnhancedArea.HideWindow();  // Joshua - Enhanced settings

    switch (_SelectMe)
    {
    case m_Controls:
        m_Controls.m_bSelected      =  true;
        m_ControlsArea.ShowWindow();
        m_selectedTab = 0;  // Joshua - Keep m_selectedTab in sync
        break;
    case m_Graphics:
        m_Graphics.m_bSelected      =  true;
        m_GraphicArea.ShowWindow();
        m_selectedTab = 1;  // Joshua - Keep m_selectedTab in sync
        break;
    case m_Sounds:
        m_Sounds.m_bSelected        =  true;
        m_SoundsArea.ShowWindow();
        m_selectedTab = 2;  // Joshua - Keep m_selectedTab in sync
        break;
    case m_Enhanced:  // Joshua - Enhanced settings
        m_Enhanced.m_bSelected      =  true;
        m_EnhancedArea.ShowWindow();
        m_selectedTab = 3;  // Joshua - Keep m_selectedTab in sync
        break;
    }
}

function Reset()
{
    m_ControlsArea.Refresh();
    m_SoundsArea.Refresh();
    m_GraphicArea.Refresh();
    m_EnhancedArea.Refresh();

	if (m_Sounds.m_bSelected)
		ChangeTopButtonSelection(m_Sounds);
	else if (m_Graphics.m_bSelected)
		ChangeTopButtonSelection(m_Graphics);
	else if (m_Controls.m_bSelected)
		ChangeTopButtonSelection(m_Controls);
    else if (m_Enhanced.m_bSelected)
        ChangeTopButtonSelection(m_Enhanced);
    else
        ChangeTopButtonSelection(m_Controls);  // Default to Controls if nothing selected
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);

    // Joshua - Draw only X (Reset to Default) prompt - A/B handled by EPCInGameMenu parent
    // Hide PC Reset to Default button in controller mode
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        m_ResetToDefault.HideWindow();
        if (m_bAreaEnabled)
        {
            DrawResetPrompt(C);
        }
    }
    else
    {
        m_ResetToDefault.ShowWindow();
    }
}

// Joshua - Draw only the X Reset to Default prompt and Y Info (A/B handled by parent EPCInGameMenu)
function DrawResetPrompt(Canvas C)
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
    PromptY = 261; // Bottom of the area
    // X button at same screen position as X Main Menu (330), offset by window position (126)
    PromptX = EPCInGameMenu(ParentWindow).m_IGoToGameButtonXPos - EPCInGameMenu(ParentWindow).m_IAreaXPos;

    IconColor.R = 128;
    IconColor.G = 128;
    IconColor.B = 128;
    IconColor.A = 255;

    TextColor.R = 71;
    TextColor.G = 71;
    TextColor.B = 71;
    TextColor.A = 255;

    C.Font = Root.Fonts[F_Normal];

    // (X) Reset to Default
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
                C.DrawTile(Texture'HUD.HUD.ETMENU', IconSize, IconSize, 115, 1, 22, 22);
                break;
        }
        PromptX += IconSize + 8;
        C.DrawColor = TextColor;
        C.SetPos(PromptX, PromptY + 3);
        PromptText = Caps(Localize("Common", "Info", "Localization\\Enhanced"));
        C.DrawText(PromptText);
    }
}


// Joshua - Enable/disable this area for controller navigation
// This overrides EPCOptionsMenu behavior to work with EPCInGameMenu
function EnableArea(bool bEnable)
{
    m_bAreaEnabled = bEnable;

    if (bEnable)
    {
        // If we were already inside a child area (switching back from mouse to controller),
        // re-enable that child area so it selects the first visible item
        if (m_bInArea)
        {
            // Re-enable the currently active child area, this will select first visible item
            switch (m_selectedTab)
            {
                case 0: m_ControlsArea.EnableArea(true); break;
                case 1: m_GraphicArea.EnableArea(true); break;
                case 2: m_SoundsArea.EnableArea(true); break;
                case 3: m_EnhancedArea.EnableArea(true); break;
            }
        }
        else
        {
            // Start at tab level (not inside an area)
            // Make sure child areas are disabled but visible content is shown
            m_ControlsArea.EnableArea(false);
            m_GraphicArea.EnableArea(false);
            m_SoundsArea.EnableArea(false);
            m_EnhancedArea.EnableArea(false);
        }

        // Update tab button visuals without calling ChangeTopButtonSelection
        // which would disable all areas and reset scroll positions
        UpdateTabSelectionVisualOnly();
    }
    else
    {
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;

        // Disable child areas when leaving
        m_ControlsArea.EnableArea(false);
        m_GraphicArea.EnableArea(false);
        m_SoundsArea.EnableArea(false);
        m_EnhancedArea.EnableArea(false);

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
    m_Controls.m_bSelected = false;
    m_Graphics.m_bSelected = false;
    m_Sounds.m_bSelected = false;
    m_Enhanced.m_bSelected = false;
}

// Joshua - Restore tab selection based on m_selectedTab (when switching to keyboard/mouse)
function RestoreTabSelection()
{
    UpdateTabSelection();

    // Also clear item highlighting in all config areas (no item selection on mouse)
    m_ControlsArea.ClearHighlight();
    m_GraphicArea.ClearHighlight();
    m_SoundsArea.ClearHighlight();
    m_EnhancedArea.ClearHighlight();
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    // Don't process controller input if area is not enabled
    // Still call Super for non-controller events (paint, mouse, etc.)
    if (!m_bAreaEnabled)
    {
        // Block controller keys when area is not enabled
        if (Msg == WM_KeyDown && Key >= 196 && Key <= 215)
            return;

        Super.WindowEvent(Msg, C, X, Y, Key);
        return;
    }

    // Track key releases for auto-repeat
    if (Msg == WM_KeyUp)
    {
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0;
        }
    }

    // Handle controller input on KeyDown
    if (Msg == WM_KeyDown)
    {
        // Track repeatable keys for tabs (left/right) when at tab level
        if (!m_bInArea && (Key == 214 || Key == 198 || Key == 215 || Key == 199))
        {
            if (Key != m_heldKey)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        // B button - handle specially for in-game menu
        if (Key == 201)
        {
            HandleBButton();
            return;  // Don't let B reach parent class
        }

        // X button - Reset to Default (works both at tab level and inside areas)
        if (Key == 202)
        {
            Root.PlayClickSound();
            ResetCurrentTabToDefault();
            return;
        }

        // Only handle tab navigation when at tab level (not inside a child area)
        if (!m_bInArea)
        {
            // Left - previous tab
            if (Key == 214 || Key == 198)
            {
                Root.PlayClickSound();
                if (m_selectedTab > 0)
                    m_selectedTab = m_selectedTab - 1;
                else
                    m_selectedTab = 3;  // Wrap to Enhanced
                UpdateTabSelection();
                return;
            }
            // Right - next tab
            else if (Key == 215 || Key == 199)
            {
                Root.PlayClickSound();
                if (m_selectedTab < 3)
                    m_selectedTab = m_selectedTab + 1;
                else
                    m_selectedTab = 0;  // Wrap to Controls
                UpdateTabSelection();
                return;
            }
            // A - enter selected tab's content area
            else if (Key == 200)
            {
                Root.PlayClickSound();
                SelectTab(m_selectedTab);
                return;
            }
        }
        else
        {
            // Inside a child area - let parent/child handle navigation
            // But block controller nav keys from parent's tab handling
            if (Key == 214 || Key == 198 || Key == 215 || Key == 199 || Key == 200)
            {
                // Let child areas handle these via Super
                Super.WindowEvent(Msg, C, X, Y, Key);
                return;
            }
        }
    }

    // Let parent handle other input
    Super.WindowEvent(Msg, C, X, Y, Key);
}

// Joshua - Tick function for auto-repeat tab navigation
function Tick(float Delta)
{
    Super.Tick(Delta);

    // Only repeat tabs when at tab level and enabled
    if (!m_bAreaEnabled || m_heldKey == 0 || m_bInArea)
        return;

    m_keyHoldTime += Delta;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Left - previous tab
        if (m_heldKey == 214 || m_heldKey == 198)
        {
            Root.PlayClickSound();
            if (m_selectedTab > 0)
                m_selectedTab = m_selectedTab - 1;
            else
                m_selectedTab = 3;
            UpdateTabSelection();
        }
        // Right - next tab
        else if (m_heldKey == 215 || m_heldKey == 199)
        {
            Root.PlayClickSound();
            if (m_selectedTab < 3)
                m_selectedTab = m_selectedTab + 1;
            else
                m_selectedTab = 0;
            UpdateTabSelection();
        }

        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

function HandleBButton()
{
    if (!m_bInArea)
    {
        // At tab level - exit back to section selection
        Root.PlayClickSound();
        EPCInGameMenu(ParentWindow).SectionExited();
    }
    else
    {
        // Inside a child area - go back to tab level
        Root.PlayClickSound();
        ExitArea();  // Inherited from EPCOptionsMenu
    }
}

// Update tab visual selection based on m_selectedTab
function UpdateTabSelection()
{
    switch (m_selectedTab)
    {
        case 0: ChangeTopButtonSelection(m_Controls); break;
        case 1: ChangeTopButtonSelection(m_Graphics); break;
        case 2: ChangeTopButtonSelection(m_Sounds); break;
        case 3: ChangeTopButtonSelection(m_Enhanced); break;
    }
}

// Joshua - Update tab button visuals only without calling ChangeTopButtonSelection
// This avoids resetting scroll positions and disabling areas
function UpdateTabSelectionVisualOnly()
{
    // Clear all tab selections
    m_Controls.m_bSelected = false;
    m_Graphics.m_bSelected = false;
    m_Sounds.m_bSelected = false;
    m_Enhanced.m_bSelected = false;

    // Set the selected tab
    switch (m_selectedTab)
    {
        case 0: m_Controls.m_bSelected = true; break;
        case 1: m_Graphics.m_bSelected = true; break;
        case 2: m_Sounds.m_bSelected = true; break;
        case 3: m_Enhanced.m_bSelected = true; break;
    }
}

// Override AreaExited to stay in this section (just go back to tab level)
function AreaExited()
{
    m_bInArea = false;  // Return to tab level, don't exit section
    m_bJustExitedArea = true;
}

// Joshua - Reset the current tab to default settings
function ResetCurrentTabToDefault()
{
    switch (m_selectedTab)
    {
        case 0: m_ControlsArea.ResetToDefault(); break;
        case 1: m_GraphicArea.ResetToDefault(); break;
        case 2: m_SoundsArea.ResetToDefault(); break;
        case 3: m_EnhancedArea.ResetToDefault(); break;
    }
}

defaultproperties
{
    m_iSectionButtonsYPos=5
    m_iFirstSectionButtonsXPos=6
    m_iSectionButtonsXOffset=110 // Joshua - Reduced from 148 to fit "Enhanced" button in Settings
    m_iSectionButtonsWidth=108 // Joshua - Reduced from 144 to fit "Enhanced" button in Settings
    m_IAreaXPos=7
    m_IAreaYPos=37
    m_IAreaWidth=434
    m_IAreaHeight=206
    m_initialDelay=0.5
    m_repeatRate=0.1
}