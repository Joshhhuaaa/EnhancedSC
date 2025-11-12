//=============================================================================
// UWindowGridColumn - a grid column
//=============================================================================
class UWindowGridColumn extends UWindowWindow;

var UWindowGridColumn NextColumn;
var UWindowGridColumn PrevColumn;
var bool				bSizing;
var string				ColumnHeading;
var int					ColumnNum;

function Created() {
	Super.Created();
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
	if (WinWidth < 1) WinWidth = 1;
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	if (X > Min(WinWidth - 5, ParentWindow.WinWidth - WinLeft - 5) && Y < 12)
	{
		bSizing = True;
		UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = True;
		Root.CaptureMouse();
	}

}

function LMouseUp(float X, float Y)
{
	Super.LMouseUp(X, Y);

	UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = False;
}

function MouseMove(float X, float Y)
{
	if (X > Min(WinWidth - 5, ParentWindow.WinWidth - WinLeft - 5) && Y < 12)
	{
		Cursor = Root.HSplitCursor;
	}
	else
	{
		Cursor = Root.NormalCursor;
	}

	if (bSizing && bMouseDown)
	{
		WinWidth = X;
		if (WinWidth < 1) WinWidth = 1;
		if (WinWidth > ParentWindow.WinWidth - WinLeft - 1) WinWidth = ParentWindow.WinWidth - WinLeft - 1;
	}
	else
	{
		bSizing = False;
		UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = False;
	}
}

function Paint(Canvas C, float X, float Y)
{
	local Region R;
	local Texture T;
	local Color FC;

	UWindowGrid(ParentWindow.ParentWindow).PaintColumn(C, Self, X, Y);

	if (IsActive())
	{
		T = LookAndFeel.Active;
		FC = LookAndFeel.HeadingActiveTitleColor;
	}
	else
	{
		T = LookAndFeel.InActive;
		FC = LookAndFeel.HeadingInactiveTitleColor;
	}

	C.SetDrawColor(255,255,255);

	DrawUpBevel(C, 0, 0, WinWidth, LookAndFeel.ColumnHeadingHeight, T);

	C.DrawColor = FC;

	ClipText(C, 2, 1, ColumnHeading);

	C.SetDrawColor(255,255,255);
}

function Click(float X, float Y)
{
	local int Row;

	if (Y < 12)
	{
		if (X <= Min(WinWidth - 5, ParentWindow.WinWidth - WinLeft - 5))
		{
			UWindowGrid(ParentWindow.ParentWindow).SortColumn(Self);
		}
	}
	else
	{
		Row = ((Y - 12) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
	}
}

function RMouseDown(float X, float Y)
{
	local int Row;
	Super.RMouseDown(X, Y);

	if (Y > 12)
	{
		Row = ((Y - 12) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
		UWindowGrid(ParentWindow.ParentWindow).RightClickRowDown(Row, X + WinLeft, Y + WinTop);
	}
}

function RMouseUp(float X, float Y)
{
	local int Row;
	Super.RMouseUp(X, Y);

	if (Y > 12)
	{
		Row = ((Y - 12) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
		UWindowGrid(ParentWindow.ParentWindow).RightClickRow(Row, X + WinLeft, Y + WinTop);
	}
}

function DoubleClick(float X, float Y)
{
	local int Row;

	if (Y < 12)
	{
		Click(X, Y);
	}
	else
	{
		Row = ((Y - 12) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).DoubleClickRow(Row);
	}
}

function MouseLeave()
{
	Super.MouseLeave();
	UWindowGrid(ParentWindow.ParentWindow).MouseLeaveColumn(Self);
}
