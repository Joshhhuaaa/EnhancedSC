//=============================================================================
// The moving brush class.
// This is a built-in Unreal class and it shouldn't be modified.
// Note that movers by default have bNoDelete == true.  This makes movers and their default properties
// remain on the client side.  If a mover subclass has bNoDelete = false, then its default properties must
// be replicated
//=============================================================================
class Mover extends Actor
	native;

// How the mover should react when it encroaches an actor.
var() enum EMoverEncroachType
{
	ME_StopWhenEncroach,	// Stop when we hit an actor.
	ME_ReturnWhenEncroach,	// Return to previous position when we hit an actor.
   	ME_CrushWhenEncroach,   // Crush the poor helpless actor.
   	ME_IgnoreWhenEncroach,  // Ignore encroached actors.
} MoverEncroachType;

// How the mover moves from one position to another.
var() enum EMoverGlideType
{
	MV_MoveByTime,			// Move linearly.
	MV_GlideByTime,			// Move with smooth acceleration.
} MoverGlideType;

// What classes can bump trigger this mover
var() enum EBumpType
{
	BT_PlayerBump,		// Can only be bumped by player.
	BT_PawnBump,		// Can be bumped by any pawn
	BT_AnyBump,			// Can be bumped by any solid actor
} BumpType;

//-----------------------------------------------------------------------------
// Keyframe numbers.
var() byte       KeyNum;           // Current or destination keyframe.
var byte         PrevKeyNum;       // Previous keyframe.
var() const byte NumKeys;          // Number of keyframes in total (0-3).
var() const byte WorldRaytraceKey; // Raytrace the world with the brush here.
var() const byte BrushRaytraceKey; // Raytrace the brush here.

//-----------------------------------------------------------------------------
// Movement parameters.
var() float      MoveTime;         // Time to spend moving between keyframes.
var() float      StayOpenTime;     // How long to remain open before closing.
var() float      OtherTime;        // TriggerPound stay-open time.
var() int        EncroachDamage;   // How much to damage encroached actors.

//-----------------------------------------------------------------------------
// Mover state.
var() bool       bTriggerOnceOnly; // Go dormant after first trigger.
var() bool       bSlave;           // This brush is a slave.
var() bool		 bUseTriggered;		// Triggered by player grab
var() bool		 bDamageTriggered;	// Triggered by taking damage
var() bool       bDynamicLightMover; // Apply dynamic lighting to mover.
var() name       PlayerBumpEvent;  // Optional event to cause when the player bumps the mover.
var() name       BumpEvent;			// Optional event to cause when any valid bumper bumps the mover.
var   actor      SavedTrigger;      // Who we were triggered by.
var() float		 DamageThreshold;	// minimum damage to trigger
var	  int		 numTriggerEvents;	// number of times triggered (count down to untrigger)
var	  Mover		 Leader;			// for having multiple movers return together
var	  Mover		 Follower;
var() name		 ReturnGroup;		// if none, same as tag
var() float		 DelayTime;			// delay before starting to open

// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce  - All audio stuff modified in this file are UBI MODIFS!!!
// ***********************************************************************************************
//-----------------------------------------------------------------------------
// Audio.
var(MoverSounds) sound        OpeningSound;			  // When start opening.
var(MoverSounds) sound        OpenedSound;			  // When finish opening
var(MoverSounds) Array<Sound> OpeningSoundEvents;     // Events to handle the zone change
var(MoverSounds) sound        OpeningStealthSound;			 // When start opening; stealth mode
var(MoverSounds) Array<Sound> OpeningStealthSoundEvents;     // Events to handle the zone change; stealth mode
var(MoverSounds) sound        ClosedSound;			  // When finish closing.
var(MoverSounds) Array<Sound> ClosedSoundEvents;      // Events to handle the zone change
var(MoverSounds) sound        ClosingSound;			  // Useful only for sliding doors
var(MoverSounds) sound        LockedSound;			  // When the door is locked
var(MoverSounds) ESoundSlot   SoundType;			  // Type of the sounds played (for transitions)
var(Door)	     float  	  DoorNoiseRadius;
var int iSoundNb;
var() bool       bQuietMover; //when set to true, the mover won't make AI Noise
// ***********************************************************************************************
// * END UBI MODIF mlaforce
// ***********************************************************************************************

