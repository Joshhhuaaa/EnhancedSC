class EMetalDetector extends EGameplayObject;

var() float			AlarmShutDownTime;	// If 0, will not shut down
var Actor			Spotted;
var EVolumeTrigger	DetectionVolume;

function PostBeginPlay()
{
	DetectionVolume = spawn(class'EVolumeTrigger', self);
	DetectionVolume.SetCollisionSize(10, 125);

	Super.PostBeginPlay();
}

event Destroyed()
{
	Super.Destroyed();

	if( DetectionVolume != None )
		DetectionVolume.Destroy();
}

auto state s_Normal
{
	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		local EPawn ePawn;

		Super.Trigger(Other, EventInstigator, InTag);

		if( !Other.IsA('EVolumeTrigger') )
			return;

		ePawn = EPawn(EventInstigator);
		if( ePawn == None )
			Log("ERROR : Pawn passing through detector should be an EPawn.");
		else if( !ePawn.bIsPlayerPawn )
			return;

		// if ePawn has no weapon, forget the trigger
		if( ePawn.FullInventory.GetItemByClass('EWeapon') == None )
			return;

		PlaySound(Sound'Electronic.Play_AlarmeDetecteurLaser', SLOT_SFX);

		Spotted = EventInstigator;
		if( Alarm != None )
			Alarm.EnableAlarm(self, EventInstigator.Controller);

		TriggerPattern(EventInstigator);

		GotoState('s_Violation');
	}
}

state s_Violation
{
	function BeginState()
	{
		SetTimer(AlarmShutDownTime, false);
	}

	function Timer()
	{
		Alarm.DisableAlarm(self);
		GotoState('s_Normal');
	}
}

defaultproperties
{
    AlarmShutDownTime=5.000000
    bDamageable=false
    AlarmLinkType=EAlarm_Trigger
    StaticMesh=StaticMesh'EMeshIngredient.Object.MetalDetector'
    CollisionRadius=10.000000
    CollisionHeight=125.000000
    bStaticMeshCylColl=false
    bBlockPlayers=true
    bBlockActors=true
}