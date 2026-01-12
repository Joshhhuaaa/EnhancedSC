//=============================================================================
//  EPCControlsConfigArea.uc : Area containing controls for setting game keys
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/27 * Created by Alexandre Dionne
//=============================================================================
class EPCControlsConfigArea extends UWindowDialogClientWindow
    config(Enhanced);

var EPCOptionKeysListBox m_ListBox;
var EPCMessageBox        m_MessageBox;

var EPCHScrollBar        m_MouseSensitivityScroll;
var UWindowLabelControl  m_LMouseSensitivityValue; // Joshua - Label for the mouse sensitivity scroll bar
var EPCHScrollBar        m_InitialSpeedScroll; // Joshua - Enhanced setting
var UWindowLabelControl  m_LInitialSpeedValue; // Joshua - Label for the initial speed scroll bar
var EPCCheckBox          m_InvertMouseButton;
var EPCCheckBox          m_FireEquipGun;
var EPCCheckBox          m_bNormalizeMovement; // Joshua - Enhanced setting
var EPCCheckBox          m_bCrouchDrop; // Joshua - Enhanced setting
var EPCCheckBox          m_bToggleBTWTargeting; // Joshua - Enhanced setting
var EPCCheckBox          m_bCameraJammerAutoLock; // Joshua - Enhanced setting
var EPCCheckBox          m_bToggleInventory; // Joshua - Enhanced setting
var EPCCheckBox          m_bHideInactiveCategories; // Joshua - Enhanced setting
var EPCCheckBox          m_bEnableRumble; // Joshua - Enhanced setting
var EPCComboControl      m_InputMode; // Joshua - Enhanced setting
var EPCComboControl      m_ControllerScheme; // Joshua - Enhanced setting
var EPCComboControl      m_ControllerIcon; // Joshua - Enhanced setting

var bool                    m_bModified;    // A setting has changed
var bool					m_bFirstRefresh;

// Joshua - Controller navigation
var bool m_bEnableArea;            // True when area is active for controller navigation
var int m_selectedItemIndex;       // Currently selected item index (selectable items only)
var int m_totalSelectableItems;    // Total number of selectable items
var bool m_bSliderFocused;         // True when a slider is in focus
var int m_focusedSliderIndex;      // Index of the focused slider
var bool m_bComboFocused;          // True when a combo box is in focus
var int m_focusedComboIndex;       // Index of the focused combo box
var bool m_bNeedsScrollOnEnable;   // True if selected item is not visible and needs scroll
var int m_scrollTargetRawIndex;    // Raw index to scroll to when m_bNeedsScrollOnEnable is true

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

// Joshua - Tooltip persistence
var config array<string> ViewedTooltips;

// Joshua - Shared info button pulse animation state
var float InfoButtonPulseTimer;
var bool bInfoButtonPulseIncreasing;

//==============================================================================
//
//==============================================================================
function Created()
{
    SetAcceptsFocus();

	m_MessageBox = none;

    m_ListBox = EPCOptionKeysListBox(CreateControl(class'EPCOptionKeysListBox', 0, 0, WinWidth, WinHeight, self));
    m_ListBox.bAlwaysBehind = true;

    // Joshua - Initialize pulse animation
    InfoButtonPulseTimer = 0.0;
    bInfoButtonPulseIncreasing = true;

    InitOptionControls();
    m_ListBox.TitleFont = F_Normal;
}

//==============================================================================
// HasViewedTooltip - Check if a tooltip has been viewed before
// Created by Joshua
//==============================================================================
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

//==============================================================================
// MarkTooltipViewed - Mark a tooltip as viewed and save config
// Created by Joshua
//==============================================================================
function MarkTooltipViewed(string TooltipKey)
{
    if (!HasViewedTooltip(TooltipKey))
    {
        ViewedTooltips[ViewedTooltips.Length] = TooltipKey;
        SaveConfig();
    }
}

//==============================================================================
// AddCheckBoxItemWithInfo - Add checkbox with info button tooltip
// Created by Joshua
//==============================================================================
function EPCCheckBox AddCheckBoxItemWithInfo(string LocalizationKey, out EPCCheckBox CheckBoxVar)
{
    local EPCOptionsKeyListBoxItem NewItem;
    local EPCInfoButton InfoButton;
    local string InfoText;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Localize("Controls", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_bIsNotSelectable = true;

    CheckBoxVar = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18, self));
    CheckBoxVar.ImageX = 5;
    CheckBoxVar.ImageY = 5;
    NewItem.m_Control = CheckBoxVar;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = CheckBoxVar;

    // Load the info text from localization
    InfoText = Localize("Controls", LocalizationKey $ "_Desc", "Localization\\Enhanced");

    // Only create info button if we have valid description text
    if (InfoText != "" && InfoText != (LocalizationKey $ "_Desc"))
    {
        // Add info button
        InfoButton = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16, self));
        InfoButton.InfoText = InfoText;
        InfoButton.LocalizationKey = LocalizationKey;
        InfoButton.SettingName = NewItem.Caption;
        NewItem.m_InfoButton = InfoButton;
        m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = InfoButton;

        // Check if this tooltip has been viewed before
        if (HasViewedTooltip(LocalizationKey))
        {
            InfoButton.bStopPulsing = true;
        }
    }

    return CheckBoxVar;
}

