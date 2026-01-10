//=============================================================================
//  EPCSBUpButton.uc : Scroll Bar Button Echelon style
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/13 * Created by Alexandre Dionne
//=============================================================================
class EPCSBLeftButton extends UWindowSBLeftButton
                native;

function Created(){}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	if (!bDisabled)
		Root.PlayClickSound();
}

// Joshua - Allow page scrolling when mouse is over the button
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Joshua - Parent is the scrollbar, we need to go to its owner to find the listbox
	if (ParentWindow != None && UWindowDialogControl(ParentWindow).NotifyWindow != None)
	{
		W = UWindowDialogControl(ParentWindow).NotifyWindow.FirstChildWindow;
		while (W != None)
		{
			if (UWindowListBox(W) != None)
			{
				W.MouseWheelDown(X, Y);
				return;
			}
			W = W.NextSiblingWindow;
		}
	}
}

// Joshua - Allow page scrolling when mouse is over the button
function MouseWheelUp(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Joshua - Parent is the scrollbar, we need to go to its owner to find the listbox
	if (ParentWindow != None && UWindowDialogControl(ParentWindow).NotifyWindow != None)
	{
		W = UWindowDialogControl(ParentWindow).NotifyWindow.FirstChildWindow;
		while (W != None)
		{
			if (UWindowListBox(W) != None)
			{
				W.MouseWheelUp(X, Y);
				return;
			}
			W = W.NextSiblingWindow;
		}
	}
}
