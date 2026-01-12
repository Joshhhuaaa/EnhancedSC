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

// Joshua - Label for each of the scroll bars
var UWindowLabelControl m_LGammaValue;
var UWindowLabelControl m_LBrightnessValue;

var EPCComboControl     m_ComboResolution;
var EPCComboControl     m_ComboShadowResolution;
var EPCComboControl     m_ComboShadow;
var EPCComboControl     m_ComboTerrain;
var EPCComboControl     m_ComboEffectsQuality;

var EPCComboControl     m_ComboTurnOffDistanceScale;
var EPCComboControl     m_ComboLODDistance;
//var EPCComboControl     m_ComboPauseOnFocusLoss;

var INT                     m_ILabelXPos, m_ILabelWidth, m_ILineItemHeight, m_ITitleLineItemHeight, m_IScrollWidth;

var bool                    m_bModified;    //A setting has changed
var bool					m_bFirstRefresh;

// Joshua - Original value for LODDistance (requires restart)
var int                     m_OriginalLODDistance;

// Joshua - Controller navigation
var bool    m_bEnableArea;          // True when area is active for controller navigation
var int     m_selectedItemIndex;    // Currently selected item index
var int     m_totalItems;           // Total selectable items (8)
var bool    m_bSliderFocused;       // True when a slider is focused for adjustment
var bool    m_bComboFocused;        // True when combo box is focused
var EPCComboControl m_ActiveCombo;  // Currently focused combo box

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    SetAcceptsFocus();

    // Joshua - Initialize controller navigation
    m_totalItems = 8;
    m_bEnableArea = false;
    m_selectedItemIndex = 0;
    m_bSliderFocused = false;
    m_bComboFocused = false;
    m_ActiveCombo = None;

    m_ListBox = EPCOptionsListBoxEnhanced(CreateWindow(class'EPCOptionsListBoxEnhanced', 0, 0, WinWidth, WinHeight));
    m_ListBox.SetAcceptsFocus();
    m_ListBox.bAlwaysBehind = true;
    m_ListBox.m_ILabelXPos = m_ILabelXPos;
    m_ListBox.m_ILabelWidth = m_ILabelWidth;
    m_ListBox.m_ILineItemHeight = m_ILineItemHeight;
    m_ListBox.m_ITitleLineItemHeight = m_ITitleLineItemHeight;
    InitVideoOptions();
    m_ListBox.TitleFont = F_Normal;
}

