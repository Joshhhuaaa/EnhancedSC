class EBaseCam extends ESensor
	abstract;

var name			BaseBone;
var EGameplayObject CameraHead, CameraBase;
var StaticMesh		CameraHeadMesh, CameraBaseMesh;

function PostBeginPlay()
{
	// Head
	if( CameraHeadMesh != None )
	{
		CameraHead = spawn(class'EGameplayObject', self);
		CameraHead.SetStaticMesh(None);
		CameraHead.SetCollisionPrim(CameraHeadMesh);
		CameraHead.bBlockBullet = false;
		CameraHead.bBlockNPCVision = false;
		CameraHead.bCPBlockBullet = true;
		CameraHead.bCPBlockNPCVision = false;
		CameraHead.bDamageable = true;
		CameraHead.bDestroyWhenDestructed = false;
		CameraHead.HitPoints = HitPoints;	// When this object is destroyed, destroy camera too
		AttachToBone(CameraHead, HeadBone);
	}

	// Base
	if( CameraBaseMesh != None )
	{
		CameraBase = spawn(class'EGameplayObject', self);
		CameraBase.SetStaticMesh(None);
		CameraBase.SetCollisionPrim(CameraBaseMesh);
		CameraBase.bBlockPlayers = false;
		CameraBase.bBlockBullet = false;
		//CameraBase.bCPBlockPlayers = true;
		CameraBase.bCPBlockBullet = true;
		CameraBase.bDamageable = false;
		AttachToBone(CameraBase, 'cam_01');
	}

	Super.PostBeginPlay();
}

function Jammed()
{   //Lil Hitpoint hack to stop the ambient sound of the cam when jammed. 
	//Actors with 0 Hitpoints don't get checked for ambient sound triggering.
	StopAllSoundsActor(false);
	bInAmbientRange = false;
	HitPoints = 0;
	GotoState('s_jammed');
}

function UnJammed()
{
	HitPoints = 100;
	GotoState('s_Patrol');
}

function ReceiveMessage( EGameplayObject Sender, EGOMsgEvent Event )
{
	Super.ReceiveMessage(Sender, Event);

	if( bDamageable && Event == GOEV_Destructed && Sender == CameraHead )
		DestroyObject();
}

//------------------------------------------------------------------------
// Description		
//		May be called from a Pattern to deactivate camera
//------------------------------------------------------------------------
function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
{
	Super.Trigger(Other, EventInstigator, InTag);

	if( !Other.IsA('EPattern') )
		return;
	
	ChangeListWhenDamaged = false;
	GotoState('s_Deactivated');
}

function Destructed()
{
	Super.Destructed();
	GotoState('s_Destructed');
}

state s_Alert
{
	function bool ProcessDetectedPawn()
	{
		Super.ProcessDetectedPawn();

		return true;
	}
}

state s_Jammed
{
	function BeginState()
	{
		// change camera look to reflect jamming
		Style = STY_Translucent;

		SetTimer(1,true);
	}

	function EndState()
	{
		Style = default.Style;
	}

	function Timer()
	{
		Spawn(class'ewallspark', self,,location+(FRand()*Vect(10,8,5)));
	}
}

// Accomplish the same thing as destructed
state s_Destructed
{
	Ignores TakeDamage;

	function BeginState()
	{
		Super.BeginState();

		StopSound(Sound_Rot_Loop);
		PlaySound(Sound'DestroyableObjet.Play_CameraDestroyed');

		// Should always be deactivated from Player for this AddChange to be valid
		Level.AddChange(self, CHANGE_DisabledTurret);
	}
}

defaultproperties
{
    PatrolSpeed=10
    RotationVelocity=3000
    SensorDetectionType=SCAN_ChangedPawns
    FollowUponDetection=true
    ZoomUponDetection=true
    AlarmDetectionDelay=1.000000
    SoundAlert=Sound'Electronic.Play_CameraZoom'
    SoundReverse=Sound'Electronic.Play_CameraScanSwitch'
    bDestroyWhenDestructed=false
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EBreakLockEmitter',SpawnAtDamagePercent=100.000000)
    AlarmLinkType=EAlarm_Trigger
    bBlockBullet=false
    HeatIntensity=0.800000
}