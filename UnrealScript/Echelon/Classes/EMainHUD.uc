/******************************************************************************

 Class:         EMainHUD

 Description:   -


 Reference:     -

******************************************************************************/
class EMainHUD extends HUD native;

/*-----------------------------------------------------------------------------
                                 E X E C ' S
-----------------------------------------------------------------------------*/
#exec OBJ LOAD FILE=..\textures\HUD.utx PACKAGE=HUD
#exec OBJ LOAD FILE=..\textures\MAPS.utx PACKAGE=MAPS

/*-----------------------------------------------------------------------------
                         M E M B E R   V A R I A B L E S
-----------------------------------------------------------------------------*/
var ECommunicationBox	CommunicationBox;       // Cannot move cause referenced directly in script
                                                // Could move if used virtual Get/Set Function
                                                // BUT class ECommunicationBox definition needs to stay in Echelon Package

var EGameplayObject		hud_master;             // Cannot move cause referenced directly in script; 
                                                // Could move if used virtual Get/Set Function

var ETimer              TimerView;

// Because EPattern automatically change the state of the hud, we need to backup ans restore certain things to be sure
// there's no mess when coming back into in-game state
var name				in_game_state_name;
var EGameplayObject		in_game_hud_master;
var bool                bShowCtrl; // Display controller help splash


/*-----------------------------------------------------------------------------
                              M E T H O D S
-----------------------------------------------------------------------------*/
// "Pure virtual" functions of "abstract" class  
function SetRenderState(ECanvas Canvas);
event SetInitialState();
event UpdateProfile();
event LoadProfile(String PlayerName);
event SaveTInfo(int tab);
event LoadTInfo(int tab);

/*-----------------------------------------------------------------------------
 Function :     PostBeginPlay

 Description :  -
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
	CommunicationBox		= spawn(class'ECommunicationBox', self);	

	Super.PostBeginPlay();
}

function Slave(EGameplayObject NewMaster)
{
	hud_master = NewMaster;
	GotoState('s_Slavery');
}

function NormalView()
{
	GotoState('MainHUD');
}

//------------------------------------------------------------------------
// Description		
//		FullInventory in any state will get in .. in s_GameMenu, will get out. Look for oeverride and Ignores.
//------------------------------------------------------------------------
function FullInventory()
{
	// Don't process the START button if we are displaying controller help splash
	if ((!bShowCtrl) && (EPlayerController(Owner).EPawn.Health > 0) && (!IsGameOver()))
	{
		// Joshua - Blocking Xbox pause menu if on keyboard
		if (!EPlayerController(Owner).eGame.bUseController)
		{
			return;
		}

		// Joshua - Necessary to reset keybind if pausing in weapon mode
		EPlayerController(Owner).SetKey("Joy1 Interaction", "");

		EPlayerController(Owner).bStopRenderWorld = true;
		PauseSound();
		SaveState();
		GotoState('s_GameMenu');
    }
}

function SaveState()
{
	in_game_state_name	= GetStateName();
	in_game_hud_master	= hud_master;
	//Log("SAVESTATE"@in_game_state_name@in_game_hud_master);
}

final function name RestoreState()
{
	hud_master			= in_game_hud_master;
	in_game_hud_master	= None;
	//Log("RESTORESTATE"@in_game_state_name@hud_master);
	return in_game_state_name;
}
