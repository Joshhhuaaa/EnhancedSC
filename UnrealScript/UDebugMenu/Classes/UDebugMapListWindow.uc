class UDebugMapListWindow extends UWindowFramedWindow;


function Created() 
{
	bSizable = true;
	MinWinWidth = 200;
	Super.Created();
}

defaultproperties
{
    ClientClass=Class'UDebugMapListCW'
    WindowTitle="Select a Map..."
}