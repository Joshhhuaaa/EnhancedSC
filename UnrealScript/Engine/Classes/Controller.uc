//=============================================================================
// Controller, the base class of players or AI.
//
// Controllers are non-physical actors that can be attached to a pawn to control 
// its actions.  PlayerControllers are used by human players to control pawns, while 
// AIControFllers implement the artificial intelligence for the pawns they control.  
// Controllers take control of a pawn using their Possess() method, and relinquish 
// control of the pawn by calling UnPossess().
//
// Controllers receive notifications for many of the events occuring for the Pawn they 
// are controlling.  This gives the controller the opportunity to implement the behavior 
// in response to this event, intercepting the event and superceding the Pawn's default 
// behavior.  
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Controller extends Actor
	native
	abstract;

var Pawn Pawn;

// Ticked pawn timers
var		float		SightCounter;		// Used to keep track of when to check player visibility

var		const float		FovAngle;			// X field of view angle in degrees, usually 90.
var		bool        bIsPlayer;			// Pawn is a player or a player-bot.

//AI flags
var const bool		bLOSflag;			// used for alternating LineOfSight traces
var		bool		bAdvancedTactics;	// used during movement between pathnodes
var		bool		bCanOpenDoors;
var		bool		bCanDoSpecial;
var const bool		bAdjusting;
var		bool		bNoTact;
var     bool		bTacticalDir;		// used during movement between pathnodes
var		bool		bPreparingMove;		// set true while pawn sets up for a latent move
var		bool		bControlAnimations;	// take control of animations from pawn (don't let pawn play animations based on notifications)
var		bool		bMoveToWalking;

var vector AdjustLoc;

// Input buttons.
var input byte
	bCrawl, bRun, bDuck, bFire, bAltFire;

var const	Controller		nextController; // chained Controller list

var		float 		Stimulus;			// Strength of stimulus - Set when stimulus happens
var     float		Skill;				// skill, scaled by game difficulty (add difficulty to this value)	
var		float		TacticalOffset;		// C++ timer used if bAdvancedTactics is true (to call UpdateTactics)


// Navigation AI
var 	float		MoveTimer;
var 	Actor		MoveTarget;		// set by movement natives
var		vector	 	Destination;	// set by Movement natives
var	 	vector		FocalPoint;		// set by Movement natives
var		Actor		Focus;

var		vector		LastSeenPos; 	// enemy position when I last saw enemy (auto updated if EnemyNotVisible() enabled)
var		vector		LastSeeingPos;	// position where I last saw enemy (auto updated if EnemyNotVisible enabled)
var		float		LastSeenTime;
var	 	Pawn    	Enemy;
var		Actor		Target;
var		Mover		PendingMover;	// mover pawn is waiting for to complete its move
var		Actor		GoalList[4];	// used by navigation AI - list of intermediate goals

var NavigationPoint home;			// set when begin play, used for retreating and attitude checks
var	 	float		MinHitWall;		// Minimum HitNormal dot Velocity.Normal to get a HitWall from the physics
 
// Route Cache for Navigation
var Actor RouteCache[16];
var Actor	RouteGoal; //final destination for current route
var float	RouteDist;	// total distance for current route

var(AI) enum EAttitude  //order in decreasing importance
{
	ATTITUDE_Fear,		//will try to run away
	ATTITUDE_Hate,		// will attack enemy
	ATTITUDE_Frenzy,	//will attack anything, indiscriminately
	ATTITUDE_Threaten,	// animations, but no attack
	ATTITUDE_Ignore,
	ATTITUDE_Friendly,
	ATTITUDE_Follow 	//accepts player as leader
} AttitudeToPlayer;	//determines how creature will react on seeing player (if in human form)

var class<Pawn> PawnClass;	// class of pawn to spawn (for players)

var NavigationPoint StartSpot;  // where player started the match

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
var	name	NextState; //for queueing states
var name	NextLabel; //for queueing states

function			TransitionEnd();
event		int		GetTurnSpeed();
function			GetReactionAnim(out name Anim, out name AnimB, out float BlendAlpha, optional eReactionAnimGroup ReactionGroup);

// ***********************************************************************************************
// * END UBI MODIF 
// * dkalina (5 Feb 2002)
// ***********************************************************************************************


