class UWindowComboButton extends UWindowButton
                    native;

var UWindowComboControl Owner;

function Created()
{
    Super.Created();
    LookAndFeel.Combo_GetButtonBitmaps(Self);
}

function BeforePaint(Canvas C, float X, float Y)
{
    bMouseDown = Owner.bListVisible;
}

function LMouseDown(float X, float Y)
{
	if (!bDisabled)
	{
		if (Owner.bListVisible)
			Owner.CloseUp();
		else
		{
			Owner.DropDown();
			Root.CaptureMouse(Owner.List);
		}
	}
}

function Click(float X, float Y)
{
}

function FocusOtherWindow(UWindowWindow W)
{
	Super.FocusOtherWindow(W);

	if (Owner.bListVisible && W.ParentWindow != Owner && W.ParentWindow != Owner.List && W.ParentWindow.ParentWindow != Owner.List)
		Owner.CloseUp();
}

defaultproperties
{
    m_BorderColor=(R=51,G=51,B=51,A=255)
}