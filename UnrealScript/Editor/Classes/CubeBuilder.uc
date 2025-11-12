//=============================================================================
// CubeBuilder: Builds a 3D cube brush.
//=============================================================================
class CubeBuilder
	extends BrushBuilder;

var() float Height, Width, Breadth;
var() float WallThickness;
var() name GroupName;
var() bool Hollow;
var() bool Tessellated;

function BuildCube(int Direction, float dx, float dy, float dz, bool _tessellated)
{
	local int n,i,j,k;
	n = GetVertexCount();

	for (i=-1; i<2; i+=2)
		for (j=-1; j<2; j+=2)
			for (k=-1; k<2; k+=2)
				Vertex3f(i*dx/2, j*dy/2, k*dz/2);

	// If the user wants a Tessellated cube, create the sides out of tris instead of quads.
	if( _tessellated)
	{
		Poly3i(Direction,n+0,n+1,n+3);
		Poly3i(Direction,n+0,n+3,n+2);
		Poly3i(Direction,n+2,n+3,n+7);
		Poly3i(Direction,n+2,n+7,n+6);
		Poly3i(Direction,n+6,n+7,n+5);
		Poly3i(Direction,n+6,n+5,n+4);
		Poly3i(Direction,n+4,n+5,n+1);
		Poly3i(Direction,n+4,n+1,n+0);
		Poly3i(Direction,n+3,n+1,n+5);
		Poly3i(Direction,n+3,n+5,n+7);
		Poly3i(Direction,n+0,n+2,n+6);
		Poly3i(Direction,n+0,n+6,n+4);
	}
	else
	{
		Poly4i(Direction,n+0,n+1,n+3,n+2);
		Poly4i(Direction,n+2,n+3,n+7,n+6);
		Poly4i(Direction,n+6,n+7,n+5,n+4);
		Poly4i(Direction,n+4,n+5,n+1,n+0);
		Poly4i(Direction,n+3,n+1,n+5,n+7);
		Poly4i(Direction,n+0,n+2,n+6,n+4);
	}
}

event bool Build()
{
	if (Height<=0 || Width<=0 || Breadth<=0)
		return BadParameters();
	if (Hollow && (Height<=WallThickness || Width<=WallThickness || Breadth<=WallThickness))
		return BadParameters();
	if (Hollow && Tessellated)
		return BadParameters("The 'Tessellated' option can't be specified with the 'Hollow' option.");

	BeginBrush(false, GroupName);
	BuildCube(+1, Breadth, Width, Height, Tessellated);
	if (Hollow)
		BuildCube(-1, Breadth-WallThickness, Width-WallThickness, Height-WallThickness, Tessellated);
	return EndBrush();
}

defaultproperties
{
    Height=256.000000
    Width=256.000000
    Breadth=256.000000
    WallThickness=16.000000
    GroupName="Cube"
    BitmapFilename="BBCube"
    ToolTip="Cube"
}