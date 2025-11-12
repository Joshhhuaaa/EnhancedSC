//=============================================================================
// Pawn, the base class of all actors that can be controlled by players or AI.
//
// Pawns are the physical representations of players and creatures in a level.  
// Pawns have a mesh, collision, and physics.  Pawns can take damage, make sounds, 
// and hold weapons and other inventory.  In short, they are responsible for all 
// physical interaction between the player or AI and the world.
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Pawn extends Actor 
	abstract
	native
	placeable;

#exec Texture Import File=Textures\Pawn.pcx Name=S_Pawn Mips=Off MASKED=1 NOCONSOLE

//-----------------------------------------------------------------------------
// Pawn variables.

var Controller Controller;

// Physics related flags.
var bool		bIsWalking;			// currently walking (can't jump, affects animations)
var bool		bWantsToCrouch;		// if true crouched (physics will automatically reduce collision height to CrouchHeight)
var const bool	bIsCrouched;		// set by physics to specify that pawn is currently crouched
var const bool	bIsStuck;			// stuck in collision
var	const bool	bIsDog;

var const bool	bTryToUncrouch;		// when auto-crouch during movement, continually try to uncrouch
var() bool		bCanCrouch;			// if true, this pawn is capable of crouching
var const bool	bReducedSpeed;		// used by movement natives
var	bool		bCanJump;			// movement capabilities - used by AI
var	bool 		bCanWalk;
var	bool		bAvoidLedges;		// don't get too close to ledges
var	bool		bStopAtLedges;		// if bAvoidLedges and bStopAtLedges, Pawn doesn't try to walk along the edge at all
var	bool		bUpdateEyeheight;	// if true, UpdateEyeheight will get called every tick
var const bool	bNoVelocityUpdate;	// used by C++ physics
var	bool		bCanFallWalk;	// Can go into falling when walking
var(AI) bool	bDontPossess;		// if true, Pawn won't be possessed at game start

var bool bPhysicsAnimUpdate;	
var bool bWasCrouched;
var bool bWasWalking;
var bool bWasOnGround;
var bool bInitializeAnimation;

// AI basics.
var 	byte	Visibility;			//How visible is the pawn? 0 = invisible, 128 = normal, 255 = highly visible 
var		float	DesiredSpeed;
var		float	MaxDesiredSpeed;

var(Display) name         AnimSequence;  // Animation sequence we're playing.
var(Display) float        AnimFrame;     // Current animation frame, 0.0 to 1.0.
var(Display) float        AnimRate;      // Animation rate in frames per second, 0 = none, negative = velocity scaled.

var const float	AvgPhysicsTime;		// Physics updating time monitoring (for AI monitoring reaching destinations)
var		float	MeleeRange;			// Max range for melee attack (not including collision radii)
var NavigationPoint Anchor;			// current nearest path;
var const float	UncrouchTime;		// when auto-crouch during movement, continually try to uncrouch once this decrements to zero

// Movement.
var float   GroundSpeed;    // The maximum ground speed.
var float   AirSpeed;		// The maximum flying speed.
var float	AccelRate;		// max acceleration rate
var float	JumpZ;      	// vertical acceleration w/ jump
var float   AirControl;		// amount of AirControl available to the pawn
var float	WalkingPct;		// pct. of running speed that walking speed is
var float	MaxFallSpeed;	// max speed pawn can land without taking damage (also limits what paths AI can use)
var float	WalkingRatio;
var float	SoundWalkingRatio;


// Player info.
var	string			OwnerName;		// Name of owning player (for save games, coop)
var float      		BaseEyeHeight; 	// Base eye height above collision center.
var float        	EyeHeight;     	// Current eye height, adjusted for stairs.
var	const vector	Floor;			// Normal of floor pawn is standing on (only used by PHYS_Spider and PHYS_Walking)
var float			SplashTime;		// time of last splash
var float			CrouchHeight;	// CollisionHeight when crouching
var float			CrouchRadius;	// CollisionRadius when crouching
var float			OldZ;			// Old Z Location - used for eyeheight smoothing
var PhysicsVolume	HeadVolume;		// physics volume of head
var(AI) int			Health;         // Health: 100 = normal maximum
var class<DamageType> ReducedDamageType; // which damagetype this creature is protected from (used by AI)

var localized  string MenuName; // Name used for this pawn type in menus (e.g. player selection) 

// shadow decal
var Projector Shadow;

var class<AIController> ControllerClass;	// default class to use when pawn is controlled by AI

