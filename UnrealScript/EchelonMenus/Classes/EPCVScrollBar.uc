//=============================================================================
//  EPCVScrollBar.uc : EchelonMenu Vertical scroll bar
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/18 * Created by Alexandre Dionne
//=============================================================================
class EPCVScrollBar extends UWindowVScrollBar
        native;

function Created()
{	
	UpButton = UWindowSBUpButton(CreateWindow(class'EPCSBUpButton', 0, 0, LookAndFeel.Size_ScrollbarWidth, LookAndFeel.Size_ScrollbarButtonHeight));
	DownButton = UWindowSBDownButton(CreateWindow(class'EPCSBDownButton', 0, WinHeight - LookAndFeel.Size_ScrollbarButtonHeight, LookAndFeel.Size_ScrollbarWidth, LookAndFeel.Size_ScrollbarButtonHeight));
}

function LMouseDown(float X, float Y)
{
	if ((Y < ThumbStart) || (Y > ThumbStart + ThumbHeight))
		Root.PlayClickSound();
	Super.LMouseDown(X, Y);
}

function Paint(Canvas C, float X, float Y) 
{
    if (isHidden())
        return;

	Render(C , X, Y);    

}
