class EPCSBLeftButton extends UWindowSBLeftButton
                native;

function Created(){}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	if(!bDisabled)
		Root.PlayClickSound();
}