//==============================================================================
//
//==============================================================================
function InitOptionControls()
{
	// MOVEMENT
	// add items in display order
    AddLineItem();
	AddTitleItem(Caps(Localize("Keys","Title_Move","Localization\\HUD")));
    AddLineItem();

	AddKeyItem(Localize("Keys","K_MoveForward","Localization\\HUD"),"MoveForward");
	AddKeyItem(Localize("Keys","K_MoveBackward","Localization\\HUD"), "MoveBackward");
    AddKeyItem(Localize("Keys","K_StrafeLeft","Localization\\HUD"),"StrafeLeft");
	AddKeyItem(Localize("Keys","K_StrafeRight","Localization\\HUD"), "StrafeRight");
    AddKeyItem(Localize("Keys","K_Duck","Localization\\HUD"),"Duck");
	AddKeyItem(Localize("Keys","K_Accel","Localization\\HUD"), "IncSpeed");
    AddKeyItem(Localize("Keys","K_Decell","Localization\\HUD"),"DecSpeed");
    AddKeyItem(Localize("Keys","k_BackToWall","Localization\\HUD"),"BackToWall");

    //AddLineItem();
    AddCompactLineItem();
    AddInitialSpeedControls();
    AddCheckBoxItemWithInfo("NormalizedMovement", m_bNormalizeMovement);
    AddEnhancedCheckBoxControl("CrouchDrop", m_bCrouchDrop);
    //AddLineItem();

    // Actions
	AddLineItem();
	AddTitleItem(Caps(Localize("Keys","Title_Actions","Localization\\HUD")));
    AddLineItem();

	AddKeyItem(Localize("Keys","K_Fire","Localization\\HUD"), "Fire");
	AddKeyItem(Localize("Keys","K_AltFire","Localization\\HUD"), "AltFire");
    AddKeyItem(Localize("Keys","K_ZoomToggle","Localization\\Enhanced"), "ZoomToggle");
    //AddKeyItem(Localize("Keys","K_SwitchCam","Localization\\Enhanced"), "SwitchCam");
    AddKeyItem(Localize("Keys","K_Scope","Localization\\HUD"), "Scope");
    AddKeyItem(Localize("Keys","K_Jump","Localization\\HUD"), "Jump");
    AddKeyItem(Localize("Keys","K_Interaction","Localization\\HUD"), "Interaction");
    AddKeyItem(Localize("Keys","K_Reload","Localization\\HUD"), "ReloadGun");
    AddKeyItem(Localize("Keys","K_SwitchROF","Localization\\HUD"), "SwitchROF");
    AddKeyItem(Localize("Keys","K_ResetCamera","Localization\\HUD"), "ResetCamera");
    AddKeyItem(Localize("Keys","K_Whistle","Localization\\Enhanced"), "Whistle");
    AddKeyItem(Localize("Keys","K_QuickSave","Localization\\HUD"), "QuickSave");
	AddKeyItem(Localize("Keys","K_QuickLoad","Localization\\HUD"), "QuickLoad");
    AddKeyItem(Localize("Keys","K_NightVision","Localization\\HUD"), "DPadLeft");
    AddKeyItem(Localize("Keys","K_HeatVision","Localization\\HUD"), "DPadRight");
    AddKeyItem(Localize("Keys","K_Pause","Localization\\HUD"), "Pause");
    AddKeyItem(Localize("Keys","K_ToggleHUD","Localization\\Enhanced"), "ToggleHUD");
    AddKeyItem(Localize("Keys","K_PlayerStats","Localization\\Enhanced"), "PlayerStats");

    //AddLineItem();
    AddCompactLineItem();
	AddFireEquipControls();
    AddEnhancedCheckBoxControl("ToggleBTWTargeting", m_bToggleBTWTargeting);
    AddEnhancedCheckBoxControl("CameraJammerAutoLock", m_bCameraJammerAutoLock);
    //AddLineItem();

    // Gadgets
	AddLineItem();
	AddTitleItem(Caps(Localize("Keys","Title_Inventory","Localization\\HUD")));
    AddLineItem();

	AddKeyItem(Localize("Keys","K_QuickInventory","Localization\\HUD"), "QuickInventory");
    AddKeyItem(Localize("Keys","K_PreviousGadget","Localization\\Enhanced"), "PreviousGadget");
    AddKeyItem(Localize("Keys","K_NextGadget","Localization\\Enhanced"), "NextGadget");
    //AddKeyItem(Localize("Keys","K_FullInventory","Localization\\HUD"), "FullInventory");

    //AddLineItem();
    AddCompactLineItem();
    AddEnhancedCheckBoxControl("ToggleInventory", m_bToggleInventory);
    AddEnhancedCheckBoxControl("HideInactiveCategories", m_bHideInactiveCategories);

    // Mouse
    AddLineItem();
	AddTitleItem(Caps(Localize("HUD","MOUSE","Localization\\HUD")));
    AddLineItem();

    AddControls();

    // Enhanced
    AddLineItem();
	AddTitleItem(Caps(Localize("HUD","Enhanced","Localization\\Enhanced")));
    AddLineItem();

    AddInputModeControls();
    AddCompactLineItem();
    AddControllerSchemeControlsWithInfo();
    AddCompactLineItem();
    AddControllerIconControls();
    AddCompactLineItem();
    AddEnhancedCheckBoxControl("EnableRumble", m_bEnableRumble);
}

//==============================================================================
//
//==============================================================================
function SaveOptions()
{
    local EPCGameOptions GO;
    local UWindowList ListItem;
    local EPlayerController EPC; // Joshua - Enhanced saving controls

    GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

    GO.MouseSensitivity = m_MouseSensitivityScroll.Pos;
    GO.InvertMouse = m_InvertMouseButton.m_bSelected;
	GO.FireEquipGun = m_FireEquipGun.m_bSelected;

    EPC.eGame.m_defautSpeed = m_InitialSpeedScroll.Pos;
    EPC.bNormalizeMovement = m_bNormalizeMovement.m_bSelected;
    EPC.bCrouchDrop = m_bCrouchDrop.m_bSelected;
    EPC.bToggleBTWTargeting = m_bToggleBTWTargeting.m_bSelected;
    EPC.bCameraJammerAutoLock = m_bCameraJammerAutoLock.m_bSelected;
    EPC.bToggleInventory = m_bToggleInventory.m_bSelected;
    EPC.bHideInactiveCategories = m_bHideInactiveCategories.m_bSelected;
    switch (m_InputMode.GetSelectedIndex())
    {
        case 0:  EPC.InputMode = IM_Auto;       break;
        case 1:  EPC.InputMode = IM_Keyboard;   break;
        case 2:  EPC.InputMode = IM_Controller; break;
        default: EPC.InputMode = IM_Auto;       break;
    }
    switch (m_ControllerScheme.GetSelectedIndex())
    {
        case 0:  EPC.ControllerScheme = CS_Default;     break;
        case 1:  EPC.ControllerScheme = CS_Xbox;        break;
        case 2:  EPC.ControllerScheme = CS_PlayStation; break;
        case 3:  EPC.ControllerScheme = CS_User;        break;
        default: EPC.ControllerScheme = CS_Default;     break;
    }
    switch (m_ControllerIcon.GetSelectedIndex())
    {
        case 0:  EPC.ControllerIcon = CI_Xbox;        break;
        case 1:  EPC.ControllerIcon = CI_PlayStation; break;
        case 2:  EPC.ControllerIcon = CI_GameCube;    break;
        default: EPC.ControllerIcon = CI_None;        break;
    }
    EPC.eGame.bEnableRumble = m_bEnableRumble.m_bSelected;

    // Reset all m_bDrawFlipped's
    for (ListItem = m_ListBox.Items.Next; ListItem != None ; ListItem = ListItem.Next)
	{
		EPCOptionsKeyListBoxItem(ListItem).m_bDrawFlipped = false;
	}

    GetPlayerOwner().SaveKeyboard();
    EPC.SaveEnhancedOptions();
    EPC.eGame.SaveEnhancedOptions();
}

