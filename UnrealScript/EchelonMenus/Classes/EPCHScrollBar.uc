//=============================================================================
//  EPCHScrollBar.uc : Echelon style horizontal slider
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/22 * Created by Alexandre Dionne
//=============================================================================


class EPCHScrollBar extends UWindowHScrollBar
        native;

var     INT          m_IScrollHeight; //The scroll Bar height

function Created()
{    
    m_IScrollHeight = WinHeight;
    LeftButton = UWindowSBLeftButton(CreateWindow(class'EPCSBLeftButton', 0, 0, LookAndFeel.Size_HScrollbarButtonWidth, LookAndFeel.Size_HScrollbarHeight));
	RightButton = UWindowSBRightButton(CreateWindow(class'EPCSBRightButton', WinWidth - LookAndFeel.Size_HScrollbarButtonWidth, 0, LookAndFeel.Size_HScrollbarButtonWidth, LookAndFeel.Size_HScrollbarHeight));    
}

function SetScrollHeight(INT _iScrollHeight)
{
    //To allow the scroll bar to be smaller then the scroller
    if (_iScrollHeight <= WinHeight)
        m_IScrollHeight = _iScrollHeight;

}

function Paint(Canvas C, float X, float Y) 
{
	Render(C , X, Y);    
}
