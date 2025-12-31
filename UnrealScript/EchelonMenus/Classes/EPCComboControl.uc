//=============================================================================
//  EPCComboControl.uc : Combo Control with echelon art style
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/22 * Created by Alexandre Dionne
//=============================================================================
class EPCComboControl extends UWindowComboControl
				native;

function CloseUp()
{
	Root.PlayClickSound();
	Super.CloseUp();
}

function DropDown()
{
	Root.PlayClickSound();
	Super.DropDown();
}

function Created()
{
	Super.Created();
	
	EditBox = UWindowEditBox(CreateWindow(class'EPCComboEditBox', 0, 0, WinWidth - LookAndFeel.Size_ComboButtonWidth, WinHeight, self)); 
	EditBox.NotifyOwner = Self;
	EditBoxWidth = WinWidth / 2;
	EditBox.bTransient = true;

	Button = UWindowComboButton(CreateWindow(class'EPCComboButton', WinWidth - LookAndFeel.Size_ComboButtonWidth, 0, LookAndFeel.Size_ComboButtonWidth, WinHeight, self)); 
	Button.Owner = Self;
	
	List = UWindowComboList(Root.CreateWindow(ListClass, 0, 0, 100, 100)); 
	List.LookAndFeel = LookAndFeel;
	List.Owner = Self;
	List.Setup();
	
	List.HideWindow();
	bListVisible = false;

	SetEditTextColor(LookAndFeel.EditBoxTextColor);

    bSetupSize = true;
}


function Paint(Canvas C, float X, float Y){}

function AfterPaint(Canvas C, float X, float Y)
{
	Render(C, X, Y);
}

// Override mouse wheel to allow page scrolling when mouse is over closed combo
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;
	
	// Find the listbox in our owner window and pass the scroll event to it
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

function MouseWheelUp(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;
	
	// Find the listbox in our owner window and pass the scroll event to it
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

defaultproperties
{
    ListClass=Class'EPCComboList'
}