//==============================================================================
//
//==============================================================================
function Refresh()
{
    // Joshua - Enhanced
    local EPlayerController EPC;
    EPC = EPlayerController(GetPlayerOwner());

    if (m_InitialSpeedScroll != None)
        m_InitialSpeedScroll.Pos = EPC.eGame.m_defautSpeed;

    // Joshua - Update initial speed value label
    if (m_LInitialSpeedValue != None && m_InitialSpeedScroll != None)
        m_LInitialSpeedValue.SetLabelText(string(int(m_InitialSpeedScroll.Pos)), TXT_LEFT);

    if (m_bNormalizeMovement != None)
        m_bNormalizeMovement.m_bSelected = EPC.bNormalizeMovement;

    if (m_bCrouchDrop != None)
        m_bCrouchDrop.m_bSelected = EPC.bCrouchDrop;

    if (m_bToggleBTWTargeting != None)
        m_bToggleBTWTargeting.m_bSelected = EPC.bToggleBTWTargeting;

    if (m_bCameraJammerAutoLock != None)
        m_bCameraJammerAutoLock.m_bSelected = EPC.bCameraJammerAutoLock;

    if (m_bToggleInventory != None)
        m_bToggleInventory.m_bSelected = EPC.bToggleInventory;

    if (m_bHideInactiveCategories != None)
        m_bHideInactiveCategories.m_bSelected = EPC.bHideInactiveCategories;

    if (m_InputMode != None)
        m_InputMode.SetSelectedIndex(Clamp(EPC.InputMode, 0, m_InputMode.List.Items.Count() - 1));

    if (m_ControllerScheme != None)
        m_ControllerScheme.SetSelectedIndex(Clamp(EPC.ControllerScheme, 0, m_ControllerScheme.List.Items.Count() - 1));

    if (m_ControllerIcon != None)
        m_ControllerIcon.SetSelectedIndex(Clamp(EPC.ControllerIcon, 0, m_ControllerIcon.List.Items.Count() - 1));

    if (m_bEnableRumble != None)
        m_bEnableRumble.m_bSelected = EPC.eGame.bEnableRumble;

    // Joshua - Update mouse sensitivity value label
    if (m_LMouseSensitivityValue != None && m_MouseSensitivityScroll != None)
        m_LMouseSensitivityValue.SetLabelText(string(int(m_MouseSensitivityScroll.Pos)), TXT_LEFT);

    // MClarke - Patch 1 Beta 2 - Added false parameter
    RefreshKeyList(false);

	m_bModified = false;
	m_bFirstRefresh = false;
}

//==============================================================================
//
//==============================================================================
function ResetToDefault()
{
    local EPCGameOptions GO;
    local UWindowList ListItem;
    local EPlayerController EPC; // Joshua - Enhanced saving controls

    // Reset all m_bDrawFlipped's
    for (ListItem = m_ListBox.Items.Next; ListItem != None ; ListItem = ListItem.Next)
	{
		EPCOptionsKeyListBoxItem(ListItem).m_bDrawFlipped = false;
	}

    GO = class'Actor'.static.GetGameOptions();
    GetPlayerOwner().ResetKeyboard();
    GO.ResetControlsToDefault();
    Refresh();

	GO.oldResolution = GO.Resolution;
	GO.oldEffectsQuality = GO.EffectsQuality;
	GO.oldShadowResolution = GO.ShadowResolution;
    GO.UpdateEngineSettings();

    EPC = EPlayerController(GetPlayerOwner());
    m_InitialSpeedScroll.Pos = 5;
    m_LInitialSpeedValue.SetLabelText(string(int(m_InitialSpeedScroll.Pos)), TXT_LEFT);
    m_bNormalizeMovement.m_bSelected = true;
    m_bCrouchDrop.m_bSelected = true;
    m_bToggleBTWTargeting.m_bSelected = true;
    m_bCameraJammerAutoLock.m_bSelected = false;
    m_bToggleInventory.m_bSelected = false;
    m_bHideInactiveCategories.m_bSelected = false;
    m_InputMode.SetSelectedIndex(0);
    m_ControllerScheme.SetSelectedIndex(0);
    m_ControllerIcon.SetSelectedIndex(0);
    m_bEnableRumble.m_bSelected = true;
}

//===============================================================================
// AddFireEquipControls
//===============================================================================
function AddFireEquipControls()
{
    // a hack to make displaying Controls Possible
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Localize("HUD","FIRETODRAWGUN","Localization\\HUD");
    NewItem.m_bIsNotSelectable = true;

    m_FireEquipGun = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18, self));
    m_FireEquipGun.ImageX = 5;
    m_FireEquipGun.ImageY = 5;
    NewItem.m_Control = m_FireEquipGun;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_FireEquipGun;
}

//===============================================================================
// AddInitialSpeedControls
// Created by Joshua
//===============================================================================
function AddInitialSpeedControls()
{
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Localize("Controls","InitialSpeed","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable = true;

    m_InitialSpeedScroll = EPCHScrollBar(CreateControl(class'EPCHScrollBar', 0, 0, 150, LookAndFeel.Size_HScrollbarHeight, self));
    m_InitialSpeedScroll.SetScrollHeight(12);
    m_InitialSpeedScroll.SetRange(1, 6, 1);

    // Joshua - Create value label for initial speed scrollbar
    m_LInitialSpeedValue = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 0, 0, 40, 18));
    m_LInitialSpeedValue.Font = F_Normal;
    m_LInitialSpeedValue.TextColor.R = 71;
    m_LInitialSpeedValue.TextColor.G = 71;
    m_LInitialSpeedValue.TextColor.B = 71;
    m_LInitialSpeedValue.TextColor.A = 255;
    m_LInitialSpeedValue.SetLabelText("1", TXT_LEFT);

    NewItem.m_Control = m_InitialSpeedScroll;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_InitialSpeedScroll;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_LInitialSpeedValue;
}

//===============================================================================
// AddEnhancedCheckBoxControl - Helper function for Enhanced checkbox controls
// Created by Joshua
//===============================================================================
function EPCCheckBox AddEnhancedCheckBoxControl(string LocalizationKey, out EPCCheckBox CheckBoxVar)
{
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Localize("Controls", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_bIsNotSelectable = true;

    CheckBoxVar = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18, self));
    CheckBoxVar.ImageX = 5;
    CheckBoxVar.ImageY = 5;
    NewItem.m_Control = CheckBoxVar;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = CheckBoxVar;

    return CheckBoxVar;
}

//===============================================================================
// AddInputModeControls
// Created by Joshua
//===============================================================================
function AddInputModeControls()
{
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Localize("Controls","InputMode","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable = true;

    m_InputMode = EPCComboControl(CreateControl(class'EPCComboControl', 265, 105, 150, 18, self));
    m_InputMode.SetFont(F_Normal);
	m_InputMode.SetEditable(False);
    m_InputMode.AddItem(Localize("Controls","IM_Automatic","Localization\\Enhanced"));
	m_InputMode.AddItem(Localize("Controls","IM_Keyboard","Localization\\Enhanced"));
    m_InputMode.AddItem(Localize("Controls","IM_Controller","Localization\\Enhanced"));
	m_InputMode.SetSelectedIndex(0);

    NewItem.m_Control = m_InputMode;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_InputMode;
}


//===============================================================================
// AddControllerSchemeControlsWithInfo
// Created by Joshua
//===============================================================================
function AddControllerSchemeControlsWithInfo()
{
    local EPCOptionsKeyListBoxItem NewItem;
    local EPCInfoButton InfoButton;
    local string InfoText;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Localize("Controls","ControllerScheme","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable = true;

    m_ControllerScheme = EPCComboControl(CreateControl(class'EPCComboControl', 265, 105, 150, 18, self));
    m_ControllerScheme.SetFont(F_Normal);
	m_ControllerScheme.SetEditable(False);
    m_ControllerScheme.AddItem(Localize("Controls","CS_Default","Localization\\Enhanced"));
	m_ControllerScheme.AddItem(Localize("Controls","CS_Xbox","Localization\\Enhanced"));
    m_ControllerScheme.AddItem(Localize("Controls","CS_PlayStation","Localization\\Enhanced"));
	m_ControllerScheme.SetSelectedIndex(0);

    NewItem.m_Control = m_ControllerScheme;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_ControllerScheme;

    // Load the info text from localization
    InfoText = Localize("Controls", "ControllerScheme_Desc", "Localization\\Enhanced");

    // Only create info button if we have valid description text
    if (InfoText != "" && InfoText != "ControllerScheme_Desc")
    {
        // Add info button
        InfoButton = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16, self));
        InfoButton.InfoText = InfoText;
        InfoButton.LocalizationKey = "ControllerScheme";
        InfoButton.SettingName = NewItem.Caption;
        NewItem.m_InfoButton = InfoButton;
        m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = InfoButton;

        // Check if this tooltip has been viewed before
        if (HasViewedTooltip("ControllerScheme"))
        {
            InfoButton.bStopPulsing = true;
        }
    }
}

