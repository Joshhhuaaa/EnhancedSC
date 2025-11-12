//=============================================================================
// PhysicsVolume:  a bounding volume which affects actor physics
// Each Actor is affected at any time by one PhysicsVolume
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class PhysicsVolume extends Volume
	native;

var()		vector		ZoneVelocity;
var()		vector		Gravity;
var()		float		GroundFriction;
var()		float		TerminalVelocity;
var()		float		DamagePerSec;
var() class<DamageType>	DamageType;
var()		int			Priority;	// determines which PhysicsVolume takes precedence if they overlap
var() sound  EntrySound;	//only if waterzone
var() sound  ExitSound;		// only if waterzone
var() class<actor> EntryActor;	// e.g. a splash (only if water zone)
var() class<actor> ExitActor;	// e.g. a splash (only if water zone)
var() float  FluidFriction;
var()		bool	bPainCausing;	 // Zone causes pain.
var()		bool	bMoveProjectiles;// this velocity zone should impart velocity to projectiles and effects
var()		bool	bBounceVelocity;	// this velocity zone should bounce actors that land in it
var			bool	bWaterVolume;
var	Info PainTimer;

// Distance Fog
var(VolumeFog) bool   bDistanceFog;	// There is distance fog in this physicsvolume.
var(VolumeFog) color DistanceFogColor;
var(VolumeFog) float DistanceFogStart;
var(VolumeFog) float DistanceFogEnd;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (bPainCausing)
		PainTimer = Spawn(class'VolumeTimer', self);
}

event ActorEnteredVolume(Actor Other);
event ActorLeavingVolume(Actor Other);

function CheckExplosive(Actor weapon, Pawn Instigator);

event PawnEnteredVolume(Pawn Other)
{
	if (Other.IsPlayerPawn())
		TriggerEvent(Event,Other, Other);
}

event PawnLeavingVolume(Pawn Other)
{
	if (Other.IsPlayerPawn())
		UntriggerEvent(Event,Other, Other);
}

/*
TimerPop
damage touched actors if pain causing.
since PhysicsVolume is static, this function is actually called by a volumetimer
*/
function TimerPop(VolumeTimer T)
{
	local actor A;

	if (T == PainTimer)
	{
		if (!bPainCausing)
			return;

		ForEach TouchingActors(class'Actor', A)
			CausePainTo(A);
	}
}

function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
{
	// turn zone damage on and off
	if (DamagePerSec != 0)
	{
		bPainCausing = !bPainCausing;
		if (bPainCausing && (PainTimer == None))
			PainTimer = spawn(class'VolumeTimer', self);
	}
}

event touch(Actor Other)
{
	Super.Touch(Other);
	if (bMoveProjectiles && (ZoneVelocity != vect(0,0,0)))
	{
		if (Other.Physics == PHYS_Projectile)
			Other.Velocity += ZoneVelocity;
	}
	if (bPainCausing)
	{
		CausePainTo(Other);
	}
}

event untouch(Actor Other)
{
	if (bWaterVolume)
		PlayExitSplash(Other);
}

function PlayExitSplash(Actor Other)
{
	local float SplashSize;
	local actor splash;

	splashSize = FClamp(0.003 * Other.Mass, 0.1, 1.0);
	if (ExitSound != None)
		PlaySound(ExitSound, SLOT_SFX);
	if (ExitActor != None)
	{
		splash = Spawn(ExitActor); 
		if (splash != None)
			splash.SetDrawScale(splashSize);
	}
}

function CausePainTo(Actor Other)
{
	local float depth;
	local Pawn P;

	// FIXMEZONE figure out depth of actor, and base pain on that!!!
	depth = 1;
	P = Pawn(Other);

	if (DamagePerSec > 0)
	{
		Other.TakeDamage(int(DamagePerSec * depth), None, Location, vect(0,0,0), vect(0,0,0), DamageType); 
		if ((P != None) && (P.Controller != None))
			P.Controller.PawnIsInPain(self);
	}	
	else
	{
		if ((P != None) && (P.Health < P.Default.Health))
		P.Health = Min(P.Default.Health, P.Health - depth * DamagePerSec);
	}
}

defaultproperties
{
    Gravity=(X=0.000000,Y=0.000000,Z=-1500.000000)
    GroundFriction=8.000000
    TerminalVelocity=2500.000000
    FluidFriction=0.300000
}