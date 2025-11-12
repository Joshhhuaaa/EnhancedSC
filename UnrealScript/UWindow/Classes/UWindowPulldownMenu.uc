//=============================================================================
// UWindowPulldownMenu
//=============================================================================


class UWindowPulldownMenu extends UWindowListControl;

#exec TEXTURE IMPORT NAME=MenuTick FILE=Textures\MenuTick.bmp GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuDivider FILE=Textures\MenuDivider.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuSubArrow FILE=Textures\MenuSubArrow.bmp GROUP="Icons" MASKED=1 MIPS=OFF

var UWindowPulldownMenuItem		Selected;

// Owner is either a UWindowMenuBarItem or UWindowPulldownMenuItem
var UWindowList					Owner;

var int ItemHeight;
var int VBorder;
var int HBorder;
var int TextBorder;

var UWindowMenuBar MyMenuBar;

// External functions
function UWindowPulldownMenuItem AddMenuItem(string C, Texture G)
{
	local UWindowPulldownMenuItem I;

	I = UWindowPulldownMenuItem(Items.Append(class'UWindowPulldownMenuItem'));
	
	I.Owner = Self;
	I.SetCaption(C);
	I.Graphic = G;
	I.Tag = Items.Count(); 
	
	return I;
}

// Mostly-private funcitons

function Created()
{
	ListClass = class'UWindowPulldownMenuItem';
	SetAcceptsFocus();
	Super.Created();
	ItemHeight = LookAndFeel.Pulldown_ItemHeight;
	VBorder = LookAndFeel.Pulldown_VBorder;
	HBorder = LookAndFeel.Pulldown_HBorder;
	TextBorder = LookAndFeel.Pulldown_TextBorder;
}

function Clear()
{
	Items.Clear();
	Selected = None;
}

function DeSelect()
{
	if (Selected != None)
	{
		Selected.DeSelect();
		Selected = None;
	}
}

function Select(UWindowPulldownMenuItem I)
{
}

function PerformSelect(UWindowPulldownMenuItem NewSelected)
{
	if (Selected != None && NewSelected != Selected) Selected.DeSelect();

	if (NewSelected == None) 
	{
		Selected = None;
	}
	else
	{	
		if (Selected != NewSelected && NewSelected.Caption != "-" && !NewSelected.bDisabled)
			LookAndFeel.PlayMenuSound(Self, MS_MenuItem);
						
		Selected = NewSelected;
		if (Selected != None) 
		{
			Selected.Select();
			Select(Selected);
		}
	}
}

function SetSelected(float X, float Y)
{
	local UWindowPulldownMenuItem NewSelected;

	NewSelected = UWindowPulldownMenuItem(Items.FindEntry((Y - VBorder) / ItemHeight));

	PerformSelect(NewSelected);
}

function ShowWindow()
{
	local UWindowPulldownMenuItem I;
	Super.ShowWindow();
	PerformSelect(None);
	FocusWindow();
}

function MouseMove(float X, float Y)
{
	Super.MouseMove(X, Y);
	SetSelected(X, Y);
	FocusWindow();
}

function LMouseUp(float X, float Y)
{
	If (Selected != None && Selected.Caption != "-" && !Selected.bDisabled)
	{
		BeforeExecuteItem(Selected);
		ExecuteItem(Selected);
	}
	Super.LMouseUp(X, Y);
}

function LMouseDown(float X, float Y)
{
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H, MaxWidth;
	local int Count;
	local UWindowPulldownMenuItem I;
	
	
	MaxWidth = 100;
	Count = 0;

	C.Font = Root.Fonts[F_Normal];
	C.SetPos(0, 0);

	for (I = UWindowPulldownMenuItem(Items.Next);I != None; I = UWindowPulldownMenuItem(I.Next))
	{
		Count++;
		TextSize(C, RemoveAmpersand(I.Caption), W, H);
		if (W > MaxWidth) MaxWidth = W;
	}

	WinWidth = MaxWidth + ((HBorder + TextBorder) * 2);
	WinHeight = (ItemHeight * Count) + (VBorder * 2);

	// Take care of bHelp items
	if (((UWindowMenuBarItem(Owner) != None) && (UWindowMenuBarItem(Owner).bHelp)) ||
		WinLeft + WinWidth > ParentWindow.WinWidth)
	{
		WinLeft = ParentWindow.WinWidth - WinWidth;
	}

	if (UWindowPulldownMenuItem(Owner) != None)
	{
		I = UWindowPulldownMenuItem(Owner);
		
		if (WinWidth + WinLeft > ParentWindow.WinWidth)
			WinLeft = I.Owner.WinLeft + I.Owner.HBORDER - WinWidth;
	}
}

function Paint(Canvas C, float X, float Y)
{
	local int Count;
	local UWindowPulldownMenuItem I;

	DrawMenuBackground(C);
	
	Count = 0;

	for (I = UWindowPulldownMenuItem(Items.Next);I != None; I = UWindowPulldownMenuItem(I.Next))
	{
		DrawItem(C, I, HBorder, VBorder + (ItemHeight * Count), WinWidth - (2 * HBorder), ItemHeight);
		Count++;
	}
}

function DrawMenuBackground(Canvas C)
{
	LookAndFeel.Menu_DrawPulldownMenuBackground(Self, C);
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	LookAndFeel.Menu_DrawPulldownMenuItem(Self, UWindowPulldownMenuItem(Item), C, X, Y, W, H, Selected == Item);
}