//===============================================================================
// AddControllerIconControls
// Created by Joshua
//===============================================================================
function AddControllerIconControls()
{
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption	= Localize("Controls","ControllerIcon","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable = true;

    m_ControllerIcon = EPCComboControl(CreateControl(class'EPCComboControl', 265, 105, 150, 18, self));
    m_ControllerIcon.SetFont(F_Normal);
    m_ControllerIcon.SetEditable(False);
    m_ControllerIcon.AddItem(Localize("Controls","CI_Xbox","Localization\\Enhanced"));
    m_ControllerIcon.AddItem(Localize("Controls","CI_PlayStation","Localization\\Enhanced"));
    m_ControllerIcon.AddItem(Localize("Controls","CI_GameCube","Localization\\Enhanced"));
    m_ControllerIcon.AddItem(Localize("Controls","CI_None","Localization\\Enhanced"));
    m_ControllerIcon.SetSelectedIndex(0);

    NewItem.m_Control = m_ControllerIcon;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_ControllerIcon;
}

//===============================================================================
// AddControls
//===============================================================================
function AddControls()
{
    // a hack to make displaying Controls Possible
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("HUD","INVERTMOUSE","Localization\\HUD");
    NewItem.m_bIsNotSelectable  = true;

    m_InvertMouseButton = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18, self));
    m_InvertMouseButton.ImageX      = 5;
    m_InvertMouseButton.ImageY      = 5;
    NewItem.m_Control = m_InvertMouseButton;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_InvertMouseButton;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("HUD","MOUSESENSITIVITY","Localization\\HUD");
    NewItem.m_bIsNotSelectable  = true;

    m_MouseSensitivityScroll   = EPCHScrollBar(CreateControl(class'EPCHScrollBar', 0, 0, 150, LookAndFeel.Size_HScrollbarHeight, self));
    m_MouseSensitivityScroll.SetScrollHeight(12);
    m_MouseSensitivityScroll.SetRange(1, 101, 1); // Joshua - Set 101 instead of 100 for full 1-100, instead of 1-99 slider

    // Joshua - Create value label for mouse sensitivity scrollbar
    m_LMouseSensitivityValue = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 0, 0, 40, 18));
    m_LMouseSensitivityValue.Font = F_Normal;
    m_LMouseSensitivityValue.TextColor.R = 71;
    m_LMouseSensitivityValue.TextColor.G = 71;
    m_LMouseSensitivityValue.TextColor.B = 71;
    m_LMouseSensitivityValue.TextColor.A = 255;
    m_LMouseSensitivityValue.SetLabelText("1", TXT_LEFT);

    NewItem.m_Control = m_MouseSensitivityScroll;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_MouseSensitivityScroll;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_LMouseSensitivityValue;
}

//===============================================================================
// AddKeyItem: Add a key item
//===============================================================================
function AddKeyItem(string _szTitle, string _szActionKey)
{
	local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = _szTitle;
	NewItem.m_szActionKey			= _szActionKey;
	NewItem.HelpText	= GetLocKeyNameByActionKey(_szActionKey, false); // value to display "the key name"
    NewItem.HelpText2	= GetLocKeyNameByActionKey(_szActionKey, true); // value to display "the ALT key name"
}

//===============================================================================
// RefreshKeyList: Refresh the list of key with the new value in Bindings[] array
//===============================================================================
function RefreshKeyList(bool bKeysOnly) // MClarke - Patch 1 Beta 2 - Added bool bKeysOnly parameter
{
	local UWindowList ListItem;
	local string szTemp;
    local EPCGameOptions GO;
    local EPlayerController EPC; // Joshua - Enhanced config save

    EPC = EPlayerController(GetPlayerOwner());

	for (ListItem = m_ListBox.Items.Next; ListItem != None ; ListItem = ListItem.Next)
	{
		if (!EPCOptionsKeyListBoxItem(ListItem).m_bIsNotSelectable)
        {
	        EPCOptionsKeyListBoxItem(ListItem).HelpText = GetLocKeyNameByActionKey(EPCOptionsKeyListBoxItem(ListItem).m_szActionKey, false);
            EPCOptionsKeyListBoxItem(ListItem).HelpText2 = GetLocKeyNameByActionKey(EPCOptionsKeyListBoxItem(ListItem).m_szActionKey, true);
        }
	}

    // MClarke - Patch 1 Beta 2 - Added bKeysOnly check
    if (!bKeysOnly)
    {
        GO = class'Actor'.static.GetGameOptions();

        m_MouseSensitivityScroll.Pos = Clamp(GO.MouseSensitivity, 1,100);

        // Joshua - Update value label for mouse sensitivity scrollbar
        if (m_LMouseSensitivityValue != None)
            m_LMouseSensitivityValue.SetLabelText(string(int(m_MouseSensitivityScroll.Pos)), TXT_LEFT);

        m_InvertMouseButton.m_bSelected = GO.InvertMouse;
	    m_FireEquipGun.m_bSelected = GO.FireEquipGun;
        m_InitialSpeedScroll.Pos = Clamp(EPC.eGame.m_defautSpeed, 1,6);
        // Joshua - Update value label for initial speed scrollbar
        if (m_LInitialSpeedValue != None)
            m_LInitialSpeedValue.SetLabelText(string(int(m_InitialSpeedScroll.Pos)), TXT_LEFT);
        m_bNormalizeMovement.m_bSelected = EPC.bNormalizeMovement;
        m_bCrouchDrop.m_bSelected = EPC.bCrouchDrop;
        m_bToggleBTWTargeting.m_bSelected = EPC.bToggleBTWTargeting;
        m_bCameraJammerAutoLock.m_bSelected = EPC.bCameraJammerAutoLock;
        m_bToggleInventory.m_bSelected = EPC.bToggleInventory;
        m_bHideInactiveCategories.m_bSelected = EPC.bHideInactiveCategories;
        m_InputMode.SetSelectedIndex(Clamp(EPC.InputMode,0,m_InputMode.List.Items.Count()));
        m_ControllerScheme.SetSelectedIndex(Clamp(EPC.ControllerScheme,0,m_ControllerScheme.List.Items.Count()));
        m_ControllerIcon.SetSelectedIndex(Clamp(EPC.ControllerIcon,0,m_ControllerScheme.List.Items.Count()));
        m_bEnableRumble.m_bSelected = EPC.eGame.bEnableRumble;
    }
}

