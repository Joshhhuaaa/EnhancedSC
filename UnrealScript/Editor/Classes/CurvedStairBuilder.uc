//=============================================================================
// CurvedStairBuilder: Builds a curved staircase.
//=============================================================================
class CurvedStairBuilder
	extends BrushBuilder;

var() int InnerRadius, StepHeight, StepWidth, AngleOfCurve, NumSteps, AddToFirstStep;
var() name GroupName;
var() bool CounterClockwise;

function BuildCurvedStair(int Direction)
{
	local rotator RotStep;
	local vector vtx, NewVtx;
	local int x, z, InnerStart, OuterStart, BottomInnerStart, BottomOuterStart, Adjustment;

	RotStep.Yaw = (65536.0f * (AngleOfCurve / 360.0f)) / NumSteps;

	if (CounterClockwise)
	{
		RotStep.Yaw *= -1;
		Direction *= -1;
	}

	// Generate the inner curve points.
	InnerStart = GetVertexCount();
	vtx.x = InnerRadius;
	for (x = 0 ; x < (NumSteps + 1) ; x++)
	{
		if (x == 0)
			Adjustment = AddToFirstStep;
		else
			Adjustment = 0;
				
		NewVtx = vtx >> (RotStep * x);

		Vertex3f(NewVtx.x, NewVtx.y, vtx.z - Adjustment);
		vtx.z += StepHeight;
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z);
	}

	// Generate the outer curve points.
	OuterStart = GetVertexCount();
	vtx.x = InnerRadius + StepWidth;
	vtx.z = 0;
	for (x = 0 ; x < (NumSteps + 1) ; x++)
	{
		if (x == 0)
			Adjustment = AddToFirstStep;
		else
			Adjustment = 0;
				
		NewVtx = vtx >> (RotStep * x);

		Vertex3f(NewVtx.x, NewVtx.y, vtx.z - Adjustment);
		vtx.z += StepHeight;
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z);
	}

	// Generate the bottom inner curve points.
	BottomInnerStart = GetVertexCount();
	vtx.x = InnerRadius;
	vtx.z = 0;
	for (x = 0 ; x < (NumSteps + 1) ; x++)
	{
		NewVtx = vtx >> (RotStep * x);
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z - AddToFirstStep);
	}

	// Generate the bottom outer curve points.
	BottomOuterStart = GetVertexCount();
	vtx.x = InnerRadius + StepWidth;
	for (x = 0 ; x < (NumSteps + 1) ; x++)
	{
		NewVtx = vtx >> (RotStep * x);
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z - AddToFirstStep);
	}

	for (x = 0 ; x < NumSteps ; x++)
	{
		Poly4i(Direction, InnerStart + (x * 2) + 2, InnerStart + (x * 2) + 1, OuterStart + (x * 2) + 1, OuterStart + (x * 2) + 2, 'steptop');
		Poly4i(Direction, InnerStart + (x * 2) + 1, InnerStart + (x * 2), OuterStart + (x * 2), OuterStart + (x * 2) + 1, 'stepfront');
		Poly4i(Direction, BottomInnerStart + x, InnerStart + (x * 2) + 1, InnerStart + (x * 2) + 2, BottomInnerStart + x + 1, 'innercurve');
		Poly4i(Direction, OuterStart + (x * 2) + 1, BottomOuterStart + x, BottomOuterStart + x + 1, OuterStart + (x * 2) + 2, 'outercurve');
		Poly4i(Direction, BottomInnerStart + x, BottomInnerStart + x + 1, BottomOuterStart + x + 1, BottomOuterStart + x, 'Bottom');
	}

	// Back panel.
	Poly4i(Direction, BottomInnerStart + NumSteps, InnerStart + (NumSteps * 2), OuterStart + (NumSteps * 2), BottomOuterStart + NumSteps, 'back');
}

function bool Build()
{
	local int i,j,k;

	if (AngleOfCurve<1 || AngleOfCurve>360)
		return BadParameters("Angle is out of range.");
	if (InnerRadius<1 || StepWidth<1 || NumSteps<1)
		return BadParameters();

	BeginBrush(false, GroupName);
	BuildCurvedStair(+1);
	return EndBrush();
}

defaultproperties
{
    InnerRadius=240
    StepHeight=16
    StepWidth=256
    AngleOfCurve=90
    NumSteps=4
    GroupName="CStair"
    BitmapFilename="BBCurvedStair"
    ToolTip="Curved Staircase"
}