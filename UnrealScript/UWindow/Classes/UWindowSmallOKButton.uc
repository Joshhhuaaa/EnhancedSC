class UWindowSmallOKButton extends UWindowSmallCloseButton;

var localized string OKText;

function Created()
{
	Super.Created();
	SetText(OKText);
}

defaultproperties
{
    OKText="OK"
}