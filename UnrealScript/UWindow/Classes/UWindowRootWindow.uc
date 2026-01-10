//=============================================================================
// UWindowRootWindow - the root window.
//
// This Window should be subclassed for each different type of menuing system.
// In many cases, there should be at least 1 UWindowRootWindow that contains
// at the very least the console.
//=============================================================================
class UWindowRootWindow extends UWindowWindow
        native;

#exec TEXTURE IMPORT NAME=MouseCursor FILE=Textures\MouseCursor.dds GROUP="Icons" MIPS=OFF ALPHA=1 MASKED=1
#exec TEXTURE IMPORT NAME=MouseMove FILE=Textures\MouseMove.bmp GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseDiag1 FILE=Textures\MouseDiag1.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseDiag2 FILE=Textures\MouseDiag2.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseNS FILE=Textures\MouseNS.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseWE FILE=Textures\MouseWE.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseHand FILE=Textures\MouseHand.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseHSplit FILE=Textures\MouseHSplit.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseVSplit FILE=Textures\MouseVSplit.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseWait FILE=Textures\MouseWait.dds GROUP="Icons" ALPHA=1 MASKED=1 MIPS=OFF

var UWindowWindow		MouseWindow;		// The window the mouse is over
var bool				bMouseCapture;
var float				MouseX, MouseY;
var float				OldMouseX, OldMouseY;
var WindowConsole		Console;
var UWindowWindow		FocusedWindow;
var UWindowWindow		KeyFocusWindow;		// window with keyboard focus
var MouseCursor			NormalCursor, MoveCursor, DiagCursor1, HandCursor, HSplitCursor, VSplitCursor, DiagCursor2, NSCursor, WECursor, WaitCursor;
var bool				bQuickKeyEnable;
var UWindowHotkeyWindowList	HotkeyWindows;

//var config float		GUIScale;
var  FLOAT		        GUIScale; //Alex- This is to prevent set res call to ovewrite this value in config file


var float				RealWidth, RealHeight;
var Font				Fonts[10];
var UWindowLookAndFeel	LooksAndFeels[20];
//var config string		LookAndFeelClass;
var string		        LookAndFeelClass;
var bool				bRequestQuit;
var float				QuitTime;
var bool				bAllowConsole;
var bool				bDisableMouseDisplay;


//Mainly to provide the R6Console the ability to change the current Widget
enum eGameWidgetID
{
    WidgetID_InGameDataDetails,
    WidgetID_InGameMenu,
    WidgetID_MainMenu,
    WidgetID_Credits,
    WidgetID_Options,
    WidgetID_Player,
    WidgetID_SaveGames,
	WidgetID_Intro,
    WidgetID_FakeWindow,
    WidgetID_Previous,
    WidgetID_None
};

function ChangeCurrentWidget(eGameWidgetID widgetID);
function ResetMenus();
function PlayClickSound();

function BeginPlay()
{
	Root = Self;
	MouseWindow = Self;
	KeyFocusWindow = Self;
}

function UWindowLookAndFeel GetLookAndFeel(String LFClassName)
{
	local int i;
	local class<UWindowLookAndFeel> LFClass;

	LFClass = class<UWindowLookAndFeel>(DynamicLoadObject(LFClassName, class'Class'));

	for (i = 0; i < 20; i++)
	{
		if (LooksAndFeels[i] == None)
		{
			LooksAndFeels[i] = new LFClass;
			LooksAndFeels[i].Setup();
			return LooksAndFeels[i];
		}

		if (LooksAndFeels[i].Class == LFClass)
			return LooksAndFeels[i];
	}
	Log("Out of LookAndFeel array space!!");
	return None;
}


