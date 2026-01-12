//=============================================================================
//  EPCCreatePlayerArea.uc : Area of control to create a player profile
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/15 * Created by Alexandre Dionne
//=============================================================================
class EPCCreatePlayerArea extends UWindowDialogClientWindow
    config(Enhanced);

var EPCTextButton   m_ResetAllButton;     // To return to main menu
var INT             m_IResetAllXPos, m_IResetAllButtonsHeight, m_IResetAllButtonsWidth, m_IResetAllButtonsYPos;


var UWindowLabelControl     m_LPlayerName;      //Title
var UWindowLabelControl     m_LDifficulty;      //Title
var UWindowLabelControl     m_LDifficultyNormal;
var UWindowLabelControl     m_LDifficultyHard;
var UWindowLabelControl     m_LDifficultyElite; // Joshua - Added Elite difficulty
var UWindowLabelControl     m_LPermadeathMode; // Joshua - Added Permadeath

var EPCEditControl          m_EPlayerName;      //Value

var EPCCheckBox             m_DifficultyNormal, m_DifficultyHard, m_DifficultyElite; // Joshua - Added Elite difficulty
var EPCCheckBox             m_PermadeathMode;

// Joshua - Info buttons for tooltips
var EPCInfoButton           m_EliteInfoButton;
var EPCInfoButton           m_PermadeathInfoButton;

var INT                     m_IXLabelPos, m_ILabelHeight, m_ILabelWidth;
var INT                     m_IPlayerNameYPos, m_IPlayerNameOffset, m_IPlayerNameWidth;
var INT                     m_IDifficultyXOffset, m_IDifficultyYPos, m_IDifficultyYOffset, m_IDifficultyRadioYPos, m_IRadioWidth;

var Color                   m_EditBorderColor;
var Color                   m_TextColor;

// Joshua - Controller navigation
var bool    m_bEnableArea;           // True when area is active for controller navigation
var int     m_selectedItemIndex;     // Currently selected item index
var int     m_totalItems;            // Total selectable items (5)
var bool    m_bProfileNameFocused;   // True when editing profile name with controller
var int     m_profileNumber;         // 1-10 for Profile01-Profile10

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

// Joshua - Tooltip persistence
var config array<string>    ViewedTooltips;

// Joshua - Shared info button pulse animation state
var float InfoButtonPulseTimer;
var bool bInfoButtonPulseIncreasing;

