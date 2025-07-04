class UWindowMessageBox extends UWindowFramedWindow;

var MessageBoxResult Result;
var float TimeOutTime;
var int TimeOut;
var bool bSetupSize;
var int FrameCount;

function SetupMessageBox(string Title, string Message, MessageBoxButtons Buttons, MessageBoxResult InESCResult, optional MessageBoxResult InEnterResult, optional int InTimeOut)
{
	WindowTitle = Title;
	UWindowMessageBoxCW(ClientArea).SetupMessageBoxClient(Message, Buttons, InEnterResult);
	Result = InESCResult;
	TimeOutTime = 0;
	TimeOut = InTimeOut;
	FrameCount = 0;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local Region R;

	if(!bSetupSize)
	{
		SetSize(200, WinHeight);		
		R = LookAndFeel.FW_GetClientArea(Self);
		SetSize(200, (WinHeight - R.H) + UWindowMessageBoxCW(ClientArea).GetHeight(C));
		WinLeft = int((Root.WinWidth - WinWidth) / 2);
		WinTop = int((Root.WinHeight - WinHeight) / 2);
		bSetupSize = True;
	}

	Super.BeforePaint(C, X, Y);
}

function AfterPaint(Canvas C, float X, float Y)
{
	Super.AfterPaint(C, X, Y);

	if(TimeOut != 0)
	{
		FrameCount++;
		
		if(FrameCount >= 5)
		{
			TimeOutTime = GetTime() + TimeOut;
			TimeOut = 0;
		}
	}

	if(TimeOutTime != 0 && GetTime() > TimeOutTime)
	{
		TimeOutTime = 0;
		Close();
	}
}

function Close(optional bool bByParent)
{
	Super.Close(bByParent);
	OwnerWindow.MessageBoxDone(Self, Result);
}

defaultproperties
{
    ClientClass=Class'UWindowMessageBoxCW'
}