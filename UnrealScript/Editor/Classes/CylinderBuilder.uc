//=============================================================================
// CylinderBuilder: Builds a 3D cylinder brush.
//=============================================================================
class CylinderBuilder
	extends BrushBuilder;

var() float Height, OuterRadius, InnerRadius;
var() int Sides;
var() name GroupName;
var() bool AlignToSide, Hollow;

function BuildCylinder(int Direction, bool AlignToSide, int Sides, float Height, float Radius)
{
	local int n,i,j,q,Ofs;
	n = GetVertexCount();
	if (AlignToSide)
	{
		Radius /= cos(pi/Sides);
		Ofs = 1;
	}

	// Vertices.
	for (i=0; i<Sides; i++)
		for (j=-1; j<2; j+=2)
			Vertex3f(Radius*sin((2*i+Ofs)*pi/Sides), Radius*cos((2*i+Ofs)*pi/Sides), j*Height/2);

	// Polys.
	for (i=0; i<Sides; i++)
		Poly4i(Direction, n+i*2, n+i*2+1, n+((i*2+3)%(2*Sides)), n+((i*2+2)%(2*Sides)), 'Wall');
}

function bool Build()
{
	local int i,j,k;

	if (Sides<3)
		return BadParameters();
	if (Height<=0 || OuterRadius<=0)
		return BadParameters();
	if (Hollow && (InnerRadius<=0 || InnerRadius>=OuterRadius))
		return BadParameters();

	BeginBrush(false, GroupName);
	BuildCylinder(+1, AlignToSide, Sides, Height, OuterRadius);
	if (Hollow)
	{
		BuildCylinder(-1, AlignToSide, Sides, Height, InnerRadius);
		for (j=-1; j<2; j+=2)
			for (i=0; i<Sides; i++)
				Poly4i(j, i*2+(1-j)/2, ((i+1)%Sides)*2+(1-j)/2, ((i+1)%Sides)*2+(1-j)/2+Sides*2, i*2+(1-j)/2+Sides*2, 'Cap');
	}
	else
	{
		for (j=-1; j<2; j+=2)
		{
			PolyBegin(j, 'Cap');
			for (i=0; i<Sides; i++)
				Polyi(i*2+(1-j)/2);
			PolyEnd();
		}
	}
	return EndBrush();
}

defaultproperties
{
    Height=256.000000
    OuterRadius=512.000000
    InnerRadius=384.000000
    Sides=8
    GroupName="Cylinder"
    AlignToSide=True
    BitmapFilename="BBCylinder"
    ToolTip="Cylinder"
}