//=============================================================================
//  EPCOptionsListBoxEnhanced.uc : Modified version of the Options settings list box for Enhanced.
//=============================================================================
class EPCOptionsListBoxEnhanced extends EPCListBox;

var Array<UWindowWindow>        m_Controls;
var int TitleFont;
var int m_ILabelXPos;           // X position offset for labels
var INT m_ILabelWidth;          // Width of label area to calculate control position
var INT m_ILineItemHeight;      // Height for line items (spacing)
var INT m_ICompactLineItemHeight;
var INT m_ITitleLineItemHeight; // Height for title line items (smaller spacing)

function BeforePaint(Canvas C, float MouseX, float MouseY)
{
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;
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
            EnhancedItem = EPCEnhancedListBoxItem(CurItem);
            if (EnhancedItem != None && EnhancedItem.bIsTitleLine)
                CurrentHeight = m_ITitleLineItemHeight;
            else if (EnhancedItem != None && EnhancedItem.bIsLine)
                CurrentHeight = m_ILineItemHeight;
            else if (EnhancedItem != None && EnhancedItem.bIsCompactLine)
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
            EnhancedItem = EPCEnhancedListBoxItem(CurItem);
            if (EnhancedItem != None && EnhancedItem.bIsTitleLine)
                CurrentHeight = m_ITitleLineItemHeight;
            else if (EnhancedItem != None && EnhancedItem.bIsLine)
                CurrentHeight = m_ILineItemHeight;
            else if (EnhancedItem != None && EnhancedItem.bIsCompactLine)
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

    VertSB.SetRange(0, ItemCount, VisibleItems);
}

function SetSelectedItem(UWindowListBoxItem NewSelected)
{
    local EPCEnhancedListBoxItem EnhancedItem;

    EnhancedItem = EPCEnhancedListBoxItem(NewSelected);

    // Only allow selection if item exists and is selectable
    if (EnhancedItem != None && !EnhancedItem.m_bIsNotSelectable)
    {
        if (SelectedItem != NewSelected)
        {
            if (SelectedItem != None)
                SelectedItem.bSelected = false;

            SelectedItem = NewSelected;
            SelectedItem.bSelected = true;

            Notify(DE_Click);
        }
    }
}

