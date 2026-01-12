//=============================================================================
//  EPCSoundConfigArea.uc : Area containing controls for audio settings
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/24 * Created by Alexandre Dionne
//=============================================================================
class EPCSoundConfigArea extends UWindowDialogClientWindow
    config(Enhanced);

var EPCOptionsListBoxEnhanced m_ListBox;

var EPCHScrollBar           m_AmbiantSoundScroll, m_VoicesSoundScroll, m_LMusicSoundScroll, m_SFXSoundScroll;
var INT                     m_IScrollWidth;

// Joshua - Label for each of the scroll bars
var UWindowLabelControl     m_LAmbiantSoundValue;
var UWindowLabelControl     m_LVoicesSoundValue;
var UWindowLabelControl     m_LMusicSoundValue;
var UWindowLabelControl     m_LSFXSoundValue;
var INT                     m_ILabelXPos, m_ILabelWidth, m_ILabelHeight, m_ILineItemHeight, m_ITitleLineItemHeight;

var EPCComboControl         m_AudioVirtCombo;

var EPCCheckBox             m_EaxButton, m_3DAccButton, m_DisableAlertSoundButton;

var Color                   m_TextColor;
var Color                   m_DisabledTextColor;

var bool                    m_bModified;    //A setting has changed
var bool					m_bFirstRefresh;

var UWindowBitmap           m_oEAXLogo;
var Texture                 m_oEAXTexture;
var Texture                 m_oEAXDisabledTexture;

var bool					m_SliderInitialized;

// Joshua - Controller navigation
var bool    m_bEnableArea;          // True when area is active for controller navigation
var int     m_selectedItemIndex;    // Currently selected item index
var int     m_totalItems;           // Total selectable items (7)
var bool    m_bSliderFocused;       // True when a slider is focused for adjustment
var bool    m_bComboFocused;        // True when combo box is focused
var EPCComboControl m_ActiveCombo;  // Currently focused combo box
var bool    m_bEAXFocused;          // True when EAX checkbox is focused

// Joshua - EAX logo flicker animation when selected
var float   m_EAXPulseTimer;

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

// Joshua - Tooltip persistence
var(Enhanced) config array<string> ViewedTooltips;

var float InfoButtonPulseTimer;
var bool bInfoButtonPulseIncreasing;


//==============================================================================
// Created - Called on window creation
//==============================================================================
function Created()
{
    SetAcceptsFocus(); // Joshua - Enable controller input

    // Joshua - Initialize controller navigation
    m_totalItems = 7;
    m_bEnableArea = false;
    m_selectedItemIndex = 0;
    m_bSliderFocused = false;
    m_bComboFocused = false;
    m_ActiveCombo = None;

    // Joshua - Initialize EAX pulse animation
    m_EAXPulseTimer = 0.0;

    // Joshua - Initialize pulse animation
    InfoButtonPulseTimer = 0.0;
    bInfoButtonPulseIncreasing = true;

	// Set color values (YM)
	m_TextColor.R = 71;
	m_TextColor.G = 71;
	m_TextColor.B = 71;
	m_TextColor.A = 255;

    m_DisabledTextColor.R = 128;
	m_DisabledTextColor.G = 128;
	m_DisabledTextColor.B = 128;
	m_DisabledTextColor.A = 255;

    // Create the scrollable listbox
    m_ListBox = EPCOptionsListBoxEnhanced(CreateWindow(class'EPCOptionsListBoxEnhanced', 0, 0, WinWidth, WinHeight));
    m_ListBox.SetAcceptsFocus();
    m_ListBox.bAlwaysBehind = true;
    m_ListBox.m_ILabelXPos = m_ILabelXPos;
    m_ListBox.m_ILabelWidth = m_ILabelWidth;
    m_ListBox.m_ILineItemHeight = m_ILineItemHeight;
    m_ListBox.m_ITitleLineItemHeight = m_ITitleLineItemHeight;
    InitSoundOptions();
    m_ListBox.TitleFont = F_Normal;
}

// Joshua - Tooltip persistence functions
function bool HasViewedTooltip(string LocalizationKey)
{
    local int i;

    for (i = 0; i < ViewedTooltips.Length; i++)
    {
        if (ViewedTooltips[i] == LocalizationKey)
            return true;
    }
    return false;
}

function MarkTooltipViewed(string LocalizationKey)
{
    if (!HasViewedTooltip(LocalizationKey))
    {
        ViewedTooltips[ViewedTooltips.Length] = LocalizationKey;
        SaveConfig();
    }
}

