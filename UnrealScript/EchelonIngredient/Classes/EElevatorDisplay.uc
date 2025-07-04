class EElevatorDisplay extends EGameplayObject;

#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

var	array<EGameplayObject>	MeshCode;

// Must be done before EElevatorPanel PostBeginPlay to have a valid MeshCode
function PreBeginPlay()
{
	local vector pos;
	local int i;

	Super.PreBeginPlay();

	// Create number mesh
	CreateTextMesh();
}

function CreateTextMesh()
{
	local int i;
	local vector pos;

	for( i=0; i<2; i++ )
	{
		pos = Vect(0.65,-3,0);
		pos.Y += i * 0.6f * 8; // drawscale

		MeshCode[i] = spawn(class'EGameplayObject', self);
		MeshCode[i].SetCollision(false);
		MeshCode[i].SetBase(self);
		MeshCode[i].SetStaticMesh(None);
		MeshCode[i].SetRelativeLocation(pos);
		MeshCode[i].SetDrawScale(8.f);
		MeshCode[i].Style = STY_Modulated;
		MeshCode[i].bUnlit = true;
		MeshCode[i].HeatIntensity = 0.5;
	}
}

function UpdateDisplays( StaticMesh NewDigit0, StaticMesh NewDigit1 )
{
	MeshCode[0].SetStaticMesh(NewDigit0);
	MeshCode[1].SetStaticMesh(NewDigit1);
}

defaultproperties
{
    bDamageable=false
    StaticMesh=StaticMesh'EMeshIngredient.Elevator.ElevatorDisplay'
}