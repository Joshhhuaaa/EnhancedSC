//=============================================================================
//  EPCEnhancedConfigArea.uc : Area containing controls for Enhanced settings
//  Created by Joshua
//=============================================================================
class EPCEnhancedConfigArea extends UWindowDialogClientWindow
    config(Enhanced);

var EPCEnhancedListBox      m_ListBox;

//=============================================================================
// General
//=============================================================================
// Native
var EPCCheckBox             m_bCheckForUpdates,
                            m_bSkipIntroVideos,
                            m_bDisableMenuIdleTimer;

var EPCComboControl         m_LevelUnlock;

//=============================================================================
// Gameplay
//=============================================================================
var EPCCheckBox             m_bWhistle,
                            m_bNewDoorInteraction,
                            m_bInteractionPause,
                            m_bQuickDataView,
                            m_bEnableCheckpoints,
                            m_bMissionFailedQuickMenu,
                            m_bXboxDifficulty;

var EPCComboControl         m_PlayerStatsMode;

//=============================================================================
// Equipment
//=============================================================================
var EPCCheckBox             m_bBinoculars,
                            m_bF2000BurstFire,
                            m_bPS2FN7Accuracy,
                            m_bF2000ZoomLevels,
                            m_bLaserMicZoomLevels,
                            m_bLaserMicVisions,
                            m_bOpticCableVisions,
                            m_bThermalOverride,
                            //m_bSwitchCam,
                            m_bRandomizeLockpick,
                            m_bScaleGadgetDamage;

var EPCComboControl         m_MineDelay;

//=============================================================================
// HUD Settings
//=============================================================================
var EPCCheckBox             m_bPersistentHUD,
                            m_bHorizontalLifeBar,
                            m_bInvertInteractionList,
                            m_bLetterBoxCinematics;

// Native
var EPCComboControl         m_FontType;
var EPCComboControl         m_CrosshairStyle;

//=============================================================================
// HUD Visibility
//=============================================================================
var EPCCheckBox             m_bShowHUD,
                            m_bShowLifeBar,
                            m_bShowInteractionBox,
                            m_bShowCommunicationBox,
                            m_bShowTimer,
                            m_bShowInventory,
                            m_bShowStealthMeter,
                            m_bShowCurrentGoal,
                            m_bShowKeypadGoal,
                            m_bShowCurrentGadget,
                            m_bShowMissionInformation,
                            m_bShowCrosshair,
                            m_bShowScope,
                            m_bShowAlarms;

//=============================================================================
// Suits
//=============================================================================
var EPCComboControl         m_TrainingSamMesh,
                            m_TbilisiSamMesh,
                            m_DefenseMinistrySamMesh,
                            m_CaspianOilRefinerySamMesh,
                            m_CIASamMesh,
                            m_KalinatekSamMesh,
                            m_ChineseEmbassySamMesh,
                            m_AbattoirSamMesh,
                            m_ChineseEmbassy2SamMesh,
                            m_PresidentialPalaceSamMesh,
                            m_KolaCellSamMesh,
                            m_VselkaSamMesh,
                            m_PowerPlantSamMesh,
                            m_SeveronickelSamMesh;

var bool    m_bModified;
var bool	m_bFirstRefresh;

// Original values for settings that require restart
var bool    m_bOriginalCheckForUpdates;
var bool    m_bOriginalSkipIntroVideos;
var bool    m_bOriginalDisableMenuIdleTimer;

// Joshua - Controller navigation
var bool    m_bEnableArea;           // True when area is active for controller navigation
var int     m_selectedItemIndex;     // Currently selected item index
var bool    m_bComboBoxOpen;         // True when a combo box is open for selection
var EPCComboControl m_ActiveCombo;   // Currently focused combo box

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

// Tooltip persistence
var(Enhanced) config array<string> ViewedTooltips;

// Shared info button pulse animation state
var float InfoButtonPulseTimer;
var bool bInfoButtonPulseIncreasing;

function Created()
{
    SetAcceptsFocus();

    m_ListBox = EPCEnhancedListBox(CreateWindow(class'EPCEnhancedListBox', 0, 0, WinWidth, WinHeight));
    m_ListBox.SetAcceptsFocus();
    m_ListBox.TitleFont = F_Normal;

    // Initialize pulse animation
    InfoButtonPulseTimer = 0.0;
    bInfoButtonPulseIncreasing = true;

    InitEnhancedSettings();
}

function BeforePaint(Canvas C, float X, float Y)
{
    Super.BeforePaint(C, X, Y);

    // Joshua - Check if combo box was closed externally (by list handling its own input)
    if (m_bComboBoxOpen && m_ActiveCombo != None && !m_ActiveCombo.bListVisible)
    {
        // Combo was closed by the combo list itself
        m_bComboBoxOpen = false;
        m_ActiveCombo = None;
    }
}

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

