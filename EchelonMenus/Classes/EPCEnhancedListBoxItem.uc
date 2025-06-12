//=============================================================================
//  EPCEnhancedListBoxItem.uc : Modified list box item used for Enhanced settings
//=============================================================================
class EPCEnhancedListBoxItem extends UWindowListBoxItem;

var bool            m_bIsTitle;
var bool            m_bIsDescription;
var bool            m_bIsNotSelectable;
var UWindowWindow   m_Control; 
var bool            bIsLine;          
var Color           m_TextColor;

defaultproperties
{
    m_TextColor=(R=71,G=71,B=71,A=255)
}