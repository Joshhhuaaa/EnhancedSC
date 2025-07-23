//=============================================================================
//  EPCVideoConfigArea.uc : Area containing controls for video settings
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/25 * Created by Alexandre Dionne
//=============================================================================


class EPCVideoConfigArea extends UWindowDialogClientWindow;

var EPCOptionsListBoxEnhanced m_ListBox;

var EPCHScrollBar       m_GammaScroll, m_BrightnessScroll;

var EPCComboControl     m_ComboResolution;
var EPCComboControl     m_ComboShadowResolution;
var EPCComboControl     m_ComboShadow;
var EPCComboControl     m_ComboTerrain;
var EPCComboControl     m_ComboEffectsQuality;

var EPCComboControl     m_ComboTurnOffDistanceScale;
var EPCComboControl     m_ComboLODDistance;
var EPCComboControl     m_ComboPauseOnFocusLoss;

var INT                     m_ILabelXPos, m_ILabelWidth, m_ILineItemHeight, m_ITitleLineItemHeight, m_IScrollWidth;

var bool                    m_bModified;    //A setting has changed
var bool					m_bFirstRefresh;

function Created()
{
    SetAcceptsFocus();
	
    m_ListBox = EPCOptionsListBoxEnhanced(CreateWindow(class'EPCOptionsListBoxEnhanced', 0, 0, WinWidth, WinHeight));            
    m_ListBox.SetAcceptsFocus();
    m_ListBox.bAlwaysBehind = true;
    m_ListBox.m_ILabelXPos = m_ILabelXPos;
    m_ListBox.m_ILabelWidth = m_ILabelWidth;
    m_ListBox.m_ILineItemHeight = m_ILineItemHeight;
    m_ListBox.m_ITitleLineItemHeight = m_ITitleLineItemHeight;
    InitVideoOptions();
    m_ListBox.TitleFont=F_Normal;
}

function InitVideoOptions()
{
	local EPCGameOptions GO;  
	
    GO = class'Actor'.static.GetGameOptions();

    AddTitleLineItem();

    // Resolution combo box
    AddComboBoxItem("RESOLUTION", m_ComboResolution);
    InitResolutionCombo(m_ComboResolution, GO);
    AddLineItem();

    // Shadow resolution combo box
    AddComboBoxItem("SHADOWRES", m_ComboShadowResolution);
    InitShadowResolutionCombo(m_ComboShadowResolution, GO);
    AddLineItem();

    // Shadow distance Scale combo box
    AddEnhancedComboBoxItem("TurnOffDistanceScale", m_ComboTurnOffDistanceScale);
    InitTurnOffDistanceScaleCombo(m_ComboTurnOffDistanceScale);
    AddLineItem();

    // Shadow quality combo box
    AddComboBoxItem("SHADOWS", m_ComboShadow);
    InitShadowCombo(m_ComboShadow);
    AddLineItem();

    // Effects quality combo box
    AddComboBoxItem("EFFECTSQUALITY", m_ComboEffectsQuality);
    InitEffectsQualityCombo(m_ComboEffectsQuality, GO);
    AddLineItem();

    // LOD Distance combo box
    AddEnhancedComboBoxItem("LODDistance", m_ComboLODDistance);
    InitLODDistanceCombo(m_ComboLODDistance);
    AddLineItem();

    // Pause on Focus Loss combo box
    AddEnhancedComboBoxItem("PauseOnFocusLoss", m_ComboPauseOnFocusLoss);
    InitPauseOnFocusLossCombo(m_ComboPauseOnFocusLoss);
    AddLineItem();

    // Gamma scroll bar
    AddScrollBarItem("GAMMA", m_GammaScroll);
    InitGammaScrollBar(m_GammaScroll);
    AddLineItem();

    // Brightness scroll bar
    AddScrollBarItem("BRIGHTNESS", m_BrightnessScroll);
    InitBrightnessScrollBar(m_BrightnessScroll);
    AddLineItem();
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

function AddTitleLineItem()
{
    local EPCEnhancedListBoxItem NewItem;
    
    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(m_ListBox.ListClass));
    NewItem.bIsTitleLine = true;
    NewItem.m_bIsNotSelectable = true;
}

function AddComboBoxItem(string LocalizationKey, out EPCComboControl ComboBox)
{
    local EPCEnhancedListBoxItem NewItem;
    
    ComboBox = EPCComboControl(CreateControl(class'EPCComboControl', 0, 0, 150, 18));
    ComboBox.SetFont(F_Normal);
    ComboBox.SetEditable(False);

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    // Joshua - Enhanced settings use different Localization file

    NewItem.Caption = Localize("HUD", LocalizationKey, "Localization\\HUD");

    NewItem.m_Control = ComboBox;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ComboBox;
}

