//=============================================================================
// LevelInfo contains information about the current level. There should 
// be one per level and it should be actor 0. UnrealEd creates each level's 
// LevelInfo automatically so you should never have to place one
// manually.
//
// The ZoneInfo properties in the LevelInfo are used to define
// the properties of all zones which don't themselves have ZoneInfo.
//=============================================================================
class LevelInfo extends ZoneInfo
	native;

// Textures.
#exec Texture Import File=Textures\WhiteSquareTexture.pcx NOCONSOLE
#exec Texture Import File=Textures\S_Vertex.tga Name=LargeVertex NOCONSOLE

#exec Texture Import File=Textures\heat_and_attenuation_2dA.tga Mips=Off MASKED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
#exec Texture Import File=Textures\heat_and_attenuation_2dB.tga Mips=Off MASKED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
#exec Texture Import File=Textures\heat_and_attenuation_2dC.tga Mips=Off MASKED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
#exec Texture Import File=Textures\heat_and_attenuation_2dCheatA.tga Mips=Off MASKED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
#exec Texture Import File=Textures\heat_and_attenuation_2dCheatC.tga Mips=Off MASKED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
#exec Texture Import File=Textures\heat_and_attenuation_2dCheatB.tga Mips=Off MASKED=1 UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP

#exec Texture Import File=Textures\Noise0_gauss.dds Mips=Off
#exec Texture Import File=Textures\Noise0_gauss_green.dds Mips=Off
#exec Texture Import File=Textures\Omni_Atten_1D.tga Mips=Off UCLAMPMODE=BORDER VCLAMPMODE=BORDER BORDERCOLOR=4294967295
#exec Texture Import File=Textures\Omni_Atten_2D.tga Mips=Off UCLAMPMODE=BORDER VCLAMPMODE=BORDER BORDERCOLOR=4294967295
#exec Texture Import File=Textures\distance_attenuation_8.tga Mips=Off UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP

#exec Texture Import File=Textures\impact01.dds Mips=Off UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP
#exec Texture Import File=Textures\gr_target.dds Mips=On UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP

var texture pThermalTexture_A;
var texture pThermalTexture_B;
var texture pThermalTexture_C;
var texture pThermalTexture_CheatA;
var texture pThermalTexture_CheatB;
var texture pThermalTexture_CheatC;

var texture pNoise0Gauss;
var texture pNoise0GaussGreen;
var texture pOmniAtten1D;
var texture pOmniAtten2D;
var texture pDistAtten8;

var texture pProjTexture;
var texture pThrowTexture;

struct SurfaceToSubTexLink
{
	var()	ESurfaceType	surfType;
	var()	INT				X;
	var()	INT				Y;
	var()	INT				Width;
	var()	INT				Height;
	var()	FLOAT			Scale;
};

struct AudioSaveData
{
	var Array<Sound>	CurrentAmbients;
	var Sound	CurrentMusic;
	var Array<Actor> AmbientPlayers;
	var Array<Sound> AmbientSounds;
	var float	VolumeTrack1;
	var float	VolumeTrack2;
	var float	VolumeTrack3;
	var int		CurrentReverb;
};

var AudioSaveData AudioData;

var Array<SurfaceToSubTexLink> ImpactSurfaceToSubTexLink;
var (WallDecal) Array<SurfaceToSubTexLink> FootStepSurfaceToSubTexLink;

struct ImpactEmitterSurfaceLink
{
	var()	ESurfaceType	surfType;
	var()	Class<Emitter>	emitterClass;
};

var Array<ImpactEmitterSurfaceLink> ImpactSurfaceToEmitterLink;

// Only used to keep a reference on UMeshAnimation during savegame
var Array<MeshAnimation> UsedMeshAnimation;

// Current time.
var           float	TimeSeconds;   // Time in seconds since level began play.
var transient int   Year;          // Year.
var transient int   Month;         // Month.
var transient int   Day;           // Day of month.
var transient int   DayOfWeek;     // Day of week.
var transient int   Hour;          // Hour.
var transient int   Minute;        // Minute.
var transient int   Second;        // Second.
var transient int   Millisecond;   // Millisecond.

