//=============================================================================
// GameInfo.
//
// The GameInfo defines the game being played: the game rules, scoring, what actors 
// are allowed to exist in this game type, and who may enter the game.  While the 
// GameInfo class is the public interface, much of this functionality is delegated 
// to several classes to allow easy modification of specific game components.  These 
// classes include GameInfo.  
// A GameInfo actor is instantiated when the level is initialized for gameplay (in 
// C++ UGameEngine::LoadMap()).  The class of this GameInfo actor is determined by 
// (in order) either  if specified in the LevelInfo, or the 
// DefaultGame entry in the game's .ini file (in the Engine.Engine section), unless 
// its a network game in which case the DefaultServerGame entry is used.  
//
//=============================================================================
class GameInfo extends Info
	native;

//-----------------------------------------------------------------------------
// Variables.

var byte					  Difficulty;				// 0 = easy, 1 = medium, 2 = hard, 3 = very hard.
var bool				      bRestartLevel;			// Level should be restarted when player dies
var bool				      bPauseable;				// Whether the game is pauseable.
var	bool					  bGameEnded;				// set when game ends
var bool					  bWaitingToStartMatch;
var globalconfig bool		  bChangeLevels;
var bool					  bAlreadyChanged;
var float	                  StartTime;
var string					  DefaultPlayerClassName;

var localized string	      DefaultPlayerName;
var localized string	      GameName;

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * Fblais (27 Jun 2001)
// * Purpose : So now we can get the player directly from the gameinfo
// ***********************************************************************************************
var PlayerController		PlayerC;

var(Stealth) config 	float	VisFullyThreshold;
var(Stealth) config 	float	VisMostlyThreshold;
var(Stealth) config 	float	VisPartiallyThreshold;
var(Stealth) config 	float	VisBarelyThreshold;
var(Stealth) config 	float	VisSpeedGain;		// divide current player speed by this value and add to base light calculation
var(Stealth) config 	float	VisCrouchMul;			// crouching subtracts this amount from base light calculation
var(Stealth) config		float	VisBackToWallMul;

// Joshua - Removed 'config' keyword so SplinterCell.ini no longer affects this option
// Rumble is now controlled by bEnableRumble in EchelonGameInfo
var	bool UseRumble;

// ***********************************************************************************************
// * END UBI MODIF 
// * Fblais (27 Jun 2001)
// ***********************************************************************************************


//-------------------------------------
// GameInfo components
var class<PlayerController> PlayerControllerClass;	// type of player controller to spawn for players logging in
var string PlayerControllerClassName;

var array<Name> LocalGameEvents;	// game events local to this level
var array<Name> TravelGameEvents;	// game events which travel from level to level.  FIXME - make them travel!!!

native final function AddLocalGameEvent(name Event);
native final function AddTravelGameEvent(name Event);
native final function RemoveGameEvent(name Event);
native final function bool GameEventRegistered(name Event);

//------------------------------------------------------------------------------
// Engine notifications.

function PreBeginPlay()
{
	StartTime = 0;
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
	bGameEnded = false;
	bWaitingToStartMatch = true;
}

function bool SetPause(BOOL bPause, PlayerController P)
{
	if (bPause)
		Level.Pauser = P;
	else
		Level.Pauser = None;
	return True;
}

function bool GetPause()
{		
	return Level.Pauser != none;	
}

//
// Called after setting low or high detail mode.
//
event DetailChange()
{
	local actor A;
	local zoneinfo Z;
	local skyzoneinfo S;

	if (!Level.bHighDetailMode)
	{
		foreach DynamicActors(class'Actor', A)
		{
			if (A.bHighDetail)
				A.Destroy();
		}
	}
	foreach AllActors(class'ZoneInfo', Z)
		Z.LinkToSkybox();
}

//------------------------------------------------------------------------------
// Player start functions

