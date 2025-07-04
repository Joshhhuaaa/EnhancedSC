class UWindowSmallCancelButton extends UWindowButton;

var localized string CancelText;

function Created()
{
	Super.Created();
	SetText(CancelText);
}

defaultproperties
{
    CancelText="Cancel"
}