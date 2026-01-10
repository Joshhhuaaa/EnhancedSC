//=============================================================================
// ParticleEmitter: Base class for sub- emitters.
//
// make sure to keep structs in sync in UnParticleSystem.h
//=============================================================================

class ParticleEmitter extends Object
	abstract
	editinlinenew
	native;

enum EBlendMode
{
	BM_MODULATE,
	BM_MODULATE2X,
	BM_MODULATE4X,
	BM_ADD,
	BM_ADDSIGNED,
	BM_ADDSIGNED2X,
	BM_SUBTRACT,
	BM_ADDSMOOTH,
	BM_BLENDDIFFUSEALPHA,
	BM_BLENDTEXTUREALPHA,
	BM_BLENDFACTORALPHA,
	BM_BLENDTEXTUREALPHAPM,
	BM_BLENDCURRENTALPHA,
	BM_PREMODULATE,
	BM_MODULATEALPHA_ADDCOLOR,
	BM_MODULATEINVALPHA_ADDCOLOR,
	BM_MODULATEINVCOLOR_ADDALPHA,
	BM_HACK
};

enum EParticleDrawStyle
{
	PTDS_Regular,
	PTDS_AlphaBlend,
	PTDS_Modulated,
	PTDS_Translucent,
	PTDS_AlphaModulate_MightNotFogCorrectly,
	PTDS_Darken,
	PTDS_Brighten
};

enum EParticleCoordinateSystem
{
	PTCS_Independent,
	PTCS_Relative,
	PTCS_Absolute
};

enum EParticleRotationSource
{
	PTRS_None,
	PTRS_Actor,
	PTRS_Offset,
	PTRS_Normal
};

enum EParticleVelocityDirection
{
	PTVD_None,
	PTVD_StartPositionAndOwner,
	PTVD_OwnerAndStartPosition,
	PTVD_AddRadial
};

enum EParticleStartLocationShape
{
	PTLS_Box,
	PTLS_Sphere,
	PTLS_Polar
};

enum EParticleEffectAxis
{
	PTEA_NegativeX,
	PTEA_PositiveZ
};

struct ParticleTimeScale
{
	var () float	RelativeTime;		// always in range [0..1]
	var () float	RelativeSize;
};

struct ParticleColorScale
{
	var () float	RelativeTime;		// always in range [0..1]
	var () color	Color;
};


struct Particle
{
	var vector	Location;
	var vector	OldLocation;
	var vector	Velocity;
	var vector	StartSize;
	var vector	SpinsPerSecond;
	var vector	StartSpin;
	var vector	Size;
	var vector  StartLocation;
	var vector  ColorMultiplier;
	var color	Color;
	var float	Time;
	var float	MaxLifetime;
	var float	Mass;
	var int		HitCount;
	var int		Flags;
	var int		Subdivision;
};

var (Acceleration)	vector						Acceleration;

var (Collision)		bool						UseCollision;
var (Collision)		vector						ExtentMultiplier;
var (Collision)		rangevector					DampingFactorRange;
var (Collision)		bool						UseCollisionPlanes;
var (Collision)		array<plane>				CollisionPlanes;
var	(Collision)		bool						UseMaxCollisions;
var (Collision)		range						MaxCollisions;
var (Collision)		int							SpawnFromOtherEmitter;
var (Collision)		int							SpawnAmount;
var (Collision)		rangevector					SpawnedVelocityScaleRange;
var (Collision)		bool						UseSpawnedVelocityScale;
var (Collision)		float						CollisionSoundProbability;

var (Sound)			Sound 						CollisionSound;

var (Color)			bool						UseColorScale;
var (Color)			array<ParticleColorScale>	ColorScale;
var (Color)			float						ColorScaleRepeats;
var (Color)			rangevector					ColorMultiplierRange;
var (Color)			bool						ModulateColorByLighting;
var (Color)			float						LightingAttenuationFactor;
var notextexport	color						AverageLightingColor;

var (Fading)		plane						FadeOutFactor;
var (Fading)		float						FadeOutStartTime;
var (Fading)		bool						FadeOut;
var (Fading)		plane						FadeInFactor;
var (Fading)		float						FadeInEndTime;
var (Fading)		bool						FadeIn;

var (Force)			bool						UseActorForces;

var (General)		EParticleCoordinateSystem	CoordinateSystem;
var (General)		int							MaxParticles;
var (General)		bool						ResetAfterChange;
var (General)		EParticleEffectAxis			EffectAxis;
var (General)		bool						OnlyVisibleInThermalVisionFallback;

var (Local)			bool						RespawnDeadParticles;
var (Local)			bool						AutoDestroy;
var (Local)			bool						AutoReset;
var (Local)			bool						Disabled;
var (Local)			bool						DisableFogging;
var (Local)			range						AutoResetTimeRange;
var (Local)			string						Name;

var (Location)		vector						StartLocationOffset;
var (Location)		rangevector					StartLocationRange;
var (Location)		int							AddLocationFromOtherEmitter;
var (Location)		EParticleStartLocationShape StartLocationShape;
var (Location)		range						SphereRadiusRange;
var (Location)		rangevector					StartLocationPolarRange;

