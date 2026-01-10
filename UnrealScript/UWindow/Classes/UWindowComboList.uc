class UWindowComboList extends UWindowListControl
                    native;

var UWindowComboControl		Owner;
var UWindowVScrollBar		VertSB;
var UWindowComboListItem	Selected;
var int ItemHeight;
var int VBorder;
var int HBorder;
var int TextBorder;
var int MaxVisible;

function Sort()
{
	Items.Sort();
}

function WindowShown()
{
	Super.WindowShown();
	FocusWindow();
}

function Clear()
{
	Items.Clear();
}

function Texture GetLookAndFeelTexture()
{
	return LookAndFeel.Active;
}

function Setup()
{
	VertSB = UWindowVScrollBar(CreateWindow(class'UWindowVScrollBar', 0, WinWidth - 16, 16, WinHeight));
}

function Created()
{
	ListClass = class'UWindowComboListItem';
	bAlwaysOnTop = true;
	bTransient = true;
	ItemHeight = 15;
	VBorder = 3;
	HBorder = 3;
	TextBorder = 9;
	Super.Created();

}

function int FindItemIndex(string Value, optional bool bIgnoreCase)
{
	local UWindowComboListItem I;
	local int Count;

	I = UWindowComboListItem(Items.Next);
	Count = 0;

	while (I != None)
	{
		if (bIgnoreCase && I.Value ~= Value) return Count;
		if (I.Value == Value) return Count;

		Count++;
		I = UWindowComboListItem(I.Next);
	}

	return -1;
}

function int FindItemIndex2(string Value2, optional bool bIgnoreCase)
{
	local UWindowComboListItem I;
	local int Count;

	I = UWindowComboListItem(Items.Next);
	Count = 0;

	while (I != None)
	{
		if (bIgnoreCase && I.Value2 ~= Value2) return Count;
		if (I.Value2 == Value2) return Count;

		Count++;
		I = UWindowComboListItem(I.Next);
	}

	return -1;
}

function string GetItemValue(int Index)
{
	local UWindowComboListItem I;
	local int Count;

	I = UWindowComboListItem(Items.Next);
	Count = 0;

	while (I != None)
	{
		if (Count == Index) return I.Value;

		Count++;
		I = UWindowComboListItem(I.Next);
	}

	return "";
}

function RemoveItem(int Index)
{
	local UWindowComboListItem I;
	local int Count;

	if (Index == -1)
		return;

	I = UWindowComboListItem(Items.Next);
	Count = 0;

	while (I != None)
	{
		if (Count == Index)
		{
			I.Remove();
			return;
		}

		Count++;
		I = UWindowComboListItem(I.Next);
	}
}

function string GetItemValue2(int Index)
{
	local UWindowComboListItem I;
	local int Count;

	I = UWindowComboListItem(Items.Next);
	Count = 0;

	while (I != None)
	{
		if (Count == Index) return I.Value2;

		Count++;
		I = UWindowComboListItem(I.Next);
	}

	return "";
}

function AddItem(string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem I;
	I = UWindowComboListItem(Items.Append(class'UWindowComboListItem'));
	I.Value = Value;
	I.Value2 = Value2;
	I.SortWeight = SortWeight;
}

function InsertItem(string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem I;
	I = UWindowComboListItem(Items.Insert(class'UWindowComboListItem'));
	I.Value = Value;
	I.Value2 = Value2;
	I.SortWeight = SortWeight;
}

function SetSelected(float X, float Y)
{
	local UWindowComboListItem NewSelected, Item;
	local int i, Count;

	Count = 0;
	for (Item = UWindowComboListItem(Items.Next);Item != None; Item = UWindowComboListItem(Item.Next))
		Count++;

	i = (Y - VBorder) / ItemHeight + VertSB.Pos;

	if (i < 0)
		i = 0;

	if (i >= VertSB.Pos + Min(Count, MaxVisible))
		i = VertSB.Pos + Min(Count, MaxVisible) - 1;

	NewSelected = UWindowComboListItem(Items.FindEntry(i));

	if (NewSelected != Selected)
	{
		if (NewSelected == None)
			Selected = None;
		else
			Selected = NewSelected;
	}
}

