//=============================================================================
//  EPCEnhancedConfigArea.uc : Area containing controls for Enhanced settings
//=============================================================================
class EPCEnhancedConfigArea extends UWindowDialogClientWindow;

var EPCEnhancedListBox      m_ListBox;

var EPCCheckBox             m_bEnablePlayerStats,
                            m_bInteractionPause,
                            m_bEnableCheckpoints,
                            m_bXboxDifficulty,
                            m_bLetterBoxCinematics,
                            m_bWhistle,
                            m_bF2000ZoomLevels,
                            m_bLaserMicZoomLevels,
                            m_bBurstFire,
                            m_bPS2FN7Accuracy,
                            m_bNewDoorInteraction,
                            m_bRandomizeLockpick,
                            m_bOpticCableVisions,
                            m_bThermalOverride,
                            m_bScaleGadgetDamage;

var EPCCheckBox             m_bShowHUD,
                            m_bShowLifeBar,
                            m_bShowInteractionBox,
                            m_bShowCommunicationBox,
                            m_bShowTimer,
                            m_bShowInventory,
                            m_bShowStealthMeter,
                            m_bShowCurrentGoal,
                            m_bShowKeypadGoal,
                            m_bShowMissionInformation,
                            m_bShowCrosshair,
                            m_bShowScope,
                            m_bShowAlarms;

// Native
var EPCCheckBox             m_bCheckForUpdates,
                            m_bSkipIntroVideos,
                            m_bDisableMenuIdleTimer;

// Native
var EPCComboControl         m_FontType;

var EPCComboControl         m_LevelUnlock;
                            
var EPCComboControl         m_MineDelay;

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

function Created()
{
    SetAcceptsFocus();

    m_ListBox = EPCEnhancedListBox(CreateWindow(class'EPCEnhancedListBox', 0, 0, WinWidth, WinHeight));
    m_ListBox.SetAcceptsFocus();
    m_ListBox.TitleFont = F_Normal;

    InitEnhancedSettings();
}

