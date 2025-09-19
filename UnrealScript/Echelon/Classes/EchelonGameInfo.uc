//=============================================================================
// EchelonGameInfo.
//
// default game info is normal single player
//
//=============================================================================
class EchelonGameInfo extends GameInfo
    config(Enhanced)  // Joshua - Class, configurable in Enhanced config
    native;



var EchelonLevelInfo    ELevel;
var EPlayerController	pPlayer;
var EVariable		    VarObject;

var	int					NumVisChecks;					// number of visibility checks done in this frame

var()  int HUD_OFFSET_X;      // Offset from left and right side of the screen
var()  int HUD_OFFSET_Y;      // Offset from top and bottom side of the screen
var()  bool bDemoMode;        // Set this variable at true to set the menu in demo mode
var()  bool bNoGore;
var()  bool bNoSamLookAt;
var()  string DemoMap;        // Map loaded for Demo
var()  string TrainingMap;    // Map loaded for Training
var    bool bStartGame;       // true only the first time you go in main menu

//=============================================================================
// Variables used as constants

var()		float	m_minInterpolSpeed;
var() 		float	m_grabbingDelay;
var() 		float	m_blinkDelay;

// Input


var(Input)    int     m_maxSpeedInterval;
var(Input) config int m_defautSpeed; // Joshua - Added to Enhanced config

var(Input) 	float	m_forwardGentle;
var(Input) 	float	m_forwardCrawl;
var(Input) 	float	m_forwardFull;
var(Input) 	float	m_backwardGentle;
var(Input) 	float	m_backwardCrawl;
var(Input) 	float	m_backwardFull;
var(Input) 	float	m_rightGentle;
var(Input) 	float	m_rightCrawl;
var(Input) 	float	m_rightFull;
var(Input) 	float	m_leftGentle;
var(Input) 	float	m_leftCrawl;
var(Input) 	float	m_leftFull;
var(Input) 	float	m_minForce;
var(Input) 	float	m_gentleForce;
var(Input) 	float	m_fullForce;
var(Input) 	float	m_inAirAccel;
var(Input) 	float	m_onGroundAccel;
var(Input) 	float	m_RollSpeed;
var(Input) 	float	m_walkBias;

var(Input) 	float	m_PlayerJoggingThreshold;
var()	   	float	m_JumpOutSpeed;

// GEO
var(Ledge) 	float	m_LGShimmySpeed;
var(Ledge) 	float	m_LGSpeedThreshold;
var(Ledge) 	float	m_LGMinLength;
var(Ledge) 	float	m_LGMaxGrabbingSpeed;
var(Ledge) 	float	m_LGMinGrabbingSpeed;
var(Ledge) 	float	m_LGMaxGrabbingAngle;
var(Ledge) 	float	m_LGMaxGrabbingDistance;
var(Ledge) 	float	m_LGMaxFallGrabSpeed;

var(Pole) 	float	m_PLMaxGrabbingSpeed;
var(Pole) 	float	m_PLMinGrabbingSpeed;
var(Pole) 	float	m_PLMaxGrabbingDistance;
var(Pole) 	float	m_PLMaxGrabbingAngle;
var(Pole) 	float	m_PLSlideDownMinSpeed;
var(Pole) 	float	m_PLSlideDownMaxSpeed;
var(Pole) 	float	m_PLSlideDownInertia;
var(Pole) 	float	m_PLUpwardSpeed;
var(Pole) 	float	m_PLFeetOffset;
var(Pole) 	float	m_PLRotationSpeed;

var(HOH) 	float	m_HOHForwardSpeed;
var(HOH) 	float	m_HOHMinLength;
var(HOH) 	float	m_HOHMaxGrabbingSpeed;
var(HOH) 	float	m_HOHMinGrabbingSpeed;
var(HOH) 	float	m_HOHMaxGrabbingDistance;
var(HOH) 	float	m_HOHFeetUpGap;
var(HOH) 	float	m_HOHFeetUpColHoriOffset;
var(HOH) 	float	m_HOHFeetUpColVertOffset;
var(HOH) 	float	m_HOHFeetUpMoveSpeed;
var(HOH) 	float	m_HOHFeetUpColHeight;

