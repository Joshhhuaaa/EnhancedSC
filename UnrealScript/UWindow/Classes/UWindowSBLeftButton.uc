//=============================================================================
// UWindowSBLeftButton - Scrollbar left button
//=============================================================================
class UWindowSBLeftButton extends UWindowButton
                native;

var float NextClickTime;

function Created()
{
	bNoKeyboard = true;
	Super.Created();
    LookAndFeel.SB_SetupLeftButton(Self);
}


function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	if (bDisabled)
		return;
	UWindowHScrollBar(ParentWindow).Scroll(-UWindowHScrollBar(ParentWindow).ScrollAmount);
	NextClickTime = GetTime() + 0.5;
}

function Tick(float Delta)
{
	if (bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()))
	{
		UWindowHScrollBar(ParentWindow).Scroll(-UWindowHScrollBar(ParentWindow).ScrollAmount);
		NextClickTime = GetTime() + 0.1;
	}

	if (!bMouseDown)
	{
		NextClickTime = 0;
	}
}
