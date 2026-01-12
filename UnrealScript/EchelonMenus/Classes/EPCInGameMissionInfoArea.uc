//=============================================================================
//  EPCInGameMissionInfoArea.uc : Area containing goals, data and notes
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/05 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameMissionInfoArea extends UWindowDialogClientWindow;

var EPCTextButton   m_GoalsButton, m_NotesButton, m_DataButton;
var INT             m_IFirstButtonsXPos, m_IXButtonOffset, m_IButtonsHeight, m_IButtonsWidth, m_IButtonsYPos;


var EPCInGameGoalsArea m_GoalsArea;
var EPCInGameDataArea  m_DataArea;

var INT                   m_IAreaXPos, m_IAreaYPos,m_IAreaWidth,m_IAreaHeight;

// Joshua - Controller navigation state
var bool m_bAreaEnabled;    // Area is active (we have focus from parent)
var bool m_bInContent;      // True = navigating within content, False = tab selection
var int m_selectedTab;      // 0=Goals, 1=Notes, 2=Data

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    SetAcceptsFocus();  // Joshua - Enable controller input

    m_GoalsButton = EPCTextButton(CreateControl(class'EPCTextButton', m_IFirstButtonsXPos, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_NotesButton = EPCTextButton(CreateControl(class'EPCTextButton', m_GoalsButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_DataButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_NotesButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));

    m_GoalsButton.SetButtonText(Caps(Localize("HUD","GOALS","Localization\\HUD"))    ,TXT_CENTER);
    m_NotesButton.SetButtonText(Caps(Localize("HUD","NOTES","Localization\\HUD"))    ,TXT_CENTER);
    m_DataButton.SetButtonText(Caps(Localize("HUD","RECONS","Localization\\HUD"))    ,TXT_CENTER);

    m_GoalsButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;
    m_NotesButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;
    m_DataButton.Font       = EPCMainMenuRootWindow(Root).TitleFont;

    m_GoalsArea   = EPCInGameGoalsArea(CreateWindow(class'EPCInGameGoalsArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight,self));
    m_DataArea    = EPCInGameDataArea(CreateWindow(class'EPCInGameDataArea', m_GoalsArea.WinLeft, m_GoalsArea.WinTop, m_GoalsArea.WinWidth, m_GoalsArea.WinHeight, self));

    ChangeMenuSection(m_GoalsButton);
}

function Paint(Canvas C, float X, float Y)
{
	local EPlayerController EPC;

	EPC = EPlayerController(GetPlayerOwner());

	if (EPC != None)
	{
		if (m_GoalsArea.WindowIsVisible() && m_GoalsArea.m_bGoals)
			EPC.bNewGoal = false;
		if (m_GoalsArea.WindowIsVisible() && !m_GoalsArea.m_bGoals)
			EPC.bNewNote = false;
		if (m_DataArea.WindowIsVisible())
			EPC.bNewRecon = false;
	}

	Super.Paint(C, X, Y);
    // Joshua - Controller prompts (A/B) are handled by EPCInGameMenu parent
}

function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_GoalsButton:
        case m_NotesButton:
        case m_DataButton:
            ChangeMenuSection(UWindowButton(C));
            break;

        }
    }
}


function ChangeMenuSection(UWindowButton _SelectMe)
{
    m_GoalsButton.m_bSelected   =  false;
    m_NotesButton.m_bSelected   =  false;
    m_DataButton.m_bSelected    =  false;

    m_GoalsArea.HideWindow();
    m_DataArea.HideWindow();

    switch (_SelectMe)
    {
    case m_GoalsButton:
        m_GoalsButton.m_bSelected    =  true;
        m_GoalsArea.ShowWindow();
        m_GoalsArea.ShowGoals(true);
        m_selectedTab = 0;  // Joshua - Keep m_selectedTab in sync
        break;
    case m_NotesButton:
        m_NotesButton.m_bSelected     =  true;
        m_GoalsArea.ShowWindow();
        m_GoalsArea.ShowGoals(false);
        m_selectedTab = 1;  // Joshua - Keep m_selectedTab in sync
        break;
    case m_DataButton:
        m_DataButton.m_bSelected     =  true;
        m_DataArea.ShowWindow();
        m_selectedTab = 2;  // Joshua - Keep m_selectedTab in sync
        // Joshua - Clear selection in controller mode until user presses A to enter content
        if (EPCMainMenuRootWindow(Root).m_bControllerModeActive && !m_bInContent)
            m_DataArea.ClearSelection();
        break;
    }
}

