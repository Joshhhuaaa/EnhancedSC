class UWindowConsoleClientWindow extends UWindowDialogClientWindow;

var UWindowConsoleTextAreaControl TextArea;
var UWindowEditControl	EditControl;

function Created()
{
	TextArea = UWindowConsoleTextAreaControl(CreateWindow(class'UWindowConsoleTextAreaControl', 0, 0, WinWidth, WinHeight));
	EditControl = UWindowEditControl(CreateControl(class'UWindowEditControl', 0, WinHeight-16, WinWidth, 16));
	EditControl.SetFont(F_Normal);	
	EditControl.SetNumericOnly(False);
	EditControl.SetMaxLength(400);
	EditControl.SetHistory(True);	
}

function Notify(UWindowDialogControl C, byte E)
{
	local string s;
	Super.Notify(C, E);

	switch(E)
	{
	case DE_EnterPressed:
		switch(C)
		{
		case EditControl:
			if(EditControl.GetValue() != "")
			{
				s = EditControl.GetValue();
				Root.Console.Message( "> "$s, 6.0 );
				EditControl.Clear();
				if( !Root.Console.ConsoleCommand( s ) )
					Root.Console.Message( Localize("Errors","Exec","Core"), 6.0 );
			}
			break;
		}
		break;
	case DE_WheelUpPressed:
		switch(C)
		{
		case EditControl:
			TextArea.VertSB.Scroll(-1);
			break;
		}
		break;
	case DE_WheelDownPressed:
		switch(C)
		{
		case EditControl:
			TextArea.VertSB.Scroll(1);
			break;
		}
		break;
	}
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

	EditControl.SetSize(WinWidth, 17);
	EditControl.WinLeft = 0;
	EditControl.WinTop = WinHeight - EditControl.WinHeight;
	EditControl.EditBoxWidth = WinWidth;

	TextArea.SetSize(WinWidth, WinHeight - EditControl.WinHeight);
}

function Paint(Canvas C, float X, float Y)
{
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
}