function BeforeExecuteItem(UWindowPulldownMenuItem I)
{
	LookAndFeel.PlayMenuSound(Self, MS_WindowOpen);
}

function ExecuteItem(UWindowPulldownMenuItem I)
{
	MyMenuBar.MenuItemSelected(Self,I);
	CloseUp();
}

function CloseUp(optional bool bByOwner)
{
	local UWindowPulldownMenuItem I;

	// tell our owners to close up
	if (!bByOwner)
	{
		if (UWindowPulldownMenuItem(Owner) != None)  UWindowPulldownMenuItem(Owner).CloseUp();
		if (UWindowMenuBarItem(Owner) != None)  UWindowMenuBarItem(Owner).CloseUp();
	}

	// tell our children to close up
	for (I = UWindowPulldownMenuItem(Items.Next);I != None; I = UWindowPulldownMenuItem(I.Next))
		if (I.SubMenu != None)
			I.SubMenu.CloseUp(True);
}

function UWindowMenuBar GetMenuBar()
{
	if (UWindowPulldownMenuItem(Owner) != None) return UWindowPulldownMenuItem(Owner).GetMenuBar();
	if (UWindowMenuBarItem(Owner) != None) return UWindowMenuBarItem(Owner).GetMenuBar();
}

function FocusOtherWindow(UWindowWindow W)
{
	Super.FocusOtherWindow(W);

	if (Selected != None) 
		if (W == Selected.SubMenu) return;

	if (UWindowPulldownMenuItem(Owner) != None)
		if (UWindowPulldownMenuItem(Owner).Owner == W) return;

	if (bWindowVisible)
		CloseUp();
}

function KeyDown(int Key, float X, float Y)
{
	local UWindowPulldownMenuItem I;

	I = Selected;

	switch (Key)
	{
	case 27: // ESC
		CloseUp();
		break;
	case 0x26: // Up
		if (I == None || I == Items.Next)
			I = UWindowPulldownMenuItem(Items.Last);
		else
			I = UWindowPulldownMenuItem(I.Prev);

		if (I == None)
			I = UWindowPulldownMenuItem(Items.Last);
		else 
			if (I.Caption == "-")
				I = UWindowPulldownMenuItem(I.Prev);

		if (I == None)
			I = UWindowPulldownMenuItem(Items.Last);

		if (I.SubMenu == None)
			PerformSelect(I);
		else
			Selected = I;

		break;
	case 0x28: // Down
		if (I == None)
			I = UWindowPulldownMenuItem(Items.Next);
		else
			I = UWindowPulldownMenuItem(I.Next);

		if (I == None)
			I = UWindowPulldownMenuItem(Items.Next);
		else
			if (I.Caption == "-")
				I = UWindowPulldownMenuItem(I.Next);

		if (I == None)
			I = UWindowPulldownMenuItem(Items.Next);

		if (I.SubMenu == None)
			PerformSelect(I);
		else
			Selected = I;

		break;
	case 0x25: // Left
		if (UWindowPulldownMenuItem(Owner) != None)
		{
			 UWindowPulldownMenuItem(Owner).Owner.PerformSelect(None);
			 UWindowPulldownMenuItem(Owner).Owner.Selected = UWindowPulldownMenuItem(Owner);
		}
		if (UWindowMenuBarItem(Owner) != None)
			UWindowMenuBarItem(Owner).Owner.KeyDown(Key, X, Y);
		break;
	case 0x27: // Right
		if (I != None && I.SubMenu != None)
		{
			Selected = None;
			PerformSelect(I);
			I.SubMenu.Selected = UWindowPulldownMenuItem(I.SubMenu.Items.Next);
		} 
		else
		{
			if (UWindowPulldownMenuItem(Owner) != None)
			{
				UWindowPulldownMenuItem(Owner).Owner.PerformSelect(None);
				UWindowPulldownMenuItem(Owner).Owner.KeyDown(Key, X, Y);
			}
			if (UWindowMenuBarItem(Owner) != None)
				UWindowMenuBarItem(Owner).Owner.KeyDown(Key, X, Y);
		}	
		break;
	case 0x0D: // Enter
		if (I.SubMenu != None)
		{
			Selected = None;
			PerformSelect(I);
		}
		else
			if (Selected != None && Selected.Caption != "-" && !Selected.bDisabled)
			{
				BeforeExecuteItem(Selected);
				ExecuteItem(Selected);
			}
		break;
	default:
	}		
}

function KeyUp(int Key, float X, float Y)
{
	local UWindowPulldownMenuItem I;
		
	if (Key >= 0x41 && Key <= 0x60)
	{	
		// Check for hotkeys in each menu item
		for (I = UWindowPulldownMenuItem(Items.Next);I != None; I = UWindowPulldownMenuItem(I.Next))
		{
			if (Key == I.HotKey) 
			{
				PerformSelect(I);
				if (I != None && I.Caption != "-" && !I.bDisabled)
				{
					BeforeExecuteItem(I);
					ExecuteItem(I);
				}
			}
		}
	}
}

function MenuCmd(int Item)
{
	local int j;
	local UWindowPulldownMenuItem I;
		
	for (I = UWindowPulldownMenuItem(Items.Next);I != None; I = UWindowPulldownMenuItem(I.Next))
	{
		if (j == Item)
		{
			PerformSelect(I);
			if (I.Caption != "-" && !I.bDisabled)
			{
				BeforeExecuteItem(I);
				ExecuteItem(I);
			}
			return;
		}
		j++;
	}
}

defaultproperties
{
    bAlwaysOnTop=true
}