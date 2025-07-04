class UWindowScrollingDialogClient extends UWindowPageWindow;

var bool bShowHorizSB;
var bool bShowVertSB;

var UWindowDialogClientWindow	ClientArea;
var UWindowDialogClientWindow	FixedArea;
var class<UWindowDialogClientWindow> ClientClass;
var class<UWindowDialogClientWindow> FixedAreaClass;

var UWindowVScrollBar VertSB;
var UWindowHScrollBar HorizSB;
var UWindowBitmap	  BRBitmap;

function Created()
{
	Super.Created();

	if(FixedAreaClass != None)
	{
		FixedArea = UWindowDialogClientWindow(CreateWindow(FixedAreaClass, 0, 0, 100, 100, OwnerWindow));
		FixedArea.bAlwaysOnTop = True;
	}
	else
		FixedArea = None;

	ClientArea = UWindowDialogClientWindow(CreateWindow(ClientClass, 0, 0, WinWidth, WinHeight, OwnerWindow));

	VertSB = UWindowVScrollbar(CreateWindow(class'UWindowVScrollbar', WinWidth-LookAndFeel.Size_ScrollbarWidth, 0, LookAndFeel.Size_ScrollbarWidth, WinHeight));
	VertSB.bAlwaysOnTop = True;
	VertSB.HideWindow();

	HorizSB = UWindowHScrollbar(CreateWindow(class'UWindowHScrollbar', 0, WinHeight-LookAndFeel.Size_ScrollbarWidth, WinWidth, LookAndFeel.Size_ScrollbarWidth));
	HorizSB.bAlwaysOnTop = True;
	HorizSB.HideWindow();

	BRBitmap = UWindowBitmap(CreateWindow(class'UWindowBitmap', WinWidth-LookAndFeel.Size_ScrollbarWidth, WinHeight-LookAndFeel.Size_ScrollbarWidth, LookAndFeel.Size_ScrollbarWidth, LookAndFeel.Size_ScrollbarWidth));
	BRBitmap.bAlwaysOnTop = True;
	BRBitmap.HideWindow();
	BRBitmap.bStretch = True;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float ClientWidth, ClientHeight;
	local float FixedHeight;


	if(FixedArea != None)
		FixedHeight = FixedArea.WinHeight;
	else
		FixedHeight = 0;

	ClientWidth = ClientArea.DesiredWidth;
	ClientHeight = ClientArea.DesiredHeight;

	if(ClientWidth <= WinWidth)
		ClientWidth = WinWidth;

	if(ClientHeight <= WinHeight - FixedHeight)
		ClientHeight = WinHeight - FixedHeight;

	ClientArea.SetSize(ClientWidth, ClientHeight);

	bShowVertSB = (ClientHeight > WinHeight - FixedHeight);
	bShowHorizSB = (ClientWidth > WinWidth);

	if(bShowHorizSB)
	{
		// re-examine need for vertical SB now we've got smaller client area.

		ClientHeight = ClientArea.DesiredHeight;

		if(ClientHeight <= WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight)
			ClientHeight = WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;

		bShowVertSB = (ClientHeight > WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight);
	}

	if(bShowVertSB)
	{
		VertSB.ShowWindow();
		VertSB.WinTop = 0;
		VertSB.WinLeft = WinWidth - LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
		if(bShowHorizSB) 
		{
			BRBitmap.ShowWindow();
			BRBitmap.WinWidth = LookAndFeel.Size_ScrollbarWidth;
			BRBitmap.WinHeight = LookAndFeel.Size_ScrollbarWidth;
			BRBitmap.WinTop = WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
			BRBitmap.WinLeft = WinWidth - LookAndFeel.Size_ScrollbarWidth;

			BRBitmap.T = GetLookAndFeelTexture();
			//BRBitmap.R = LookAndFeel.SBBackground;

			VertSB.WinHeight = WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
		}
		else
		{
			BRBitmap.HideWindow();
			VertSB.WinHeight = WinHeight - FixedHeight;
		}

		VertSB.SetRange(0, ClientHeight, VertSB.WinHeight, 10);	
	}
	else
	{
		BRBitmap.HideWindow();
		VertSB.HideWindow();
		VertSB.Pos = 0;		
	}

	if(bShowHorizSB)
	{
		HorizSB.ShowWindow();
		HorizSB.WinLeft = 0;
		HorizSB.WinTop = WinHeight - LookAndFeel.Size_ScrollbarWidth - FixedHeight;
		HorizSB.WinHeight = LookAndFeel.Size_ScrollbarWidth;
		if(bShowVertSB)
			HorizSB.WinWidth = WinWidth - LookAndFeel.Size_ScrollbarWidth;
		else
			HorizSB.WinWidth = WinWidth;

		HorizSB.SetRange(0, ClientWidth, HorizSB.WinWidth, 10);	
	}
	else
	{
		HorizSB.HideWindow();
		HorizSB.Pos = 0;		
	}

	ClientArea.WinLeft = -HorizSB.Pos;
	ClientArea.WinTop = -VertSB.Pos;

	if(FixedArea != None)
	{
		FixedArea.WinLeft = 0;
		FixedArea.WinTop = WinHeight - FixedHeight;
		if(FixedArea.WinWidth != WinWidth)
			FixedArea.SetSize(WinWidth, FixedArea.WinHeight);
	}

	Super.BeforePaint(C, X, Y);
}

function GetDesiredDimensions(out float W, out float H)
{	
	Super(UWindowWindow).GetDesiredDimensions(W, H);
}

function Paint(Canvas C, float X, float Y)
{
}

defaultproperties
{
    ClientClass=Class'UWindowDialogClientWindow'
}