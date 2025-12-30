//=============================================================================
// Actor: The base class of all actors.
// Actor is the base class of all gameplay objects.  
// A large number of properties, behaviors and interfaces are implemented in Actor, including:
//
// -	Display 
// -	Animation
// -	Physics and world interaction
// -	Making sounds
// -	Networking properties
// -	Actor creation and destruction
// -	Triggering and timers
// -	Actor iterator functions
// -	Message broadcasting
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Actor extends Object
	abstract
	native;

// Imported data (during full rebuild).
#exec Texture Import File=Textures\S_Actor.pcx Name=S_Actor Mips=Off MASKED=1 NOCONSOLE




// Flags.
var			  const bool	bStatic;			// Does not move or change over time. Don't let L.D.s change this - screws up net play
var(Advanced)		bool	bHidden;			// Is hidden during gameplay.
var(Advanced) const bool	bNoDelete;			// Cannot be deleted during play.
var					bool	bAnimFinished;		// Unlooped animation sequence has finished.
var			  const	bool	bDeleteMe;			// About to be deleted.
var transient const bool	bTicked;			// Actor has been updated.
var					bool	bDynamicLight;		// Temporarily treat this as a dynamic light.
var					bool	bTimerLoop;			// Timer loops (else is one-shot).
var			  const	bool	bAlwaysTick;		// Update even when players-only.
var(Advanced)		bool    bHighDetail;		// Only show up on high-detail.
var(Advanced)		bool	bStasis;			// In StandAlone games, turn off if not in a recently rendered zone turned off if  bStasis  and physics = PHYS_None or PHYS_Rotating.
var					bool	bTrailerSameRotation; // If PHYS_Trailer and true, have same rotation as owner.
var					bool	bTrailerPrePivot;	// If PHYS_Trailer and true, offset from owner by PrePivot.
var					bool	bWorldGeometry;		// Collision and Physics treats this actor as world geometry
var(Display)		bool    bAcceptsProjectors;	// Projectors can project onto this actor
var(ShadowProjector) bool	bDontUseFrustum;
var					bool	bOrientOnSlope;		// when landing, orient base on slope of floor
var(ShadowProjector) bool	bHiddenButCastShadow;
var(ShadowProjector) bool	bResortLightByDistance;
var(ShadowProjector) bool	bForceShowReflection;
var(ShadowProjector) bool	bForceGlowPassThrough;
var(ShadowProjector) bool	bForceThisActorDrawLater;
var(ShadowProjector) float	fZOffsetAdjust;
var(ShadowProjector) byte	GlassAmbientColor;
var(ShadowProjector) float	Zbias;
var(ShadowProjector) bool	bRenderObjectInGF2Only;

// Priority Parameters
// Actor's current physics mode.
var(Movement) const enum EPhysics
{
	PHYS_None,
	PHYS_Walking,
	PHYS_Falling,
	PHYS_Flying,
	PHYS_Rotating,
	PHYS_Projectile,
	PHYS_Interpolating,
	PHYS_MovingBrush,
	PHYS_Trailer,
	PHYS_RootMotion,
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dchabot (25 mai 2001)
// * Purpose : 
// ***********************************************************************************************
	PHYS_Linear,
	PHYS_Fence,
// ***********************************************************************************************
// * END UBI MODIF 
// * dchabot (25 mai 2001)
// ***********************************************************************************************
} Physics;

// Drawing effect.
var(Display) const enum EDrawType
{
	DT_None,
	DT_Sprite,
	DT_Mesh,
	DT_Brush,
	DT_RopeSprite,
	DT_VerticalSprite,
	DT_Terraform,
	DT_SpriteAnimOnce,
	DT_StaticMesh,
	DT_DrawType,
	DT_Particle, 
	DT_AntiPortal,
	DT_Rain,
} DrawType;

// Shadow projector tuning static meshes tuning parameters
var(ShadowProjector) const enum EShadowReceiveType
{
	STR_None,
	STR_Mesh,
	STR_BSP,
} ShadowReceiveType;

var(ShadowProjector) const enum EShadowCastType
{
	STC_None,
	STC_MeshAndBSP,
	STC_BSP,
} ShadowCastType;


var			float			LastRenderTime;	// last time this actor was rendered.
var(Events) name			Tag;			// Actor's tag name.

// Execution and timer variables.
var				float       TimerRate;		// Timer event, 0 = no timer.
var		const	float       TimerCounter;	// Counts up until it reaches TimerRate.
var(Advanced)	float		LifeSpan;		// How old the object lives before dying, 0 = forever.

var transient MeshInstance MeshInstance;	// Mesh instance.
var AnimInfo AnimInfo;

// Owner.
var         const Actor   Owner;			// Owner actor.
var(Object) name InitialState;
var(Object) name Group;

//-----------------------------------------------------------------------------
// Structures.

// Identifies a unique convex volume in the world.
struct PointRegion
{
	var ZoneInfo Zone;       // Zone.
	var int      iLeaf;      // Bsp leaf.
	var byte     ZoneNumber; // Zone number.
};

//-----------------------------------------------------------------------------
// Major actor properties.

// Scriptable.
var       const LevelInfo Level;         // Level this actor is on.
var transient const Level XLevel;        // Level object.
var(Events) name          Event;         // The event this actor causes.
var Pawn                  Instigator;    // Pawn responsible for damage caused by this actor.
var(Sound) sound          AmbientPlaySound;  // Ambient sound effect.
var(Sound) sound          AmbientStopSound;  // Ambient sound effect.
var(Sound) array<ZoneInfo> 	m_ListOfZoneInfo;      	// Play the sounds only if the object is NOT in one of those zone
var(Sound) bool         	m_bPlayIfSameZone;        	// Play the sounds only if the object is in the same zone
var(Sound) bool         	m_bIfDirectLineOfSight;   	// Play the sounds only if we have a direct line of sight

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
var bool		      bInAmbientRange;// Are we within the radius?
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

var const Actor           Base;          // Actor we're standing on.
var const PointRegion     Region;        // Region this actor is in.
var transient array<int>  Leaves;		 // BSP leaves this actor is in.

// Internal.
var const float           LatentFloat;   // Internal latent function use.
var const array<Actor>    Touching;		 // List of touching actors.
var const actor           Deleted;       // Next actor in just-deleted chain.

// Internal tags.
var const native int CollisionTag, LightingTag, ActorTag;

// The actor's position and rotation.
var const	PhysicsVolume	PhysicsVolume;	// physics volume this actor is currently in
var(Movement) const vector	Location;		// Actor's location; use Move to set.
var(Movement) const rotator Rotation;		// Rotation.
var(Movement) vector		Velocity;		// Velocity.
var			  vector        Acceleration;	// Acceleration.

// Attachment related variables
var(Movement)	name	AttachTag;
var const array<Actor>  Attached;			// array of actors attached to this actor.
var const vector		RelativeLocation;	// location relative to base/bone (valid if base exists)
var const rotator		RelativeRotation;	// rotation relative to base/bone (valid if base exists)
var const name			AttachmentBone;		// name of bone to which actor is attached (if attached to center of base, =='')

// Projectors
var const array<ProjectorRenderInfo> Projectors;// Projected textures on this actor

//-----------------------------------------------------------------------------
// Display properties.

var(Display) Material		Texture;			// Sprite texture.if DrawType = DT_Sprite
var(Display) mesh			Mesh;				// Mesh if DrawType = DT_Mesh.
var(Display) const StaticMesh		StaticMesh;			// StaticMesh if DrawType = DT_StaticMesh
var StaticMeshInstance		StaticMeshInstance; // Contains per-instance static mesh data, like static lighting data.
var const export model		Brush;				// Brush if DrawType = DT_Brush.
var(Display) const float	DrawScale;			// Scaling factor, 1.0 = normal size.
var(Display) const vector	DrawScale3D;		// Scaling vector, (1.0,1.0,1.0) = normal size.
var			 vector			PrePivot;			// Offset from box center for drawing.
var(Display) array<Material> Skins;				// Multiple skin support - not replicated.
var(Display) byte			AmbientGlow;		// Ambient brightness, or 255 = pulsing.
var(Display) ConvexVolume	AntiPortal;

