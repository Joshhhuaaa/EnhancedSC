//=============================================================================
// UWindowSBUpButton - Scrollbar up button
//=============================================================================
class UWindowSBUpButton extends UWindowButton
            native;

var float NextClickTime;
var bool  m_bHideSBWhenDisable;

function Created()
{
	bNoKeyboard = true;
	Super.Created();
    LookAndFeel.SB_SetupUpButton(Self);
}

function Paint(Canvas C, float X, float Y) 
{
    if (bDisabled && m_bHideSBWhenDisable)
            return;

    Super.Paint(C, X, Y);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	if (bDisabled)
		return;
	UWindowVScrollBar(ParentWindow).Scroll(-UWindowVScrollBar(ParentWindow).ScrollAmount);
	NextClickTime = GetTime() + 0.5;
}

function Tick(float Delta)
{
	if (bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()))
	{
		UWindowVScrollBar(ParentWindow).Scroll(-UWindowVScrollBar(ParentWindow).ScrollAmount);
		NextClickTime = GetTime() + 0.1;
	}

	if (!bMouseDown)
	{
		NextClickTime = 0;
	}
}
