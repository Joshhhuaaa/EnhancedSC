class UDebugMapListCW extends UWindowDialogClientWindow;

var UDebugMapListBox MapList;

var UWindowSmallCloseButton CloseButton;
var UDebugSmallLoadMapButton OkButton;
var UWindowComboControl GameCombo;
var UWindowComboControl NetworkCombo;
var GlobalConfig string LastGameType;

function Created()
{
	local int index;

	WinWidth = Min(400, Root.WinWidth - 50);
	WinHeight = Min(210, Root.WinHeight - 50);

	Super.Created();

	MapList = UDebugMapListBox(CreateWindow(class'UDebugMapListBox', 0, 0, 100, 100, Self));
	LoadMapList();

	CloseButton = UWindowSmallCloseButton(CreateWindow(class'UWindowSmallCloseButton', WinWidth - 56, WinHeight - 24, 48, 16));
	OkButton    = UDebugSmallLoadMapButton(CreateWindow(class'UDebugSmallLoadMapButton', WinWidth - 120, WinHeight - 24, 58, 16));

	GameCombo   = UWindowComboControl(CreateWindow(class'UWindowComboControl', 5, WinHeight - 24, WinWidth - 130, 16));
	GameCombo.SetButtons(True);
	GameCombo.SetText("Game Type:");
	GameCombo.SetFont(F_Normal);
	GameCombo.SetEditable(False);

	GameCombo.AddItem("Engine.GameInfo");
	GameCombo.AddItem("WarfareGame.WarfareDeathMatch");
	GameCombo.AddItem("WarfareGame.WarfareTeamGame");
	GameCombo.AddItem("WarfareGame.WarfareCTFGame");
	GameCombo.EditBox.WinWidth = GameCombo.WinWidth - 60;
	if (LastGameType!="")
	{
		index = GameCombo.List.FindItemIndex(LastGameType);
		GameCombo.SetSelectedIndex(Index);
	}
	else
		GameCombo.SetSelectedIndex(0);

	NetworkCombo   = UWindowComboControl(CreateWindow(class'UWindowComboControl', 5, WinHeight - 20, WinWidth - 130,16));
	NetworkCombo.SetButtons(True);
	NetworkCombo.SetText("Network Game:");
	NetworkCombo.SetFont(F_Normal);
	NetworkCombo.SetEditable(False);
	NetworkCombo.AddItem("Single Player");
	NetworkCombo.AddItem("Listen Server");
	NetworkCombo.SetSelectedIndex(0);
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(c,x,y);
}

function Paint(Canvas C, float X, float Y)
{
	local Texture T;

	Super.Paint(C, X, Y);

	T = GetLookAndFeelTexture();
	DrawUpBevel(C, 0, WinHeight - 46, WinWidth, 46, T);
}


function Resized()
{
	MapList.WinWidth = WinWidth;
	MapList.WinHeight = WinHeight - 46;
	MapList.VertSB.WinLeft = MapList.WinWidth - MapList.VertSB.WinWidth;
	MapList.VertSB.WinHeight = MapList.WinHeight;
	CloseButton.WinLeft = WinWidth - 52;
	CloseButton.WinTop = WinHeight - 40;
	OkButton.WinLeft = WinWidth - 120;
	OkButton.WinTop = WinHeight - 40;
	GameCombo.WinTop = WinHeight - 40;
	GameCombo.WinWidth = WinWidth - 130;
	GameCombo.EditBoxWidth = GameCombo.WinWidth - 75;
	NetworkCombo.WinTop = WinHeight - 21;
	NetworkCombo.WinWidth = WinWidth - 130;
	NetworkCombo.EditBoxWidth = GameCombo.WinWidth - 75;

}

function LoadMapList()
{
	local string FirstMap, NextMap, TestMap, MapName;
	local int i, IncludeCount;
	local UDebugMapList L;

	FirstMap = "";
	NextMap = FirstMap;
	while (!(FirstMap ~= TestMap))
	{
		L = UDebugMapList(MapList.Items.Append(class'UDebugMapList'));
		L.MapName = NextMap;
		if (Right(NextMap, 4) ~= ".unr")
			L.DisplayName = Left(NextMap, Len(NextMap) - 4);
		else
			L.DisplayName = NextMap;

		NextMap = "";
		TestMap = NextMap;
	}

	MapList.Sort();
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);
	switch (E)
	{
	case DE_Change:
		switch (C)
		{
		case GameCombo:
			LastGameType = GameCombo.GetValue();
			SaveConfig();

			break;
		}
		break;
	}
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	if (Msg == WM_KeyDown)
	{
		if (Key == 236)
			MapList.VertSB.Scroll(-1);
		else if (Key == 237)
			MapList.VertSB.Scroll(+1);

		return;
	}

	Super.WindowEvent(MSg,C,X,Y,Key);
}