function InitSoundOptions()
{
    AddTitleLineItem();

    // Volume sliders
    AddScrollBarItem("AMBIENTVOLUME", m_AmbiantSoundScroll);
    InitVolumeScrollBar(m_AmbiantSoundScroll);
    m_LAmbiantSoundValue = GetLastValueLabel();
    AddLineItem();

    AddScrollBarItem("VOICEVOLUME", m_VoicesSoundScroll);
    InitVolumeScrollBar(m_VoicesSoundScroll);
    m_LVoicesSoundValue = GetLastValueLabel();
    AddLineItem();

    AddScrollBarItem("MUSICVOLUME", m_LMusicSoundScroll);
    InitVolumeScrollBar(m_LMusicSoundScroll);
    m_LMusicSoundValue = GetLastValueLabel();
    AddLineItem();

    AddScrollBarItem("SFXVOLUME", m_SFXSoundScroll);
    InitVolumeScrollBar(m_SFXSoundScroll);
    m_LSFXSoundValue = GetLastValueLabel();
    AddLineItem();

    // Audio virtualization combo
    AddComboBoxItem("AUDIOVIRT", m_AudioVirtCombo);
    m_AudioVirtCombo.AddItem(Localize("HUD","LOW","Localization\\HUD"));
    m_AudioVirtCombo.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));
    m_AudioVirtCombo.AddItem(Localize("HUD","HIGH","Localization\\HUD"));
    m_AudioVirtCombo.SetSelectedIndex(0);
    AddLineItem();

    // Joshua - 3D Audio checkbox with EAX logo and checkbox on same row like original layout
    Add3DAudioWithEAXItem();
    AddLineItem();

    // Joshua - Disable Alert Sound checkbox with tooltip
    AddEnhancedCheckBoxItemWithInfo("DisableAlertSound", "DisableAlertSound", m_DisableAlertSoundButton);
    AddLineItem();
}

function AddTitleLineItem()
{
    local EPCEnhancedListBoxItem NewItem;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.bIsTitleLine = true;
    NewItem.m_bIsNotSelectable = true;
}

function AddLineItem()
{
    local EPCEnhancedListBoxItem NewItem;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.bIsLine = true;
    NewItem.m_bIsNotSelectable = true;
}

function AddScrollBarItem(string LocalizationKey, out EPCHScrollBar ScrollBar)
{
    local EPCEnhancedListBoxItem NewItem;
    local UWindowLabelControl ValueLabel;

    ScrollBar = EPCHScrollBar(CreateControl(class'EPCHScrollBar', 0, 0, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight));
    ScrollBar.SetScrollHeight(12);

    // Create value label for scrollbar
    ValueLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 0, 0, 40, 18));
    ValueLabel.Font = F_Normal;
    ValueLabel.TextColor = m_TextColor;
    ValueLabel.SetLabelText("0", TXT_LEFT);

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("HUD", LocalizationKey, "Localization\\HUD");
    NewItem.m_Control = ScrollBar;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ScrollBar;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ValueLabel;
}

function UWindowLabelControl GetLastValueLabel()
{
    // The value label is always the last control added
    if (m_ListBox.m_Controls.Length > 0)
        return UWindowLabelControl(m_ListBox.m_Controls[m_ListBox.m_Controls.Length - 1]);
    return None;
}

function InitVolumeScrollBar(EPCHScrollBar ScrollBar)
{
    ScrollBar.SetRange(0, 101, 1); // Joshua - Offset slider range to show 0-100 in the GUI while maintaining correct internal values
}

function AddComboBoxItem(string LocalizationKey, out EPCComboControl ComboBox)
{
    local EPCEnhancedListBoxItem NewItem;

    ComboBox = EPCComboControl(CreateControl(class'EPCComboControl', 0, 0, 150, 18));
    ComboBox.SetFont(F_Normal);
    ComboBox.SetEditable(False);

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("HUD", LocalizationKey, "Localization\\HUD");
    NewItem.m_Control = ComboBox;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ComboBox;
}

function AddCheckBoxItem(string LocalizationKey, out EPCCheckBox CheckBox)
{
    local EPCEnhancedListBoxItem NewItem;

    CheckBox = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18));
    CheckBox.ImageX = 5;
    CheckBox.ImageY = 5;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("HUD", LocalizationKey, "Localization\\HUD");
    NewItem.m_Control = CheckBox;
    NewItem.m_bIsNotSelectable = true;
    NewItem.bRightAlignControl = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = CheckBox;
}

function AddEnhancedCheckBoxItem(string LocalizationKey, out EPCCheckBox CheckBox)
{
    local EPCEnhancedListBoxItem NewItem;

    CheckBox = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18));
    CheckBox.ImageX = 5;
    CheckBox.ImageY = 5;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("Audio", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_Control = CheckBox;
    NewItem.m_bIsNotSelectable = true;
    NewItem.bRightAlignControl = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = CheckBox;
}