// Style for rendering sprites, meshes.
var(Display) enum ERenderStyle
{
	STY_None,
	STY_Normal,
	STY_Masked,
	STY_Translucent,
	STY_Modulated, 
	STY_Alpha,
	STY_Particle
} Style;

// Display.
var(Display)  array<Actor> DontAffectEchelonLighting;
var(Display)  array<Actor> ForcedLightsHack;
var(Display)  bool      bUnlit;					// Lights don't affect actor.
var(Display)  bool      bShadowCast;			// Casts static shadows.
var(Display)  bool		bStaticLighting;		// Uses raytraced lighting.
var(Display)  bool      bDontAffectEchelonLighting;

var(Display)  bool bJustVisibleNight;
var(Display)  bool bJustVisibleHeat;

// Advanced.
var			  bool		bHurtEntry;				// keep HurtRadius from being reentrant
var(Advanced) bool		bCollideWhenPlacing;	// This actor collides with the world when placing.
var			  bool		bTravel;				// Actor is capable of travelling among servers.
var(Advanced) bool		bMovable;				// Actor can be moved.
var(Events)	  bool		bLocalGameEvent;		// this event should be saved as a local saved game event
var(Events)	  bool		bTravelGameEvent;		// this event should travel across levels as a saved game event
var			  bool		bPendingDelete;			// set when actor is about to be deleted (since endstate and other functions called 
												// during deletion process before bDeleteMe is set).
//-----------------------------------------------------------------------------
// Sound.

// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************
var				bool			bAttachViaSkel;
var(Sound)		bool			StopSoundsWhenKilled;	 // Should we kill the sounds from an actor when it's destroyed
var				bool			CurrentFoot;
var(Surface)	bool			bClimbable;
var(Surface)	bool			bNoSplitJump;
var(Surface)	bool			bNoBTW;
var(Surface)	bool			bBatmanHack;
var(Surface)	bool			bNPCBulletGoTru;
var(Surface)	bool			bPlayerBulletGoTru;
var(Sound)		float			SoundRadiusSaturation;	 // Radius of full volume for a sound, it decrases when farther
var(Sound)		float			SoundRadiusBackground;	 // Radius of full volume for a sound, it decrases when farther
var(Surface)	ESurfaceType	SurfaceType;
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

enum EQuickLoadType
{
	EQLoad_None,
	EQLoad_Slot1,
	EQLoad_Slot2,
	EQLoad_Slot3,
	EQLoad_MapStart 
};

// Sound slots for actors.
enum ESoundSlot
{
	SLOT_SFX,
	SLOT_Barks,
	SLOT_Voice,
	SLOT_Interface,
	SLOT_Music,
	SLOT_Ambient,
	SLOT_Fisher,
	SLOT_Lambert
};


// ***********************************************************************************************
// * UBI MODIF Transient variables deleted
// ***********************************************************************************************

//-----------------------------------------------------------------------------
// Collision.

// Collision size.
var(Collision) const float CollisionRadius;		// Radius of collision cyllinder.
var(Collision) const float CollisionHeight;		// Half-height cyllinder.

var(CollPrim) const	StaticMesh	CollisionPrimitive;

// Collision flags.
var(Collision)	const	bool	bCollideActors;
var(Collision)	bool			bCollideWorld;

// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (21 janv. 2002)
// ***********************************************************************************************
var(Collision)	bool			bStaticMeshCylColl;
var(Collision)	bool			bCollideSB;

var(CollisionFlag)	bool		bBlockPlayers;
var(CollisionFlag)	bool		bBlockActors;
var(CollisionFlag)	bool		bBlockProj;
var(CollisionFlag)	bool		bBlockBullet;
var(CollisionFlag)	bool		bBlockCamera;
var(CollisionFlag)	bool		bBlockNPCShot;
var(CollisionFlag)	bool		bBlockNPCVision;
var(CollisionFlag)	bool		bBlockPeeking;

var(CollPrimFlag)	bool		bCPBlockPlayers;
var(CollPrimFlag)	bool		bCPBlockActors;
var(CollPrimFlag)	bool		bCPBlockProj;
var(CollPrimFlag)	bool		bCPBlockBullet;
var(CollPrimFlag)	bool		bCPBlockCamera;
var(CollPrimFlag)	bool		bCPBlockNPCShot;
var(CollPrimFlag)	bool		bCPBlockNPCVision;

// Lighting.
var(Lighting) bool	     bSpecialLit;	// Only affects special-lit surfaces.
var(Lighting) bool	     bCorona;       // Light uses Skin as a corona.
var transient bool		 bLightChanged;	// Recalculate this light's lighting now.

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

//-----------------------------------------------------------------------------
// Lighting.

// Light modulation.
var(Lighting) enum ELightType
{
	LT_None,
	LT_Steady,
	LT_Pulse,
	LT_Blink,
	LT_Flicker,
	LT_Strobe,
	LT_BackdropLight,
	LT_SubtlePulse,
	LT_TexturePaletteOnce,
	LT_TexturePaletteLoop
} LightType;

var ELightType ELightTypeInitial;
var bool RestoreInitialLightType;
var bool DisableIfOppositeShadowMode;

// Spatial light effect to use.
var(Lighting) enum ELightEffect
{
	LE_None,
	LE_TorchWaver,
	LE_FireWaver,
	LE_WateryShimmer,
	LE_Searchlight,
	LE_SlowWave,
	LE_FastWave,
	LE_CloudCast,
	LE_StaticSpot,
	LE_Shock,
	LE_Disco,
	LE_Warp,
	LE_Spotlight,
	LE_NonIncidence,
	LE_Shell,
	LE_OmniBumpMap,
	LE_Interference,
	LE_Cylinder,
	LE_Rotor,
	LE_Unused,
	LE_Sunlight,
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * yletourneau (01 Oct 2001)
// * Purpose : <Unspecified>
// ***********************************************************************************************
/*	LE_EOceanSunLight,
	LE_ESpotShadowBump,
	LE_ESpotShadow,
	LE_ESpotBump,
	LE_ESpotDistAtten,
	LE_ESpotShadowDistAtten,
	LE_ESpotBumpDistAtten,
	LE_ESpot,
	LE_EOmni,
	LE_EOmniBump,
	LE_EOmniAtten,
	LE_EOmniBumpAtten,
	LE_ESpotOrthoShadowBump,
	LE_ESpotOrthoShadow,
	LE_ESpotOrthoBump,
	LE_ESpotOrthoDistAtten,
	LE_ESpotOrthoShadowDistAtten,
	LE_ESpotOrthoBumpDistAtten,
	LE_ESpotOrtho,*/
	LE_EOceanSunLight,
	LE_EUnused01,//LE_ESpotShadowBump,
	LE_ESpotShadow,
	LE_EUnused02,//LE_ESpotBump,
	LE_EUnused03,//LE_ESpotDistAtten,
	LE_ESpotShadowDistAtten,
	LE_EUnused04,//LE_ESpotBumpDistAtten,
	LE_ESpot,
	LE_EUnused05,//LE_EOmni,
	LE_EUnused06,//LE_EOmniBump,
	LE_EOmniAtten,
	LE_EUnused07,//LE_EOmniBumpAtten,
	LE_EUnused08,//LE_ESpotOrthoShadowBump,
	LE_ESpotOrthoShadow,
	LE_EUnused09,//LE_ESpotOrthoBump,
	LE_EUnused10,//LE_ESpotOrthoDistAtten,
	LE_ESpotOrthoShadowDistAtten,
	LE_EUnused11,//LE_ESpotOrthoBumpDistAtten,
	LE_ESpotOrtho,
// ***********************************************************************************************
// * END UBI MODIF 
// * yletourneau (01 Oct 2001)
// ***********************************************************************************************
} LightEffect;

// Lighting info.
var(LightColor) byte
	LightBrightness,
	LightHue,
	LightSaturation;

// Light properties.
var(Lighting) byte
	LightRadius,
	LightPeriod,
	LightPhase,
	LightCone,
	VolumeBrightness,
	VolumeRadius,
	VolumeFog;

