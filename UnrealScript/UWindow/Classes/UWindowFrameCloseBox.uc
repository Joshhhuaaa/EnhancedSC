class UWindowFrameCloseBox extends UWindowButton;

function Created()
{
	bNoKeyboard = True;
	Super.Created();
}

function Click(float X, float Y)
{
	ParentWindow.Close();
}

// No keyboard support
function KeyDown(int Key, float X, float Y)
{
}
