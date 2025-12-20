//=============================================================================
// PlayerController
//
// PlayerControllers are used by human players to control pawns.
//
// This is a built-in Unreal class and it shouldn't be modified.
// CHANGENOTE: All Changes since v739 in this class are related to the Weapon code update, except
// for the change in Possess().
//=============================================================================
class PlayerController extends Controller
	config(user)
	native;

// Player info.
var const player Player;

// Player control flags
var bool		bPressedJump;
var bool		bCheatFlying;	// instantly stop in flying mode
var bool		bSavingGameBad;
var bool		bLoadingGameBad;
var bool		bStopRenderWorld;
var bool		bStopInput;
var bool		bShouldResumeAll;

// Global to all profile
var int bGlobalBrightness;
var int bGlobalContrast;
var int bGlobalMusicVol;
var int bGlobalVoiceVol;
var int bGlobalSfxVol;
var int bGlobalAmbVol;
var int bGlobalXPos;
var int bGlobalYPos;

var bool bSavingTraining;
var bool bLoadingTraining;
var bool bAutoSaveLoad;
var EPlayerInfo playerInfo;

var input float
	aMouseX, aMouseY,
	aForward, aStrafe, aTurn, aLookUp, aAltFire, aFire;

// ***********************************************************************************************
// * BEGIN UBI MODIF
// ***********************************************************************************************
var input byte bStrafe, bStepOneFrame;

var EInteractionManager	  IManager;
var Actor				  MicroTarget;	// if this is not None, use it in Dare to get sound from
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

// Camera info.
var int ShowFlags;
var int Misc1,Misc2;
var const int RendMap;
var int ShadowMode;
var int TextureCache;
var int LightmapTextureCache;
var bool ShadowOnActor;
var bool HighQualityCharacterShadow;
var bool ShadowOnStaticMesh;
var bool StaticMeshCastShadow;
var bool ShadowFiltering;
var bool HighSpecGraphicAdapter;
var bool EnableFadeOut;
var int FadeOutNearPlane;
var int FadeOutFarPlane;
var Texture ThermalTexture;
var bool bBigPixels;
var float        OrthoZoom;     // Orthogonal/map view zoom factor.
var const actor ViewTarget;

var globalconfig float DesiredFOV;
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dchabot (28 nov. 2001)
// ***********************************************************************************************
var(Camera) globalconfig float DefaultFOV;
// ***********************************************************************************************
// * END UBI MODIF 
// * dchabot (28 nov. 2001)
// ***********************************************************************************************
var float		ZoomLevel;

var HUD	myHUD;	// heads up display info
var transient int iErrorMsg;

// Components (inner classes)
var CheatManager			CheatManager;	// Object within playercontroller that manages "cheat" commands
var class<CheatManager>		CheatClass;		// class of my CheatManager
var transient PlayerInput	PlayerInput;	// Object within playercontroller that manages player input.
var class<PlayerInput>		InputClass;		// class of my PlayerInput

// ***********************************************************************************************
// * BEGIN UBI MODIF Adionne (28 Oct 2002)
// ***********************************************************************************************
native(4010) final function BYTE GetKey(string szActionKey, bool bAltKey);
native(4011) final function string GetActionKey(BYTE Key);
native(4012) final function string GetEnumName(BYTE Key);
native(4013) final function SetKey(string szKeyAndAction, string szKeyToReplace);
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * ATurcotte (MTL) (13 juin 2001)
// * Purpose : Process Key
// ***********************************************************************************************

event EmptyRecons();

event PlayerGiven();

//Init the controller after it is loaded from a load game.
event InitLoadGame();

event bool KeyEvent(string Key, EInputAction Action, FLOAT Delta)
{
	return myHUD.KeyEvent(Key, Action, Delta);
}

//clauzon 9/11/2002 To change key mapping in Menus
event  RealKeyEvent(string RealKeyValue, EInputAction Action, FLOAT Delta)
{
	myHUD.RealKeyEvent(RealKeyValue, Action, Delta);
}

function bool CanAddInteract(EInteractObject IntObj)
{
	return false;
}

event bool CanSaveGame();
event bool CanLoadGame();
event bool CanGoBackToGame();

function UpdateCameraRotation(actor ViewActor);	// handle in EPlayerController
// ***********************************************************************************************
// * END UBI MODIF 
// * ATurcotte (MTL) (13 juin 2001)
// ***********************************************************************************************

native function string ConsoleCommand(string Command);
event string SendConsoleCommand(string Command)
{
	return ConsoleCommand(Command);
}

native final function LevelInfo GetEntryLevel();
native(544) final function ResetKeyboard();
// ***********************************************************************************************
// * BEGIN UBI MODIF Adionne (26 Nov 2002)
// ***********************************************************************************************
native(4017) final function SaveKeyboard();
native(4018) final function LoadKeyboard();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************
native final function SetViewTarget(Actor NewViewTarget);
native event ClientTravel(string URL, ETravelType TravelType, bool bItems);
native(546) final function UpdateURL(string NewOption, string NewValue, bool bSaveDefault);
native final function string GetDefaultURL(string Option);
// Execute a console command in the context of this player, then forward to Actor.ConsoleCommand.
native function CopyToClipboard(string Text);
native function string PasteFromClipboard();

