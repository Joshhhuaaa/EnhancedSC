//=============================================================================
// BrushBuilder: Base class of UnrealEd brush builders.
//
// Tips for writing brush builders:
//
// * Always validate the user-specified and call BadParameters function
//   if anything is wrong, instead of actually building geometry.
//   If you build an invalid brush due to bad user parameters, you'll
//   cause an extraordinary amount of pain for the poor user.
//
// * When generating polygons with more than 3 vertices, BE SURE all the
//   polygon's vertices are coplanar!  Out-of-plane polygons will cause
//   geometry to be corrupted.
//=============================================================================
class BrushBuilder
	extends Object
	abstract
	native;

var(BrushBuilder) string BitmapFilename;
var(BrushBuilder) string ToolTip;

// Internal state, not accessible to script.
struct BuilderPoly
{
	var array<int> VertexIndices;
	var int Direction;
	var name Item;
	var int PolyFlags;
};
var private array<vector> Vertices;
var private array<BuilderPoly> Polys;
var private name Group;
var private bool MergeCoplanars;

// Native support.
native function BeginBrush(bool MergeCoplanars, name Group);
native function bool EndBrush();
native function int GetVertexCount();
native function vector GetVertex(int i);
native function int GetPolyCount();
native function bool BadParameters(optional string msg);
native function int Vertexv(vector v);
native function int Vertex3f(float x, float y, float z);
native function Poly3i(int Direction, int i, int j, int k, optional name ItemName, optional int PolyFlags);
native function Poly4i(int Direction, int i, int j, int k, int l, optional name ItemName, optional int PolyFlags);
native function PolyBegin(int Direction, optional name ItemName, optional int PolyFlags);
native function Polyi(int i);
native function PolyEnd();

// Build interface.
event bool Build();

defaultproperties
{
    BitmapFilename="BBGeneric"
    ToolTip="Generic Builder"
}