//-----------------------------------------------------------------------------
// Internal.
var vector       KeyPos[8];
var rotator      KeyRot[8];
var vector       BasePos, OldPos, OldPrePivot, SavedPos;
var rotator      BaseRot, OldRot, SavedRot;
var           float       PhysAlpha;       // Interpolating position, 0.0-1.0.
var           float       PhysRate;        // Interpolation rate per second.

// AI related
var       NavigationPoint  myMarker;
var		  bool			bOpening, bDelaying, bClientPause;
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dkalina (22 Nov 2001)
// * Purpose : adding bClosing so NPCs can detect when a door is on the way shut
// ***********************************************************************************************
var		  bool			bClosing;	// on its way to a closed position (opposite of bOpening);
// ***********************************************************************************************
// * END UBI MODIF 
// * dkalina (22 Nov 2001)
// ***********************************************************************************************
var		  bool			bClosed;	// mover is in closed position, and no longer moving
var		  bool			bPlayerOnly;
var		  bool			bSteatlh;

// for client side replication
var		vector			SimOldPos;
var		int				SimOldRotPitch, SimOldRotYaw, SimOldRotRoll;
var		vector			SimInterpolate;
var		vector			RealPosition;
var     rotator			RealRotation;
var		int				ClientUpdate;

/* StartInterpolation()
when this function is called, the actor will start moving along an interpolation path
beginning at Dest
*/	
function StartInterpolation()
{
	GotoState('');
	bInterpolating = true;
	SetPhysics(PHYS_None);
}

function Timer()
{
	if (Velocity != vect(0,0,0))
	{
		bClientPause = false;
		return;		
	}
	RealPosition = Location;
	RealRotation = Rotation;
}

//-----------------------------------------------------------------------------
// Movement functions.

event vector GetBasePos()
{
	if (Base == None)
		return BasePos;
	else
		return Base.ToWorld(SavedPos);
}


// Interpolate to keyframe KeyNum in Seconds time.
final function InterpolateTo(byte NewKeyNum, float Seconds)
{
	NewKeyNum = Clamp(NewKeyNum, 0, ArrayCount(KeyPos) - 1);
	if (NewKeyNum == PrevKeyNum && KeyNum != PrevKeyNum)
	{
		// Reverse the movement smoothly.
		PhysAlpha = 1.0 - PhysAlpha;
		OldPos	  = GetBasePos() + KeyPos[KeyNum];
		OldRot    = BaseRot + KeyRot[KeyNum];
	}
	else
	{
		// Start a new movement.
		OldPos    = Location;
		OldRot    = Rotation;
		PhysAlpha = 0.0;
	}

	// Setup physics.
	SetPhysics(PHYS_MovingBrush);
	bInterpolating   = true;
	PrevKeyNum       = KeyNum;
	KeyNum			 = NewKeyNum;
	PhysRate         = 1.0 / FMax(Seconds, 0.005);

	ClientUpdate++;
	SimOldPos = OldPos;
	SimOldRotYaw = OldRot.Yaw;
	SimOldRotPitch = OldRot.Pitch;
	SimOldRotRoll = OldRot.Roll;
	SimInterpolate.X = 100 * PhysAlpha;
	SimInterpolate.Y = 100 * FMax(0.01, PhysRate);
	SimInterpolate.Z = 256 * PrevKeyNum + KeyNum;
}

// Set the specified keyframe.
final function SetKeyframe(byte NewKeyNum, vector NewLocation, rotator NewRotation)
{
	KeyNum         = Clamp(NewKeyNum, 0, ArrayCount(KeyPos) - 1);
	KeyPos[KeyNum] = NewLocation;
	KeyRot[KeyNum] = NewRotation;
}