// Joshua - Enhanced checkbox with info button (tooltip)
function AddEnhancedCheckBoxItemWithInfo(string LocalizationKey, string SettingName, out EPCCheckBox CheckBox)
{
    local EPCEnhancedListBoxItem NewItem;
    local EPCInfoButton InfoButton;
    local string InfoText;

    CheckBox = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18));
    CheckBox.ImageX = 5;
    CheckBox.ImageY = 5;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("Audio", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_Control = CheckBox;
    NewItem.m_bIsNotSelectable = true;
    NewItem.bRightAlignControl = true;

    // Create info button
    InfoText = Localize("Audio", LocalizationKey $ "_Desc", "Localization\\Enhanced");
    if (InfoText != "" && InfoText != (LocalizationKey $ "_Desc"))
    {
        InfoButton = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16));
        InfoButton.InfoText = InfoText;
        InfoButton.SettingName = NewItem.Caption; // Use the localized setting name as title
        InfoButton.LocalizationKey = LocalizationKey; // Store key for persistence
        InfoButton.bStopPulsing = HasViewedTooltip(LocalizationKey); // Don't pulse if already viewed
        NewItem.m_InfoButton = InfoButton;
        m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = InfoButton;
    }

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = CheckBox;
}

// Joshua - Combined 3D Audio + EAX row (like original layout)
// Original positions: 3D Audio checkbox right after label text, EAX logo at X=280
function Add3DAudioWithEAXItem()
{
    local EPCEnhancedListBoxItem NewItem;
    local Region EAXRegion;

    // Create 3D Audio checkbox (primary control, positioned right after label text)
    m_3DAccButton = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18));
    m_3DAccButton.ImageX = 5;
    m_3DAccButton.ImageY = 5;

    // Create EAX checkbox (secondary control)
    m_EaxButton = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18));
    m_EaxButton.ImageX = 5;
    m_EaxButton.ImageY = 5;

    // Create EAX logo (fixed position at X=280 like original, adjusted for listbox offset)
    m_oEAXLogo = UWindowBitmap(CreateWindow(class'UWindowBitmap', 0, 0, 64, 32));
    EAXRegion.X = 0;
    EAXRegion.Y = 0;
    EAXRegion.W = 64;
    EAXRegion.H = 32;
    m_oEAXLogo.T = m_oEAXTexture;
    m_oEAXLogo.R = EAXRegion;
    m_oEAXLogo.bStretch = true;
    m_oEAXLogo.bCenter = true;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("HUD", "AUDIO3D", "Localization\\HUD");
    NewItem.m_Control = m_3DAccButton;           // 3D Audio checkbox
    NewItem.m_SecondaryControl = m_EaxButton;    // EAX checkbox
    NewItem.m_LogoControl = m_oEAXLogo;          // EAX logo
    NewItem.m_bIsNotSelectable = true;
    NewItem.bControlAfterLabel = true;           // Position 3D Audio checkbox right after label text
    NewItem.m_LogoXPos = 265;                    // Fixed X position for EAX logo (original was 280, adjusted for listbox)

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_3DAccButton;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_EaxButton;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_oEAXLogo;
}

// Joshua - Check if combo box was closed externally
function BeforePaint(Canvas C, float X, float Y)
{
    Super.BeforePaint(C, X, Y);

    // Check if combo box was closed externally (by selecting an item)
    if (m_bComboFocused && m_ActiveCombo != None && !m_ActiveCombo.bListVisible)
    {
        m_bComboFocused = false;
        m_ActiveCombo = None;
    }
    // Joshua - EAX logo is now positioned by the listbox DrawItem function so it scrolls properly
}