function LMouseDown(float X, float Y)
{
    // Joshua - Don't call Super to prevent selection effect
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
    local EPCEnhancedListBoxItem listBoxItem;
    local int i;
    local EPCHScrollBar ScrollBar;
    local EPCCheckBox CheckBox;
    local UWindowLabelControl ValueLabel;
    local Color DrawColor;
    local Color SelectedColor;
    local float TextWidth, TextHeight;
    local float BarX;
    local float ControlXPos;
    local float RightEdge;
    local float InfoButtonSize;
    local float InfoButtonTextWidth;

    listBoxItem = EPCEnhancedListBoxItem(Item);
    if (listBoxItem != None)
    {
        // Reset canvas style at start of each item
        C.Style = 5; // STY_Alpha

        // Set font first so we can measure text
        C.Font = Root.Fonts[TitleFont];
        TextSize(C, listBoxItem.Caption, TextWidth, TextHeight);

        // Joshua - Draw selection highlight
        if (listBoxItem.bSelected && listBoxItem.m_Control != None)
        {
            // Draw solid dark bar behind text
            SelectedColor.R = 71;
            SelectedColor.G = 71;
            SelectedColor.B = 71;
            SelectedColor.A = 180;
            C.DrawColor = SelectedColor;
            for (BarX = X + m_ILabelXPos - 2; BarX < X + m_ILabelXPos + TextWidth + 4; BarX += 1)
            {
                C.SetPos(BarX, Y);
                C.DrawTile(Texture'HUD.HUD.ETPixel', 1, H, 0, 0, 1, 1);
            }
        }

        // Calculate right edge (before scrollbar)
        RightEdge = W - LookAndFeel.Size_ScrollbarWidth - 5;

        if (listBoxItem.m_Control != None)
        {
            listBoxItem.m_Control.WinTop = Y;

            // Joshua - Position control based on flags
            CheckBox = EPCCheckBox(listBoxItem.m_Control);
            if (listBoxItem.bRightAlignControl && CheckBox != None)
            {
                listBoxItem.m_Control.WinLeft = X + RightEdge - listBoxItem.m_Control.WinWidth;
            }
            else if (listBoxItem.bControlAfterLabel && CheckBox != None)
            {
                listBoxItem.m_Control.WinLeft = X + m_ILabelXPos + TextWidth + 95;
            }
            else
            {
                listBoxItem.m_Control.WinLeft = X + m_ILabelXPos + m_ILabelWidth;
            }
            listBoxItem.m_Control.ShowWindow();

            // Joshua - Position value labels to the right of scrollbars
            ScrollBar = EPCHScrollBar(listBoxItem.m_Control);
            if (ScrollBar != None)
            {
                // Joshua - Look for the corresponding value label (should be the next control in the array)
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

        // Joshua - Position secondary control (EAX checkbox on same row)
        if (listBoxItem.m_SecondaryControl != None)
        {
            listBoxItem.m_SecondaryControl.WinTop = Y;
            // Secondary control is aligned before scrollbar
            listBoxItem.m_SecondaryControl.WinLeft = X + RightEdge - listBoxItem.m_SecondaryControl.WinWidth;
            listBoxItem.m_SecondaryControl.ShowWindow();
        }

        // Joshua - Position logo control (EAX logo)
        if (listBoxItem.m_LogoControl != None)
        {
            // Center logo vertically with checkbox
            listBoxItem.m_LogoControl.WinTop = Y - 5;
            // Use fixed X position if specified, otherwise auto-position left of secondary control
            if (listBoxItem.m_LogoXPos > 0)
                listBoxItem.m_LogoControl.WinLeft = X + listBoxItem.m_LogoXPos;
            else if (listBoxItem.m_SecondaryControl != None)
                listBoxItem.m_LogoControl.WinLeft = listBoxItem.m_SecondaryControl.WinLeft - listBoxItem.m_LogoControl.WinWidth - 5;
            else
                listBoxItem.m_LogoControl.WinLeft = X + RightEdge - listBoxItem.m_LogoControl.WinWidth - 25;
            listBoxItem.m_LogoControl.ShowWindow();
        }

        // Joshua - Position info button (tooltip "?" button)
        if (listBoxItem.m_InfoButton != None)
        {
            InfoButtonSize = 16; // Info button is 16x16
            // Measure text width to position button after it
            C.Font = Root.Fonts[F_Normal];
            C.TextSize(listBoxItem.Caption, InfoButtonTextWidth, TextHeight);

            listBoxItem.m_InfoButton.WinTop = Y + (H - InfoButtonSize) / 2;
            listBoxItem.m_InfoButton.WinLeft = X + m_ILabelXPos + InfoButtonTextWidth + 5; // 5 pixels after text
            listBoxItem.m_InfoButton.ShowWindow();
        }

        // Joshua - White text on dark bar for selected, normal color otherwise
        if (listBoxItem.bSelected && listBoxItem.m_Control != None)
        {
            DrawColor.R = 255;
            DrawColor.G = 255;
            DrawColor.B = 255;
            DrawColor.A = 255;
        }
        else
        {
            DrawColor = TextColor;
        }
        C.DrawColor = DrawColor;

        // Draw the caption text
        ClipText(C, X + m_ILabelXPos, Y + (H - TextHeight) / 2, listBoxItem.Caption);
    }
    else
    {
        // Fallback for non-enhanced items - use native RenderItem
        RenderItem(C, UWindowListBoxItem(Item), X + (m_ILabelXPos - 5), Y, W - m_IRightPadding, H);
    }
}

function Paint(Canvas C, float MouseX, float MouseY)
{
    local float y;
    local UWindowList CurItem;
    local int i;
    local EPCEnhancedListBoxItem EnhancedItem;
    local float CurrentItemHeight;

    HideControls();

    // Custom paint logic to handle different heights for line items
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
            EnhancedItem = EPCEnhancedListBoxItem(CurItem);
              // Use custom height for different item types
            if (EnhancedItem != None && EnhancedItem.bIsTitleLine)
                CurrentItemHeight = m_ITitleLineItemHeight;
            else if (EnhancedItem != None && EnhancedItem.bIsLine)
                CurrentItemHeight = m_ILineItemHeight;
            else if (EnhancedItem != None && EnhancedItem.bIsCompactLine)
                CurrentItemHeight = m_ICompactLineItemHeight;
            else
                CurrentItemHeight = ItemHeight;

            if (y + CurrentItemHeight < WinHeight)
            {
                if (VertSB.bWindowVisible)
                    DrawItem(C, CurItem, 0, y, WinWidth - LookAndFeel.Size_ScrollbarWidth, CurrentItemHeight);
                else
                    DrawItem(C, CurItem, 0, y, WinWidth, CurrentItemHeight);
            }

            y = y + CurrentItemHeight;
        }
    }
}

function HideControls()
{
    local int i;

    for (i = 0; i < m_Controls.Length; i++)
    {
        if (m_Controls[i] != None)
        {
            m_Controls[i].HideWindow();
        }
    }
}

// Joshua - Close combo boxes if scrolling begins
function CloseActiveComboBoxes()
{
    local int i;
    local EPCComboControl ComboBox;

    for (i = 0; i < m_Controls.Length; i++)
    {
        ComboBox = EPCComboControl(m_Controls[i]);
        if (ComboBox != None && ComboBox.bListVisible)
        {
            ComboBox.CloseUp();
        }
    }
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
    CloseActiveComboBoxes();
    Super.MouseWheelDown(X, Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    CloseActiveComboBoxes();
    Super.MouseWheelUp(X, Y);
}

defaultproperties
{
    ListClass=Class'EPCEnhancedListBoxItem'
    TextColor=(R=71,G=71,B=71,A=255)
    m_ILabelXPos=15
    m_ILabelWidth=250
    m_ICompactLineItemHeight=2
    m_ILineItemHeight=8
    m_ITitleLineItemHeight=4
}
