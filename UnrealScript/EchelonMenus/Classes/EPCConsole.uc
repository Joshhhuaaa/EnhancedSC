//=============================================================================
//  EPCConsole.uc : Console routing inputs and rendering call to menu system
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/18 * Created by Alexandre Dionne
//=============================================================================


class EPCConsole extends WindowConsole;

var ELeaveGame m_eNextStep;


var BOOL   bReturnToMenu;
var BOOL   bLaunchWasCalled;
var BOOL   bShowFakeWindow;
var BOOL   bMusicPlaying;
var BOOL   bInGameMenuActive;
var BOOL   bMainMenuActive;
var BOOL   bAltHeld; // Joshua - Track Alt key state for Alt+F4

var config BOOL StartMenus;
var config BOOL HideMenusAtStart;

var Sound   MenuMusic;

event Initialized()
{  
   if(StartMenus == true)
        LaunchMainMenu();   
}

event GameSaved(bool success)
{
    if( EPCMainMenuRootWindow(Root) != None)   
        EPCMainMenuRootWindow(Root).GameSaved(success);
}

event GameLoaded(bool success)
{
    if( EPCMainMenuRootWindow(Root) != None)   
        EPCMainMenuRootWindow(Root).GameLoaded(success);
}

event ShowFakeWindow()
{
    bShowFakeWindow = true;
    GotoState('FakeWindow');
}

event HideFakeWindow()
{
    bShowFakeWindow = false;
    GotoState('');
}

event ShowMainMenu()
{
	bLaunchWasCalled = false;
	GotoState('UWindow');
	LeaveGame(LG_MainMenu);
}

event ExitAltTab()
{
	if(bMainMenuActive)
	{
		ViewportOwner.Actor.StopAllSounds();
	}
	else
	{
		ViewportOwner.Actor.PauseSound(true);

		if(!bInGameMenuActive)
		{
			ViewportOwner.Actor.SetPause(true);
		}
	}
}

event ShowGameMenu(bool GoToSaveLoadArea)
{
	GotoState('UWindow');
	Root.ChangeCurrentWidget(WidgetID_InGameMenu);
	if(GoToSaveLoadArea)
		EPCMainMenuRootWindow(Root).m_InGameMenu.GoToSaveLoadArea();
}

event EnterAltTab()
{
	if(bMainMenuActive)
	{	
		MouseX = Root.WinWidth / 2;
		MouseY = Root.WinHeight / 2;
		bMusicPlaying = false;
	}
	else
	{
		if(!bInGameMenuActive)
		{
			ViewportOwner.Actor.SetPause(false);
		}
		else
		{
			MouseX = Root.WinWidth / 2;
			MouseY = Root.WinHeight / 2;
		}
		
		ViewportOwner.Actor.ResumeSound(true);
	}
}

function PopCD()
{
	//ViewportOwner.Actor.SetPause(true);
	//GotoState('FakeWindow');
	EPCMainMenuRootWindow(Root).PopCD();
}
	
function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
    
    if(bShowLog)log("Maint KeyEvent Key"@Key@"Action"@Action);
    
    
//
//    if( (Key == EInputKey.IK_O) && (Action == IST_Release) && (Root != None) ) 
//    {
//                GotoState('UWindow');
//                Root.ChangeCurrentWidget(WidgetID_MainMenu);        		
//                return true;
//    }    
//    else if( (Key == EInputKey.IK_P) && (Action == IST_Release) && (Root != None) ) 
//    
//    

    if( (Key == ViewportOwner.Actor.GetKey("FullInventory", false)) && (Action == IST_Press) && (Root != None) )     
    {
		if(	ViewportOwner.Actor.Level.Pauser == None)
		{
			bLaunchWasCalled = false;
			bReturnToMenu = false;
			GotoState('UWindow');
			Root.ChangeCurrentWidget(WidgetID_InGameMenu);
			EPCMainMenuRootWindow(Root).m_InGameMenu.CheckSubMenu();
			return true;
		}
    }
    else if( (Key == ConsoleKey) && (Action == IST_Press) ) 
    {
        if (bLocked)
            return true;

        Type();
        return true;
     
    }
    else 
        return false;
		

}

function bool KeyType( EInputKey Key )
{
	if(bShowLog) log("ERROR!!!!!!!!!!!!!!!!!!! IN R6Console >> KeyType");
    return false;
}

function PostRender( canvas Canvas )
{
	if(Root == None)
		CreateRootWindow(Canvas);
	if(bShowLog) log("ERROR!!!!!!!!!!!!!!!!!!! IN R6Console >> PostRender");
}