function AddEnhancedComboBoxItem(string LocalizationKey, out EPCComboControl ComboBox)
{
    local EPCEnhancedListBoxItem NewItem;
    
    ComboBox = EPCComboControl(CreateControl(class'EPCComboControl', 0, 0, 150, 18));
    ComboBox.SetFont(F_Normal);
    ComboBox.SetEditable(False);

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    // Joshua - Enhanced settings use different Localization file

    NewItem.Caption = Localize("Graphics", LocalizationKey, "Localization\\Enhanced");

    NewItem.m_Control = ComboBox;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ComboBox;
}

function AddScrollBarItem(string LocalizationKey, out EPCHScrollBar ScrollBar)
{
    local EPCEnhancedListBoxItem NewItem;
    
    ScrollBar = EPCHScrollBar(CreateControl(class'EPCHScrollBar', 0, 0, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight));
    ScrollBar.SetScrollHeight(12);

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("HUD", LocalizationKey, "Localization\\HUD");
    NewItem.m_Control = ScrollBar;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ScrollBar;
}

function InitResolutionCombo(EPCComboControl ComboBox, EPCGameOptions GO)
{
    ComboBox.AddItem("640x480");
    if (GO.VidMem != 0)
    {
        ComboBox.AddItem("800x600");
        ComboBox.AddItem("1024x768");
        ComboBox.AddItem("1280x1024");
    }
    if (GO.VidMem == 2)
    {
        ComboBox.AddItem("1600x1200");
    }
    ComboBox.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));
}

function InitShadowResolutionCombo(EPCComboControl ComboBox, EPCGameOptions GO)
{
    ComboBox.AddItem(Localize("HUD","LOW","Localization\\HUD"));
    ComboBox.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));
    if (GO.VidMem == 2)
    {
        ComboBox.AddItem(Localize("HUD","HIGH","Localization\\HUD"));
    }
    ComboBox.SetSelectedIndex(0);
}

function InitShadowCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("HUD","LOW","Localization\\HUD"));
    ComboBox.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));
    ComboBox.AddItem(Localize("HUD","HIGH","Localization\\HUD"));     
    ComboBox.SetSelectedIndex(0);
}

function InitEffectsQualityCombo(EPCComboControl ComboBox, EPCGameOptions GO)
{
    ComboBox.AddItem(Localize("HUD","LOW","Localization\\HUD"));
    ComboBox.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));
    if (GO.VidMem != 0)
    {
        ComboBox.AddItem(Localize("HUD","HIGH","Localization\\HUD")); 
    }
    if (GO.VidMem == 2)
    {    
        ComboBox.AddItem(Localize("HUD","VERYHIGH","Localization\\HUD"));  
    }   
    ComboBox.SetSelectedIndex(0);
}

function InitGammaScrollBar(EPCHScrollBar ScrollBar)
{
    ScrollBar.SetRange(0, 100, 1);
}

function InitBrightnessScrollBar(EPCHScrollBar ScrollBar)
{
    ScrollBar.SetRange(0, 100, 1);
}

function InitTurnOffDistanceScaleCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Graphics","TurnOffDistanceScale_1x","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Graphics","TurnOffDistanceScale_2x","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Graphics","TurnOffDistanceScale_4x","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Graphics","TurnOffDistanceScale_8x","Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function InitLODDistanceCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Graphics","LODDistance_Default","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Graphics","LODDistance_Enhanced","Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function InitPauseOnFocusLossCombo(EPCComboControl ComboBox)
{
    ComboBox.AddItem(Localize("Graphics","PauseOnFocusLoss_Disable","Localization\\Enhanced"));
    ComboBox.AddItem(Localize("Graphics","PauseOnFocusLoss_Enable","Localization\\Enhanced"));
    ComboBox.SetSelectedIndex(0);
}