// ***********************************************************************************************
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * Purpose : Echelon-specific Variables
// ***********************************************************************************************
// ***********************************************************************************************

struct RenderLightInfo
{
	var INT	     type;
	var Vector	 Origin;
	var Vector	 Direction;
	var Vector	 Diffuse;
	var FLOAT    Range;
	var FLOAT	 ConstantAttenuation;
	var FLOAT	 LinearAttenuation;
	var FLOAT	 QuadraticAttenuation;
	var FLOAT	 Theta;
	var FLOAT	 Phi;
	var FLOAT	 Falloff;
	var INT 	 BindToTexture;
	var Actor	 LightActor;		// To extract other relevant info
};

struct CacheSurfaceInfo
{
	var int SurfaceIndex;
	var int	Zone;
	var array<INT> Nodes;
};

var notextexport array<int>  LightLeaves;					// BSP leaves this light actor affects.
var notextexport array<int>  LightZones;						// BSP zones this light actor affects.
var notextexport array<CacheSurfaceInfo>  LightNodes;		// BSP surfaces/nodes this light actor affects.
var bool		bLightCachingValid;				// Are the previous arrays valid ?

var(EchelonHeat) bool	bSideFadeEffect;
var(Display) bool		bJustInGlow;     // Just render in  glow.
var(Display) bool       bGlowDisplay;     //just display for the glow
var(Display) bool       bInvalidateLightCachingIfMoved;     //for moving flashlights

var(LightBeamVolumeProperties) bool				UsesSpotLightBeam;
var(LightBeamVolumeProperties) const StaticMesh	VolumeLightMesh;	
var(LightBeamVolumeProperties) float 			VolumeTotalFalloffScale;
var(LightBeamVolumeProperties) byte				VolumeInitialAlpha;

var(EchelonLighting) byte
	AmbientBrightness,
	AmbientHue,
	AmbientSaturation;

var(EchelonLighting) float 
	TurnOffDistance,
	TurnOffDistancePercentageFadeIn,
	MinDistance,
	MaxDistance,
	GF2LightBeamMaxDistance,
	SpotHeight,
	SpotWidth;

var(EchelonLighting) ELightBeamMaterial
	SpotProjectedMaterial;

var transient int FrustumPointer;

var(EchelonHeat) float
	HeatOpacity,
	HeatRadius,
	HeatIntensity;

var(EchelonModifier) editinline EModifier
	Modifier;

////////////////////////////////////////////////////////////
/// Other Echelon specific vars 
////////////////////////////////////////////////////////////

var(Debug) enum EChangeType
{
	CHANGE_None,
	CHANGE_Footprints,
	CHANGE_DisabledTurret,
	CHANGE_DisabledCamera,
	CHANGE_BrokenObject,
	CHANGE_BrokenDoor,
	CHANGE_Object,
	CHANGE_AirCamera,
	CHANGE_ScorchMark,
	CHANGE_BloodStain,
	CHANGE_Flare,
	CHANGE_LightTurnedOff,
	CHANGE_LightShotOut,
	CHANGE_Unconscious,
	CHANGE_Bleeding,
	CHANGE_Dead,
	CHANGE_Fire,
	CHANGE_WallMine,
	CHANGE_Grenade
} ChangeType;

var Actor nextChangedActor;				// next pointer in ChangedActorsList

enum EVolumeSize
{
	EVS_Normal,
	EVS_Small,
	EVS_Tiny,
	EVS_Minute,
};

// possible general transition types for designers to specify
enum ETransitionType
{
	TRAN_None,
	TRAN_Investigate,
	TRAN_Alert,
	TRAN_Surprised
};

const NUMVOLUMESIZE = 4;
const NUMCAMMODE = 27;

enum ECamMode
{
	ECM_Walking,
	ECM_WalkingCr,
	ECM_FirstPerson,
	ECM_FirstPersonCr,
	ECM_Grab,
	ECM_GrabFP,
	ECM_Carry,
	ECM_CarryCr,
	ECM_Throw,
	ECM_ThrowCr,
	ECM_Sniping,
	ECM_HSphere,
	ECM_FSphere,
	ECM_HOH,
	ECM_HOHFU,
	ECM_HOHFP,
	ECM_BTW,
	ECM_BTWPeakLeft,
	ECM_BTWPeakRight,
	ECM_BTWLeftFP,
	ECM_BTWRightFP,
	ECM_Rapel,
	ECM_RapelFP,
	ECM_DoorPeekRight,
	ECM_DoorPeekLeft,
	ECM_SplitJump,
	ECM_SplitJumpFP,
};

struct ECamParam
{
	var()	vector	offset[NUMVOLUMESIZE];
	var()	float	Distance[NUMVOLUMESIZE];
	var()	int		minYaw;
	var()	int		maxYaw;
	var()	int		minPitch;
	var()	int		maxPitch;
	var()	float	Damping;
	var()	float	interSpeed;
	var()	float	collInterSpeed;
	var()	float	targetXYSpeed;
	var()	float	targetZSpeed;
	var()	float	twigX;
	var()	float	twigZ;
	var()	float	biasCut;
	var()	float	biasSlope;
	var()	float	offsetSpeed;

	// usage
	var()	int		useAngles;
	var()	int		alignPawn;
	var()	int		usePitchCurve;
	var()	int		useCollTarget;
	var()	int		useCylColl;
	var()	int		useColl;
	var()	int		useTwig;
	var()	int		useCamFlag;
};

enum eLookAtType
{
	LANORMAL,
	LAHOH
};

enum eAimAtType
{
	AAFULL,
	AAVERT,
	AAHOH,
	AABTW
};

enum eClimbingHand
{
	CHNONE,
	CHLEFT,
	CHRIGHT
};

// Phys Trailer
var				Vector		TrailerOffset;		// Local offset used with PHYS_Trailer and bTrailerPrePivot

// Actor IsA flag
var const	bool	bIsSoftBody;
var const	bool	bIsRope;
var const	bool	bIsPawn;
var	const	bool	bIsPlayerPawn;
var	const	bool	bIsNPCPawn;
var const	bool	bIsMover;
var const	bool	bIsTrapMover;
var const	bool	bIsVolume;
var const	bool	bIsNavPoint;
var const	bool	bIsNavMarker;
var			bool	bIsEchelonLight;
var const	bool	bIsGamePlayObject;
var	const	bool	bIsProjectile;
var const   bool	bIsProjector;
var	const	bool	bIsCollisionMesh;

var	const	bool	bIsTouchable;
var	const	bool	bIsNPCRelevant;
var	const	bool	bIsPlayerRelevant;
var	const	bool	bRenderLast;
var			bool	bVisibilityCalculated;		// if in this tick, the visibility has already been calculated

enum AIEventType
{
  	 AI_NONE,
	 AI_INVESTIGATE,
	 AI_ATTACK,

	 AI_EXTERN_EVENTS,    //Extern stimulis

     AI_SEE_NPC,
	 AI_SEE_CHANGED_ACTOR,
	 AI_SEE_INTERROGATION,
     AI_SEE_PLAYER_INVESTIGATE,
	 AI_HEAR_SOMETHING,
	 AI_SMELL_SOMETHING,
	 AI_SHOT_JUST_MISSED,
     AI_TAKE_DAMAGE,
	 AI_SEE_PLAYER_SURPRISED,
	 AI_SEE_PLAYER_ALERT,

	 AI_INTERN_EVENTS,

