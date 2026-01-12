class UWindowBitmap extends UWindowWindow;

var Texture T;
var Region	R;
var bool	bStretch;
var bool	bCenter;


function Paint(Canvas C, float X, float Y)
{
    // *************************************************************************
    // * BEGIN UBI MODIF
    // * MClarke (15 Jan 2003)
    // * Purpose : EAX Logo in Sound configs
    // *************************************************************************
    C.Style = GetLevel().ERenderStyle.STY_Alpha;
    // *************************************************************************
    // * END UBI MODIF
    // * MClarke (15 Jan 2003)
    // *************************************************************************

	if (bStretch)
	{
		DrawStretchedTextureSegment(C, 0, 0, WinWidth, WinHeight, R.X, R.Y, R.W, R.H, T);
	}
	else
	{
		if (bCenter)
		{
			DrawStretchedTextureSegment(C, (WinWidth - R.W) / 2, (WinHeight - R.H) / 2, R.W, R.H, R.X, R.Y, R.W, R.H, T);
		}
		else
		{
			DrawStretchedTextureSegment(C, 0, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T);
		}
	}
}

// Joshua - Allow page scrolling when mouse is over the bitmap
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Joshua - Find the listbox in our parent window and pass the scroll event to it
	if (ParentWindow != None && ParentWindow.ParentWindow != None)
	{
		W = ParentWindow.ParentWindow.FirstChildWindow;
		while (W != None)
		{
			if (UWindowListBox(W) != None)
			{
				W.MouseWheelDown(X, Y);
				return;
			}
			W = W.NextSiblingWindow;
		}
	}
}

// Joshua - Allow page scrolling when mouse is over the bitmap
function MouseWheelUp(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Joshua - Find the listbox in our parent window and pass the scroll event to it
	if (ParentWindow != None && ParentWindow.ParentWindow != None)
	{
		W = ParentWindow.ParentWindow.FirstChildWindow;
		while (W != None)
		{
			if (UWindowListBox(W) != None)
			{
				W.MouseWheelUp(X, Y);
				return;
			}
			W = W.NextSiblingWindow;
		}
	}
}