function Created()
{
    LookAndFeel = GetLookAndFeel(LookAndFeelClass);

    SetupFonts();

	NormalCursor.tex = Texture'MouseCursor';
	NormalCursor.HotX = 0;
	NormalCursor.HotY = 0;
	NormalCursor.WindowsCursor = Console.ViewportOwner.IDC_ARROW;

	MoveCursor.tex = Texture'MouseMove';
	MoveCursor.HotX = 8;
	MoveCursor.HotY = 8;
	MoveCursor.WindowsCursor = Console.ViewportOwner.IDC_SIZEALL;

	DiagCursor1.tex = Texture'MouseDiag1';
	DiagCursor1.HotX = 8;
	DiagCursor1.HotY = 8;
	DiagCursor1.WindowsCursor = Console.ViewportOwner.IDC_SIZENWSE;

	HandCursor.tex = Texture'MouseHand';
	HandCursor.HotX = 11;
	HandCursor.HotY = 1;
	HandCursor.WindowsCursor = Console.ViewportOwner.IDC_ARROW;

	HSplitCursor.tex = Texture'MouseHSplit';
	HSplitCursor.HotX = 9;
	HSplitCursor.HotY = 9;
	HSplitCursor.WindowsCursor = Console.ViewportOwner.IDC_SIZEWE;

	VSplitCursor.tex = Texture'MouseVSplit';
	VSplitCursor.HotX = 9;
	VSplitCursor.HotY = 9;
	VSplitCursor.WindowsCursor = Console.ViewportOwner.IDC_SIZENS;

	DiagCursor2.tex = Texture'MouseDiag2';
	DiagCursor2.HotX = 7;
	DiagCursor2.HotY = 7;
	DiagCursor2.WindowsCursor = Console.ViewportOwner.IDC_SIZENESW;

	NSCursor.tex = Texture'MouseNS';
	NSCursor.HotX = 3;
	NSCursor.HotY = 7;
	NSCursor.WindowsCursor = Console.ViewportOwner.IDC_SIZENS;

	WECursor.tex = Texture'MouseWE';
	WECursor.HotX = 7;
	WECursor.HotY = 3;
	WECursor.WindowsCursor = Console.ViewportOwner.IDC_SIZEWE;
	log("UWindowRootWindow::Created():  12");
	WaitCursor.tex = Texture'MouseWait';
	WECursor.HotX = 6;
	WECursor.HotY = 9;
	WECursor.WindowsCursor = Console.ViewportOwner.IDC_WAIT;

	HotkeyWindows = New class'UWindowHotkeyWindowList';
	HotkeyWindows.Last = HotkeyWindows;
	HotkeyWindows.Next = None;
	HotkeyWindows.Sentinel = HotkeyWindows;
	Cursor = NormalCursor;
}

function MoveMouse(float X, float Y)
{
	local UWindowWindow NewMouseWindow;
	local float tx, ty;

	MouseX = X;
	MouseY = Y;

	if (!bMouseCapture)
		NewMouseWindow = FindWindowUnder(X, Y);
	else
		NewMouseWindow = MouseWindow;

	if (NewMouseWindow != MouseWindow)
	{
		MouseWindow.MouseLeave();
		NewMouseWindow.MouseEnter();
		MouseWindow = NewMouseWindow;
	}

	if (MouseX != OldMouseX || MouseY != OldMouseY)
	{
		OldMouseX = MouseX;
		OldMouseY = MouseY;

		MouseWindow.GetMouseXY(tx, ty);
		MouseWindow.MouseMove(tx, ty);
	}
}

function DrawMouse(Canvas C)
{
	local float X, Y;

	if (bDisableMouseDisplay)
		return;


	if (Console.ViewportOwner.bWindowsMouseAvailable)
	{
		// Set the windows cursor...
		Console.ViewportOwner.SelectedCursor = MouseWindow.Cursor.WindowsCursor;
	}
	else
	{
		C.SetDrawColor(255, 255, 255);

		C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX, MouseY * GUIScale - MouseWindow.Cursor.HotY);
		C.DrawIcon(MouseWindow.Cursor.tex, 1.0);

	}

}

function bool CheckCaptureMouseUp()
{
	local float X, Y;

	if (bMouseCapture) {
		MouseWindow.GetMouseXY(X, Y);
		MouseWindow.LMouseUp(X, Y);
		bMouseCapture = false;
		return True;
	}
	return False;
}

function bool CheckCaptureMouseDown()
{
	local float X, Y;

	if (bMouseCapture) {
		MouseWindow.GetMouseXY(X, Y);
		MouseWindow.LMouseDown(X, Y);
		bMouseCapture = false;
		return True;
	}
	return False;
}


function CancelCapture()
{
	bMouseCapture = false;
}


function CaptureMouse(optional UWindowWindow W)
{
	bMouseCapture = true;
	if (W != None)
		MouseWindow = W;
}


function Texture GetLookAndFeelTexture()
{
	Return LookAndFeel.Active;
}


function bool IsActive()
{
	Return True;
}