function Created()
{
    SetAcceptsFocus();

    m_LPlayerName       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IXLabelPos, m_IPlayerNameYPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficulty       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IXLabelPos, m_IDifficultyYPos, m_ILabelWidth, m_ILabelHeight, self));

    m_EPlayerName       = EPCEditControl(CreateWindow(class'EPCEditControl', m_LPlayerName.WinLeft + m_LPlayerName.WinWidth + m_IPlayerNameOffset, m_IPlayerNameYPos, m_IPlayerNameWidth, m_ILabelHeight, self));

    m_EPlayerName.SetBorderColor(m_EditBorderColor);
    m_EPlayerName.SetEditTextColor(m_EditBorderColor);

	// Set Profile name length to a maximum of 15 characters
    // Joshua - Reduced from 17 to 15 to match save games
    m_EPlayerName.SetMaxLength(15);

    m_LDifficultyNormal = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficultyHard   = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos + m_IDifficultyYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficultyElite   = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos + m_IDifficultyYOffset * 2, m_ILabelWidth, m_ILabelHeight, self));

    m_ResetAllButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_IResetAllXPos, m_IResetAllButtonsYPos, m_IResetAllButtonsWidth, m_IResetAllButtonsHeight, self));

    m_DifficultyNormal  = EPCCheckBox(CreateControl(class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyNormal.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyHard    = EPCCheckBox(CreateControl(class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyHard.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyElite    = EPCCheckBox(CreateControl(class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyElite.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyNormal.m_bSelected  = true;
    m_DifficultyNormal.ImageX       = 5;
    m_DifficultyNormal.ImageY       = 5;
    m_DifficultyHard.ImageX         = 5;
    m_DifficultyHard.ImageY         = 5;
    m_DifficultyElite.ImageX         = 5;
    m_DifficultyElite.ImageY         = 5;

    m_ResetAllButton.SetButtonText(Caps(Localize("HUD","CLEARALL","Localization\\HUD")) ,TXT_CENTER);

    m_LPlayerName.SetLabelText(Localize("HUD","PLAYERNAME","Localization\\HUD"),TXT_LEFT);
    m_LDifficulty.SetLabelText(Localize("HUD","DIFFICULTY","Localization\\HUD"),TXT_LEFT);
    m_LDifficultyNormal.SetLabelText(Localize("HUD","Normal","Localization\\HUD"),TXT_LEFT);
    m_LDifficultyHard.SetLabelText(Localize("HUD","Hard","Localization\\HUD"),TXT_LEFT);
    m_LDifficultyElite.SetLabelText(Localize("Common","Elite","Localization\\Enhanced"),TXT_LEFT);


    m_ResetAllButton.Font     = F_Normal;
    m_LPlayerName.Font        = F_Normal;
    m_LDifficulty.Font        = F_Normal;
    m_LDifficultyNormal.Font  = F_Normal;
    m_LDifficultyHard.Font    = F_Normal;
    m_LDifficultyElite.Font    = F_Normal;

    m_LPlayerName.TextColor         = m_TextColor;
    m_LDifficulty.TextColor         = m_TextColor;
    m_LDifficultyNormal.TextColor   = m_TextColor;
    m_LDifficultyHard.TextColor     = m_TextColor;
    m_LDifficultyElite.TextColor     = m_TextColor;
    m_LDifficultyElite.bAcceptsMouseFocus = false; // Joshua - Don't let label interfere with info button clicks

    // Joshua - Permadeath
    m_LPermadeathMode = UWindowLabelControl(CreateWindow(class'UWindowLabelControl',
        m_IXLabelPos,
        m_LDifficultyElite.WinTop + m_IDifficultyYOffset,
        m_ILabelWidth, m_ILabelHeight, self));

    m_PermadeathMode = EPCCheckBox(CreateControl(class'EPCCheckBox',
        m_EPlayerName.WinLeft,
        m_LPermadeathMode.WinTop,
        m_IRadioWidth, m_ILabelHeight, self));

    m_PermadeathMode.ImageX = 5;
    m_PermadeathMode.ImageY = 5;
    m_PermadeathMode.bDisabled = true;

    m_LPermadeathMode.SetLabelText(Localize("Common", "PermadeathMode", "Localization\\Enhanced"), TXT_LEFT);
    m_LPermadeathMode.Font = F_Normal;
    m_LPermadeathMode.TextColor = m_TextColor;
    m_LPermadeathMode.bAcceptsMouseFocus = false; // Joshua - Don't let label interfere with info button clicks

    // Joshua - Initialize pulse animation
    InfoButtonPulseTimer = 0.0;
    bInfoButtonPulseIncreasing = true;

    // Joshua - Create info button for Elite difficulty (position set in BeforePaint)
    m_EliteInfoButton = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16, self));
    m_EliteInfoButton.InfoText = Localize("Common", "Elite_Desc", "Localization\\Enhanced");
    m_EliteInfoButton.SettingName = Localize("Common", "Elite", "Localization\\Enhanced");
    m_EliteInfoButton.LocalizationKey = "Elite";
    m_EliteInfoButton.bStopPulsing = HasViewedTooltip("Elite");

    // Joshua - Create info button for Permadeath (position set in BeforePaint)
    m_PermadeathInfoButton = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16, self));
    m_PermadeathInfoButton.InfoText = Localize("Common", "PermadeathMode_Desc", "Localization\\Enhanced");
    m_PermadeathInfoButton.SettingName = Localize("Common", "PermadeathMode", "Localization\\Enhanced");
    m_PermadeathInfoButton.LocalizationKey = "PermadeathMode";
    m_PermadeathInfoButton.bStopPulsing = HasViewedTooltip("PermadeathMode");

    // Joshua - Initialize controller navigation
    m_totalItems = 5; // Player Name, Normal, Hard, Elite, Permadeath
    m_bEnableArea = false;
    m_selectedItemIndex = 0;

    // Joshua - Initialize auto-scroll variables
    m_heldKey = 0;
    m_keyHoldTime = 0.0;
    m_nextRepeatTime = 0.0;
}

// Joshua - Update pulse animation for info buttons and position them
function BeforePaint(Canvas C, float X, float Y)
{
    local float TextWidth, TextHeight;

    Super.BeforePaint(C, X, Y);

    // Position info buttons 5 pixels after their label text
    C.Font = Root.Fonts[F_Normal];

    // Elite info button
    TextSize(C, m_LDifficultyElite.Text, TextWidth, TextHeight);
    m_EliteInfoButton.WinLeft = m_LDifficultyElite.WinLeft + TextWidth + 5;
    m_EliteInfoButton.WinTop = m_LDifficultyElite.WinTop + (m_LDifficultyElite.WinHeight - 16) / 2;

    // Permadeath info button
    TextSize(C, m_LPermadeathMode.Text, TextWidth, TextHeight);
    m_PermadeathInfoButton.WinLeft = m_LPermadeathMode.WinLeft + TextWidth + 5;
    m_PermadeathInfoButton.WinTop = m_LPermadeathMode.WinTop + (m_LPermadeathMode.WinHeight - 16) / 2;

    // Joshua - Ensure text is selected when in controller mode and profile name is focused
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive && m_bProfileNameFocused && m_EPlayerName != None && m_EPlayerName.EditBox != None)
    {
        // Check if text is not already fully selected
        if (m_EPlayerName.EditBox.CaretOffset != Len(m_EPlayerName.EditBox.Value) || !m_EPlayerName.EditBox.bAllSelected)
        {
            m_EPlayerName.SelectAll();
        }
    }
}