     AI_GOAL_COMPLETE,
     AI_GOAL_FAILURE,
	 AI_DEAD,
	 AI_UNCONSCIOUS,
	 AI_REVIVED,
	 AI_GRABBED,
	 AI_RELEASED,	 
     AI_LOST_PLAYER,
	 AI_LOST_PLAYER_AFTER,
	 AI_SEE_PLAYER_AGAIN,
	 AI_UPDATE_SEARCH,
	 AI_SHOT_BLOCKED,
	 AI_STUCK,
	 AI_NEARLY_DEAD,
	 AI_WEAPON_INEFFECTIVE,
	 AI_LOW_AMMO,
	 AI_NO_AMMO,
	 AI_PLAYER_FAR,
	 AI_PLAYER_CLOSE,
	 AI_PLAYER_VERYCLOSE,
	 AI_PLAYER_DEAD,
	 AI_UPDATE_STRATEGY_REQUEST,
	 AI_ALARM_ON_PRIMARY,
	 AI_ALARM_ON_SECONDARY,
	 AI_ALARM_UPDATE_POSITION,
	 AI_ALARM_OFF,
	 AI_INTERROGATION_QUERY_NPC,
	 AI_INTERROGATION_QUERY_SAM,
	 AI_FORCED_RETINAL_SCAN,
	 AI_OUT_OF_DEFEND_RADIUS,
	 AI_PATROL_TIMEOUT,
	 AI_GET_DOWN,
	 AI_COVERPOINT_TOUCHED,
	 AI_COVER_LOST_PLAYER,
	 AI_GROUP_LAST_MEMBER,
	 AI_GROUP_LOST_PLAYER,
	 AI_GROUP_SEE_PLAYER_AGAIN,
	 AI_MASTER_OUT_OF_RADIUS,
     AI_MASTER_DEAD,
	 AI_HEAR_RICOCHET,

	 AI_COMMUNICATION_EVENTS,

	 AI_ARE_YOU_OK,
	 AI_LET_HIM_GO,
	 AI_INVESTIGATE_GREETINGS	 

};



// Reaction Animation Groups -- AI Controller specifies one or many animations to play for each of the following:

enum eReactionAnimGroup
{
	REACT_None,
	REACT_CuriousNoise,
	REACT_AlarmingNoise,
	REACT_DistantThreat,
	REACT_ImmediateThreat,
	REACT_CuriousObject,
	REACT_MovingObject,
	REACT_BrokenObject,
	REACT_SeeUnknownPerson,
	REACT_SeeBody,
	REACT_SeeGrenade,
	REACT_SeeWallMine,
	REACT_SeeLightsOut,
	REACT_Blinded,
	REACT_SearchFailed,
	REACT_SeeInterrogation,
	REACT_Surprised,
	REACT_AboutToDie,
	REACT_TempA,
	REACT_TempB,
	REACT_TempC,
	REACT_TempD
};

//AI Broadcast
enum BroadCastType
{
	BC_SELF_DIRECTED,
	BC_INFO_BARK_AWARE,
	BC_INFO_BARK_ALERT,
	BC_BACKUP_BARK_INVESTIGATE,
	BC_BACKUP_BARK_ATTACK,
	BC_INFO_RADIO_AWARE,
	BC_INFO_RADIO_ALERT,
	BC_BACKUP_RADIO_INVESTIGATE,
	BC_BACKUP_RADIO_ATTACK,
	BC_INFO_BARK_COVER
};

// Visibility flags
enum VisibilityRating
{	
	VIS_Invisible,
	VIS_Barely,
	VIS_Partially,
	VIS_Mostly,
	VIS_Fully
};

var float				VisibilityFactor;			// base visibility (0..255) --> use VisibilityTableLookup to get discrete version

enum eInvCategory
{
    CAT_NONE,
	CAT_MAINGUN,
	CAT_GADGETS,
	CAT_ITEMS,
	CAT_INFO,
};

// For echelon noise propagation system
enum NoiseType
{
	NOISE_None,
	NOISE_LightFootstep,
	NOISE_HeavyFootstep,
	NOISE_DoorOpening,
	NOISE_Object_Falling,
	NOISE_Object_Breaking,
	NOISE_GrenadeWarning,
	NOISE_Alarm,
	NOISE_WallMineTick,
	NOISE_InfoBarkAware,
	NOISE_InfoBarkAlert,
	NOISE_DogBarking,
	NOISE_BackupBarkInvestigate,
    NOISE_TurretGunfire,
	NOISE_Scream,
	NOISE_DyingGasp,
	NOISE_TakeCover,
	NOISE_BackUpBarkAttack,
	NOISE_Explosion,
	NOISE_Gunfire,
	NOISE_Ricochet
};

var(Sound) float		AmbientPlayRadius;
var(Sound) float		AmbientStopRadius;

// struct for representing noise radii for a given surface
struct SurfaceNoiseInfo
{
	var()	float	WalkRadius;
	var()	float	JogRadius;
	var()	float	CrouchWalkRadius;
	var()	float	CrouchJogRadius;
	var()	float	LandingRadius;
	var()	float	QuietLandingRadius;
};

struct AIEvent
{
	var AIEventType   EventType;
	var Vector		  EventLocation;
	var Actor	 	  EventTarget;
	var Actor		  EventActor;
	var BroadCastType EventBroadcastType;
	var	float         ReceivedTime;
	var Controller    Instigator;
	var NoiseType	  EventNoiseType;
};

var(Interaction) class<EInteractObject> InteractionClass;
var EInteractObject Interaction;

enum MoveFlags
{
	MOVE_NotSpecified,
	MOVE_WalkRelaxed,
	MOVE_WalkNormal,
	MOVE_WalkAlert,
	MOVE_JogAlert,
	MOVE_CrouchWalk,
	MOVE_CrouchJog,
	MOVE_Search,
	MOVE_Snipe,
	MOVE_JogNoWeapon,
	MOVE_Sit,
	MOVE_DesignerWalk
};

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


//-----------------------------------------------------------------------------
// Physics.

// Physics properties.
var(Movement) float       Mass;				// Mass of this actor.
var(Movement) rotator	  RotationRate;		// Change in rotation per second.
var(Movement) rotator     DesiredRotation;	// Physics will smoothly rotate actor to this rotation if bRotateToDesired.
var			  Actor		  PendingTouch;		// Actor touched during move which wants to add an effect after the movement completes 
var       const vector    ColLocation;		// Actor's old location one move ago. Only for debugging
var       const rotator   ColRotation;		// Actor's old rotation one move ago. Only for debugging

const MAXSTEPHEIGHT = 35.0; // Maximum step height walkable by pawns

//-----------------------------------------------------------------------------
// Forces.

enum EForceType
{
	FT_None,
	FT_DragAlong,
};

// Options.
var(Movement) bool        bBounce;           // Bounces when hits ground fast.
var(Movement) bool		  bFixedRotationDir; // Fixed direction of rotation.
var(Movement) bool		  bRotateToDesired;  // Rotate to DesiredRotation.
var           bool        bInterpolating;    // Performing interpolating.
var			  const bool  bJustTeleported;   // Used by engine physics - not valid for scripts.

//Editing flags
var(Advanced) bool        bHiddenEd;     // Is hidden during editing.
var(Advanced) bool        bHiddenEdGroup;// Is hidden by the group brower.
var(Advanced) bool        bDirectional;  // Actor shows direction arrow during editing.
var const bool            bSelected;     // Selected in UnrealEd.
var(Advanced) bool        bEdShouldSnap; // Snap to grid in editor.
var transient bool        bEdSnap;       // Should snap to grid in UnrealEd.
var transient const bool  bTempEditor;   // Internal UnrealEd.
var	const bool			  bObsolete;	 // actor is obsolete - warn level designers to remove it
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (15 janv. 2002)
// ***********************************************************************************************
var(Collision) bool				  bPathColliding;// this actor should collide (if bWorldGeometry && bBlockActors is true) during path building (ignored if bStatic is true, as actor will always collide during path building)
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************
var transient bool		  bPathTemp;	 // Internal/path building

var	bool				  bScriptInitialized; // set to prevent re-initializing of actors spawned during level startup

var transient bool		  bRenderAtEndOfFrame;

var(Lighting) bool		  bAffectOwnZoneOnly;

var(Display)  int		  iRenderPriority;

var(Display)  bool		  HideInLowQuality;

//-----------------------------------------------------------------------------
// Enums.

// Travelling from server to server.
enum ETravelType
{
	TRAVEL_Absolute,	// Absolute URL.
	TRAVEL_Partial,		// Partial (carry name, reset server).
	TRAVEL_Relative,	// Relative URL.
};


//-----------------------------------------------------------------------------
// natives.

// Execute a console command in the context of the current level and game engine.
native function string ConsoleCommand(string Command);

//=============================================================================
// Actor error handling.

// Handle an error and kill this one actor.
native(233) final function Error(coerce string S);

//=============================================================================
// General functions.

