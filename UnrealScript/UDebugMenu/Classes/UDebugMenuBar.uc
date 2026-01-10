class UDebugMenuBar extends UWindowMenuBar;

var UWindowPulldownMenu Game, RModes, Rend, Stats, Show, Player, Options;
var UWindowMenuBarItem GameItem, RModesItem, RendItem, StatsItem, ShowItem, PlayerItem, OptionsItem;
var bool bShowMenu;

function Created()
{

	Super.Created();

	GameItem = AddItem("&Game");
	Game = GameItem.CreateMenu(class 'UWindowPulldownMenu');
	Game.MyMenuBar = self;
	Game.AddMenuItem("&Load New Map",none);
	Game.AddMenuItem("-",none);
	Game.AddMenuItem("&Connect to..",none);
	Game.AddMenuItem("-",none);
	Game.AddMenuItem("ScreenShot",none);
	Game.AddMenuItem("Flush",none);
	Game.AddMenuItem("Export To Raw",none);
	Game.AddMenuItem("-",none);
	Game.AddMenuItem("E&xit",none);

	RModesItem = AddItem("&Render Modes");
	RModes = RModesItem.CreateMenu(class 'UWindowPulldownMenu');
	RModes.MyMenuBar = self;
	RModes.AddMenuItem("&Wireframe",none);
	RModes.AddMenuItem("&Zones",none);
	RModes.AddMenuItem("&Flat Shaded BSP",none);
	RModes.AddMenuItem("&BSP Splits",none);
	RModes.AddMenuItem("&Regular",none);
	RModes.AddMenuItem("&Unlit",none);
	RModes.AddMenuItem("&Lighting Only",none);
	RModes.AddMenuItem("&Depth Complexity",none);
	RModes.AddMenuItem("-",None);
	RModes.AddMenuItem("&Top Down",None);
	RModes.AddMenuItem("&Front",None);
	RModes.AddMenuItem("&Side",None);

	RendItem = AddItem("Render &Commands");
	Rend = RendItem.CreateMenu(class 'UWindowPulldownMenu');
	Rend.MyMenuBar = self;
	Rend.AddMenuItem("&Blend",none);
	Rend.AddMenuItem("&Bone",none);
	Rend.AddMenuItem("&Skin",none);
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (25 janv. 2002)
// ***********************************************************************************************
	Rend.AddMenuItem("&Pill",none);
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************

	StatsItem = AddItem("&Stats");
	Stats = StatsItem.CreateMenu(class 'UWindowPulldownMenu');
	Stats.MyMenuBar = self;
	Stats.AddMenuItem("&All",None);
	Stats.AddMenuItem("&None",None);
	Stats.AddMenuItem("-",None);
	Stats.AddMenuItem("&Render",None);
	Stats.AddMenuItem("&Game",None);
	Stats.AddMenuItem("&Hardware",None);
	Stats.AddMenuItem("Ne&t",None);
	Stats.AddMenuItem("Ani&m",None);
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (25 janv. 2002)
// ***********************************************************************************************
	Stats.AddMenuItem("&Fps",None);
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************

	ShowItem = AddItem("Sho&w Commands");
	Show = ShowItem.CreateMenu(class 'UWindowPulldownMenu');
	Show.MyMenuBar = self;
	Show.AddMenuItem("Show &Actors",None);
	Show.AddMenuItem("Show Static &Meshes",None);
	Show.AddMenuItem("Show &Terrain",None);
	Show.AddMenuItem("Show &Fog",None);
	Show.AddMenuItem("Show &Sky",None);
	Show.AddMenuItem("Show &Coronas",None);
	Show.AddMenuItem("Show &Particles",None);
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (17 janv. 2002)
// ***********************************************************************************************
	Show.AddMenuItem("Show Collision",None);
	Show.AddMenuItem("Show GE",None);
	Show.AddMenuItem("Show EVolume",None);
	Show.AddMenuItem("Show Trace",None);
	Show.AddMenuItem("Show FastTrace",None);
	Show.AddMenuItem("Show Bounding",None);
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************

	OptionsItem = AddItem("&Options");
	Options = OptionsItem.CreateMenu(class 'UWindowPulldownMenu');
	Options.MyMenuBar = self;
	Options.AddMenuItem("&Video",None);
//	Options.AddMenuItem("&Audio",None);
//	Options.AddMenuItem("&Keys",None);

	bShowMenu = true;
	Spacing = 12;

}