//==============================================================================
// Paint - No custom painting needed, listbox handles selection highlighting
//==============================================================================
function Paint(Canvas C, float X, float Y)
{
    Super.Paint(C, X, Y);
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
    CloseActiveComboBoxes();
    if (m_ListBox != None)
        m_ListBox.MouseWheelDown(X, Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    CloseActiveComboBoxes();
    if (m_ListBox != None)
        m_ListBox.MouseWheelUp(X, Y);
}

function CloseActiveComboBoxes()
{
    if (m_ListBox != None)
        m_ListBox.CloseActiveComboBoxes();
}

//==============================================================================
// ResetToDefault
//==============================================================================
function ResetToDefault()
{
    local EPCGameOptions GO;
    local EPlayerController EPC;

    GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

    GO.ResetSoundToDefault();

    // Reset Enhanced audio options
    if (EPC != None && EPC.eGame != None)
    {
        EPC.eGame.bDisableAlertSound = false;
        EPC.eGame.SaveEnhancedOptions();
    }

    Refresh();
    Verify3DSound();
    GO.oldResolution = GO.Resolution;
    GO.oldEffectsQuality = GO.EffectsQuality;
    GO.oldShadowResolution = GO.ShadowResolution;
    GO.UpdateEngineSettings();
}

//==============================================================================
// Refresh
//==============================================================================
function Refresh()
{
    local EPCGameOptions GO;
    local EPlayerController EPC;

    GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

    m_AmbiantSoundScroll.Pos = InternalToGUI(GO.AmbiantVolume);
    m_VoicesSoundScroll.Pos = InternalToGUI(GO.VoicesVolume);
    m_LMusicSoundScroll.Pos = InternalToGUI(GO.MusicVolume);
    m_SFXSoundScroll.Pos = InternalToGUI(GO.SFXVolume);

    // Joshua - Label for each of the scroll bars
    if (m_LAmbiantSoundValue != None)
        m_LAmbiantSoundValue.SetLabelText(string(int(m_AmbiantSoundScroll.Pos)), TXT_LEFT);
    if (m_LVoicesSoundValue != None)
        m_LVoicesSoundValue.SetLabelText(string(int(m_VoicesSoundScroll.Pos)), TXT_LEFT);
    if (m_LMusicSoundValue != None)
        m_LMusicSoundValue.SetLabelText(string(int(m_LMusicSoundScroll.Pos)), TXT_LEFT);
    if (m_LSFXSoundValue != None)
        m_LSFXSoundValue.SetLabelText(string(int(m_SFXSoundScroll.Pos)), TXT_LEFT);

    m_AudioVirtCombo.SetSelectedIndex(Clamp(GO.AudioVirt,0,m_AudioVirtCombo.List.Items.Count() -1));
    m_EaxButton.m_bSelected = GO.EAX;
    m_3DAccButton.m_bSelected = GO.Sound3DAcc;

    // Joshua - Refresh Enhanced audio options
    if (EPC != None && EPC.eGame != None && m_DisableAlertSoundButton != None)
        m_DisableAlertSoundButton.m_bSelected = EPC.eGame.bDisableAlertSound;

    if (m_bFirstRefresh)
    {
        Verify3DSound();
    }

	m_bModified = false;
	m_bFirstRefresh = false;
}

//==============================================================================
// SaveOptions
//==============================================================================
function SaveOptions()
{
    local EPCGameOptions GO;
    local EPlayerController EPC;

    GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

    GO.AmbiantVolume = GUIToInternal(m_AmbiantSoundScroll.Pos);
    GO.VoicesVolume = GUIToInternal(m_VoicesSoundScroll.Pos);
    GO.MusicVolume = GUIToInternal(m_LMusicSoundScroll.Pos);
    GO.SFXVolume = GUIToInternal(m_SFXSoundScroll.Pos);

    GO.AudioVirt = m_AudioVirtCombo.GetSelectedIndex();
    GO.EAX = m_EaxButton.m_bSelected;
    GO.Sound3DAcc = m_3DAccButton.m_bSelected;

    // Joshua - Save Enhanced audio options
    if (EPC != None && EPC.eGame != None && m_DisableAlertSoundButton != None)
    {
        EPC.eGame.bDisableAlertSound = m_DisableAlertSoundButton.m_bSelected;
        EPC.eGame.SaveEnhancedOptions();
    }
}

//==============================================================================
// Notify - Message Passing
//==============================================================================
function Notify(UWindowDialogControl C, byte E)
{
	local EPCGameOptions GO;

    GO = class'Actor'.static.GetGameOptions();

    if (InternalToGUI(GO.AmbiantVolume) == m_AmbiantSoundScroll.Pos &&
        InternalToGUI(GO.VoicesVolume) == m_VoicesSoundScroll.Pos &&
        InternalToGUI(GO.MusicVolume) == m_LMusicSoundScroll.Pos &&
        InternalToGUI(GO.SFXVolume) == m_SFXSoundScroll.Pos)
    {
        m_SliderInitialized = true;
    }

    if (E == DE_Click)
    {
        switch (C)
        {
        case m_3DAccButton:
            Verify3DSound();
        case m_EaxButton:
        case m_DisableAlertSoundButton: // Joshua - Mark as modified when Disable Alert Sound is toggled
            log("EAX");
            m_bModified = true;
            break;
        }
    }
    if (E == DE_Change)
    {
        switch (C)
        {
        case m_AmbiantSoundScroll:
        case m_VoicesSoundScroll:
        case m_LMusicSoundScroll:
        case m_SFXSoundScroll:
        case m_AudioVirtCombo:
            m_bModified = true;
			if (m_SliderInitialized)
			{
                GO.RTAmbiantVolume = GUIToInternal(m_AmbiantSoundScroll.Pos);
                GO.RTVoicesVolume = GUIToInternal(m_VoicesSoundScroll.Pos);
                GO.RTMusicVolume = GUIToInternal(m_LMusicSoundScroll.Pos);
                GO.RTSFXVolume = GUIToInternal(m_SFXSoundScroll.Pos);
				GO.UpdateEngineSettings(true);
			}
            // Joshua - Label for each of the scroll bars
            m_LAmbiantSoundValue.SetLabelText(string(int(m_AmbiantSoundScroll.Pos)), TXT_LEFT);
            m_LVoicesSoundValue.SetLabelText(string(int(m_VoicesSoundScroll.Pos)), TXT_LEFT);
            m_LMusicSoundValue.SetLabelText(string(int(m_LMusicSoundScroll.Pos)), TXT_LEFT);
            m_LSFXSoundValue.SetLabelText(string(int(m_SFXSoundScroll.Pos)), TXT_LEFT);
            break;
        }
    }
}

//==============================================================================
// Verify3DSound - Checks whether 3D sound is ON before giving the EAX option
//==============================================================================
function Verify3DSound()
{
    if (m_3DAccButton.m_bSelected && IsEAXCapable())   // 3D SOUND was just ENABLED
    {
        // Enable EAX
        m_EaxButton.bDisabled = false;

        // Put enabled texture
        m_oEAXLogo.T = m_oEAXTexture;
    }
    else                            // 3D SOUND was just DISABLED
    {
        // De-check EAX
        m_EaxButton.m_bSelected = false;

        // Disable EAX
        m_EaxButton.bDisabled = true;

        // Put Disabled Texture on EAX Logo
        m_oEAXLogo.T = m_oEAXDisabledTexture;
    }
}

//==============================================================================
// IsEAXCapable - Checks whether sound card is EAX capable
//==============================================================================
function bool IsEAXCapable()
{
    local EPCGameOptions GO;

    GO = class'Actor'.static.GetGameOptions();

    return GO.EAX_Capable;
}

// Joshua - Functions to ensure audio sliders in settings display accurate values
//==============================================================================
// UIToInternal -  Maps UI slider value (0-100) to internal volume value (0–255)
//==============================================================================
function int GUIToInternal(float UIValue)
{
    // Convert 0-100 UI value to 0-255 internal value
    return int(UIValue * 2.55 + 0.5); // Adding 0.5 for proper rounding
}

//==============================================================================
// InternalToUI - Maps internal volume (0–255) to UI slider value (0–100)
//==============================================================================
function int InternalToGUI(float InternalValue)
{
    // Convert 0-255 internal value to 0-100 UI value
    return int(InternalValue / 2.55 + 0.5); // Adding 0.5 for proper rounding
}

// Joshua - Check if current item has an info button
function bool CurrentItemHasInfo()
{
    local EPCEnhancedListBoxItem Item;

    if (!m_bEnableArea || m_selectedItemIndex < 0 || m_selectedItemIndex >= m_totalItems)
        return false;

    // Get the list item at the selected index
    Item = GetItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_InfoButton != None)
    {
        return true;
    }

    return false;
}

