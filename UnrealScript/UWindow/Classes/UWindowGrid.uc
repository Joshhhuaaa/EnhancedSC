//=============================================================================
// UWindowGrid - a grid with sizable columns and clickable column headings.
//=============================================================================
class UWindowGrid extends UWindowWindow;

var UWindowGridColumn FirstColumn;
var UWindowGridColumn LastColumn;
var UWindowGridClient ClientArea;

var int					TopRow;
var float				RowHeight;
var UWindowVScrollbar	VertSB;
var UWindowHScrollbar	HorizSB;
var bool				bShowHorizSB;
var bool				bSizingColumn;
var bool				bNoKeyboard;

function Created()
{
	ClientArea = UWindowGridClient(CreateWindow(class'UWindowGridClient', 0, 0, WinWidth - 12, WinHeight));
	VertSB = UWindowVScrollbar(CreateWindow(class'UWindowVScrollbar', WinWidth - 12, 0, 12, WinHeight));
	VertSB.bAlwaysOnTop = True;

	HorizSB = UWindowHScrollbar(CreateWindow(class'UWindowHScrollbar', 0, WinHeight - 12, WinWidth, 12));
	HorizSB.bAlwaysOnTop = True;
	HorizSB.HideWindow();
	bShowHorizSB = False;

	if (!bNoKeyboard)
		SetAcceptsFocus();

	Super.Created();
}


function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
	Resized();
}

function Resized()
{
	local float Offset;
	local UWindowGridColumn colColumn;
	local float TotalWidth;


	TotalWidth = 0;
	colColumn = FirstColumn;
	while (colColumn != None)
	{
		TotalWidth = TotalWidth + colColumn.WinWidth;
		colColumn = colColumn.NextColumn;
	}

	if (!bSizingColumn)
		HorizSB.SetRange(0, TotalWidth, WinWidth - LookAndFeel.Size_ScrollbarWidth, 10);

	if (!HorizSB.bDisabled)
	{
		// Need a horizontal scrollbar
		HorizSB.ShowWindow();
		bShowHorizSB = True;
	}
	else
	{
		HorizSB.HideWindow();
		bShowHorizSB = False;
		HorizSB.Pos = 0;
	}


	ClientArea.WinTop = 0;
	ClientArea.WinLeft = 0;
	ClientArea.WinWidth = WinWidth - LookAndFeel.Size_ScrollbarWidth;
	if (bShowHorizSB)
		ClientArea.WinHeight = WinHeight - LookAndFeel.Size_ScrollbarWidth;
	else
		ClientArea.WinHeight = WinHeight;


	if (bShowHorizSB)
	{
		HorizSB.WinTop = WinHeight - LookAndFeel.Size_ScrollbarWidth;
		HorizSB.WinLeft = 0;
		HorizSB.WinWidth = WinWidth - LookAndFeel.Size_ScrollbarWidth;
		HorizSB.WinHeight = LookAndFeel.Size_ScrollbarWidth;
	}

	VertSB.WinTop = 0;
	VertSB.WinLeft = WinWidth - LookAndFeel.Size_ScrollbarWidth;
	VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
	if (bShowHorizSB)
		VertSB.WinHeight = WinHeight - LookAndFeel.Size_ScrollbarWidth;
	else
		VertSB.WinHeight = WinHeight;

	
	if (bShowHorizSB)
		Offset = 1 - HorizSB.Pos;
	else
		Offset = 1;

	colColumn = FirstColumn;
	while (colColumn != None)
	{
		colColumn.WinLeft = Offset ;
		colColumn.WinTop = 0;
		colColumn.WinHeight = WinHeight;
		Offset = Offset + colColumn.WinWidth;
		colColumn = colColumn.NextColumn;
	}
}


function UWindowGridColumn AddColumn(string ColumnHeading, float DefaultWidth)
{
	local UWindowGridColumn NewColumn;
	local UWindowGridColumn OldLastColumn;

	OldLastColumn = LastColumn;

	if (LastColumn == None)
	{
		NewColumn = UWindowGridColumn(ClientArea.CreateWindow(class'UWindowGridColumn', 0, 0, DefaultWidth, WinHeight));
		FirstColumn = NewColumn;
		NewColumn.ColumnNum = 0;
	}
	else
	{
		NewColumn = UWindowGridColumn(ClientArea.CreateWindow(class'UWindowGridColumn', LastColumn.WinLeft + LastColumn.WinWidth, 0, DefaultWidth, WinHeight));
		LastColumn.NextColumn = NewColumn;
		NewColumn.ColumnNum = LastColumn.ColumnNum + 1;
	}

	LastColumn = NewColumn;
	NewColumn.NextColumn = None;
	NewColumn.PrevColumn = OldLastColumn;

	NewColumn.ColumnHeading = ColumnHeading;	
	return NewColumn;
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float X;
	local Texture T;
	local Region R;

	X = LastColumn.WinWidth + LastColumn.WinLeft;

	T = GetLookAndFeelTexture();
	DrawUpBevel(C, X, 0, WinWidth - X, LookAndFeel.ColumnHeadingHeight, T);

	if (bShowHorizSB)
	{
		// R = LookAndFeel.SBBackground;
		DrawStretchedTextureSegment(C, WinWidth - LookAndFeel.Size_ScrollbarWidth,
										WinHeight - LookAndFeel.Size_ScrollbarWidth,
										LookAndFeel.Size_ScrollbarWidth,
										LookAndFeel.Size_ScrollbarWidth,
										R.X, R.Y, R.W, R.H, T);
	}
}


function PaintColumn(Canvas C, UWindowGridColumn Column, float MouseX, float MouseY)
{
	// defined in subclass
}

function SortColumn(UWindowGridColumn Column)
{
	// defined in subclass
}

function SelectRow(int Row)
{
	// defined in subclass
}

function RightClickRow(int Row, float X, float Y)
{
	// defined in subclass
}

function RightClickRowDown(int Row, float X, float Y)
{
	// defined in subclass
}

function DoubleClickRow(int Row)
{
	// defined in subclass
}

function MouseLeaveColumn(UWindowGridColumn Column)
{
	// defined in subclass
}

function KeyDown(int Key, float X, float Y)
{
	switch (Key) {
	case 0x26: // IK_Up
	case 0xEC: // IK_MouseWheelUp
		VertSB.Scroll(-1);
		break;
	case 0x28: // IK_Down
	case 0xED: // IK_MouseWheelDown
		VertSB.Scroll(1);
		break;
	case 0x21: // IK_PageUp
		VertSB.Scroll(-(VertSB.MaxVisible - 1));
		break;
	case 0x22: // IK_PageDown
		VertSB.Scroll(VertSB.MaxVisible - 1);
		break;
	}
}

defaultproperties
{
    RowHeight=10.000000
}