function InitEnhancedSettings()
{
    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_General", "Localization\\Enhanced")));
    AddLineItem();

    AddCheckBoxItem("CheckForUpdates", m_bCheckForUpdates);
    AddCheckBoxItem("SkipIntroVideos", m_bSkipIntroVideos);
    AddCheckBoxItem("DisableMenuIdleTimer", m_bDisableMenuIdleTimer);
    AddCompactLineItem();
    AddComboBoxItem("LevelUnlock", m_LevelUnlock);
    AddLevelUnlockCombo(m_LevelUnlock);

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_Gameplay", "Localization\\Enhanced")));
    AddLineItem();

    AddCheckBoxItem("Whistle", m_bWhistle);
    AddCheckBoxItemWithInfo("NewDoorInteraction", m_bNewDoorInteraction);
    AddCheckBoxItem("InteractionPause", m_bInteractionPause);
    AddCheckBoxItemWithInfo("QuickDataView", m_bQuickDataView);
    AddCheckBoxItem("EnableCheckpoints", m_bEnableCheckpoints);
    AddCheckBoxItemWithInfo("MissionFailedQuickMenu", m_bMissionFailedQuickMenu);
    AddCheckBoxItemWithInfo("XboxDifficulty", m_bXboxDifficulty);

    AddCompactLineItem();
    AddComboBoxItemWithInfo("PlayerStatsMode", m_PlayerStatsMode);
    AddPlayerStatsModeCombo(m_PlayerStatsMode);

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_Equipment", "Localization\\Enhanced")));
    AddLineItem();


    AddCheckBoxItem("Binoculars", m_bBinoculars);
    AddCheckBoxItem("F2000BurstFire", m_bF2000BurstFire);
    AddCheckBoxItemWithInfo("PS2FN7Accuracy", m_bPS2FN7Accuracy);
    AddCheckBoxItem("F2000ZoomLevels", m_bF2000ZoomLevels);
    AddCheckBoxItem("LaserMicZoomLevels", m_bLaserMicZoomLevels);
    AddCheckBoxItem("LaserMicVisions", m_bLaserMicVisions);
    AddCheckBoxItem("OpticCableVisions", m_bOpticCableVisions);
    AddCheckBoxItemWithInfo("ThermalOverride", m_bThermalOverride);
    //AddCheckBoxItemWithInfo("SwitchCam", m_bSwitchCam);
    AddCheckBoxItem("RandomizeLockpick", m_bRandomizeLockpick);
    AddCheckBoxItemWithInfo("ScaleGadgetDamage", m_bScaleGadgetDamage);

    AddCompactLineItem();
    AddComboBoxItem("MineDelay", m_MineDelay);
    AddMineDelayCombo(m_MineDelay);

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_HUDSettings", "Localization\\Enhanced")));
    AddLineItem();

    AddCheckBoxItemWithInfo("PersistentHUD", m_bPersistentHUD);
    AddCheckBoxItem("HorizontalLifeBar", m_bHorizontalLifeBar);
    AddCheckBoxItem("InvertInteractionList", m_bInvertInteractionList);
    AddCheckBoxItem("LetterBoxCinematics", m_bLetterBoxCinematics);

    AddCompactLineItem();
    AddComboBoxItem("FontType", m_FontType);
    AddFontTypeCombo(m_FontType);

    AddCompactLineItem();
    AddComboBoxItem("CrosshairStyle", m_CrosshairStyle);
    AddCrosshairStyleCombo(m_CrosshairStyle);

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_HUDVisibility", "Localization\\Enhanced")));
    AddLineItem();

    AddCheckBoxItem("ShowHUD", m_bShowHUD);
    AddCheckBoxItem("ShowLifeBar", m_bShowLifeBar);
    AddCheckBoxItem("ShowInteractionBox", m_bShowInteractionBox);
    AddCheckBoxItem("ShowCommunicationBox", m_bShowCommunicationBox);
    AddCheckBoxItem("ShowTimer", m_bShowTimer);
    AddCheckBoxItem("ShowInventory", m_bShowInventory);
    AddCheckBoxItem("ShowStealthMeter", m_bShowStealthMeter);
    AddCheckBoxItem("ShowCurrentGoal", m_bShowCurrentGoal);
    AddCheckBoxItemWithInfo("ShowKeypadGoal", m_bShowKeypadGoal);
    AddCheckBoxItemWithInfo("ShowCurrentGadget", m_bShowCurrentGadget);
    AddCheckBoxItemWithInfo("ShowMissionInformation", m_bShowMissionInformation);
    AddCheckBoxItem("ShowCrosshair", m_bShowCrosshair);
    AddCheckBoxItem("ShowScope", m_bShowScope);
    AddCheckBoxItem("ShowAlarms", m_bShowAlarms);
    AddLineItem();

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_Suit", "Localization\\Enhanced")));
    AddLineItem();

    AddComboBoxItem("TrainingSamMesh", m_TrainingSamMesh);
    AddSamMeshCombo(m_TrainingSamMesh, 0);
    AddCompactLineItem();

    AddComboBoxItem("TbilisiSamMesh", m_TbilisiSamMesh);
    AddSamMeshCombo(m_TbilisiSamMesh, 0);
    AddCompactLineItem();

    AddComboBoxItem("DefenseMinistrySamMesh", m_DefenseMinistrySamMesh);
    AddSamMeshCombo(m_DefenseMinistrySamMesh, 0);
    AddCompactLineItem();

    AddComboBoxItem("CaspianOilRefinerySamMesh", m_CaspianOilRefinerySamMesh);
    AddSamMeshCombo(m_CaspianOilRefinerySamMesh, 2);
    AddCompactLineItem();

    AddComboBoxItem("CIASamMesh", m_CIASamMesh);
    AddSamMeshCombo(m_CIASamMesh, 1);
    AddCompactLineItem();

    AddComboBoxItem("KalinatekSamMesh", m_KalinatekSamMesh);
    AddSamMeshCombo(m_KalinatekSamMesh, 0);
    AddCompactLineItem();

    AddComboBoxItem("ChineseEmbassySamMesh", m_ChineseEmbassySamMesh);
    AddSamMeshCombo(m_ChineseEmbassySamMesh, 2);
    AddCompactLineItem();

    AddComboBoxItem("AbattoirSamMesh", m_AbattoirSamMesh);
    AddSamMeshCombo(m_AbattoirSamMesh, 2);
    AddCompactLineItem();

    AddComboBoxItem("ChineseEmbassy2SamMesh", m_ChineseEmbassy2SamMesh);
    AddSamMeshCombo(m_ChineseEmbassy2SamMesh, 2);
    AddCompactLineItem();

    AddComboBoxItem("PresidentialPalaceSamMesh", m_PresidentialPalaceSamMesh);
    AddSamMeshCombo(m_PresidentialPalaceSamMesh, 1);
    AddCompactLineItem();

    AddComboBoxItem("KolaCellSamMesh", m_KolaCellSamMesh);
    AddSamMeshCombo(m_KolaCellSamMesh, 0);
    AddCompactLineItem();

    AddComboBoxItem("VselkaSamMesh", m_VselkaSamMesh);
    AddSamMeshCombo(m_VselkaSamMesh, 1);
    AddCompactLineItem();

    AddComboBoxItem("PowerPlantSamMesh", m_PowerPlantSamMesh);
    AddSamMeshCombo(m_PowerPlantSamMesh, 0);
    AddCompactLineItem();

    AddComboBoxItem("SeveronickelSamMesh", m_SeveronickelSamMesh);
    AddSamMeshCombo(m_SeveronickelSamMesh, 0);
}

function AddCheckBoxItem(string LocalizationKey, out EPCCheckBox CheckBox)
{
    local EPCEnhancedListBoxItem NewItem;

    CheckBox = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18));
    CheckBox.ImageX = 5;
    CheckBox.ImageY = 5;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("Enhanced", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_Control = CheckBox;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = CheckBox;
}

function AddCheckBoxItemWithInfo(string LocalizationKey, out EPCCheckBox CheckBox)
{
    local EPCEnhancedListBoxItem NewItem;
    local EPCInfoButton InfoBtn;
    local string InfoText;

    CheckBox = EPCCheckBox(CreateControl(class'EPCCheckBox', 0, 0, 20, 18));
    CheckBox.ImageX = 5;
    CheckBox.ImageY = 5;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("Enhanced", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_Control = CheckBox;
    NewItem.m_bIsNotSelectable = true;

    // Create info button
    InfoText = Localize("Enhanced", LocalizationKey $ "_Desc", "Localization\\Enhanced");
    if (InfoText != "" && InfoText != (LocalizationKey $ "_Desc"))
    {
        InfoBtn = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16));
        InfoBtn.InfoText = InfoText;
        InfoBtn.SettingName = NewItem.Caption; // Use the localized setting name as title
        InfoBtn.LocalizationKey = LocalizationKey; // Store key for persistence
        InfoBtn.bStopPulsing = HasViewedTooltip(LocalizationKey); // Don't pulse if already viewed
        NewItem.m_InfoButton = InfoBtn;
    }

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = CheckBox;
}

function AddComboBoxItem(string LocalizationKey, out EPCComboControl ComboBox)
{
    local EPCEnhancedListBoxItem NewItem;

    ComboBox = EPCComboControl(CreateControl(class'EPCComboControl', 0, 0, 150, 18));
    ComboBox.SetFont(F_Normal);
    ComboBox.SetEditable(False);

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("Enhanced", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_Control = ComboBox;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ComboBox;
}

function AddComboBoxItemWithInfo(string LocalizationKey, out EPCComboControl ComboBox)
{
    local EPCEnhancedListBoxItem NewItem;
    local EPCInfoButton InfoBtn;
    local string InfoText;

    ComboBox = EPCComboControl(CreateControl(class'EPCComboControl', 0, 0, 150, 18));
    ComboBox.SetFont(F_Normal);
    ComboBox.SetEditable(False);

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("Enhanced", LocalizationKey, "Localization\\Enhanced");
    NewItem.m_Control = ComboBox;
    NewItem.m_bIsNotSelectable = true;

    // Create info button
    InfoText = Localize("Enhanced", LocalizationKey $ "_Desc", "Localization\\Enhanced");
    if (InfoText != "" && InfoText != (LocalizationKey $ "_Desc"))
    {
        InfoBtn = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16));
        InfoBtn.InfoText = InfoText;
        InfoBtn.SettingName = NewItem.Caption; // Use the localized setting name as title
        InfoBtn.LocalizationKey = LocalizationKey; // Store key for persistence
        InfoBtn.bStopPulsing = HasViewedTooltip(LocalizationKey); // Don't pulse if already viewed
        NewItem.m_InfoButton = InfoBtn;
    }

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ComboBox;
}