native(1180) final function SkipPresent(int numSkip);
native(1181) final function FlushMouseMoveMessages();

// Latent functions.
native(256) final latent function Sleep(float Seconds);

// Collision.
native(262) final function SetCollision(optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers);
native(283) final function bool SetCollisionSize(float NewRadius, float NewHeight);
native final function SetDrawScale(float NewScale);
native final function SetDrawScale3D(vector NewScale3D);
native final function SetDrawType(EDrawType NewDrawType);

// Movement.
native(266) final function bool Move(vector Delta);
native(267) final function bool SetLocation(vector NewLocation);
native(299) final function bool SetRotation(rotator NewRotation);

// SetRelativeRotation() sets the rotation relative to the actor's base
native final function bool SetRelativeRotation(rotator NewRotation);
native final function bool SetRelativeLocation(vector NewLocation);

native(3969) final function bool MoveSmooth(vector Delta);
native(3971) final function AutonomousPhysics(float DeltaSeconds);

// Relations.
native(298) final function SetBase(actor NewBase, optional vector NewFloor);
native(1144) final function FindBase();
native(272) final function SetOwner(actor NewOwner);

//=============================================================================
// Animation.

// Animation functions.
native(259) final function PlayAnim(name Sequence, optional float Rate, optional float TweenTime, optional int Channel, optional bool bBackward, optional bool bContinueAtFrame);
native(260) final function LoopAnim(name Sequence, optional float Rate, optional float TweenTime, optional int Channel, optional bool bBackward, optional bool bContinueAtFrame);
native(294) final function TweenAnim(name Sequence, float Time, optional int Channel);
native(282) final function bool IsAnimating(optional int Channel);
native(261) final latent function FinishAnim(optional int Channel);
native(263) final function bool HasAnim(name Sequence);
native final function StopAnimating();
native final function bool IsTweening(int Channel);
native(1260) final function bool IsAnimBackward(optional int Channel);

// Animation notifications.
event AnimEnd(int Channel);
native final function EnableChannelNotify (int Channel, int Switch);
native final function int GetNotifyChannel();

// Skeletal animation.
native final function LinkSkelAnim(MeshAnimation Anim);
native final function AnimBlendParams(int Stage, optional float BlendAlpha, optional float InTime, optional float OutTime, optional name BoneName);
native final function AnimBlendToAlpha(int Stage, float TargetAlpha, float TimeInterval);

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dchabot (4 oct. 2001)
// * Purpose : Added params
// ***********************************************************************************************
native final function coords  GetBoneCoords(name BoneName, optional bool ForceRefresh);
native final function		  SetIKFade(float FadeIn, float FadeOut);
// ***********************************************************************************************
// * END UBI MODIF 
// * dchabot (4 oct. 2001)
// ***********************************************************************************************
native final function rotator GetBoneRotation(name BoneName, optional int Space);

native final function vector  GetRootLocation();
native final function rotator GetRootRotation();
native final function vector  GetRootLocationDelta();
native final function rotator GetRootRotationDelta();

native final function bool  AttachToBone(actor Attachment, name BoneName);
native final function bool  DetachFromBone(actor Attachment);

native final function LockRootMotion(int Lock, optional bool bUseRootRotation);
native final function SetBoneScale(int Slot, optional float BoneScale, optional name BoneName);

native final function SetBoneDirection(name BoneName, rotator BoneTurn, optional vector BoneTrans, optional float Alpha);
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dchabot (9 oct. 2001)
// * Purpose : 
// ***********************************************************************************************
native final function SetBoneLocation(name BoneName, optional vector BoneTrans, optional float FadeIn, optional float FadeOut, optional float Alpha);
native final function SetBoneRotation(name BoneName, optional rotator BoneTurn, optional int Space, optional float FadeIn, optional float FadeOut, optional float Alpha);
// ***********************************************************************************************
// * END UBI MODIF 
// * dchabot (9 oct. 2001)
// ***********************************************************************************************
native final function GetAnimParams(int Channel, out name OutSeqName, out float OutAnimFrame, out float OutAnimRate);
native final function bool AnimIsInGroup(int Channel, name GroupName);  


//=========================================================================
// Physics.

// Physics control.
native(301) final latent function FinishInterpolation();
native(3970) final function SetPhysics(EPhysics newPhysics);

// ***********************************************************************************************
// * BEGIN UBI MODIF Adionne (12 Nov 2002)
// ***********************************************************************************************

native(4014) static final function Canvas GetCanvas();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


//=========================================================================
// Engine notification functions.

//
// Major notifications.
//
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
event Destroyed()
{
	// Must destroy the interaction
	ResetInteraction();

	// Must remove from ChangedActorsList here
	RemoveChangedActor();
}

native(1419) final function string GetCurrentMapName();

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************
event GainedChild(Actor Other);
event LostChild(Actor Other);
event Tick(float DeltaTime);


//
// Triggers.
//
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
event Trigger(Actor Other, Pawn EventInstigator, optional name InTag);
event UnTrigger(Actor Other, Pawn EventInstigator, optional name InTag);
event HitFakeBackDrop();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************
event BeginEvent();
event EndEvent();

//
// Physics & world interaction.
//
event Timer();
event HitWall(vector HitNormal, actor HitWall);
event Falling();
event Landed(vector HitNormal);
event ZoneChange(ZoneInfo NewZone);
event PhysicsVolumeChange(PhysicsVolume NewVolume);
event Touch(Actor Other);
event PostTouch(Actor Other); // called for PendingTouch actor after physics completes
event UnTouch(Actor Other);
event Bump(Actor Other, optional int Pill);
event BaseChange();
event Attach(Actor Other);
event Detach(Actor Other);
event Actor SpecialHandling(Pawn Other);
event bool EncroachingOn(actor Other);
event EncroachedBy(actor Other);
event EndedRotation();			// called when rotation completes

event UsedBy(Pawn user); // called if this Actor was touching a Pawn who pressed Use

event FellOutOfWorld()
{
	SetPhysics(PHYS_None);
	Destroy();
}	

//
// Damage and kills.
//
event KilledBy(pawn EventInstigator);
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag);

native(1174) final function bool FindBulletExit(out vector HitLocation, out vector HitNormal, out Material HitMaterial, vector Momentum);
native(1229) final function rotator FindSlopeRotation(vector FloorNormal, rotator NewRotation);

function SpawnWallHit(Actor HitActor, vector HitLocation, vector HitNormal, Material HitMaterial);
event BulletWentTru(Actor Instigator, vector HitLocation, vector HitNormal, vector Momentum, Material HitMaterial)
{
	// Takes care of wallhit. No damage or momentum added
	Instigator.SpawnWallHit(self, HitLocation, HitNormal, HitMaterial);

	if (FindBulletExit(HitLocation, HitNormal, HitMaterial, Momentum))
		Instigator.SpawnWallHit(self, HitLocation, HitNormal, HitMaterial);
}
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

//
// Trace a line and see what it collides with first.
// Takes this actor's collision properties into account.
// Returns first hit actor, Level if hit level, or None if hit nothing.
//
native(277) final function Actor Trace
(
	out vector      HitLocation,
	out vector      HitNormal,
	vector          TraceEnd,
	optional vector TraceStart,
	optional bool   bTraceActors,
	optional vector Extent,
	optional out material Material,
	optional bool   bSkipNoBlocking,
	optional bool   bSkipPawn
);

// returns true if did not hit world geometry
native(548) final function bool FastTrace
(
	vector          TraceEnd,
	optional vector TraceStart
);

//
// Spawn an actor. Returns an actor of the specified class, not
// of class Actor (this is hardcoded in the compiler). Returns None
// if the actor could not be spawned (either the actor wouldn't fit in
// the specified location, or the actor list is full).
// Defaults to spawning at the spawner's location.
//
native(278) final function actor Spawn
(
	class<actor>      SpawnClass,
	optional actor	  SpawnOwner,
	optional name     SpawnTag,
	optional vector   SpawnLocation,
	optional rotator  SpawnRotation
);

//
// Destroy this actor. Returns true if destroyed, false if indestructable.
// Destruction is latent. It occurs at the end of the tick.
//
native(279) final function bool Destroy();

