class UWindowSmallCloseButton extends UWindowSmallButton;

var localized string CloseText;

function Created()
{
	Super.Created();
	SetText(CloseText);
}

function Click(float X, float Y)
{
	UWindowFramedWindow(GetParent(class'UWindowFramedWindow')).Close();
}

defaultproperties
{
    CloseText="Close"
}