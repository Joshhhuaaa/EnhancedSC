//=============================================================================
// Emitter: An Unreal Spark Particle Emitter.
//=============================================================================
class SparkEmitter extends ParticleEmitter
	native;

struct ParticleSparkData
{
	var	float	TimeBeforeVisible;
	var float	TimeBetweenSegments;
	var vector	StartLocation;
	var vector	StartVelocity;
};

var (Spark)			range						LineSegmentsRange;
var (Spark)			range						TimeBeforeVisibleRange;
var (Spark)			range						TimeBetweenSegmentsRange;

var notextexport array<ParticleSparkData>	SparkData;
var notextexport vertexbuffer				VertexBuffer;
var notextexport indexbuffer					IndexBuffer;
var notextexport int							NumSegments;
var notextexport int							VerticesPerParticle;
var notextexport int							IndicesPerParticle;
var notextexport int							PrimitivesPerParticle;

defaultproperties
{
    LineSegmentsRange=(Min=0.000000,Max=0.000000) // (Min=5.000000,Max=5.000000)
}