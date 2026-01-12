//=============================================================================
//  EPCEnhancedListBoxItem.uc : Modified list box item used for Enhanced settings
//  Created by Joshua
//=============================================================================
class EPCEnhancedListBoxItem extends UWindowListBoxItem;

var bool            m_bIsTitle;
var bool            m_bIsDescription;
var bool            m_bIsNotSelectable;
var UWindowWindow   m_Control;
var UWindowWindow   m_SecondaryControl; // Secondary control (EAX checkbox on same row as 3D Audio)
var UWindowWindow   m_LogoControl;      // Logo bitmap (EAX logo that scrolls with item)
var UWindowWindow   m_InfoButton; // Optional info button
var bool            bIsLine;
var bool            bIsCompactLine;
var bool            bIsTitleLine; // Special line item with smaller height for titles
var bool            bRightAlignControl;
var bool            bControlAfterLabel; // Position control right after label text (like original 3D Audio)
var float           m_LogoXPos;         // Fixed X position for logo (0 = auto position left of secondary)
var Color           m_TextColor;

defaultproperties
{
    m_TextColor=(R=71,G=71,B=71,A=255)
}