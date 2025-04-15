class EPCOptionKeysListBox extends EPCListBox
            native;
var int                         TitleFont;

var INT     m_IHighLightWidth, m_IHighLightRightPadding;
var Texture m_BGTexture;
var bool                    m_bDoingAltMapping; 

var Array<UWindowWindow>        m_Controls;

//==============================================================================
// 
//==============================================================================
function SetSelectedItem(UWindowListBoxItem NewSelected)
{

    if( (EPCOptionsKeyListBoxItem(NewSelected) != None) && 
        (SelectedItem != NewSelected) && 
        (EPCOptionsKeyListBoxItem(NewSelected).m_bIsNotSelectable == false) //make sure we are allowed selecting this element
        )
	{
        if(SelectedItem != None)
			SelectedItem.bSelected = False;

		SelectedItem = NewSelected;
        SelectedItem.bSelected = True;
		
		Notify(DE_Click);
	}
}

//==============================================================================
// 
//==============================================================================
function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
    local EPCOptionsKeyListBoxItem listBoxItem;

    listBoxItem = EPCOptionsKeyListBoxItem(Item);

    if( (listBoxItem != None) && (listBoxItem.m_Control != None) )
    {
        if(!listBoxItem.bIsCheckBoxLine)
        {
            listBoxItem.m_Control.WinTop = Y;
            listBoxItem.m_Control.WinLeft = X + W - m_IHighLightWidth - m_IHighLightRightPadding - m_IRightPadding;
            listBoxItem.m_Control.ShowWindow();
        }
        else
        {
            // For Fire Equip line, draw the check box real far
            listBoxItem.m_Control.WinTop = Y;
            listBoxItem.m_Control.WinLeft = X + W - 32 ;
            listBoxItem.m_Control.ShowWindow();           
        }
    }

    RenderItem(C, UWindowListBoxItem(Item), X, Y, W - m_IRightPadding, H);  
}

//==============================================================================
// 
//==============================================================================
function Paint(Canvas C, float MouseX, float MouseY)
{
    HideControls();
	Super.Paint(C, MouseX, MouseY);	
}

//==============================================================================
// 
//==============================================================================
function HideControls()
{
    local INT i;
    
    for(i =0; i < m_Controls.Length ;i++)
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
}