function SelectArea(bool bNewGoal, bool bNewNote, bool bNewRecon)
{
	if (bNewGoal)
		ChangeMenuSection(m_GoalsButton);
	else if (bNewNote)
		ChangeMenuSection(m_NotesButton);
	else if (bNewRecon)
		ChangeMenuSection(m_DataButton);
}

function Reset()
{
    m_GoalsArea.Init();
    m_DataArea.FillListBox();
    // Joshua - Clear selection in controller mode until user presses A
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
        m_DataArea.ClearSelection();

	// Reselect last selected
	if (m_DataButton.m_bSelected)
		ChangeMenuSection(m_DataButton);
	else if (m_NotesButton.m_bSelected)
		ChangeMenuSection(m_NotesButton);
	else
		ChangeMenuSection(m_GoalsButton);
}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    m_bAreaEnabled = bEnable;

    if (bEnable)
    {
        // Start at tab selection level
        m_bInContent = false;

        // Restore tab selection visual when entering (m_selectedTab is already in sync)
        UpdateTabSelection();
    }
    else
    {
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
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
    m_GoalsButton.m_bSelected = false;
    m_NotesButton.m_bSelected = false;
    m_DataButton.m_bSelected = false;
}

// Joshua - Restore tab selection based on m_selectedTab (when switching to keyboard/mouse)
function RestoreTabSelection()
{
    UpdateTabSelection();
}

// Joshua - Check if current tab has scrollable content
function bool HasCurrentTabContent()
{
    switch (m_selectedTab)
    {
        case 0:  // Goals
            return (m_GoalsArea.m_IGoalNbScroll > 0);
        case 1:  // Notes
            return (m_GoalsArea.m_INoteNbScroll > 0);
        case 2:  // Data
            return (m_DataArea.m_ListBox.Items.Count() > 0);
        default:
            return false;
    }
}

// Joshua - Called when mouse clicks on a data item, sync controller state
function OnDataItemClicked()
{
    if (m_selectedTab == 2)  // Data tab
    {
        m_bInContent = true;
    }
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    // Don't process controller input when area is not enabled
    // Still let mouse/paint events through
    if (!m_bAreaEnabled)
    {
        // Block controller keys when area is not enabled
        if (Msg == WM_KeyDown && Key >= 196 && Key <= 215)
            return;

        Super.WindowEvent(Msg, C, X, Y, Key);
        return;
    }

    // Handle B button before Super to prevent any parent from processing it
    if (Msg == WM_KeyDown && Key == 201)
    {
        if (m_bInContent)
        {
            // Inside content - go back to tab level
            m_bInContent = false;
            // Stop auto-repeat
            m_heldKey = 0;
            m_keyHoldTime = 0;
            // Clear selection in data area when exiting with B (only if on Data tab)
            if (m_selectedTab == 2)
            {
                m_DataArea.ClearSelection();
            }
            Root.PlayClickSound();
        }
        else
        {
            // At tab level - exit to section selection
            // Also clear data selection when leaving the entire area
            m_DataArea.ClearSelection();
            Root.PlayClickSound();
            EPCInGameMenu(ParentWindow).SectionExited();
        }
        return;  // Don't let B reach any parent
    }

    // Let parent handle window events
    Super.WindowEvent(Msg, C, X, Y, Key);

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

    // Handle other controller input on KeyDown
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

        HandleKeyAction(Key);
    }
}

