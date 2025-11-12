//=============================================================================
// UWindowHScrollBar - A horizontal scrollbar
//=============================================================================
class UWindowHScrollBar extends UWindowDialogControl
            native;

var UWindowSBLeftButton		LeftButton;
var UWindowSBRightButton	RightButton;
var bool					bDisabled;
var float					MinPos;
var float					MaxPos;
var float					MaxVisible;
var float					Pos;				// offset to WinTop
var float					ThumbStart, ThumbWidth;
var float					NextClickTime;
var float					DragX;
var bool					bDragging;
var float					ScrollAmount;

function Show(float P)
{
	if (P < 0) return;
	if (P > MaxPos + MaxVisible) return;

	while (P < Pos) 
		if (!Scroll(-1))
			break;
	while (P - Pos > MaxVisible - 1)
		if (!Scroll(1))
			break;
}

function bool Scroll(float Delta) 
{
	local float OldPos;
	
	OldPos = Pos;
	Pos = Pos + Delta;
	CheckRange();
    Notify(DE_Change);
	return Pos == OldPos + Delta;
}

function SetRange(float NewMinPos, float NewMaxPos, float NewMaxVisible, optional float NewScrollAmount)
{
	if (NewScrollAmount == 0)
		NewScrollAmount = 1;

	ScrollAmount = NewScrollAmount;
	MinPos = NewMinPos;
	MaxPos = NewMaxPos - NewMaxVisible;
	MaxVisible = NewMaxVisible;

	CheckRange();
}

function CheckRange() 
{
	if (Pos < MinPos)
	{
		Pos = MinPos;
	}
	else
	{
		if (Pos > MaxPos) Pos = MaxPos;
	}

	bDisabled = (MaxPos <= MinPos);
	LeftButton.bDisabled = bDisabled;
	RightButton.bDisabled = bDisabled;

	if (bDisabled)
	{
		Pos = 0;
	}
	else
	{
		ThumbStart = ((Pos - MinPos) * (WinWidth - (2 * LookAndFeel.Size_HScrollbarButtonWidth))) / (MaxPos + MaxVisible - MinPos);
		ThumbWidth = (MaxVisible * (WinWidth - (2 * LookAndFeel.Size_HScrollbarButtonWidth))) / (MaxPos + MaxVisible - MinPos);

		if (ThumbWidth < LookAndFeel.Size_HMinScrollbarWidth) 
			ThumbWidth = LookAndFeel.Size_HMinScrollbarWidth;
		
		if (ThumbWidth + ThumbStart > WinWidth - 2 * LookAndFeel.Size_HScrollbarButtonWidth)
		{
			ThumbStart = WinWidth - 2 * LookAndFeel.Size_HScrollbarButtonWidth - ThumbWidth;
		}

		ThumbStart = ThumbStart + LookAndFeel.Size_HScrollbarButtonWidth;
	}
}

function Created() 
{
	Super.Created();
	LeftButton = UWindowSBLeftButton(CreateWindow(class'UWindowSBLeftButton', 0, 0, LookAndFeel.Size_HScrollbarButtonWidth, LookAndFeel.Size_HScrollbarHeight));
	RightButton = UWindowSBRightButton(CreateWindow(class'UWindowSBRightButton', WinWidth - LookAndFeel.Size_HScrollbarButtonWidth, 0, LookAndFeel.Size_HScrollbarButtonWidth, LookAndFeel.Size_HScrollbarHeight));
}


function BeforePaint(Canvas C, float X, float Y)
{
	LeftButton.WinTop = 0;
	LeftButton.WinLeft = 0;
	LeftButton.WinWidth = LookAndFeel.Size_HScrollbarButtonWidth;
	LeftButton.WinHeight = LookAndFeel.Size_HScrollbarHeight;

	RightButton.WinTop = 0;
	RightButton.WinLeft = WinWidth - LookAndFeel.Size_HScrollbarButtonWidth;
	RightButton.WinWidth = LookAndFeel.Size_HScrollbarButtonWidth;
	RightButton.WinHeight = LookAndFeel.Size_HScrollbarHeight;

	CheckRange();
}

function Paint(Canvas C, float X, float Y) 
{
	LookAndFeel.SB_HDraw(Self, C);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	if (bDisabled) return;

	if (X < ThumbStart)
	{
		Scroll(-(MaxVisible - 1));
		NextClickTime = GetTime() + 0.5;
		return;
	}
	if (X > ThumbStart + ThumbWidth)
	{
		Scroll(MaxVisible - 1);
		NextClickTime = GetTime() + 0.5;
		return;
	}

	if ((X >= ThumbStart) && (X <= ThumbStart + ThumbWidth))
	{
		DragX = X - ThumbStart;
		bDragging = True;
		Root.CaptureMouse();
		return;
	}
}


function Tick(float Delta) 
{
	local bool bLeft, bRight;
	local float X, Y;

	if (bDragging) return;

	bLeft = False;
	bRight = False;

	if (bMouseDown)
	{
		GetMouseXY(X, Y);
		bLeft = (X < ThumbStart);
		bRight = (X > ThumbStart + ThumbWidth);
	}
	
	if (bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime())  && bLeft)
	{
		Scroll(-(MaxVisible - 1));
		NextClickTime = GetTime() + 0.1;
	}

	if (bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime())  && bRight)
	{
		Scroll(MaxVisible - 1);
		NextClickTime = GetTime() + 0.1;
	}

	if (!bMouseDown || (!bLeft && !bRight))
	{
		NextClickTime = 0;
	}
}

function MouseMove(float X, float Y)
{
	if (bDragging && bMouseDown && !bDisabled)
	{
		while (X < (ThumbStart + DragX) && Pos > MinPos)
		{
			Scroll(-1);
		}

		while (X > (ThumbStart + DragX) && Pos < MaxPos)
		{
			Scroll(1);
		}	
	}
	else
		bDragging = False;
}