var(Ladder) 	float	m_NLUpwardSpeed;
var(Ladder) 	float	m_NLDownwardSpeed;
var(Ladder) 	float	m_NLStepSize;
var(Ladder) 	float	m_NLSlideDownMaxSpeed;
var(Ladder) 	float	m_NLSlideDownMinSpeed;
var(Ladder) 	float	m_NLSlideDownInertia;
var(Ladder) 	float	m_NLMaxGrabbingAngle;
var(Ladder) 	float	m_NLMaxGrabbingAngleTop;
var(Ladder) 	float	m_NLMaxGrabbingDistance;
var(Ladder) 	float	m_NLMaxGrabbingSpeed;
var(Ladder) 	float	m_NLMinGrabbingSpeed;
var(Ladder) 	float	m_NLSlideDelay;

var(Pipe) 	float	m_PUpwardSpeed;
var(Pipe) 	float	m_PDownwardSpeed;
var(Pipe) 	float	m_PSlideDownMaxSpeed;
var(Pipe) 	float	m_PSlideDownMinSpeed;
var(Pipe) 	float	m_PSlideDownInertia;
var(Pipe) 	float	m_PMaxGrabbingAngle;
var(Pipe) 	float	m_PMaxGrabbingAngleTop;
var(Pipe) 	float	m_PMaxGrabbingDistance;
var(Pipe) 	float	m_PMaxGrabbingSpeed;
var(Pipe) 	float	m_PMinGrabbingSpeed;

var(ZipLine) 	float	m_ZLSlideDownMaxSpeed;
var(ZipLine) 	float	m_ZLSlideDownMinSpeed;
var(ZipLine) 	float	m_ZLSlideDownInertia;
var(ZipLine) 	float	m_ZLMaxGrabbingDistance;
var(ZipLine) 	float	m_ZLMaxGrabbingSpeed;
var(ZipLine) 	float	m_ZLMinGrabbingSpeed;

var(Fence) 	float	m_FMaxGrabbingSpeed;
var(Fence) 	float	m_FMinGrabbingSpeed;

var(DamageHeight)  float MinBeforeDamage;
var(DamageHeight)  float MaxBeforeDeath;
var(DamageHeight)  float NPCCushionDivider;

var(SurfaceNoise) SurfaceNoiseInfo VeryQuietSurface;
var(SurfaceNoise) SurfaceNoiseInfo QuietSurface;
var(SurfaceNoise) SurfaceNoiseInfo NormalSurface;
var(SurfaceNoise) SurfaceNoiseInfo LoudSurface;
var(SurfaceNoise) SurfaceNoiseInfo VeryLoudSurface;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================

var bool bUseController; // Joshua - Adjusts HUD, inventory, lockpicking, keypad, turrets for controller
var(Enhanced) config bool bEnableCheckpoints; // Joshua - Restores the checkpoints from the Xbox version

var(Enhanced) config bool bThermalOverride; // Joshua - Enables thermal vision to be available for all levels, regardless of their original settings
var(Enhanced) config bool bOpticCableVisions; // Joshua - Allows the Optic Cable use all vision modes like Pandora Tomorrow
var(Enhanced) config bool bScaleGadgetDamage; // Joshua - Scales gadget damage on Hard difficulty (Pandora Tomorrow applied this fix: NPCs have 1.5x health on Hard, so 1.5x damage)
var(Enhanced) config bool bPS2FN7Accuracy; // Joshua - Uses the FN7's accuracy values from the PS2 version
var(Enhanced) config bool bNewDoorInteraction; // Joshua - Uses new door interaction system that adds Lock Pick, Disposable Pick, and Optic Cable like Chaos Theory
var(Enhanced) config bool bRandomizeLockpick; // Joshua - Randomizes all the lockpick combinations on doors


var(Enhanced) config bool bXboxDifficulty; // Joshua - Xbox difficulty, Sam has more health on Xbox
var(Enhanced) config bool bEliteMode; // Joshua - Elite mode, no starting ammo, lower health, no saving, 3 alarms
var(Enhanced) config bool bPermadeathMode; // Joshua - Permadeath mode, profile deletion upon mission failure

