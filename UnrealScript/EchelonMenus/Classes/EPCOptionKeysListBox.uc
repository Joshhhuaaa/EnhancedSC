class EPCOptionKeysListBox extends EPCListBox
            native;
var int                         TitleFont;

var INT     m_IHighLightWidth, m_IHighLightRightPadding;
var Texture m_BGTexture;
var bool                    m_bDoingAltMapping;

var Array<UWindowWindow>        m_Controls;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var INT m_ILineItemHeight;
var INT m_ICompactLineItemHeight;
var INT m_ITitleLineItemHeight;

//==============================================================================
//
//==============================================================================
function SetSelectedItem(UWindowListBoxItem NewSelected)
{

    if ((EPCOptionsKeyListBoxItem(NewSelected) != None) &&
        (SelectedItem != NewSelected) &&
        (EPCOptionsKeyListBoxItem(NewSelected).m_bIsNotSelectable == false) //make sure we are allowed selecting this element
)
	{
        if (SelectedItem != None)
			SelectedItem.bSelected = false;

		SelectedItem = NewSelected;
        SelectedItem.bSelected = true;

		Notify(DE_Click);
	}
}

//==============================================================================
// BeforePaint - Handle variable height items for scrollbar range
//==============================================================================
function BeforePaint(Canvas C, float MouseX, float MouseY)
{
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;
    local float TotalHeight;
    local int ItemCount;
    local int VisibleItems;
    local float CurrentHeight;
    local float HeightAccum;

    // Calculate total content height and count items
    TotalHeight = 0;
    ItemCount = 0;
    for (CurItem = Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        if (CurItem.ShowThisItem())
        {
            KeyItem = EPCOptionsKeyListBoxItem(CurItem);
            if (KeyItem != None && KeyItem.bIsCompactLine)
                CurrentHeight = m_ICompactLineItemHeight;
            else
                CurrentHeight = ItemHeight;

            TotalHeight += CurrentHeight;
            ItemCount++;
        }
    }

    // Count how many items actually fit in the visible window
    VisibleItems = 0;
    HeightAccum = m_IFirstItemYOffset;
    for (CurItem = Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        if (CurItem.ShowThisItem())
        {
            KeyItem = EPCOptionsKeyListBoxItem(CurItem);
            if (KeyItem != None && KeyItem.bIsCompactLine)
                CurrentHeight = m_ICompactLineItemHeight;
            else
                CurrentHeight = ItemHeight;

            if (HeightAccum + CurrentHeight <= WinHeight)
            {
                VisibleItems++;
                HeightAccum += CurrentHeight;
            }
            else
                break;
        }
    }

    // Add extra visible items to reduce over-scrolling
    VisibleItems += 2;

    VertSB.SetRange(0, ItemCount, VisibleItems);
}