// Interpolation ended.
event KeyFrameReached()
{
	local byte OldKeyNum;

	OldKeyNum  = PrevKeyNum;
	PrevKeyNum = KeyNum;
	PhysAlpha  = 0;
	ClientUpdate--;

	// If more than two keyframes, chain them.
	if (KeyNum > 0 && KeyNum < OldKeyNum)
	{
		// Chain to previous.
		InterpolateTo(KeyNum - 1,MoveTime);
	}
	else if (KeyNum < NumKeys - 1 && KeyNum > OldKeyNum)
	{
		// Chain to next.
		InterpolateTo(KeyNum + 1, MoveTime);
	}
	else
	{
		// Finished interpolating.
		if (ClientUpdate == 0)
		{
			RealPosition = Location;
			RealRotation = Rotation;
		}
	}
}

//-----------------------------------------------------------------------------
// Mover functions.

// Notify AI that mover finished movement
function FinishNotify()
{
	local Controller C;

	for (C = Level.ControllerList; C != None; C = C.nextController)
		if ((C.Pawn != None) && (C.PendingMover == self))
			C.MoverFinished();
}

// Handle when the mover finishes closing.
function FinishedClosing()
{
	// Update sound effects.
	local int iSoundNb;
// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************
	PlaySound(ClosedSound, SLOT_SFX); 
	if (ClosedSoundEvents.Length != 0)
	{
        for (iSoundNb = 0; iSoundNb < ClosedSoundEvents.Length; iSoundNb++)
        {
            PlaySound(ClosedSoundEvents[iSoundNb], SoundType);
        }
    }
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************
	
	// Notify our triggering actor that we have completed.
	if (SavedTrigger != None)
		SavedTrigger.EndEvent();
	SavedTrigger = None;
	Instigator = None;
	If (MyMarker != None)
		MyMarker.MoverClosed();
	bClosing = false;				// UBI MODIF
	bClosed = true;
	FinishNotify(); 
}

// Handle when the mover finishes opening.
function FinishedOpening()
{
	bOpening = false;	// UBI MODIF - if we are finished opening FUCKING TURN THE FLAG OFF

	PlaySound(OpenedSound, SLOT_SFX); 
	
	// Trigger any chained movers.
	TriggerEvent(Event, Self, Instigator);

	If (MyMarker != None)
		MyMarker.MoverOpened();
	FinishNotify();
}

// Open the mover.
function DoOpen()
{
	bClosing = false;   // UBI MODIF
	bOpening = true;
	bDelaying = false;
	FlushRequests();
	InterpolateTo(1, MoveTime);
}

// Close the mover.
function DoClose()
{
	bClosing = true;	// UBI MODIF
	bOpening = false;
	bDelaying = false;
	InterpolateTo(Max(0,KeyNum - 1), MoveTime);
// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************
	PlaySound(ClosingSound, SLOT_SFX);
// ***********************************************************************************************
// * END UBI MODIF mlaforce
// ***********************************************************************************************
	UntriggerEvent(Event, self, Instigator);
}

//-----------------------------------------------------------------------------
// Engine notifications.

// When mover enters gameplay.
function BeginPlay()
{
	local rotator R;

	RealPosition = Location;
	RealRotation = Rotation;

	// Init key info.
	Super.BeginPlay();
	KeyNum         = Clamp(KeyNum, 0, ArrayCount(KeyPos) - 1);
	PhysAlpha      = 0.0;

	// Set initial location.
	Move(BasePos + KeyPos[KeyNum] - Location);

	// Initial rotation.
	SetRotation(BaseRot + KeyRot[KeyNum]);
}

// Immediately after mover enters gameplay.
function PostBeginPlay()
{
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
/*	local mover M;

	// Initialize all slaves.
	if (!bSlave)
	{
		foreach DynamicActors(class 'Mover', M, Tag)
		{
			if (M.bSlave)
			{
				M.GotoState('');
				M.SetBase(Self);
			}
		}
	}

	if (Leader == None)
	{	
		Leader = self;
		ForEach DynamicActors(class'Mover', M)
			if ((M != self) && (M.ReturnGroup == ReturnGroup))
			{
				M.Leader = self;
				M.Follower = Follower;
				Follower = M;
			}
	}
*/
	Leader = self;

	Super.PostBeginPlay();
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************
}

function MakeGroupStop()
{
	// Stop moving immediately.
	bInterpolating = false;
	GotoState(, '');

	if (Follower != None)
		Follower.MakeGroupStop();
}