state FakeWindow extends UWindow
{
    function BeginState()
    {
        if(Root != None)    
            Root.ChangeCurrentWidget(WidgetID_FakeWindow);
    }
    
    function PostRender( canvas Canvas )
    { 
        if(Root != None)
            Root.bUWindowActive = True;
        RenderUWindow( Canvas );        
    }
 
	event ExitAltTab()
	{
		if(!bMainMenuActive)
		{
			ViewportOwner.Actor.SetPause(True);
			ViewportOwner.Actor.PauseSound(true);
		}
	}

	event EnterAltTab()
	{
		if(!bMainMenuActive)
		{
			ViewportOwner.Actor.SetPause(False);
			ViewportOwner.Actor.ResumeSound(true);
		}
	}
	
    function bool KeyEvent( EInputKey eKey, EInputAction eAction, FLOAT fDelta )
    {        

        local byte k;
        k = eKey;                
        
        if(bShowLog)log("Console state FakeWindow KeyEvent eAction"@eAction@"Key"@eKey);
        
        // Joshua - Track Alt key state for Alt+F4
        if( eKey == IK_Alt )
        {
            if( eAction == IST_Press || eAction == IST_Hold )
                bAltHeld = true;
            else if( eAction == IST_Release )
                bAltHeld = false;
        }
        
        // Joshua - Alt+F4 to quit the game
        if( bAltHeld && eAction == IST_Press && eKey == IK_F4 )
        {
            ViewportOwner.Actor.ConsoleCommand("QUIT");
            return true;
        }
        
        switch(eAction)
        {
        case IST_Release:
            
            ///////////////////////////////////////////////////
            //---------------  No Root  -----------------------
            if(Root == None)
                return false;
            //-------------------------------------------------
            ///////////////////////////////////////////////////            
            
            switch (eKey)
            {
            case EInputKey.IK_LeftMouse:
                Root.WindowEvent(WM_LMouseUp, None, MouseX, MouseY, k);
                break;
            case EInputKey.IK_RightMouse:				
                Root.WindowEvent(WM_RMouseUp, None, MouseX, MouseY, k);
                break;
            case EInputKey.IK_MiddleMouse:
                Root.WindowEvent(WM_MMouseUp, None, MouseX, MouseY, k);
                break;
            case EInputKey.IK_Escape:
				// To close window when hitting ESC
				if(EPCMainMenuRootWindow(Root) != None && EPCMainMenuRootWindow(Root).m_FakeWidget != None)
	                EPCMainMenuRootWindow(Root).m_FakeWidget.Click(0.0, 0.0);
                break;
            default:				
                return false;   //We only wan'to handle mouse input so return false when receiving any other input
                break;
            }
            break;
            
            
            case IST_Press:
                if (k == ConsoleKey)
                {
                    if (bLocked)
                        return true;
                    
                    Type();
                    return true;
                }            
                ///////////////////////////////////////////////////
                //---------------  No Root  -----------------------
                if(Root == None)
                    return false;
                //-------------------------------------------------
                ///////////////////////////////////////////////////
                
                switch(k)
                {
                case EInputKey.IK_LeftMouse:				                
                    Root.WindowEvent(WM_LMouseDown, None, MouseX, MouseY, k);   
                    break;
                case EInputKey.IK_RightMouse:
                    Root.WindowEvent(WM_RMouseDown, None, MouseX, MouseY, k);				
                    break;
                case EInputKey.IK_MiddleMouse:
                    Root.WindowEvent(WM_MMouseDown, None, MouseX, MouseY, k);				
                    break;
                case EInputKey.IK_MouseWheelDown:
                    Root.WindowEvent(WM_MouseWheelDown, None, MouseX, MouseY, k);				
                    break;
                case EInputKey.IK_MouseWheelUp:
                    Root.WindowEvent(WM_MouseWheelUp, None, MouseX, MouseY, k);				
                    break;
                default:                    
                    return false;   //We only wan'to handle mouse input so return false when receiving any other input                                    
                    break;
                }
                break;
                case IST_Axis:         
                    
                    switch (k)
                    {
                    case EInputKey.IK_MouseX:
                        MouseX = MouseX + (MouseScale * fDelta);                
                        break;
                    case EInputKey.IK_MouseY:			    
                        MouseY = MouseY + (MouseScale * fDelta);                
                        break;					
                    }
                    break;
                    
                    ///////////////////////////////////////////////////
                    //---------------  No Root  -----------------------
                    if(Root == None)
                        return false;
                    //-------------------------------------------------
                    ///////////////////////////////////////////////////
                    
                    default:
                        break;
        }
        
        return true; //We have a root we keep the input
    }
    
    
    function EndState()
    {
        if(Root != None)    
            Root.ChangeCurrentWidget(WidgetID_None);
    }
    
}