// Joshua - Show tooltip for the currently selected item (if available)
function ShowSelectedItemTooltip()
{
    local EPCEnhancedListBoxItem Item;
    local EPCInfoButton InfoBtn;

    Item = GetItemAtIndex(m_selectedItemIndex);
    if (Item == None)
        return;

    // Check if this item has an info button
    InfoBtn = EPCInfoButton(Item.m_InfoButton);
    if (InfoBtn != None && InfoBtn.InfoText != "")
    {
        // Stop any auto-scrolling when opening tooltip
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;

        // Trigger the info button's click to show the tooltip
        InfoBtn.Click(0, 0);
        Root.PlayClickSound();
    }
}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    local EPCEnhancedListBoxItem Item;

    m_bEnableArea = bEnable;

    if (bEnable)
    {
        // Find the first visible selectable item based on scroll position
        m_selectedItemIndex = GetFirstVisibleSelectableItemIndex();
        m_bSliderFocused = false;
        m_bComboFocused = false;
        m_bEAXFocused = false; // Joshua - Start with 3D Audio focused, not EAX
        m_ActiveCombo = None;

        // Highlight without scrolling, user is already viewing where they want
        ClearHighlight();
        Item = GetItemAtIndex(m_selectedItemIndex);
        if (Item != None)
        {
            Item.bSelected = true;
        }
    }
    else
    {
        m_bSliderFocused = false;
        m_bComboFocused = false;
        m_bEAXFocused = false;
        m_ActiveCombo = None;
        ClearHighlight();
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
    }
}

// Joshua - Get the first visible selectable item based on scroll position
function int GetFirstVisibleSelectableItemIndex()
{
    local int ScrollPos;
    local int VisibleCount;
    local int SelectableIndex;
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;
    local bool bPassedScrollPos;

    // Get the current scroll position (number of visible items scrolled past)
    ScrollPos = 0;
    if (m_ListBox.VertSB != None)
    {
        ScrollPos = m_ListBox.VertSB.Pos;
    }

    // Walk through all items, counting visible items and selectable items
    VisibleCount = 0;
    SelectableIndex = 0;
    bPassedScrollPos = false;

    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        if (!CurItem.ShowThisItem())
            continue;

        // Check if we've passed the scroll position
        if (VisibleCount >= ScrollPos)
            bPassedScrollPos = true;

        EnhancedItem = EPCEnhancedListBoxItem(CurItem);
        if (EnhancedItem != None && EnhancedItem.m_Control != None)
        {
            // This is a selectable item
            if (bPassedScrollPos)
            {
                // This is the first selectable item at or after the scroll position
                return SelectableIndex;
            }
            SelectableIndex++;
        }

        VisibleCount++;
    }

    // Fallback to first selectable item
    return 0;
}