function MakeGroupReturn(Actor Other)
{
	// Abort move and reverse course.
	bInterpolating = false;
	if (KeyNum < PrevKeyNum)
		GotoState(, 'Open');
	else
		GotoState(, 'Close');

	if (Follower != None)
		Follower.MakeGroupReturn(self);
}
		
// Return true to abort, false to continue.
function bool EncroachingOn(actor Other)
{
	if ((Pawn(Other) != None) && (Pawn(Other).Controller == None))
	{
		Other.TakeDamage(10000, None, Other.Location, vect(0,0,0), vect(0,0,0), class'Crushed');
		return false;
	}

	// Damage the encroached actor.
	if (EncroachDamage != 0)
		Other.TakeDamage(EncroachDamage, Instigator, Other.Location, vect(0,0,0), vect(0,0,0), class'Crushed');

	// Stop, return, or whatever.
	if (Other.bIsGameplayObject && Other.bIsProjectile)
	{
		// Will get the Bump and ignore the encroachment
		Other.Bump(self);
		return false;
	}
	else if (MoverEncroachType == ME_StopWhenEncroach)
	{
		Leader.MakeGroupStop();
		return true;
	}
	else if (MoverEncroachType == ME_ReturnWhenEncroach)
	{
		Leader.MakeGroupReturn(self);
		return true;
	}
	else if (MoverEncroachType == ME_CrushWhenEncroach)
	{
		// Kill it.
		Other.TakeDamage(2000, None, Other.Location, vect(0,0,0), Velocity, None);
		return false;
	}
	else if (MoverEncroachType == ME_IgnoreWhenEncroach)
	{
		// Ignore it.
		return false;
	}
}

// When bumped by player.
function Bump(actor Other, optional int Pill)
{
	local pawn  P;

	P = Pawn(Other);
	if (bUseTriggered && (P != None) && !P.IsHumanControlled() && P.IsPlayerPawn())
	{
		Trigger(P,P);
		P.Controller.WaitForMover(self);
	}	
	if ((BumpType != BT_AnyBump) && (P == None))
		return;
	if ((BumpType == BT_PlayerBump) && !P.IsPlayerPawn())
		return;
	TriggerEvent(BumpEvent, self, P);

	if ((P != None) && P.IsPlayerPawn())
		TriggerEvent(PlayerBumpEvent, self, P);
}

// When damaged
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, vector HitNormal, 
						Vector momentum, class<DamageType> damageType, optional int PillTag) // UBI MODIF - Additional parameter
{
	if (bDamageTriggered && (Damage >= DamageThreshold))
		self.Trigger(self, instigatedBy);
}

//========================================================================
// Master State for OpenTimed mover states (for movers that open and close)

state OpenTimedMover
{
	function DisableTrigger();
	function EnableTrigger();

Open:
	bClosed = false;
	DisableTrigger();
	if (DelayTime > 0)
	{
		bDelaying = true;
		Sleep(DelayTime);
	}

	DoOpen();

// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************
	if (!bSteatlh)
	{
		if (!bClosing)
		{
		AddSoundRequest(OpeningSound, SLOT_SFX, 0.2f);
		if (!bQuietMover && SavedTrigger != None && SavedTrigger.bIsPlayerPawn)
			MakeNoise(DoorNoiseRadius, NOISE_DoorOpening);
			
			if (OpeningSoundEvents.Length != 0)
			{
				for (iSoundNb = 0; iSoundNb < OpeningSoundEvents.Length; iSoundNb++)
				{
					AddSoundRequest(OpeningSoundEvents[iSoundNb], SoundType, 0.2f);
				}
			}
		}
	}
	else
	{
		PlaySound(OpeningStealthSound, SLOT_SFX);

		if (OpeningStealthSoundEvents.Length != 0)
	{
			for (iSoundNb = 0; iSoundNb < OpeningStealthSoundEvents.Length; iSoundNb++)
        {
			    PlaySound(OpeningSoundEvents[iSoundNb], SoundType);
		    }
        }
    }

// ***********************************************************************************************
// * END UBI MODIF mlaforce
// ***********************************************************************************************

	FinishInterpolation();
	FinishedOpening();
	Sleep(StayOpenTime);
	if (bTriggerOnceOnly)
		GotoState('');
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	EnableTrigger();
}