//=============================================================================
// Timing.

// Causes Timer() events every NewTimerRate seconds.
native(280) final function SetTimer(float NewTimerRate, bool bLoop);

//=============================================================================
// Sound functions.

// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************

/* Play a sound effect.
*/
native(264) final function bool PlaySound
(
	sound				Sound,
	optional ESoundSlot Slot
);

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

/* Get a sound duration.
*/
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (15 janv. 2002)
// ***********************************************************************************************
native(1600) final function float GetSoundDuration(sound Sound);
native(1604) final function float GetSoundPosition(sound Sound);
native(1605) final function SetVolumeLineValue(int Slot, float value);
native(1606) final function float GetVolumeLineValue(int Slot);
native(1601) final function bool IsPlaying(sound Sound);
native(1603) final function bool IsPlayingAnyActor(sound Sound);
native(1607) final function bool StopAllVoicesActor(optional bool DontStopNPC, optional bool bDontStopBarks);
native(1614) final function StopAllSoundsActor(bool bExceptAmbient);
native(1615) final function bool CanPlayMusic();
native(1608) final function StopAllSounds();
native(1609) final function AddSoundRequest(sound Sound, ESoundSlot Slot, float Fade);
native(1611) final function VerifyOcclusion();
native(1610) final function SetReverbEffect(int Effect);
native(1602) final function StopSound(sound Sound, optional float Fade);
native(1130) final function vector ToWorld(vector pos);
native(1131) final function vector ToWorldDir(vector pos);
native(1132) final function vector ToLocal(vector pos);
native(1133) final function vector ToLocalDir(vector pos);
native(2120) final function SetDASkinGlowIntensity(byte  _a, byte _r, byte _g, byte _b);
native(1616) final function float DistancePointToLine(vector Point, vector Start, vector End);
native(1617) final function AddOneVoice();
native(1618) final function PauseSound(optional bool bAllSounds);
native(1619) final function ResumeSound(optional bool bAllSounds);
native(1622) final function SetLaserMicSession(bool bSession);
native(1623) final function SetLaserLocked(bool bLocked);
native(1624) final function FlushRequests();
native(1625) final function StartFadeOut(float Time);
native(1626) final function bool IsGameOver();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

// ***********************************************************************************************
// * BEGIN UBI MODIF Adionne (21 Nov 2002)
// ***********************************************************************************************
native(4015) static final function EPCGameOptions GetGameOptions();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


//=============================================================================
// AI functions.

/* PlayerCanSeeMe returns true if any player (server) or the local player (standalone
or client) has a line of sight to actor's location.
*/
native(532) final function bool PlayerCanSeeMe();

// ***********************************************************************************************
// * BEGIN UBI MODIF - cgripeos May 6, 2002
// ***********************************************************************************************
native(3082) final function BYTE IsLocationInRainVolume(Vector _Location);
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************



//=============================================================================
// Regular engine functions.

// Teleportation.
event bool PreTeleport(Teleporter InTeleporter);
event PostTeleport(Teleporter OutTeleporter);

// Level state.
event BeginPlay();

//=============================================================================
// Iterator functions.

// Iterator functions for dealing with sets of actors.

/* AllActors() - avoid using AllActors() too often as it iterates through the whole actor list and is therefore slow
*/
native(304) final iterator function AllActors     (class<actor> BaseClass, out actor Actor, optional name MatchTag);

/* DynamicActors() only iterates through the non-static actors on the list (still relatively slow, bu
 much better than AllActors).  This should be used in most cases and replaces AllActors in most of 
 Epic's game code. 
*/
native(313) final iterator function DynamicActors     (class<actor> BaseClass, out actor Actor, optional name MatchTag);

/* ChildActors() returns all actors owned by this actor.  Slow like AllActors()
*/
native(305) final iterator function ChildActors   (class<actor> BaseClass, out actor Actor);

/* BasedActors() returns all actors based on the current actor (slow, like AllActors)
*/
native(306) final iterator function BasedActors   (class<actor> BaseClass, out actor Actor);

/* TouchingActors() returns all actors touching the current actor (fast)
*/
native(307) final iterator function TouchingActors(class<actor> BaseClass, out actor Actor);

/* TraceActors() return all actors along a traced line.  Reasonably fast (like any trace)
*/
native(309) final iterator function TraceActors   (class<actor> BaseClass, out actor Actor, out vector HitLoc, out vector HitNorm, vector End, optional vector Start, optional vector Extent);

/* RadiusActors() returns all actors within a give radius.  Slow like AllActors().  Use CollidingActors() or VisibleCollidingActors() instead if desired actor types are visible
(not bHidden) and in the collision hash (bCollideActors is true)
*/
native(310) final iterator function RadiusActors  (class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc);

/* VisibleActors() returns all visible actors within a radius.  Slow like AllActors().  Use VisibleCollidingActors() instead if desired actor types are 
in the collision hash (bCollideActors is true)
*/
native(311) final iterator function VisibleActors (class<actor> BaseClass, out actor Actor, optional float Radius, optional vector Loc);

/* VisibleCollidingActors() returns visible (not bHidden) colliding (bCollideActors == true) actors within a certain radius.
Much faster than AllActors() since it uses the collision hash
*/
native(312) final iterator function VisibleCollidingActors (class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc, optional bool bIgnoreHidden);

/* CollidingActors() returns colliding (bCollideActors == true) actors within a certain radius.
Much faster than AllActors() for reasonably small radii since it uses the collision hash
*/
native(321) final iterator function CollidingActors (class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc);

//=============================================================================
// Color functions
native(549) static final operator(20) color -     (color A, color B);
native(550) static final operator(16) color *     (float A, color B);
native(551) static final operator(20) color +     (color A, color B);
native(552) static final operator(16) color *     (color A, float B);

//=============================================================================
// Scripted Actor functions.

/* RenderOverlays()
called by player's hud to request drawing of actor specific overlays onto canvas
*/
function RenderOverlays(Canvas Canvas);
	
//
// Called immediately before gameplay begins.
//
event PreBeginPlay()
{
	ELightTypeInitial = LightType;
}

// Called immediately after gameplay begins.
//
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
event PostBeginPlay()
{
	if (InteractionClass != None)
		Interaction = Spawn(InteractionClass,self);

	// add any actors with initial change type to change list
	if (ChangeType > CHANGE_None) 
		Level.AddChange(self, ChangeType);
}
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

// Called after PostBeginPlay.
//
event SetInitialState()
{
	bScriptInitialized = true;
	if (InitialState!='')
		GotoState(InitialState);
	else
		GotoState('Auto');
}

/* HurtRadius()
 Hurt locally authoritative actors within the radius.
*/
final function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local Actor Victims;
	local float damageScale, dist;
	local vector dir;
	
	if (bHurtEntry)
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors(class 'Actor', Victims, DamageRadius, HitLocation)
	{
		if (Victims != self)
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir / dist; 
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius) / DamageRadius);
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator, 
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				dir,
				(damageScale * Momentum * dir),
				DamageType
);
		} 
	}
	bHurtEntry = false;
}

// Called by PlayerController when this actor becomes its ViewTarget.
//
function BecomeViewTarget();

// Returns the string representation of the name of an object without the package
// prefixes.
//
function String GetItemName(string FullName)
{
	local int pos;

	pos = InStr(FullName, ".");
	While (pos != -1)
	{
		FullName = Right(FullName, Len(FullName) - pos - 1);
		pos = InStr(FullName, ".");
	}

	return FullName;
}

// Returns the human readable string representation of an object.
//
// CHANGED function name from GetHumanName()
function String GetHumanReadableName()
{
	return GetItemName(string(class));
}

final function ReplaceText(out string Text, string Replace, string With)
{
	local int i;
	local string Input;
		
	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while (i != -1)
	{	
		Text = Text $ Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));	
		i = InStr(Input, Replace);
	}
	Text = Text $ Input;
}

// Get localized message string associated with this actor
static function string GetLocalString(optional int Switch)
{
	return "";
}