//===============================================================================
// GetLocKeyNameByActionKey: Get the localization name of the key to display
//===============================================================================
function string GetLocKeyNameByActionKey(string _szActionKey, bool bAltKey)
{
	local string szTemp;
	local BYTE Key;

	Key = GetPlayerOwner().GetKey(_szActionKey, bAltKey);

	// Joshua - Don't display controller keys in the key binding boxes
	if (Key >= 196 && Key <= 215)
		return "";

	szTemp = GetPlayerOwner().GetEnumName(Key);
	szTemp = EPCConsole(Root.Console).ConvertKeyToLocalisation(Key, szTemp);

	return szTemp;
}

//===============================================================================
// AddLineItem: add a line item in the list
//===============================================================================
function AddLineItem()
{
	local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.m_bIsNotSelectable  = true;
}

//===============================================================================
// AddCompactLineItem: add a compact line item in the list
//===============================================================================
function AddCompactLineItem()
{
	local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.bIsCompactLine = true;
    NewItem.m_bIsNotSelectable  = true;
}

//===============================================================================
// AddTitleItem: Add a title item only
//===============================================================================
function AddTitleItem(string _szTitle)
{
	local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption             = _szTitle;
    NewItem.m_bisTitle          = true;
    NewItem.m_bIsNotSelectable  = true;
}

//==============================================================================
// KeyPressed -  Set the new key pressed
//==============================================================================
function KeyPressed(int Key)
{
	local string szKeyName;
    local string szKeyToReplace;        // Tells whether we want to replace the primary or alt key
    local BYTE KeyOld;                  // Key which will be replaced
    local BYTE OtherKey;

    KeyOld = GetPlayerOwner().GetKey(EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_szActionKey, m_ListBox.m_bDoingAltMapping);
    OtherKey = GetPlayerOwner().GetKey(EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_szActionKey, !m_ListBox.m_bDoingAltMapping);
	szKeyToReplace = GetPlayerOwner().GetEnumName(KeyOld);

	// set the key and refresh the list
	szKeyName = GetPlayerOwner().GetEnumName(Key);

    if ((OtherKey != 0) && (m_ListBox.m_bDoingAltMapping == (Key < OtherKey)))
    {
        EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped = !EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;
    }
    else
    {
        EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped = EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;
    }

	GetPlayerOwner().SetKey(szKeyName@ EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_szActionKey, szKeyToReplace);

    // MClarke - Patch 1 Beta 2 - Added true parameter
    RefreshKeyList(true);
}

//==============================================================================
// KeyDown - Handler for a key pressed, passes stuff to KeyPressed, if valid
//==============================================================================
function KeyDown(int Key, float X, float Y)
{
	//local string szTemp, szKeyName;

	if (m_MessageBox != None)
    {
		// set the key and refresh the list
		//szKeyName = GetPlayerOwner().GetEnumName(Key);

		//validates the windows key:
		//szTemp = Caps(Left(szKeyName, 7));

		// No joystick/gamepad support for the PC version
		if (Key >= 196 && Key <= 215) return;

        // Joshua - Prevent binding Windows left (92) and Windows right (93)
        If (Key == 92 || Key == 93) return;

        // Joshua - Allow binding unknown keys (used for Mouse 4 / Mouse 5)
		//if (szTemp == "UNKNOWN") return;

		if (Key != GetPlayerOwner().Player.Console.EInputKey.IK_Escape)
		{
			 EPCMainMenuRootWindow(Root).m_MessageBoxCW.Close();
			 KeyPressed(Key);
			 m_MessageBox = None;
			 m_bModified = true;
		}
    }
}

//==============================================================================
// LMouseDown - Handler for player who wants to set Left mouse button as new key
//==============================================================================
function LMouseDown(float X, float Y)
{
	if (m_MessageBox != None)
    {
         EPCMainMenuRootWindow(Root).m_MessageBoxCW.Close();
         KeyPressed(Root.Console.EInputKey.IK_LeftMouse);
         m_MessageBox = None;
         m_bModified = true;
    }
}

//==============================================================================
// MMouseDown - Handler for player who wants to set Middle mouse button as new key
//==============================================================================
function MMouseDown(float X, float Y)
{
    if (m_MessageBox != None)
    {
         EPCMainMenuRootWindow(Root).m_MessageBoxCW.Close();
         KeyPressed(Root.Console.EInputKey.IK_MiddleMouse);
         m_MessageBox = None;
         m_bModified = true;
    }
}

//==============================================================================
//
//==============================================================================
function RMouseDown(float X, float Y)
{
	if (m_MessageBox != None)
    {
         EPCMainMenuRootWindow(Root).m_MessageBoxCW.Close();
         KeyPressed(Root.Console.EInputKey.IK_RightMouse);
         m_MessageBox = None;
         m_bModified = true;
    }
}

//==============================================================================
//
//==============================================================================
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	if (m_MessageBox != None)
    {
         EPCMainMenuRootWindow(Root).m_MessageBoxCW.Close();
         KeyPressed(Root.Console.EInputKey.IK_MouseWheelDown);
         m_MessageBox = None;
         m_bModified = true;
    }
}

//==============================================================================
//
//==============================================================================
function MouseWheelUp(FLOAT X, FLOAT Y)
{
	if (m_MessageBox != None)
    {
         EPCMainMenuRootWindow(Root).m_MessageBoxCW.Close();
         KeyPressed(Root.Console.EInputKey.IK_MouseWheelUp);
         m_MessageBox = None;
         m_bModified = true;
    }
}

