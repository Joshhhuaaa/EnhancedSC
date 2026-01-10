class UWindowURLTextArea extends UWindowDynamicTextArea;

var bool bReleased;

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
	Cursor = Root.NormalCursor;
}

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);
	bReleased = false;
}

function TextAreaClipText(Canvas C, float DrawX, float DrawY, coerce string S, optional bool bCheckHotkey)
{
	local float X, Y, W, H;
	local float ClickX, ClickY;
	local string Text, NextBlock;
	local byte bLink;
	local bool bOverLink;

	Text = S;
	X = DrawX;
	Y = DrawY;
	while (Text != "")
	{
		ProcessText(C, Text, NextBlock, W, H, bLink);
		if (bLink != 0)
		{
			C.SetDrawColor(0, 0, 255);
		}
		else
		{
			C.SetDrawColor(255, 255, 255);
		}

		GetMouseXY(ClickX, ClickY);
		bOverLink = bLink != 0 && DrawX < ClickX && DrawX + W > ClickX && DrawY < ClickY && DrawY + H > ClickY;

		if (bOverLink)
			Cursor = Root.HandCursor;

		if (bOverLink && (bMouseDown || bReleased))
		{
			if (bReleased)
			{
				Log("Clicked URL: >>"$NextBlock$"<<");
				if (Left(NextBlock, 7) ~= "http://")
					GetPlayerOwner().ConsoleCommand("start "$NextBlock);
				if (Left(NextBlock, 6) ~= "ftp://")
					GetPlayerOwner().ConsoleCommand("start "$NextBlock);
				if (Left(NextBlock, 9) ~= "telnet://")
					GetPlayerOwner().ConsoleCommand("start "$NextBlock);
				if (Left(NextBlock, 9) ~= "gopher://")
					GetPlayerOwner().ConsoleCommand("start "$NextBlock);
				if (Left(NextBlock, 4) ~= "www.")
					GetPlayerOwner().ConsoleCommand("start http://"$NextBlock);
				if (Left(NextBlock, 4) ~= "ftp.")
					GetPlayerOwner().ConsoleCommand("start ftp://"$NextBlock);
				else
				if (Left(NextBlock, 9) ~= "unreal://")
					LaunchUnrealURL(NextBlock);
			}
			else
			{
				C.SetDrawColor(255, 0, 0);
			}
			if (bReleased)
				bReleased = false;
		}

		if (bLink != 0)
			DrawStretchedTexture(C, DrawX, DrawY + H - 1, W, 1, Texture'WhiteTexture');
		ClipText(C, DrawX, DrawY, NextBlock);
		DrawX += W;
	}
}

function LaunchUnrealURL(string URL)
{
	GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
}

function Click(float X, float Y)
{
	Super.Click(X, Y);
	bReleased = true;
}

function ProcessText(Canvas C, out string Text, out string NextBlock, out float W, out float H, out byte bLink)
{
	local int i, j;
	local string Temp;

	i = InStr(Text, "http://");

	j = InStr(Text, "www.");
	if (i == -1 || j == -1)
		i = Max(i, j);
	else
		i = Min(i, j);

	j = InStr(Text, "unreal://");
	if (i == -1 || j == -1)
		i = Max(i, j);
	else
		i = Min(i, j);

	j = InStr(Text, "ftp://");
	if (i == -1 || j == -1)
		i = Max(i, j);
	else
		i = Min(i, j);

	j = InStr(Text, "ftp.");
	if (i == -1 || j == -1)
		i = Max(i, j);
	else
		i = Min(i, j);

	j = InStr(Text, "telnet://");
	if (i == -1 || j == -1)
		i = Max(i, j);
	else
		i = Min(i, j);

	j = InStr(Text, "gopher://");
	if (i == -1 || j == -1)
		i = Max(i, j);
	else
		i = Min(i, j);

	bLink = 0;

	if (i == -1)
	{
		NextBlock = Text;
		Text = "";
	}
	else
	if (i == 0)
	{
		bLink = 1;

		i = InStr(Text, " ");
		if (i == -1)
		{
			NextBlock = Text;
			Text = "";
		}
		else
		{
			NextBlock = Left(Text, i);
			Text = Mid(Text, i);
		}
	}
	else
	{
		NextBlock = Left(Text, i);
		Text = Mid(Text, i);
	}

	TextAreaTextSize(C, NextBlock, W, H);
}

defaultproperties
{
    bIgnoreLDoubleClick=True
}