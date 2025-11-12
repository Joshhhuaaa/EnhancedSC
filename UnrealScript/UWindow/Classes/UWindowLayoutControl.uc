class UWindowLayoutControl extends UWindowLayoutBase;

var UWindowDialogClientWindow	OwnerWindow;

var float				WinTop;
var float				WinLeft;
var float				WinWidth;
var float				WinHeight;

var float				MinimumWidth;
var float				MinimumHeight;


var UWindowLayoutRow	RowList;


// Methods
static function UWindowLayoutControl Create()
{
	local UWindowLayoutControl C;

	C = new class'UWindowLayoutControl';
	C.RowList = new class'UWindowLayoutRow';
	C.RowList.SetupSentinel();

	return C;
}


/*
Layout procedure

1.  Calculate minimum (desired) row height by asking
    controls
2.  For each column, work out the minimum (desired) width for this column.
    Then add these up and 
	
	.
2.	If this is less than WinHeight, space cells to fit.
3.	If this is more than WinHeight, adjust parent
    window's DesiredWidth/DesiredHeight variables to cause scrolling.


*/

function PerformLayout()
{
	local UWindowLayoutRow R;
	local float TotalWidth;
	local float TotalHeight;

	for (R = UWindowLayoutRow(RowList.Next); R != None; R = UWindowLayoutRow(R.Next))
		TotalHeight += R.CalcMinHeight();

	
		TotalWidth += R.CalcMinHeight();


}

function UWindowLayoutRow AddRow()
{
	return UWindowLayoutRow(RowList.Append(class'UWindowLayoutRow'));
}

function UWindowLayoutCell AddCell(optional int ColSpan, optional int RowSpan)
{
	return RowList.AddCell(ColSpan, RowSpan);
}

