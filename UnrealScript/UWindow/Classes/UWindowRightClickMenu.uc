class UWindowRightClickMenu extends UWindowPulldownMenu;

function Created()
{
	bTransient = true;
	Super.Created();
}

function RMouseDown(float X, float Y)
{
	LMouseDown(X, Y);
}

function RMouseUp(float X, float Y)
{
	LMouseUp(X, Y);
}

function CloseUp(optional bool bByOwner)
{
	Super.CloseUp(bByOwner);
	HideWindow();
}