function AddHotkeyWindow(UWindowWindow W)
{
//	Log("Adding hotkeys for "$W);
	UWindowHotkeyWindowList(HotkeyWindows.Insert(class'UWindowHotkeyWindowList')).Window = W;
}

function RemoveHotkeyWindow(UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

//	Log("Removing hotkeys for "$W);

	L = HotkeyWindows.FindWindow(W);
	if (L != None)
		L.Remove();
}

function BOOL IsAHotKeyWindow(UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	L = HotkeyWindows.FindWindow(W);

	if (L != None)
		return true;

	return false;
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
    {
	switch (Msg) {
    case WM_Paint:
        Paint(C, X, Y);
		PaintClients(C, X, Y);
        AfterPaint(C, X, Y);
        return;
	case WM_KeyDown:
		if (HotKeyDown(Key, X, Y))
			return;
		break;
	case WM_KeyUp:
		if (HotKeyUp(Key, X, Y))
			return;
		break;
    case WM_LMouseDown:
//    case WM_LMouseUp:
    case WM_MMouseDown:
//    case WM_MMouseUp:
    case WM_RMouseDown:
//    case WM_RMouseUp:
		if (MouseUpDown(Key, X, Y))
			return;
		break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
}


function bool HotKeyDown(int Key, float X, float Y)
{
	local UWindowHotkeyWindowList l;

	l = UWindowHotkeyWindowList(HotkeyWindows.Next);
	while (l != None)
	{
		if (l.Window != Self && l.Window.HotKeyDown(Key, X, Y)) return True;
		l = UWindowHotkeyWindowList(l.Next);
	}

	return False;
}

function bool HotKeyUp(int Key, float X, float Y)
{
	local UWindowHotkeyWindowList l;

	l = UWindowHotkeyWindowList(HotkeyWindows.Next);
	while (l != None)
	{
		if (l.Window != Self && l.Window.HotKeyUp(Key, X, Y)) return True;
		l = UWindowHotkeyWindowList(l.Next);
	}

	return False;
}

function bool MouseUpDown(int Key, float X, float Y)
{
	local UWindowHotkeyWindowList l;

	l = UWindowHotkeyWindowList(HotkeyWindows.Next);
	while (l != None)
	{
		if (l.Window != Self && l.Window.MouseUpDown(Key, X, Y)) return True;
		l = UWindowHotkeyWindowList(l.Next);
	}

	return False;
}

function CloseActiveWindow()
{
	if (ActiveWindow != None)
		ActiveWindow.EscClose();
	else
		Console.CloseUWindow();
}

function Resized()
{
	ResolutionChanged(WinWidth, WinHeight);
}

function SetScale(float NewScale)
{
	WinWidth = RealWidth / NewScale;
	WinHeight = RealHeight / NewScale;

	GUIScale = NewScale;

	ClippingRegion.X = 0;
	ClippingRegion.Y = 0;
	ClippingRegion.W = WinWidth;
	ClippingRegion.H = WinHeight;

	SetupFonts();

	Resized();
}

function SetupFonts()
{
	if (GUIScale == 2)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma20", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma30", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB30", class'Font'));
	}
	else
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma10", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB10", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma20", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", class'Font'));
	}
}

/*
function ChangeLookAndFeel(string NewLookAndFeel)
{
	LookAndFeelClass = NewLookAndFeel;
	SaveConfig();

	// Completely restart UWindow system on the next paint
	Console.ResetUWindow();
}

*/

function HideWindow()
{
}

function SetMousePos(float X, float Y)
{
	Console.MouseX = X;
	Console.MouseY = Y;
}

function QuitGame()
{
	bRequestQuit = true;
	QuitTime = 0;
	NotifyQuitUnreal();
}

function DoQuitGame()
{
//	SaveConfig();
//	Console.SaveConfig();
	//Console.ViewportOwner.Actor.SaveConfig();
	Close();
	Console.ViewportOwner.Actor.ConsoleCommand("exit");
}

function Tick(float Delta)
{
	if (bRequestQuit)
	{
		// Give everything time to close itself down (ie sockets).
		if (QuitTime > 0.25)
			DoQuitGame();
		QuitTime += Delta;
	}

	Super.Tick(Delta);
}

defaultproperties
{
    GUIScale=1.000000
    bAllowConsole=True
}