function InitVideoOptions()
{
	local EPCGameOptions GO;

    GO = class'Actor'.static.GetGameOptions();

    AddTitleLineItem();

    AddComboBoxItem("RESOLUTION", m_ComboResolution);
    InitResolutionCombo(m_ComboResolution, GO);
    AddLineItem();

    AddComboBoxItem("SHADOWRES", m_ComboShadowResolution);
    InitShadowResolutionCombo(m_ComboShadowResolution, GO);
    AddLineItem();

    AddEnhancedComboBoxItem("TurnOffDistanceScale", m_ComboTurnOffDistanceScale);
    InitTurnOffDistanceScaleCombo(m_ComboTurnOffDistanceScale);
    AddLineItem();

    AddComboBoxItem("SHADOWS", m_ComboShadow);
    InitShadowCombo(m_ComboShadow);
    AddLineItem();

    AddComboBoxItem("EFFECTSQUALITY", m_ComboEffectsQuality);
    InitEffectsQualityCombo(m_ComboEffectsQuality, GO);
    AddLineItem();

    AddEnhancedComboBoxItem("LODDistance", m_ComboLODDistance);
    InitLODDistanceCombo(m_ComboLODDistance);
    AddLineItem();

    //AddEnhancedComboBoxItem("PauseOnFocusLoss", m_ComboPauseOnFocusLoss);
    //InitPauseOnFocusLossCombo(m_ComboPauseOnFocusLoss);
    //AddLineItem();

    AddScrollBarItem("BRIGHTNESS", m_BrightnessScroll);
    InitBrightnessScrollBar(m_BrightnessScroll);
    AddLineItem();

    // Joshua - Move Gamma (actually adjusts Contrast) to appear after Brightness
    AddScrollBarItem("CONTRAST", m_GammaScroll);
    InitGammaScrollBar(m_GammaScroll);
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
    local UWindowLabelControl ValueLabel;

    ScrollBar = EPCHScrollBar(CreateControl(class'EPCHScrollBar', 0, 0, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight));
    ScrollBar.SetScrollHeight(12);

    // Joshua - Create value label for scrollbar
    ValueLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 0, 0, 40, 18));
    ValueLabel.Font = F_Normal;
    ValueLabel.TextColor.R = 71;
    ValueLabel.TextColor.G = 71;
    ValueLabel.TextColor.B = 71;
    ValueLabel.TextColor.A = 255;
    ValueLabel.SetLabelText("0", TXT_LEFT);

    // Store references to value labels
    if (LocalizationKey == "CONTRAST") // Joshua - Ubisoft mislabeled this as Gamma, it actually controls Contrast in SplinterCell.ini
        m_LGammaValue = ValueLabel;
    else if (LocalizationKey == "BRIGHTNESS")
        m_LBrightnessValue = ValueLabel;

    NewItem = EPCEnhancedListBoxItem(m_ListBox.Items.Append(class'EPCEnhancedListBoxItem'));
    NewItem.Caption = Localize("HUD", LocalizationKey, "Localization\\HUD");
    NewItem.m_Control = ScrollBar;
    NewItem.m_bIsNotSelectable = true;

    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ScrollBar;
    m_ListBox.m_Controls[m_ListBox.m_Controls.Length] = ValueLabel;
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
    ScrollBar.SetRange(0, 101, 1); // Joshua - Set 101 instead of 100 for full 0-100, instead of 0-99 slider
}

function InitBrightnessScrollBar(EPCHScrollBar ScrollBar)
{
    ScrollBar.SetRange(0, 101, 1); // Joshua - Set 101 instead of 100 for full 0-100, instead of 0-99 slider
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

//function InitPauseOnFocusLossCombo(EPCComboControl ComboBox)
//{
//    ComboBox.AddItem(Localize("Graphics","PauseOnFocusLoss_Disable","Localization\\Enhanced"));
//    ComboBox.AddItem(Localize("Graphics","PauseOnFocusLoss_Enable","Localization\\Enhanced"));
//    ComboBox.SetSelectedIndex(0);
//}

function Refresh()
{
    local EPCGameOptions GO;
    local EPlayerController EPC;

    GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

	m_GammaScroll.Pos = Clamp(GO.Gamma,0,100); // Joshua - Set 99 clamp to be 100 instead for full 0.0 to 1.0 range
	m_BrightnessScroll.Pos = Clamp(GO.Brightness,0,100); // Joshua - Set 99 clamp to be 100 instead for full 0.0 to 1.0 range

    // Joshua - Update value labels for scrollbars
    if (m_LGammaValue != None)
        m_LGammaValue.SetLabelText(string(int(m_GammaScroll.Pos)), TXT_LEFT);
    if (m_LBrightnessValue != None)
        m_LBrightnessValue.SetLabelText(string(int(m_BrightnessScroll.Pos)), TXT_LEFT);

    m_ComboResolution.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));
    m_ComboShadowResolution.SetSelectedIndex(Clamp(GO.ShadowResolution,0,m_ComboShadowResolution.List.Items.Count()));
    m_ComboShadow.SetSelectedIndex(Clamp(GO.ShadowLevel,0,m_ComboShadow.List.Items.Count() -1));
    m_ComboEffectsQuality.SetSelectedIndex(Clamp(GO.EffectsQuality,0,m_ComboEffectsQuality.List.Items.Count() -1));

    if (m_ComboTurnOffDistanceScale != None && EPC != None)
        m_ComboTurnOffDistanceScale.SetSelectedIndex(Clamp(EPC.eGame.TurnOffDistanceScale, 0, m_ComboTurnOffDistanceScale.List.Items.Count() - 1));

    // Joshua - Store original value for LODDistance before setting combo (requires restart)
    m_OriginalLODDistance = int(EPC.eGame.bLODDistance);

    if (m_ComboLODDistance != None && EPC != None)
        m_ComboLODDistance.SetSelectedIndex(Clamp(int(EPC.eGame.bLODDistance), 0, m_ComboLODDistance.List.Items.Count() - 1));

    //if (m_ComboPauseOnFocusLoss != None && EPC != None)
    //    m_ComboPauseOnFocusLoss.SetSelectedIndex(Clamp(int(EPC.eGame.bPauseOnFocusLoss), 0, m_ComboPauseOnFocusLoss.List.Items.Count() - 1));

	m_bModified     = false;
	m_bFirstRefresh = false;
}