//==============================================================================
//
//==============================================================================
function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
    local EPCOptionsKeyListBoxItem listBoxItem;
    local int i;
    local EPCHScrollBar ScrollBar;
    local UWindowLabelControl ValueLabel;
    local float TextWidth, TextHeight; // Joshua - Width and height of tooltip text
    local Color DrawColor;
    local Color HighlightBGColor;
    local bool bIsControlItem;

    listBoxItem = EPCOptionsKeyListBoxItem(Item);

    // Joshua - Reset canvas style at start of each item
    C.Style = 5; // STY_Alpha

    // Check if this is an item with a control (slider/checkbox/combo) or a key binding item
    bIsControlItem = (listBoxItem != None && listBoxItem.m_Control != None);

    // Joshua - Draw controller selection highlight background and text for control items only
    // Key binding items will still use RenderItem which draws them properly
    // Only draw selector when actually in controller mode
    if (listBoxItem != None && listBoxItem.bControllerSelected && bIsControlItem && EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        // Measure text width first
        C.Font = Root.Fonts[F_Normal];
        TextSize(C, listBoxItem.Caption, TextWidth, TextHeight);

        // Draw dark selection bar behind text using individual pixels
        HighlightBGColor.R = 71;
        HighlightBGColor.G = 71;
        HighlightBGColor.B = 71;
        HighlightBGColor.A = 180;
        C.DrawColor = HighlightBGColor;
        for (i = X - 2; i < X + TextWidth + 4; i++)
        {
            C.SetPos(i, Y);
            C.DrawTile(Texture'UWindow.ETPixel', 1, H, 0, 0, 1, 1);
        }

        // Draw text in white
        DrawColor.R = 255;
        DrawColor.G = 255;
        DrawColor.B = 255;
        DrawColor.A = 255;
        C.DrawColor = DrawColor;
        ClipText(C, X, Y + 2, listBoxItem.Caption);
    }

    if ((listBoxItem != None) && (listBoxItem.m_Control != None))
    {
        if (!listBoxItem.bIsCheckBoxLine)
        {
            listBoxItem.m_Control.WinTop = Y;
            listBoxItem.m_Control.WinLeft = X + W - m_IHighLightWidth - m_IHighLightRightPadding - m_IRightPadding;
            listBoxItem.m_Control.ShowWindow();

            // Joshua - Position info button if present (for combo boxes, scrollbars, etc.)
            if (listBoxItem.m_InfoButton != None)
            {
                C.Font = Root.Fonts[F_Normal];
                TextSize(C, listBoxItem.Caption, TextWidth, TextHeight);
                listBoxItem.m_InfoButton.WinTop = Y + 1; // Align with text
                listBoxItem.m_InfoButton.WinLeft = X + TextWidth + 5; // 5 pixels after text
                listBoxItem.m_InfoButton.ShowWindow();
            }

            // Joshua - Position value labels to the right of scrollbars
            ScrollBar = EPCHScrollBar(listBoxItem.m_Control);
            if (ScrollBar != None)
            {
                // Look for the corresponding value label (should be the next control in the array)
                for (i = 0; i < m_Controls.Length - 1; i++)
                {
                    if (m_Controls[i] == ScrollBar)
                    {
                        ValueLabel = UWindowLabelControl(m_Controls[i + 1]);
                        if (ValueLabel != None)
                        {
                            ValueLabel.WinTop = Y - 1; // Joshua - Subtracting 1 from WinTop seems better alligned
                            ValueLabel.WinLeft = ScrollBar.WinLeft + ScrollBar.WinWidth + 5;
                            ValueLabel.ShowWindow();
                        }
                        break;
                    }
                }
            }
        }
        else
        {
            // For Fire Equip line, draw the check box real far
            listBoxItem.m_Control.WinTop = Y;
            listBoxItem.m_Control.WinLeft = X + W - 32;
            listBoxItem.m_Control.ShowWindow();

            // Joshua - Position info button if present
            if (listBoxItem.m_InfoButton != None)
            {
                C.Font = Root.Fonts[F_Normal];
                TextSize(C, listBoxItem.Caption, TextWidth, TextHeight);
                listBoxItem.m_InfoButton.WinTop = Y + 1; // Align with text
                listBoxItem.m_InfoButton.WinLeft = X + TextWidth + 5; // 5 pixels after text
                listBoxItem.m_InfoButton.ShowWindow();
            }
        }
    }

    // Joshua - Skip native render for controller-selected control items only (we drew them above)
    // Key binding items still need RenderItem for their key text and background
    // Only skip when in controller mode (in mouse mode, always use native render)
    if (listBoxItem != None && listBoxItem.bControllerSelected && bIsControlItem && EPCMainMenuRootWindow(Root).m_bControllerModeActive)
        return;

    RenderItem(C, UWindowListBoxItem(Item), X, Y, W - m_IRightPadding, H);
}