//==============================================================================
// Paint - Joshua - Draw selection bar behind selected label
//==============================================================================
function Paint(Canvas C, float X, float Y)
{
    local UWindowLabelControl SelectedLabel;
    local Color BarColor;
    local float TextWidth, TextHeight;
    local int i;

    Super.Paint(C, X, Y);

    // Only draw selection bar when in controller mode
    if (!m_bEnableArea)
        return;

    // Get the selected label based on index
    switch (m_selectedItemIndex)
    {
        case 0: SelectedLabel = m_LPlayerName; break;
        case 1: SelectedLabel = m_LDifficultyNormal; break;
        case 2: SelectedLabel = m_LDifficultyHard; break;
        case 3: SelectedLabel = m_LDifficultyElite; break;
        case 4: SelectedLabel = m_LPermadeathMode; break;
        default: return;
    }

    if (SelectedLabel == None)
        return;

    // Measure text width
    C.Font = Root.Fonts[F_Normal];
    TextSize(C, SelectedLabel.Text, TextWidth, TextHeight);

    // Set up bar drawing
    C.Style = 5; // STY_Alpha
    BarColor.R = 71;
    BarColor.G = 71;
    BarColor.B = 71;
    BarColor.A = 180;
    C.DrawColor = BarColor;

    // Draw dark selection bar using individual pixels
    for (i = SelectedLabel.WinLeft - 2; i < SelectedLabel.WinLeft + TextWidth + 4; i++)
    {
        C.SetPos(i, SelectedLabel.WinTop);
        C.DrawTile(Texture'UWindow.ETPixel', 1, SelectedLabel.WinHeight, 0, 0, 1, 1);
    }
}

// Joshua - Check if a tooltip has been viewed before
function bool HasViewedTooltip(string TooltipKey)
{
    local int i;

    for (i = 0; i < ViewedTooltips.Length; i++)
    {
        if (ViewedTooltips[i] == TooltipKey)
            return true;
    }

    return false;
}

// Joshua - Mark a tooltip as viewed and save config
function MarkTooltipViewed(string TooltipKey)
{
    if (!HasViewedTooltip(TooltipKey))
    {
        ViewedTooltips[ViewedTooltips.Length] = TooltipKey;
        SaveConfig();
    }
}

function String GetProfileName()
{
    return m_EPlayerName.GetValue();
}

function INT GetDifficulty()
{
    local EPlayerController EPC;
    local int baseDifficulty;
    EPC = EPlayerController(GetPlayerOwner());

    if (m_DifficultyNormal.m_bSelected)
        baseDifficulty = 0;
    else if (m_DifficultyHard.m_bSelected)
        baseDifficulty = 1;
    else if (m_DifficultyElite.m_bSelected)
        baseDifficulty = 2;

    // Add permadeath offset (2) if enabled and not Normal difficulty
    if (m_PermadeathMode.m_bSelected && !m_DifficultyNormal.m_bSelected)
        return baseDifficulty + 2;
    else
        return baseDifficulty;
}

function Reset()
{
    m_EPlayerName.Clear();
    m_DifficultyNormal.m_bSelected  = true;
    m_DifficultyHard.m_bSelected    = false;
    m_DifficultyElite.m_bSelected    = false;
    m_PermadeathMode.m_bSelected = false;
}

