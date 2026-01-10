//=============================================================================
//  EPCCheckBox.uc : CheckBox or Radio Button
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/15 * Created by Alexandre Dionne
//=============================================================================
class EPCCheckBox extends UWindowButton
				native;

function Click(float X, float Y)
{
    if (bDisabled)
        return;

    m_bSelected = !m_bSelected;

	Notify(DE_Click);

	Root.PlayClickSound();
}

// Joshua - Allow page scrolling when mouse is over checkbox
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Joshua - Find the listbox in our owner window and pass the scroll event to it
	if (NotifyWindow != None)
	{
		W = NotifyWindow.FirstChildWindow;
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

// Joshua - Allow page scrolling when mouse is over checkbox
function MouseWheelUp(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Joshua - Find the listbox in our owner window and pass the scroll event to it
	if (NotifyWindow != None)
	{
		W = NotifyWindow.FirstChildWindow;
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

