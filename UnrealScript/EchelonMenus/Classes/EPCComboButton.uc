class EPCComboButton extends UWindowComboButton
				native;

function Created(){}

// Joshua - Allow page scrolling when mouse is over the combo button
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;
	
	// Joshua - The parent is the combo control, we need to go to its owner to find the listbox
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

// Joshua - Allow page scrolling when mouse is over the combo button
function MouseWheelUp(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;
	
	// Joshua - The parent is the combo control, we need to go to its owner to find the listbox
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
 

