//=============================================================================
// UWindowMenuBarItem - An Unreal menu bar item
//=============================================================================

class UWindowMenuBarItem extends UWindowList
	config;

var	string					Caption;
var UWindowMenuBar			Owner;
var UWindowPulldownMenu		Menu;
var float					ItemLeft;
var float					ItemWidth;
var bool					bHelp;
var byte					HotKey;

function SetHelp(bool b)
{
	bHelp = b;
}

function SetCaption(string C)
{
	local string Junk, Junk2;

	Caption = C;
	HotKey = Owner.ParseAmpersand(C, Junk, Junk2, False);
}

function UWindowPulldownMenu CreateMenu(Class<UWindowPulldownMenu> MenuClass)
{
	Menu = UWindowPulldownMenu(Owner.ParentWindow.CreateWindow(MenuClass, 0, 0, 100, 100));
	Menu.HideWindow();
	Menu.Owner = Self;
	return Menu;
}

function DeSelect()
{
	Owner.LookAndFeel.PlayMenuSound(Owner, MS_MenuCloseUp);
	Menu.DeSelect();
	Menu.HideWindow();
}

function Select()
{
	Owner.LookAndFeel.PlayMenuSound(Owner, MS_MenuPullDown);
	Menu.ShowWindow();
	Menu.WinLeft = ItemLeft + Owner.WinLeft;
	Menu.WinTop = 14;
	Menu.WinWidth = 100;
	Menu.WinHeight = 100;
}


function CloseUp() {
	Owner.CloseUp();
}

function UWindowMenuBar GetMenuBar()
{
	return Owner.GetMenuBar();
}