// A window is displayed, trapping all the input
state UWindow
{   
    function PostRender( canvas Canvas )
	{    
        if(ViewportOwner.Actor != None)
        {        
            ViewportOwner.Actor.SetPause( true );           //Pause Game
            ViewportOwner.Actor.bStopRenderWorld = true;    //Stop Rendering World

			if(	ViewportOwner.Actor.Level != None &&
				ViewportOwner.Actor.Level.bIsStartMenu &&
				!bMusicPlaying)
			{
				if(ViewportOwner.Actor.PlaySound(MenuMusic, SLOT_Music))
				{
					bMusicPlaying = true;
				}
			}
        }

        if(bReturnToMenu == true && Root != None)
        {          
            bReturnToMenu = false; 

            //Force Menu Res       

            switch(m_eNextStep)
            {
            case LG_MainMenu:
                //Go to Next Level
                Root.ChangeCurrentWidget(WidgetID_MainMenu);
                break;            
            }            
        
        }
        
        if(bLaunchWasCalled==true && Root != None)
        {                     
           ReturnToGame();           
           bLaunchWasCalled=false;

        }
        else
        {
            if(Root != None)
			    Root.bUWindowActive = True;

		    RenderUWindow( Canvas );                       
                
        }	

	}

    function bool KeyEvent( EInputKey eKey, EInputAction eAction, FLOAT fDelta )
    {
        local byte k;
        local EMainMenuHUD MenuHUD;
        k = eKey;
        
        if(bShowLog)log("Console state Uwindow KeyEvent eAction"@eAction@"Key"@eKey);

        // Joshua - Track Alt key state for Alt+F4
        if( eKey == IK_Alt )
        {
            if( eAction == IST_Press || eAction == IST_Hold )
                bAltHeld = true;
            else if( eAction == IST_Release )
                bAltHeld = false;
        }
        
        // Joshua - Alt+F4 to quit the game
        if( bAltHeld && eAction == IST_Press && eKey == IK_F4 )
        {
            ViewportOwner.Actor.ConsoleCommand("QUIT");
            return true;
        }

        // Joshua - Add functionality to skip inactivity videos
        if(eAction == IST_Press)
        {
            MenuHUD = EchelonMainHUD(ViewportOwner.Actor.myHUD).MainMenuHUD;
            if(MenuHUD != None && MenuHUD.bInactVideoPlaying)
            {
                MenuHUD.bStopInactVideo = True;
                return true;
            }
        }


        switch(eAction)
        {
		case IST_Release:
            
            ///////////////////////////////////////////////////
            //---------------  No Root  -----------------------
            if(Root == None)
                return false;
            //-------------------------------------------------
            ///////////////////////////////////////////////////            

			switch (eKey)
			{
//            case EInputKey.IK_O:
//           		LaunchGame();
//           		break; 
//           
 
			case EInputKey.IK_LeftMouse:
				Root.WindowEvent(WM_LMouseUp, None, MouseX, MouseY, k);                    
                break;
			case EInputKey.IK_RightMouse:				
                Root.WindowEvent(WM_RMouseUp, None, MouseX, MouseY, k);				                    
                break;
			case EInputKey.IK_MiddleMouse:
				Root.WindowEvent(WM_MMouseUp, None, MouseX, MouseY, k);				                				                    
                break;
			default:				
                Root.WindowEvent(WM_KeyUp, None, MouseX, MouseY, k);				    
				break;
			}
			break;

            
        case IST_Press:
            if (k == ConsoleKey)
            {
                if (bLocked)
                    return true;

                Type();
                return true;
            }            
            ///////////////////////////////////////////////////
            //---------------  No Root  -----------------------
            if(Root == None)
                return false;
            //-------------------------------------------------
            ///////////////////////////////////////////////////

            switch(k)
            {
			case EInputKey.IK_LeftMouse:				                
			    Root.WindowEvent(WM_LMouseDown, None, MouseX, MouseY, k);   
                break;
			case EInputKey.IK_RightMouse:
				Root.WindowEvent(WM_RMouseDown, None, MouseX, MouseY, k);				
                break;
			case EInputKey.IK_MiddleMouse:
				Root.WindowEvent(WM_MMouseDown, None, MouseX, MouseY, k);				
                break;
			case EInputKey.IK_MouseWheelDown:
				Root.WindowEvent(WM_MouseWheelDown, None, MouseX, MouseY, k);				
                break;
			case EInputKey.IK_MouseWheelUp:
				Root.WindowEvent(WM_MouseWheelUp, None, MouseX, MouseY, k);				
                break;
			default:                    
				Root.WindowEvent(WM_KeyDown, None, MouseX, MouseY, k);                                    
				break;
			}
			break;
		case IST_Axis:         

            switch (k)
		    {
		    case EInputKey.IK_MouseX:
			    MouseX = MouseX + (MouseScale * fDelta);                
			    break;
		    case EInputKey.IK_MouseY:			    
                MouseY = MouseY + (MouseScale * fDelta);                
			    break;					
		    }
            break;

            ///////////////////////////////////////////////////
            //---------------  No Root  -----------------------
            if(Root == None)
                return false;
            //-------------------------------------------------
            ///////////////////////////////////////////////////

		default:
			break;
        }

        return true; //We have a root we keep the input
    }


	function BeginState()
	{
		if(	ViewportOwner != None &&
			ViewportOwner.Actor != None &&
			ViewportOwner.Actor.Level != None &&
			!ViewportOwner.Actor.Level.bIsStartMenu)
			ViewportOwner.Actor.PauseSound(false);
	}    

	function EndState()
	{
        local Canvas C;

		if(bMusicPlaying && ViewportOwner.Actor != None)
		{
			ViewportOwner.Actor.StopSound(MenuMusic, 0.25);
			bMusicPlaying = false;
		}

        if(ViewportOwner.Actor != None)
        {
		    ViewportOwner.Actor.SetPause( false );         //Unpause Game
            ViewportOwner.Actor.bStopRenderWorld = false; //Render World
			ViewportOwner.Actor.SkipPresent(1);
        }

        C = class'Actor'.static.GetCanvas();       
        C.VideoStop();

        if(bShowFakeWindow)
            GotoState('FakeWindow');
        else if(Root != None)
		{
			if(!ViewportOwner.Actor.Level.bIsStartMenu)
			{
				ViewportOwner.Actor.ResumeSound(ViewportOwner.Actor.bShouldResumeAll);
				ViewportOwner.Actor.bShouldResumeAll = false;
			}

            Root.ChangeCurrentWidget(WidgetID_None);
		}
	}
}