// Open when stood on, wait, then close.
state() StandOpenTimed extends OpenTimedMover
{
	function Attach(actor Other)
	{
		local pawn  P;

		P = Pawn(Other);
		if ((BumpType != BT_AnyBump) && (P == None))
			return;
		if ((BumpType == BT_PlayerBump) && !P.IsPlayerPawn())
			return;
		if ((BumpType == BT_PawnBump) && (Other.Mass < 10))
			return;
		SavedTrigger = None;
		GotoState('StandOpenTimed', 'Open');
	}

	function DisableTrigger()
	{
		Disable('Attach');
	}

	function EnableTrigger()
	{
		Enable('Attach');
	}
}

// Open when bumped, wait, then close.
state() BumpOpenTimed extends OpenTimedMover
{
	function Bump(actor Other, optional int Pill)
	{
		if ((BumpType != BT_AnyBump) && (Pawn(Other) == None))
			return;
		if ((BumpType == BT_PlayerBump) && !Pawn(Other).IsPlayerPawn())
			return;
		if ((BumpType == BT_PawnBump) && (Other.Mass < 10))
			return;
		Global.Bump(Other, Pill);
		SavedTrigger = None;
		Instigator = Pawn(Other);
		Instigator.Controller.WaitForMover(self);
		GotoState('BumpOpenTimed', 'Open');
	}

	function DisableTrigger()
	{
		Disable('Bump');
	}

	function EnableTrigger()
	{
		Enable('Bump');
	}
}

// When triggered, open, wait, then close.
state() TriggerOpenTimed extends OpenTimedMover
{
	function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
	{
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if (SavedTrigger != None)
			SavedTrigger.BeginEvent();
		GotoState('TriggerOpenTimed', 'Open');
	}

	function DisableTrigger()
	{
		Disable('Trigger');
	}

	function EnableTrigger()
	{
		Enable('Trigger');
	}
}

//=================================================================
// Other Mover States

