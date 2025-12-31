//=============================================================================
//  EPCEnhancedListBox.uc : Modified list box used for Enhanced settings
//  Created by Joshua
//=============================================================================
class EPCEnhancedListBox extends EPCListBox;

var Array<UWindowWindow>        m_Controls;
var int TitleFont;
var INT m_ILineItemHeight;      // Height for line items (spacing)
var INT m_ICompactLineItemHeight; // Height for compact line items (smaller spacing)
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
    
    // Add extra visible items to reduce over-scrolling
    VisibleItems += 2;
    
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
    local float InfoButtonSize;
    local float TextWidth, TextHeight;
    local Color DrawColor;
    
    listBoxItem = EPCEnhancedListBoxItem(Item);

    if (listBoxItem != None)
    {
        // Draw the text manually to support per-item colors
        C.Font = Root.Fonts[F_Normal];
        
        // Use item's text color (titles will be darker, regular items lighter)
        DrawColor = listBoxItem.m_TextColor;
        C.DrawColor = DrawColor;
        
        // Draw the caption text
        TextSize(C, listBoxItem.Caption, TextWidth, TextHeight);
        ClipText(C, X, Y + (H - TextHeight) / 2, listBoxItem.Caption);
        
        if (listBoxItem.m_Control != None)
        {
            listBoxItem.m_Control.WinTop = Y;
            listBoxItem.m_Control.WinLeft = X + W - listBoxItem.m_Control.WinWidth - 10;
            listBoxItem.m_Control.ShowWindow();
        }
        
        // Show info button if present - position it right after the label text
        if (listBoxItem.m_InfoButton != None)
        {
            InfoButtonSize = 16;
            
            listBoxItem.m_InfoButton.WinTop = Y + (H - InfoButtonSize) / 2;
            listBoxItem.m_InfoButton.WinLeft = X + TextWidth + 5; // 5 pixels after text
            listBoxItem.m_InfoButton.ShowWindow();
        }
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
    local UWindowList CurItem;
    local EPCEnhancedListBoxItem EnhancedItem;
    
    // Hide main controls
    for (i = 0; i < m_Controls.Length; i++)
    {
        if (m_Controls[i] != None)
        {
            m_Controls[i].HideWindow();
        }
    }
    
    // Hide all info buttons
    for (CurItem = Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        EnhancedItem = EPCEnhancedListBoxItem(CurItem);
        if (EnhancedItem != None && EnhancedItem.m_InfoButton != None)
        {
            EnhancedItem.m_InfoButton.HideWindow();
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
    //SelectionColor=(R=51,G=51,B=51,A=255)
    m_ILineItemHeight=10
    m_ICompactLineItemHeight=5
    m_ITitleLineItemHeight=5
}