//==============================================================================
// Notify - Handles doubles clicks and single clicks
//==============================================================================
function Notify(UWindowDialogControl C, byte E)
{
    local float iMouseX;
    local float iMouseY;
    local float fOffsetFromMiddle; // Where the PRIM and ALT boxes start from middle of screen

    fOffsetFromMiddle = 6.50;

    if (E == DE_DoubleClick && C == m_ListBox && m_ListBox.SelectedItem != None)
    {
        GetMouseXY(iMouseX, iMouseY);

        // Now we want to know whether primary or alternate config has been selected
        if ((iMouseX - ((m_ListBox.WinWidth / 2) -  fOffsetFromMiddle)) > (m_ListBox.m_IHighLightWidth / 1.4))
        {
            m_ListBox.m_bDoingAltMapping = !EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;
        }
        else
        {
            m_ListBox.m_bDoingAltMapping = EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;
        }

        m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","MAPKEYTITLE","Localization\\HUD"), Localize("OPTIONS","MAPKEYMESSAGE","Localization\\HUD"), MB_Cancel, MR_Cancel, MR_None, true);
    }
    else if (E == DE_Click && C == m_InvertMouseButton)
    {
        m_bModified = true;
    }
    else if (E == DE_Click && C == m_FireEquipGun)
    {
        m_bModified = true;
    }
    else if (E == DE_Change && C == m_MouseSensitivityScroll)
    {
        m_bModified = true;
        // Joshua - Update value label for mouse sensitivity scrollbar
        if (m_LMouseSensitivityValue != None)
            m_LMouseSensitivityValue.SetLabelText(string(int(m_MouseSensitivityScroll.Pos)), TXT_LEFT);
    }
    else if (E == DE_Change && C == m_InitialSpeedScroll)
    {
        m_bModified = true;
        // Joshua - Update value label for initial speed scrollbar
        if (m_LInitialSpeedValue != None)
            m_LInitialSpeedValue.SetLabelText(string(int(m_InitialSpeedScroll.Pos)), TXT_LEFT);
    }
    else if (E == DE_Click && C == m_bNormalizeMovement)
    {
        m_bModified = true;
    }
    else if (E == DE_Click && C == m_bCrouchDrop)
    {
        m_bModified = true;
    }
    else if (E == DE_Click && C == m_bToggleBTWTargeting)
    {
        m_bModified = true;
    }
    else if (E == DE_Click && C == m_bCameraJammerAutoLock)
    {
        m_bModified = true;
    }
    else if (E == DE_Click && C == m_bToggleInventory)
    {
        m_bModified = true;
    }
    else if (E == DE_Click && C == m_bHideInactiveCategories)
    {
        m_bModified = true;
    }
    else if (E == DE_Change && C == m_InputMode)
    {
        m_bModified = true;
    }
    else if (E == DE_Change && C == m_ControllerScheme)
    {
        m_bModified = true;
    }
    else if (E == DE_Change && C == m_ControllerIcon)
    {
        m_bModified = true;
    }
    else if (E == DE_Click && C == m_bEnableRumble)
    {
        m_bModified = true;
    }
}

//==============================================================================
//
//==============================================================================
function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    m_MessageBox = None;
}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    local EPCOptionsKeyListBoxItem Item;

    m_bEnableArea = bEnable;

    if (bEnable)
    {
        // Count total selectable items (items with m_Control != None or key items)
        CountSelectableItems();

        // Find the first visible selectable item based on scroll position
        // This also sets m_bNeedsScrollOnEnable and m_scrollTargetRawIndex if no item is visible
        m_selectedItemIndex = GetFirstVisibleSelectableItemIndex();

        m_bSliderFocused = false;
        m_bComboFocused = false;

        // If no selectable item is visible, scroll to make one visible
        if (m_bNeedsScrollOnEnable && m_ListBox.VertSB != None)
        {
            // Scroll to center the target item in view
            m_ListBox.VertSB.Pos = Max(0, m_scrollTargetRawIndex - 3);
        }

        // Highlight the selected item
        ClearHighlight();
        Item = GetSelectableItemAtIndex(m_selectedItemIndex);
        if (Item != None)
        {
            Item.bControllerSelected = true;
        }
    }
    else
    {
        // Clear selection
        m_selectedItemIndex = -1;
        ClearHighlight();
        m_bSliderFocused = false;
        m_bComboFocused = false;
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
    }
}

// Joshua - Check if current item has an info button
function bool CurrentItemHasInfo()
{
    local EPCOptionsKeyListBoxItem Item;

    if (!m_bEnableArea || m_selectedItemIndex < 0)
        return false;

    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_InfoButton != None)
    {
        return true;
    }

    return false;
}

// Joshua - Get the first visible selectable item based on scroll position
// Returns the selectable index and sets bNeedsScroll to true if item is not currently visible
function int GetFirstVisibleSelectableItemIndex()
{
    local int ScrollPos;
    local int VisibleCount;
    local int VisibleEnd;
    local int SelectableIndex;
    local int FirstSelectableAfterView;
    local int RawIndexOfFirstAfter;
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;
    local bool bInVisibleArea;

    // Get the current scroll position (number of visible items scrolled past)
    ScrollPos = 0;
    if (m_ListBox.VertSB != None)
    {
        ScrollPos = m_ListBox.VertSB.Pos;
    }

    // Calculate visible end (approximate - 8 items visible)
    VisibleEnd = ScrollPos + 8;

    // First selectable item in visible area or first selectable item after visible area (for scrolling down)
    VisibleCount = 0;
    SelectableIndex = 0;
    FirstSelectableAfterView = -1;
    RawIndexOfFirstAfter = 0;

    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        if (!CurItem.ShowThisItem())
            continue;

        bInVisibleArea = (VisibleCount >= ScrollPos && VisibleCount < VisibleEnd);

        KeyItem = EPCOptionsKeyListBoxItem(CurItem);
        if (KeyItem != None && KeyItem.m_Control != None)
        {
            // This is a selectable item
            if (bInVisibleArea)
            {
                // Found a selectable item in visible area - return it
                m_bNeedsScrollOnEnable = false;
                return SelectableIndex;
            }
            else if (VisibleCount >= VisibleEnd && FirstSelectableAfterView == -1)
            {
                // After visible area - remember the first one
                FirstSelectableAfterView = SelectableIndex;
                RawIndexOfFirstAfter = VisibleCount;
            }
            SelectableIndex++;
        }

        VisibleCount++;
    }

    // No selectable item in visible area - need to scroll
    m_bNeedsScrollOnEnable = true;

    // If there's a selectable item below the view, scroll to it
    if (FirstSelectableAfterView >= 0)
    {
        m_scrollTargetRawIndex = RawIndexOfFirstAfter;
        return FirstSelectableAfterView;
    }

    // Otherwise, go to first selectable item
    m_scrollTargetRawIndex = 0;
    return 0;
}

// Joshua - Exit the area (used by parent when B is pressed)
function ExitArea()
{
    if (m_bEnableArea)
    {
        ClearHighlight();
        m_bEnableArea = false;
        m_bSliderFocused = false;
        m_bComboFocused = false;

        // Notify parent menu that we exited
        if (EPCOptionsMenu(ParentWindow) != None)
        {
            EPCOptionsMenu(ParentWindow).AreaExited();
        }
    }
}

// Joshua - Count selectable items for controller navigation
function CountSelectableItems()
{
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;

    m_totalSelectableItems = 0;

    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        KeyItem = EPCOptionsKeyListBoxItem(CurItem);
        if (KeyItem != None)
        {
            // Only selectable if it has a control (slider/checkbox/combo)
            // Skip key binding items, they're not usable with controller
            if (KeyItem.m_Control != None)
            {
                m_totalSelectableItems++;
            }
        }
    }
}

// Joshua - Get item at selectable index
function EPCOptionsKeyListBoxItem GetSelectableItemAtIndex(int SelectableIndex)
{
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;
    local int CurrentSelectableIndex;

    CurrentSelectableIndex = 0;

    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        KeyItem = EPCOptionsKeyListBoxItem(CurItem);
        if (KeyItem != None)
        {
            // Only selectable if it has a control (slider/checkbox/combo)
            // Skip key binding items, they're not usable with controller
            if (KeyItem.m_Control != None)
            {
                if (CurrentSelectableIndex == SelectableIndex)
                    return KeyItem;
                CurrentSelectableIndex++;
            }
        }
    }

    return None;
}

