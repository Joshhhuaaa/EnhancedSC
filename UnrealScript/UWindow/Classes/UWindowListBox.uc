//=============================================================================
// UWindowListBox - a listbox
//=============================================================================
class UWindowListBox extends UWindowListControl
            native;

var float				ItemHeight;
var UWindowVScrollbar	VertSB;
var UWindowListBoxItem	SelectedItem;

var bool				bCanDrag;
var bool				bCanDragExternal;
var string				DefaultHelpText;
var bool				bDragging;
var float				DragY;
var UWindowListBox		DoubleClickList;	// list to send items to on double-click

var bool				bHotTrack;	// Auto select when the mouse is over.
var INT                 m_IFirstItemYOffset;

function Created()
{
	Super.Created();
	VertSB = UWindowVScrollbar(CreateWindow(class'UWindowVScrollbar', WinWidth - LookAndFeel.Size_ScrollbarWidth, 0, LookAndFeel.Size_ScrollbarWidth, WinHeight));
}

function UWindowListBoxItem AddItem(string C)
{
	local UWindowListBoxItem I;

	I = UWindowListBoxItem(Items.Append(ListClass));
	I.Caption = c;

	return I;
}

function Clear()
{
    SelectedItem = None;
    Items.Clear();
}

function BeforePaint(Canvas C, float MouseX, float MouseY)
{
	local UWindowListBoxItem OverItem;
	local string NewHelpText;

	VertSB.SetRange(0, Items.CountShown(), int(WinHeight / ItemHeight));

	NewHelpText = DefaultHelpText;
	if (SelectedItem != None)
	{
		OverItem = GetItemAt(MouseX, MouseY);
		if (OverItem == SelectedItem && OverItem.HelpText != "")
			NewHelpText = OverItem.HelpText;
	}
	
	if (NewHelpText != HelpText)
	{
		HelpText = NewHelpText;
		Notify(DE_HelpChanged);
	}
}

function SetHelpText(string T)
{
	Super.SetHelpText(T);
	DefaultHelpText = T;
}

function Sort()
{
	Items.Sort();
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float y;
	local UWindowList CurItem;
	local int i;
	local Color OldColor;	
	CurItem = Items.Next;
	i = 0;

	while ((CurItem != None) && (i < VertSB.Pos)) 
	{
		if (CurItem.ShowThisItem())
			i++;
		CurItem = CurItem.Next;
	}

	for (y = m_IFirstItemYOffset; (y + ItemHeight< WinHeight) && (CurItem != None); CurItem = CurItem.Next)
	{
		if (CurItem.ShowThisItem())
		{
			OldColor = TextColor;
			if (bHotTrack)
			{
				if ((GetItemAt(MouseX, MouseY) == CurItem) && (CurItem != SelectedItem))
				{
					TextColor = SelectionColor;
					TextColor.R = max(0,TextColor.R - 96); 
					TextColor.G = max(0,TextColor.G - 96); 
					TextColor.B = max(0,TextColor.B - 96);
				} 
			}				
		
			if (VertSB.bWindowVisible)
				DrawItem(C, CurItem, 5, y, WinWidth - LookAndFeel.Size_ScrollbarWidth, ItemHeight);
			else
			    DrawItem(C, CurItem, 5, y, WinWidth, ItemHeight);
			y = y + ItemHeight;
			
			TextColor = OldColor;
			
		}
	}   
	
}

function Resized()
{
	Super.Resized();

	VertSB.WinLeft = WinWidth - LookAndFeel.Size_ScrollbarWidth;
	VertSB.WinTop = 0;
	VertSB.SetSize(LookAndFeel.Size_ScrollbarWidth, WinHeight);
}

function UWindowListBoxItem GetItemAt(float MouseX, float MouseY)
{
	local float y;
	local UWindowList CurItem;
	local int i;
	
	if (MouseX < 0 || MouseX > WinWidth)
		return None;

	CurItem = Items.Next;
	i = 0;

	while ((CurItem != None) && (i < VertSB.Pos)) 
	{
		if (CurItem.ShowThisItem())
			i++;
		CurItem = CurItem.Next;
	}

	for (y = m_IFirstItemYOffset; (y < WinHeight) && (CurItem != None); CurItem = CurItem.Next)
	{
		if (CurItem.ShowThisItem())
		{
			if (MouseY >= y && MouseY <= y + ItemHeight)
				return UWindowListBoxItem(CurItem);
			y = y + ItemHeight;
		}
	}

	return None;
}

function MakeSelectedVisible()
{
	local UWindowList CurItem;
	local int i;
	
	VertSB.SetRange(0, Items.CountShown(), int(WinHeight / ItemHeight));

	if (SelectedItem == None)
		return;

	i = 0;
	for (CurItem = Items.Next; CurItem != None; CurItem = CurItem.Next)
	{
		if (CurItem == SelectedItem)
			break;
		if (CurItem.ShowThisItem())
			i++;
	}

	VertSB.Show(i);
}

function SetSelectedItem(UWindowListBoxItem NewSelected)
{
	if (NewSelected != None && SelectedItem != NewSelected)
	{
		if (SelectedItem != None)
			SelectedItem.bSelected = false;

		SelectedItem = NewSelected;

		if (SelectedItem != None)
			SelectedItem.bSelected = true;
		
		Notify(DE_Click);
	}
}