function SetHelp(string NewHelpText)
{
}

function ShowHelpItem(UWindowMenuBarItem I)
{
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	C.SetDrawColor(255, 255, 255);
	if (UWindowMenuBarItem(Item).bHelp) W = W - 16;

	UWindowMenuBarItem(Item).ItemLeft = X;
	UWindowMenuBarItem(Item).ItemWidth = W;
	LookAndFeel.Menu_DrawMenuBarItem(Self, UWindowMenuBarItem(Item), X, Y, W, H, C);
}

function DrawMenuBar(Canvas C)
{
	local float W, H;
	local string VersionText;
	VersionText = "[Debug Menu] Version "@GetLevel().EngineVersion;
	LookAndFeel.Menu_DrawMenuBar(Self, C);

	C.Font = Root.Fonts[F_Normal];

	C.SetDrawColor(0, 0, 0);

	TextSize(C, VersionText, W, H);
	ClipText(C, WinWidth - W - 20, 3, VersionText);
}

function LMouseDown(float X, float Y)
{
	if (X > WinWidth - 13) GetPlayerOwner().ConsoleCommand("togglefullscreen");
	Super.LMouseDown(X, Y);
}
function NotifyQuitUnreal()
{
	local UWindowMenuBarItem I;

	for (I = UWindowMenuBarItem(Items.Next); I != None; I = UWindowMenuBarItem(I.Next))
		if (I.Menu != None)
			I.Menu.NotifyQuitUnreal();
}

function NotifyBeforeLevelChange()
{
	local UWindowMenuBarItem I;

	for (I = UWindowMenuBarItem(Items.Next); I != None; I = UWindowMenuBarItem(I.Next))
		if (I.Menu != None)
			I.Menu.NotifyBeforeLevelChange();
}

function NotifyAfterLevelChange()
{
	local UWindowMenuBarItem I;

	for (I = UWindowMenuBarItem(Items.Next); I != None; I = UWindowMenuBarItem(I.Next))
		if (I.Menu != None)
			I.Menu.NotifyAfterLevelChange();
}

function MenuCmd(int Menu, int Item)
{
	Super.MenuCmd(Menu, Item);
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	switch (Msg)
	{
		case WM_KeyDown:


			if (Key == 27) // GRR
			{
				if (Selected == None)
				{
					Root.GotoState('');
				}

				return;
			}
			break;
	}
	Super.WindowEvent(Msg, C, X, Y, Key);

}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float X,xl,yl;
	local float W, H;
	local UWindowMenuBarItem I;

	DrawMenuBar(C);

	for (I = UWindowMenuBarItem(Items.Next);I != None; I = UWindowMenuBarItem(I.Next))
	{
		C.Font = Root.Fonts[F_Normal];
		TextSize(C, RemoveAmpersand(I.Caption), W, H);

		if (I.bHelp)
		{
			DrawItem(C, I, (WinWidth - (W + Spacing)), 1, W + Spacing, 14);
		}
		else
		{
			DrawItem(C, I, X, 1, W + Spacing, 14);
			X = X + W + Spacing;
		}
	}
}

