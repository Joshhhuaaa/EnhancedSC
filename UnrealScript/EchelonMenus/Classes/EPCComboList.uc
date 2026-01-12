//=============================================================================
//  EPCComboList.uc : Combo drop down list with echelon art style
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/22 * Created by Alexandre Dionne
//=============================================================================
class EPCComboList extends UWindowComboList
			native;

// Joshua - Track selected index for controller navigation
var int m_SelectedIndex;

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Paint(Canvas C, float X, float Y)
{
	local int Count;
	local UWindowComboListItem I;


    C.SetDrawColor(255, 255, 255);
    C.Style = GetLevel().ERenderStyle.STY_Normal;
    DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'WhiteTexture');
	Render(C, X, Y);

	Count = 0;

	for (I = UWindowComboListItem(Items.Next);I != None; I = UWindowComboListItem(I.Next))
	{
		if (VertSB.bWindowVisible)
		{
			if (Count >= VertSB.Pos)
				DrawItem(C, I, HBorder, VBorder + (ItemHeight * (Count - VertSB.Pos)), WinWidth - (2 * HBorder) - VertSB.WinWidth, ItemHeight);
		}
		else
			DrawItem(C, I, HBorder, VBorder + (ItemHeight * Count), WinWidth - (2 * HBorder), ItemHeight);
		Count++;
	}
}

// Joshua - Initialize selection when dropdown opens
function WindowShown()
{
    Super.WindowShown();
    // Initialize selection index to current selected item
    m_SelectedIndex = GetSelectedIndex();
    UpdateSelectedFromIndex();

    // Reset key repeat state
    m_heldKey = 0;
    m_keyHoldTime = 0;
    m_nextRepeatTime = 0;
}

// Joshua - Get the index of the currently selected item
function int GetSelectedIndex()
{
    local UWindowComboListItem I;
    local int Count;

    Count = 0;
    for (I = UWindowComboListItem(Items.Next); I != None; I = UWindowComboListItem(I.Next))
    {
        if (I == Selected)
            return Count;
        Count++;
    }
    return 0;
}

// Joshua - Update the selected pointer from m_SelectedIndex
function UpdateSelectedFromIndex()
{
    local UWindowComboListItem Item;

    Item = UWindowComboListItem(Items.FindEntry(m_SelectedIndex));
    if (Item != None)
        Selected = Item;

    // Ensure item is visible
    EnsureSelectedVisible();
}

// Joshua - Ensure the selected item is visible by scrolling
function EnsureSelectedVisible()
{
    local int VisibleStart;
    local int VisibleCount;

    if (!VertSB.bWindowVisible)
        return;

    VisibleStart = VertSB.Pos;
    VisibleCount = MaxVisible;

    if (m_SelectedIndex < VisibleStart)
    {
        VertSB.Pos = m_SelectedIndex;
    }
    else if (m_SelectedIndex >= VisibleStart + VisibleCount)
    {
        VertSB.Pos = m_SelectedIndex - VisibleCount + 1;
    }
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function KeyDown(int Key, float X, float Y)
{
    local int ItemCount;

    ItemCount = Items.Count();

    if (ItemCount == 0)
    {
        CloseUp();
        return;
    }

    // Track repeatable keys (up/down)
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

    HandleNavigationInput(Key, ItemCount);
}

// Joshua - Handle key releases for auto-scrolling
function KeyUp(int Key, float X, float Y)
{
    if (Key == m_heldKey)
    {
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
    }
}

// Joshua - Handle navigation input (for normal mode and auto-repeat)
function HandleNavigationInput(int Key, int ItemCount)
{
    // Navigate down in list, DPadDown (213) or AnalogDown (197)
    if (Key == 213 || Key == 197)
    {
        Root.PlayClickSound();
        m_SelectedIndex = (m_SelectedIndex + 1) % ItemCount;
        UpdateSelectedFromIndex();
    }
    // Navigate up in list, DPadUp (212) or AnalogUp (196)
    else if (Key == 212 || Key == 196)
    {
        Root.PlayClickSound();
        m_SelectedIndex = (m_SelectedIndex - 1 + ItemCount) % ItemCount;
        UpdateSelectedFromIndex();
    }
    // Confirm selection, A button (200)
    else if (Key == 200)
    {
        if (Selected != None)
        {
            ExecuteItem(Selected);
        }
    }
    // Cancel, B button (201)
    else if (Key == 201)
    {
        Root.PlayClickSound();
        CloseUp();
    }
}

// Joshua - Tick function to handle auto-scrolling for held keys
function Tick(float Delta)
{
    local int ItemCount;

    Super.Tick(Delta);

    if (m_heldKey == 0)
        return;

    m_keyHoldTime += Delta;

    // Check if it's time to repeat
    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        ItemCount = Items.Count();
        if (ItemCount > 0)
        {
            // Execute the held key's action
            HandleNavigationInput(m_heldKey, ItemCount);

            // Schedule next repeat
            m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
        }
    }
}

defaultproperties
{
    m_initialDelay=0.5
    m_repeatRate=0.1
}