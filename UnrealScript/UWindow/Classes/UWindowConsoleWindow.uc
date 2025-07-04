class UWindowConsoleWindow extends UWindowFramedWindow;

var float OldParentWidth, OldParentHeight;

function Created() 
{
	Super.Created();
	bSizable = True;
	bStatusBar = True;
	bLeaveOnScreen = True;

	OldParentWidth = ParentWindow.WinWidth;
	OldParentHeight = ParentWindow.WinHeight;

	SetDimensions();

	SetAcceptsFocus();
}

function ShowWindow()
{
	Super.ShowWindow();

	if(ParentWindow.WinWidth != OldParentWidth || ParentWindow.WinHeight != OldParentHeight)
	{
		SetDimensions();
		OldParentWidth = ParentWindow.WinWidth;
		OldParentHeight = ParentWindow.WinHeight;
	}
}

function ResolutionChanged(float W, float H)
{
	SetDimensions();
}

function SetDimensions()
{
	if (ParentWindow.WinWidth < 500)
	{
		SetSize(200, 150);
	} else {
		SetSize(410, 310);
	}
	WinLeft = ParentWindow.WinWidth/2 - WinWidth/2;
	WinTop = ParentWindow.WinHeight/2 - WinHeight/2;
}

function Close(optional bool bByParent)
{
	ClientArea.Close(True);
	Root.GotoState('');
}

defaultproperties
{
    ClientClass=Class'UWindowConsoleClientWindow'
    WindowTitle="Game Console"
}