// Joshua - Get slider by index
function EPCHScrollBar GetSliderAtIndex(int Index)
{
    switch (Index)
    {
        case 0: return m_AmbiantSoundScroll;
        case 1: return m_VoicesSoundScroll;
        case 2: return m_LMusicSoundScroll;
        case 3: return m_SFXSoundScroll;
        default: return None;
    }
}

// Joshua - Get combo box by index
function EPCComboControl GetComboAtIndex(int Index)
{
    switch (Index)
    {
        case 4: return m_AudioVirtCombo;
        default: return None;
    }
}

// Joshua - Get checkbox by index
// Index 5 is the 3D Audio (EAX is handled separately)
// Index 6 is Disable Alert Sound
function EPCCheckBox GetCheckBoxAtIndex(int Index)
{
    switch (Index)
    {
        case 5: return m_3DAccButton; // 3D Audio checkbox on combined row
        case 6: return m_DisableAlertSoundButton;
        default: return None;
    }
}

// Joshua - Get list item for selected index
function EPCEnhancedListBoxItem GetItemAtIndex(int Index)
{
    local EPCEnhancedListBoxItem Item;
    local int SelectableIndex;

    SelectableIndex = 0;

    for (Item = EPCEnhancedListBoxItem(m_ListBox.Items.Next); Item != None; Item = EPCEnhancedListBoxItem(Item.Next))
    {
        if (Item.m_Control != None)
        {
            if (SelectableIndex == Index)
                return Item;
            SelectableIndex++;
        }
    }
    return None;
}

// Joshua - Clear all highlights
function ClearHighlight()
{
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;

    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        EnhancedItem = EPCEnhancedListBoxItem(CurItem);
        if (EnhancedItem != None)
        {
            EnhancedItem.bSelected = false;
        }
    }

    // Joshua - Restore EAX logo to correct texture (stop flickering)
    if (m_3DAccButton.m_bSelected && !m_EaxButton.bDisabled)
        m_oEAXLogo.T = m_oEAXTexture;
    else
        m_oEAXLogo.T = m_oEAXDisabledTexture;
    m_EAXPulseTimer = 0.0;
}

// Joshua - Restore highlight when controller mode is re-enabled
// Select the first visible selectable item based on current scroll position, without scrolling
function RestoreHighlight()
{
    local EPCEnhancedListBoxItem Item;

    // Only restore if area is enabled
    if (m_bEnableArea)
    {
        // Find the first visible selectable item (in case user scrolled with mouse)
        m_selectedItemIndex = GetFirstVisibleSelectableItemIndex();

        // Highlight without scrolling, user is already viewing where they want
        ClearHighlight();
        Item = GetItemAtIndex(m_selectedItemIndex);
        if (Item != None)
        {
            Item.bSelected = true;
        }
    }
}

// Joshua - Highlight the selected item
function HighlightSelectedItem(int Index)
{
    local EPCEnhancedListBoxItem Item;

    ClearHighlight();

    Item = GetItemAtIndex(Index);
    if (Item != None)
    {
        // On the 3D Audio+EAX row (index 5), only highlight label when 3D Audio is focused
        // When EAX is focused, the flicker animation is the visual indicator
        if (Index == 5 && m_bEAXFocused)
        {
            Item.bSelected = false; // Don't highlight label when EAX is focused
        }
        else
        {
            Item.bSelected = true;
        }

        // Scroll to make item visible
        ScrollToItem(Index);
    }
}

// Joshua - Scroll the list to make the specified item visible
function ScrollToItem(int SelectableIndex)
{
    local int RawIndex;
    local int VisibleCount;
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;
    local int SelectableCount;

    if (m_ListBox.VertSB == None)
        return;

    // If we're at the first selectable item (index 0), scroll all the way to top to show header
    if (SelectableIndex == 0)
    {
        m_ListBox.VertSB.Pos = 0;
        return;
    }

    // Find the raw index (including non-selectable items) for scrolling
    RawIndex = 0;
    SelectableCount = 0;
    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        EnhancedItem = EPCEnhancedListBoxItem(CurItem);
        if (EnhancedItem != None && EnhancedItem.m_Control != None)
        {
            if (SelectableCount == SelectableIndex)
                break;
            SelectableCount++;
        }
        RawIndex++;
    }

    VisibleCount = 5; // Approximate visible items

    // Scroll down if item is below visible area
    if (RawIndex >= m_ListBox.VertSB.Pos + VisibleCount)
    {
        m_ListBox.VertSB.Pos = RawIndex - VisibleCount + 1;
    }
    // Scroll up if item is above visible area
    else if (RawIndex < m_ListBox.VertSB.Pos)
    {
        m_ListBox.VertSB.Pos = RawIndex;
    }
}