function AddTitleItem(string Title)
{
    local EPCEnhancedListBoxItem NewItem;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Title;
    NewItem.m_bIsTitle = true;
    NewItem.m_bIsNotSelectable = true;
    NewItem.m_TextColor.R = 51; // Darker color for titles
    NewItem.m_TextColor.G = 51;
    NewItem.m_TextColor.B = 51;
    NewItem.m_TextColor.A = 255;
}

function AddLineItem()
{
    local EPCEnhancedListBoxItem NewItem;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.bIsLine = true;
    NewItem.m_bIsNotSelectable = true;
}

function AddCompactLineItem()
{
    local EPCEnhancedListBoxItem NewItem;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.bIsCompactLine = true;
    NewItem.m_bIsNotSelectable = true;
}

function AddLevelUnlockCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced","LevelUnlock_Disabled","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced","LevelUnlock_Enabled","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced","LevelUnlock_AllParts","Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function AddPlayerStatsModeCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced", "PlayerStatsMode_Disabled", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "PlayerStatsMode_Ghost", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "PlayerStatsMode_Stealth", "Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(1); // Default to Ghost
}

function AddMineDelayCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced","MineDelay_Default","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced","MineDelay_Enhanced","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced","MineDelay_Instant","Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function AddFontTypeCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced", "FontType_PC", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "FontType_Xbox", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "FontType_GameCube", "Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(1); // Default to Xbox
}

function AddCrosshairStyleCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced", "CrosshairStyle_Original", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "CrosshairStyle_Beta", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "CrosshairStyle_PS2", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "CrosshairStyle_SCCT", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "CrosshairStyle_PS3", "Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function AddSamMeshCombo(EPCComboControl ComboBox, int SamMeshType)
{
    ComboBox.AddItem(Localize("Enhanced", "SamMesh_Default", "Localization\\Enhanced"));
    if (SamMeshType != 0)
        ComboBox.AddItem(Localize("Enhanced", "SamMesh_Standard", "Localization\\Enhanced"));
    if (SamMeshType != 1)
        ComboBox.AddItem(Localize("Enhanced", "SamMesh_Balaclava", "Localization\\Enhanced"));
    if (SamMeshType != 2)
        ComboBox.AddItem(Localize("Enhanced", "SamMesh_PartialSleeves", "Localization\\Enhanced"));
    if (SamMeshType != 3)
        ComboBox.AddItem(Localize("Enhanced", "SamMesh_BetaStandard", "Localization\\Enhanced"));
    if (SamMeshType != 4)
        ComboBox.AddItem(Localize("Enhanced", "SamMesh_WhiteBalaclava", "Localization\\Enhanced"));
    if (SamMeshType != 5)
        ComboBox.AddItem(Localize("Enhanced", "SamMesh_BetaSleeves", "Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

// Converts combo box index to SamMeshType enum, accounting for the skipped default suit
function EchelonGameInfo.ESamMeshType GetSamMeshEnumFromIndex(int ComboIndex, int SamMeshType)
{
    local int EnumValue;
    local int SkippedEnum;

    // Index 0 is always SMT_Default
    if (ComboIndex == 0)
        return SMT_Default;

    SkippedEnum = SamMeshType + 1;

    EnumValue = ComboIndex;

    // If we're at or past the skipped enum value, add 1 to compensate
    if (EnumValue >= SkippedEnum)
        EnumValue += 1;

    switch (EnumValue)
    {
        case 0: return SMT_Default;
        case 1: return SMT_Standard;
        case 2: return SMT_Balaclava;
        case 3: return SMT_PartialSleeves;
        case 4: return SMT_BetaStandard;
        case 5: return SMT_WhiteBalaclava;
        case 6: return SMT_BetaSleeves;
        default: return SMT_Default;
    }
}

// Converts SamMeshType enum value to combo box index, accounting for the skipped default suit
function int GetIndexFromSamMeshEnum(int EnumValue, int SamMeshType)
{
    local int SkippedEnum;

    if (EnumValue == 0)
        return 0;

    SkippedEnum = SamMeshType + 1;

    // If enum value equals the skipped type, it shouldn't happen but return 0 (default)
    if (EnumValue == SkippedEnum)
        return 0;

    // If the enum value is greater than the skipped type, subtract 1
    if (EnumValue > SkippedEnum)
        return EnumValue - 1;

    return EnumValue;
}

function Notify(UWindowDialogControl C, byte E)
{
    if (E == DE_Click)
    {
        switch (C)
        {
            //=============================================================================
            // General
            //=============================================================================
            case m_bCheckForUpdates:
                if (m_bCheckForUpdates.m_bSelected != m_bOriginalCheckForUpdates)
                {
                    // Stop any auto-scrolling when opening restart required messagebox
                    m_heldKey = 0;
                    m_keyHoldTime = 0;
                    m_nextRepeatTime = 0;
                    EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "RestartRequired", "Localization\\Enhanced"), Localize("Common", "RestartRequiredWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);
                }
                m_bModified = true;
                break;
            case m_bSkipIntroVideos:
                if (m_bSkipIntroVideos.m_bSelected != m_bOriginalSkipIntroVideos)
                {
                    // Stop any auto-scrolling when opening restart required messagebox
                    m_heldKey = 0;
                    m_keyHoldTime = 0;
                    m_nextRepeatTime = 0;
                    EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "RestartRequired", "Localization\\Enhanced"), Localize("Common", "RestartRequiredWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);
                }
                m_bModified = true;
                break;
            case m_bDisableMenuIdleTimer:
                if (m_bDisableMenuIdleTimer.m_bSelected != m_bOriginalDisableMenuIdleTimer)
                {
                    // Stop any auto-scrolling when opening restart required messagebox
                    m_heldKey = 0;
                    m_keyHoldTime = 0;
                    m_nextRepeatTime = 0;
                    EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "RestartRequired", "Localization\\Enhanced"), Localize("Common", "RestartRequiredWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);
                }
                m_bModified = true;
                break;

            //=============================================================================
            // Gameplay
            //=============================================================================
            case m_bWhistle:
            case m_bNewDoorInteraction:
            case m_bInteractionPause:
            case m_bQuickDataView:
            case m_bEnableCheckpoints:
            case m_bMissionFailedQuickMenu:
            case m_bXboxDifficulty:
                m_bModified = true;
                break;

            //=============================================================================
            // Equipment
            //=============================================================================
            case m_bBinoculars:
            case m_bF2000BurstFire:
            case m_bPS2FN7Accuracy:
            case m_bF2000ZoomLevels:
            case m_bLaserMicZoomLevels:
            case m_bLaserMicVisions:
            case m_bOpticCableVisions:
            //case m_bSwitchCam:
            case m_bThermalOverride:
            case m_bRandomizeLockpick:
            case m_bScaleGadgetDamage:
                m_bModified = true;
                break;

            //=============================================================================
            // HUD Settings
            //=============================================================================
            case m_bPersistentHUD:
            case m_bHorizontalLifeBar:
            case m_bInvertInteractionList:
            case m_bLetterBoxCinematics:
                m_bModified = true;
                break;

            //=============================================================================
            // HUD Visibility
            //=============================================================================
            case m_bShowHUD:
            case m_bShowLifeBar:
            case m_bShowInteractionBox:
            case m_bShowCommunicationBox:
            case m_bShowTimer:
            case m_bShowInventory:
            case m_bShowStealthMeter:
            case m_bShowCurrentGoal: // If current goal is disabled, disable keypad goal and current gadget
                if (C == m_bShowCurrentGoal)
                {
                    if (!m_bShowCurrentGoal.m_bSelected)
                    {
                        m_bShowKeypadGoal.bDisabled = true;
                        m_bShowCurrentGadget.bDisabled = true;
                    }
                    else
                    {
                        m_bShowKeypadGoal.bDisabled = false;
                        m_bShowCurrentGadget.bDisabled = false;
                    }
                }
                m_bModified = true;
                break;
            case m_bShowKeypadGoal:
            case m_bShowCurrentGadget:
            case m_bShowMissionInformation:
            case m_bShowCrosshair:
            case m_bShowScope:
            case m_bShowAlarms:
                m_bModified = true;
                break;
        }
    }
    else if (E == DE_Change)
    {
        switch (C)
        {
            //=============================================================================
            // General
            //=============================================================================
            case m_LevelUnlock:
                m_bModified = true;
                break;

            //=============================================================================
            // Gameplay
            //=============================================================================
            case m_PlayerStatsMode:
                m_bModified = true;
                break;

            //=============================================================================
            // Equipment
            //=============================================================================
            case m_MineDelay:
                m_bModified = true;
                break;

            //=============================================================================
            // HUD Settings
            //=============================================================================
            case m_FontType:
            case m_CrosshairStyle:
                m_bModified = true;
                break;

            //=============================================================================
            // Suits
            //=============================================================================
            case m_TrainingSamMesh:
            case m_TbilisiSamMesh:
            case m_DefenseMinistrySamMesh:
            case m_CaspianOilRefinerySamMesh:
            case m_CIASamMesh:
            case m_KalinatekSamMesh:
            case m_ChineseEmbassySamMesh:
            case m_AbattoirSamMesh:
            case m_ChineseEmbassy2SamMesh:
            case m_PresidentialPalaceSamMesh:
            case m_KolaCellSamMesh:
            case m_VselkaSamMesh:
            case m_PowerPlantSamMesh:
            case m_SeveronickelSamMesh:
                m_bModified = true;
                break;
        }
    }
}

function SaveOptions()
{
    local EPlayerController EPC;
    local EchelonMainHUD HUD;

    local EF2000 F2000;
    local EGoggle Goggle;
    local ELaserMic LaserMic;
    local Actor CamController;

    local bool bPreviousF2000ZoomLevels;
    local bool bPreviousLaserMicZoomLevels;
    local bool bPreviousLaserMicVisions;
    local bool bPreviousBurstFire;
    local bool bPreviousNewDoorInteraction;
    local bool bPreviousOpticCableVisions;

    EPC = EPlayerController(GetPlayerOwner());
    HUD = EchelonMainHUD(EPC.myHUD);

    bPreviousF2000ZoomLevels = EPC.bF2000ZoomLevels;
    bPreviousLaserMicZoomLevels = EPC.bLaserMicZoomLevels;
    bPreviousLaserMicVisions = EPC.bLaserMicVisions;
    bPreviousBurstFire = EPC.bF2000BurstFire;
    bPreviousNewDoorInteraction = EPC.eGame.bNewDoorInteraction;
    bPreviousOpticCableVisions = EPC.bOpticCableVisions;

	//=============================================================================
	// General
	//=============================================================================
    EPC.eGame.bCheckForUpdates = m_bCheckForUpdates.m_bSelected;
    EPC.eGame.bSkipIntroVideos = m_bSkipIntroVideos.m_bSelected;
    EPC.eGame.bDisableMenuIdleTimer = m_bDisableMenuIdleTimer.m_bSelected;

    switch (m_LevelUnlock.GetSelectedIndex())
    {
        case 0: EPC.playerInfo.LevelUnlock = LU_Disabled; break;
        case 1: EPC.playerInfo.LevelUnlock = LU_Enabled; break;
        case 2: EPC.playerInfo.LevelUnlock = LU_AllParts; break;
        default: EPC.playerInfo.LevelUnlock = LU_Disabled; break;
    }

	//=============================================================================
	// Gameplay
	//=============================================================================
    EPC.bWhistle = m_bWhistle.m_bSelected;
    EPC.eGame.bNewDoorInteraction = m_bNewDoorInteraction.m_bSelected;

    if (bPreviousNewDoorInteraction != EPC.eGame.bNewDoorInteraction)
    {
        RefreshCurrentDoorInteraction(EPC);
    }

    EPC.bInteractionPause = m_bInteractionPause.m_bSelected;
    EPC.bQuickDataView = m_bQuickDataView.m_bSelected;
    EPC.eGame.bEnableCheckpoints = m_bEnableCheckpoints.m_bSelected;
    EPC.bMissionFailedQuickMenu = m_bMissionFailedQuickMenu.m_bSelected;
    EPC.eGame.bXboxDifficulty = m_bXboxDifficulty.m_bSelected;

    switch (m_PlayerStatsMode.GetSelectedIndex())
    {
        case 0: EPC.PlayerStatsMode = SM_Disabled; break;
        case 1: EPC.PlayerStatsMode = SM_Ghost; break;
        case 2: EPC.PlayerStatsMode = SM_Stealth; break;
        default: EPC.PlayerStatsMode = SM_Ghost; break;
    }

	//=============================================================================
	// Equipment
	//=============================================================================
    EPC.bBinoculars = m_bBinoculars.m_bSelected;

    EPC.bF2000BurstFire = m_bF2000BurstFire.m_bSelected;
    if (bPreviousBurstFire && !EPC.bF2000BurstFire)
    {
        if (EPC.MainGun != None)
        {
            F2000 = EF2000(EPC.MainGun);
            if (F2000 != None)
            {
                F2000.ValidateROFMode();
            }
        }
    }


    EPC.eGame.bPS2FN7Accuracy = m_bPS2FN7Accuracy.m_bSelected;
    if (EPC.HandGun != None)
    {
        if (EPC.eGame.bPS2FN7Accuracy && !EPC.eGame.bEliteMode)
        {
            EPC.HandGun.AccuracyMovementModifier = 3.330000;
            EPC.HandGun.AccuracyBase = 0.330000;
        }
        else
        {
            EPC.HandGun.AccuracyMovementModifier = EPC.HandGun.default.AccuracyMovementModifier;
            EPC.HandGun.AccuracyBase = EPC.HandGun.default.AccuracyBase;
        }
    }

    EPC.bF2000ZoomLevels = m_bF2000ZoomLevels.m_bSelected;
    if (bPreviousF2000ZoomLevels && !EPC.bF2000ZoomLevels)
    {
        if (EPC.MainGun != None)
        {
            F2000 = EF2000(EPC.MainGun);
            if (F2000 != None)
            {
                F2000.ValidateZoomLevel();

                if (EPC.ActiveGun == EPC.MainGun && F2000.bSniperMode)
                {
                    EPC.SetCameraFOV(EPC, F2000.GetZoom());
                }
            }
        }
    }

    EPC.bLaserMicZoomLevels = m_bLaserMicZoomLevels.m_bSelected;
    EPC.bLaserMicVisions = m_bLaserMicVisions.m_bSelected;

    // Handle laser mic settings changes while actively using it
    if (EPC.GetStateName() == 's_LaserMicTargeting' && EPC.ePawn.HandItem != None && EPC.ePawn.HandItem.IsA('ELaserMic'))
    {
        LaserMic = ELaserMic(EPC.ePawn.HandItem);

        // Determine the camera controller based on vision setting
        if (EPC.bLaserMicVisions)
            CamController = EPC;
        else
            CamController = LaserMic;

        // Handle vision mode toggle
        if (bPreviousLaserMicVisions != EPC.bLaserMicVisions)
        {
            if (bPreviousLaserMicVisions)
            {
                EPC.SetCameraFOV(LaserMic, LaserMic.current_fov);
            }
            else
            {
                EPC.PopCamera(LaserMic);
                EPC.SetCameraFOV(EPC, LaserMic.current_fov);
            }
        }

        // Handle zoom levels being disabled, reset to 30 FOV if needed
        if (bPreviousLaserMicZoomLevels && !EPC.bLaserMicZoomLevels)
        {
            LaserMic.current_fov = 30.0;
            EPC.SetCameraFOV(CamController, 30.0);
        }
    }

    EPC.bOpticCableVisions = m_bOpticCableVisions.m_bSelected;
    if (EPC.GetStateName() == 's_OpticCable' && (bPreviousOpticCableVisions != EPC.bOpticCableVisions))
    {
        if (EPC.OpticCableItem != None)
        {
            if (bPreviousOpticCableVisions)
                Epc.SetCameraMode(Epc.OpticCableItem, 11); // REN_NightVision = 11
            else
                Epc.PopCamera(Epc.OpticCableItem);
        }
    }

    //EPC.bSwitchCam = m_bSwitchCam.m_bSelected;

    EPC.eGame.bThermalOverride = m_bThermalOverride.m_bSelected;
    if (EPC.Goggle != None && !EPC.eGame.bEliteMode)
    {
        if (EchelonPlayerStart(EPC.StartSpot).bNoThermalAvailable)
            EPC.Goggle.bNoThermalAvailable = !m_bThermalOverride.m_bSelected;
        else
            EPC.Goggle.bNoThermalAvailable = false;
    }

    EPC.eGame.bRandomizeLockpick = m_bRandomizeLockpick.m_bSelected;
    EPC.eGame.bScaleGadgetDamage = m_bScaleGadgetDamage.m_bSelected;

    switch (m_MineDelay.GetSelectedIndex())
    {
        case 0: EPC.eGame.WallMineDelay = WMD_Default; break;
        case 1: EPC.eGame.WallMineDelay = WMD_Enhanced; break;
        case 2: EPC.eGame.WallMineDelay = WMD_Instant; break;
        default: EPC.eGame.WallMineDelay = WMD_Default; break;
    }

	//=============================================================================
	// HUD Settings
	//=============================================================================
    EPC.bPersistentHUD = m_bPersistentHUD.m_bSelected;
    EPC.bHorizontalLifeBar = m_bHorizontalLifeBar.m_bSelected;
    EPC.bInvertInteractionList = m_bInvertInteractionList.m_bSelected;
    HUD.bLetterBoxCinematics = m_bLetterBoxCinematics.m_bSelected;

    switch (m_FontType.GetSelectedIndex())
    {
        case 0: EPC.eGame.FontType = Font_PC; break;
        case 1: EPC.eGame.FontType = Font_Xbox; break;
        case 2: EPC.eGame.FontType = Font_GameCube; break;
        default: EPC.eGame.FontType = Font_Xbox; break;
    }

    // Update canvas font immediately
    UpdateCanvasFont(EPC.eGame.FontType);

    // Update menu fonts
    if (Root != None)
        EPCMainMenuRootWindow(Root).SetupFonts();

    switch (m_CrosshairStyle.GetSelectedIndex())
    {
        case 0: EPC.CrosshairStyle = CS_Original; break;
        case 1: EPC.CrosshairStyle = CS_Beta; break;
        case 2: EPC.CrosshairStyle = CS_PS2; break;
        case 3: EPC.CrosshairStyle = CS_SCCT; break;
        case 4: EPC.CrosshairStyle = CS_PS3; break;
        default: EPC.CrosshairStyle = CS_Original; break;
    }

    //=============================================================================
    // HUD Visibility
    //=============================================================================
    EPC.bShowHUD = m_bShowHUD.m_bSelected;
    HUD.bShowLifeBar = m_bShowLifeBar.m_bSelected;
    HUD.bShowInteractionBox = m_bShowInteractionBox.m_bSelected;
    HUD.bShowCommunicationBox = m_bShowCommunicationBox.m_bSelected;
    HUD.bShowTimer = m_bShowTimer.m_bSelected;
    EPC.bShowInventory = m_bShowInventory.m_bSelected;
    EPC.bShowStealthMeter = m_bShowStealthMeter.m_bSelected;
    EPC.bShowCurrentGoal = m_bShowCurrentGoal.m_bSelected;
    EPC.bShowKeyPadGoal = m_bShowKeypadGoal.m_bSelected;
    EPC.bShowCurrentGadget = m_bShowCurrentGadget.m_bSelected;
    EPC.bShowMissionInformation = m_bShowMissionInformation.m_bSelected;
    EPC.bShowCrosshair = m_bShowCrosshair.m_bSelected;
    EPC.bShowScope = m_bShowScope.m_bSelected;
    EPC.bShowAlarms = m_bShowAlarms.m_bSelected;

    //=============================================================================
    // Suits
    //=============================================================================
    EPC.eGame.ESam_Training = GetSamMeshEnumFromIndex(m_TrainingSamMesh.GetSelectedIndex(), 0);
    EPC.eGame.ESam_Tbilisi = GetSamMeshEnumFromIndex(m_TbilisiSamMesh.GetSelectedIndex(), 0);
    EPC.eGame.ESam_DefenseMinistry = GetSamMeshEnumFromIndex(m_DefenseMinistrySamMesh.GetSelectedIndex(), 0);
    EPC.eGame.ESam_CaspianOilRefinery = GetSamMeshEnumFromIndex(m_CaspianOilRefinerySamMesh.GetSelectedIndex(), 2);
    EPC.eGame.ESam_CIA = GetSamMeshEnumFromIndex(m_CIASamMesh.GetSelectedIndex(), 1);
    EPC.eGame.ESam_Kalinatek = GetSamMeshEnumFromIndex(m_KalinatekSamMesh.GetSelectedIndex(), 0);
    EPC.eGame.ESam_ChineseEmbassy = GetSamMeshEnumFromIndex(m_ChineseEmbassySamMesh.GetSelectedIndex(), 2);
    EPC.eGame.ESam_Abattoir = GetSamMeshEnumFromIndex(m_AbattoirSamMesh.GetSelectedIndex(), 2);
    EPC.eGame.ESam_ChineseEmbassy2 = GetSamMeshEnumFromIndex(m_ChineseEmbassy2SamMesh.GetSelectedIndex(), 2);
    EPC.eGame.ESam_PresidentialPalace = GetSamMeshEnumFromIndex(m_PresidentialPalaceSamMesh.GetSelectedIndex(), 1);
    EPC.eGame.ESam_KolaCell = GetSamMeshEnumFromIndex(m_KolaCellSamMesh.GetSelectedIndex(), 0);
    EPC.eGame.ESam_Vselka = GetSamMeshEnumFromIndex(m_VselkaSamMesh.GetSelectedIndex(), 1);
    EPC.eGame.ESam_PowerPlant = GetSamMeshEnumFromIndex(m_PowerPlantSamMesh.GetSelectedIndex(), 0);
    EPC.eGame.ESam_Severonickel = GetSamMeshEnumFromIndex(m_SeveronickelSamMesh.GetSelectedIndex(), 0);

    EPC.SaveEnhancedOptions();
    EPC.eGame.SaveEnhancedOptions();
    HUD.SaveEnhancedOptions();
    EPC.playerInfo.SaveEnhancedOptions();
}

// Function to update the canvas font immediately
function UpdateCanvasFont(EchelonGameInfo.EFontType FontType)
{
    local ECanvas C;

    C = ECanvas(class'Actor'.static.GetCanvas());

    if (C == None)
        return;

    switch(FontType)
    {
        case Font_PC:
            C.ETextFont = Font'Engine.ETextFont';
            break;
        case Font_Xbox:
            C.ETextFont = Font'Engine.ETextFontXbox';
            break;
        case Font_GameCube:
            C.ETextFont = Font'Engine.ETextFontGameCube';
            break;
        default:
            C.ETextFont = Font'Engine.ETextFontXbox';
            break;
    }
}

// Function to refresh the current door interaction the player is touching
// When loading a save, ApplyPostLoadSettings in EPlayerController handles this instead
function RefreshCurrentDoorInteraction(EPlayerController EPC)
{
    local EDoorInteraction DoorInteraction;
    local EInteractObject InteractObj;

    // Check if player currently has a door interaction in their interaction manager
    if (EPC.IManager.IsPresent(class'EDoorInteraction', InteractObj))
    {
        DoorInteraction = EDoorInteraction(InteractObj);
        if (DoorInteraction != None)
        {
            DoorInteraction.RefreshInteractions();
        }
    }
}

/* Update all wall mines in the level when the delay setting is changed mid-mission
function ApplyWallMineDelay(EPlayerController EPC)
{
    local EWallMine WallMine;
    local float NewDelay;

    // Determine the new delay based on the setting
    switch (EPC.eGame.WallMineDelay)
    {
        case WMD_Default:
            NewDelay = 1.75;
            break;
        case WMD_Enhanced:
            NewDelay = 0.5;
            break;
        case WMD_Instant:
            NewDelay = 0.0;
            break;
    }

    // Elite Mode overrides if greater than 0.5
    if (EPC.eGame.bEliteMode && NewDelay > 0.5)
    {
        NewDelay = 0.5;
    }

    // Update all wall mines in the level
    foreach EPC.AllActors(class'EWallMine', WallMine)
    {
        WallMine.ExplosionDelay = NewDelay;
    }
}
*/

function ResetToDefault()
{
    //=============================================================================
    // General
    //=============================================================================
    m_bCheckForUpdates.m_bSelected = true;
    m_bSkipIntroVideos.m_bSelected = false;
    m_bDisableMenuIdleTimer.m_bSelected = false;
    m_LevelUnlock.SetSelectedIndex(0);

    //=============================================================================
    // Gameplay
    //=============================================================================
    m_bWhistle.m_bSelected = true;
    m_bNewDoorInteraction.m_bSelected = true;
    m_bInteractionPause.m_bSelected = false;
    m_bQuickDataView.m_bSelected = true;
    m_bEnableCheckpoints.m_bSelected = true;
    m_bMissionFailedQuickMenu.m_bSelected = true;
    m_bXboxDifficulty.m_bSelected = false;
    m_PlayerStatsMode.SetSelectedIndex(1); // Default to Ghost

    //=============================================================================
    // Equipment
    //=============================================================================
    m_bBinoculars.m_bSelected = true;
    m_bF2000BurstFire.m_bSelected = true;
    m_bPS2FN7Accuracy.m_bSelected = false;
    m_bF2000ZoomLevels.m_bSelected = true;
    m_bLaserMicZoomLevels.m_bSelected = true;
    m_bLaserMicVisions.m_bSelected = true;
    m_bOpticCableVisions.m_bSelected = true;
    //m_bSwitchCam.m_bSelected = true;
    m_bThermalOverride.m_bSelected = false;
    m_bRandomizeLockpick.m_bSelected = true;
    m_bScaleGadgetDamage.m_bSelected = true;
    m_MineDelay.SetSelectedIndex(0);

    //=============================================================================
    // HUD Settings
    //=============================================================================
    m_bPersistentHUD.m_bSelected = false;
    m_bHorizontalLifeBar.m_bSelected = false;
    m_bInvertInteractionList.m_bSelected = true;
    m_bLetterBoxCinematics.m_bSelected = true;
    m_FontType.SetSelectedIndex(1); // Default to Xbox
    m_CrosshairStyle.SetSelectedIndex(0);

    //=============================================================================
    // HUD Visibility
    //=============================================================================
    m_bShowHUD.m_bSelected = true;
    m_bShowLifeBar.m_bSelected = true;
    m_bShowInteractionBox.m_bSelected = true;
    m_bShowCommunicationBox.m_bSelected = true;
    m_bShowTimer.m_bSelected = true;
    m_bShowInventory.m_bSelected = true;
    m_bShowStealthMeter.m_bSelected = true;
    m_bShowCurrentGoal.m_bSelected = true;
    m_bShowKeypadGoal.m_bSelected = true;
    m_bShowKeypadGoal.bDisabled = false; // Allow if current goal had disabled it
    m_bShowCurrentGadget.m_bSelected = false;
    m_bShowCurrentGadget.bDisabled = false; // Allow if current goal had disabled it
    m_bShowMissionInformation.m_bSelected = true;
    m_bShowCrosshair.m_bSelected = true;
    m_bShowScope.m_bSelected = true;
    m_bShowAlarms.m_bSelected = true;

    //=============================================================================
    // Suits
    //=============================================================================
    m_TrainingSamMesh.SetSelectedIndex(0);
    m_TbilisiSamMesh.SetSelectedIndex(0);
    m_DefenseMinistrySamMesh.SetSelectedIndex(0);
    m_CaspianOilRefinerySamMesh.SetSelectedIndex(0);
    m_CIASamMesh.SetSelectedIndex(0);
    m_KalinatekSamMesh.SetSelectedIndex(0);
    m_ChineseEmbassySamMesh.SetSelectedIndex(0);
    m_AbattoirSamMesh.SetSelectedIndex(0);
    m_ChineseEmbassy2SamMesh.SetSelectedIndex(0);
    m_PresidentialPalaceSamMesh.SetSelectedIndex(0);
    m_KolaCellSamMesh.SetSelectedIndex(0);
    m_VselkaSamMesh.SetSelectedIndex(0);
    m_PowerPlantSamMesh.SetSelectedIndex(0);
    m_SeveronickelSamMesh.SetSelectedIndex(0);

    // Check if any restart-required settings were changed from original
    if (m_bCheckForUpdates.m_bSelected != m_bOriginalCheckForUpdates ||
        m_bSkipIntroVideos.m_bSelected != m_bOriginalSkipIntroVideos ||
        m_bDisableMenuIdleTimer.m_bSelected != m_bOriginalDisableMenuIdleTimer)
    {
        // Stop any auto-scrolling when opening restart required messagebox
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
        EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "RestartRequired", "Localization\\Enhanced"), Localize("Common", "RestartRequiredWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);
    }
}

function Refresh()
{
    local EPlayerController EPC;
    local EchelonMainHUD HUD;

    EPC = EPlayerController(GetPlayerOwner());
    HUD = EchelonMainHUD(EPC.myHUD);

    //=============================================================================
    // General
    //=============================================================================
    if (m_bCheckForUpdates != None)
        m_bCheckForUpdates.m_bSelected = EPC.eGame.bCheckForUpdates;

    if (m_bSkipIntroVideos != None)
        m_bSkipIntroVideos.m_bSelected = EPC.eGame.bSkipIntroVideos;

    if (m_bDisableMenuIdleTimer != None)
        m_bDisableMenuIdleTimer.m_bSelected = EPC.eGame.bDisableMenuIdleTimer;

    // Store original values for restart-required settings
    m_bOriginalCheckForUpdates = EPC.eGame.bCheckForUpdates;
    m_bOriginalSkipIntroVideos = EPC.eGame.bSkipIntroVideos;
    m_bOriginalDisableMenuIdleTimer = EPC.eGame.bDisableMenuIdleTimer;

    if (m_LevelUnlock != None)
        m_LevelUnlock.SetSelectedIndex(Clamp(EPC.playerInfo.LevelUnlock, 0, m_LevelUnlock.List.Items.Count() - 1));

    //=============================================================================
    // Gameplay
    //=============================================================================
    if (m_bWhistle != None)
        m_bWhistle.m_bSelected = EPC.bWhistle;

    if (m_bNewDoorInteraction != None)
        m_bNewDoorInteraction.m_bSelected = EPC.eGame.bNewDoorInteraction;

    if (m_bInteractionPause != None)
        m_bInteractionPause.m_bSelected = EPC.bInteractionPause;

    if (m_bQuickDataView != None)
        m_bQuickDataView.m_bSelected = EPC.bQuickDataView;

    if (m_bEnableCheckpoints != None)
        m_bEnableCheckpoints.m_bSelected = EPC.eGame.bEnableCheckpoints;

    if (m_bMissionFailedQuickMenu != None)
        m_bMissionFailedQuickMenu.m_bSelected = EPC.bMissionFailedQuickMenu;

    if (m_bXboxDifficulty != None)
        m_bXboxDifficulty.m_bSelected = EPC.eGame.bXboxDifficulty;

    if (m_PlayerStatsMode != None && EPC != None)
        m_PlayerStatsMode.SetSelectedIndex(Clamp(EPC.PlayerStatsMode, 0, m_PlayerStatsMode.List.Items.Count() - 1));

    //=============================================================================
    // Equipment
    //=============================================================================
    if (m_bBinoculars != None)
        m_bBinoculars.m_bSelected = EPC.bBinoculars;

    if (m_bF2000BurstFire != None)
        m_bF2000BurstFire.m_bSelected = EPC.bF2000BurstFire;

    if (m_bPS2FN7Accuracy != None)
        m_bPS2FN7Accuracy.m_bSelected = EPC.eGame.bPS2FN7Accuracy;

    if (m_bF2000ZoomLevels != None)
        m_bF2000ZoomLevels.m_bSelected = EPC.bF2000ZoomLevels;

    if (m_bLaserMicZoomLevels != None)
        m_bLaserMicZoomLevels.m_bSelected = EPC.bLaserMicZoomLevels;

    if (m_bLaserMicVisions != None)
        m_bLaserMicVisions.m_bSelected = EPC.bLaserMicVisions;

    if (m_bOpticCableVisions != None)
        m_bOpticCableVisions.m_bSelected = EPC.bOpticCableVisions;

    //if (m_bSwitchCam != None)
    //    m_bSwitchCam.m_bSelected = EPC.bSwitchCam;

    if (m_bThermalOverride != None)
        m_bThermalOverride.m_bSelected = EPC.eGame.bThermalOverride;

    if (m_bRandomizeLockpick != None)
        m_bRandomizeLockpick.m_bSelected = EPC.eGame.bRandomizeLockpick;

    if (m_bScaleGadgetDamage != None)
        m_bScaleGadgetDamage.m_bSelected = EPC.eGame.bScaleGadgetDamage;

    if (m_MineDelay != None)
        m_MineDelay.SetSelectedIndex(Clamp(EPC.eGame.WallMineDelay, 0, m_MineDelay.List.Items.Count() - 1));

    //=============================================================================
    // HUD Settings
    //=============================================================================
    if (m_bPersistentHUD != None)
        m_bPersistentHUD.m_bSelected = EPC.bPersistentHUD;

    if (m_bHorizontalLifeBar != None)
        m_bHorizontalLifeBar.m_bSelected = EPC.bHorizontalLifeBar;

    if (m_bInvertInteractionList != None)
        m_bInvertInteractionList.m_bSelected = EPC.bInvertInteractionList;

    if (m_bLetterBoxCinematics != None)
        m_bLetterBoxCinematics.m_bSelected = HUD.bLetterBoxCinematics;

    if (m_FontType != None && EPC != None)
        m_FontType.SetSelectedIndex(Clamp(EPC.eGame.FontType, 0, m_FontType.List.Items.Count() - 1));

    if (m_CrosshairStyle != None && EPC != None)
        m_CrosshairStyle.SetSelectedIndex(Clamp(EPC.CrosshairStyle, 0, m_CrosshairStyle.List.Items.Count() - 1));

    //=============================================================================
    // HUD Visibility
    //=============================================================================
    if (m_bShowHUD != None)
        m_bShowHUD.m_bSelected = EPC.bShowHUD;

    if (m_bShowLifeBar != None)
        m_bShowLifeBar.m_bSelected = HUD.bShowLifeBar;

    if (m_bShowInteractionBox != None)
        m_bShowInteractionBox.m_bSelected = HUD.bShowInteractionBox;

    if (m_bShowCommunicationBox != None)
        m_bShowCommunicationBox.m_bSelected = HUD.bShowCommunicationBox;

    if (m_bShowTimer != None)
        m_bShowTimer.m_bSelected = HUD.bShowTimer;

    if (m_bShowInventory != None)
        m_bShowInventory.m_bSelected = EPC.bShowInventory;

    if (m_bShowStealthMeter != None)
        m_bShowStealthMeter.m_bSelected = EPC.bShowStealthMeter;

    if (m_bShowCurrentGoal != None)
    {
        m_bShowCurrentGoal.m_bSelected = EPC.bShowCurrentGoal;

        if (m_bShowKeypadGoal != None)
        {
            // Gray out keypad goal and current gadget if current goal is disabled
            m_bShowKeypadGoal.bDisabled = !EPC.bShowCurrentGoal;
            m_bShowCurrentGadget.bDisabled = !EPC.bShowCurrentGoal;
        }
    }

    if (m_bShowKeypadGoal != None)
        m_bShowKeypadGoal.m_bSelected = EPC.bShowKeyPadGoal;

    if (m_bShowCurrentGadget != None)
        m_bShowCurrentGadget.m_bSelected = EPC.bShowCurrentGadget;

    if (m_bShowMissionInformation != None)
        m_bShowMissionInformation.m_bSelected = EPC.bShowMissionInformation;

    if (m_bShowCrosshair != None)
        m_bShowCrosshair.m_bSelected = EPC.bShowCrosshair;

    if (m_bShowScope != None)
        m_bShowScope.m_bSelected = EPC.bShowScope;

    if (m_bShowAlarms != None)
        m_bShowAlarms.m_bSelected = EPC.bShowAlarms;

    //=============================================================================
    // Suits
    //=============================================================================
    if (m_TrainingSamMesh != None)
        m_TrainingSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_Training, 0));

    if (m_TbilisiSamMesh != None)
        m_TbilisiSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_Tbilisi, 0));

    if (m_DefenseMinistrySamMesh != None)
        m_DefenseMinistrySamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_DefenseMinistry, 0));

    if (m_CaspianOilRefinerySamMesh != None)
        m_CaspianOilRefinerySamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_CaspianOilRefinery, 2));

    if (m_CIASamMesh != None)
        m_CIASamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_CIA, 1));

    if (m_KalinatekSamMesh != None)
        m_KalinatekSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_Kalinatek, 0));

    if (m_ChineseEmbassySamMesh != None)
        m_ChineseEmbassySamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_ChineseEmbassy, 2));

    if (m_AbattoirSamMesh != None)
        m_AbattoirSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_Abattoir, 2));

    if (m_ChineseEmbassy2SamMesh != None)
        m_ChineseEmbassy2SamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_ChineseEmbassy2, 2));

    if (m_PresidentialPalaceSamMesh != None)
        m_PresidentialPalaceSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_PresidentialPalace, 1));

    if (m_KolaCellSamMesh != None)
        m_KolaCellSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_KolaCell, 0));

    if (m_VselkaSamMesh != None)
        m_VselkaSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_Vselka, 1));

    if (m_PowerPlantSamMesh != None)
        m_PowerPlantSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_PowerPlant, 0));

    if (m_SeveronickelSamMesh != None)
        m_SeveronickelSamMesh.SetSelectedIndex(GetIndexFromSamMeshEnum(EPC.eGame.ESam_Severonickel, 0));

	m_bModified = false;
	m_bFirstRefresh = false;
}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    local EPCEnhancedListBoxItem Item;

    m_bEnableArea = bEnable;

    // Close any open combo box
    if (m_bComboBoxOpen && m_ActiveCombo != None)
    {
        m_ActiveCombo.CloseUp();
    }
    m_bComboBoxOpen = false;
    m_ActiveCombo = None;

    if (bEnable)
    {
        // Find the first visible selectable item (based on scroll position)
        m_selectedItemIndex = GetFirstVisibleSelectableItemIndex();

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
        // Clear selection
        m_selectedItemIndex = -1;
        ClearHighlight();
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
    }
}