/* DisplayDebug()
list important actor variable on canvas.  HUD will call DisplayDebug() on the current ViewTarget when
the ShowDebug exec is used
*/
function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string T;
	local float XL;
	local int i;
	local Actor A;
	local name anim;
	local float frame, rate;

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.StrLen("TEST", XL, YL);
	YPos = YPos + YL;
	Canvas.SetPos(4, YPos);
	Canvas.SetDrawColor(255, 0, 0);
	T = GetItemName(string(self));
	if (bDeleteMe)
		T = T$" DELETED (bDeleteMe == true)";

	Canvas.DrawText(T, false);
	YPos += YL;
	Canvas.SetPos(4, YPos);
	Canvas.SetDrawColor(255, 255, 255);

	T = "Physics ";
	Switch (PHYSICS)
	{
		case PHYS_None: T = T$"None"; break;
		case PHYS_Walking: T = T$"Walking"; break;
		case PHYS_Falling: T = T$"Falling"; break;
		case PHYS_Flying: T = T$"Flying"; break;
		case PHYS_Rotating: T = T$"Rotating"; break;
		case PHYS_Projectile: T = T$"Projectile"; break;
		case PHYS_Interpolating: T = T$"Interpolating"; break;
		case PHYS_MovingBrush: T = T$"MovingBrush"; break;
		case PHYS_Trailer: T = T$"Trailer"; break;
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * ATurcotte (MTL) (12 Jul 2001)
// * Purpose : Add new physics
// ***********************************************************************************************
		case PHYS_Linear: T = T$"Linear"; break;
		case PHYS_Fence: T = T$"Fence"; break;
		case PHYS_RootMotion: T = T$"RootMotion"; break;
// ***********************************************************************************************
// * END UBI MODIF 
// * ATurcotte (MTL) (12 Jul 2001)
// ***********************************************************************************************
	}
	T = T$" in physicsvolume "$GetItemName(string(PhysicsVolume))$" on base "$GetItemName(string(Base));
	if (bBounce)
		T = T$" - will bounce";
	Canvas.DrawText(T, false);
	YPos += YL;
	Canvas.SetPos(4, YPos);

	Canvas.DrawText("Location: "$Location, false);
	YPos += YL;
	Canvas.SetPos(4, YPos);
	Canvas.DrawText("Rotation: "$Rotation, false);
	YPos += YL;
	Canvas.SetPos(4, YPos);
	Canvas.DrawText("Velocity: "$Velocity$" Speed "$VSize(Velocity), false);
	YPos += YL;
	Canvas.SetPos(4, YPos);
	Canvas.DrawText("Acceleration: "$Acceleration, false);
	YPos += YL;
	Canvas.SetPos(4, YPos);
	
	Canvas.SetDrawColor(255, 255, 0);
	Canvas.DrawText("Collision Radius "$CollisionRadius$" Height "$CollisionHeight);
	YPos += YL;
	Canvas.SetPos(4, YPos);

	Canvas.DrawText("Collides with Actors "$bCollideActors$", world "$bCollideWorld$", and target "$bBlockProj);
	YPos += YL;
	Canvas.SetPos(4, YPos);
// UBI MODIF
	Canvas.DrawText("Blocks Actors "$bBlockActors$", players "$bBlockPlayers$", camera "$bBlockCamera);
// END UBI MODIF
	YPos += YL;
	Canvas.SetPos(4, YPos);

	T = "Touching ";
	ForEach TouchingActors(class'Actor', A)
		T = T$GetItemName(string(A))$" ";
	if (T == "Touching ")
		T = "Touching nothing";
	Canvas.DrawText(T, false);
	YPos += YL;
	Canvas.SetPos(4, YPos);

	Canvas.SetDrawColor(0, 255, 0);
	T = "Rendered: ";
	Switch (Style)
	{
		case STY_None: T = T; break;
		case STY_Normal: T = T$"Normal"; break;
		case STY_Masked: T = T$"Masked"; break;
		case STY_Translucent: T = T$"Translucent"; break;
		case STY_Modulated: T = T$"Modulated"; break;
		case STY_Alpha: T = T$"Alpha"; break;
	}		

	Switch (DrawType)
	{
		case DT_None: T = T$" None"; break;
		case DT_Sprite: T = T$" Sprite "; break;
		case DT_Mesh: T = T$" Mesh "; break;
		case DT_Brush: T = T$" Brush "; break;
		case DT_RopeSprite: T = T$" RopeSprite "; break;
		case DT_VerticalSprite: T = T$" VerticalSprite "; break;
		case DT_Terraform: T = T$" Terraform "; break;
		case DT_SpriteAnimOnce: T = T$" SpriteAnimOnce "; break;
		case DT_StaticMesh: T = T$" StaticMesh "; break;
	}

	if (DrawType == DT_Mesh)
	{
		T = T$Mesh;
		if (Skins.length > 0)
		{
			T = T$" skins: ";
			for (i = 0; i < Skins.length; i++)
			{
				if (skins[i] == None)
					break;
				else
					T =T$skins[i]$", ";
			}
		}

		Canvas.DrawText(T, false);
		YPos += YL;
		Canvas.SetPos(4, YPos);
		
		// mesh animation
		GetAnimParams(0,Anim,frame,rate);
		T = "AnimSequence "$Anim$" Frame "$frame$" Rate "$rate;
	}
	else if ((DrawType == DT_Sprite) || (DrawType == DT_SpriteAnimOnce))
		T = T$Texture;
	else if (DrawType == DT_Brush)
		T = T$Brush;
		
	Canvas.DrawText(T, false);
	YPos += YL;
	Canvas.SetPos(4, YPos);
	
	Canvas.SetDrawColor(0, 255, 255);
	Canvas.DrawText("Tag: "$Tag$" Event: "$Event$" STATE: "$GetStateName(), false);
	YPos += YL;
	Canvas.SetPos(4, YPos);

	Canvas.DrawText("Instigator "$GetItemName(string(Instigator))$" Owner "$GetItemName(string(Owner)));
	YPos += YL;
	Canvas.SetPos(4, YPos);

	Canvas.DrawText("Timer: "$TimerCounter$" LifeSpan "$LifeSpan);
	YPos += YL;
	Canvas.SetPos(4, YPos);

	Canvas.DrawText("AmbientSound "$AmbientPlaySound);
	YPos += YL;
	Canvas.SetPos(4, YPos);
}

// NearSpot() returns true is spot is within collision cylinder
// FIXME - make intrinsic

final function bool NearSpot(vector Spot)
{
	local vector Dir;

	Dir = Location - Spot;
	
	if (abs(Dir.Z) > CollisionHeight)
		return false;

	Dir.Z = 0;
	return (VSize(Dir) <= CollisionRadius);
}

final function bool TouchingActor(Actor A)
{
	local vector Dir;

	Dir = Location - A.Location;
	
	if (abs(Dir.Z) > CollisionHeight + A.CollisionHeight)
		return false;

	Dir.Z = 0;
	return (VSize(Dir) <= CollisionRadius + A.CollisionRadius);
}


// returns true if shortest rotation direction is in the positive (clockwise) direction
// from A to B
function bool PlusDir(int A, int B)
{
	A = A & 65535;
	B = B & 65535;

	if (Abs(A - B) > 32768)
		return (A - B < 0);
	return (A - B > 0);
}