// Joshua - Adjust slider value
function AdjustSlider(int SliderIndex, int Direction, int Key)
{
    local float NewPos;
    local float Step;
    local EPCHScrollBar Slider;
    local bool bIsDPad;

    // DPad (214/215) uses step of 1, Analog stick (198/199) uses step of 5
    bIsDPad = (Key == 214 || Key == 215);
    if (bIsDPad)
        Step = 1.0;
    else
        Step = 5.0;

    Slider = GetSliderAtIndex(SliderIndex);

    if (Slider == None)
        return;

    NewPos = Slider.Pos + (Direction * Step);
    NewPos = FClamp(NewPos, 0, 100);
    Slider.Pos = NewPos;
    Notify(Slider, DE_Change);
}

// Joshua - Handle controller input
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    local int ComboIndex;
    local EPCComboControl CurrentCombo;

    Super.WindowEvent(Msg, C, X, Y, Key);

    if (!m_bEnableArea)
        return;

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

    // A=200, B=201, X=202, Y=203
    // DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
    // AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
    if (Msg == WM_KeyDown)
    {
        // Track repeatable keys (directional keys only)
        if (Key == 212 || Key == 196 || Key == 213 || Key == 197 ||
            Key == 214 || Key == 198 || Key == 215 || Key == 199)
        {
            // New key press - reset repeat timing
            if (Key != m_heldKey)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        // If combo is focused, handle up/down for selection
        if (m_bComboFocused && m_ActiveCombo != None)
        {
            if (Key == 212 || Key == 196) // DPadUp or AnalogUp
            {
                ComboIndex = m_ActiveCombo.GetSelectedIndex();
                if (ComboIndex > 0)
                {
                    Root.PlayClickSound();
                    m_ActiveCombo.SetSelectedIndex(ComboIndex - 1);
                    Notify(m_ActiveCombo, DE_Change);
                }
            }
            else if (Key == 213 || Key == 197) // DPadDown or AnalogDown
            {
                ComboIndex = m_ActiveCombo.GetSelectedIndex();
                if (ComboIndex < m_ActiveCombo.List.Items.Count() - 1)
                {
                    Root.PlayClickSound();
                    m_ActiveCombo.SetSelectedIndex(ComboIndex + 1);
                    Notify(m_ActiveCombo, DE_Change);
                }
            }
            else if (Key == 200 || Key == 201) // A or B
            {
                // B or A exits combo focus
                Root.PlayClickSound();
                m_bComboFocused = false;
                m_ActiveCombo.CloseUp();
                m_ActiveCombo = None;
            }
            return;
        }

        // Normal navigation - call handler
        HandleNavigationInput(Key);
    }
}