var EPhysics OldPhysics;
var int OldRotYaw;			// used for determining if pawn is turning
var vector OldAcceleration;

var Actor ControlledActor;		// Actor being controlled by Pawn e.g. KVehicle, WeaponTurret

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
var				float			LinearSpeed;					// Linear speed for use in physLinear

// Used for MoveToDestination
var		vector					m_locationStart;
var		vector					m_locationEnd;
var		rotator					m_orientationStart;
var		rotator					m_orientationEnd;

// Echelon specific reach flags
var(AI)  name		m_GroupTag;				// name (tag) of group we wish to join
var		 bool		m_validFence;
var(Nav) bool		bCanUseRetinalScanner;
var(Nav) bool		bCanUseKeyPad;
var(Nav) bool		bCanClimbLadders;		// from unreal - allowing it to be designer specified
var(Nav) bool		bCanOpenDoors;

// Don't merge the following - i use them for my own purposes now..
var(Hearing) bool	bLOSHearing;			// can hear sounds from line-of-sight sources (which are close enough to hear)
											// bLOSHearing = true is like UT/Unreal hearing
var(Hearing) bool	bSameZoneHearing;		//can hear any sound in same zone (if close enough to hear)
var(Hearing) bool	bAdjacentZoneHearing;	// can hear any sound in adjacent zone (if close enough to hear)
var(Hearing) bool	bMuffledHearing;		// can hear sounds through walls (but muffled - sound distance increased to double plus 4x the distance through walls
var(Hearing) bool	bAroundCornerHearing;	// Hear sounds around one corner (slightly more expensive, and bLOSHearing must also be true)

var(Hearing) float	HearingThreshold;		// max distance at which ANY noise can be heard (DAK ECHELON)
var(Hearing) float	TeammateHearingBoost;	// boost for loudness of players on same team as this pawn

var Sound NPCComm;

// For Displaying Noise Radii in-game
var vector LastNoiseLocation;
var float  LastNoiseRadius;

//Used for GeomatricEvent detection
var()	vector		m_NormalArmsZone;
var()	float		m_NormalArmsRadius;
var()	vector		m_CrouchedArmsZone;
var()	float		m_CrouchedArmsRadius;
var()	vector		m_LedgeGrabArmsZone;
var()	float		m_LedgeGrabArmsRadius;
var()	vector		m_HandOverHandArmsZone;
var()	float		m_HandOverHandArmsRadius;
var()	vector		m_NarrowLadderArmsZone;
var()	float		m_NarrowLadderArmsRadius;
var()	vector		m_PipeArmsZone;
var()	float		m_PipeArmsRadius;
var()	vector		m_ZipLineArmsZone;
var()	float		m_ZipLineArmsRadius;
var()	vector		m_FenceArmsZone;
var()	float		m_FenceArmsRadius;
var()	vector		m_NormalFeetZone;
var()	float		m_NormalFeetRadius;
var()	vector		m_CrouchedFeetZone;
var()	float		m_CrouchedFeetRadius;
var()	vector		m_PoleArmsZone;
var()	float		m_PoleArmsRadius;
var		vector		m_CurrentArmsZone;
var		float		m_CurrentArmsRadius;
var		vector		m_CurrentFeetZone;
var		float		m_CurrentFeetRadius;
var		bool		m_LegdeInFeet;
var		bool		m_LegdePushing;
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************


/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	if ((Controller == None) || Controller.bIsPlayer)
		Destroy();
	else
		Super.Reset();
}

/* PossessedBy()
 Pawn is possessed by Controller
*/
function PossessedBy(Controller C)
{
	Controller = C;
	if (C.IsA('PlayerController'))
		BecomeViewTarget();

	SetOwner(Controller);
	Eyeheight = BaseEyeHeight;
}

function UnPossessed()
{	
	SetOwner(None);
	Controller = None;
}

function BecomeViewTarget()
{
	bUpdateEyeHeight = true;
}

function SetWalking(bool bNewIsWalking)
{
	if (bNewIsWalking != bIsWalking)
	{
		bIsWalking = bNewIsWalking;
	}
}

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string T;
	Super.DisplayDebug(Canvas, YL, YPos);

	Canvas.SetDrawColor(255,255,255);

	Canvas.SetPos(4,YPos);

	T = "Floor "$Floor$" DesiredSpeed "$DesiredSpeed$" Crouched "$bIsCrouched$" Try to uncrouch "$UncrouchTime;
	Canvas.DrawText(T);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText("EyeHeight "$Eyeheight$" BaseEyeHeight "$BaseEyeHeight$" Physics Anim "$bPhysicsAnimUpdate);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.SetDrawColor(255,0,0);

	if (Controller == None)
	{
		Canvas.DrawText("NO CONTROLLER");
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}
	else
		Controller.DisplayDebug(Canvas,YL,YPos);
}
		 		