function Refresh()
{
    local EPCGameOptions GO;  
    local EPlayerController EPC;
	
    GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

	m_GammaScroll.Pos = Clamp(GO.Gamma,0,99);	
	m_BrightnessScroll.Pos = Clamp(GO.Brightness,0,99);    
	
    m_ComboResolution.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));
    m_ComboShadowResolution.SetSelectedIndex(Clamp(GO.ShadowResolution,0,m_ComboShadowResolution.List.Items.Count()));    
    m_ComboShadow.SetSelectedIndex(Clamp(GO.ShadowLevel,0,m_ComboShadow.List.Items.Count() -1));        
    m_ComboEffectsQuality.SetSelectedIndex(Clamp(GO.EffectsQuality,0,m_ComboEffectsQuality.List.Items.Count() -1));            
    
    if (m_ComboTurnOffDistanceScale != None && EPC != None)
        m_ComboTurnOffDistanceScale.SetSelectedIndex(Clamp(EPC.eGame.TurnOffDistanceScale, 0, m_ComboTurnOffDistanceScale.List.Items.Count() - 1));

    if (m_ComboLODDistance != None && EPC != None)
        m_ComboLODDistance.SetSelectedIndex(Clamp(int(EPC.eGame.bLODDistance), 0, m_ComboLODDistance.List.Items.Count() - 1));

    if (m_ComboPauseOnFocusLoss != None && EPC != None)
        m_ComboPauseOnFocusLoss.SetSelectedIndex(Clamp(int(EPC.eGame.bPauseOnFocusLoss), 0, m_ComboPauseOnFocusLoss.List.Items.Count() - 1));

	m_bModified     = false;
	m_bFirstRefresh = false;
}

function ResetToDefault()
{
    local EPCGameOptions GO; 
    local EPlayerController EPC;
    local string oldRes;

	GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());
    
	GO.oldResolution = GO.Resolution;
	GO.oldEffectsQuality = GO.EffectsQuality;
	GO.oldShadowResolution = GO.ShadowResolution;

	GO.ResetGraphicsToDefault();
	GO.UpdateEngineSettings();   

    // Enhanced settings
    EPC.eGame.TurnOffDistanceScale = EPC.eGame.default.TurnOffDistanceScale;
    EPC.eGame.bLODDistance = EPC.eGame.default.bLODDistance;
    EPC.eGame.bPauseOnFocusLoss = EPC.eGame.default.bPauseOnFocusLoss;
    EPC.eGame.SaveEnhancedOptions();

	Refresh(); 
}

function SaveOptions()
{
    local EPCGameOptions GO;    
    local EPlayerController EPC; // Joshua - Used for Enhanced settings
	
    GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

    GO.Resolution = m_ComboResolution.GetValue();
    GO.ShadowResolution = m_ComboShadowResolution.GetSelectedIndex();    
    GO.ShadowLevel = m_ComboShadow.GetSelectedIndex();        
    GO.EffectsQuality = m_ComboEffectsQuality.GetSelectedIndex();        

	GO.Brightness = m_BrightnessScroll.Pos;
	GO.Gamma   = m_GammaScroll.Pos;
	
    // Enhanced settings
    switch (m_ComboTurnOffDistanceScale.GetSelectedIndex())
    {
        case 0: EPC.eGame.TurnOffDistanceScale = TurnOffDistance_1x; break;
        case 1: EPC.eGame.TurnOffDistanceScale = TurnOffDistance_2x; break;
        case 2: EPC.eGame.TurnOffDistanceScale = TurnOffDistance_4x; break;
        case 3: EPC.eGame.TurnOffDistanceScale = TurnOffDistance_8x; break;
        default: EPC.eGame.TurnOffDistanceScale = TurnOffDistance_1x; break;
    }

    switch (m_ComboLODDistance.GetSelectedIndex())
    {
        case 0: EPC.eGame.bLODDistance = false; break;
        case 1: EPC.eGame.bLODDistance = true; break;
        default: EPC.eGame.bLODDistance = false; break;
    }

    switch (m_ComboPauseOnFocusLoss.GetSelectedIndex())
    {
        case 0: EPC.eGame.bPauseOnFocusLoss = false; break;
        case 1: EPC.eGame.bPauseOnFocusLoss = true; break;
        default: EPC.eGame.bPauseOnFocusLoss = false; break;
    }

    EPC.eGame.SaveEnhancedOptions();
}

function Notify(UWindowDialogControl C, byte E)
{
    if(E == DE_Change)
    {
        switch(C)
        {
        case m_ComboResolution: 
        case m_ComboShadowResolution:        
        case m_ComboShadow:
		case m_GammaScroll:
		case m_BrightnessScroll:
		case m_ComboEffectsQuality:
        case m_ComboTurnOffDistanceScale:
        case m_ComboLODDistance:
        case m_ComboPauseOnFocusLoss:
            m_bModified = true;
            break;
        }
    }
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
    CloseActiveComboBoxes();
    if(m_ListBox != None)
        m_ListBox.MouseWheelDown(X, Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    CloseActiveComboBoxes();
    if(m_ListBox != None)
        m_ListBox.MouseWheelUp(X, Y);
}

function CloseActiveComboBoxes()
{
    if(m_ListBox != None)
        m_ListBox.CloseActiveComboBoxes();
}

defaultproperties
{
    m_ILabelXPos=15
    m_ILabelWidth=250
    m_IScrollWidth=190
    m_ITitleLineItemHeight=2
    m_ILineItemHeight=8
}