class EPCGameOptions extends Object
            config(USER)
			native;

//Video
var config BYTE     ShadowLevel;         //0 = Low, 1 = Medium, 2 = High
var config BYTE     ShadowResolution;    //0 = Low, 1 = Medium, 2 = High, 3 = Very High
var config String   Resolution;             
var config BYTE     Brightness;			 // Values from 0-100
var config BYTE     Gamma;				 // Values from 0-100, Joshua - Ubisoft mislabeled this as Gamma, it actually controls Contrast in SplinterCell.ini
var config BYTE		EffectsQuality;		 //0 = Low, 1 = Medium, 2 = High, 3 = Very High

var config BYTE		GraphicsCaps;		 //		HW Pixel Shader		HW Vertex Shader	HW Shadow Buffer
										 // 0 =	No					No					No
										 // 1 =	Yes					Yes					No
										 // 2 =	Yes					Yes					Yes
var config BYTE		VidMem;				 // 0 =	32 MB Frame Buffer
										 // 1 =	64 MB Frame Buffer
										 // 2 =	128+ MB Frame Buffer
var config BYTE AntiAliasing;

//Sound
var config BYTE AmbiantVolume;           // Values from 0-100
var config BYTE VoicesVolume;            // Values from 0-100
var config BYTE MusicVolume;             // Values from 0-100
var config BYTE SFXVolume;               // Values from 0-100
var config BYTE  AudioVirt;              // 0 = Low, 1 = Medium, 2 = High
var config BOOL  Sound3DAcc;
var config BOOL  EAX;
var config BOOL  EAX_Capable;

var BYTE RTAmbiantVolume;                // Values from 0-100
var BYTE RTVoicesVolume;                 // Values from 0-100
var BYTE RTMusicVolume;                  // Values from 0-100
var BYTE RTSFXVolume;                    // Values from 0-100

//Controls
var config BOOL InvertMouse;
var config BOOL FireEquipGun;
var config BYTE MouseSensitivity;        // Values from 0-100


//clauzon to fix flicker bug when pressing reset to default
var bool   bResolutionChanged;
var String oldResolution;
var BYTE   oldEffectsQuality;		     //0 = Low, 1 = Medium, 2 = High, 3 = Very High
var BYTE   oldShadowResolution;		     //0 = Low, 1 = Medium, 2 = High, 3 = Very High
var BYTE   oldAntiAliasing;

//We can call this make the engine update it's values according to what is set in this class
native(4016) final function UpdateEngineSettings(optional bool Sound);

//=========================================
// ResetGraphicsToDefault: Reset the video options, use default.ini value
//=========================================
function ResetGraphicsToDefault()
{
	ResetConfig("AnimatedGeometry");	
	ResetConfig("ShadowLevel");			
	ResetConfig("ShadowResolution");		
    ResetConfig("Resolution");
	ResetConfig("Brightness");
	ResetConfig("Gamma");
	ResetConfig("EffectsQuality");
	ResetConfig("AntiAliasing");
}	

//=========================================
// ResetGameToDefault: Reset the game options, use default.ini value
//=========================================
function ResetSoundToDefault()
{
	ResetConfig("AmbiantVolume");	
	ResetConfig("VoicesVolume");	
	ResetConfig("MusicVolume");		
    ResetConfig("SFXVolume");
	ResetConfig("AudioVirt");		
	ResetConfig("Sound3DAcc");		
	ResetConfig("EAX");	    
    
}

//=========================================
// ResetControlsToDefault: Reset the game options, use default.ini value
//=========================================
function ResetControlsToDefault()
{
	ResetConfig("InvertMouse");
	ResetConfig("FireEquipGun");
	ResetConfig("MouseSensitivity");
}
