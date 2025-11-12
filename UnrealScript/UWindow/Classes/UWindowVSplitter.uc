//=============================================================================
// UWindowVSplitter - a vertical splitter component
//=============================================================================
class UWindowVSplitter extends UWindowWindow;

var UWindowWindow			TopClientWindow;
var UWindowWindow			BottomClientWindow;
var bool					bSizing;
var float					SplitPos;
var float					MinWinHeight;
var float					MaxSplitPos;
var float					OldWinHeight;
var bool					bBottomGrow;
var bool					bSizable;

function Created() 
{
	Super.Created();
	bAlwaysBehind = True;
	SplitPos = WinHeight / 2;
	MinWinHeight = 24;

	OldWinHeight = WinHeight;
}

function Paint(Canvas C, float X, float Y) 
{
	local Texture T;

	T = GetLookAndFeelTexture();
	DrawUpBevel(C, 0, SplitPos, WinWidth, 7, T);
}

function BeforePaint(Canvas C, float X, float Y) 
{
	local float NewW, NewH;

	// Make Top panel resize
	if (OldWinHeight != WinHeight && !bBottomGrow)
	{
		SplitPos = SplitPos + WinHeight - OldWinHeight;
	}

	SplitPos = FClamp(SplitPos, MinWinHeight, WinHeight - 7 - MinWinHeight);
	if (MaxSplitPos != 0)
		SplitPos = FClamp(SplitPos, 0, MaxSplitPos);

	NewW = WinWidth;
	NewH = SplitPos;

	if (NewW != TopClientWindow.WinWidth || NewH != TopClientWindow.WinHeight)
	{
		TopClientWindow.SetSize(NewW, NewH);
	}

	NewH = WinHeight - SplitPos - 7;

	if (NewW != BottomClientWindow.WinWidth || NewH != BottomClientWindow.WinHeight)
	{
		BottomClientWindow.SetSize(NewW, NewH);
	}
	BottomClientWindow.WinTop = SplitPos + 7;
	BottomClientWindow.WinLeft = 0;

	OldWinHeight = WinHeight;
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	if (bSizable && (Y >= SplitPos) && (Y <= SplitPos + 7)) 
	{
		bSizing = True;
		Root.CaptureMouse();
	}
}

function MouseMove(float X, float Y)
{

	if (bSizable && (Y >= SplitPos) && (Y <= SplitPos + 7)) 
		Cursor = Root.VSplitCursor;
	else
		Cursor = Root.NormalCursor;

	if (bSizing && bMouseDown)
	{
		SplitPos = Y;
	} else bSizing = False;
}

defaultproperties
{
    bSizable=true
}