// Joshua - Check if current item has an info button
function bool CurrentItemHasInfo()
{
    local EPCEnhancedListBoxItem Item;

    if (!m_bEnableArea || m_selectedItemIndex < 0)
        return false;

    // Get the item at the absolute selected index
    Item = GetItemAtIndex(m_selectedItemIndex);
    if (Item != None && Item.m_InfoButton != None)
    {
        return true;
    }

    return false;
}

// Joshua - Get the index of the first visible selectable item based on scroll position
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

// Joshua - Get the total number of selectable items in the list
// Only counts items that have m_Control (not titles/headers)
function int GetTotalItemCount()
{
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;
    local int Count;

    Count = 0;
    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        EnhancedItem = EPCEnhancedListBoxItem(CurItem);
        if (EnhancedItem != None && EnhancedItem.m_Control != None)
        {
            Count++;
        }
    }
    return Count;
}

// Joshua - Get the selectable item at the specified selectable index
// This counts only items that have m_Control (not titles/headers)
function EPCEnhancedListBoxItem GetItemAtIndex(int SelectableIndex)
{
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;
    local int CurSelectableIndex;

    CurSelectableIndex = 0;
    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        EnhancedItem = EPCEnhancedListBoxItem(CurItem);
        if (EnhancedItem != None && EnhancedItem.m_Control != None)
        {
            if (CurSelectableIndex == SelectableIndex)
                return EnhancedItem;
            CurSelectableIndex++;
        }
    }
    return None;
}