// Latent Movement.
//Note that MoveTo sets the actor's Destination, and MoveToward sets the
//actor's MoveTarget.  Actor will rotate towards destination unless the optional ViewFocus is specified.

native(500) final latent function MoveTo( vector NewDestination, optional Actor ViewFocus, optional float speed);
native(502) final latent function MoveToward(actor NewTarget, optional Actor ViewFocus, optional float speed);
native(508) final latent function FinishRotation();

// native AI functions
/* LineOfSightTo() returns true if any of several points of Other is visible 
  (origin, top, bottom)
*/
native(514) final function bool LineOfSightTo(actor Other); 

/* CanSee() similar to line of sight, but also takes into account Pawn's peripheral vision
*/
native(533) final function bool CanSee(Pawn Other); 

//Navigation functions - return the next path toward the goal
native(518) final function Actor FindPathTo(vector aPoint, optional bool bClearPaths);
native(517) final function Actor FindPathToward(actor anActor, optional bool bClearPaths);
native final function Actor FindPathTowardNearest(class<NavigationPoint> GoalClass);
native(525) final function NavigationPoint FindRandomDest(optional bool bClearPaths);

native(522) final function ClearPaths();
native(523) final function vector EAdjustJump(float BaseZ, float XYSpeed);

//Reachable returns whether direct path from Actor to aPoint is traversable
//using the current locomotion method
native(521) final function bool pointReachable(vector aPoint);
native(520) final function bool actorReachable(actor anActor);

/* PickWallAdjust()
Check if could jump up over obstruction (only if there is a knee height obstruction)
If so, start jump, and return current destination
Else, try to step around - return a destination 90 degrees right or left depending on traces
out and floor checks
*/
native(526) final function bool PickWallAdjust(vector HitNormal);

/* WaitForLanding()
latent function returns when pawn is on ground (no longer falling)
*/
native(527) final latent function WaitForLanding();

native(529) final function AddController();
native(530) final function RemoveController();

// Pick best pawn target
native(531) final function pawn PickTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart);
native(534) final function actor PickAnyTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart);

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
native(1100) final latent function MoveToDestination(float speed, optional bool walking);
function vector GetTargetPosition();
function NotifyFiring();					// notifies controller when weapon is going off
function NotifyOutOfAmmo();					// notifies controller when weapon is out of ammo
function NotifyReloading();					// notifies controller when weapon is reloading
function bool MayReload()
{
	return true;
}
event MoveToDestinationFailed();
event MoveToDestinationSucceeded();

function Vector AdjustTarget( Vector ShotDirection )
{
	return ShotDirection;
}

event PlayerCalcEye( out vector EyeLocation, out rotator EyeRotation );

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


// Force end to sleep
native function StopWaiting();

event MayFall(); //return true if allowed to fall - called by engine when pawn is about to fall

/* DisplayDebug()
list important controller attributes on canvas
*/
function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	Canvas.DrawText("PAWN "$Pawn);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	if ( Pawn == None )
	{
		Super.DisplayDebug(Canvas,YL,YPos);
		return;
	}
	Canvas.DrawText("CONTROLLER "$GetItemName(string(self)) $ "   STATE: " $ GetStateName());
	YPos += YL;
	Canvas.SetPos(4,YPos);
}

/* Reset() 
reset actor to initial state
*/
function Reset()
{
	Super.Reset();
	Enemy = None;
	LastSeenTime = 0;
	StartSpot = None;
}

/* AIHearSound()
Called when AI controlled pawn would hear a sound.  Default AI implementation uses MakeNoise() 
interface for hearing appropriate sounds instead
*/
// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce 
// ***********************************************************************************************
event AIHearSound ( 
	actor Actor,  
	sound S 
);
// ***********************************************************************************************
// * END UBI MODIF mlaforce 
// ***********************************************************************************************

function Possess(Pawn aPawn)
{
	aPawn.PossessedBy(self);
	Pawn = aPawn;
	// preserve Pawn's rotation initially for placed Pawns
	FocalPoint = Pawn.Location + 512*vector(Pawn.Rotation);
	Restart();
}

/* PawnDied()
 unpossess a pawn (because pawn was killed)
 */