//
// Grab the next option from a string.
//
function bool GrabOption(out string Options, out string Result)
{
	if (Left(Options,1)=="?")
	{
		// Get result.
		Result = Mid(Options,1);
		if (InStr(Result,"?")>=0)
			Result = Left(Result, InStr(Result,"?"));

		// Update options.
		Options = Mid(Options,1);
		if (InStr(Options,"?")>=0)
			Options = Mid(Options, InStr(Options,"?"));
		else
			Options = "";

		return true;
	}
	else return false;
}

//
// Break up a key=value pair into its key and value.
//
function GetKeyValue(string Pair, out string Key, out string Value)
{
	if (InStr(Pair,"=")>=0)
	{
		Key   = Left(Pair,InStr(Pair,"="));
		Value = Mid(Pair,InStr(Pair,"=") + 1);
	}
	else
	{
		Key   = Pair;
		Value = "";
	}
}

/* ParseOption()
 Find an option in the options string and return it.
*/
function string ParseOption(string Options, string InKey)
{
	local string Pair, Key, Value;
	while (GrabOption(Options, Pair))
	{
		GetKeyValue(Pair, Key, Value);
		if (Key ~= InKey)
			return Value;
	}
	return "";
}

function int GetIntOption(string Options, string ParseString, int CurrentValue)
{
	local string InOpt;

	InOpt = ParseOption(Options, ParseString);
	if (InOpt != "")
	{
		log(ParseString@InOpt);
		return int(InOpt);
	}	
	return CurrentValue;
}

//
// Log a player in.
// Fails login if you set the Error string.
// PreLogin is called before Login, but significant game time may pass before
// Login is called, especially if content is downloaded.
//
event PlayerController Login
(
	string Portal,
	string Options,
	out string Error
)
{
	local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local class<Pawn> DesiredPawnClass;
	local Pawn      TestPawn;
	local string    InClass;
	local int i;
	local Actor A;

	// Find a start spot.
	StartSpot = FindPlayerStart(None, 0, Portal);

	if (StartSpot == None)
	{
		return None;
	}

	if (PlayerControllerClass == None)
		PlayerControllerClass = class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, class'Class'));
	NewPlayer = spawn(PlayerControllerClass,,,StartSpot.Location,StartSpot.Rotation);

	// Handle spawn failure.
	if (NewPlayer == None)
	{
		log("Couldn't spawn player controller of class "$PlayerControllerClass);
		return None;
	}

	NewPlayer.StartSpot = StartSpot;

	InClass = ParseOption(Options, "Class");
	if (InClass != "")
	{
		DesiredPawnClass = class<Pawn>(DynamicLoadObject(InClass, class'Class'));
		if (DesiredPawnClass != None)
			NewPlayer.PawnClass = DesiredPawnClass;
	}

	// start match, or let player enter, immediately
	bRestartLevel = false;	// let player spawn once in levels that must be restarted after every death
	if (bWaitingToStartMatch)
		StartMatch();
	else
		RestartPlayer(newPlayer);
	bRestartLevel = Default.bRestartLevel;
	return newPlayer;
}	

/* StartMatch()
Start the game - inform all actors that the match is starting, and spawn player pawns
*/
function StartMatch()
{	
	local Controller P;
	local Actor A; 

	// start human players first
	for (P = Level.ControllerList; P != None; P = P.nextController)
		if (P.IsA('PlayerController') && (P.Pawn == None))
		{
			if (bGameEnded) return; // telefrag ended the game with ridiculous frag limit
			else
				RestartPlayer(P);
		}

	// start AI players
	for (P = Level.ControllerList; P != None; P = P.nextController)
		if (P.bIsPlayer && !P.IsA('PlayerController'))
			RestartPlayer(P);

	bWaitingToStartMatch = false;
}