//***************************************
// Interface to Pawn's Controller

// return true if controlled by a Player (AI or human)
function bool IsPlayerPawn()
{
	return ((Controller != None) && Controller.bIsPlayer);
}

// return true if controlled by a real live human
function bool IsHumanControlled()
{
	return (PlayerController(Controller) != None);
}

function rotator GetViewRotation()
{
	if (Controller == None)
		return Rotation;
	else
		return Controller.Rotation;
}

function SetViewRotation(rotator NewRotation)
{
	if (Controller != None)
		Controller.SetRotation(NewRotation);
}

function bool PressingFire()
{
	return ((Controller != None) && (Controller.bFire != 0));
}

final function bool PressingAltFire()
{
	return ((Controller != None) && (Controller.bAltFire != 0));
}

function bool LineOfSightTo(actor Other)
{
	return ((Controller != None) && Controller.LineOfSightTo(Other));
} 

function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
{
	if (Controller != None)
		Controller.Trigger(Other, EventInstigator);
}

//***************************************

function bool CanTrigger(Trigger T)
{
	return true;
}

event FellOutOfWorld()
{
	Health = -1;
	SetPhysics(PHYS_None);
	Died(None, class'Crushed', Location);
}

/* ShouldCrouch()
Controller is requesting that pawn crouch
*/
function ShouldCrouch(bool Crouch)
{
	bWantsToCrouch = Crouch;
}

// Stub events called when physics actually allows crouch to begin or end
// use these for changing the animation (if script controlled)
event EndCrouch(float HeightAdjust)
{
	EyeHeight += HeightAdjust;
	BaseEyeHeight = Default.BaseEyeHeight;
}

event StartCrouch(float HeightAdjust)
{
	EyeHeight -= HeightAdjust;
	BaseEyeHeight = 0.8 * CrouchHeight;
}

function RestartPlayer();
function AddVelocity(vector NewVelocity)
{
	if (Physics == PHYS_Walking)
		SetPhysics(PHYS_Falling);
	if ((Velocity.Z > 380) && (NewVelocity.Z > 0))
		NewVelocity.Z *= 0.5;
	Velocity += NewVelocity;
}

function KilledBy(pawn EventInstigator)
{
	local Controller Killer;

	Health = 0;
	if (EventInstigator != None)
		Killer = EventInstigator.Controller;
	Died(Killer, class'Crushed', Location);
}

function ClientReStart()
{
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	BaseEyeHeight = Default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
}

//==============
// Encroachment
event bool EncroachingOn(actor Other)
{
	if ((Other.Brush != None) || (Brush(Other) != None))
		return true;
		
	if (((Controller == None) || !Controller.bIsPlayer) && (Pawn(Other) != None))
		return true;
		
	return false;
}

//Base change - if new base is pawn or decoration, damage based on relative mass and old velocity
// Also, non-players will jump off pawns immediately
function JumpOffPawn()
{
	Velocity += (100 + CollisionRadius) * VRand();
	Velocity.Z = 200 + CollisionHeight;
	SetPhysics(PHYS_Falling);
	Controller.SetFall();
}

singular event BaseChange()
{
	local float decorMass;

	if (bInterpolating)
		return;
	if ((base == None) && (Physics == PHYS_None))
		SetPhysics(PHYS_Falling);
	else if (Pawn(Base) != None)
	{
		Base.TakeDamage((1 - Velocity.Z / 400) * Mass / Base.Mass, Self,Location,vect(0,0,1), 0.5 * Velocity , class'Crushed');
		JumpOffPawn();
	}
}

event UpdateEyeHeight(float DeltaTime)
{
	local float smooth;
	local float OldEyeHeight;

	if (Controller == None)
	{
		EyeHeight = 0;
		return;
	}

	// smooth up/down stairs
	smooth = FMin(1.0, 10.0 * DeltaTime);
	If (Physics == PHYS_Walking)
	{
		OldEyeHeight = EyeHeight;
		EyeHeight = FClamp((EyeHeight - Location.Z + OldZ) * (1 - smooth) + BaseEyeHeight * smooth,
							-0.5 * CollisionHeight,
							CollisionHeight + FClamp((OldZ - Location.Z), 0.0, MAXSTEPHEIGHT)); 
	}
	else
	{
		EyeHeight = EyeHeight * (1 - smooth) + BaseEyeHeight * smooth;
	}
	Controller.AdjustView(DeltaTime);
}

