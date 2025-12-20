class UDebugMapListBox extends UWindowListBox;

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	if (UDebugMapList(Item).bSelected)
	{
		C.SetDrawColor(0, 0, 128);
		DrawStretchedTexture(C, X, Y, W, H - 1, Texture'WhiteTexture');
		C.SetDrawColor(255, 255, 255);
	}
	else
	{
		C.SetDrawColor(0, 0, 0);
	}

	C.Font = Root.Fonts[F_Normal];
	ClipText(C, X, Y, UDebugMapList(Item).DisplayName);
}

defaultproperties
{
    ItemHeight=13.000000
    ListClass=Class'UDebugMapList'
}