function Notify(UWindowDialogControl C, byte E)
{
	if (E == DE_Click)
	{
        switch (C)
        {
        case m_DifficultyNormal:
            m_DifficultyNormal.m_bSelected = true;
            m_DifficultyHard.m_bSelected = false;
            m_DifficultyElite.m_bSelected = false;
            m_PermadeathMode.m_bSelected = false; // Force disable permadeath
            m_PermadeathMode.bDisabled = true;    // Gray out permadeath option
            break;
        case m_DifficultyHard:
            m_DifficultyHard.m_bSelected = true;
            m_DifficultyNormal.m_bSelected = false;
            m_DifficultyElite.m_bSelected = false;
            m_PermadeathMode.bDisabled = false; // Enable permadeath option
            break;
        case m_DifficultyElite:
            m_DifficultyElite.m_bSelected = true;
            m_DifficultyNormal.m_bSelected = false;
            m_DifficultyHard.m_bSelected = false;
            m_PermadeathMode.bDisabled = false; // Enable permadeath option
            break;
        case m_PermadeathMode:
                break;
        case m_ResetAllButton:
            Reset();
            break;
        }
    }
}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    m_bEnableArea = bEnable;

    if (bEnable)
    {
        // Start at player name field (index 0)
        m_selectedItemIndex = 0;
        m_bProfileNameFocused = false;
        m_profileNumber = 1;  // Default to Profile01
        HighlightSelectedItem(m_selectedItemIndex);
    }
    else
    {
        m_bProfileNameFocused = false;
        ClearHighlight();
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
    }
}

// Joshua - Called when controller mode changes (from parent)
function OnControllerModeChanged(bool bControllerMode)
{
    // If switching back to controller mode and we're in profile name focus, select all text
    if (bControllerMode && m_bProfileNameFocused && m_EPlayerName != None)
    {
        m_EPlayerName.SelectAll();
    }
}

// Joshua - Clear all highlights
function ClearHighlight()
{
    m_LPlayerName.TextColor = m_TextColor;
    m_LDifficultyNormal.TextColor = m_TextColor;
    m_LDifficultyHard.TextColor = m_TextColor;
    m_LDifficultyElite.TextColor = m_TextColor;
    m_LPermadeathMode.TextColor = m_TextColor;
}

// Joshua - Highlight the selected item with black text (like EPCEnhancedConfigArea)
function HighlightSelectedItem(int Index)
{
    local Color HighlightColor;

    ClearHighlight();

    // White text on dark selection bar
    HighlightColor.R = 255;
    HighlightColor.G = 255;
    HighlightColor.B = 255;
    HighlightColor.A = 255;

    switch (Index)
    {
        case 0:
            m_LPlayerName.TextColor = HighlightColor;
            break;
        case 1:
            m_LDifficultyNormal.TextColor = HighlightColor;
            break;
        case 2:
            m_LDifficultyHard.TextColor = HighlightColor;
            break;
        case 3:
            m_LDifficultyElite.TextColor = HighlightColor;
            break;
        case 4:
            m_LPermadeathMode.TextColor = HighlightColor;
            break;
    }
}

// Joshua - Activate the selected item
function ActivateSelectedItem()
{
    switch (m_selectedItemIndex)
    {
        case 0: // Player Name - enter profile name focus
            m_bProfileNameFocused = true;
            m_EPlayerName.SetValue(GetProfileNameString(m_profileNumber));
            m_EPlayerName.SelectAll(); // Highlight all text when focused
            break;
        case 1: // Normal
            Notify(m_DifficultyNormal, DE_Click);
            break;
        case 2: // Hard
            Notify(m_DifficultyHard, DE_Click);
            break;
        case 3: // Elite
            Notify(m_DifficultyElite, DE_Click);
            break;
        case 4: // Permadeath
            if (!m_PermadeathMode.bDisabled)
            {
                m_PermadeathMode.m_bSelected = !m_PermadeathMode.m_bSelected;
                Notify(m_PermadeathMode, DE_Click);
            }
            break;
    }
}

// Joshua - Get formatted profile name string (Profile01-Profile10)
function string GetProfileNameString(int ProfileNum)
{
    local string ProfileText;

    ProfileText = Localize("Common", "Profile", "Localization\\Enhanced");

    if (ProfileNum < 10)
        return ProfileText $ "0" $ string(ProfileNum);
    else
        return ProfileText $ string(ProfileNum);
}