/* EyePosition()
Called by PlayerController to determine camera position in first person view.  Returns
the offset from the Pawn's location at which to place the camera
*/
function vector EyePosition()
{
	return EyeHeight * vect(0,0,1);
}

//=============================================================================

event Destroyed()
{
	if (Shadow != None)
		Shadow.Destroy();
	if (Controller != None)
		Controller.PawnDied();

	Super.Destroyed();
}

//=============================================================================
//
// Called immediately before gameplay begins.
//
event PreBeginPlay()
{
	Super.PreBeginPlay();
	Instigator = self;
	DesiredRotation = Rotation;
	if (bDeleteMe)
		return;

	if (DrawScale != Default.Drawscale)
	{
		SetCollisionSize(CollisionRadius * DrawScale / Default.DrawScale, CollisionHeight * DrawScale / Default.DrawScale);
		Health = Health * DrawScale / Default.DrawScale;
	}

	if (BaseEyeHeight == 0)
		BaseEyeHeight = 0.8 * CollisionHeight;
	EyeHeight = BaseEyeHeight;

	if (menuname == "")
		menuname = GetItemName(string(class));
}

event PostBeginPlay()
{
	Super.PostBeginPlay();
	SplashTime = 0;
	EyeHeight = BaseEyeHeight;
	OldRotYaw = Rotation.Yaw;

	// automatically add controller to pawns which were placed in level
	// NOTE: pawns spawned during gameplay are not automatically possessed by a controller
	if (Level.bStartup && (Health > 0) && !bDontPossess)
	{
		if ((ControllerClass != None) && (Controller == None))
			Controller = spawn(ControllerClass);
		if (Controller != None)
			Controller.Possess(self);
	}
}

function SetMesh()
{
	mesh = default.mesh;
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (bDeleteMe)
		return; //already destroyed

	Health = Min(0, Health);
	Level.Game.Killed(Killer, Controller, self, damageType);

	if (Killer != None)
		TriggerEvent(Event, self, Killer.Pawn);
	else
		TriggerEvent(Event, self, None);

	Velocity.Z *= 1.3;
	PlayDying(DamageType, HitLocation);
	if (Level.Game.bGameEnded)
		return;
}

event Falling()
{
	//SetPhysics(PHYS_Falling); //Note - physics changes type to PHYS_Falling by default
	if (Controller != None)
		Controller.SetFall();
}

//=============================================================================
// Animation interface for controllers

/* PlayXXX() function called by controller to play transient animation actions 
*/
event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	GotoState('Dying');
	if (bPhysicsAnimUpdate)
	{
		SetPhysics(PHYS_Falling);
	}
}

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************

native(1104) final function bool CheckFence(out vector normal, out actor wall, vector pos);
native(1115) final function Crouch(bool bTest);
native(1116) final function UnCrouch(bool bTest);
native(1121) final function bool IsCrouch();

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

defaultproperties
{
    bCanWalk=true
    Visibility=128
    DesiredSpeed=1.000000
    MaxDesiredSpeed=1.000000
    AvgPhysicsTime=0.100000
    GroundSpeed=600.000000
    AirSpeed=600.000000
    AccelRate=2048.000000
    JumpZ=420.000000
    AirControl=0.050000
    MaxFallSpeed=1200.000000
    BaseEyeHeight=64.000000
    EyeHeight=54.000000
    CrouchHeight=40.000000
    CrouchRadius=34.000000
    Health=100
    ControllerClass=Class'AIController'
    bSameZoneHearing=true
    HearingThreshold=2800.000000
    bAcceptsProjectors=true
    DrawType=DT_Mesh
    Texture=Texture'S_Pawn'
    SoundRadiusSaturation=350.000000
    CollisionRadius=34.000000
    CollisionHeight=78.000000
    bCollideActors=true
    bCollideWorld=true
    bCollideSB=true
    bBlockPlayers=true
    bBlockActors=true
    bBlockProj=true
    bBlockBullet=true
    bBlockNPCShot=true
    bBlockNPCVision=true
    bSideFadeEffect=true
    HeatIntensity=1.000000
    bIsPawn=true
    RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)
    bRotateToDesired=true
    bDirectional=true
}