// Joshua - Find the next selectable item index (with a control), returns -1 if none found in direction
function int GetNextSelectableItemIndex(int CurrentIndex, bool bForward)
{
    local int TotalItems;
    local int NewIndex;
    local EPCEnhancedListBoxItem Item;

    TotalItems = GetTotalItemCount();
    if (TotalItems == 0)
        return -1;

    NewIndex = CurrentIndex;

    while (true)
    {
        if (bForward)
        {
            NewIndex = NewIndex + 1;
            if (NewIndex >= TotalItems)
                return -1; // At the end, no more items
        }
        else
        {
            NewIndex = NewIndex - 1;
            if (NewIndex < 0)
                return -1; // At the beginning, no more items
        }

        Item = GetItemAtIndex(NewIndex);
        if (Item != None && Item.m_Control != None)
            return NewIndex;
    }

    return -1;
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

// Joshua - Highlight the item at the specified index
function HighlightSelectedItem(int Index)
{
    local EPCEnhancedListBoxItem Item;

    ClearHighlight();

    Item = GetItemAtIndex(Index);
    if (Item != None)
    {
        Item.bSelected = true;

        // Ensure the item is visible by scrolling if needed
        ScrollToItem(Index);
    }
}

// Joshua - Scroll the list to make the specified selectable item visible
function ScrollToItem(int SelectableIndex)
{
    local int VisibleStart;
    local int VisibleCount;
    local int RawIndex;

    if (m_ListBox.VertSB == None)
        return;

    VisibleStart = m_ListBox.VertSB.Pos;
    VisibleCount = 8; // Approximate visible items

    // If we're at the first selectable item, scroll all the way to top to show header
    if (SelectableIndex == 0)
    {
        m_ListBox.VertSB.Pos = 0;
        return;
    }

    // Convert selectable index to raw visible item index for scrolling
    RawIndex = GetRawIndexForSelectableItem(SelectableIndex);

    if (RawIndex < VisibleStart)
    {
        m_ListBox.VertSB.Pos = RawIndex;
    }
    else if (RawIndex >= VisibleStart + VisibleCount - 1)
    {
        m_ListBox.VertSB.Pos = RawIndex - VisibleCount + 2;
    }
}

// Joshua - Convert a selectable item index to a raw visible item index
function int GetRawIndexForSelectableItem(int SelectableIndex)
{
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;
    local int RawIndex;
    local int CurSelectableIndex;

    RawIndex = 0;
    CurSelectableIndex = 0;
    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        if (!CurItem.ShowThisItem())
            continue;

        EnhancedItem = EPCEnhancedListBoxItem(CurItem);
        if (EnhancedItem != None && EnhancedItem.m_Control != None)
        {
            if (CurSelectableIndex == SelectableIndex)
                return RawIndex;
            CurSelectableIndex++;
        }
        RawIndex++;
    }
    return 0;
}