// Joshua - Highlight the selected item
function HighlightSelectedItem(int Index)
{
    local EPCOptionsKeyListBoxItem Item;

    ClearHighlight();

    Item = GetSelectableItemAtIndex(Index);
    if (Item != None)
    {
        Item.bControllerSelected = true;
        ScrollToItem(Index);
    }
}

// Joshua - Clear all highlights
function ClearHighlight()
{
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;

    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        KeyItem = EPCOptionsKeyListBoxItem(CurItem);
        if (KeyItem != None)
        {
            KeyItem.bControllerSelected = false;
        }
    }
}

// Joshua - Restore highlight when controller mode is re-enabled
// Select the first visible selectable item based on current scroll position
// If no selectable items are visible, scroll to the nearest one
function RestoreHighlight()
{
    local EPCOptionsKeyListBoxItem Item;

    // Clear keybind button selection since controller mode doesn't use keybind buttons
    if (m_ListBox != None && m_ListBox.SelectedItem != None)
    {
        m_ListBox.SelectedItem.bSelected = false;
        m_ListBox.SelectedItem = None;
    }

    // Only restore if area is enabled
    if (m_bEnableArea)
    {
        // Find the first visible selectable item (in case user scrolled with mouse)
        // This also sets m_bNeedsScrollOnEnable if no item is visible
        m_selectedItemIndex = GetFirstVisibleSelectableItemIndex();

        // If no selectable item is visible, scroll to make one visible
        if (m_bNeedsScrollOnEnable && m_ListBox.VertSB != None)
        {
            // Scroll to center the target item in view
            m_ListBox.VertSB.Pos = Max(0, m_scrollTargetRawIndex - 3);
        }

        // Highlight the selected item
        ClearHighlight();
        Item = GetSelectableItemAtIndex(m_selectedItemIndex);
        if (Item != None)
        {
            Item.bControllerSelected = true;
        }
    }
}

// Joshua - Scroll the list to make the specified item visible
function ScrollToItem(int SelectableIndex)
{
    local int RawIndex;
    local int VisibleCount;
    local int ScrollMargin;
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;
    local int SelectableCount;

    if (m_ListBox.VertSB == None)
        return;

    // Find the raw index (including non-selectable items) for scrolling
    RawIndex = 0;
    SelectableCount = 0;
    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        KeyItem = EPCOptionsKeyListBoxItem(CurItem);
        if (KeyItem != None)
        {
            // Only count items with controls (skip key binding items)
            if (KeyItem.m_Control != None)
            {
                if (SelectableCount == SelectableIndex)
                    break;
                SelectableCount++;
            }
        }
        RawIndex++;
    }

    VisibleCount = 6; // Visible items in the window
    ScrollMargin = 2; // Start scrolling when within 2 items of edge

    // Scroll down if item is near bottom of visible area
    if (RawIndex >= m_ListBox.VertSB.Pos + VisibleCount - ScrollMargin)
    {
        m_ListBox.VertSB.Pos = RawIndex - VisibleCount + ScrollMargin + 1;
    }
    // Scroll up if item is near top of visible area
    else if (RawIndex < m_ListBox.VertSB.Pos + ScrollMargin)
    {
        m_ListBox.VertSB.Pos = Max(0, RawIndex - ScrollMargin);
    }
}

// Joshua - Check if current item is a slider
function bool IsCurrentItemSlider()
{
    local EPCOptionsKeyListBoxItem Item;
    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_Control != None)
    {
        return (EPCHScrollBar(Item.m_Control) != None);
    }
    return false;
}

// Joshua - Check if current item is a combo box
function bool IsCurrentItemCombo()
{
    local EPCOptionsKeyListBoxItem Item;
    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_Control != None)
    {
        return (EPCComboControl(Item.m_Control) != None);
    }
    return false;
}

// Joshua - Check if current item is a checkbox
function bool IsCurrentItemCheckbox()
{
    local EPCOptionsKeyListBoxItem Item;
    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_Control != None)
    {
        return (EPCCheckBox(Item.m_Control) != None);
    }
    return false;
}

// Joshua - Get the slider at current selection
function EPCHScrollBar GetCurrentSlider()
{
    local EPCOptionsKeyListBoxItem Item;
    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_Control != None)
    {
        return EPCHScrollBar(Item.m_Control);
    }
    return None;
}

// Joshua - Get the combo at current selection
function EPCComboControl GetCurrentCombo()
{
    local EPCOptionsKeyListBoxItem Item;
    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_Control != None)
    {
        return EPCComboControl(Item.m_Control);
    }
    return None;
}

// Joshua - Get the checkbox at current selection
function EPCCheckBox GetCurrentCheckbox()
{
    local EPCOptionsKeyListBoxItem Item;
    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_Control != None)
    {
        return EPCCheckBox(Item.m_Control);
    }
    return None;
}

// Joshua - Adjust slider value
function AdjustSlider(int Direction, int Key)
{
    local EPCHScrollBar Slider;
    local float NewPos;
    local float Step;
    local bool bIsDPad;

    Slider = GetCurrentSlider();
    if (Slider == None)
        return;

    // DPad (214/215) uses step of 1, Analog stick (198/199) uses step of 5
    bIsDPad = (Key == 214 || Key == 215);

    // Determine step size based on which slider and input type
    if (Slider == m_MouseSensitivityScroll)
    {
        if (bIsDPad)
            Step = 1.0;
        else
            Step = 5.0;
    }
    else if (Slider == m_InitialSpeedScroll)
    {
        Step = 1.0; // Initial speed always adjusts by 1
    }
    else
    {
        if (bIsDPad)
            Step = 1.0;
        else
            Step = 5.0;
    }

    NewPos = Slider.Pos + (Direction * Step);

    // Clamp to valid range
    if (NewPos < Slider.MinPos)
        NewPos = Slider.MinPos;
    if (NewPos > Slider.MaxPos)
        NewPos = Slider.MaxPos;

    if (Slider.Pos != NewPos)
    {
        Slider.Pos = NewPos;
        Slider.Notify(DE_Change);
    }
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    local EPCComboControl Combo;

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

    // Handle controller input
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

        // Process the key action
        HandleKeyAction(Key);
    }
}