// Toggle when triggered.
state() TriggerToggle
{
	function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
	{
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if (SavedTrigger != None)
			SavedTrigger.BeginEvent();
		if (KeyNum == 0 || KeyNum < PrevKeyNum)
			GotoState('TriggerToggle', 'Open');
		else
			GotoState('TriggerToggle', 'Close');
	}
Open:
	bClosed = false;
	if (DelayTime > 0)
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();

	FinishInterpolation();
	FinishedOpening();
	if (SavedTrigger != None)
		SavedTrigger.EndEvent();
	Stop;
Close:		
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

// Open when triggered, close when get untriggered.
state() TriggerControl
{
	function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
	{
		numTriggerEvents++;
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if (SavedTrigger != None)
			SavedTrigger.BeginEvent();
		GotoState('TriggerControl', 'Open');
	}
	function UnTrigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
	{
		numTriggerEvents--;
		if (numTriggerEvents <=0)
		{
			numTriggerEvents = 0;
			SavedTrigger = Other;
			Instigator = EventInstigator;
			SavedTrigger.BeginEvent();
			GotoState('TriggerControl', 'Close');
		}
	}

	function BeginState()
	{
		numTriggerEvents = 0;
	}

Open:
	bClosed = false;
	if (DelayTime > 0)
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();

// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************
	AddSoundRequest(OpeningSound, SLOT_SFX, 0.2f);
	if (!bQuietMover)
		MakeNoise(DoorNoiseRadius, NOISE_DoorOpening);

	if (OpeningSoundEvents.Length != 0)
	{
        for (iSoundNb = 0; iSoundNb < OpeningSoundEvents.Length; iSoundNb++)
        {
            AddSoundRequest(OpeningSoundEvents[iSoundNb], SoundType, 0.2f);
        }
    }
// ***********************************************************************************************
// * END UBI MODIF mlaforce
// ***********************************************************************************************

	FinishInterpolation();
	FinishedOpening();
	SavedTrigger.EndEvent();
	if (bTriggerOnceOnly)
		GotoState('');
	Stop;
Close:		
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

// Start pounding when triggered.
state() TriggerPound
{
	function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
	{
		numTriggerEvents++;
		SavedTrigger = Other;
		Instigator = EventInstigator;
		GotoState('TriggerPound', 'Open');
	}
	function UnTrigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
	{
		numTriggerEvents--;
		if (numTriggerEvents <= 0)
		{
			numTriggerEvents = 0;
			SavedTrigger = None;
			Instigator = None;
			GotoState('TriggerPound', 'Close');
		}
	}
	function BeginState()
	{
		numTriggerEvents = 0;
	}

Open:
	bClosed = false;
	if (DelayTime > 0)
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();

// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************
	AddSoundRequest(OpeningSound, SLOT_SFX, 0.2f);
	if (!bQuietMover)
		MakeNoise(DoorNoiseRadius, NOISE_DoorOpening);

	if (OpeningSoundEvents.Length != 0)
	{
        for (iSoundNb = 0; iSoundNb < OpeningSoundEvents.Length; iSoundNb++)
        {
            AddSoundRequest(OpeningSoundEvents[iSoundNb], SoundType, 0.2f);
        }
    }
// ***********************************************************************************************
// * END UBI MODIF mlaforce
// ***********************************************************************************************

	FinishInterpolation();
	Sleep(OtherTime);
Close:
	DoClose();
	FinishInterpolation();
	Sleep(StayOpenTime);
	if (bTriggerOnceOnly)
		GotoState('');
	if (SavedTrigger != None)
		goto 'Open';
}

//-----------------------------------------------------------------------------
// Bump states.


// Open when bumped, close when reset.
state() BumpButton
{
	function Bump(actor Other, optional int Pill)
	{
		if ((BumpType != BT_AnyBump) && (Pawn(Other) == None))
			return;
		if ((BumpType == BT_PlayerBump) && !Pawn(Other).IsPlayerPawn())
			return;
		if ((BumpType == BT_PawnBump) && (Other.Mass < 10))
			return;
		Global.Bump(Other, Pill);
		SavedTrigger = Other;
		Instigator = Pawn(Other);
		Instigator.Controller.WaitForMover(self);
		GotoState('BumpButton', 'Open');
	}
	function BeginEvent()
	{
		bSlave = true;
	}
	function EndEvent()
	{
		bSlave     = false;
		Instigator = None;
		GotoState('BumpButton', 'Close');
	}
Open:
	bClosed = false;
	Disable('Bump');
	if (DelayTime > 0)
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();

// ***********************************************************************************************
// * BEGIN UBI MODIF mlaforce
// ***********************************************************************************************
	AddSoundRequest(OpeningSound, SLOT_SFX, 0.2f);
	if (!bQuietMover)
		MakeNoise(DoorNoiseRadius, NOISE_DoorOpening);

	if (OpeningSoundEvents.Length != 0)
	{
        for (iSoundNb = 0; iSoundNb < OpeningSoundEvents.Length; iSoundNb++)
        {
            AddSoundRequest(OpeningSoundEvents[iSoundNb], SoundType, 0.2f);
        }
    }
// ***********************************************************************************************
// * END UBI MODIF mlaforce
// ***********************************************************************************************

	FinishInterpolation();
	FinishedOpening();
	if (bTriggerOnceOnly)
		GotoState('');
	if (bSlave)
		Stop;
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Bump');
}

defaultproperties
{
    MoverEncroachType=ME_ReturnWhenEncroach
    MoverGlideType=MV_MoveByTime
    NumKeys=2
    MoveTime=1.000000
    StayOpenTime=4.000000
    DoorNoiseRadius=350.000000
    bClosed=true
    bNoDelete=true
    bAcceptsProjectors=true
    Physics=PHYS_MovingBrush
    InitialState="BumpOpenTimed"
    bShadowCast=true
    CollisionRadius=160.000000
    CollisionHeight=160.000000
    bCollideActors=true
    bBlockPlayers=true
    bBlockActors=true
    bBlockProj=true
    bBlockBullet=true
    bBlockCamera=true
    bBlockNPCShot=true
    bBlockNPCVision=true
    bIsMover=true
    bEdShouldSnap=true
    bPathColliding=true
}