// Joshua - Activate the currently selected item (toggle checkbox or open combo)
function ActivateSelectedItem()
{
    local EPCEnhancedListBoxItem Item;
    local EPCCheckBox CheckBox;
    local EPCComboControl ComboBox;

    Item = GetItemAtIndex(m_selectedItemIndex);
    if (Item == None || Item.m_Control == None)
        return;

    // Check if it's a checkbox
    CheckBox = EPCCheckBox(Item.m_Control);
    if (CheckBox != None)
    {
        CheckBox.m_bSelected = !CheckBox.m_bSelected;
        Notify(CheckBox, DE_Click);
        Root.PlayClickSound();
        return;
    }

    // Check if it's a combo box - open it for selection
    ComboBox = EPCComboControl(Item.m_Control);
    if (ComboBox != None)
    {
        OpenComboBox(ComboBox);
        return;
    }
}

// Joshua - Open a combo box for controller selection
function OpenComboBox(EPCComboControl ComboBox)
{
    if (ComboBox == None || ComboBox.List == None)
        return;

    m_bComboBoxOpen = true;
    m_ActiveCombo = ComboBox;
    ComboBox.DropDown();
    Root.PlayClickSound();
    // Joshua - Reset held key state so direction isn't carried into combo
    m_heldKey = 0;
    m_keyHoldTime = 0;
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

    // Don't process input while combo box is open, combo list handles it
    if (m_bComboBoxOpen)
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

    if (Msg == WM_KeyDown)
    {
        // Track repeatable keys (directional keys only)
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

        HandleItemNavigationInput(Key);
    }
}