// Joshua - Option to reduce delay to prevent running past the wallmine before it explodes
enum EWallMineDelay
{
    WMD_Default,  //1.75
    WMD_Enhanced, //0.50
    WMD_Instant   //0.00
};
var(Enhanced) config EWallMineDelay WallMineDelay;

// Joshua - New variables to override which SamMesh to use in a level
enum ESamMeshType
{
    SMT_Default,        // Default mesh assigned by level
    SMT_Standard,       // SamAMesh
    SMT_Balaclava,      // SamBMesh
    SMT_PartialSleeves  // SamCMesh
};
var config ESamMeshType ESam_Training; 
var config ESamMeshType ESam_Tbilisi;
var config ESamMeshType ESam_DefenseMinistry;
var config ESamMeshType ESam_CaspianOilRefinery;
var config ESamMeshType ESam_CIA;
var config ESamMeshType ESam_Kalinatek;
var config ESamMeshType ESam_PowerPlant;
var config ESamMeshType ESam_Severonickel;
var config ESamMeshType ESam_ChineseEmbassy;
var config ESamMeshType ESam_Abattoir;
var config ESamMeshType ESam_ChineseEmbassy2;
var config ESamMeshType ESam_PresidentialPalace;
var config ESamMeshType ESam_KolaCell;
var config ESamMeshType ESam_Vselka;

// Joshua - Echelon lights use TurnOffDistance to determine when to turn off
// This setting allows users to scale that distance up to 8x, allowing Echelon lights to stay on farther away
enum ETurnOffDistanceScale
{
    TurnOffDistance_1x,
    TurnOffDistance_2x,
    TurnOffDistance_4x,
    TurnOffDistance_8x
};
var(Enhanced) config ETurnOffDistanceScale TurnOffDistanceScale;

// Native Variables
var(Enhanced) config bool bSkipIntroVideos;
var(Enhanced) config bool bDisableMenuIdleTimer; // Joshua - Disables inactivity videos
var(Enhanced) config bool bXboxFont;
var(Enhanced) config bool bLODDistance;
var(Enhanced) config bool bPauseOnFocusLoss;
var(Enhanced) config bool bCheckForUpdates;
var(Enhanced) config bool bSteamDeckMode; // Joshua - Block opening links on Steam Deck as it will crash the game

//=============================================================================

//----------------------------------------[FSchelling - 15 June 2001]-----
function PostBeginPlay()
{
	local class<EVariable> VarObjectClassName;

	Super.PostBeginPlay();

	//load the the specific variable class
	VarObjectClassName = class<EVariable>(DynamicLoadObject("EchelonPattern.VGame", class'Class'));

	if(VarObjectClassName != None)
	{
		//spawn variable class
		VarObject = spawn(VarObjectClassName,self);

		//log("Variable class for the game spawned: "$VarObject);
	}
	
	// set EchelonLevelInfo reference
	ELevel = EchelonLevelInfo(Level);

	if ( ELevel == none )
		log("ECHELON LEVEL INFO COULD NOT BE SET");
}

//---------------------------------------[David Kalina - 12 Apr 2001]-----
// 
// Description
//		Spawns and logs in the Player Controller.
//		Since this is an Echelon Game, we make sure the controller casts
//		to an EPlayerController and store it for easy access.
// 
// Input
//		Portal : 
//		Options : 
//		Error : 
//
// Output
//		PlayerController : 
//
//------------------------------------------------------------------------

