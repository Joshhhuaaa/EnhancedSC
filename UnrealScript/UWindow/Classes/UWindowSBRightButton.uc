//=============================================================================
// UWindowSBRightButton - Scrollbar right button
//=============================================================================
class UWindowSBRightButton extends UWindowButton
                native;

var float NextClickTime;

function Created()
{
	bNoKeyboard = True;
	Super.Created();
    LookAndFeel.SB_SetupRightButton(Self);
}


function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	if (bDisabled)
		return;
	UWindowHScrollBar(ParentWindow).Scroll(UWindowHScrollBar(ParentWindow).ScrollAmount);
	NextClickTime = GetTime() + 0.5;
}

function Tick(float Delta)
{
	if (bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()))
	{
		UWindowHScrollBar(ParentWindow).Scroll(UWindowHScrollBar(ParentWindow).ScrollAmount);
		NextClickTime = GetTime() + 0.1;
	}

	if (!bMouseDown)
	{
		NextClickTime = 0;
	}
}
