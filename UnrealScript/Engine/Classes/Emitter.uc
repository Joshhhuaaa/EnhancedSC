//=============================================================================
// Emitter: An Unreal Emitter Actor.
//=============================================================================
class Emitter extends Actor
	native
	placeable;

#exec Texture Import File=Textures\S_Emitter.pcx  Name=S_Emitter Mips=Off MASKED=1 NOCONSOLE


var ()	export	editinline	array<ParticleEmitter>	Emitters;

var		(Global)	bool			AutoDestroy;
var		(Global)	bool			AutoReset;
var		(Global)	bool			DisableFogging;
var		(Global)	rangevector		GlobalOffsetRange;
var		(Global)	range			TimeTillResetRange;

var	transient		int					Initialized;
var	notextexport	box					BoundingBox;
var	notextexport	float				EmitterRadius;
var	notextexport	float				EmitterHeight;
var	notextexport	bool				ActorForcesEnabled;
var	notextexport	vector				GlobalOffset;
var	notextexport	float				TimeTillReset;
var	notextexport	bool				UseParticleProjectors;
var	transient		ParticleMaterial	ParticleMaterial;
var	notextexport	bool				DeleteParticleEmitters;

// shutdown the emitter and make it auto-destroy when the last active particle dies.
native function Kill();

function PostBeginPlay()
{
	local int i;
	for( i=0; i<Emitters.Length; i++ )
	{
		if( Emitters[i] != None )
		{
			Emitters[i].InitialTimeRange.Min = Min(Emitters[i].InitialTimeRange.Min, Emitters[i].LifetimeRange.Min);
			Emitters[i].InitialTimeRange.Max = Min(Emitters[i].InitialTimeRange.Max, Emitters[i].LifetimeRange.Max);
		}
	}

	Super.PostBeginPlay();
}

function Trigger( Actor Other, Pawn EventInstigator, optional name InTag ) // UBI MODIF
{
	local int i;
	for( i=0; i<Emitters.Length; i++ )
	{
		if( Emitters[i] != None )
			Emitters[i].Disabled = !Emitters[i].Disabled;
	}
}

defaultproperties
{
    AutoDestroy=true
    DrawType=DT_Particle
    Texture=Texture'S_Emitter'
    Style=STY_Particle
    bUnlit=true
}