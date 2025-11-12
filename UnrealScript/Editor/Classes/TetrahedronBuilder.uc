//=============================================================================
// TetrahedronBuilder: Builds an octahedron (not tetrahedron) - experimental.
//=============================================================================
class TetrahedronBuilder
	extends BrushBuilder;

var() float Radius;
var() int SphereExtrapolation;
var() name GroupName;

function Extrapolate(int a, int b, int c, int Count, float Radius)
{
	local int ab,bc,ca;
	if (Count>1)
	{
		ab=Vertexv(Radius*Normal(GetVertex(a)+GetVertex(b)));
		bc=Vertexv(Radius*Normal(GetVertex(b)+GetVertex(c)));
		ca=Vertexv(Radius*Normal(GetVertex(c)+GetVertex(a)));
		Extrapolate(a,ab,ca,Count-1,Radius);
		Extrapolate(b,bc,ab,Count-1,Radius);
		Extrapolate(c,ca,bc,Count-1,Radius);
		Extrapolate(ab,bc,ca,Count-1,Radius);
		//wastes shared vertices
	}
	else Poly3i(+1,a,b,c);
}

function BuildTetrahedron(float R, int SphereExtrapolation)
{
	vertex3f(R,0,0);
	vertex3f(-R,0,0);
	vertex3f(0, R,0);
	vertex3f(0,-R,0);
	vertex3f(0,0, R);
	vertex3f(0,0,-R);

	Extrapolate(2,1,4,SphereExtrapolation,Radius);
	Extrapolate(1,3,4,SphereExtrapolation,Radius);
	Extrapolate(3,0,4,SphereExtrapolation,Radius);
	Extrapolate(0,2,4,SphereExtrapolation,Radius);
	Extrapolate(1,2,5,SphereExtrapolation,Radius);
	Extrapolate(3,1,5,SphereExtrapolation,Radius);
	Extrapolate(0,3,5,SphereExtrapolation,Radius);
	Extrapolate(2,0,5,SphereExtrapolation,Radius);
}

event bool Build()
{
	if (Radius<=0 || SphereExtrapolation<=0)
		return BadParameters();

	BeginBrush(false, GroupName);
	BuildTetrahedron(Radius, SphereExtrapolation);
	return EndBrush();
}

defaultproperties
{
    Radius=256.000000
    SphereExtrapolation=1
    GroupName="Tetrahedron"
    BitmapFilename="BBSphere"
    ToolTip="Tetrahedron (Sphere)"
}