function PawnDied()
{
	if ( Pawn != None )
	{
		SetLocation(Pawn.Location);
		Pawn.UnPossessed();
	}
	Pawn = None;
	PendingMover = None;
	if ( bIsPlayer )
		GotoState('Dead'); // can respawn
	else
		Destroy();
}

function Restart()
{
	Enemy = None;
}

event LongFall(); // called when latent function WaitForLanding() doesn't return after 4 seconds

// notifications of pawn events (from C++)
// if return true, then pawn won't get notified 
event bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume);
event bool NotifyHeadVolumeChange(PhysicsVolume NewVolume);
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dchabot (7 Dec 2001)
// ***********************************************************************************************
event bool NotifyLanded(vector HitNormal, Actor HitActor);
// ***********************************************************************************************
// * END UBI MODIF 
// * dchabot (7 Dec 2001)
// ***********************************************************************************************
event bool NotifyHitWall(vector HitNormal, actor Wall);
event bool NotifyBump(Actor Other, optional int Pill);
event NotifyHitMover(vector HitNormal, mover Wall);

// notifications called by pawn in script
function NotifyTakeHit(pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * ATurcotte (MTL) (15 Dec 2001)
// ***********************************************************************************************
	if ( (instigatedBy != None) && (instigatedBy != pawn) )
		damageAttitudeTo(instigatedBy, Damage, damageType);
// ***********************************************************************************************
// * END UBI MODIF 
// * ATurcotte (MTL) (15 Dec 2001)
// ***********************************************************************************************
} 

function SetFall();	//about to fall
function PawnIsInPain(PhysicsVolume PainVolume);	// called when pawn is taking pain volume damage

event PreBeginPlay()
{
	AddController();
	Super.PreBeginPlay();
	if ( bDeleteMe )
		return;

	SightCounter = 0.2 * FRand();  //offset randomly 
}

event Destroyed()
{
	RemoveController();

	Super.Destroyed();
}

/* AdjustView() 
by default, check and see if pawn still needs to update eye height
(only if some playercontroller still has pawn as its viewtarget)
Overridden in playercontroller
*/
function AdjustView( float DeltaTime )
{
	local Controller C;

	for ( C=Level.ControllerList; C!=None; C=C.NextController )
		if ( C.IsA('PlayerController') && (PlayerController(C).ViewTarget == Pawn) )
			return;

	Pawn.bUpdateEyeHeight =false;
	Pawn.Eyeheight = Pawn.BaseEyeheight;
}
			
function ClientGameEnded()
{
	GotoState('GameEnded');
}

//***************************************************************
// AI related

event PrepareForMove(NavigationPoint Goal, ReachSpec Path);
function WaitForMover(Mover M);
function MoverFinished();

event HearNoise( float Loudness, Actor NoiseMaker);
event SeePlayer( Pawn Seen );	// called when a player (bIsPlayer==true) pawn is seen
event SeeMonster( Pawn Seen );	// called when a non-player (bIsPlayer==false) pawn is seen

event UpdateTactics(); // for advanced tactics
event EnemyNotVisible();

function NotifyKilled(Controller Killer, Controller Killed, pawn Other)
{
	if ( Enemy == Other )
		Enemy = None;
}

function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType,optional int PillTag); //UBI MODIF - Additional parameter

function ServerReStartPlayer();

// **********************************************
// Controller States

State Dead
{
ignores SeePlayer, HearNoise, KilledBy;

	function PawnDied() {}

	function ServerReStartPlayer()
	{
		Level.Game.RestartPlayer(self);
	}
}

state GameEnded
{
ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, Falling, TakeDamage;

	function BeginState()
	{
		if ( Pawn != None )
		{
			Pawn.bPhysicsAnimUpdate = false;
			Pawn.StopAnimating();
			Pawn.SetCollision(false,false,false);
			Pawn.Velocity = vect(0,0,0);
			Pawn.SetPhysics(PHYS_None);
			Pawn.UnPossessed();
		}
		if ( !bIsPlayer )
			Destroy();
	}
}

defaultproperties
{
    FovAngle=90.000000
    MinHitWall=-0.600000
    AttitudeToPlayer=ATTITUDE_Hate
    bHidden=true
    bHiddenEd=true
}