//=============================================================================
//  EPCControlsConfigArea.uc : Area containing controls for setting game keys
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/27 * Created by Alexandre Dionne
//=============================================================================


class EPCControlsConfigArea extends UWindowDialogClientWindow;

var EPCOptionKeysListBox m_ListBox;
var EPCMessageBox        m_MessageBox;

var EPCHScrollBar        m_MouseSensitivityScroll;
var UWindowLabelControl  m_LMouseSensitivityValue; // Joshua - Label for the mouse sensitivity scroll bar
var EPCHScrollBar        m_InitialSpeedScroll; // Joshua - Enhanced setting
var EPCCheckBox          m_InvertMouseButton;
var EPCCheckBox          m_FireEquipGun;
var EPCCheckBox          m_bNormalizeMovement; // Joshua - Enhanced setting
var EPCCheckBox          m_bCrouchDrop; // Joshua - Enhanced setting
var EPCCheckBox          m_bToggleBTWTargeting; // Joshua - Enhanced setting
var EPCCheckBox          m_bToggleInventory; // Joshua - Enhanced setting
var EPCCheckBox          m_bEnableRumble; // Joshua - Enhanced setting
var EPCComboControl      m_InputMode; // Joshua - Enhanced setting
var EPCComboControl      m_ControllerScheme; // Joshua - Enhnaced setting
var EPCComboControl      m_ControllerIcon; // Joshua - Enhnaced setting

var bool                    m_bModified;    //A setting has changed
var bool					m_bFirstRefresh;


//==============================================================================
// 
//==============================================================================
function Created()
{
    SetAcceptsFocus();

	m_MessageBox = none;
	
    m_ListBox = EPCOptionKeysListBox(CreateControl( class'EPCOptionKeysListBox', 0, 0, WinWidth, WinHeight, self));            
    m_ListBox.bAlwaysBehind = true;
    InitOptionControls();
    m_ListBox.TitleFont=F_Normal;
}