event PlayerController Login(string Portal,
					         string Options,
					         out string Error)
{
	local PlayerController NewPlayer;

	NewPlayer = Super.Login(Portal, Options, Error);
	Log("Echelon -- New Player super login");

    pPlayer = EPlayerController(NewPlayer);    // set gameinfo reference to Echelon Player type

	//for the engine
	PlayerC = NewPlayer;

	if (pPlayer == none)
		Log("WARNING!!!!!!   EchelonGameInfo.pPlayer is NOT an EPlayerController.  This is bad.");

    pPlayer.m_curWalkSpeed = m_defautSpeed;
    
    if (bPermadeathMode)
        pPlayer.CheatManager = None;

    // Joshua - Elite mode
    if (bEliteMode)
    {
        pPlayer.CheatManager = None;
        pPlayer.ePawn.InitialHealth = 100; // 100 * 0.66 = 66 HP
        pPlayer.ePawn.Health = pPlayer.ePawn.InitialHealth;

        if (pPlayer.MainGun != None) // No SC-20K ammo
        {
            pPlayer.MainGun.Ammo = 0;
            pPlayer.MainGun.ClipAmmo = 0;
        }

        if (pPlayer.HandGun != None) // No SC Pistol ammo
        {
            pPlayer.HandGun.Ammo = 0;
            pPlayer.HandGun.ClipAmmo = 0;
        }
    }
    else // Not Elite Mode
    {
        // Joshua - Xbox difficulty
        if (bXboxDifficulty)
        {
            // Xbox = 300 HP, PC = 200 HP [Normal]
            // Xbox = 198 HP, PC = 132 HP [Hard]
            pPlayer.ePawn.InitialHealth = 300;
            pPlayer.ePawn.Health = pPlayer.ePawn.InitialHealth;
        }

        // Joshua - PS2 FN7 Accuracy
        if (bPS2FN7Accuracy)
        {
            if (pPlayer.HandGun != None)
            {
                pPlayer.HandGun.AccuracyMovementModifier = 3.330000;
                pPlayer.HandGun.AccuracyBase = 0.330000;
            }
        }
    }

	return NewPlayer;
}

exec function SaveEnhancedOptions()
{
	SaveConfig("Enhanced");
}

native(2345) final function string GetStringBinding(EchelonEnums.eKEY_BIND Key);
native(2346) final function EchelonEnums.eKEY_BIND GetKeyBinding(string Key);

