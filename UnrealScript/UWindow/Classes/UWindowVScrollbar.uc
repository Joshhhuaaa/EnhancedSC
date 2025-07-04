//=============================================================================
// UWindowVScrollBar - A vertical scrollbar
//=============================================================================
class UWindowVScrollBar extends UWindowWindow
        native;

var UWindowSBUpButton		UpButton;
var UWindowSBDownButton		DownButton;
var bool					bDisabled;
var float					MinPos;
var float					MaxPos;
var float					MaxVisible;
var float					Pos;				// offset to WinTop
var float					ThumbStart, ThumbHeight;
var float					NextClickTime;
var float					DragY;
var bool					bDragging;
var float					ScrollAmount;
var bool                    m_bHideSBWhenDisable;

function Show(float P)
{
	if(P < 0) return;
	if(P > MaxPos + MaxVisible) return;

	while(P < Pos) 
		if(!Scroll(-1))
			break;
	while(P - Pos > MaxVisible - 1)
		if(!Scroll(1))
			break;
}

function bool Scroll(float Delta)
{
	local float OldPos;

	OldPos = Pos;
	Pos = Pos + Delta;
	CheckRange();
	return Pos == OldPos + Delta;
}

function SetRange(float NewMinPos, float NewMaxPos, float NewMaxVisible, optional float NewScrollAmount)
{
	if(NewScrollAmount == 0)
		NewScrollAmount = 1;

	ScrollAmount = NewScrollAmount;
	MaxPos = NewMaxPos - NewMaxVisible;
	MaxVisible = NewMaxVisible;

	CheckRange();
}

function CheckRange()
{
	if(Pos < MinPos)
	{
		Pos = MinPos;
	}
	else
	{
		if(Pos > MaxPos) Pos = MaxPos;
	}

	bDisabled = (MaxPos <= MinPos);
	DownButton.bDisabled = bDisabled;
	UpButton.bDisabled = bDisabled;

	if(bDisabled)
	{
		Pos = 0;
	}
	else
	{
		ThumbStart = ((Pos - MinPos) * (WinHeight - (2*LookAndFeel.Size_ScrollbarButtonHeight))) / (MaxPos + MaxVisible - MinPos);
		ThumbHeight = (MaxVisible * (WinHeight - (2*LookAndFeel.Size_ScrollbarButtonHeight))) / (MaxPos + MaxVisible - MinPos);

		if(ThumbHeight < LookAndFeel.Size_MinScrollbarHeight) 
			ThumbHeight = LookAndFeel.Size_MinScrollbarHeight;
		
		if(ThumbHeight + ThumbStart > WinHeight - (2*LookAndFeel.Size_ScrollbarButtonHeight))
		{
			ThumbStart = WinHeight - (2*LookAndFeel.Size_ScrollbarButtonHeight) - ThumbHeight;
		}
		ThumbStart = ThumbStart + LookAndFeel.Size_ScrollbarButtonHeight;
	}
}

function Created()
{	
	UpButton = UWindowSBUpButton(CreateWindow(class'UWindowSBUpButton', 0, 0, LookAndFeel.Size_ScrollbarWidth, LookAndFeel.Size_ScrollbarButtonHeight));
	DownButton = UWindowSBDownButton(CreateWindow(class'UWindowSBDownButton', 0, WinHeight-LookAndFeel.Size_ScrollbarButtonHeight, LookAndFeel.Size_ScrollbarWidth, LookAndFeel.Size_ScrollbarButtonHeight));
}

function BeforePaint(Canvas C, float X, float Y)
{
	UpButton.WinTop = 0;
	UpButton.WinLeft = 0;
	UpButton.WinWidth = LookAndFeel.Size_ScrollbarWidth;
	UpButton.WinHeight = LookAndFeel.Size_ScrollbarButtonHeight;

	DownButton.WinTop = WinHeight - LookAndFeel.Size_ScrollbarButtonHeight;
	DownButton.WinLeft = 0;
	DownButton.WinWidth = LookAndFeel.Size_ScrollbarWidth;
	DownButton.WinHeight = LookAndFeel.Size_ScrollbarButtonHeight;

	CheckRange();
}

function Paint(Canvas C, float X, float Y) 
{
    if ( isHidden()  )
            return;

	LookAndFeel.SB_VDraw(Self, C);
}

function bool isHidden()
{
    return (bDisabled && m_bHideSBWhenDisable);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	if(bDisabled) return;

	if(Y < ThumbStart)
	{
		Scroll(-(MaxVisible-1));
		NextClickTime = GetTime() + 0.5;
		return;
	}
	if(Y > ThumbStart + ThumbHeight)
	{
		Scroll(MaxVisible-1);
		NextClickTime = GetTime() + 0.5;
		return;
	}

	if((Y >= ThumbStart) && (Y <= ThumbStart + ThumbHeight))
	{
		DragY = Y - ThumbStart;
		bDragging = True;
		Root.CaptureMouse();
		return;
	}
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
    if(!bDisabled)
	    Scroll(1);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    if(!bDisabled)
	    Scroll(-1);
}

function Tick(float Delta)
{
	local bool bUp, bDown;
	local float X, Y;

	if(bDragging) return;

	bUp = False;
	bDown = False;

	if(bMouseDown)
	{
		GetMouseXY(X, Y);
		bUp = (Y < ThumbStart);
		bDown = (Y > ThumbStart + ThumbHeight);
	}
	
	if(bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime())  && bUp)
	{
		Scroll(-(MaxVisible-1));
		NextClickTime = GetTime() + 0.1;
	}

	if(bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime())  && bDown)
	{
		Scroll(MaxVisible-1);
		NextClickTime = GetTime() + 0.1;
	}

	if(!bMouseDown || (!bUp && !bDown))
	{
		NextClickTime = 0;
	}
}

function MouseMove(float X, float Y)
{
	if(bDragging && bMouseDown && !bDisabled)
	{
		while(Y < (ThumbStart+DragY) && Pos > MinPos)
		{
			Scroll(-1);
		}

		while(Y > (ThumbStart+DragY) && Pos < MaxPos)
		{
			Scroll(1);
		}	
	}
	else
		bDragging = False;
}

function SetBorderColor(Color c)
{
    m_BorderColor = c;
    UpButton.m_BorderColor = c;
    DownButton.m_BorderColor = c;
}

function SetHideWhenDisable( BOOL _bHideWhenDisable)
{
    m_bHideSBWhenDisable = _bHideWhenDisable;
    UpButton.m_bHideSBWhenDisable = _bHideWhenDisable;
    DownButton.m_bHideSBWhenDisable = _bHideWhenDisable;
}