function MouseMove(float X, float Y)
{
	Super.MouseMove(X, Y);
	if (Y > WinHeight) VertSB.Scroll(1);
	if (Y < 0) VertSB.Scroll(-1);

	SetSelected(X, Y);

	FocusWindow();
}

function LMouseUp(float X, float Y)
{
	If (Y >= 0 && Y <= WinHeight && Selected != None)
	{
		ExecuteItem(Selected);
	}
	Super.LMouseUp(X, Y);
}

function LMouseDown(float X, float Y)
{
	Root.CaptureMouse();
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H, MaxWidth;
	local int Count;
	local UWindowComboListItem I;
	local float ListX, ListY;
	local float ExtraWidth;

	C.Font = Root.Fonts[F_Normal];
	C.SetPos(0, 0);

	MaxWidth = Owner.EditBoxWidth;
	ExtraWidth = ((HBorder + TextBorder) * 2);

	Count = Items.Count();
	if (Count > MaxVisible)
	{
		ExtraWidth += LookAndFeel.Size_ScrollbarWidth;
		WinHeight = (ItemHeight * MaxVisible) + (VBorder * 2);
	}
	else
	{
		VertSB.Pos = 0;
		WinHeight = (ItemHeight * Count) + (VBorder * 2);
	}

	for (I = UWindowComboListItem(Items.Next);I != None; I = UWindowComboListItem(I.Next))
	{
		TextSize(C, RemoveAmpersand(I.Value), W, H);
		if (W + ExtraWidth > MaxWidth)
			MaxWidth = W + ExtraWidth;
	}

	WinWidth = MaxWidth;

	ListX = Owner.EditAreaDrawX + Owner.EditBoxWidth - WinWidth;
	ListY = Owner.Button.WinTop + Owner.Button.WinHeight;

	if (Count > MaxVisible)
	{
		VertSB.ShowWindow();
		VertSB.SetRange(0, Count, MaxVisible);
		VertSB.WinLeft = WinWidth - LookAndFeel.Size_ScrollbarWidth - HBorder;
		VertSB.WinTop = HBorder;
		VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinHeight = WinHeight - 2 * VBorder;
	}
	else
	{
		VertSB.HideWindow();
	}

	Owner.WindowToGlobal(ListX, ListY, WinLeft, WinTop);
}

function Paint(Canvas C, float X, float Y)
{
	local int Count;
	local UWindowComboListItem I;

	DrawMenuBackground(C);

	Count = 0;

	for (I = UWindowComboListItem(Items.Next);I != None; I = UWindowComboListItem(I.Next))
	{
		if (VertSB.bWindowVisible)
		{
			if (Count >= VertSB.Pos)
				DrawItem(C, I, HBorder, VBorder + (ItemHeight * (Count - VertSB.Pos)), WinWidth - (2 * HBorder) - VertSB.WinWidth, ItemHeight);
		}
		else
			DrawItem(C, I, HBorder, VBorder + (ItemHeight * Count), WinWidth - (2 * HBorder), ItemHeight);
		Count++;
	}
}

function DrawMenuBackground(Canvas C)
{
	LookAndFeel.ComboList_DrawBackground(Self, C);
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	LookAndFeel.ComboList_DrawItem(Self, C, X, Y, W, H, UWindowComboListItem(Item).Value, Selected == Item);
}

function ExecuteItem(UWindowComboListItem I)
{
	Owner.SetValue(I.Value, I.Value2);
	CloseUp();
}

function CloseUp()
{
	Owner.CloseUp();
}

function FocusOtherWindow(UWindowWindow W)
{
	Super.FocusOtherWindow(W);

	if (bWindowVisible && W.ParentWindow.ParentWindow != Self && W.ParentWindow != Self && W.ParentWindow != Owner)
		CloseUp();
}

defaultproperties
{
    MaxVisible=10
    m_BorderColor=(R=51,G=51,B=51,A=255)
}