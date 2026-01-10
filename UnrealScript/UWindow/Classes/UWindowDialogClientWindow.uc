class UWindowDialogClientWindow extends UWindowClientWindow
            native;


// Used for scrolling
var float DesiredWidth;
var float DesiredHeight;

var UWindowDialogControl	TabLast;

function OKPressed()
{
}

function Notify(UWindowDialogControl C, byte E)
{
	// Handle this notification in a subclass.
}

function UWindowDialogControl CreateControl(class<UWindowDialogControl> ControlClass, float X, float Y, float W, float H, optional UWindowWindow OwnerWindow)
{
	local UWindowDialogControl C;


	C = UWindowDialogControl(CreateWindow(ControlClass, X, Y, W, H, OwnerWindow));

	C.Register(Self);
	C.Notify(C.DE_Created);

	if (TabLast == None)
	{
		TabLast = C;
		C.TabNext = C;
		C.TabPrev = C;
	}
	else
	{
		C.TabNext = TabLast.TabNext;
		C.TabPrev = TabLast;
		TabLast.TabNext.TabPrev = C;
		TabLast.TabNext = C;

		TabLast = C;
	}

	return C;
}

/*
function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);
	LookAndFeel.DrawClientArea(Self, C);
}
*/


function GetDesiredDimensions(out float W, out float H)
{
	W = DesiredWidth;
	H = DesiredHeight;
}