function MenuItemSelected(UWindowBase Sender, UWindowBase Item)
{
	local UWindowPulldownMenu Menu;
	local UWindowPulldownMenuItem I;

	Menu = UWindowPulldownMenu(Sender);
	I = UWindowPulldownMenuItem(Item);

	if (Menu != None)
	{
		switch (Menu)
		{
			case Game:
				switch (I.Tag)
				{
					case 1 :
						// Open the Map Menu
						Root.ShowModal(Root.CreateWindow(class'UDebugMapListWindow', (Root.WinWidth / 2) - 200, (Root.WinHeight / 2) - 107, 400, 214, self));
						return;
						break;

					case 3 :
						// Open the Map Menu
						Root.ShowModal(Root.CreateWindow(class'UDebugOpenWindow', (Root.WinWidth / 2) - 150,(Root.WinHeight / 2) - 45, 300,90, self));
						return;
						break;

					case 5 : GetLevel().ConsoleCommand("Shot"); break;
					case 6 : GetLevel().ConsoleCommand("Flush"); break;
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (25 janv. 2002)
// ***********************************************************************************************
					case 7 : GetLevel().ConsoleCommand("DumpMapToRaw"); break;
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************
					case 9 : GetLevel().ConsoleCommand("Quit"); break;
				}
				break;
			case RModes:
				if (I.Tag < 9)
					GetLevel().ConsoleCommand("RMode "$I.Tag);
				else if (I.Tag >9)
					GetLevel().ConsoleCommand("RMode "$I.Tag + 3);

				break;

			case Rend:
				switch (I.Tag)
				{
					case 1 : GetLevel().ConsoleCommand("rend blend"); break;
					case 2 : GetLevel().ConsoleCommand("rend bone"); break;
					case 3 : GetLevel().ConsoleCommand("rend skin"); break;
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (25 janv. 2002)
// ***********************************************************************************************
					case 4 : GetLevel().ConsoleCommand("rend pill"); break;
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************
				}
				break;

			case Stats:
				switch (I.Tag)
				{
					case 1 : GetLevel().ConsoleCommand("stat All");break;
					case 2 : GetLevel().ConsoleCommand("stat NONE");break;
					case 4 : GetLevel().ConsoleCommand("stat RENDER");break;
					case 5 : GetLevel().ConsoleCommand("stat GAME");break;
					case 6 : GetLevel().ConsoleCommand("stat HARDWARE");break;
					case 7 : GetLevel().ConsoleCommand("stat NET");break;
					case 8 : GetLevel().ConsoleCommand("stat ANIM");break;
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (25 janv. 2002)
// ***********************************************************************************************
					case 9 : GetLevel().ConsoleCommand("stat fps");break;
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************

				}
				break;

			case Show:
				switch (I.Tag)
				{
					case 1 : GetLevel().ConsoleCommand("show Actors"); break;
					case 2 : GetLevel().ConsoleCommand("show StaticMeshes"); break;
					case 3 : GetLevel().ConsoleCommand("show Terrain"); break;
					case 4 : GetLevel().ConsoleCommand("show Fog"); break;
					case 5 : GetLevel().ConsoleCommand("show Sky"); break;
					case 6 : GetLevel().ConsoleCommand("show Coronas"); break;
					case 7 : GetLevel().ConsoleCommand("show Particles"); break;
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (17 janv. 2002)
// ***********************************************************************************************
					case 8 : GetLevel().ConsoleCommand("show Radii"); break;
					case 9 : GetLevel().ConsoleCommand("show GEO"); break;
					case 10 : GetLevel().ConsoleCommand("show Volume"); break;
					case 11 : GetLevel().ConsoleCommand("show linecheck"); break;
					case 12 : GetLevel().ConsoleCommand("show fastlinecheck"); break;
					case 13 : GetLevel().ConsoleCommand("rend bound"); break;
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************
				}
				break;

			case Options:
				switch (I.tag)
				{
					case 1 : // Video Menu

						Root.ShowModal(Root.CreateWindow(class'UDebugVideoWindow', Options.WinLeft, 20, 220, 100, self));
						return;
						break;

					case 2 : break; // Audio Menu
					case 3 : break; // Input Menu
				}
				break;
		}
	}
	Root.GotoState('');

}

