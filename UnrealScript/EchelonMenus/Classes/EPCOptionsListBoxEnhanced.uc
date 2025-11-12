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
    local UWindowLabelControl ValueLabel;
    
    listBoxItem = EPCEnhancedListBoxItem(Item);
    if (listBoxItem != None)
    {
        if (listBoxItem.m_Control != None)
        {
            listBoxItem.m_Control.WinTop = Y;
            // Joshua - Left-align controls using same method as sound config (labelXPos + labelWidth)
            listBoxItem.m_Control.WinLeft = X + m_ILabelXPos + m_ILabelWidth;
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
    }

    // Joshua - Call parent RenderItem but adjust X position to use configurable offset
    // Subtracting default offset (5) and add our configurable offset
    RenderItem(C, UWindowListBoxItem(Item), X + (m_ILabelXPos - 5), Y, W - m_IRightPadding, H);
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
                    DrawItem(C, CurItem, 5, y, WinWidth - LookAndFeel.Size_ScrollbarWidth, CurrentItemHeight);
                else
                    DrawItem(C, CurItem, 5, y, WinWidth, CurrentItemHeight);
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
    TextColor=(R=51,G=51,B=51,A=255)
    m_ILabelXPos=15
    m_ILabelWidth=250
    m_ICompactLineItemHeight=2
    m_ILineItemHeight=8
    m_ITitleLineItemHeight=4
    //SelectionColor=(R=51,G=51,B=51,A=255)
}