function ResetToDefault()
{
    local EPCGameOptions GO;
    local EPlayerController EPC;

	GO = class'Actor'.static.GetGameOptions();
    EPC = EPlayerController(GetPlayerOwner());

	GO.oldResolution = GO.Resolution;
	GO.oldEffectsQuality = GO.EffectsQuality;
	GO.oldShadowResolution = GO.ShadowResolution;

	GO.ResetGraphicsToDefault();
	GO.UpdateEngineSettings();

    // Enhanced settings
    EPC.eGame.TurnOffDistanceScale = TurnOffDistance_4x;
    EPC.eGame.ApplyTurnOffDistanceScale(EPC.eGame.TurnOffDistanceScale);
    EPC.eGame.bLODDistance = true; // EPC.eGame.default.bLODDistance;
    //EPC.eGame.bPauseOnFocusLoss = EPC.eGame.default.bPauseOnFocusLoss;
    EPC.eGame.SaveEnhancedOptions();

    // Joshua - Check if LODDistance changed from original (requires restart)
    if (int(EPC.eGame.bLODDistance) != m_OriginalLODDistance)
        EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "RestartRequired", "Localization\\Enhanced"), Localize("Common", "RestartRequiredWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);

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
        case 0:
            EPC.eGame.TurnOffDistanceScale = TurnOffDistance_1x;
            EPC.eGame.ApplyTurnOffDistanceScale(EPC.eGame.TurnOffDistanceScale);
            break;
        case 1:
            EPC.eGame.TurnOffDistanceScale = TurnOffDistance_2x;
            EPC.eGame.ApplyTurnOffDistanceScale(EPC.eGame.TurnOffDistanceScale);
            break;
        case 2:
            EPC.eGame.TurnOffDistanceScale = TurnOffDistance_4x;
            EPC.eGame.ApplyTurnOffDistanceScale(EPC.eGame.TurnOffDistanceScale);
            break;
        case 3:
            EPC.eGame.TurnOffDistanceScale = TurnOffDistance_8x;
            EPC.eGame.ApplyTurnOffDistanceScale(EPC.eGame.TurnOffDistanceScale);
            break;
        default:
            EPC.eGame.TurnOffDistanceScale = TurnOffDistance_1x;
            EPC.eGame.ApplyTurnOffDistanceScale(EPC.eGame.TurnOffDistanceScale);
            break;
    }

    switch (m_ComboLODDistance.GetSelectedIndex())
    {
        case 0: EPC.eGame.bLODDistance = false; break;
        case 1: EPC.eGame.bLODDistance = true; break;
        default: EPC.eGame.bLODDistance = false; break;
    }

    //switch (m_ComboPauseOnFocusLoss.GetSelectedIndex())
    //{
    //    case 0: EPC.eGame.bPauseOnFocusLoss = false; break;
    //    case 1: EPC.eGame.bPauseOnFocusLoss = true; break;
    //    default: EPC.eGame.bPauseOnFocusLoss = false; break;
    //}

    EPC.eGame.SaveEnhancedOptions();
}

