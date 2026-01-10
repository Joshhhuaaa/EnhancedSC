class UWindowControlFrame extends UWindowWindow;

var UWindowWindow Framed;

function SetFrame(UWindowWindow W)
{
	Framed = W;
	W.SetParent(Self);
}

function BeforePaint(Canvas C, float X, float Y)
{
	if (Framed != None)
		LookAndFeel.ControlFrame_SetupSizes(Self, C);
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.ControlFrame_Draw(Self, C);
}