function LaunchMainMenu()
{
	bUWindowActive = true;
	bVisible = true;

	bQuickKeyEnable = False;
	LaunchUWindow();   

	if(Root != None)
    {
        //something wrong!!!!
		Root.bWindowVisible = true;
    }      
}

function CloseMainMenu()
{
    bVisible = false;
    ResetUWindow();
}

event ResetMainMenu()
{
	ResetUWindow();
	LaunchUWindow();   
	bUWindowActive = true;
	bVisible = true;
	bLaunchWasCalled = true; 
	HideMenusAtStart = false;
	ReturnToGame();
}

event LeaveGame(ELeaveGame _bwhatToDo)
{ 
    //Go Back to menu
    if(bReturnToMenu)
        return;

    bReturnToMenu   = true;    

	ViewportOwner.Actor.StopAllSounds();

    CloseMainMenu();
    LaunchMainMenu();

    switch(_bwhatToDo)
    {      
	    case LG_MainMenu:        
		default: //Go back to main menu       
			m_eNextStep = LG_MainMenu;        
			break;
    }
}

//This can be called to closed menus and return to game
function LaunchGame()
{   
	ViewportOwner.Actor.bStopRenderWorld = false; //Render World
	bLaunchWasCalled = true; 
	HideMenusAtStart = false;    
}


//This should not be called except by Console Code
function ReturnToGame() //used to return to game and hide menus as well
{    
    GotoState('');
 
}

// ====================================================================
// ConvertKeyToLocalisation: This is convert a key to the name of the key localization
// Ex: english to french : A is A -- Space is Espace -- Backspace is reculer etc...
//	   the localization is in R6Menu.int 
// ====================================================================
function string ConvertKeyToLocalisation( BYTE _Key, string _szEnumKeyName)
{
	local string szResult;
	
	// number
	if (( _Key > EInputKey.IK_0 - 1) && ( _Key < EInputKey.IK_9 + 1))
	{
		szResult = string(_Key - EInputKey.IK_0);
	}
	// alphabet
	else if (( _Key > EInputKey.IK_A - 1) && ( _Key < EInputKey.IK_Z + 1))
	{
		szResult = Chr(_Key);
	}
	// F1 to F24
	else if (( _Key > EInputKey.IK_F1 - 1) && ( _Key < EInputKey.IK_F24 + 1))
	{
		szResult = "F"$(_Key - EInputKey.IK_F1 + 1); //+1 because of the substraction
	}
	else
	{
		szResult = Localize("Interactions", "IK_"$_szEnumKeyName, "Localization\\HUD");
		
		// if the key is not define
		if ( szResult == Localize("Interactions", "IK_None", "Localization\\HUD"))
		{
			szResult = "";
		}
	}

	return szResult;
}

defaultproperties
{
    MenuMusic=Sound'CommonMusic.Play_theme_Menu'
    RootWindow="EchelonMenus.EPCInGameMenuRootWindow"
}