//==============================================================================
// Paint - Handle variable height items
//==============================================================================
function Paint(Canvas C, float MouseX, float MouseY)
{
    local float y;
    local UWindowList CurItem;
    local int i;
    local EPCOptionsKeyListBoxItem KeyItem;
    local float CurrentItemHeight;

    HideControls();

    // Custom paint logic to handle different heights for compact line items
    CurItem = Items.Next;
    i = 0;

    // Skip items based on scroll position
    while ((CurItem != None) && (i < VertSB.Pos))
    {
        if (CurItem.ShowThisItem())
            i++;
        CurItem = CurItem.Next;
    }

    // Draw visible items with custom heights
    for (y = m_IFirstItemYOffset; (y < WinHeight) && (CurItem != None); CurItem = CurItem.Next)
    {
        if (CurItem.ShowThisItem())
        {
            KeyItem = EPCOptionsKeyListBoxItem(CurItem);
            // Use custom height for compact line items
            if (KeyItem != None && KeyItem.bIsCompactLine)
                CurrentItemHeight = m_ICompactLineItemHeight;
            else
                CurrentItemHeight = ItemHeight;

            if (y + CurrentItemHeight < WinHeight)
            {
                if (VertSB.bWindowVisible)
                    DrawItem(C, CurItem, 5, y, WinWidth - LookAndFeel.Size_ScrollbarWidth, CurrentItemHeight);
                else
                    DrawItem(C, CurItem, 5, y, WinWidth, CurrentItemHeight);
            }

            y = y + CurrentItemHeight;
        }
    }
}

//==============================================================================
//
//==============================================================================
function HideControls()
{
    local int i;
    // Joshua - Also hide info buttons that are stored in list items
    local UWindowList CurItem;
    local EPCOptionsKeyListBoxItem KeyItem;

    for (i = 0; i < m_Controls.Length; i++)
    {
        m_Controls[i].HideWindow();
    }

    // Joshua - Also hide info buttons that are stored in list items
    for (CurItem = Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        KeyItem = EPCOptionsKeyListBoxItem(CurItem);
        if (KeyItem != None && KeyItem.m_InfoButton != None)
        {
            KeyItem.m_InfoButton.HideWindow();
        }
    }
}


// Joshua - Override to handle variable height items
// Fixes bug where clicking items with compact lines would select wrong item
function UWindowListBoxItem GetItemAt(float MouseX, float MouseY)
{
    local float y;
    local UWindowList CurItem;
    local int i;
    local EPCOptionsKeyListBoxItem KeyItem;
    local float CurrentItemHeight;

    if (MouseX < 0 || MouseX > WinWidth)
        return None;

    CurItem = Items.Next;
    i = 0;

    // Skip items based on scroll position
    while ((CurItem != None) && (i < VertSB.Pos))
    {
        if (CurItem.ShowThisItem())
            i++;
        CurItem = CurItem.Next;
    }

    // Check each visible item with proper height
    for (y = m_IFirstItemYOffset; (y < WinHeight) && (CurItem != None); CurItem = CurItem.Next)
    {
        if (CurItem.ShowThisItem())
        {
            KeyItem = EPCOptionsKeyListBoxItem(CurItem);
            // Use custom height for compact line items
            if (KeyItem != None && KeyItem.bIsCompactLine)
                CurrentItemHeight = m_ICompactLineItemHeight;
            else
                CurrentItemHeight = ItemHeight;

            if (MouseY >= y && MouseY <= y + CurrentItemHeight)
                return UWindowListBoxItem(CurItem);
            y = y + CurrentItemHeight;
        }
    }

    return None;
}

//==============================================================================
//
//==============================================================================

defaultproperties
{
    m_IHighLightWidth=160
    m_IHighLightRightPadding=75
    m_BGTexture=Texture'UWindow.WhiteTexture'
    ListClass=Class'EPCOptionsKeyListBoxItem'
    SelectionColor=(R=51,G=51,B=51,A=255)
    TextColor=(R=71,G=71,B=71,A=255)
	//=============================================================================
	// Enhanced Variables
	//=============================================================================
    m_ILineItemHeight=10
    m_ICompactLineItemHeight=5
    m_ITitleLineItemHeight=5
}