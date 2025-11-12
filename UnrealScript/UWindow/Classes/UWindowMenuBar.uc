//=============================================================================
// UWindowMenuBar - A menu bar
//=============================================================================
class UWindowMenuBar extends UWindowListControl;

var UWindowMenuBarItem		Selected;
var UWindowMenuBarItem		Over;
var bool					bAltDown;
var int						Spacing;

function Created()
{
	ListClass = class'UWindowMenuBarItem';
	SetAcceptsHotKeys(True);
	Super.Created();
	Spacing = 10;
}

function UWindowMenuBarItem AddHelpItem(string Caption)
{
	Local UWindowMenuBarItem I;

	I = AddItem(Caption);
	I.SetHelp(True);

	return I;
}

function UWindowMenuBarItem AddItem(string Caption)
{
	local UWindowMenuBarItem I;
	I = UWindowMenuBarItem(Items.Append(class'UWindowMenuBarItem'));
	I.Owner = Self;
	I.SetCaption(Caption);
	
	return I;
}

function ResolutionChanged(float W, float H)
{
	local UWindowMenuBarItem I;
	
	if (Items != none)
	{
		for (I = UWindowMenuBarItem(Items.Next);I != None; I = UWindowMenuBarItem(I.Next))
			if (I.Menu != None)
				I.Menu.ResolutionChanged(W, H);
	}

	Super.ResolutionChanged(W, H);
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float X;
	local float W, H;
	local UWindowMenuBarItem I;

	DrawMenuBar(C);

	for (I = UWindowMenuBarItem(Items.Next);I != None; I = UWindowMenuBarItem(I.Next))
	{
		C.Font = Root.Fonts[F_Normal];
		TextSize(C, RemoveAmpersand(I.Caption), W, H);

		if (I.bHelp)
		{
			DrawItem(C, I, (WinWidth - (W + Spacing)), 1, W + Spacing, 14);
		}
		else
		{
			DrawItem(C, I, X, 1, W + Spacing, 14);
			X = X + W + Spacing;
		}		
	}
}

function MouseMove(float X, float Y)
{
	local UWindowMenuBarItem I;
	Super.MouseMove(X, Y);

	Over = None;

	for (I = UWindowMenuBarItem(Items.Next);I != None; I = UWindowMenuBarItem(I.Next))
	{
		if (X >= I.ItemLeft && X <= I.ItemLeft + I.ItemWidth)
		{
			if (Selected != None) {
				if (Selected != I)
				{
					Selected.DeSelect();
					Selected = I;
					Selected.Select();
					Select(Selected);
				}
			} else {
				Over = I;
			}
		}
	}
}

function MouseLeave()
{
	Super.MouseLeave();
	Over = None;
}

function Select(UWindowMenuBarItem I)
{
}

function LMouseDown(float X, float Y)
{
	local UWindowMenuBarItem I;

	for (I = UWindowMenuBarItem(Items.Next);I != None; I = UWindowMenuBarItem(I.Next))
	{
		if (X >= I.ItemLeft && X <= I.ItemLeft + I.ItemWidth)
		{
			//Log("Click "$I.Caption);

			if (Selected != None) {
				Selected.DeSelect();
			}

			if (Selected == I)
			{
				Selected = None;
				Over = I;
			}
			else
			{
				Selected = I;
				Selected.Select();
			}

			Select(Selected);
			return;
		}
	}

	if (Selected != None)
	{
		Selected.DeSelect();
	}

	Selected = None;
	Select(Selected);
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local string Text;
	local string Underline;


	C.SetDrawColor(255,255,255);
	
	UWindowMenuBarItem(Item).ItemLeft = X;
	UWindowMenuBarItem(Item).ItemWidth = W;

	LookAndFeel.Menu_DrawMenuBarItem(Self, UWindowMenuBarItem(Item), X, Y, W, H, C);
}

function DrawMenuBar(Canvas C)
{
	DrawStretchedTexture(C, 0, 0, WinWidth, 16, Texture'MenuBar');
}

function CloseUp()
{
	if (Selected != None) 
	{
		Selected.DeSelect();
		Selected = None;
	}
}

function Close(optional bool bByParent)
{
//	Root.Console.CloseUWindow();
}

function UWindowMenuBar GetMenuBar()
{
	return Self;
}


function bool HotKeyDown(int Key, float X, float Y)
{
	local UWindowMenuBarItem I;

	if (Key == 0x12)
		bAltDown = True;

	if (bAltDown)
	{
		// Check for hotkeys in each menu item
		for (I = UWindowMenuBarItem(Items.Next);I != None; I = UWindowMenuBarItem(I.Next))
		{
			if (Key == I.HotKey) 
			{
				if (Selected != None)
					Selected.DeSelect();
				Selected = I;
				Selected.Select();
				Select(Selected);
				bAltDown = False;
				return True;
			}
		}
	}		
	return False;
}

function bool HotKeyUp(int Key, float X, float Y)
{
	if (Key == 0x12)
		bAltDown = False;

	return False;
}

function KeyDown(int Key, float X, float Y)
{
	local UWindowMenuBarItem I;

	switch (Key)
	{
	case 0x25: // Left
		I = UWindowMenuBarItem(Selected.Prev);
		if (I == None || I == Items)
			I = UWindowMenuBarItem(Items.Last);

		if (Selected != None)
			Selected.DeSelect();	

		Selected = I;
		Selected.Select();

		Select(Selected);

		break;
	case 0x27: // Right
		I = UWindowMenuBarItem(Selected.Next);
		if (I == None)
			I = UWindowMenuBarItem(Items.Next);

		if (Selected != None)
			Selected.DeSelect();
		

		Selected = I;
		Selected.Select();

		Select(Selected);
		
		break;
	}
}

function MenuCmd(int Menu, int Item)
{
	local UWindowMenuBarItem I;
	local int j;

	j = 0;
	for (I = UWindowMenuBarItem(Items.Next); I != None; I = UWindowMenuBarItem(I.Next))
	{
		if (j == Menu && I.Menu != None)
		{
			if (Selected != None)
				Selected.DeSelect();
			Selected = I;
			Selected.Select();
			Select(Selected);
			I.Menu.MenuCmd(Item);
			return;
		}
		j++;
	}	
}

function MenuItemSelected(UWindowBase Sender, UWindowBase Item)
{
	// Should be handled in a child

}

