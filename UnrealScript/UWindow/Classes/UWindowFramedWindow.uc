//=============================================================================
// UWindowFramedWindow - a Windows95 style framed window
//=============================================================================
class UWindowFramedWindow extends UWindowWindow;


var class<UWindowWindow>	ClientClass;
var UWindowWindow			ClientArea;
var localized string		WindowTitle;
var string					StatusBarText;
var float					MoveX, MoveY;	// co-ordinates where the move was requested
var float					MinWinWidth, MinWinHeight;

var bool					bTLSizing;
var bool					bTSizing;
var bool					bTRSizing;
var bool					bLSizing;
var bool					bRSizing;
var bool					bBLSizing;
var bool					bBSizing;
var bool					bBRSizing;

var bool					bMoving;
var bool					bSizable;
var bool					bStatusBar;
var UWindowFrameCloseBox	CloseBox;


function Created()
{
	Super.Created();

	MinWinWidth = 50;
	MinWinHeight = 50;
	ClientArea = CreateWindow(ClientClass, 4, 16, WinWidth - 8, WinHeight - 20, OwnerWindow);
	CloseBox = UWindowFrameCloseBox(CreateWindow(Class'UWindowFrameCloseBox', WinWidth-20, WinHeight-20, 11, 10));
}

function Texture GetLookAndFeelTexture()
{
	return LookAndFeel.GetTexture(Self);
}

function bool IsActive()
{
	return ParentWindow.ActiveWindow == Self;
}

function BeforePaint(Canvas C, float X, float Y)
{	
	Super.BeforePaint(C, X, Y);
	Resized();
	LookAndFeel.FW_SetupFrameButtons(Self, C);
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.FW_DrawWindowFrame(Self, C);
}

function LMouseDown(float X, float Y)
{
	local FrameHitTest H;
	H = LookAndFeel.FW_HitTest(Self, X, Y);

	Super.LMouseDown(X, Y);


	if(H == HT_TitleBar)
	{
		MoveX = X;
		MoveY = Y;
		bMoving = True;
		Root.CaptureMouse();

		return;
	}

	if(bSizable) 
	{
		switch(H)
		{
		case HT_NW:
			bTLSizing = True;
			Root.CaptureMouse();
			return;
		case HT_NE:
			bTRSizing = True;
			Root.CaptureMouse();
			return;
		case HT_SW:
			bBLSizing = True;
			Root.CaptureMouse();
			return;		
		case HT_SE:
			bBRSizing = True;
			Root.CaptureMouse();
			return;
		case HT_N:
			bTSizing = True;
			Root.CaptureMouse();
			return;
		case HT_S:
			bBSizing = True;
			Root.CaptureMouse();
			return;
		case HT_W:
			bLSizing = True;
			Root.CaptureMouse();
			return;
		case HT_E:
			bRSizing = True;
			Root.CaptureMouse();
			return;
		}
	}
}

function Resized()
{
	local Region R;

	if(ClientArea == None)
	{
		Log("Client Area is None for "$Self);
		return;
	}

	R = LookAndFeel.FW_GetClientArea(Self);

	ClientArea.WinLeft = R.X;
	ClientArea.WinTop = R.Y;

	if((R.W != ClientArea.WinWidth) || (R.H != ClientArea.WinHeight)) 
	{
		ClientArea.SetSize(R.W, R.H);
	}

}

function MouseMove(float X, float Y)
{
	local float OldW, OldH;
	local FrameHitTest H;
	H = LookAndFeel.FW_HitTest(Self, X, Y);


	if(bMoving && bMouseDown)
	{
		WinLeft = Int(WinLeft + X - MoveX);
		WinTop = Int(WinTop + Y - MoveY);
	}
	else
		bMoving = False;


	Cursor = Root.NormalCursor;

	if(bSizable && !bMoving)
	{
		switch(H)
		{
		case HT_NW:
		case HT_SE:
			Cursor = Root.DiagCursor1;
			break;
		case HT_NE:
		case HT_SW:
			Cursor = Root.DiagCursor2;
			break;
		case HT_W:
		case HT_E:
			Cursor = Root.WECursor;
			break;
		case HT_N:
		case HT_S:
			Cursor = Root.NSCursor;
			break;
		}
	}	

	// Top Left
	if(bTLSizing && bMouseDown)
	{
		Cursor = Root.DiagCursor1;	
		OldW = WinWidth;
		OldH = WinHeight;
		SetSize(Max(MinWinWidth, WinWidth - X), Max(MinWinHeight, WinHeight - Y));
		WinLeft = Int(WinLeft + OldW - WinWidth);
		WinTop = Int(WinTop + OldH - WinHeight);
	}
	else 
		bTLSizing = False;


	// Top
	if(bTSizing && bMouseDown)
	{
		Cursor = Root.NSCursor;
		OldH = WinHeight;
		SetSize(WinWidth, Max(MinWinHeight, WinHeight - Y));
		WinTop = Int(WinTop + OldH - WinHeight);
	}
	else 
		bTSizing = False;

	// Top Right
	if(bTRSizing && bMouseDown)
	{
		Cursor = Root.DiagCursor2;
		OldH = WinHeight;
		SetSize(Max(MinWinWidth, X), Max(MinWinHeight, WinHeight - Y));
		WinTop = Int(WinTop + OldH - WinHeight);
	}
	else 
		bTRSizing = False;


	// Left
	if(bLSizing && bMouseDown)
	{
		Cursor = Root.WECursor;
		OldW = WinWidth;
		SetSize(Max(MinWinWidth, WinWidth - X), WinHeight);
		WinLeft = Int(WinLeft + OldW - WinWidth);
	}
	else 
		bLSizing = False;

	// Right
	if(bRSizing && bMouseDown)
	{
		Cursor = Root.WECursor;
		SetSize(Max(MinWinWidth, X), WinHeight);
	}
	else 
		bRSizing = False;

	// Bottom Left
	if(bBLSizing && bMouseDown)
	{
		Cursor = Root.DiagCursor2;
		OldW = WinWidth;
		SetSize(Max(MinWinWidth, WinWidth - X), Max(MinWinHeight, Y));
		WinLeft = Int(WinLeft + OldW - WinWidth);
	}
	else 
		bBLSizing = False;

	// Bottom
	if(bBSizing && bMouseDown)
	{
		Cursor = Root.NSCursor;
		SetSize(WinWidth, Max(MinWinHeight, Y));
	}
	else 
		bBSizing = False;

	// Bottom Right
	if(bBRSizing && bMouseDown)
	{
		Cursor = Root.DiagCursor1;
		SetSize(Max(MinWinWidth, X), Max(MinWinHeight, Y));
	}
	else
		bBRSizing = False;

}

function ToolTip(string strTip)
{
	StatusBarText = strTip;
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	if(Msg == WM_Paint || !WaitModal())
		Super.WindowEvent(Msg, C, X, Y, Key);
}

function WindowHidden()
{
	Super.WindowHidden();
	LookAndFeel.PlayMenuSound(Self, MS_WindowClose);
}

defaultproperties
{
    ClientClass=Class'UWindowClientWindow'
}