//=============================================================================
// LinearStairBuilder: Builds a Linear Staircase.
//=============================================================================
class LinearStairBuilder
	extends BrushBuilder;

var() int StepLength, StepHeight, StepWidth, NumSteps, AddToFirstStep;
var() name GroupName;

event bool Build()
{
	local int i, LastIdx, CurrentX, CurrentY, CurrentZ, Adjustment;

	// Check for bad input.
	if (StepLength<=0 || StepHeight<=0 || StepWidth<=0)
		return BadParameters();
	if (Numsteps<=1 || Numsteps>45)
		return BadParameters("NumSteps must be greater than 1 and less than 45.");

	//
	// Build the brush.
	//
	BeginBrush(false, GroupName);

	CurrentX = 0;
	CurrentY = 0;
	CurrentZ = 0;

	LastIdx = GetVertexCount();

	// Bottom poly.
	Vertex3f(0,						0,			-StepHeight);
	Vertex3f(0,						StepWidth,	-StepHeight);
	Vertex3f(StepLength * NumSteps,	StepWidth,	-StepHeight);
	Vertex3f(StepLength * NumSteps,	0,			-StepHeight);
	Poly4i(1, 0, 1, 2, 3, 'Base');
	LastIdx += 4;

	// Back poly.
	Vertex3f(StepLength * NumSteps,	StepWidth,	-StepHeight);
	Vertex3f(StepLength * NumSteps,	StepWidth,	(StepHeight * (NumSteps - 1)) + AddToFirstStep);
	Vertex3f(StepLength * NumSteps,	0,			(StepHeight * (NumSteps - 1)) + AddToFirstStep);
	Vertex3f(StepLength * NumSteps,	0,			-StepHeight);
	Poly4i(1, 4, 5, 6, 7, 'Back');
	LastIdx += 4;

	// Tops of steps.
	for (i = 0 ; i < Numsteps ; i++)
	{
		CurrentX = (i * StepLength);
		CurrentZ = (i * StepHeight) + AddToFirstStep;

		// Top of the step
		Vertex3f(CurrentX,					CurrentY,				CurrentZ);
		Vertex3f(CurrentX,					CurrentY + StepWidth,	CurrentZ);
		Vertex3f(CurrentX + StepLength,	CurrentY + StepWidth,	CurrentZ);
		Vertex3f(CurrentX + StepLength,	CurrentY,				CurrentZ);

		Poly4i(1,
			LastIdx+(i*4)+3,
			LastIdx+(i*4)+2,
			LastIdx+(i*4)+1,
			LastIdx+(i*4), 'Step');
	}
	LastIdx += (NumSteps*4);

	// Fronts of steps.
	for (i = 0 ; i < Numsteps ; i++)
	{
		CurrentX = (i * StepLength);
		CurrentZ = (i * StepHeight) + AddToFirstStep;
		if (i == 0)
			Adjustment = AddToFirstStep;
		else
			Adjustment = 0;

		// Top of the step
		Vertex3f(CurrentX,		CurrentY,				CurrentZ);
		Vertex3f(CurrentX,		CurrentY,				CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX,		CurrentY + StepWidth,	CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX,		CurrentY + StepWidth,	CurrentZ);

		Poly4i(1,
			LastIdx+(i*12)+3,
			LastIdx+(i*12)+2,
			LastIdx+(i*12)+1,
			LastIdx+(i*12), 'Rise');

		// Sides of the step
		Vertex3f(CurrentX,								CurrentY,		CurrentZ);
		Vertex3f(CurrentX,								CurrentY,		CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + (StepLength*(Numsteps-i)),	CurrentY,		CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + (StepLength*(Numsteps-i)),	CurrentY,		CurrentZ);

		Poly4i(1,
			LastIdx+(i*12)+4,
			LastIdx+(i*12)+5,
			LastIdx+(i*12)+6,
			LastIdx+(i*12)+7, 'Side');

		Vertex3f(CurrentX,								CurrentY + StepWidth,		CurrentZ);
		Vertex3f(CurrentX,								CurrentY + StepWidth,		CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + (StepLength*(Numsteps-i)),	CurrentY + StepWidth,		CurrentZ - StepHeight - Adjustment);
		Vertex3f(CurrentX + (StepLength*(Numsteps-i)),	CurrentY + StepWidth,		CurrentZ);

		Poly4i(1,
			LastIdx+(i*12)+11,
			LastIdx+(i*12)+10,
			LastIdx+(i*12)+9,
			LastIdx+(i*12)+8, 'Side');
	}

	return EndBrush();
}

defaultproperties
{
    StepLength=32
    StepHeight=16
    StepWidth=256
    NumSteps=8
    GroupName="LinearStair"
    BitmapFilename="BBLinearStair"
    ToolTip="Linear Staircase"
}