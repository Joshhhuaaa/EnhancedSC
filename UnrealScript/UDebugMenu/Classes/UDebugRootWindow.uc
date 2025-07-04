// ====================================================================
//  Class:  UDebugMenu.UDebugRootWindow
//  Parent: UWindow.UWindowRootWindow
//
//  <Enter a description here>
// ====================================================================

class UDebugRootWindow extends UWindowRootWindow;

var class<UWindowMenuBar> MenuBarClass;				
var UDebugMenuBar		 MenuBar;					  

function Created() 
{
	Super.Created();

	MenuBar = UDebugMenuBar(CreateWindow(class'UDebugMenuBar', 50, 0, 500, 16));
	//MenuBar.HideWindow();
    

	Resized();
}


function Resized()
{
	Super.Resized();
	
	MenuBar.WinLeft = 0;;
	MenuBar.WinTop = 0;
	MenuBar.WinWidth = WinWidth;;
	MenuBar.WinHeight = 16;
}

function DoQuitGame()
{
	MenuBar.SaveConfig();
	if ( Root.GetLevel().Game != None )
	{
		Root.GetLevel().Game.SaveConfig();
	}
	Super.DoQuitGame();
}

/*
function bool KeyEvent( out Console.EInputKey Key, out Console.EInputAction Action, FLOAT Delta )
{
	if ( (Action == IST_Press) && (Key == IK_Escape) )
	{
		bAllowConsole = false;
		GotoState('UWindows');
		return true;
	}
	
	return Super.KeyEvent(Key,Action,Delta);
}
*/
/*
state UWindows
{
	function BeginState()
	{
		if (!bAllowConsole)
			MenuBar.ShowWindow();
			
		Super.BeginState();
		
	}
	
	function EndState()
	{
		MenuBar.HideWindow();
		Super.EndState();			
	}

}	
*/

//Alex
function ShowWindow()
{
    MenuBar.ShowWindow();
}

function HideWindow()
{
    MenuBar.HideWindow();
}

defaultproperties
{
    LookAndFeelClass="UDebugMenu.UDebugBlueLookAndFeel"
}