// Joshua - Process a key action (called on initial press and during auto-repeat)
function HandleKeyAction(int Key)
{
    local EPCComboControl Combo;

    // If combo is focused, handle its navigation
    if (m_bComboFocused)
    {
        Combo = GetCurrentCombo();
        if (Combo != None)
        {
            // DPadUp (212) or AnalogUp (196)
            if (Key == 212 || Key == 196)
            {
                // Up in combo - previous item
                if (Combo.GetSelectedIndex() > 0)
                    Combo.SetSelectedIndex(Combo.GetSelectedIndex() - 1);
            }
            // DPadDown (213) or AnalogDown (197)
            else if (Key == 213 || Key == 197)
            {
                // Down in combo - next item
                if (Combo.GetSelectedIndex() < Combo.List.Items.Count() - 1)
                    Combo.SetSelectedIndex(Combo.GetSelectedIndex() + 1);
            }
            else if (Key == 200 || Key == 201) // A or B
            {
                // A or B - close combo and confirm
                Combo.CloseUp();
                m_bComboFocused = false;
            }
        }
        return;
    }

    // Normal item navigation
    // DPadUp (212) or AnalogUp (196)
    if (Key == 212 || Key == 196)
    {
        // Move up in list
        if (m_selectedItemIndex > 0)
        {
            Root.PlayClickSound();
            m_selectedItemIndex--;
            HighlightSelectedItem(m_selectedItemIndex);
        }
    }
    // DPadDown (213) or AnalogDown (197)
    else if (Key == 213 || Key == 197)
    {
        // Move down in list
        if (m_selectedItemIndex < m_totalSelectableItems - 1)
        {
            Root.PlayClickSound();
            m_selectedItemIndex++;
            HighlightSelectedItem(m_selectedItemIndex);
        }
    }
    // DPadLeft (214) or AnalogLeft (198)
    else if (Key == 214 || Key == 198)
    {
        // Left - adjust slider directly if current item is a slider
        if (IsCurrentItemSlider())
        {
            Root.PlayClickSound();
            AdjustSlider(-1, Key);
        }
    }
    // DPadRight (215) or AnalogRight (199)
    else if (Key == 215 || Key == 199)
    {
        // Right - adjust slider directly if current item is a slider
        if (IsCurrentItemSlider())
        {
            Root.PlayClickSound();
            AdjustSlider(1, Key);
        }
    }
    else if (Key == 200) // A button
    {
        // A button - activate current item (sliders are controlled directly with left/right)
        if (IsCurrentItemCombo())
        {
            // Open combo box
            Combo = GetCurrentCombo();
            if (Combo != None)
            {
                Root.PlayClickSound();
                Combo.DropDown();
                m_bComboFocused = true;
                // Reset held key state so direction isn't carried into combo
                m_heldKey = 0;
                m_keyHoldTime = 0;
            }
        }
        else if (IsCurrentItemCheckbox())
        {
            // Toggle checkbox
            Root.PlayClickSound();
            ToggleCurrentCheckbox();
        }
    }
    else if (Key == 201) // B button - exit area
    {
        ExitArea();
    }
    else if (Key == 203) // Y button - show tooltip
    {
        ShowCurrentItemTooltip();
    }
}

// Joshua - Tick function to handle auto-repeat for held keys and info button pulse
function Tick(float Delta)
{
    Super.Tick(Delta);

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

    if (!m_bEnableArea || m_heldKey == 0)
        return;

    m_keyHoldTime += Delta;

    // Check if it's time to repeat
    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Execute the held key's action
        HandleKeyAction(m_heldKey);

        // Schedule next repeat
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

// Joshua - Show tooltip for current item if it has an info button
function ShowCurrentItemTooltip()
{
    local EPCOptionsKeyListBoxItem Item;
    local EPCInfoButton InfoButton;

    Item = GetSelectableItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_InfoButton != None)
    {
        InfoButton = EPCInfoButton(Item.m_InfoButton);
        if (InfoButton != None)
        {
            // Stop any auto-scrolling when opening tooltip
            m_heldKey = 0;
            m_keyHoldTime = 0;
            m_nextRepeatTime = 0;

            InfoButton.ShowInfoMessage();
            InfoButton.bStopPulsing = true;
            // Mark as viewed
            MarkTooltipViewed(InfoButton.LocalizationKey);
        }
    }
}

// Joshua - Toggle the current checkbox
function ToggleCurrentCheckbox()
{
    local EPCCheckBox Checkbox;

    Checkbox = GetCurrentCheckbox();
    if (Checkbox != None)
    {
        Checkbox.m_bSelected = !Checkbox.m_bSelected;
        Checkbox.Notify(DE_Click);
    }
}

// Joshua - BeforePaint to detect combo box auto-close
function BeforePaint(Canvas C, float X, float Y)
{
    local EPCComboControl Combo;

    Super.BeforePaint(C, X, Y);

    // Check if combo was closed externally (clicked outside)
    if (m_bComboFocused)
    {
        Combo = GetCurrentCombo();
        if (Combo != None && !Combo.bListVisible)
        {
            m_bComboFocused = false;
        }
    }

    // Joshua - If controller mode is active and selection is enabled, check if selected item scrolled off-screen
    // Only update when in controller mode to avoid interfering with mouse scrolling
    if (m_bEnableArea && !m_bSliderFocused && !m_bComboFocused && EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        UpdateSelectionIfOffscreen();
    }
}

// Joshua - Update controller selection if currently selected item is off-screen
// This only triggers when mouse scrolling moves the view away from the selected item
function UpdateSelectionIfOffscreen()
{
    local int RawIndex;
    local int SelectableCount;
    local int VisibleCount;
    local int ScrollPos;
    local int SelectedRawIndex;
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;
    local int NewSelectableIndex;

    if (m_ListBox == None || m_ListBox.VertSB == None)
        return;

    // Don't update if using controller navigation (key is being held)
    if (m_heldKey != 0)
        return;

    ScrollPos = m_ListBox.VertSB.Pos;

    // Calculate visible count based on listbox height and item height
    // ItemHeight is typically 18-20 pixels, so divide window height by a safe minimum
    VisibleCount = int(m_ListBox.WinHeight / m_ListBox.ItemHeight) + 2;
    if (VisibleCount < 10)
        VisibleCount = 10; // Minimum fallback

    // First, find the raw index of the currently selected item
    RawIndex = 0;
    SelectableCount = 0;
    SelectedRawIndex = -1;
    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        KeyItem = EPCOptionsKeyListBoxItem(CurItem);
        if (KeyItem != None && KeyItem.m_Control != None)
        {
            if (SelectableCount == m_selectedItemIndex)
            {
                SelectedRawIndex = RawIndex;
                break;
            }
            SelectableCount++;
        }
        RawIndex++;
    }

    // Check if selected item is visible (between scroll pos and scroll pos + visible count)
    if (SelectedRawIndex >= 0 && SelectedRawIndex >= ScrollPos && SelectedRawIndex < ScrollPos + VisibleCount)
    {
        // Item is visible, nothing to do
        return;
    }

    // Item is off-screen, update selection to first visible selectable item
    // Don't call HighlightSelectedItem here because that would scroll the view, just update the selection state directly
    NewSelectableIndex = GetFirstVisibleSelectableItemIndex();
    if (NewSelectableIndex != m_selectedItemIndex)
    {
        ClearHighlight();
        m_selectedItemIndex = NewSelectableIndex;
        // Directly set the highlight without scrolling
        KeyItem = GetSelectableItemAtIndex(m_selectedItemIndex);
        if (KeyItem != None)
        {
            KeyItem.bControllerSelected = true;
        }
    }
}

defaultproperties
{
    m_initialDelay=0.5
    m_repeatRate=0.1
}