var (Mass)			range						StartMassRange;

var (Rendering)		int							AlphaRef;
var (Rendering)		bool						AlphaTest;
var (Rendering)		bool						AcceptsProjectors;
var (Rendering)		bool						ZTest;
var (Rendering)		bool						ZWrite;

var (Rotation)		EParticleRotationSource		UseRotationFrom;
var (Rotation)		bool						SpinParticles;
var (Rotation)		rotator						RotationOffset;
var (Rotation)		vector						SpinCCWorCW;
var (Rotation)		rangevector					SpinsPerSecondRange;
var (Rotation)		rangevector					StartSpinRange;
var (Rotation)		bool						DampRotation;
var (Rotation)		rangevector					RotationDampingFactorRange;
var (Rotation)		vector						RotationNormal;

var (Size)			bool						UseSizeScale;
var (Size)			bool						UseRegularSizeScale;
var (Size)			array<ParticleTimeScale>	SizeScale;
var (Size)			float						SizeScaleRepeats;
var (Size)			rangevector					StartSizeRange;
var (Size)			bool						UniformSize;

var (Spawning)		float						ParticlesPerSecond;
var (Spawning)		float						InitialParticlesPerSecond;
var (Spawning)		bool						AutomaticInitialSpawning;

var (Texture)		EParticleDrawStyle			DrawStyle;
var (Texture)		texture						Texture;
var (Texture)		EParticleDrawStyle			ThermalVisionFallbackDrawStyle;
var (Texture)		texture						ThermalVisionFallbackTexture;
var (Texture)		int							TextureUSubdivisions;
var (Texture)		int							TextureVSubdivisions;
var (Texture)		bool						BlendBetweenSubdivisions;
var	(Texture)		bool						UseSubdivisionScale;
var (Texture)		array<float>				SubdivisionScale;
var (Texture)		int							SubdivisionStart;
var (Texture)		int							SubdivisionEnd;
var (Texture)		bool						UseRandomSubdivision;

var (Tick)			float						SecondsBeforeInactive;
var (Tick)			float						MinSquaredVelocity;

var	(Time)			range						InitialTimeRange;
var (Time)			range						LifetimeRange;
var (Time)			range						InitialDelayRange;

var (Velocity)		rangevector					StartVelocityRange;
var (Velocity)		range						StartVelocityRadialRange;
var (Velocity)		vector						MaxAbsVelocity;
var (Velocity)		rangevector					VelocityLossRange;
var (Velocity)		int							AddVelocityFromOtherEmitter;
var (Velocity)		rangevector					AddVelocityMultiplierRange;
var (Velocity)		EParticleVelocityDirection	GetVelocityDirectionFrom;

var (Warmup)		float						WarmupTicksPerSecond;
var (Warmup)		float						RelativeWarmupTime;

var (Glow)			Color				        GlowScale;
var (Glow)			bool				        IsGlowing;

var notextexport emitter			Owner;
var	notextexport bool				Initialized;
var notextexport bool				Inactive;
var notextexport float				InactiveTime;
var notextexport array<Particle>	Particles;
var notextexport int				ParticleIndex;			// index into circular list of particles
var notextexport int				LivingParticles;		// real active particles
var notextexport int				ActiveParticles;		// currently active particles
var notextexport float				PPSFraction;			// used to keep track of fractional PPTick
var notextexport box				BoundingBox;

var notextexport vector				RealExtentMultiplier;
var	notextexport bool				RealDisableFogging;
var notextexport bool				AllParticlesDead;
var notextexport bool				WarmedUp;
var	notextexport int				OtherIndex;
var notextexport float				InitialDelay;
var notextexport vector				GlobalOffset;
var notextexport float				TimeTillReset;
var notextexport int				PS2Data;
var notextexport int				MaxActiveParticles;
var notextexport int				CurrentCollisionSoundIndex;
var notextexport float				MaxSizeScale;
var notextexport int				KillPending;

native function SpawnParticle(int Amount);

defaultproperties
{
    ExtentMultiplier=(X=1.000000,Y=1.000000,Z=1.000000)
    DampingFactorRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
    SpawnFromOtherEmitter=-1
    ColorMultiplierRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
    LightingAttenuationFactor=1.000000
    FadeOutFactor=(W=1.000000,X=1.000000,Y=1.000000,Z=1.000000)
    FadeInFactor=(W=1.000000,X=1.000000,Y=1.000000,Z=1.000000)
    MaxParticles=10
    RespawnDeadParticles=True
    AutoDestroy=True
    AddLocationFromOtherEmitter=-1
    StartMassRange=(Min=1.000000,Max=1.000000)
    AlphaTest=True
    ZTest=True
    SpinCCWorCW=(X=0.500000,Y=0.500000,Z=0.500000)
    UseRegularSizeScale=True
    StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
    AutomaticInitialSpawning=True
    DrawStyle=PTDS_Translucent
    Texture=Texture'S_Emitter'
    LifetimeRange=(Min=4.000000,Max=4.000000)
    AddVelocityFromOtherEmitter=-1
    AddVelocityMultiplierRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
    GlowScale=(R=255,G=255,B=255,A=255)
}