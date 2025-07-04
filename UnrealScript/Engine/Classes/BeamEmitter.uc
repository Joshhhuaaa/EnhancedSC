//=============================================================================
// BeamEmitter: An Unreal Beam Particle Emitter.
//=============================================================================
class BeamEmitter extends ParticleEmitter
	native;


enum EBeamEndPointType
{
	PTEP_Velocity,
	PTEP_Distance,
	PTEP_Offset,
	PTEP_Actor,
	PTEP_TraceOffset,
	PTEP_OffsetAsAbsolute
};

struct ParticleBeamData
{
	var vector	Location;
	var float	t;
};

struct ParticleBeamEndPoint
{
	var () name			ActorTag;
	var () rangevector	Offset;
	var () float		Weight;
};

struct ParticleBeamScale
{
	var () vector		FrequencyScale;
	var () float		RelativeLength;
};

var (Beam)			range						BeamDistanceRange;	
var (Beam)			array<ParticleBeamEndPoint>	BeamEndPoints;
var (Beam)			EBeamEndPointType			DetermineEndPointBy;		
var (Beam)			float						BeamTextureUScale;
var (Beam)			float						BeamTextureVScale;
var (Beam)			int							RotatingSheets;

var (BeamNoise)		rangevector					LowFrequencyNoiseRange;
var (BeamNoise)		int							LowFrequencyPoints;
var (BeamNoise)		rangevector					HighFrequencyNoiseRange;
var (BeamNoise)		int							HighFrequencyPoints;
var (BeamNoise)		array<ParticleBeamScale>	LFScaleFactors;
var (BeamNoise)		array<ParticleBeamScale>	HFScaleFactors;
var (BeamNoise)		float						LFScaleRepeats;
var (BeamNoise)		float						HFScaleRepeats;
var (BeamNoise)		bool						UseHighFrequencyScale;
var (BeamNoise)		bool						UseLowFrequencyScale;
var (BeamNoise)		bool						NoiseDeterminesEndPoint;

var (BeamBranching) bool						UseBranching;
var (BeamBranching)	range						BranchProbability;
var (BeamBranching)	int							BranchEmitter;
var (BeamBranching) range						BranchSpawnAmountRange;
var (BeamBranching) bool						LinkupLifetime;

var		notextexport int							SheetsUsed;
var 	notextexport int							VerticesPerParticle;
var 	notextexport int							IndicesPerParticle;
var 	notextexport int							PrimitivesPerParticle;
var 	notextexport float						BeamValueSum;
var 	notextexport array<ParticleBeamData>		HFPoints;
var 	notextexport array<vector>				LFPoints;
var 	notextexport array<actor>				HitActors;

defaultproperties
{
    BeamTextureUScale=1.000000
    BeamTextureVScale=1.000000
    LowFrequencyPoints=3
    HighFrequencyPoints=10
    BranchEmitter=-1
}