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

    listBoxItem = EPCOptionsKeyListBoxItem(Item);

    if ((listBoxItem != None) && (listBoxItem.m_Control != None))
    {
        if (!listBoxItem.bIsCheckBoxLine)
        {
            listBoxItem.m_Control.WinTop = Y;
            listBoxItem.m_Control.WinLeft = X + W - m_IHighLightWidth - m_IHighLightRightPadding - m_IRightPadding;
            listBoxItem.m_Control.ShowWindow();
            
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
        }
    }

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
    local INT i;
    
    for (i =0; i < m_Controls.Length ;i++)
    {
        m_Controls[i].HideWindow();
    }
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