function InitEnhancedSettings()
{
    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_General", "Localization\\Enhanced")));
    AddLineItem();

    AddCheckBoxItem("CheckForUpdates", m_bCheckForUpdates);
    AddCheckBoxItem("SkipIntroVideos", m_bSkipIntroVideos);
    AddCheckBoxItem("DisableMenuIdleTimer", m_bDisableMenuIdleTimer);

    AddCheckBoxItem("EnablePlayerStats", m_bEnablePlayerStats);
    AddCheckBoxItem("InteractionPause", m_bInteractionPause);
    AddCheckBoxItem("EnableCheckpoints", m_bEnableCheckpoints);
    AddCheckBoxItem("XboxDifficulty", m_bXboxDifficulty);

    AddCheckBoxItem("LetterBoxCinematics", m_bLetterBoxCinematics);

    AddCompactLineItem();

    AddComboBoxItem("FontType", m_FontType);
    AddFontTypeCombo(m_FontType);

    AddCompactLineItem();

    AddComboBoxItem("LevelUnlock", m_LevelUnlock);
    AddLevelUnlockCombo(m_LevelUnlock);

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_Equipment", "Localization\\Enhanced")));
    AddLineItem();

    AddCheckBoxItem("Whistle", m_bWhistle);
    AddCheckBoxItem("F2000ZoomLevels", m_bF2000ZoomLevels);
    AddCheckBoxItem("LaserMicZoomLevels", m_bLaserMicZoomLevels);
    AddCheckBoxItem("BurstFire", m_bBurstFire);
    AddCheckBoxItem("PS2FN7Accuracy", m_bPS2FN7Accuracy);
    AddCheckBoxItem("NewDoorInteraction", m_bNewDoorInteraction);
    AddCheckBoxItem("RandomizeLockpick", m_bRandomizeLockpick);
    AddCheckBoxItem("OpticCableVisions", m_bOpticCableVisions);
    AddCheckBoxItem("ThermalOverride", m_bThermalOverride);
    AddCheckBoxItem("ScaleGadgetDamage", m_bScaleGadgetDamage);

    AddCompactLineItem();
    AddComboBoxItem("MineDelay", m_MineDelay);
    AddMineDelayCombo(m_MineDelay);

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_HUD", "Localization\\Enhanced")));
    AddLineItem();

    AddCheckBoxItem("ShowHUD", m_bShowHUD);
    AddCheckBoxItem("ShowLifeBar", m_bShowLifeBar);
    AddCheckBoxItem("ShowInteractionBox", m_bShowInteractionBox);
    AddCheckBoxItem("ShowCommunicationBox", m_bShowCommunicationBox);
    AddCheckBoxItem("ShowTimer", m_bShowTimer);
    AddCheckBoxItem("ShowInventory", m_bShowInventory);
    AddCheckBoxItem("ShowStealthMeter", m_bShowStealthMeter);
    AddCheckBoxItem("ShowCurrentGoal", m_bShowCurrentGoal);
    AddCheckBoxItem("ShowKeypadGoal", m_bShowKeypadGoal);
    AddCheckBoxItem("ShowMissionInformation", m_bShowMissionInformation);
    AddCheckBoxItem("ShowCrosshair", m_bShowCrosshair);
    AddCheckBoxItem("ShowScope", m_bShowScope);
    AddCheckBoxItem("ShowAlarms", m_bShowAlarms);
    AddLineItem();

    AddLineItem();
    AddTitleItem(Caps(Localize("Enhanced", "Title_Suit", "Localization\\Enhanced")));
    AddLineItem();

    AddComboBoxItem("TrainingSamMesh", m_TrainingSamMesh); 
    AddSamMeshCombo(m_TrainingSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("TbilisiSamMesh", m_TbilisiSamMesh);
    AddSamMeshCombo(m_TbilisiSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("DefenseMinistrySamMesh", m_DefenseMinistrySamMesh);
    AddSamMeshCombo(m_DefenseMinistrySamMesh);
    AddCompactLineItem();    

    AddComboBoxItem("CaspianOilRefinerySamMesh", m_CaspianOilRefinerySamMesh);
    AddSamMeshCombo(m_CaspianOilRefinerySamMesh);
    AddCompactLineItem();

    AddComboBoxItem("CIASamMesh", m_CIASamMesh);
    AddSamMeshCombo(m_CIASamMesh);
    AddCompactLineItem();

    AddComboBoxItem("KalinatekSamMesh", m_KalinatekSamMesh);
    AddSamMeshCombo(m_KalinatekSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("ChineseEmbassySamMesh", m_ChineseEmbassySamMesh);
    AddSamMeshCombo(m_ChineseEmbassySamMesh);
    AddCompactLineItem();

    AddComboBoxItem("AbattoirSamMesh", m_AbattoirSamMesh);
    AddSamMeshCombo(m_AbattoirSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("ChineseEmbassy2SamMesh", m_ChineseEmbassy2SamMesh);
    AddSamMeshCombo(m_ChineseEmbassy2SamMesh);
    AddCompactLineItem();

    AddComboBoxItem("PresidentialPalaceSamMesh", m_PresidentialPalaceSamMesh);
    AddSamMeshCombo(m_PresidentialPalaceSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("KolaCellSamMesh", m_KolaCellSamMesh);
    AddSamMeshCombo(m_KolaCellSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("VselkaSamMesh", m_VselkaSamMesh);
    AddSamMeshCombo(m_VselkaSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("PowerPlantSamMesh", m_PowerPlantSamMesh);
    AddSamMeshCombo(m_PowerPlantSamMesh);
    AddCompactLineItem();

    AddComboBoxItem("SeveronickelSamMesh", m_SeveronickelSamMesh);
    AddSamMeshCombo(m_SeveronickelSamMesh);
    AddCompactLineItem();
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

function AddTitleItem(string Title)
{
    local EPCEnhancedListBoxItem NewItem;
    
    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.Caption = Title;
    NewItem.m_bIsTitle = true;
    NewItem.m_bIsNotSelectable = true;
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

function AddMineDelayCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced","MineDelay_Default","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced","MineDelay_Enhanced","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced","MineDelay_Instant","Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function AddSamMeshCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced", "SamMesh_Default", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "SamMesh_Standard", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "SamMesh_Balaclava", "Localization\\Enhanced")); 
    ComboBox.AddItem(Localize("Enhanced", "SamMesh_PartialSleeves", "Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function AddFontTypeCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Enhanced", "FontType_PC", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "FontType_Xbox", "Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Enhanced", "FontType_GameCube", "Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(1); // Default to Xbox
}

function Notify(UWindowDialogControl C, byte E)
{
    if (E == DE_Click)
    {
        switch (C)
        {
            case m_bCheckForUpdates:
            case m_bSkipIntroVideos:
            case m_bDisableMenuIdleTimer:
            case m_bEnablePlayerStats:
            case m_bInteractionPause:
            case m_bEnableCheckpoints:
            case m_bXboxDifficulty:
            case m_bLetterBoxCinematics:
            case m_bWhistle:
            case m_bF2000ZoomLevels:
            case m_bLaserMicZoomLevels:
            case m_bBurstFire:
            case m_bPS2FN7Accuracy:
            case m_bNewDoorInteraction:
            case m_bRandomizeLockpick:
            case m_bOpticCableVisions:
            case m_bThermalOverride:            
            case m_bScaleGadgetDamage:
            case m_bShowHUD:
            case m_bShowLifeBar:
            case m_bShowInteractionBox:
            case m_bShowCommunicationBox:
            case m_bShowTimer:
            case m_bShowInventory:
            case m_bShowStealthMeter:
            case m_bShowCurrentGoal: // If current goal is disabled, disable keypad goal
                if (C == m_bShowCurrentGoal)
                {
                    if (!m_bShowCurrentGoal.m_bSelected)
                    {
                        m_bShowKeypadGoal.bDisabled = true;
                    }
                    else
                    {
                        m_bShowKeypadGoal.bDisabled = false;
                    }
                }
                m_bModified = true;
                break;
            case m_bShowKeypadGoal:
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
            case m_FontType:
            case m_LevelUnlock:
            case m_MineDelay:
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
    local bool bPreviousF2000ZoomLevels;
    local bool bPreviousLaserMicZoomLevels;
    local bool bPreviousBurstFire;
    local bool bPreviousNewDoorInteraction;

    local EGoggle Goggle;
    
    EPC = EPlayerController(GetPlayerOwner());
    HUD = EchelonMainHUD(EPC.myHUD);
    bPreviousF2000ZoomLevels = EPC.bF2000ZoomLevels;
    bPreviousLaserMicZoomLevels = EPC.bLaserMicZoomLevels;
    bPreviousBurstFire = EPC.bBurstFire;
    bPreviousNewDoorInteraction = EPC.eGame.bNewDoorInteraction;
    
    EPC.eGame.bCheckForUpdates = m_bCheckForUpdates.m_bSelected;
    EPC.eGame.bSkipIntroVideos = m_bSkipIntroVideos.m_bSelected;
    EPC.eGame.bDisableMenuIdleTimer = m_bDisableMenuIdleTimer.m_bSelected;
    
    switch (m_FontType.GetSelectedIndex())
    {
        case 0: EPC.eGame.FontType = Font_PC; break;
        case 1: EPC.eGame.FontType = Font_Xbox; break;
        case 2: EPC.eGame.FontType = Font_GameCube; break;
        default: EPC.eGame.FontType = Font_Xbox; break;
    }
    EPC.bEnablePlayerStats = m_bEnablePlayerStats.m_bSelected;
    EPC.bInteractionPause = m_bInteractionPause.m_bSelected;
    EPC.eGame.bEnableCheckpoints = m_bEnableCheckpoints.m_bSelected;
    EPC.eGame.bXboxDifficulty = m_bXboxDifficulty.m_bSelected;
    HUD.bLetterBoxCinematics = m_bLetterBoxCinematics.m_bSelected;
    EPC.bWhistle = m_bWhistle.m_bSelected;
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
    if (bPreviousLaserMicZoomLevels && !Epc.bLaserMicZoomLevels && Epc.GetStateName() == 's_LaserMicTargeting')
    {
        EPC.SetCameraFOV(ELaserMic(EPC.ePawn.HandItem), 30.0);
        ELaserMic(EPC.ePawn.HandItem).current_fov = 30.0;
    }

    EPC.bBurstFire = m_bBurstFire.m_bSelected;
    if (bPreviousBurstFire && !EPC.bBurstFire)
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
    
    EPC.eGame.bNewDoorInteraction = m_bNewDoorInteraction.m_bSelected;
    if (bPreviousNewDoorInteraction != EPC.eGame.bNewDoorInteraction)
    {
        RefreshCurrentDoorInteraction(EPC);
    }
    
    EPC.eGame.bRandomizeLockpick = m_bRandomizeLockpick.m_bSelected;
    EPC.eGame.bOpticCableVisions = m_bOpticCableVisions.m_bSelected;
    EPC.eGame.bThermalOverride = m_bThermalOverride.m_bSelected;
    if (EPC.Goggle != None && !EPC.eGame.bEliteMode)
    {
        if (EchelonPlayerStart(EPC.StartSpot).bNoThermalAvailable)
            EPC.Goggle.bNoThermalAvailable = !m_bThermalOverride.m_bSelected;
        else
            EPC.Goggle.bNoThermalAvailable = false;
    }
    EPC.eGame.bScaleGadgetDamage = m_bScaleGadgetDamage.m_bSelected;

    switch (m_LevelUnlock.GetSelectedIndex())
    {
        case 0: EPC.playerInfo.LevelUnlock = LU_Disabled; break;
        case 1: EPC.playerInfo.LevelUnlock = LU_Enabled; break;
        case 2: EPC.playerInfo.LevelUnlock = LU_AllParts; break;
        default: EPC.playerInfo.LevelUnlock = LU_Disabled; break;
    }

    switch (m_MineDelay.GetSelectedIndex())
    {
        case 0: EPC.eGame.WallMineDelay = WMD_Default; break;
        case 1: EPC.eGame.WallMineDelay = WMD_Enhanced; break;
        case 2: EPC.eGame.WallMineDelay = WMD_Instant; break;
        default: EPC.eGame.WallMineDelay = WMD_Default; break;
    }

    EPC.bShowHUD = m_bShowHUD.m_bSelected;
    HUD.bShowLifeBar = m_bShowLifeBar.m_bSelected;
    HUD.bShowInteractionBox = m_bShowInteractionBox.m_bSelected;
    HUD.bShowCommunicationBox = m_bShowCommunicationBox.m_bSelected;
    HUD.bShowTimer = m_bShowTimer.m_bSelected;
    EPC.bShowInventory = m_bShowInventory.m_bSelected;
    EPC.bShowStealthMeter = m_bShowStealthMeter.m_bSelected;
    EPC.bShowCurrentGoal = m_bShowCurrentGoal.m_bSelected;
    EPC.bShowKeyPadGoal = m_bShowKeypadGoal.m_bSelected;
    EPC.bShowMissionInformation = m_bShowMissionInformation.m_bSelected;
    EPC.bShowCrosshair = m_bShowCrosshair.m_bSelected;
    EPC.bShowScope = m_bShowScope.m_bSelected;
    EPC.bShowAlarms = m_bShowAlarms.m_bSelected;
    
    switch (m_TrainingSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_Training = SMT_Default; break;
        case 1: EPC.eGame.ESam_Training = SMT_Standard; break;
        case 2: EPC.eGame.ESam_Training = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_Training = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_Training = SMT_Default; break;
    }

    switch (m_TbilisiSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_Tbilisi = SMT_Default; break;
        case 1: EPC.eGame.ESam_Tbilisi = SMT_Standard; break;
        case 2: EPC.eGame.ESam_Tbilisi = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_Tbilisi = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_Tbilisi = SMT_Default; break;
    }

    switch (m_DefenseMinistrySamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_DefenseMinistry = SMT_Default; break;
        case 1: EPC.eGame.ESam_DefenseMinistry = SMT_Standard; break;
        case 2: EPC.eGame.ESam_DefenseMinistry = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_DefenseMinistry = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_DefenseMinistry = SMT_Default; break;
    }

    switch (m_CaspianOilRefinerySamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_CaspianOilRefinery = SMT_Default; break;
        case 1: EPC.eGame.ESam_CaspianOilRefinery = SMT_Standard; break;
        case 2: EPC.eGame.ESam_CaspianOilRefinery = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_CaspianOilRefinery = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_CaspianOilRefinery = SMT_Default; break;
    }

    switch (m_CIASamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_CIA = SMT_Default; break;
        case 1: EPC.eGame.ESam_CIA = SMT_Standard; break;
        case 2: EPC.eGame.ESam_CIA = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_CIA = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_CIA = SMT_Default; break;
    }

    switch (m_KalinatekSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_Kalinatek = SMT_Default; break;
        case 1: EPC.eGame.ESam_Kalinatek = SMT_Standard; break;
        case 2: EPC.eGame.ESam_Kalinatek = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_Kalinatek = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_Kalinatek = SMT_Default; break;
    }

    switch (m_ChineseEmbassySamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_ChineseEmbassy = SMT_Default; break;
        case 1: EPC.eGame.ESam_ChineseEmbassy = SMT_Standard; break;
        case 2: EPC.eGame.ESam_ChineseEmbassy = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_ChineseEmbassy = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_ChineseEmbassy = SMT_Default; break;
    }

    switch (m_AbattoirSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_Abattoir = SMT_Default; break;
        case 1: EPC.eGame.ESam_Abattoir = SMT_Standard; break;
        case 2: EPC.eGame.ESam_Abattoir = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_Abattoir = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_Abattoir = SMT_Default; break;
    }

    switch (m_ChineseEmbassy2SamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_ChineseEmbassy2 = SMT_Default; break;
        case 1: EPC.eGame.ESam_ChineseEmbassy2 = SMT_Standard; break;
        case 2: EPC.eGame.ESam_ChineseEmbassy2 = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_ChineseEmbassy2 = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_ChineseEmbassy2 = SMT_Default; break;
    }

    switch (m_PresidentialPalaceSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_PresidentialPalace = SMT_Default; break;
        case 1: EPC.eGame.ESam_PresidentialPalace = SMT_Standard; break;
        case 2: EPC.eGame.ESam_PresidentialPalace = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_PresidentialPalace = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_PresidentialPalace = SMT_Default; break;
    }

    switch (m_KolaCellSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_KolaCell = SMT_Default; break;
        case 1: EPC.eGame.ESam_KolaCell = SMT_Standard; break;
        case 2: EPC.eGame.ESam_KolaCell = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_KolaCell = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_KolaCell = SMT_Default; break;
    }

    switch (m_VselkaSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_Vselka = SMT_Default; break;
        case 1: EPC.eGame.ESam_Vselka = SMT_Standard; break;
        case 2: EPC.eGame.ESam_Vselka = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_Vselka = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_Vselka = SMT_Default; break;
    }

    switch (m_PowerPlantSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_PowerPlant = SMT_Default; break;
        case 1: EPC.eGame.ESam_PowerPlant = SMT_Standard; break;
        case 2: EPC.eGame.ESam_PowerPlant = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_PowerPlant = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_PowerPlant = SMT_Default; break;
    }

    switch (m_SeveronickelSamMesh.GetSelectedIndex())
    {
        case 0: EPC.eGame.ESam_Severonickel = SMT_Default; break;
        case 1: EPC.eGame.ESam_Severonickel = SMT_Standard; break;
        case 2: EPC.eGame.ESam_Severonickel = SMT_Balaclava; break;
        case 3: EPC.eGame.ESam_Severonickel = SMT_PartialSleeves; break;
        default: EPC.eGame.ESam_Severonickel = SMT_Default; break;
    }
    EPC.SaveEnhancedOptions();
    EPC.eGame.SaveEnhancedOptions();
    HUD.SaveEnhancedOptions();
    EPC.playerInfo.SaveEnhancedOptions();
}

// Function to refresh the current door interaction the player is touching
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

function ResetToDefault()
{
    m_bCheckForUpdates.m_bSelected = true;
    m_bSkipIntroVideos.m_bSelected = false;
    m_bDisableMenuIdleTimer.m_bSelected = false;
    m_FontType.SetSelectedIndex(1); // Default to Xbox
    m_bEnablePlayerStats.m_bSelected = true;
    m_bInteractionPause.m_bSelected = false;
    m_bEnableCheckpoints.m_bSelected = true;
    m_bXboxDifficulty.m_bSelected = false;
    m_bLetterBoxCinematics.m_bSelected = true;
    m_LevelUnlock.SetSelectedIndex(0);

    m_bWhistle.m_bSelected = true;
    m_bF2000ZoomLevels.m_bSelected = true;
    m_bLaserMicZoomLevels.m_bSelected = true;
    m_bBurstFire.m_bSelected = true;
    m_bPS2FN7Accuracy.m_bSelected = false;
    m_bNewDoorInteraction.m_bSelected = true;
    m_bRandomizeLockpick.m_bSelected = true;
    m_bOpticCableVisions.m_bSelected = true;
    m_bThermalOverride.m_bSelected = false;
    m_bScaleGadgetDamage.m_bSelected = true;
    m_MineDelay.SetSelectedIndex(0);

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
    m_bShowMissionInformation.m_bSelected = true;
    m_bShowCrosshair.m_bSelected = true;
    m_bShowScope.m_bSelected = true;
    m_bShowAlarms.m_bSelected = true;

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
}

function Refresh()
{
    local EPlayerController EPC;
    local EchelonMainHUD HUD;
    
    EPC = EPlayerController(GetPlayerOwner());
    HUD = EchelonMainHUD(EPC.myHUD);

    if (m_FontType != None && EPC != None)
        m_FontType.SetSelectedIndex(Clamp(EPC.eGame.FontType, 0, m_FontType.List.Items.Count() - 1));

    if (m_bCheckForUpdates != None)
        m_bCheckForUpdates.m_bSelected = EPC.eGame.bCheckForUpdates;

    if (m_bSkipIntroVideos != None)
        m_bSkipIntroVideos.m_bSelected = EPC.eGame.bSkipIntroVideos;

    if (m_bDisableMenuIdleTimer != None)
        m_bDisableMenuIdleTimer.m_bSelected = EPC.eGame.bDisableMenuIdleTimer;

    if (m_bEnablePlayerStats != None)
        m_bEnablePlayerStats.m_bSelected = EPC.bEnablePlayerStats;

    if (m_bInteractionPause != None)
        m_bInteractionPause.m_bSelected = EPC.bInteractionPause;

    if (m_bEnableCheckpoints != None)
        m_bEnableCheckpoints.m_bSelected = EPC.eGame.bEnableCheckpoints;

    if (m_bXboxDifficulty != None)
        m_bXboxDifficulty.m_bSelected = EPC.eGame.bXboxDifficulty;

    if (m_bLetterBoxCinematics != None)
        m_bLetterBoxCinematics.m_bSelected = HUD.bLetterBoxCinematics;

    if (m_LevelUnlock != None)
        m_LevelUnlock.SetSelectedIndex(Clamp(EPC.playerInfo.LevelUnlock, 0, m_LevelUnlock.List.Items.Count() - 1));

    if (m_bWhistle != None)
        m_bWhistle.m_bSelected = EPC.bWhistle;

    if (m_bF2000ZoomLevels != None)
        m_bF2000ZoomLevels.m_bSelected = EPC.bF2000ZoomLevels;

    if (m_bLaserMicZoomLevels != None)
        m_bLaserMicZoomLevels.m_bSelected = EPC.bLaserMicZoomLevels;

    if (m_bBurstFire != None)
        m_bBurstFire.m_bSelected = EPC.bBurstFire;

    if (m_bPS2FN7Accuracy != None)
        m_bPS2FN7Accuracy.m_bSelected = EPC.eGame.bPS2FN7Accuracy;

    if (m_bNewDoorInteraction != None)
        m_bNewDoorInteraction.m_bSelected = EPC.eGame.bNewDoorInteraction;

    if (m_bRandomizeLockpick != None)
        m_bRandomizeLockpick.m_bSelected = EPC.eGame.bRandomizeLockpick;

    if (m_bOpticCableVisions != None)
        m_bOpticCableVisions.m_bSelected = EPC.eGame.bOpticCableVisions;

    if (m_bThermalOverride != None)
        m_bThermalOverride.m_bSelected = EPC.eGame.bThermalOverride;
       
    if (m_bScaleGadgetDamage != None)
        m_bScaleGadgetDamage.m_bSelected = EPC.eGame.bScaleGadgetDamage;

    if (m_MineDelay != None)
        m_MineDelay.SetSelectedIndex(Clamp(EPC.eGame.WallMineDelay, 0, m_MineDelay.List.Items.Count() - 1));

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
            // Gray out keypad goal if current goal is disabled
            m_bShowKeypadGoal.bDisabled = !EPC.bShowCurrentGoal;
        }
    }

    if (m_bShowKeypadGoal != None)
        m_bShowKeypadGoal.m_bSelected = EPC.bShowKeyPadGoal;

    if (m_bShowMissionInformation != None)
        m_bShowMissionInformation.m_bSelected = EPC.bShowMissionInformation;

    if (m_bShowCrosshair != None)
        m_bShowCrosshair.m_bSelected = EPC.bShowCrosshair;

    if (m_bShowScope != None)
        m_bShowScope.m_bSelected = EPC.bShowScope;

    if (m_bShowAlarms != None)
        m_bShowAlarms.m_bSelected = EPC.bShowAlarms;

    if (m_TrainingSamMesh != None)
        m_TrainingSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_Training, 0, m_TrainingSamMesh.List.Items.Count() - 1));
        
    if (m_TbilisiSamMesh != None)
        m_TbilisiSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_Tbilisi, 0, m_TbilisiSamMesh.List.Items.Count() - 1));

    if (m_DefenseMinistrySamMesh != None)
        m_DefenseMinistrySamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_DefenseMinistry, 0, m_DefenseMinistrySamMesh.List.Items.Count() - 1));

    if (m_CaspianOilRefinerySamMesh != None)
        m_CaspianOilRefinerySamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_CaspianOilRefinery, 0, m_CaspianOilRefinerySamMesh.List.Items.Count() - 1));
        
    if (m_CIASamMesh != None)
        m_CIASamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_CIA, 0, m_CIASamMesh.List.Items.Count() - 1));

    if (m_KalinatekSamMesh != None)
        m_KalinatekSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_Kalinatek, 0, m_KalinatekSamMesh.List.Items.Count() - 1));

    if (m_ChineseEmbassySamMesh != None)
        m_ChineseEmbassySamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_ChineseEmbassy, 0, m_ChineseEmbassySamMesh.List.Items.Count() - 1));

    if (m_AbattoirSamMesh != None)
        m_AbattoirSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_Abattoir, 0, m_AbattoirSamMesh.List.Items.Count() - 1));
        
    if (m_ChineseEmbassy2SamMesh != None)
        m_ChineseEmbassy2SamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_ChineseEmbassy2, 0, m_ChineseEmbassy2SamMesh.List.Items.Count() - 1));

    if (m_PresidentialPalaceSamMesh != None)
        m_PresidentialPalaceSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_PresidentialPalace, 0, m_PresidentialPalaceSamMesh.List.Items.Count() - 1));

    if (m_KolaCellSamMesh != None)
        m_KolaCellSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_KolaCell, 0, m_KolaCellSamMesh.List.Items.Count() - 1));
        
    if (m_VselkaSamMesh != None)
        m_VselkaSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_Vselka, 0, m_VselkaSamMesh.List.Items.Count() - 1));

    if (m_PowerPlantSamMesh != None)
        m_PowerPlantSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_PowerPlant, 0, m_PowerPlantSamMesh.List.Items.Count() - 1));
        
    if (m_SeveronickelSamMesh != None)
        m_SeveronickelSamMesh.SetSelectedIndex(Clamp(EPC.eGame.ESam_Severonickel, 0, m_SeveronickelSamMesh.List.Items.Count() - 1));
    
	m_bModified = false;
	m_bFirstRefresh = false;
}