// Joshua - Cycle profile number up (with wrap)
function CycleProfileUp()
{
    if (m_profileNumber <= 1)
        m_profileNumber = 10;
    else
        m_profileNumber = m_profileNumber - 1;

    m_EPlayerName.SetValue(GetProfileNameString(m_profileNumber));
    m_EPlayerName.MoveCaretToEnd(); // Move cursor to end so typing appends
}

// Joshua - Cycle profile number down (with wrap)
function CycleProfileDown()
{
    if (m_profileNumber >= 10)
        m_profileNumber = 1;
    else
        m_profileNumber = m_profileNumber + 1;

    m_EPlayerName.SetValue(GetProfileNameString(m_profileNumber));
    m_EPlayerName.MoveCaretToEnd(); // Move cursor to end so typing appends
}

// Joshua - Show tooltip for the selected item (Y button)
function ShowSelectedItemTooltip()
{
    switch (m_selectedItemIndex)
    {
        case 3: // Elite has tooltip
            if (m_EliteInfoButton != None && m_EliteInfoButton.InfoText != "")
            {
                m_EliteInfoButton.Click(0, 0);
                Root.PlayClickSound();
            }
            break;
        case 4: // Permadeath has tooltip
            if (m_PermadeathInfoButton != None && m_PermadeathInfoButton.InfoText != "")
            {
                m_PermadeathInfoButton.Click(0, 0);
                Root.PlayClickSound();
            }
            break;
    }
}

// Joshua - Check if current item has an info button (for controller prompts)
function bool CurrentItemHasInfo()
{
    if (!m_bEnableArea)
        return false;

    // Only Elite (3) and Permadeath (4) have info buttons
    return (m_selectedItemIndex == 3 || m_selectedItemIndex == 4);
}

// Joshua - Check if profile name field is focused (after pressing A) for Y button Clear All
function bool IsProfileNameFocused()
{
    return (m_bEnableArea && m_selectedItemIndex == 0 && m_bProfileNameFocused);
}