//-----------------------------------------------------------------------------
// Text info about level.

var() localized string Title;
var()           string Author;		    // Who built it.
var() localized string LevelEnterText;  // Message to tell players when they enter.
var()           string LocalizedPkg;    // Package to look in for localizations.
var             PlayerController Pauser;          // If paused, name of person pausing the game.
var		LevelSummary Summary;
var           string VisibleGroups;		    // List of the group names which were checked when the level was last saved
//-----------------------------------------------------------------------------
// Flags affecting the level.

var() bool           bLonePlayer;     // No multiplayer coordination, i.e. for entranceways.
var bool             bBegunPlay;      // Whether gameplay has begun.
var bool             bPlayersOnly;    // Only update players.
var bool             bHighDetailMode; // Client high-detail mode.
var bool			 bDropDetail;	  // frame rate is below DesiredFrameRate, so drop high detail actors
var bool			 bAggressiveLOD;  // frame rate is well below DesiredFrameRate, so make LOD more aggressive
var bool             bStartup;        // Starting gameplay.
var	bool			 bPathsRebuilt;	  // True if path network is valid

// for saving DareAudio stuff
var	bool			 m_bInLaserMicSession;
var	bool			 m_bInMenu;

//-----------------------------------------------------------------------------
// Legend - used for saving the viewport camera positions
var() vector  CameraLocationDynamic;
var() vector  CameraLocationTop;
var() vector  CameraLocationFront;
var() vector  CameraLocationSide;
var() rotator CameraRotationDynamic;


//-----------------------------------------------------------------------------
// Miscellaneous information.

var() float Brightness;
var texture DefaultTexture;
var texture WhiteSquareTexture;
var texture LargeVertex;
var transient enum ELevelAction
{
	LEVACT_None,
	LEVACT_Loading,
	LEVACT_Saving,
	LEVACT_Connecting,
	LEVACT_Precaching
} LevelAction;

//-----------------------------------------------------------------------------
// Renderer Management.
var() bool bNeverPrecache;

//-----------------------------------------------------------------------------
// Networking.

var string ComputerName;  // Machine's name according to the OS.
var string EngineVersion; // Engine version.
var string MinNetVersion; // Min engine version that is net compatible.

//-----------------------------------------------------------------------------
// Gameplay rules

var GameInfo Game;

//-----------------------------------------------------------------------------
// Navigation point and Pawn lists (chained using nextNavigationPoint and nextPawn).

var const NavigationPoint NavigationPointList;
var const Controller ControllerList;

var const NavigationPoint ValidAttackPoints[10];
var const NavigationPoint ValidCoverPoints[30];

var       NavigationPoint CurrentAttackPoint;
var		  Controller	  CurrentController;	//used for visibility purpose

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
var const float m_dT;
var() bool			 bIsStartMenu;     // the map is the start menu
var   bool	 		bIsInGameMenu;
var bool			 stepOneFrame;

var EVariable		 VarObject;

var  Actor		ChangedActorsList;		// keep track of 'changed' actors within a map - AI will use this to notice dead bodies, broken machinery, etc.

var ERumble			Rumble;
var(SoundMap) string		SoundMapName;		   //Name of the sound map associated to this level
var(SoundMap) bool		    UseDefaultSoundMap;	   //The default sound map as the same name as the level
var()		  bool			DownloadedMap;

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


//-----------------------------------------------------------------------------
// Functions.

//
// Return the URL of this level on the local machine.
//
native function string GetLocalURL();

//
// Return the URL of this level, which may possibly
// exist on a remote machine.
//
native function string GetAddressURL();

native(1599) final function AddImpact(vector location, rotator rotation, bool footStep, bool invert, int decalIndex);

//
// ensure the DefaultPhysicsVolume class is loaded.
//
function ThisIsNeverExecuted()
{
	local DefaultPhysicsVolume P;
	P = None;
}


