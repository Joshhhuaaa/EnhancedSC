class UWindowLayoutRow extends UWindowLayoutBase;

var UWindowLayoutCell	CellList;

function SetupSentinel(optional bool bInTreeSort)
{
	Super.SetupSentinel(bInTreeSort);
	CellList = new class'UWindowLayoutCell';
	CellList.SetupSentinel();
}


function UWindowLayoutCell AddCell(optional int ColSpan, optional int RowSpan)
{
	local UWindowLayoutCell C;

	C = UWindowLayoutCell(CellList.Append(class'UWindowLayoutCell'));
	C.ColSpan = ColSpan;
	C.RowSpan = RowSpan;

	return C;
}

function float CalcMinHeight()
{
	return 0;
}