defaultproperties
{
    HUD_OFFSET_X=24
    HUD_OFFSET_Y=39
    DemoMap="3_4_3Severonickel"
    TrainingMap="0_0_2_Training"
    bStartGame=true
    m_minInterpolSpeed=200.000000
    m_grabbingDelay=0.200000
    m_blinkDelay=3.000000
    m_maxSpeedInterval=5
    m_defautSpeed=5 // Joshua - Default speed in original game is 1
    m_forwardGentle=0.500000
    m_forwardCrawl=0.100000
    m_forwardFull=0.900000
    m_backwardGentle=-0.500000
    m_backwardCrawl=-0.100000
    m_backwardFull=-0.900000
    m_rightGentle=0.500000
    m_rightCrawl=0.100000
    m_rightFull=0.900000
    m_leftGentle=-0.500000
    m_leftCrawl=-0.100000
    m_leftFull=-0.900000
    m_minForce=0.020000
    m_gentleForce=0.500000
    m_fullForce=0.900000
    m_inAirAccel=1000.000000
    m_onGroundAccel=2000.000000
    m_RollSpeed=350.000000
    m_walkBias=0.300000
    m_PlayerJoggingThreshold=300.000000
    m_JumpOutSpeed=200.000000
    m_LGShimmySpeed=50.000000
    m_LGSpeedThreshold=10.000000
    m_LGMinLength=28.000000
    m_LGMaxGrabbingSpeed=200.000000
    m_LGMinGrabbingSpeed=-1000.000000
    m_LGMaxGrabbingAngle=-0.600000
    m_LGMaxGrabbingDistance=1000.000000
    m_LGMaxFallGrabSpeed=200.000000
    m_PLMaxGrabbingSpeed=200.000000
    m_PLMinGrabbingSpeed=-1000.000000
    m_PLMaxGrabbingDistance=35.000000
    m_PLMaxGrabbingAngle=-0.600000
    m_PLSlideDownMinSpeed=200.000000
    m_PLSlideDownMaxSpeed=600.000000
    m_PLSlideDownInertia=600.000000
    m_PLUpwardSpeed=50.000000
    m_PLFeetOffset=80.000000
    m_PLRotationSpeed=20000.000000
    m_HOHForwardSpeed=100.000000
    m_HOHMinLength=15.000000
    m_HOHMaxGrabbingSpeed=200.000000
    m_HOHMinGrabbingSpeed=-1000.000000
    m_HOHMaxGrabbingDistance=1500.000000
    m_HOHFeetUpGap=100.000000
    m_HOHFeetUpColHoriOffset=45.000000
    m_HOHFeetUpColVertOffset=60.000000
    m_HOHFeetUpMoveSpeed=40.000000
    m_HOHFeetUpColHeight=18.000000
    m_NLUpwardSpeed=120.000000
    m_NLDownwardSpeed=-120.000000
    m_NLStepSize=32.000000
    m_NLSlideDownMaxSpeed=600.000000
    m_NLSlideDownMinSpeed=200.000000
    m_NLSlideDownInertia=600.000000
    m_NLMaxGrabbingAngle=-0.600000
    m_NLMaxGrabbingAngleTop=0.300000
    m_NLMaxGrabbingDistance=35.000000
    m_NLMaxGrabbingSpeed=100.000000
    m_NLMinGrabbingSpeed=-1000.000000
    m_NLSlideDelay=0.200000
    m_PUpwardSpeed=130.000000
    m_PDownwardSpeed=-130.000000
    m_PSlideDownMaxSpeed=600.000000
    m_PSlideDownMinSpeed=200.000000
    m_PSlideDownInertia=600.000000
    m_PMaxGrabbingAngle=-0.600000
    m_PMaxGrabbingAngleTop=0.300000
    m_PMaxGrabbingDistance=35.000000
    m_PMaxGrabbingSpeed=100.000000
    m_PMinGrabbingSpeed=-1000.000000
    m_ZLSlideDownMaxSpeed=400.000000
    m_ZLSlideDownMinSpeed=200.000000
    m_ZLSlideDownInertia=400.000000
    m_ZLMaxGrabbingDistance=1500.000000
    m_ZLMaxGrabbingSpeed=200.000000
    m_ZLMinGrabbingSpeed=-1000.000000
    m_FMaxGrabbingSpeed=200.000000
    m_FMinGrabbingSpeed=-1000.000000
    MinBeforeDamage=1250.000000
    MaxBeforeDeath=1500.000000
    NPCCushionDivider=2.000000
    VeryQuietSurface=(JogRadius=400.000000,CrouchJogRadius=225.000000,LandingRadius=500.000000)
    QuietSurface=(JogRadius=550.000000,CrouchJogRadius=308.000000,LandingRadius=650.000000)
    NormalSurface=(WalkRadius=200.000000,JogRadius=700.000000,CrouchJogRadius=392.000000,LandingRadius=800.000000)
    LoudSurface=(WalkRadius=350.000000,JogRadius=1100.000000,CrouchJogRadius=616.000000,LandingRadius=1200.000000)
    VeryLoudSurface=(WalkRadius=500.000000,JogRadius=1500.000000,CrouchWalkRadius=100.000000,CrouchJogRadius=840.000000,LandingRadius=1600.000000,QuietLandingRadius=200.000000)
    GameName="Echelon"
    PlayerControllerClassName="Echelon.EPlayerController"
    bOpticCableVisions=true
    bEnableCheckpoints=true
    bScaleGadgetDamage=true
    bNewDoorInteraction=true
    bRandomizeLockpick=true
    WallMineDelay=WMD_Default
    ESam_Training=SMT_Default
    ESam_Tbilisi=SMT_Default
    ESam_DefenseMinistry=SMT_Default
    ESam_CaspianOilRefinery=SMT_Default
    ESam_CIA=SMT_Default
    ESam_Kalinatek=SMT_Default
    ESam_PowerPlant=SMT_Default
    ESam_Severonickel=SMT_Default
    ESam_ChineseEmbassy=SMT_Default
    ESam_Abattoir=SMT_Default
    ESam_ChineseEmbassy2=SMT_Default
    ESam_PresidentialPalace=SMT_Default
    ESam_KolaCell=SMT_Default
    ESam_Vselka=SMT_Default
    TurnOffDistanceScale=TurnOffDistance_4x
    bXboxFont=true
    bLODDistance=true
    bPauseOnFocusLoss=true
    bCheckForUpdates=true
}
