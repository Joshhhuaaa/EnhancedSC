class EIRSensor extends EGameplayObject;

#exec OBJ LOAD FILE=..\StaticMeshes\EGO_OBJ.usx

enum IRType
{
	IRT_Emitter,
	IRT_Receiver
};

var()	EIRSensor			Receiver;
var()	IRType				SensorType;
var()	float				StayOnTime;
var		EGameplayObject		Laser;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (SensorType == IRT_Emitter)
	{
		// Validate Receiver
		if (Receiver == None)
			Log(self$" ERROR: EIRSensor should have a End");
		else if (Receiver.SensorType != IRT_Receiver)
			Log(self$" ERROR: EIRSensor Receiver's Type is not a IRT_Receiver");

		// Create laser
		Laser = spawn(class'EGameplayObject', self,,,Rotator(Receiver.Location - Location));
		if (Laser == None)
			Log(self$" ERROR: Can't create Laser for EIRSensor");
		Laser.SetStaticMesh(StaticMesh'EGO_OBJ.GenObjGO.GO_Laser');
		Laser.SetCollision(false);
		Laser.bHidden		= true;
		Laser.HeatIntensity	= 1;
		AdjustScale(Receiver.Location);

		SetCollisionSize(VSize(Location - Receiver.Location) * 1.1, 30);

		InitialState = 's_RayTracing';
	}
}
/*
function Touch(Actor Other)
{
	GotoState('s_RayTracing');
}

function UnTouch(Actor Other)
{
	if (Touching.Length <= 1)
		GotoState('');
}
*/
function AdjustScale(vector LaserEnd)
{    
	Laser.SetDrawScale3D(((VSize(Location - LaserEnd) + 2.f) * Vect(1,0,0)) + DrawScale3D);
}

// Should not call base EGameplayObject::Trigger
function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{
	if (Other.IsA('EPattern'))
		GotoState('');
	else
		Super.Trigger(Other, EventInstigator);
}

state s_RayTracing
{
	function BeginState()
	{
		if (Receiver == None)
			Disable('Tick');
		
		// call once to activate on startup
		Activate();
		SetTimer(StayOnTime, true);
	}

	function EndState()
	{
		Deactivate();
	}

	function Activate()
	{
		Laser.bJustVisibleHeat = true;
		Laser.bJustVisibleNight = true;
	}
	function Deactivate()
	{
		Laser.bJustVisibleHeat = false;
		Laser.bJustVisibleNight = false;
	}

	function Timer()
	{
		if (!Laser.bJustVisibleHeat)
		{
			Activate();
			Enable('Tick');
		}
		else
		{
			Deactivate();
			Disable('Tick');
		}
	}

	function Tick(float DeltaTime)
	{
		local vector	HitLocation, HitNormal;
		local actor		HitActor;
		local int		PillTag, i;
		local bool		shouldTrace;

		// trace only if a pawn is around
		for (i = 0; i < Touching.Length; i++)
		{
			if (Touching[i].bIsPlayerPawn)
				shouldTrace = true;
		}

		if (shouldTrace)
			HitActor = TraceBone(PillTag, HitLocation, HitNormal, Receiver.Location, Location);

		if (HitActor == None)
			AdjustScale(Receiver.Location);
		else
			AdjustScale(HitLocation);

		if (HitActor != None && HitActor.bIsPlayerPawn)
		{
			if (!IsPlaying(Sound'Electronic.Play_AlarmeDetecteurLaser'))
				PlaySound(Sound'Electronic.Play_AlarmeDetecteurLaser', SLOT_SFX);
			TriggerPattern();
		}

	}
}

defaultproperties
{
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_LaserSystemA01B',Percent=100.000000)
    TriggerPatternJustOnce=False
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_LaserSystemA00B'
    DrawScale=2.000000
    bBlockProj=False
    bBlockBullet=False
    bBlockNPCVision=False
    bIsTouchable=True
}