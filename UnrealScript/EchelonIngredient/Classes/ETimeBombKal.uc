class ETimeBombKal extends EGameplayObject;

var(AI)	name		TimerJumpLabel;
var()	float		TimeToExplosion;
var EGameplayObject NeedleSec, NeedleMin;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SpawnNeedle(NeedleSec, -65535 / 60 * 5 * Rot(0,0,1));
	SpawnNeedle(NeedleMin, -65535 / 60 * Rot(0,0,1));
}

function SpawnNeedle(out EGameplayObject Needle, Rotator Rate)
{
	if (Needle != None) 
		return;
	Needle = spawn(class'EGameplayObject', self,, ToWorld(Vect(3.887,-4.63,0.373)));
	Needle.SetStaticMesh(StaticMesh'EMeshIngredient.Object.BombNeedle_kal');
	Needle.bFixedRotationDir = true;
	Needle.RotationRate = Rate;
	Needle.SetPhysics(PHYS_None);
}

function Destroyed()
{
	if (NeedleSec != None)
		NeedleSec.Destroy();
	if (NeedleMin != None)
		NeedleMin.Destroy();
	Super.Destroyed();
}

function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{
	// From pattern to start Timer
	PlaySound(Sound'Electronic.Play_AlarmAlgorithm', SLOT_SFX);
	GotoState('s_Timing');
}

state s_Timing
{
	function BeginState()
	{
		NeedleSec.SetPhysics(PHYS_Rotating);
		NeedleMin.SetPhysics(PHYS_Rotating);

		SetTimer(TimeToExplosion, false);
	}

	function EndState()
	{
		NeedleSec.SetPhysics(PHYS_None);
		NeedleMin.SetPhysics(PHYS_None);
	}

	function Timer()
	{
		// If timer, replace destroyed jump label with timer
		DestroyedJumpLabel = TimerJumpLabel;
		// BOOM
		DestroyObject();
	}

	function Trigger(actor Other, pawn EventInstigator, optional name InTag)
	{
		// // From interaction to handle defusing
		Super.Trigger(Other, EventInstigator);
		PlaySound(Sound'Electronic.Stop_AlarmAlgorithm', SLOT_SFX);
		GotoState('');
	}
}

defaultproperties
{
    TimeToExplosion=120.000000
    bExplodeWhenDestructed=True
    ExplosionDamage=1000.000000
    StaticMesh=StaticMesh'EMeshIngredient.Object.Bomb_kal'
}