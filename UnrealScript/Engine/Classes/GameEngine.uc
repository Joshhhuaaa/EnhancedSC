//=============================================================================
// GameEngine: The game subsystem.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class GameEngine extends Engine
	native
	noexport
	transient;

// URL structure.
struct URL
{
	var string			Protocol,	// Protocol, i.e. "unreal" or "http".
						Host;		// Optional hostname, i.e. "204.157.115.40" or "unreal.epicgames.com", blank if local.
	var int				Port;		// Optional host port.
	var string			Map;		// Map name, i.e. "SkyCity", default is "Index".
	var array<string>	Op;			// Options.
	var string			Portal;		// Portal to enter through, default is "".
	var bool			Valid;
};
 
var Level			GLevel,
					GEntry;
var URL				LastURL;

var bool			FramePresentPending;


//clauzon Loading progress bar:
var transient Texture		ProgressTexture;
var transient Texture		SplashTexture1;
var transient Texture		SplashTexture2;

var string		CurrentProfile;

var array<int> CRCLookup;			//used to validate save games

// JFP: Gameflow data.
var int				d_iGameflowState;