function Notify(UWindowDialogControl C, byte E)
{
    if (E == DE_Change)
    {
        switch (C)
        {
        case m_ComboResolution:
        case m_ComboShadowResolution:
        case m_ComboShadow:
        case m_GammaScroll:
        case m_BrightnessScroll:
        case m_ComboEffectsQuality:
        case m_ComboTurnOffDistanceScale:
        //case m_ComboPauseOnFocusLoss:
            m_bModified = true;
            // Joshua - Update value labels for scrollbars
            if (C == m_GammaScroll && m_LGammaValue != None)
                m_LGammaValue.SetLabelText(string(int(m_GammaScroll.Pos)), TXT_LEFT);
            if (C == m_BrightnessScroll && m_LBrightnessValue != None)
                m_LBrightnessValue.SetLabelText(string(int(m_BrightnessScroll.Pos)), TXT_LEFT);
            break;
        case m_ComboLODDistance:
            m_bModified = true;
            if (m_ComboLODDistance.GetSelectedIndex() != m_OriginalLODDistance)
                EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "RestartRequired", "Localization\\Enhanced"), Localize("Common", "RestartRequiredWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);
            break;
        }
    }
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

// Joshua - Get combo box by index
function EPCComboControl GetComboAtIndex(int Index)
{
    switch (Index)
    {
        case 0: return m_ComboResolution;
        case 1: return m_ComboShadowResolution;
        case 2: return m_ComboTurnOffDistanceScale;
        case 3: return m_ComboShadow;
        case 4: return m_ComboEffectsQuality;
        case 5: return m_ComboLODDistance;
        default: return None;
    }
}

// Joshua - Get slider by index
function EPCHScrollBar GetSliderAtIndex(int Index)
{
    switch (Index)
    {
        case 6: return m_BrightnessScroll;
        case 7: return m_GammaScroll;
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
        Item.bSelected = true;

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
}

// Joshua - Handle controller input
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    local int ComboIndex;
    local EPCComboControl CurrentCombo;
    local EPCHScrollBar CurrentSlider;

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
                // A or B exits combo focus
                Root.PlayClickSound();
                m_bComboFocused = false;
                m_ActiveCombo.CloseUp();
                m_ActiveCombo = None;
            }
            return;
        }

        HandleNavigationInput(Key);
    }
}

// Joshua - Handle navigation input (for normal mode and auto-repeat)
function HandleNavigationInput(int Key)
{
    local EPCComboControl CurrentCombo;

    // DPadDown (213) or AnalogDown (197)
    if (Key == 213 || Key == 197)
    {
        if (m_selectedItemIndex < m_totalItems - 1)
        {
            Root.PlayClickSound();
            m_selectedItemIndex = m_selectedItemIndex + 1;
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
            HighlightSelectedItem(m_selectedItemIndex);
        }
        // At top - do nothing
    }
        else if (Key == 200) // A button
        {
            // A button - only activates combo boxes (sliders are controlled directly with left/right)
            if (m_selectedItemIndex <= 5)
            {
                // Combo box
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
            // Sliders: A button does nothing
        }
        else if (Key == 201) // B button
        {
            // B button - exit area
            Root.PlayClickSound();
            EnableArea(false);
            EPCOptionsMenu(OwnerWindow).AreaExited();
        }
        // DPadLeft (214) or AnalogLeft (198) - adjust slider
        else if (Key == 214 || Key == 198)
        {
            if (m_selectedItemIndex > 5) // Sliders are indices 6+
            {
                Root.PlayClickSound();
                AdjustSlider(m_selectedItemIndex, -1, Key);
            }
        }
        // DPadRight (215) or AnalogRight (199) - adjust slider
        else if (Key == 215 || Key == 199)
        {
            if (m_selectedItemIndex > 5) // Sliders are indices 6+
            {
                Root.PlayClickSound();
                AdjustSlider(m_selectedItemIndex, 1, Key);
            }
        }
}

// Joshua - Tick function to handle auto-repeat for held keys
function Tick(float Delta)
{
    Super.Tick(Delta);

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
    m_IScrollWidth=160 // Joshua - Reduced from 190 to fit the new label
    m_ITitleLineItemHeight=2
    m_ILineItemHeight=8
    m_initialDelay=0.5
    m_repeatRate=0.1
}