//==============================================================================
// 
//==============================================================================
function InitOptionControls()
{
	// MOVEMENT
	// add items in display order
    AddLineItem();
	AddTitleItem( Caps(Localize("Keys","Title_Move","Localization\\HUD")));
    AddLineItem();
    
	AddKeyItem( Localize("Keys","K_MoveForward","Localization\\HUD"),"MoveForward");
	AddKeyItem( Localize("Keys","K_MoveBackward","Localization\\HUD"), "MoveBackward");
    AddKeyItem( Localize("Keys","K_StrafeLeft","Localization\\HUD"),"StrafeLeft");
	AddKeyItem( Localize("Keys","K_StrafeRight","Localization\\HUD"), "StrafeRight");
    AddKeyItem( Localize("Keys","K_Duck","Localization\\HUD"),"Duck");
	AddKeyItem( Localize("Keys","K_Accel","Localization\\HUD"), "IncSpeed");
    AddKeyItem( Localize("Keys","K_Decell","Localization\\HUD"),"DecSpeed");
    AddKeyItem( Localize("Keys","k_BackToWall","Localization\\HUD"),"BackToWall");
    
    AddLineItem();
    AddInitialSpeedControls();
    AddNormalizedMovementControls();
    AddCrouchDropControls();
    AddLineItem();
	
    // Actions
	AddLineItem();
	AddTitleItem( Caps(Localize("Keys","Title_Actions","Localization\\HUD")));
    AddLineItem();

	AddKeyItem( Localize("Keys","K_Fire","Localization\\HUD"), "Fire");
	AddKeyItem( Localize("Keys","K_AltFire","Localization\\HUD"), "AltFire");
    AddKeyItem( Localize("Keys","K_Snipe","Localization\\Enhanced"), "Snipe");
    AddKeyItem( Localize("Keys","K_Scope","Localization\\HUD"), "Scope");
    AddKeyItem( Localize("Keys","K_Jump","Localization\\HUD"), "Jump");
    AddKeyItem( Localize("Keys","K_Interaction","Localization\\HUD"), "Interaction");
    AddKeyItem( Localize("Keys","K_Reload","Localization\\HUD"), "ReloadGun");
    AddKeyItem( Localize("Keys","K_SwitchROF","Localization\\HUD"), "SwitchROF");
    AddKeyItem( Localize("Keys","K_Whistle","Localization\\Enhanced"), "Whistle");
    AddKeyItem( Localize("Keys","K_QuickSave","Localization\\HUD"), "QuickSave");
	AddKeyItem( Localize("Keys","K_QuickLoad","Localization\\HUD"), "QuickLoad");
    AddKeyItem( Localize("Keys","K_NightVision","Localization\\HUD"), "DPadLeft");
    AddKeyItem( Localize("Keys","K_HeatVision","Localization\\HUD"), "DPadRight");
    AddKeyItem( Localize("Keys","K_Pause","Localization\\HUD"), "Pause");
    AddKeyItem( Localize("Keys","K_ToggleHUD","Localization\\Enhanced"), "ToggleHUD");
    AddKeyItem( Localize("Keys","K_PlayerStats","Localization\\Enhanced"), "PlayerStats");

    AddLineItem();
	AddFireEquipControls();
    AddToggleBTWTargetingControls();
    AddLineItem();
    
    // Gadgets
	AddLineItem();
	AddTitleItem( Caps(Localize("Keys","Title_Inventory","Localization\\HUD")));
    AddLineItem();

	AddKeyItem( Localize("Keys","K_QuickInventory","Localization\\HUD"), "QuickInventory");
    AddKeyItem( Localize("Keys","K_PreviousGadget","Localization\\Enhanced"), "PreviousGadget");
    AddKeyItem( Localize("Keys","K_NextGadget","Localization\\Enhanced"), "NextGadget");
    //AddKeyItem( Localize("Keys","K_FullInventory","Localization\\HUD"), "FullInventory");

    AddLineItem();
    AddToggleInventoryControls();
    AddLineItem();


    // Mouse
    AddLineItem();
	AddTitleItem( Caps(Localize("HUD","MOUSE","Localization\\HUD")));
    AddLineItem();

    AddControls();
    AddLineItem();

    // Enhanced
    AddLineItem();
	AddTitleItem( Caps(Localize("HUD","Enhanced","Localization\\Enhanced")));
    AddLineItem();

    AddInputModeControls();
    AddLineItem();
    AddControllerSchemeControls();
    AddLineItem();
    AddControllerIconControls();
    AddLineItem();
    AddEnableRumbleControls();
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
    EPC.bToggleInventory = m_bToggleInventory.m_bSelected;
    switch (m_InputMode.GetSelectedIndex())
    {
        case 0:
            EPC.InputMode = IM_Auto;
            break;
        case 1:
            EPC.InputMode = IM_Keyboard;
            break;
        case 2:
            EPC.InputMode = IM_Controller;
            break;
        default:
            EPC.InputMode = IM_Auto;
            break;
    }
    switch (m_ControllerScheme.GetSelectedIndex())
    {
        case 0:
            EPC.ControllerScheme = CS_Default;
            break;
        case 1:
            EPC.ControllerScheme = CS_Pandora;
            break;
        case 2:
            EPC.ControllerScheme = CS_PlayStation;
            break;
        case 3:
            EPC.ControllerScheme = CS_User;
        default:
            EPC.ControllerScheme = CS_Default;
            break;
    }
    switch (m_ControllerIcon.GetSelectedIndex())
    {
        case 0:
            EPC.ControllerIcon = CI_Xbox;
            break;
        case 1:
            EPC.ControllerIcon = CI_PlayStation;
            break;
        case 2:
            EPC.ControllerIcon = CI_GameCube;
            break;
        case 3:
            EPC.ControllerIcon = CI_None;
            break;
        default:
            EPC.ControllerIcon = CI_Xbox;
            break;
    }
    EPC.eGame.bEnableRumble = m_bEnableRumble.m_bSelected;
    
    // Reset all m_bDrawFlipped's
    for ( ListItem = m_ListBox.Items.Next; ListItem != None ; ListItem = ListItem.Next)
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

    if (m_bNormalizeMovement != None)
        m_bNormalizeMovement.m_bSelected = EPC.bNormalizeMovement;

    if (m_bCrouchDrop != None)
        m_bCrouchDrop.m_bSelected = EPC.bCrouchDrop;

    if (m_bToggleBTWTargeting != None)
        m_bToggleBTWTargeting.m_bSelected = EPC.bToggleBTWTargeting;

    if (m_bToggleInventory != None)
        m_bToggleInventory.m_bSelected = EPC.bToggleInventory;

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
    for ( ListItem = m_ListBox.Items.Next; ListItem != None ; ListItem = ListItem.Next)
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
    m_bNormalizeMovement.m_bSelected = true;
    m_bCrouchDrop.m_bSelected = true;
    m_bToggleBTWTargeting.m_bSelected = true;
    m_bToggleInventory.m_bSelected = false;
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
    NewItem.Caption			        = Localize("HUD","FIRETODRAWGUN","Localization\\HUD");
    NewItem.m_bIsNotSelectable  = true;

    m_FireEquipGun = EPCCheckBox(CreateControl( class'EPCCheckBox', 0, 0, 20, 18, self));    
    m_FireEquipGun.ImageX      = 5;
    m_FireEquipGun.ImageY      = 5;
    NewItem.m_Control = m_FireEquipGun;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_FireEquipGun;
}

