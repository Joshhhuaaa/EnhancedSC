class UDebugOpenWindow extends UWindowFramedWindow;

var UWindowSmallCloseButton CloseButton;
var UWindowSmallButton OKButton;
var localized string OKText;

function Created()
{
	Super.Created();

	OKButton = UWindowSmallButton(CreateWindow(class'UWindowSmallButton', WinWidth-108, WinHeight-24, 48, 16));
	CloseButton = UWindowSmallCloseButton(CreateWindow(class'UWindowSmallCloseButton', WinWidth-56, WinHeight-24, 48, 16));
	OKButton.Register(UDebugOpenCW(ClientArea));
	OKButton.SetText(OKText);
}

function Resized()
{
	Super.Resized();
	ClientArea.SetSize(ClientArea.WinWidth, ClientArea.WinHeight-24);
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

	OKButton.WinLeft = ClientArea.WinLeft+ClientArea.WinWidth-104;
	OKButton.WinTop = ClientArea.WinTop+ClientArea.WinHeight+4;
	CloseButton.WinLeft = ClientArea.WinLeft+ClientArea.WinWidth-52;
	CloseButton.WinTop = ClientArea.WinTop+ClientArea.WinHeight+4;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture T;

	T = GetLookAndFeelTexture();
	DrawUpBevel( C, ClientArea.WinLeft, ClientArea.WinTop + ClientArea.WinHeight, ClientArea.WinWidth, 24, T);

	Super.Paint(C, X, Y);
}

defaultproperties
{
    OKText="OK"
    ClientClass=Class'UDebugOpenCW'
    WindowTitle="Open Location"
}