/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	// perform garbage collection of objects (not done during gameplay)
	ConsoleCommand("OBJ GARBAGE");
	Super.Reset();
}


function RumbleShake(float Duration, float Strenth)
{
	if (Rumble != None)
		Rumble.Shake(Duration, Strenth);
}

function RumbleVibrate(float Duration, float Strenth)
{
	if (Rumble != None)
		Rumble.Vibrate(Duration, Strenth);
}

//----------------------------------------[David Kalina - 3 Jul 2001]-----
// 
// Description
//		Adds a changed actor to the ChangedActorsList.
//		Simple interface so any actor can add itself.
//		TODO:  Check for duplication?
// 
// Input
//		changedActor : 
//		type : 
//
//------------------------------------------------------------------------
function AddChange(Actor changedActor, EChangeType type)
{
	changedActor.ChangeType = type;
	changedActor.AddChangedActor();
}


//---------------------------------------[David Kalina - 10 Oct 2001]-----
// 
// Description
//		Remove an actor specified from the Changed Actors list.
// 
//------------------------------------------------------------------------

function RemoveChange(Actor changedActor)
{
	//changedActor.ChangeType = CHANGE_None;
	changedActor.RemoveChangedActor();
}


//---------------------------------------------------[Frederic Blais]-----
// 
// 
//------------------------------------------------------------------------
event PostBeginPlay()
{
	local string			ClassName,temp;
	local class<EVariable>	VarObjectClassName;
	local class<ELevelInfo>	ELevInfClassName;
local int i;
    
	Super.PostBeginPlay();


	//check the level name
    temp = GetCurrentMapName();


    if (InStr(temp, ".") > 0)
    {
        temp = Left(temp, InStr(temp, "."));
    }
       
	if (UseDefaultSoundMap)
		SoundMapName = temp;

	ClassName = "EchelonPattern.V" $ temp;

	//load the the specific variable class
	VarObjectClassName = class<EVariable>(DynamicLoadObject(ClassName, class'Class'));

    //log("Variable ClassName : "$ClassName);

	//spawn variable class
	if (VarObjectClassName != None)
		VarObject = spawn(VarObjectClassName,self);
//	else
//		Log(self$" Variable class for the level could not be spawned");

	if (Game.UseRumble)
	{
		Rumble = new class'ERumble';
		if (Rumble == None)
			Log("Cant create ERumble actor");
	}
}

defaultproperties
{
    pThermalTexture_A=Texture'heat_and_attenuation_2dA'
    pThermalTexture_B=Texture'heat_and_attenuation_2dB'
    pThermalTexture_C=Texture'heat_and_attenuation_2dC'
    pThermalTexture_CheatA=Texture'heat_and_attenuation_2dCheatA'
    pThermalTexture_CheatB=Texture'heat_and_attenuation_2dCheatB'
    pThermalTexture_CheatC=Texture'heat_and_attenuation_2dCheatC'
    pNoise0Gauss=Texture'Noise0_gauss'
    pNoise0GaussGreen=Texture'Noise0_gauss_green'
    pOmniAtten1D=Texture'Omni_Atten_1D'
    pOmniAtten2D=Texture'Omni_Atten_2D'
    pDistAtten8=Texture'distance_attenuation_8'
    pProjTexture=Texture'impact01'
    pThrowTexture=Texture'gr_target'
    Title="Untitled"
    VisibleGroups="None"
    bHighDetailMode=true
    Brightness=1.000000
    DefaultTexture=Texture'DefaultTexture'
    WhiteSquareTexture=Texture'WhiteSquareTexture'
    LargeVertex=Texture'LargeVertex'
    UseDefaultSoundMap=true
    bWorldGeometry=true
    bBlockPlayers=true
    bBlockActors=true
    bBlockProj=true
    bBlockBullet=true
    bBlockCamera=true
    bBlockNPCShot=true
    bBlockNPCVision=true
    bHiddenEd=true
	EngineVersion="Enhanced" // Joshua - Enhanced version identifer
}