//===============================================================================
// AddInitialSpeedControls
//===============================================================================
function AddInitialSpeedControls()
{
    // Joshua - Enhanced initial speed
    local EPCOptionsKeyListBoxItem NewItem;
    
    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Localize("Controls","InitialSpeed","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;
	
    m_InitialSpeedScroll = EPCHScrollBar(CreateControl( class'EPCHScrollBar', 0, 0, 150, LookAndFeel.Size_HScrollbarHeight, self));
    m_InitialSpeedScroll.SetScrollHeight(12);
    m_InitialSpeedScroll.SetRange(1, 6, 1);

    NewItem.m_Control = m_InitialSpeedScroll;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_InitialSpeedScroll;
}

//===============================================================================
// AddNormalizedMovementControls
//===============================================================================
function AddNormalizedMovementControls()
{
    // Joshua - Enhanced noramlized movement
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","NormalizedMovement","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_bNormalizeMovement = EPCCheckBox(CreateControl( class'EPCCheckBox', 0, 0, 20, 18, self));    
    m_bNormalizeMovement.ImageX      = 5;
    m_bNormalizeMovement.ImageY      = 5;
    NewItem.m_Control = m_bNormalizeMovement;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_bNormalizeMovement;
}

//===============================================================================
// AddCrouchDropControls
//===============================================================================
function AddCrouchDropControls()
{
    // Joshua - Enhanced noramlized movement
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","CrouchDrop","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_bCrouchDrop = EPCCheckBox(CreateControl( class'EPCCheckBox', 0, 0, 20, 18, self));    
    m_bCrouchDrop.ImageX      = 5;
    m_bCrouchDrop.ImageY      = 5;
    NewItem.m_Control = m_bCrouchDrop;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_bCrouchDrop;
}

//===============================================================================
// AddToggleBTWTargetingControls
//===============================================================================
function AddToggleBTWTargetingControls()
{
    // Joshua - Enhanced toggle back to wall targetting
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","ToggleBTWTargeting","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_bToggleBTWTargeting = EPCCheckBox(CreateControl( class'EPCCheckBox', 0, 0, 20, 18, self));    
    m_bToggleBTWTargeting.ImageX      = 5;
    m_bToggleBTWTargeting.ImageY      = 5;
    NewItem.m_Control = m_bToggleBTWTargeting;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_bToggleBTWTargeting;
}

//===============================================================================
// AddToggleInventoryControls
//===============================================================================
function AddToggleInventoryControls()
{
    // Joshua - Enhanced toggle inventory
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","ToggleInventory","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_bToggleInventory = EPCCheckBox(CreateControl( class'EPCCheckBox', 0, 0, 20, 18, self));    
    m_bToggleInventory.ImageX      = 5;
    m_bToggleInventory.ImageY      = 5;
    NewItem.m_Control = m_bToggleInventory;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_bToggleInventory;
}

//===============================================================================
// AddEnableRumbleControls
//===============================================================================
function AddEnableRumbleControls()
{
    // Joshua - Enhanced rumble
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","EnableRumble","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_bEnableRumble = EPCCheckBox(CreateControl( class'EPCCheckBox', 0, 0, 20, 18, self));    
    m_bEnableRumble.ImageX      = 5;
    m_bEnableRumble.ImageY      = 5;
    NewItem.m_Control = m_bEnableRumble;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_bEnableRumble;
}

//===============================================================================
// AddInputModeControls
//===============================================================================
function AddInputModeControls()
{
    // Joshua - Enhanced input mode
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","InputMode","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_InputMode = EPCComboControl(CreateControl( class'EPCComboControl', 265, 105, 150, 18, self));    
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
// AddControllerSchemeControls
//===============================================================================
function AddControllerSchemeControls()
{
    // Joshua - Enhanced input mode
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","ControllerScheme","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_ControllerScheme = EPCComboControl(CreateControl( class'EPCComboControl', 265, 105, 150, 18, self));    
    m_ControllerScheme.SetFont(F_Normal);
	m_ControllerScheme.SetEditable(False);
    m_ControllerScheme.AddItem(Localize("Controls","CS_Default","Localization\\Enhanced"));
	m_ControllerScheme.AddItem(Localize("Controls","CS_Pandora","Localization\\Enhanced"));
    m_ControllerScheme.AddItem(Localize("Controls","CS_PlayStation","Localization\\Enhanced"));
	m_ControllerScheme.SetSelectedIndex(0);

    NewItem.m_Control = m_ControllerScheme;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_ControllerScheme;
}

//===============================================================================
// AddControllerIconControls
//===============================================================================
function AddControllerIconControls()
{
    // Joshua - Enhanced controller icons
    local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("Controls","ControllerIcon","Localization\\Enhanced");
    NewItem.m_bIsNotSelectable  = true;

    m_ControllerIcon = EPCComboControl(CreateControl( class'EPCComboControl', 265, 105, 150, 18, self));    
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

    m_InvertMouseButton = EPCCheckBox(CreateControl( class'EPCCheckBox', 0, 0, 20, 18, self));    
    m_InvertMouseButton.ImageX      = 5;
    m_InvertMouseButton.ImageY      = 5;
    NewItem.m_Control = m_InvertMouseButton;
    NewItem.bIsCheckBoxLine = true;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = m_InvertMouseButton;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = Localize("HUD","MOUSESENSITIVITY","Localization\\HUD");
    NewItem.m_bIsNotSelectable  = true;       

    m_MouseSensitivityScroll   = EPCHScrollBar(CreateControl( class'EPCHScrollBar', 0, 0, 150, LookAndFeel.Size_HScrollbarHeight, self));
    m_MouseSensitivityScroll.SetScrollHeight(12);
    m_MouseSensitivityScroll.SetRange(1, 100, 1);

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
function AddKeyItem( string _szTitle, string _szActionKey)
{
	local EPCOptionsKeyListBoxItem NewItem;

    NewItem = EPCOptionsKeyListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption			        = _szTitle;
	NewItem.m_szActionKey			= _szActionKey;
	NewItem.HelpText	= GetLocKeyNameByActionKey( _szActionKey, false); // value to display "the key name"
    NewItem.HelpText2	= GetLocKeyNameByActionKey( _szActionKey, true); // value to display "the ALT key name"    
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

	for ( ListItem = m_ListBox.Items.Next; ListItem != None ; ListItem = ListItem.Next)
	{
		if (!EPCOptionsKeyListBoxItem(ListItem).m_bIsNotSelectable)	
        {
	        EPCOptionsKeyListBoxItem(ListItem).HelpText = GetLocKeyNameByActionKey(EPCOptionsKeyListBoxItem(ListItem).m_szActionKey, false);
            EPCOptionsKeyListBoxItem(ListItem).HelpText2 = GetLocKeyNameByActionKey(EPCOptionsKeyListBoxItem(ListItem).m_szActionKey, true);
        }		
	}     
	
    // MClarke - Patch 1 Beta 2 - Added bKeysOnly check 
    if(!bKeysOnly)
    {
        GO = class'Actor'.static.GetGameOptions();

        m_MouseSensitivityScroll.Pos = Clamp(GO.MouseSensitivity, 1,100);    

        // Joshua - Update value label for mouse sensitivity scrollbar
        if (m_LMouseSensitivityValue != None)
            m_LMouseSensitivityValue.SetLabelText(string(int(m_MouseSensitivityScroll.Pos)), TXT_LEFT);

        m_InvertMouseButton.m_bSelected = GO.InvertMouse;    
	    m_FireEquipGun.m_bSelected = GO.FireEquipGun;
        m_InitialSpeedScroll.Pos = Clamp(EPC.eGame.m_defautSpeed, 1,6);
        m_bNormalizeMovement.m_bSelected = EPC.bNormalizeMovement;
        m_bCrouchDrop.m_bSelected = EPC.bCrouchDrop;
        m_bToggleBTWTargeting.m_bSelected = EPC.bToggleBTWTargeting;
        m_bToggleInventory.m_bSelected = EPC.bToggleInventory;
        m_InputMode.SetSelectedIndex(Clamp(EPC.InputMode,0,m_InputMode.List.Items.Count()));
        m_ControllerScheme.SetSelectedIndex(Clamp(EPC.ControllerScheme,0,m_ControllerScheme.List.Items.Count()));
        m_ControllerIcon.SetSelectedIndex(Clamp(EPC.ControllerIcon,0,m_ControllerScheme.List.Items.Count()));
        m_bEnableRumble.m_bSelected = EPC.eGame.bEnableRumble;
    }
}

//===============================================================================
// GetLocKeyNameByActionKey: Get the localization name of the key to display
//===============================================================================
function string GetLocKeyNameByActionKey( string _szActionKey, bool bAltKey)
{
	local string szTemp;
	local BYTE Key;

	Key =    GetPlayerOwner().GetKey(_szActionKey, bAltKey);
	szTemp = GetPlayerOwner().GetEnumName( Key);
	szTemp = EPCConsole(Root.Console).ConvertKeyToLocalisation( Key, szTemp);

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
// AddTitleItem: Add a title item only
//===============================================================================
function AddTitleItem( string _szTitle)
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
function KeyPressed( int Key)
{
	local string szKeyName;
    local string szKeyToReplace;        // Tells whether we want to replace the primary or alt key
    local BYTE KeyOld;                  // Key which will be replaced
    local BYTE OtherKey;

    KeyOld = GetPlayerOwner().GetKey(EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_szActionKey, m_ListBox.m_bDoingAltMapping);
    OtherKey = GetPlayerOwner().GetKey(EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_szActionKey, !m_ListBox.m_bDoingAltMapping);
	szKeyToReplace = GetPlayerOwner().GetEnumName( KeyOld);

	// set the key and refresh the list
	szKeyName = GetPlayerOwner().GetEnumName(Key);

    if((OtherKey != 0) && (m_ListBox.m_bDoingAltMapping == (Key < OtherKey)))
    {
        EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped = !EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;  
    }
    else
    {
        EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped = EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;
    }
	
	GetPlayerOwner().SetKey( szKeyName@ EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_szActionKey, szKeyToReplace);
	
    // MClarke - Patch 1 Beta 2 - Added true parameter 
    RefreshKeyList(true);
}

//==============================================================================
// KeyDown - Handler for a key pressed, passes stuff to KeyPressed, if valid
//==============================================================================
function KeyDown(int Key, float X, float Y)
{
	//local string szTemp, szKeyName;

	if(m_MessageBox != None)
    {
		// set the key and refresh the list
		//szKeyName = GetPlayerOwner().GetEnumName(Key);
		
		//validates the windows key:
		//szTemp = Caps(Left(szKeyName, 7));
		
		// No joystick/gamepad support for the PC version
		if( Key >= 196 && Key <= 215 ) return;

        // Joshua - Prevent binding Windows left (92) and Windows right (93)
        If( Key == 92 || Key == 93 ) return;

        // Joshua - Allow binding unknown keys (used for Mouse 4 / Mouse 5)
		//if(szTemp == "UNKNOWN") return;
		
		if(Key != GetPlayerOwner().Player.Console.EInputKey.IK_Escape)
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
	if(m_MessageBox != None)
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
    if(m_MessageBox != None)
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
	if(m_MessageBox != None)
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
	if(m_MessageBox != None)
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
	if(m_MessageBox != None)
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
        
    if(E == DE_DoubleClick && C == m_ListBox && m_ListBox.SelectedItem != None)
    {    
        GetMouseXY(iMouseX, iMouseY);

        // Now we want to know whether primary or alternate config has been selected
        if((iMouseX - ((m_ListBox.WinWidth / 2) -  fOffsetFromMiddle)) > (m_ListBox.m_IHighLightWidth / 1.4) )
        {
            m_ListBox.m_bDoingAltMapping = !EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;           
        }
        else
        {
            m_ListBox.m_bDoingAltMapping = EPCOptionsKeyListBoxItem(m_ListBox.SelectedItem).m_bDrawFlipped;
        }

        m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","MAPKEYTITLE","Localization\\HUD"), Localize("OPTIONS","MAPKEYMESSAGE","Localization\\HUD"), MB_Cancel, MR_Cancel, MR_None, true);                
    }
    else if(E==DE_Click && C == m_InvertMouseButton)
    {
        m_bModified = true;
    }
    else if(E==DE_Click && C == m_FireEquipGun)
    {
        m_bModified = true;
    }
    else if(E == DE_Change && C == m_MouseSensitivityScroll)
    {
        m_bModified = true;
        // Joshua - Update value label for mouse sensitivity scrollbar
        if (m_LMouseSensitivityValue != None)
            m_LMouseSensitivityValue.SetLabelText(string(int(m_MouseSensitivityScroll.Pos)), TXT_LEFT);
    }
    else if(E == DE_Change && C == m_InitialSpeedScroll)
    {
        m_bModified = true;
    }
    else if(E==DE_Click && C == m_bNormalizeMovement)
    {
        m_bModified = true;
    }
    else if(E==DE_Click && C == m_bCrouchDrop)
    {
        m_bModified = true;
    }
    else if(E==DE_Click && C == m_bToggleBTWTargeting)
    {
        m_bModified = true;
    }
    else if(E==DE_Click && C == m_bToggleInventory)
    {
        m_bModified = true;
    }
    else if(E==DE_Change && C == m_InputMode)
    {
        m_bModified = true;
    }
    else if(E==DE_Change && C == m_ControllerScheme)
    {
        m_bModified = true;
    }
    else if(E==DE_Change && C == m_ControllerIcon)
    {
        m_bModified = true;
    }
    else if(E==DE_Click && C == m_bEnableRumble)
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
