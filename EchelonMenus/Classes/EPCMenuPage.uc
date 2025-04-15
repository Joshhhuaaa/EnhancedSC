//=============================================================================
//  EPCMenuPage.uc : Base class for menu pages providing native rendering functions
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/18 * Created by Alexandre Dionne
//=============================================================================


class EPCMenuPage extends UWindowDialogClientWindow 
		native;


function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	super.WindowEvent(Msg, C, X, Y, Key);
	
	if(Msg==WM_KeyDown)
	{
		if(Key == GetPlayerOwner().Player.Console.EInputKey.IK_Escape)
		{
			// No escape available is message box is poped up
			if( EPCMainMenuRootWindow(Root).m_MessageBox == None )
				EscapeMenu();
		}
	}
}

function EscapeMenu()
{
}