// Joshua - Check if Y button should show anything (profile name focused for Clear All, or info items)
function bool ShouldShowYButton()
{
    if (!m_bEnableArea)
        return false;

    // Y shows Clear All only when profile name is focused (after A press), or Info on Elite (3) / Permadeath (4)
    return (m_bProfileNameFocused || m_selectedItemIndex == 3 || m_selectedItemIndex == 4);
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    Super.WindowEvent(Msg, C, X, Y, Key);

    if (!m_bEnableArea)
        return;

    if (Msg == WM_KeyDown)
    {
        // Track held key for auto-repeat (only for navigation keys)
        if (Key == 213 || Key == 197 || Key == 212 || Key == 196)
        {
            if (m_heldKey != Key)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0.0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        // If we're in profile name focus, handle differently
        if (m_bProfileNameFocused)
        {
            // Navigate down - DPadDown (213) or AnalogDown (197), cycle to next profile
            if (Key == 213 || Key == 197)
            {
                Root.PlayClickSound();
                CycleProfileDown();
            }
            // DPadUp (212) or AnalogUp (196) - cycle to previous profile
            else if (Key == 212 || Key == 196)
            {
                Root.PlayClickSound();
                CycleProfileUp();
            }
            // A button - confirm profile name and exit focus
            else if (Key == 200)
            {
                Root.PlayClickSound();
                m_bProfileNameFocused = false;
                m_heldKey = 0;  // Clear held key when exiting focus
            }
            // B button - exit profile name focus
            else if (Key == 201)
            {
                Root.PlayClickSound();
                m_bProfileNameFocused = false;
                m_heldKey = 0;  // Clear held key when exiting focus
            }
            // X button - Create Profile (202)
            else if (Key == 202)
            {
                Root.PlayClickSound();
                EPCPlayerMenu(OwnerWindow).ConfirmButtonPressed();
            }
            // Y button - Clear All (203)
            else if (Key == 203)
            {
                Root.PlayClickSound();
                Notify(m_ResetAllButton, DE_Click);
            }
            return;  // Don't process other inputs while in profile name focus
        }

        // Normal navigation mode
        // Navigate down - DPadDown (213) or AnalogDown (197)
        if (Key == 213 || Key == 197)
        {
            Root.PlayClickSound();
            m_selectedItemIndex = (m_selectedItemIndex + 1) % m_totalItems;
            HighlightSelectedItem(m_selectedItemIndex);
        }
        // Navigate up - DPadUp (212) or AnalogUp (196)
        else if (Key == 212 || Key == 196)
        {
            Root.PlayClickSound();
            m_selectedItemIndex = (m_selectedItemIndex - 1 + m_totalItems) % m_totalItems;
            HighlightSelectedItem(m_selectedItemIndex);
        }
        // A button - Select (200)
        else if (Key == 200)
        {
            Root.PlayClickSound();
            ActivateSelectedItem();
        }
        // X button - Create Profile (202)
        else if (Key == 202)
        {
            Root.PlayClickSound();
            EPCPlayerMenu(OwnerWindow).ConfirmButtonPressed();
        }
        // Y button - Info if on Elite/Permadeath (203)
        else if (Key == 203)
        {
            if (m_selectedItemIndex == 3)
            {
                // Elite - show tooltip
                m_heldKey = 0;
                m_keyHoldTime = 0;
                Root.PlayClickSound();
                m_EliteInfoButton.ShowInfoMessage();
                m_EliteInfoButton.bStopPulsing = true;
                MarkTooltipViewed(m_EliteInfoButton.LocalizationKey);
            }
            else if (m_selectedItemIndex == 4)
            {
                // Permadeath - show tooltip
                m_heldKey = 0;
                m_keyHoldTime = 0;
                Root.PlayClickSound();
                m_PermadeathInfoButton.ShowInfoMessage();
                m_PermadeathInfoButton.bStopPulsing = true;
                MarkTooltipViewed(m_PermadeathInfoButton.LocalizationKey);
            }
        }
        // B button - Exit area back to tab selection
        else if (Key == 201)
        {
            Root.PlayClickSound();
            EnableArea(false);
            EPCPlayerMenu(OwnerWindow).AreaExited();
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

// Joshua - Tick function for auto-repeat navigation and info button pulse
function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    if (bInfoButtonPulseIncreasing)
    {
        InfoButtonPulseTimer += DeltaTime * 1.2;
        if (InfoButtonPulseTimer >= 1.0)
        {
            InfoButtonPulseTimer = 1.0;
            bInfoButtonPulseIncreasing = false;
        }
    }
    else
    {
        InfoButtonPulseTimer -= DeltaTime * 1.2;
        if (InfoButtonPulseTimer <= 0.0)
        {
            InfoButtonPulseTimer = 0.0;
            bInfoButtonPulseIncreasing = true;
        }
    }

    if (!m_bEnableArea || m_heldKey == 0)
        return;

    m_keyHoldTime += DeltaTime;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Profile name focus - cycle profile numbers
        if (m_bProfileNameFocused)
        {
            if (m_heldKey == 213 || m_heldKey == 197)
            {
                Root.PlayClickSound();
                CycleProfileDown();
            }
            else if (m_heldKey == 212 || m_heldKey == 196)
            {
                Root.PlayClickSound();
                CycleProfileUp();
            }
        }
        // Normal navigation mode
        else
        {
            if (m_heldKey == 213 || m_heldKey == 197)
            {
                Root.PlayClickSound();
                m_selectedItemIndex = (m_selectedItemIndex + 1) % m_totalItems;
                HighlightSelectedItem(m_selectedItemIndex);
            }
            else if (m_heldKey == 212 || m_heldKey == 196)
            {
                Root.PlayClickSound();
                m_selectedItemIndex = (m_selectedItemIndex - 1 + m_totalItems) % m_totalItems;
                HighlightSelectedItem(m_selectedItemIndex);
            }
        }

        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

defaultproperties
{
    m_initialDelay=0.5
    m_repeatRate=0.1
    m_IResetAllXPos=150
    m_IResetAllButtonsHeight=18
    m_IResetAllButtonsWidth=200
    m_IResetAllButtonsYPos=136
    m_IXLabelPos=20
    m_ILabelHeight=18
    m_ILabelWidth=190
    m_IPlayerNameYPos=10        // Joshua - Modified from 30 to fit Elite/Permadeath
    m_IPlayerNameOffset=25
    m_IPlayerNameWidth=200
    m_IDifficultyXOffset=30
    m_IDifficultyYPos=45        // Joshua - Modified from 70 to fit Elite/Permadeath
    m_IDifficultyYOffset=20     // Joshua - Modified from 25 to fit Elite/Permadeath
    m_IDifficultyRadioYPos=45   // Joshua - Modified from 70 to fit Elite/Permadeath
    m_IRadioWidth=20
    m_EditBorderColor=(R=51,G=51,B=51,A=255)
    m_TextColor=(R=51,G=51,B=51,A=255)
}