// Joshua - Process a key action (called on initial press and during auto-repeat)
function HandleKeyAction(int Key)
{
    if (m_bInContent)
    {
        // Inside content - handle scrolling
        // Up - scroll up
        if (Key == 212 || Key == 196)
        {
            if (m_selectedTab == 0 || m_selectedTab == 1)
            {
                // Goals/Notes - scroll
                if (m_GoalsArea.m_ScrollBar != None && m_GoalsArea.m_ScrollBar.Pos > m_GoalsArea.m_ScrollBar.MinPos)
                {
                    m_GoalsArea.m_ScrollBar.Scroll(-1);
                    Root.PlayClickSound();
                }
            }
            else if (m_selectedTab == 2)
            {
                // Data - navigate list (handled by DataArea)
                m_DataArea.NavigateUp();
            }
        }
        // Down - scroll down
        else if (Key == 213 || Key == 197)
        {
            if (m_selectedTab == 0 || m_selectedTab == 1)
            {
                // Goals/Notes - scroll
                if (m_GoalsArea.m_ScrollBar != None && m_GoalsArea.m_ScrollBar.Pos < m_GoalsArea.m_ScrollBar.MaxPos)
                {
                    m_GoalsArea.m_ScrollBar.Scroll(1);
                    Root.PlayClickSound();
                }
            }
            else if (m_selectedTab == 2)
            {
                // Data - navigate list (handled by DataArea)
                m_DataArea.NavigateDown();
            }
        }
        // A button - activate item (Data tab only)
        else if (Key == 200)
        {
            if (m_selectedTab == 2)
            {
                // Joshua - Clear held key state so direction isn't carried into details view
                m_heldKey = 0;
                m_keyHoldTime = 0;
                m_nextRepeatTime = 0;
                m_DataArea.ActivateSelected();
            }
        }
    }
    else
    {
        // At tab level - handle tab navigation with wrap-around
        // Left - previous tab (wrap from Goals to Data)
        if (Key == 214 || Key == 198)
        {
            m_selectedTab = (m_selectedTab - 1 + 3) % 3;
            UpdateTabSelection();
            Root.PlayClickSound();
        }
        // Right - next tab (wrap from Data to Goals)
        else if (Key == 215 || Key == 199)
        {
            m_selectedTab = (m_selectedTab + 1) % 3;
            UpdateTabSelection();
            Root.PlayClickSound();
        }
        // A - enter content (only if tab has content to scroll/navigate)
        else if (Key == 200)
        {
            if (HasCurrentTabContent())
            {
                m_bInContent = true;
                Root.PlayClickSound();

                // If Data tab, restore selection (remembers position from last time)
                if (m_selectedTab == 2)
                {
                    m_DataArea.RestoreSelection();
                }
            }
        }
    }
}

// Joshua - Tick function for auto-repeat scrolling and tab navigation
function Tick(float Delta)
{
    Super.Tick(Delta);

    if (!m_bAreaEnabled || m_heldKey == 0)
        return;

    // Skip auto-repeat for content scrolling if not in content
    // But allow tab navigation auto-repeat when at tab level
    if (m_bInContent)
    {
        // Only repeat up/down for content
        if (m_heldKey != 212 && m_heldKey != 196 && m_heldKey != 213 && m_heldKey != 197)
            return;
    }
    else
    {
        // Only repeat left/right for tabs
        if (m_heldKey != 214 && m_heldKey != 198 && m_heldKey != 215 && m_heldKey != 199)
            return;
    }

    m_keyHoldTime += Delta;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        HandleKeyAction(m_heldKey);
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

function UpdateTabSelection()
{
    switch (m_selectedTab)
    {
        case 0:
            ChangeMenuSection(m_GoalsButton);
            break;
        case 1:
            ChangeMenuSection(m_NotesButton);
            break;
        case 2:
            ChangeMenuSection(m_DataButton);
            break;
    }
}

defaultproperties
{
    m_IFirstButtonsXPos=6
    m_IXButtonOffset=148
    m_IButtonsHeight=18
    m_IButtonsWidth=144
    m_IButtonsYPos=5
    m_IAreaXPos=7
    m_IAreaYPos=37
    m_IAreaWidth=434
    m_IAreaHeight=206
    m_initialDelay=0.5
    m_repeatRate=0.1
}