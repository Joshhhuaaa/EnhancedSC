class EFanBladeCIA extends EGameplayObject;

var() bool	bTurning;
var() int	DeltaSpeed;
var() int	MaxSpeed;

function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{
	bTurning = !bTurning;

	Super.Trigger(Other, EventInstigator, InTag);
}

function Bump(Actor Other, optional int Pill)
{
	if (bTurning && Other.bIsPawn)
		Other.TakeDamage(EPawn(Other).Health, None, Other.Location, Vect(0,0,0), Vect(0,0,0), class'Crushed');
}

function Tick(float DeltaTime)
{
	if (bTurning && RotationRate.Pitch < MaxSpeed)
	{
		RotationRate += DeltaSpeed * Rot(1,0,0) * DeltaTime;
		
		Clamp(RotationRate.Pitch, 0, MaxSpeed);
		Clamp(RotationRate.Yaw, 0, MaxSpeed);
		Clamp(RotationRate.Roll, 0, MaxSpeed);
	}
	else if (!bTurning && RotationRate.Pitch > 0)
	{
		RotationRate -= DeltaSpeed * Rot(1,0,0) * DeltaTime;
	
		Clamp(RotationRate.Pitch, 0, MaxSpeed);
		Clamp(RotationRate.Yaw, 0, MaxSpeed);
		Clamp(RotationRate.Roll, 0, MaxSpeed);
	}
}

defaultproperties
{
    DeltaSpeed=1000
    MaxSpeed=50000
    bDamageable=False
    Physics=PHYS_Rotating
    StaticMesh=StaticMesh'2-1_cia_obj.2_1_objects_obj.CIA_fanblade'
    bStaticMeshCylColl=False
    bBlockPlayers=True
    bFixedRotationDir=True
}