//
// Restart a player.
//
function RestartPlayer(Controller aPlayer)	
{
	local NavigationPoint StartSpot;
	local bool foundStart;
	local int TeamNum,i;
	local class<Pawn> DefaultPlayerClass;

	if (bRestartLevel)
		return;

	TeamNum = 255;

	StartSpot = FindPlayerStart(aPlayer, TeamNum);
	if (StartSpot == None)
	{
		log(" Player start not found!!!");
		return;
	}	

	if (aPlayer.PawnClass != None)
		aPlayer.Pawn = Spawn(aPlayer.PawnClass,,,StartSpot.Location,StartSpot.Rotation);

	if (aPlayer.Pawn == None)
	{
		DefaultPlayerClass = class<Pawn>(DynamicLoadObject(GetDefaultPlayerClassName(aPlayer), class'Class'));
		aPlayer.Pawn = Spawn(DefaultPlayerClass,,,StartSpot.Location,StartSpot.Rotation);
	}
	if (aPlayer.Pawn == None)
	{
		log("Couldn't spawn player of type "$aPlayer.PawnClass$" at "$StartSpot);
		aPlayer.GotoState('Dead');
		return;
	}

	aPlayer.Possess(aPlayer.Pawn);
	aPlayer.PawnClass = aPlayer.Pawn.Class;

	PlayTeleportEffect(aPlayer, true, true);
//	aPlayer.ClientSetRotation(aPlayer.Pawn.Rotation);
	TriggerEvent(StartSpot.Event, StartSpot, aPlayer.Pawn);
}

function string GetDefaultPlayerClassName(Controller C)
{
	return DefaultPlayerClassName;
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	PlayerPawn.JumpZ = PlayerPawn.Default.JumpZ;
	PlayerPawn.AirControl = PlayerPawn.Default.AirControl;
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
	local Controller C;

	for (C = Level.ControllerList; C != None; C = C.nextController)
		C.NotifyKilled(Killer, Killed, KilledPawn);
}

function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType)
{
	local String Message, KillerWeapon, OtherWeapon;
	local name logtype;

	NotifyKilled(Killer,Killed,KilledPawn);
}

//-------------------------------------------------------------------------------------
// Level gameplay modification.

/* Send a player to a URL.
*/
function SendPlayer(PlayerController aPlayer, string URL)
{
	aPlayer.ClientTravel(URL, TRAVEL_Relative, true);
}

/* Play a teleporting special effect.
*/
function PlayTeleportEffect(actor Incoming, bool bOut, bool bSound)
{
	Incoming.MakeNoise(1.0);
}

//==========================================================================
	
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local NavigationPoint N, BestStart;
	local Teleporter Tel;
	local float BestRating, NewRating;
	local byte Team;

	// always pick StartSpot at start of match
	if ((Player != None) && (Player.StartSpot != None))
	{
		return Player.StartSpot;
	}	

	// if incoming start is specified, then just use it
	if (incomingName!="")
		foreach AllActors(class 'Teleporter', Tel)
			if (string(Tel.Tag)~=incomingName)
				return Tel;

	Team = InTeam;

	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	{
		NewRating = RatePlayerStart(N,InTeam,Player);
		if (NewRating > BestRating)
		{
			BestRating = NewRating;
			BestStart = N;
		}
	}
	
	if (BestStart == None)
	{
		log("Warning - PATHS NOT DEFINED or NO PLAYERSTART");			
		foreach AllActors(class 'NavigationPoint', N)
		{
			NewRating = RatePlayerStart(N,0,Player);
			if (NewRating > BestRating)
			{
				BestRating = NewRating;
				BestStart = N;	
			}
		}
	}

	return BestStart;
}

function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
	local PlayerStart P;

	P = PlayerStart(N);
	if (P != None)
	{
		return 1000;
	}
	return 0;
}

defaultproperties
{
    bRestartLevel=True
    bPauseable=True
    bWaitingToStartMatch=True
    bChangeLevels=True
    DefaultPlayerName="Player"
    GameName="Game"
    PlayerControllerClassName="Engine.PlayerController"
	UseRumble=True // Joshua - Always set to true, Rumble is now toggled via bEnableRumble in EchelonGameInfo
}