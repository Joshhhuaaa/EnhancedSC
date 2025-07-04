//=============================================================================
//  EPCEnhancedListBox.uc : Modified list box used for Enhanced settings
//=============================================================================
class EPCEnhancedListBox extends EPCListBox;

var Array<UWindowWindow>        m_Controls;
var int TitleFont;

function SetSelectedItem(UWindowListBoxItem NewSelected)
{
    local EPCEnhancedListBoxItem EnhancedItem;
    
    EnhancedItem = EPCEnhancedListBoxItem(NewSelected);
    
    // Only allow selection if item exists and is selectable
    if(EnhancedItem != None && !EnhancedItem.m_bIsNotSelectable)
    {
        if(SelectedItem != NewSelected)
        {
            if(SelectedItem != None)
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
    
    listBoxItem = EPCEnhancedListBoxItem(Item);

    if(listBoxItem != None)
    {
        if(listBoxItem.m_Control != None)
        {
            listBoxItem.m_Control.WinTop = Y;
            listBoxItem.m_Control.WinLeft = X + W - listBoxItem.m_Control.WinWidth - 10;
            listBoxItem.m_Control.ShowWindow();
        }
    }

    RenderItem(C, UWindowListBoxItem(Item), X, Y, W - m_IRightPadding, H);
}

function Paint(Canvas C, float MouseX, float MouseY)
{
    HideControls();
    Super.Paint(C, MouseX, MouseY);
}

function HideControls()
{
    local int i;
    
    for(i = 0; i < m_Controls.Length; i++)
    {
        if(m_Controls[i] != None)
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
    
    for(i = 0; i < m_Controls.Length; i++)
    {
        ComboBox = EPCComboControl(m_Controls[i]);
        if(ComboBox != None && ComboBox.bListVisible)
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
}