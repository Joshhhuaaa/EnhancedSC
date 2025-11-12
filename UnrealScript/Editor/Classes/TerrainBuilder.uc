//=============================================================================
// TerrainBuilder: Builds a 3D cube brush, with a tessellated bottom.
//=============================================================================
class TerrainBuilder
	extends BrushBuilder;

var() float Height, Width, Breadth;
var() int WidthSegments, DepthSegments;		// How many breaks to have in each direction
var() name GroupName;

function BuildTerrain(int Direction, float dx, float dy, float dz, int WidthSeg, int DepthSeg)
{
	local int n,nbottom,ntop,i,j,k,x,y,idx;
	local float WidthStep, DepthStep;

	//
	// TOP
	//

	n = GetVertexCount();

	// Create vertices
	for (i=-1; i<2; i+=2)
		for (j=-1; j<2; j+=2)
			for (k=-1; k<2; k+=2)
				Vertex3f(i*dx/2, j*dy/2, k*dz/2);

	// Create the top
	Poly4i(Direction,n+3,n+1,n+5,n+7, 'sky');

	//
	// BOTTOM
	//

	nbottom = GetVertexCount();

	// Create vertices
	WidthStep = dx / WidthSeg;
	DepthStep = dy / DepthSeg;

	for (x = 0 ; x < WidthSeg + 1 ; x++)
		for (y = 0 ; y < DepthSeg + 1 ; y++)
			Vertex3f((WidthStep * x) - dx/2, (DepthStep * y) - dy/2, -(dz/2));

	ntop = GetVertexCount();

	for (x = 0 ; x < WidthSeg + 1 ; x++)
		for (y = 0 ; y < DepthSeg + 1 ; y++)
			Vertex3f((WidthStep * x) - dx/2, (DepthStep * y) - dy/2, dz/2);

	// Create the bottom as a mesh of triangles
	for (x = 0 ; x < WidthSeg ; x++)
		for (y = 0 ; y < DepthSeg ; y++)
		{
			Poly3i(-Direction,
				(nbottom+y)		+ ((DepthSeg+1) * x),
				(nbottom+y)		+ ((DepthSeg+1) * (x+1)),
				((nbottom+1)+y)	+ ((DepthSeg+1) * (x+1)),
				'ground');
			Poly3i(-Direction,
				(nbottom+y)		+ ((DepthSeg+1) * x),
				((nbottom+1)+y) + ((DepthSeg+1) * (x+1)),
				((nbottom+1)+y) + ((DepthSeg+1) * x),
				'ground');
		}

	//
	// SIDES
	//
	// The bottom poly of each side is basically a triangle fan.
	//
	for (x = 0 ; x < WidthSeg ; x++)
	{
		Poly4i(-Direction,
			nbottom + DepthSeg + ((DepthSeg+1) * x),
			nbottom + DepthSeg + ((DepthSeg+1) * (x + 1)),
			ntop + DepthSeg + ((DepthSeg+1) * (x + 1)),
			ntop + DepthSeg + ((DepthSeg+1) * x),
			'sky');
		Poly4i(-Direction,
			nbottom + ((DepthSeg+1) * (x + 1)),
			nbottom + ((DepthSeg+1) * x),
			ntop + ((DepthSeg+1) * x),
			ntop + ((DepthSeg+1) * (x + 1)),
			'sky');
	}
	for (y = 0 ; y < DepthSeg ; y++)
	{
		Poly4i(-Direction,
			nbottom + y,
			nbottom + (y + 1),
			ntop + (y + 1),
			ntop + y,
			'sky');
		Poly4i(-Direction,
			nbottom + ((DepthSeg+1) * WidthSeg) + (y + 1),
			nbottom + ((DepthSeg+1) * WidthSeg) + y,
			ntop + ((DepthSeg+1) * WidthSeg) + y,
			ntop + ((DepthSeg+1) * WidthSeg) + (y + 1),
			'sky');
	}
}

event bool Build()
{
	if (Height<=0 || Width<=0 || Breadth<=0 || WidthSegments<=0 || DepthSegments<=0)
		return BadParameters();

	BeginBrush(false, GroupName);
	BuildTerrain(+1, Breadth, Width, Height, WidthSegments, DepthSegments);
	return EndBrush();
}

defaultproperties
{
    Height=256.000000
    Width=256.000000
    Breadth=512.000000
    WidthSegments=4
    DepthSegments=2
    GroupName="Terrain"
    BitmapFilename="BBTerrain"
    ToolTip="BSP Based Terrain"
}