// Joshua - Handle input when navigating items
function HandleItemNavigationInput(int Key)
{
    local int NewIndex;

    // Navigate down - DPadDown (213) or AnalogDown (197)
    if (Key == 213 || Key == 197)
    {
        NewIndex = GetNextSelectableItemIndex(m_selectedItemIndex, true);
        if (NewIndex != -1)
        {
            Root.PlayClickSound();
            m_selectedItemIndex = NewIndex;
            HighlightSelectedItem(m_selectedItemIndex);
        }
        // At bottom - do nothing
    }
    // Navigate up - DPadUp (212) or AnalogUp (196)
    else if (Key == 212 || Key == 196)
    {
        NewIndex = GetNextSelectableItemIndex(m_selectedItemIndex, false);
        if (NewIndex != -1)
        {
            Root.PlayClickSound();
            m_selectedItemIndex = NewIndex;
            HighlightSelectedItem(m_selectedItemIndex);
        }
    }
    // A button - select
    else if (Key == 200)
    {
        ActivateSelectedItem();
    }
    // Y button - show tooltip
    else if (Key == 203)
    {
        ShowSelectedItemTooltip();
    }
    // B button - exit to tab selection
    else if (Key == 201)
    {
        Root.PlayClickSound();
        EnableArea(false);
        EPCOptionsMenu(ParentWindow).AreaExited();
    }
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

    if (!m_bEnableArea || m_heldKey == 0 || m_bComboBoxOpen)
        return;

    m_keyHoldTime += Delta;

    // Check if it's time to repeat
    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Execute the held key's action
        HandleItemNavigationInput(m_heldKey);

        // Schedule next repeat
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

defaultproperties
{
    m_initialDelay=0.5
    m_repeatRate=0.1
}