/* StartInterpolation()
when this function is called, the actor will start moving along an interpolation path
beginning at Dest
*/	
function StartInterpolation()
{
	GotoState('');
	SetCollision(True,false,false);
	bCollideWorld = false;
	bInterpolating = true;
	SetPhysics(PHYS_None);
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset();

/* 
Trigger an event
*/
event TriggerEvent(Name EventName, Actor Other, Pawn EventInstigator)
{
	// ***********************************************************************************************
	// * BEGIN UBI MODIF 
	// * dkalina (25 Sep 2001)
	// * Purpose : Patch so TriggerEvent calls will affect NavPoints
	// ***********************************************************************************************
	local Actor A;
	local NavigationPoint nav;

	if ((EventName == '') || (EventName == 'None'))
		return;

	ForEach DynamicActors(class 'Actor', A, EventName)
		A.Trigger(Other, EventInstigator, Tag);

	for (nav = Level.NavigationPointList; nav != none; nav = nav.nextNavigationPoint)
	{
		if (EventName == nav.Tag)
			nav.Trigger(Other, EventInstigator, Tag);
	}
	// ***********************************************************************************************
	// * END UBI MODIF 
	// * dkalina (25 Sep 2001)
	// ***********************************************************************************************

	// if triggered event is actor's event, check if it should be registered as persistent game event
	if ((EventName == Event) && (Level.Game != None))
	{
		if (bTravelGameEvent)
			Level.Game.AddTravelGameEvent(EventName);
		else if (bLocalGameEvent)		
			Level.Game.AddLocalGameEvent(EventName);
	}
}

/*
Untrigger an event
*/
function UntriggerEvent(Name EventName, Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if ((EventName == '') || (EventName == 'None'))
		return;

// UBI MODIF
	ForEach DynamicActors(class 'Actor', A, EventName)
		A.Untrigger(Other, EventInstigator, Tag);
// END UBI MODIF
}

function bool IsInVolume(Volume aVolume)
{
	local Volume V;
	
	ForEach TouchingActors(class'Volume',V)
		if (V == aVolume)
			return true;
	return false;
}
	 
function bool IsInPain()
{
	local PhysicsVolume V;

	ForEach TouchingActors(class'PhysicsVolume',V)
		if (V.bPainCausing && (V.DamagePerSec > 0))
			return true;
	return false;
}

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * Purpose : Echelon specifics Events and Functions
// ***********************************************************************************************

native(1501) final function int InterpolateRotatorValue(float Rate, int Source, int Target);
native(1125) final function rotator InterpolateRotator(float Alpha, rotator Source, rotator Target);

native(1231) final function SetStaticMesh(StaticMesh NewStaticMesh);
native(1232) final function SetCollisionPrim(StaticMesh NewCollPrim);
native(1233) final function vector GetVectorFrom(Rotator RotationDir, int ConeAngle);

//------------------------------------------------------------------------
// Description		
//		Temp while we do something else
//------------------------------------------------------------------------
event VisibilityRating VisibilityTableLookup(float BaseVisibility)
{
	if		(BaseVisibility >= Level.Game.VisFullyThreshold)		return VIS_Fully;
	else if (BaseVisibility > Level.Game.VisMostlyThreshold)		return VIS_Mostly;
	else if (BaseVisibility > Level.Game.VisPartiallyThreshold)		return VIS_Partially;
	else if (BaseVisibility > Level.Game.VisBarelyThreshold)		return VIS_Barely;
	else															return VIS_Invisible;
}

//------------------------------------------------------------------------
// Description		
//		By default, return full visibility for an actor
//------------------------------------------------------------------------
event VisibilityRating GetActorVisibility()
{
	return VIS_Fully;
}

//------------------------------------------------------------------------
// Description
//		Get Base Visibility Factor (0..255) for this Actor.
//------------------------------------------------------------------------
native(1203) final function float GetVisibilityFactor(optional bool bFullTest);

//------------------------------------------------------------------------
// Description		
//		Called from skeletal attachement moving
//------------------------------------------------------------------------
event AttachedMoved();

//---------------------------------------[David Kalina - 18 Dec 2000]-----
// 
// Description
//		TODO:  Move to Native??
//      Performs a linear interpolation (Lerp) on each float member of 
//      the source vector, given a target vector and an alpha value.
// 
// Input
//          _InterpolationResult : Return - interpolated vector
//          _InterpolationSource : Source Vector
//          _InterpolationTarget : Target Vector
//          _Alpha :               Interpolation Alpha (rate of inter.)
//
//------------------------------------------------------------------------
function Interpolate(out vector _vInterpolationResult, vector _vInterpolationSource, vector _vInterpolationTarget, float _rAlpha)
{
    _vInterpolationResult.X = Lerp(_rAlpha, _vInterpolationSource.X, _vInterpolationTarget.X);
    _vInterpolationResult.Y = Lerp(_rAlpha, _vInterpolationSource.Y, _vInterpolationTarget.Y);
    _vInterpolationResult.Z = Lerp(_rAlpha, _vInterpolationSource.Z, _vInterpolationTarget.Z);
} 

function Actor GetMatchingActor(Name matchTag)
{
	local Actor A;
	
	if (matchTag != '')
		foreach AllActors(class'Actor', A)
			if (A.Tag == matchTag)
				return A;
		
	return none;
}

// Get any actor BB
native(1405) final function int GetBoundingBox(out vector Min ,out vector Max, optional bool bGetCollPrim);

// Force end to sleep
native(1406) final function StopSleep();

// Adding native function for getting animation time (seconds) = frame rate * total frames
native(1507) final function float GetAnimTime(name Sequence);

//	Blending synchronization
native(1513) final function SynchAnim(name Sequence, int Channel, optional float TweenTime, optional float BlendAlpha, optional name BoneName, optional int TargetChannel, optional bool bBackward);

// Quick bsp trace like old Epic FastTrace
native(1240) final function bool FastTraceBsp(vector TraceEnd, optional vector TraceStart);

// Trace with pill tag retreival
native(1107) final function Actor TraceBone
(
	out int			PillTag,
	out vector		HitLocation,
	out vector		HitNormal,
	vector			TraceEnd,
	optional vector TraceStart,
	optional out material Material,
	optional bool   bRealFire
);

// Fast target check
native(1139) final function bool TraceTarget
(
	vector			TraceEnd,
	vector			TraceStart,
	actor			Target,
	optional bool	bTracePill,
	optional bool	bNPCVision,
	optional bool	bNPCShot
);

native(1105) final function bool FastPointCheck
(
	optional vector CenterPoint,
	optional vector Extent,
	optional bool   bTraceActors,
	optional bool   bTraceLevel,
	optional bool   bNoPawn
);

function ResetInteraction()
{
	//Reset owner interaction reference
	if (Interaction != None)
		Interaction.Destroy();
	Interaction = None;
}

// add to / remove from ChangedActorsList in LevelInfo
native(1514) final function AddChangedActor();
native(1515) final function RemoveChangedActor();

//----------------------------------------[David Kalina - 9 Jul 2001]-----
// 
// Description
//		Replaced old MakeNoise with Echelon-specific version
// Input
//		Radius : how far noise can travel
//		nType  : type of noise - used for AI response
//		ZThreshold : how far up/down the noise can reach
// 
//------------------------------------------------------------------------
native(512) final function MakeNoise(float Radius, optional NoiseType nType, optional float ZThreshold);

//------------------------------------------------------------------------
// Description		
//		Log wrapper that includes Name and StateName.
//		Only visible if LPATTERN is on.
//------------------------------------------------------------------------
function plog(coerce string S)
{
	log(Name $ " -- STATE:  " $ GetStateName() $ " -- " $ S,,LPATTERN);
}

//---------------------------------------[David Kalina - 24 Jan 2002]-----
// 
// Description
//		Return this objects relevant Interaction
//
//------------------------------------------------------------------------

function EInteractObject GetInteraction(Pawn InteractPawn)
{
	return Interaction;
}


// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

defaultproperties
{
    fZOffsetAdjust=1.000000
    Zbias=0.001000
    DrawType=DT_Sprite
    Texture=Texture'S_Actor'
    DrawScale=1.000000
    DrawScale3D=(X=1.000000,Y=1.000000,Z=1.000000)
    Style=STY_Normal
    bMovable=True
    SoundRadiusSaturation=200.000000
    SoundRadiusBackground=-1.000000
    CollisionRadius=22.000000
    CollisionHeight=22.000000
    bBlockPeeking=True
    RestoreInitialLightType=True
    bGlowDisplay=True
    VolumeTotalFalloffScale=1.000000
    VolumeInitialAlpha=255
    TurnOffDistance=5000.000000
    TurnOffDistancePercentageFadeIn=0.900000
    MinDistance=50.000000
    MaxDistance=1000.000000
    GF2LightBeamMaxDistance=-1.000000
    SpotHeight=45.000000
    SpotWidth=45.000000
    HeatOpacity=1.000000
    bIsTouchable=True
    bIsNPCRelevant=True
    bIsPlayerRelevant=True
    Mass=100.000000
    bJustTeleported=True
    iRenderPriority=64
}