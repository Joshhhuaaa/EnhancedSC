//=============================================================================
// ConeBuilder: Builds a 3D cone brush, compatible with cylinder of same size.
//=============================================================================
class ConeBuilder
	extends BrushBuilder;

var() float Height, CapHeight, OuterRadius, InnerRadius;
var() int Sides;
var() name GroupName;
var() bool AlignToSide, Hollow;

function BuildCone( int Direction, bool AlignToSide, int Sides, float Height, float Radius, name Item )
{
	local int n,i,j,q,Ofs;
	n = GetVertexCount();
	if( AlignToSide )
	{
		Radius /= cos(pi/Sides);
		Ofs = 1;
	}

	// Vertices.
	for( i=0; i<Sides; i++ )
		Vertex3f( Radius*sin((2*i+Ofs)*pi/Sides), Radius*cos((2*i+Ofs)*pi/Sides), 0 );
	Vertex3f( 0, 0, Height );

	// Polys.
	for( i=0; i<Sides; i++ )
		Poly3i( Direction, n+i, n+Sides, n+((i+1)%Sides), Item );
}

function bool Build()
{
	local int i;

	if( Sides<3 )
		return BadParameters();
	if( Height<=0 || OuterRadius<=0 )
		return BadParameters();
	if( Hollow && (InnerRadius<=0 || InnerRadius>=OuterRadius) )
		return BadParameters();
	if( Hollow && CapHeight>Height )
		return BadParameters();
	if( Hollow && (CapHeight==Height && InnerRadius==OuterRadius) )
		return BadParameters();

	BeginBrush( false, GroupName );
	BuildCone( +1, AlignToSide, Sides, Height, OuterRadius, 'Top' );
	if( Hollow )
	{
		BuildCone( -1, AlignToSide, Sides, CapHeight, InnerRadius, 'Cap' );
		if( OuterRadius!=InnerRadius )
			for( i=0; i<Sides; i++ )
				Poly4i( 1, i, ((i+1)%Sides), Sides+1+((i+1)%Sides), Sides+1+i, 'Bottom' );
	}
	else
	{
		PolyBegin( 1, 'Bottom' );
		for( i=0; i<Sides; i++ )
			Polyi( i );
		PolyEnd();
	}
	return EndBrush();
}

defaultproperties
{
    Height=256.000000
    CapHeight=256.000000
    OuterRadius=512.000000
    InnerRadius=384.000000
    Sides=8
    GroupName="Cone"
    AlignToSide=true
    BitmapFilename="BBCone"
    ToolTip="Cone"
}