// Joshua - Handle navigation input (for normal mode and auto-repeat)
function HandleNavigationInput(int Key)
{
    local EPCComboControl CurrentCombo;
    local EPCCheckBox CurrentCheckBox;

    // DPadDown (213) or AnalogDown (197)
    if (Key == 213 || Key == 197)
    {
        if (m_selectedItemIndex < m_totalItems - 1)
        {
            Root.PlayClickSound();
            m_selectedItemIndex = m_selectedItemIndex + 1;
            m_bEAXFocused = false; // Reset EAX focus when moving to new row
            HighlightSelectedItem(m_selectedItemIndex);
        }
        // At bottom - do nothing
    }
    // DPadUp (212) or AnalogUp (196)
    else if (Key == 212 || Key == 196)
    {
        if (m_selectedItemIndex > 0)
        {
            Root.PlayClickSound();
            m_selectedItemIndex = m_selectedItemIndex - 1;
            m_bEAXFocused = false; // Reset EAX focus when moving to new row
            HighlightSelectedItem(m_selectedItemIndex);
        }
        // At top - do nothing
    }
    else if (Key == 200) // A button
    {
        // A button - activates combo boxes and toggles checkboxes (sliders are controlled directly with left/right)
        if (m_selectedItemIndex <= 3) // Sliders
        {
            // Sliders: A button does nothing
        }
        else if (m_selectedItemIndex == 4) // Combo box
        {
            CurrentCombo = GetComboAtIndex(m_selectedItemIndex);
            if (CurrentCombo != None)
            {
                Root.PlayClickSound();
                m_bComboFocused = true;
                m_ActiveCombo = CurrentCombo;
                CurrentCombo.DropDown();
                // Joshua - Reset held key state so direction isn't carried into combo
                m_heldKey = 0;
                m_keyHoldTime = 0;
            }
        }
        else if (m_selectedItemIndex == 5) // 3D Audio + EAX row
        {
            if (m_bEAXFocused)
            {
                // Toggle EAX checkbox
                if (!m_EaxButton.bDisabled)
                {
                    Root.PlayClickSound();
                    m_EaxButton.m_bSelected = !m_EaxButton.m_bSelected;
                    Notify(m_EaxButton, DE_Click);
                }
            }
            else
            {
                // Toggle 3D Audio checkbox
                Root.PlayClickSound();
                m_3DAccButton.m_bSelected = !m_3DAccButton.m_bSelected;
                Notify(m_3DAccButton, DE_Click);
            }
        }
        else // Checkbox (index 6 = Disable Alert Sound)
        {
            CurrentCheckBox = GetCheckBoxAtIndex(m_selectedItemIndex);
            if (CurrentCheckBox != None && !CurrentCheckBox.bDisabled)
            {
                Root.PlayClickSound();
                CurrentCheckBox.m_bSelected = !CurrentCheckBox.m_bSelected;
                Notify(CurrentCheckBox, DE_Click);
            }
        }
    }
    else if (Key == 201) // B button
    {
        // B button - exit area
        Root.PlayClickSound();
        EnableArea(false);
        EPCOptionsMenu(OwnerWindow).AreaExited();
    }
    else if (Key == 203) // Y button
    {
        // Y button - show tooltip for current item (if available)
        ShowSelectedItemTooltip();
    }
    // DPadLeft (214) or AnalogLeft (198)
    else if (Key == 214 || Key == 198)
    {
        if (m_selectedItemIndex <= 3) // Sliders - adjust value
        {
            Root.PlayClickSound();
            AdjustSlider(m_selectedItemIndex, -1, Key);
        }
        else if (m_selectedItemIndex == 5 && m_bEAXFocused) // 3D Audio+EAX row - switch to 3D Audio
        {
            Root.PlayClickSound();
            m_bEAXFocused = false;
            HighlightSelectedItem(m_selectedItemIndex);
        }
    }
    // DPadRight (215) or AnalogRight (199)
    else if (Key == 215 || Key == 199)
    {
        if (m_selectedItemIndex <= 3) // Sliders - adjust value
        {
            Root.PlayClickSound();
            AdjustSlider(m_selectedItemIndex, 1, Key);
        }
        else if (m_selectedItemIndex == 5 && !m_bEAXFocused && !m_EaxButton.bDisabled) // 3D Audio+EAX row - switch to EAX
        {
            Root.PlayClickSound();
            m_bEAXFocused = true;
            HighlightSelectedItem(m_selectedItemIndex);
        }
    }
}

// Joshua - Tick function to handle auto-repeat for held keys and EAX flicker
function Tick(float Delta)
{
    Super.Tick(Delta);

    // Joshua - Update EAX flicker animation when EAX is focused on the 3D Audio+EAX row (index 5)
    // Flicker every 0.5 seconds (same speed as 30fps with old 0.1 increment per frame)
    if (m_bEnableArea && m_selectedItemIndex == 5 && m_bEAXFocused && !m_EaxButton.bDisabled)
    {
        m_EAXPulseTimer += Delta;
        if (m_EAXPulseTimer >= 0.5)
        {
            m_EAXPulseTimer = 0.0;
            // Toggle between enabled and disabled texture
            if (m_oEAXLogo.T == m_oEAXTexture)
                m_oEAXLogo.T = m_oEAXDisabledTexture;
            else
                m_oEAXLogo.T = m_oEAXTexture;
        }
    }

    // Joshua - Update info button pulse animation (same pattern as EPCEnhancedConfigArea)
    if (bInfoButtonPulseIncreasing)
    {
        InfoButtonPulseTimer += Delta * 1.2;
        if (InfoButtonPulseTimer >= 1.0)
        {
            InfoButtonPulseTimer = 1.0;
            bInfoButtonPulseIncreasing = false;
        }
    }
    else
    {
        InfoButtonPulseTimer -= Delta * 1.2;
        if (InfoButtonPulseTimer <= 0.0)
        {
            InfoButtonPulseTimer = 0.0;
            bInfoButtonPulseIncreasing = true;
        }
    }

    // Auto-repeat for held keys
    if (!m_bEnableArea || m_heldKey == 0 || m_bComboFocused)
        return;

    m_keyHoldTime += Delta;

    // Check if it's time to repeat
    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Execute the held key's action
        HandleNavigationInput(m_heldKey);

        // Schedule next repeat
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

defaultproperties
{
    m_ILabelXPos=15
    m_ILabelWidth=250
    m_ILabelHeight=18
    m_IScrollWidth=160 // Joshua - Reduced from 175 (200) to fit the new label better
    m_ITitleLineItemHeight=2
    m_ILineItemHeight=6
    m_TextColor=(R=51,G=51,B=51,A=255)
    m_oEAXTexture=Texture'HUD.HUD.EAX'
    m_oEAXDisabledTexture=Texture'HUD.HUD.eax_dis'
    m_initialDelay=0.5
    m_repeatRate=0.1
}