function SetSelected(float X, float Y)
{
	local UWindowListBoxItem NewSelected;

	NewSelected = GetItemAt(X, Y);
	SetSelectedItem(NewSelected);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	SetSelected(X, Y);

	if (bCanDrag || bCanDragExternal)
	{
		bDragging = true;
		Root.CaptureMouse();
		DragY = Y;
	}
}

function DoubleClick(float X, float Y)
{
	Super.DoubleClick(X, Y);

	if (GetItemAt(X, Y) == SelectedItem)
	{
		DoubleClickItem(SelectedItem);
	}	
}

function ReceiveDoubleClickItem(UWindowListBox L, UWindowListBoxItem I)
{
	I.Remove();
	Items.AppendItem(I);
	SetSelectedItem(I);
	L.SelectedItem = None;
	L.Notify(DE_Change);
	Notify(DE_Change);
}

function DoubleClickItem(UWindowListBoxItem I)
{
    Notify(DE_DoubleClick);

	if (DoubleClickList != None && I != None)
		DoubleClickList.ReceiveDoubleClickItem(Self, I);
}

function MouseMove(float X, float Y)
{
	local UWindowListBoxItem OverItem;

	
	Super.MouseMove(X, Y);

	if (bDragging && bMouseDown)
	{
		OverItem = GetItemAt(X, Y);
		if (bCanDrag && OverItem != SelectedItem && OverItem != None && SelectedItem != None)
		{
			SelectedItem.Remove();
			if (Y < DragY)
				OverItem.InsertItemBefore(SelectedItem);
			else
				OverItem.InsertItemAfter(SelectedItem, True);

			Notify(DE_Change);

			DragY = Y;
		}
		else
		{
			if (bCanDragExternal && CheckExternalDrag(X, Y) != None)
				bDragging = false;
		}
	}
	else
		bDragging = false;

//	if (bHotTrack)
//	{
//		OverItem = GetItemAt(X, Y);
//		SetSelectedItem(OverItem);
//	}
		
}

function bool ExternalDragOver(UWindowDialogControl ExternalControl, float X, float Y)
{
	local UWindowListBox B;
	local UWindowListBoxItem OverItem;

	// Subclass should return false and not call this version if this external
	// drag should be denied.

	B = UWindowListBox(ExternalControl);
	if (B != None && B.SelectedItem != None)
	{	
		OverItem = GetItemAt(X, Y);

		B.SelectedItem.Remove();
		if (OverItem != None)
			OverItem.InsertItemBefore(B.SelectedItem);
		else
			Items.AppendItem(B.SelectedItem);

		SetSelectedItem(B.SelectedItem);
		B.SelectedItem = None;
		B.Notify(DE_Change);
		Notify(DE_Change);

		if (bCanDrag || bCanDragExternal)
		{
			Root.CancelCapture();
			bDragging = true;
			bMouseDown = true;
			Root.CaptureMouse(Self);
			DragY = Y;	
		}

		return True;
	}

	return False;	
}


function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{

	local float TX,XL,YL;

// @@Joe - Fixed this to use the TextColor and fonts.  Much nicer :) 
//   FIXME: Update to auto-set the item height 		

	
	if (UWindowListBoxItem(Item).bSelected)
	{
		if (!bNoSelectionBox)
		{
			C.DrawColor = SelectionBkgColor;
			DrawStretchedTexture(C, X, Y, W, H - 1, Texture'WhiteTexture');
		}
		C.DrawColor = SelectionColor;
	}
	else
		C.DrawColor = TextColor;


	C.Font = Root.Fonts[Font];
	C.StrLen(UWindowListBoxItem(Item).Caption,XL,YL);
	
	switch (Align)
	{
		case TXT_LEFT:
			TX = X + 2;
		case TXT_CENTER:
			TX = (W - 4 - XL) / 2;
			break;
		case TXT_RIGHT:
			TX = W - XL - W - 2;
			break;
	}	
	
	ClipText(C, TX, Y, UWindowListBoxItem(Item).Caption);
		
}

function KeyUp(int Key, float X, float Y)
{
	if ((key == 0xC8) || (key == 78)) 
	{
		If (SelectedItem.Prev.Prev != None)
			SetSelectedItem(UWindowListBoxItem(SelectedItem.Prev));
	}
	else if ((key == 0xC9) || (key == 80))
	{
		If (SelectedItem.Next != None)
			SetSelectedItem(UWindowListBoxItem(SelectedItem.Next));
	}
	else if ((key == 0xCD) || (key == 0x0d))
	{
		if ((OwnerWindow != None) && (OwnerWindow.IsA('UWindowDialogClientWindow')))
		{
			UWindowDialogClientWindow(OwnerWindow).Notify(self,DE_Change);
		}
	}

	Super.KeyUp(key,x,y);
	
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
    if (VertSB != None)
	    VertSB.MouseWheelDown(X,Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    if (VertSB != None)
        VertSB.MouseWheelUp(X,Y);
	    
}

defaultproperties
{
    ItemHeight=10.000000
    m_IFirstItemYOffset=3
    ListClass=Class'UWindowListBoxItem'
    TextColor=(R=255,G=255,B=255,A=255)
}