event PostBeginPlay()
{
	Super.PostBeginPlay();
	DesiredFOV = DefaultFOV;
	SetViewTarget(self);  // MUST have a view target!
	CheatManager = new CheatClass;
	IManager      = spawn(class'EInteractionManager',self);
	iErrorMsg = -3;
	playerInfo = Spawn(class'EPlayerInfo', self);
}
	
/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	PawnDied();
	Super.Reset();
	SetViewTarget(self);
	GotoState('PlayerWaiting');
}

/* InitInputSystem()
Spawn the appropriate class of PlayerInput
Only called for playercontrollers that belong to local players
*/
event InitInputSystem()
{
	PlayerInput = new InputClass;
}

// Possess a pawn
function Possess(Pawn aPawn)
{
	SetRotation(aPawn.Rotation);
	aPawn.PossessedBy(self);
	Pawn = aPawn;
	Pawn.bStasis = false;
	Restart();
}

// unpossessed a pawn (not because pawn was killed)
function UnPossess()
{
	if (Pawn != None)
	{
		SetLocation(Pawn.Location);
		Pawn.UnPossessed();
		if (Viewtarget == Pawn)
			SetViewTarget(self);
	}
	Pawn = None;
}

event Destroyed()
{
	if (Pawn != None)
	{
		Pawn.Health = 0;
		Pawn.Died(self, None, Pawn.Location);
	}
	Super.Destroyed();
	myHud.Destroy();
}


// ------------------------------------------------------------------------
// Zooming/FOV change functions

function FixFOV()
{
//	FOVAngle = Default.DefaultFOV;
//	DesiredFOV = Default.DefaultFOV;
//	DefaultFOV = Default.DefaultFOV;
}

function SetFOV(float NewFOV)
{
//	DesiredFOV = NewFOV;
//	FOVAngle = NewFOV;
}

function ResetFOV()
{
//	DesiredFOV = DefaultFOV;
//	FOVAngle = DefaultFOV;
}

exec function FOV(float F)
{
//	DefaultFOV = FClamp(F, 1, 170);
//	DesiredFOV = DefaultFOV;
//	SaveConfig();
}

function HandleWalking()
{
	if (Pawn != None)
		Pawn.SetWalking((bRun != 0) || (bDuck != 0)); 
}

//function SetFOVAngle(float newFOV)
//{
//	FOVAngle = newFOV;
//}
	 
function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType,optional int PillTag) //UBI MODIF - Additional parameter
{
	if ((Other != None) && (Other != Pawn) && (Damage > 0))
		Enemy = Other;
}

exec function RestartLevel()
{
	ClientTravel("?restart", TRAVEL_Relative, false);
}

exec function LocalTravel(string URL)
{
	ClientTravel(URL, TRAVEL_Relative, true);
}

event bool SetPause(BOOL bPause)
{
	return Level.Game.SetPause(bPause, self);
}

exec function Pause()
{
	SetPause(Level.Pauser == None);
}

exec function Suicide()
{
	Pawn.KilledBy(None);
}

function Restart()
{
	Enemy = None;
	EnterStartState();
	SetViewTarget(Pawn);
	ClientRestart();
}

function EnterStartState();

function ClientRestart()
{
	if (Pawn == None)
	{
		GotoState('WaitingForPawn');
		return;
	}
	Pawn.ClientRestart();
	SetViewTarget(Pawn);
	EnterStartState();	
}

event PlayerTick(float DeltaTime)
{
	PlayerInput.PlayerInput(DeltaTime);

	UpdateCameraRotation(ViewTarget);

	PlayerMove(DeltaTime);
}

function PlayerMove(float DeltaTime);

event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation);

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
event PlayerCalcEye(out vector EyeLocation, out rotator EyeRotation)
{
	local vector X,Y,Z;
	EyeRotation = Pawn.GetViewRotation();
	GetAxes(EyeRotation, X,Y,Z);
	EyeLocation = Pawn.Location;
	EyeLocation.Z += Pawn.CollisionHeight * 0.8;
	EyeLocation += X * Pawn.CollisionRadius / 2;
}
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

defaultproperties
{
    bStopRenderWorld=True
    ShadowOnActor=True
    ShadowOnStaticMesh=True
    StaticMeshCastShadow=True
    ShadowFiltering=True
    FadeOutNearPlane=707
    FadeOutFarPlane=1000
    OrthoZoom=40000.000000
    DesiredFOV=85.000000
    DefaultFOV=85.000000
    CheatClass=Class'CheatManager'
    InputClass=Class'PlayerInput'
    FovAngle=85.000000
    bIsPlayer=True
    bTravel=True
}