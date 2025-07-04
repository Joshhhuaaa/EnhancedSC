//=============================================================================
// SheetBuilder: Builds a simple sheet.
//=============================================================================
class SheetBuilder
	extends BrushBuilder;

var() int Height, Width, HorizBreaks, VertBreaks;
var() enum ESheetAxis
{
	AX_Horizontal,
	AX_XAxis,
	AX_YAxis,
} Axis;
var() name GroupName;

event bool Build()
{
	local int x, y, XStep, YStep, idx, count;

	if( Height<=0 || Width<=0 || HorizBreaks<=0 || VertBreaks<=0 )
		return BadParameters();

	BeginBrush( false, GroupName );
	XStep = Width/HorizBreaks;
	YStep = Height/VertBreaks;

	count = 0;
	for( x = 0 ; x < HorizBreaks ; x++ )
	{
		for( y = 0 ; y < VertBreaks ; y++ )
		{
			if( Axis==AX_Horizontal )
			{
				Vertex3f(  (x*XStep)-Width/2, (y*YStep)-Height/2, 0 );
				Vertex3f(  (x*XStep)-Width/2, ((y+1)*YStep)-Height/2, 0 );
				Vertex3f(  ((x+1)*XStep)-Width/2, ((y+1)*YStep)-Height/2, 0 );
				Vertex3f(  ((x+1)*XStep)-Width/2, (y*YStep)-Height/2, 0 );
			}
			else if( Axis==AX_XAxis )
			{
				Vertex3f(  0, (x*XStep)-Width/2, (y*YStep)-Height/2 );
				Vertex3f(  0, (x*XStep)-Width/2, ((y+1)*YStep)-Height/2 );
				Vertex3f(  0, ((x+1)*XStep)-Width/2, ((y+1)*YStep)-Height/2 );
				Vertex3f(  0, ((x+1)*XStep)-Width/2, (y*YStep)-Height/2 );
			}
			else
			{
				Vertex3f(  (x*XStep)-Width/2, 0, (y*YStep)-Height/2 );
				Vertex3f(  (x*XStep)-Width/2, 0, ((y+1)*YStep)-Height/2 );
				Vertex3f(  ((x+1)*XStep)-Width/2, 0, ((y+1)*YStep)-Height/2 );
				Vertex3f(  ((x+1)*XStep)-Width/2, 0, (y*YStep)-Height/2 );
			}

			Poly4i(+1,count,count+1,count+2,count+3,'Sheet',0x00000108); // PF_TwoSided|PF_NotSolid.
			count = GetVertexCount();
		}
	}

	return EndBrush();
}

defaultproperties
{
    Height=256
    Width=256
    HorizBreaks=1
    VertBreaks=1
    GroupName="Sheet"
    BitmapFilename="BBSheet"
    ToolTip="Sheet"
}