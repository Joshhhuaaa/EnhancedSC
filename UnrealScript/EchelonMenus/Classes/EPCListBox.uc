//=============================================================================
//  EPCListBox.uc : Echelon List Box
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/16 * Created by Alexandre Dionne
//=============================================================================
class EPCListBox extends UWindowListBox
        native;

var INT m_IRightPadding; //To leave some space at the left of the scrollbar

native(4008) final function RenderItem(Canvas C, UWindowListBoxItem Item, float X, float Y, float W, float H);

function Created()
{
	Super.Created();
	VertSB = UWindowVScrollbar(CreateWindow(class'EPCVScrollBar', WinWidth - LookAndFeel.Size_ScrollbarWidth, 0, LookAndFeel.Size_ScrollbarWidth, WinHeight));
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
    RenderItem(C, UWindowListBoxItem(Item), X, Y, W - m_IRightPadding, H);
}

function DoubleClickItem(UWindowListBoxItem I)
{
	Root.PlayClickSound();
	Super.DoubleClickItem(I);
}

defaultproperties
{
    m_IRightPadding=4
    ItemHeight=18.000000
    ListClass=Class'EPCListBoxItem'
    TextColor=(R=51,G=51,B=51,A=255)
    Align=2
    bNoKeyboard=True
    m_BorderColor=(R=51,G=51,B=51,A=255)
}