//=============================================================================
// Emitter: An Unreal Mesh Particle Emitter.
//=============================================================================
class MeshEmitter extends ParticleEmitter
	native;


var (Mesh)		staticmesh		StaticMesh;
var (Mesh)		bool			UseMeshBlendMode;
var (Mesh)		bool			RenderTwoSided;
var (Mesh)		bool			UseParticleColor;

var	notextexport vector			MeshExtent;

defaultproperties
{
    UseMeshBlendMode=True
}