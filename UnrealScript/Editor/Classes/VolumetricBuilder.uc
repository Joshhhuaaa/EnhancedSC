//=============================================================================
// VolumetricBuilder: Builds a volumetric brush (criss-crossed sheets).
//=============================================================================
class VolumetricBuilder
	extends BrushBuilder;

var() float Height, Radius;
var() int NumSheets;
var() name GroupName;

function BuildVolumetric(int Direction, int NumSheets, float Height, float Radius)
{
	local int n,x,y;
	local rotator RotStep;
	local vector vtx, NewVtx;

	n = GetVertexCount();
	RotStep.Yaw = 65536.0f / (NumSheets * 2);

	// Vertices.
	vtx.x = Radius;
	vtx.z = Height / 2;
	for (x = 0 ; x < (NumSheets * 2) ; x++)
	{
		NewVtx = vtx >> (RotStep * x);
		Vertex3f(NewVtx.x, NewVtx.y, NewVtx.z);
		Vertex3f(NewVtx.x, NewVtx.y, NewVtx.z - Height);
	}

	// Polys.
	for (x = 0 ; x < NumSheets ; x++)
	{
		y = (x*2) + 1;
		if (y >= (NumSheets * 2)) y -= (NumSheets * 2);
		Poly4i(Direction, n+(x*2), n+y, n+y+(NumSheets*2), n+(x*2)+(NumSheets*2), 'Sheets', 0x00000108); // PF_TwoSided|PF_NotSolid.
	}
}

function bool Build()
{
	if (NumSheets<2)
		return BadParameters();
	if (Height<=0 || Radius<=0)
		return BadParameters();

	BeginBrush(true, GroupName);
	BuildVolumetric(+1, NumSheets, Height, Radius);
	return EndBrush();
}

defaultproperties
{
    Height=128.000000
    Radius=64.000000
    NumSheets=2
    GroupName="Volumetric"
    BitmapFilename="BBVolumetric"
    ToolTip="Volumetric (Torches, Chains, etc)"
}