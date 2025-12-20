//=============================================================================
// SpiralStairBuilder: Builds a spiral staircase.
//=============================================================================
class SpiralStairBuilder
	extends BrushBuilder;

var() int InnerRadius, StepWidth, StepHeight, StepThickness, NumStepsPer360, NumSteps;
var() name GroupName;
var() bool SlopedCeiling, SlopedFloor, CounterClockwise;

function BuildCurvedStair(int Direction)
{
	local rotator RotStep, NewRot;
	local vector vtx, NewVtx, Template[8];
	local int x, y, idx, VertexStart;

	RotStep.Yaw = 65536.0f * ((360.0f / NumStepsPer360) / 360.0f);
	if (CounterClockwise)
	{
		RotStep.Yaw *= -1;
		Direction *= -1;
	}

	// Generate the vertices for the first stair.
	idx = 0;
	VertexStart = GetVertexCount();
	vtx.x = InnerRadius;
	for (x = 0 ; x < 2 ; x++)
	{
		NewVtx = vtx >> (RotStep * x);

		vtx.z = 0;
		if (SlopedCeiling && x == 1)
			vtx.z = StepHeight;
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z);
		Template[idx].x = NewVtx.x;		Template[idx].y = NewVtx.y;		Template[idx].z = vtx.z;		idx++;

		vtx.z = StepThickness;
		if (SlopedFloor && x == 0)
			vtx.z -= StepHeight;
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z);
		Template[idx].x = NewVtx.x;		Template[idx].y = NewVtx.y;		Template[idx].z = vtx.z;		idx++;
	}

	vtx.x = InnerRadius + StepWidth;
	for (x = 0 ; x < 2 ; x++)
	{
		NewVtx = vtx >> (RotStep * x);

		vtx.z = 0;
		if (SlopedCeiling && x == 1)
			vtx.z = StepHeight;
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z);
		Template[idx].x = NewVtx.x;		Template[idx].y = NewVtx.y;		Template[idx].z = vtx.z;		idx++;

		vtx.z = StepThickness;
		if (SlopedFloor && x == 0)
			vtx.z -= StepHeight;
		Vertex3f(NewVtx.x, NewVtx.y, vtx.z);
		Template[idx].x = NewVtx.x;		Template[idx].y = NewVtx.y;		Template[idx].z = vtx.z;		idx++;
	}

	// Create steps from the template
	for (x = 0 ; x < NumSteps - 1 ; x++)
	{
		if (SlopedFloor)
		{
			Poly3i(Direction, VertexStart + 3, VertexStart + 1, VertexStart + 5, 'steptop');
			Poly3i(Direction, VertexStart + 3, VertexStart + 5, VertexStart + 7, 'steptop');
		}
		else
			Poly4i(Direction, VertexStart + 3, VertexStart + 1, VertexStart + 5, VertexStart + 7, 'steptop');

		Poly4i(Direction, VertexStart + 0, VertexStart + 1, VertexStart + 3, VertexStart + 2, 'inner');
		Poly4i(Direction, VertexStart + 5, VertexStart + 4, VertexStart + 6, VertexStart + 7, 'outer');
		Poly4i(Direction, VertexStart + 1, VertexStart + 0, VertexStart + 4, VertexStart + 5, 'stepfront');
		Poly4i(Direction, VertexStart + 2, VertexStart + 3, VertexStart + 7, VertexStart + 6, 'stepback');

		if (SlopedCeiling)
		{
			Poly3i(Direction, VertexStart + 0, VertexStart + 2, VertexStart + 6, 'stepbottom');
			Poly3i(Direction, VertexStart + 0, VertexStart + 6, VertexStart + 4, 'stepbottom');
		}
		else
			Poly4i(Direction, VertexStart + 0, VertexStart + 2, VertexStart + 6, VertexStart + 4, 'stepbottom');

		VertexStart = GetVertexCount();
		for (y = 0 ; y < 8 ; y++)
		{
			NewVtx = Template[y] >> (RotStep * (x + 1));
			Vertex3f(NewVtx.x, NewVtx.y, NewVtx.z + (Stepheight * (x + 1)));
		}
	}
}

function bool Build()
{
	if (InnerRadius<1 || StepWidth<1 || NumSteps<1 || NumStepsPer360<3)
		return BadParameters();

	BeginBrush(false, GroupName);
	BuildCurvedStair(+1);
	return EndBrush();
}

defaultproperties
{
    InnerRadius=64
    StepWidth=256
    StepHeight=16
    StepThickness=32
    NumStepsPer360=8
    NumSteps=8
    GroupName="Spiral"
    SlopedCeiling=True
    BitmapFilename="BBSpiralStair"
    ToolTip="Spiral Staircase"
}