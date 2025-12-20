//=============================================================================
// EPawn
//
// Base Pawn class for Echelon Gametype.
// Defines all high-level animation sequencing and management.
// Also:
//      Will take damage and die.
//      Will draw currently selected item / misc. attachments.
//=============================================================================

class EPawn extends Pawn
	abstract
	native;

#exec OBJ LOAD FILE=..\Animations\ENPC.ukx
#exec OBJ LOAD FILE=..\Sounds\FisherFoley.uax
#exec OBJ LOAD FILE=..\Sounds\Special.uax
#exec OBJ LOAD FILE=..\Sounds\Exspetsnaz.uax
#exec OBJ LOAD FILE=..\Sounds\Electronic.uax
#exec OBJ LOAD FILE=..\Sounds\GunCommon.uax
#exec OBJ LOAD FILE=..\Sounds\Dog.uax
#exec OBJ LOAD FILE=..\Sounds\ThrowObject.uax
#exec OBJ LOAD FILE=..\Sounds\GenericLife.uax
#exec OBJ LOAD FILE=..\StaticMeshes\EMeshCharacter.usx

const TWOOVERPI = 0.63661977236758134307553505349006;

struct SAnimBlend
{
	var Name	m_forward;
	var Name	m_backward;
	var Name	m_forwardLeft;
	var Name	m_backwardLeft;
	var Name	m_forwardRight;
	var Name	m_backwardRight;
};	// m_backwardLeft and m_backwardRight can be none

var()	vector					m_HoistOffset;
var()	vector					m_HoistCrOffset;
var()	vector					m_HoistFeetOffset;
var()	vector					m_HoistFeetCrOffset;
var()	vector					m_HoistWaistOffset;
var()	vector					m_HoistWaistCrOffset;
var()	vector					m_NLOutTopAnimOffset;
var()	vector					m_POutTopAnimOffset;

var		bool					bDontBlink;
var		bool					m_topHanging;
var		bool					m_topClimbing;
var		bool					m_slipeRight;
var		eClimbingHand			m_climbingUpperHand;
var		vector					m_geoTopPoint;
var		vector					m_geoBottomPoint;
var		vector					m_geoNormal;
var		vector					m_prevPos;	// start location at begin of frame
var		rotator					m_prevRot;	// start location at begin of frame
var		rotator					m_inertRot;

var		EchelonGameInfo			eGame;
// NPC movement

var				Rotator					DesiredTurnTarget;				// rotator towards which we are trying to turn 

var(Debug)		MoveFlags				BaseMoveFlags;					// currently selected set of animations for movement

// Used by AIController / EAIController
var				ESatchel				Satchel;
var(AI)			array<class<EInventoryItem> >	SatchelItems;
var(AI)			Array<class<EInventoryItem> >	DynInitialInventory;
var(AI)			float					AccuracyDeviation;				// scales the possible deviation of weapon fire - for EAIController
var(AI)			float					PlayerFarDistance;				// for EAIController events during alert state - typically will lead to change in strategy
var(AI)			float					PlayerCloseDistance;
var(AI)			float					PlayerVeryCloseDistance;
var				Actor					DefendActor;					// for internal usage
var(AI)			Name					DefendActorTag;					// get base actor to defend based on this tag
var(AI)			float					DefendDistance;					// never go further than this distance from
var(AI)			float					MinSearchTime;					// minimum time NPC will typically stay in search behavior
var				float					TimeOfDeath;					// need to know how long has the body been dead
var(AINoise)	float					DyingGaspRadius;				// distance dying gasp noise will reach - maybe depend on weapon?
var(AINoise)	float					KnockedGaspRadius;				// " for when NPC is knocked out
var(AINoise)	float					ElectrocutedGaspRadius;			// " for when NPC is electrocuted
var(AI)			float					IntuitionTime;					// how long AI will continue to "know" where player is after losing him ..
var(AI)			float					TimeBeforePlayerCanHide;		// how long after AI loses player that AI can see player regardless of shadow
var(AI)			float					PlayerCanHideDistance;			// how far player must move from last known location in order to be able to hide from me
var(AI)			float					Laziness_DefaultState;			// how often will we skip search points in s_Default?
var(AI)			float					Laziness_AwareState;			// how often will we skip search points in s_Aware?
var(AI)			float					Laziness_AlertState;			// ditto (s_alert)
var(AI)			float					DefuseMinePercentage;			// what are the odds of defusing a wall mine?
var(AI)			float					RandomStopPercentage;			// what % of the time will we stop at a patrol point and play a random anim?
var(AI)			float					ExpiredTime;					// Time we want them to stay in attack

var(AI)			float					FocusDistanceMin;				// minimum distance we'll look at a focus point
var(AI)			float					FocusDistanceMax;				// maximum distance we'll look at a focus point
var(AI)			float					MinTurnThreshold;				// minimum # of rotator units (yaw) before we have to turn

// keep bools packed

var(Movement)   bool					bNoBlending;					// can we use blending in our movement?
var(Movement)   bool					bNoAiming;						// can we use aiming during our movement?
var(Movement)	bool					bNoPersonality;					// don't automatically blend personality animations
var(Movement)	bool					bNoFocusPoints;					// don't focus switch based on focus points
var(Movement)	bool					bNoFocusSwitching;				// don't procedurally switch focus
var				bool					bNoTurningAnims;				// when true, do not play turning animations when pawn is rotating

var				bool					bCoverPeeking;					// NPC flag that indicates that Pawn is peeking from a Cover point
var				bool					bWasCarried;

var(AI)			bool					MayUseGunLight;
var(AI)			bool					ForceFlashLight;
var(AI)			bool					bSendAIEvents;
var(AI)			bool					bKeepNPCAlive;
var(AI)			bool					bDisableAI;
var(Nav)		bool					bAvoidPlayer;					// should NPC allow AvoidCollisions to check for player (for friendly NPC's typically)
var(AI)			bool					bDontPlayDeathAnim;
var(AI)			bool					bDontPlayDeathSitAnim;
var(AI)			bool					bFollowTarget;
var				bool					bFallToDeath;					// set to true when death animation requires pawn to fall before dying
var(AI)			bool					bNoPickupInteraction;			// disallow pickup interactions on this pawn
var(AI)			bool					bNoUnconsciousRevival;			// disallow NPC to NPC revival of this pawn if unconscious
var(AI)			bool					bCanBeGrabbed;
var(AI)			bool					bSniper;						// The NPC is a Sniper
var				bool					bBodyDetected;
var				bool					bKilledByPlayer;
var             bool                    bKnockedByPlayer;
var(AI)         bool                    bDoesntBroadcast;
var(AI)         bool                    bNoBlood;                       // This NPC does not emit blood when shot at
var(AI)         bool                    bJustHides;                     // Used for bureaucrats; does not reach alarms or armed NPCs, goes straight to Hide behavior
var(AI)         bool                    bNeverMarkAsChanged;            // Used for NPCs not to be added to Changed actor list
var(AI)         bool                    bDontPlayDamageAnim;            // Used for scripted NPCs which we do not want to play damage animation on TakeDamage()
var(AI)			bool					bDrunk;
var(AI)			bool					bDontSendNoise;
var				bool					bIsAttachedToAnimObject;		// is NPC attached to an EAnimatedObject?
var(Debug)		bool					bAlwaysFrag;					// always fresh, always fragtastic
var				bool					bPitchBlack;
var(AI)		    bool					bIgnorePitchBlack;              // This NPC doesn't worry (slow down) when in pitch black conditions 
var             bool                    bIsHotBlooded;                   // This NPC will fire at Sam when using BARK_LookingForYou
var(Interaction)bool                    bForceNoInteraction;
var(AI)         bool					bCanWhistle;
var(AI)         bool					bDontCheckChangedActor;
var(AI)         bool					bDyingDude;						// for guy under pill of burning wood and dying teck in 222

var				EFlashLight				FlashLight;

var				name					ADeathNeutral;
var(AI)			name					DesignerDeathAnim;


var				float					PrevMoveBlendAlpha;				// previous movement blend alpha -- used for transition between movement and waiting
var				float					RandomizedAnimRate;				// initialized for slightly different animation playback in AI Pawns
var				vector					PreviousVelocity;
var				float					NextBlinkTime;

var(AI)			class<EPattern>			 BasicPatternClass;
var(AI)			EAlarmPanelObject        ForceAlarmPanelRun;			//if we want to force a NPC

var(Movement)	name					DesignerWalkAnim;				// if MOVE_DesignerWalk is specified, use this as the walk animation
var(Movement)	name					DesignerWaitAnim;				// if MOVE_DesignerWalk is specified, use this as the wait animation
var(Movement)	float					DesignerWalkSpeed;				// speed of walk animation (m/sec)

var(PostAttackAI)	bool					bUsePostAttackSetup;
var(PostAttackAI)	name					PostAttackPointTag;				// Point to GUARD after the NPC lost player
var(PostAttackAI)	name					PostAttackFocusTag;
var(PostAttackAI)	EchelonEnums.GoalType	PostAttackGoalType;				// Initial Goal : Type (guard / patrol recommended)
var(PostAttackAI)	name					PostAttackAnim;
var(PostAttackAI)	float					fHideTime;

// initial goal - not providing all possible fields here ..

enum EAIControllerState
{
	EAIS_Default,
	EAIS_Aware,
	EAIS_Alert,
	EAIS_Dead,
	EAIS_Unconscious
};

var(DefaultAI)	EAIControllerState		InitialAIState;
var(DefaultAI)	EchelonEnums.GoalType	InitialGoalType;				// Initial Goal : Type (guard / patrol recommended)
var(DefaultAI)	Name					InitialGoalTag;				
var(DefaultAI)	bool					InitialGoalFlag;
var(DefaultAI)	float					InitialGoalValue;
var(DefaultAI)	MoveFlags				InitialGoalMoveFlags;
var(DefaultAI)  MoveFlags				InitialGoalWaitFlags;
var(DefaultAI)	Vector					InitialGoalLocation;
var(DefaultAI)	Vector					InitialGoalFocus;
var(DefaultAI)	Sound					InitialGoalSound;
var(DefaultAI)	name					InitialGoalAnim;

var(Debug)		bool					bDebugWeapon;					// when true, NPC will never fire weapon - useful for watching NPC animation w/ weapon in place

// TODO : make this so that we know when the NPC will fire, just without sound or damage


//We can set a conversation interaction
var(Conversation) class<EPattern>		PatternClass;

var(Vision)     float					m_VisibilityConeAngle;          // Angle of NPC's visibility, in degrees
var(Vision)     float					m_VisibilityMaxDistance;        // Maximum distance at which an NPC can detect something
var(Vision)		float					m_VisibilityAngleVertical;		// Angle of NPC's visibility +/- the XY plane
var(Vision)		float					m_MaxPeripheralVisionDistance;  // how far maximum can we see discounting the vision cone?
var(Vision)		bool					bUseTransitionTable;

var(Hearing)	NoiseType				IgnoreGroupNoiseType;			// if we receive noise from our group, ignore any with type LESS THAN OR EQUAL to this value
var(Hearing)	NoiseType				IgnoreNPCNoiseType;				// ignore noises LESS THAN OR EQUAL to this if they come from other NPCs 
var(Hearing)	NoiseType				IgnoreAllNoiseType;				// ignore all noises up to this noise type


// the new Visibility Transition Tables
// each array corresponds to a transition type, the index corresponds to light value, and the value corresponds to distance
// the peripheral table specifies distances for 'surprise' transitions outside the standard visibility cone but inside whatever is defined as the characters periphery

var(Vision)		float					VisTable_Alert[5];
var(Vision)		float					VisTable_Investigate[5];
var(Vision)		float					VisTable_Surprised[5];
var(Vision)		float					VisTable_Peripheral[5];

// for visibility average
var float VisAverageArray[10];
var int	  CurrentVisIndex;

// Personality Anim tweaking vars -- min / max time before changing personality animation for blending, based on state

var(Personality)	float				PrsoUpdate_DefaultMin,
										PrsoUpdate_DefaultMax,
										PrsoUpdate_AwareMin,
										PrsoUpdate_AwareMax,
										PrsoUpdate_AlertMin,
										PrsoUpdate_AlertMax;

// Sound Variables

var(Smell)		float					SmellRadius;
var				int					    CurrentYawDiff; //for rotation
var				bool					bYawDiffSet;
var(AI)			bool					bSleeping;

var Sound GearSoundFall;
var bool  PlayGearSound;
var class<DamageType> LastDamageType;
var int TmpDamage;

enum SurfaceNoiseType
{
	SN_VeryQuiet,
	SN_Quiet,
	SN_Normal,
	SN_Loud,
	SN_VeryLoud
};

enum EBarkType
{
	BARK_Generic,
	BARK_HeardFoot,
	BARK_HeardGunShot,
	BARK_UnderFire,
	BARK_AnticipatingPain,
	BARK_GroupScatter,
	BARK_LightShot,
	BARK_LightsOut,
	BARK_NormalGreeting,
	BARK_InvestigationGreeting,
	BARK_Mystified,
	BARK_SeePlayer,
	BARK_SurprisedByPlayer,
	BARK_SeeSomethingMove,
	BARK_SeeHackedTurret,
	BARK_SeeWallMine,
	BARK_SeeBlood,
	BARK_SeeBrokenCamera,
	BARK_SeeCorpse,
	BARK_SeeUnconscious,
	BARK_BeingInterrogated,
	BARK_AboutToDie,
	BARK_BeenHit,
	BARK_DropHim,
	BARK_ShootHim,
	BARK_LostPlayer,
	BARK_SearchFailedPlayer,
	BARK_SearchFailedOther,
	BARK_PlayerKilled,
	BARK_CombArea,
	BARK_SendBackup,
	BARK_BeAware,
	BARK_DogHasScent,
	BARK_DogLostTrail,
	BARK_HitByBullet,
	BARK_HitElectric,
	BARK_KnockedOut,
	BARK_Cough,
	BARK_InFire,
	BARK_Dying,
	BARK_ChokeGrab,
	BARK_LookingForYou,
	BARK_RadioCancel,
    BARK_BegForLife
};

// all these structs correspond directly with the ESurfaceType enum in Texture.uc
// I use explicit names instead of index referencing for clarity when modifying properties in the editor
var(Sounds)		Sound			Sounds_Move;                //Main sound resource for walk, jump, run, etc...

var(Sounds)		Sound			Sounds_Barks;

var             Sound           Sounds_AttackMove;
var             Sound           Sounds_AttackGetDown;
var             Sound           Sounds_AttackStop;

var             EBarkType		Bark_Type;

// Pawn State
var		EInventory				FullInventory;
var		EGameplayObject			HandItem;				// item in hand (does not have to be a weapon)
var		EInventoryItem			PendingItem;			// transition is about to select this item.
var		EWeapon					CurrentWeapon;			// weapon presently equipped (will always match hand-item - doing this so we don't have to cast continually)
var		EGameplayObject			Chair;					// if we're sitting, this variable is set (can't point to EChair, but don't need to..)
var(AI)	Actor					ForceObjectOnGrab;		// Set this var. to go directly to this object in GrabMode

var		int						WeaponStance;			// 0 = nothing in hands, 1 = one handed weapon, 2 = 2-handed weapon, etc. -- for EQUIPPED weapons
var		int						WeaponHandedness;		// same as WeaponStance but stays the same throughout for the weapon we possess
var		bool					bIsAlert;				// TRUE = use alert state anims, FALSE = normal state anims
var		bool					bSneaking;				// Sam sneaking behind an enemy

// Bones
var		name					EyeBoneName;
var		name					UpperBodyBoneName;		// use this to blend over the upper body

// Clothes stuff
var(Accessories) StaticMesh		HatMesh;
var(Accessories) bool			bSmokingDude;
var(Accessories) bool			bCellDude;
var		EGameplayObject			Hat;
var		EGameplayObject			Cigaret;
var		EGameplayObject			Cellular;

// Weapon Stuff
var		vector					TargetLocation;			// position at which we are aiming (presently used only by player)

// blending
var(Movement)	int				YawTurnSpeed;			// used for player and for upper body rotations for NPC
var(Movement)	int				TurnSpeed_Default;		// specify different general turning speeds per AI state
var(Movement)	int				TurnSpeed_Aware;		
var(Movement)	int				TurnSpeed_Alert;		
var(Movement)	float			MaxAimAngle_Default;	// maximum angles for aiming by state
var(Movement)	float			MaxAimAngle_Aware;	
var(Movement)	float			MaxAimAngle_Alert;	

// Animation RESERVED Channel

const	BASEMOVEMENTCHANNEL		= 0;
const	BLENDMOVEMENTCHANNEL	= 1;
const	TURNLEFTCHANNEL			= 2;
const	TURNRIGHTCHANNEL		= 3;
const	REFPOSECHANNEL			= 4;
const	ACTIONCHANNEL			= 5;
const	PERSONALITYCHANNEL		= 6;


// animation names - set according to pawn state

var		SAnimBlend				ABlendMovement;

var		SAnimBlend				ABlendFence;
var		SAnimBlend				ABlendGrab;
var		SAnimBlend				ABlendSniping;
var		SAnimBlend				ABlendSnipingCrouch;

var		name					AStandUpR,
								AStandUpL,
								AStandUpF,
								ASitDownR,
								ASitDownL,
								ASitDownF,
								AWaitSitT,
								AWaitSitS;


var		name					AWait,
								AWaitIn,
								AWaitOut,
								AWaitLeft,
								AWaitRight,
								AWaitCrouch,
								AWaitCrouchIn,
								AWalk,
								AWalkCrouch,
								AJogg,
								AJoggCrouch,
								ATurnRight,
								ATurnRightCrouch,
								ATurnBRight,
								ATurnBLeft,
								ATurnLt,
								ATurnRt,
								AJumpForwardR,
								AJumpForwardL,
								AJumpStart,
								AFall,
								AFallQuiet,
								AFallFree,
								ALandHi,
								ALandLow,
								ALandQuiet,
								ALandAttack,
								APeekLeftBegin,
								APeekLeft,
								APeekRightBegin,
								APeekRight,
								ADamageHeadShotForward,
								ADamageHeadShotBack,
								ADamageChestForward,
								ADamageChestBack,
								ADamageChestLeft,
								ADamageChestRight,
								ADamageArmLeft,
								ADamageArmRight,
								ADamageLegLeft,
								ADamageLegRight,
								AHurtHandLeft,
								AHurtHandRight,
								AHurtFootLeft,
								AHurtFootRight,
								AStunBegin,
								AStunned,					// don't specify AStunned in subclasses - this is a looping anim for s_Stunned that can be variable
								AStunEnd,
								ACough,
								ADeathForward,
								ADeathBack,
								ADeathLeft,
								ADeathRight,
								ADeathDown,
								ADeathLadder,
								ADeathForwardNtrl,
								ADeathBackNtrl,
								ADeathLeftNtrl,
								ADeathRightNtrl,
								ASpasm1,
								ASpasm2,
								ASpasm3,
								ASpasm4,
								AFragForward,
								AFragBack,
								AFragLeft,
								AFragRight,
								ASearchBody,
								ASprayFire,
								APitchBlackF,
								APitchBlackL,
								APitchBlackR,
								APlaceWallMineBegin,
								APlaceWallMine,
								APlaceWallMineEnd,
								AReload,
								AReloadCrouch,
								ADoorOpenRt,
								ADoorOpenLt,
								ADoorTryOpenRt,
								ADoorTryOpenLt,
								ARetinalScanBegin,
								ARetinalScan,
								ARetinalScanEnd,
								ANLUpRight,
								ANLUpLeft,
								ANLOutBottomRight,
								ANLOutBottomLeft,
								ANLTopUpLeft,
								ANLTopUpRight,
								ANLInTop,
								ANLTopDownRight,
								ANLInBottom,
								ANLWaitLeft,
								ANLWaitRight,
								ANLWaitTop,
								ANLSlideDown,
								AFenceClimbWait,
								ARappelWait,
								ASplitWait,
								AGrabStart,
								AGrabWait,
								AGrabSqeeze,
								AGrabRetinalStart,
								AGrabRetinalWait,
								AGrabRetinalEnd,
								AGrabRelease,
								AGrabReleaseKnock,
								ARecover,
								AReviveBody,
								ACheckDeadBody,
								AThrowGrenade,
								AAlarmInteract,
								ALightSwitchInteract,
								ALookForward,
								ALookLeft,
								ALookRight,
								ALookDownwards,
								ALookUpwards,
								ALookBackwards,
								ARadioBegin,
								ARadio,
								ARadioEnd;
 

// for state s_Transition:

enum ETransitionNotifyType
{
	TRANN_None,
	TRANN_WeaponSelect,
	TRANN_WeaponAway,
	TRANN_ItemSelect
};

struct STransitionInfo
{
	var name					TransitionState;				// state name to transition to
	var name					ATransition;					// transition animation name
	var	name					ATransitionTarget;				// transition animation target
	var float					TransitionTime;					// how long to transition for, if not the length of the animation
	var float					TransitionTween;				// tween time during non-root motion transition
	var bool					bRootMotionTransition;			// does transition anim use root motion?
	var bool					bTransitionWithRotation;		// should we allowing turning when PlayWaitingBlend is called during s_Tran?	
	var bool					bBackwards;						// play animation backwards
	var ETransitionNotifyType	NotifyType;						// if transition handles a Notify, specify type here.
};

var Array<STransitionInfo> TransitionQueue;		// series of transitions to be played in First In First Out order by UpdateAnimationSet

var	bool	bInTransition;				// set when in the s_Transition state



var	Color						RelevantAmbientColor;
var Array<Actor>				RelevantLights;

var(AI) bool bHostile;                  // Used to know if we can shoot it or not

struct SampleBrightness4Bones
{
    var name BoneName;
    var float Brightness;
};

var() Array<SampleBrightness4Bones> PawnSampleBrightness;	

// PILL STUFF

const P_Head		= 1;
const P_LBody		= 2;
const P_LUpperArm	= 3;
const P_LForeArm	= 4;
const P_LHand		= 5;
const P_LThigh		= 6;
const P_LCalf		= 7;
const P_LFoot		= 8;
const P_RBody		= 9;
const P_RUpperArm	= 10;
const P_RForeArm	= 11;
const P_RHand		= 12;
const P_RThigh		= 13;
const P_RCalf		= 14;
const P_RFoot		= 15;
const P_MaxPills	= 15;

var	  int		InitialHealth;
var() float		DamageLookupTable[P_MaxPills];		// Damage attribution modifier table

// Goodies
var float	IdleTime;	// As soon as a Pawn begin waiting, set this time
var Emitter	BreathEmitter;		// When in cold zone, this get sets
var float	RollSpeed;
var bool	wasRolled;

// Lipsynch data
var bool    m_bLipsynchPlaying;
var INT     m_hLipSynchData;

// AmbientPain, Fire and burn
var float	AmbientDamagePerSeconds;
var float	AmbientDamageFromFire;
var float	ResidualAmbientDamage;
var array<EPawnFire>	BodyFlames;

// Foot print
var int		rightFootDirtyness;
var int		leftFootDirtyness;
var int		currentDirtynessFactor;

event bool IsTransitionQueueEmpty()
{
	if (TransitionQueue.Length == 0)
		return true;

	return false;
}

///////////////////////////////////////////////////////////
// FIRE FUNCTIONS /////////////////////////////////////////
///////////////////////////////////////////////////////////
function name GetFireBone(int i)
{
	switch (i)
	{
	case 0: 
		if (FRand() > 0.5)
			return 'B Spine1';
		else
			return 'B Neck';
		break;

	case 1:
		if (FRand() > 0.5)
			return 'B R Midarm';
		else
			return 'B R Forearm';
		break;

	case 2:
		if (FRand() > 0.5)
			return 'B L Midarm';
		else
			return 'B L Forearm';
		break;

	case 3:
		if (FRand() > 0.5)
			return 'B L Calf';
		else
			return 'B L Foot';
		break;

	case 4:
		if (FRand() > 0.5)
			return 'B R Calf';
		else
			return 'B R Foot';
		break;
	}
}

function CatchOnFire()
{
	local int i;
	for (i = BodyFlames.Length; i < 5; i++)
	{
		BodyFlames[i] = spawn(class'EPawnFire', self);
		AttachToBone(BodyFlames[i], GetFireBone(i));

		// Fire damage gives 4hp loss / sec
		AddAmbientDamage(,4);
	}
}

//------------------------------------------------------------------------
// Description		
//		AttenuationChances	1 is 100% chances of killing all flames
//		FlameToDelete		Number of flames that are killed .. no chance factor
//------------------------------------------------------------------------
function AttenuateFire(float AttenuationChances, optional int FlameToDelete)
{
	local int i;

	//log("AttenuateFire Len"@BodyFlames.Length@AttenuationChances@FlameToDelete);

	for (i = 0; i < BodyFlames.Length; i = i)
	{
		if (FRand() <= AttenuationChances || FlameToDelete > 0)
		{
			//Log("Killing Flame["$i$"]"); 
			BodyFlames[i].Kill();
			BodyFlames.Remove(i,1);

			FlameToDelete--;

			AddAmbientDamage(,-4);
		}
		else
			i++;
	}
	//Log(BodyFlames.Length$" left!");
}

//------------------------------------------------------------------------
// Description		
//		Turn on/off head light if Pawn can use it
//------------------------------------------------------------------------
event ToggleHeadLight(bool bTurnOn)
{
	if (!MayUseGunLight)
		return;

	// Only spawn it when wanted on
	if (FlashLight == None && bTurnOn)
	{
		FlashLight = spawn(class'EFlashLight', self);
		AttachToBone(FlashLight, 'LightBone');

		// YLA : Prevent a pawn to cast shadow in its own flashlight (ugly)
		DontAffectEchelonLighting[DontAffectEchelonLighting.Length] = FlashLight;
	}

	if (FlashLight != None)
		FlashLight.ToggleLight(bTurnOn);
}

///////////////////////////////////////////////////////////
// END OF FIRE FUNCTIONS //////////////////////////////////
///////////////////////////////////////////////////////////






// NATIVE FUNCTIONS 

native(1503) final function bool ReachedDestination(vector Direction, Actor GoalActor);
native(1537) final function ExitRootMotion(name TargetAnim);
native(1534) final function ForceAnimParams(int Channel, name AnimSequence, float AnimFrame, float AnimRate);						// TODO : Move to Actor?
native(1540) final function bool IsSequenceInCurrentAnim(name AnimSequence);														// TODO : Move to Actor?
native(1541) final function BlendAnims(int SourceChannel, name SourceAnim, float SourceTweenTime, 
									   int TargetChannel, name TargetAnim, float TargetTweenTime, float BlendAlpha);				// TODO : Move to Actor?
native(1546) final function bool IsPawnTalking();
native(1548) final function name ChooseDeathAnimation(int PillTag, vector momentum);
native(1173) final function name ChooseChairDeathAnimation(int PillTag, vector momentum);
native(1552) final function NavigationPoint GetAnchorForLocation(Vector oLocation);
native(1553) final function NavigationPoint GetAnchor();
native(1554) final function int ArePointsConnected(NavigationPoint Start, NavigationPoint End);

// aiming and stuff
native(1106) final function LookAt(eLookAtType type, vector viewDir, vector originalDir, float minHoriAngle, float maxHoriAngle, float minVertAngle, float maxVertAngle);
native(1108) final function AimAt(eAimAtType type, vector viewDir, vector originalDir, float minHoriAngle, float maxHoriAngle, float minVertAngle, float maxVertAngle);

native(1113) final function Recoil(vector aimDir, float RecoilStrength, float RecoilAngle, float alpha, float FadeIn, float FadeOut);

native(1126) final function RollPawn(int targetRoll);
native(1128) final function StartLipSynch(Sound _hSound);
native(1143) final function EyeBlink();


native(1145) final function RotateAroundZ(int YawAdd);


// OVERRIDEN FUNCTIONALITY
// Pawn functions we don't want to use - override here...
// Will probably want to remove from base Pawn class entirely in the future ..

event SpecialTick(float DeltaTime)
{
	local int DamageThisTick;
	local float CumulativeDamage;
	local class<DamageType> Type;
	local Pawn	Instigator;
	
	// If Npc is dead .. reduce HeatIntensity
	if (Health <= 0)
	{
		// Reduce body heat to 0
		if (HeatIntensity > 0)
			HeatIntensity -= deltaTime / 45.f/*seconds*/;
		else
			HeatIntensity = 0.f;
	}

	CumulativeDamage = AmbientDamagePerSeconds + AmbientDamageFromFire;
	if (AmbientDamageFromFire > 0)
	{
		Type = class'EBurned';
		Instigator = self;
	}
	else
		Type = class'EAmbientPain';

	// If no more ambient pain, reset and return
	if (CumulativeDamage == 0)
	{
		ResidualAmbientDamage = 0;
		return;
	}

	ResidualAmbientDamage += CumulativeDamage * DeltaTime;
	DamageThisTick = ResidualAmbientDamage;
	
	//Log(self$" SpecialTick ambientDam["$AmbientDamagePerSeconds$"] AmbientFire["$AmbientDamageFromFire$"] ResidualAmbientDamage["$ResidualAmbientDamage$"] DamageThisTick["$DamageThisTick$"]");

	if (DamageThisTick > 0)
	{
		ResidualAmbientDamage -= DamageThisTick;
		TakeDamage(DamageThisTick, Instigator, Vect(0,0,0), Vect(0,0,0), Vect(0,0,0), Type);
	}
}

function AddAmbientDamage(optional int Ambient, optional int Fire)
{
	AmbientDamagePerSeconds = Max(0, AmbientDamagePerSeconds + Ambient);
	AmbientDamageFromFire = Max(0, AmbientDamageFromFire + Fire);
}

event AnimEnd(int Channel) {}
function CheckWalkAnim(vector OldAccel) {}
function PlayDuck() {}
function PlayCrawling() {}
function PlayRising() {}
function HitWall(vector HitNormal, actor HitWall) {}
function TweenToWaiting(float tweentime) {}

event EndCrouch(float HeightAdjust)
{
	Super.EndCrouch(HeightAdjust);

	PlaySound(Sound'FisherFoley.Play_Fisher_CrouchToStandGear', SLOT_SFX);

	// Reset timer
	IdleTime = 0;

	if (Controller != None && Controller.bIsPlayer)
		EPlayerController(Controller).NotifyEndCrouch();
}

event StartCrouch(float HeightAdjust)
{
	Super.StartCrouch(HeightAdjust);

	PlaySound(Sound'FisherFoley.Play_Fisher_StandToCrouchGear', SLOT_SFX);

	// Reset timer
	IdleTime = 0;

	if (Controller != None && Controller.bIsPlayer)
		EPlayerController(Controller).NotifyStartCrouch();
}

singular event BaseChange()
{
	local EPawn npc;
	npc = EPawn(Base);

	if (npc == None)
		return;

	if (!npc.bIsPlayerPawn)
	{
		npc.TakeDamage(npc.Health / 2, self, npc.Location, vect(0,0,1), vect(0,0,-1), class'EKnocked', P_Head);
		SetPhysics(PHYS_Falling);
	}
	else
	{
		// New Base is Sam
		if (npc.Controller.GetStateName() == 's_NarrowLadder' ||
			npc.Controller.GetStateName() == 's_NarrowLadderSlideDown')
		{
			// Make Sam fall from ladder
			npc.m_topHanging = false;
			npc.m_topClimbing = false;
			EPlayerController(npc.Controller).JumpRelease();
			SetBase(None);
		}
		if (npc.Controller.GetStateName() != 's_Grab' &&
			npc.Controller.GetStateName() != 's_GrabTargeting' &&
			npc.Controller.GetStateName() != 's_Carry')
		{
			// Fall tru Sam
			SetPhysics(PHYS_Falling);
			Move(vect(0,0,-5));
		}

	}
}

function plog(coerce string S)
{
	log(Name $ " - " $ Controller.Name $ " -- STATE:  " $ GetStateName() $ " -- " $ S,,LAICONTROLLER);
}

//---------------------------------------[David Kalina - 10 Apr 2001]-----
// 
// Description
//		Initialization (pre-controller possession)
// 
//------------------------------------------------------------------------
function PreBeginPlay()
{
	ResetZones();

	FullInventory = spawn(class'EInventory', self);

	Super.PreBeginPlay();
}

function PostBeginPlay()
{
	local int i;

	// set up anims 
	InitAnims();

	BaseMoveFlags = InitialGoalMoveFlags;
	if (BaseMoveFlags == MOVE_NotSpecified)
		BaseMoveFlags = MOVE_WalkRelaxed;

	SwitchAnims();			
		
	Super.PostBeginPlay();

	m_climbingUpperHand = CHNONE;

	// Set Initial Health
	InitialHealth = Health;

	//
	// Accessories
	//

	// Hat
	if (HatMesh != None)
	{
		Hat = spawn(class'EHat', self);
		Hat.SetStaticMesh(HatMesh);
		EHat(Hat).Setup();
		AttachToBone(Hat, 'HatBone');
	}
	// Cigaret
	if (bSmokingDude)
	{
		Cigaret = spawn(class'EGameplayObject', self);
		Cigaret.SetStaticMesh(StaticMesh'EMeshCharacter.Cook.Cig');
		Cigaret.SetCollisionSize(1,1);
		Cigaret.SetCollision(false);
		Cigaret.bDamageable = false;
		AttachToBone(Cigaret, 'CigBone');
	}
	// Cellular
	if (bCellDude)
	{
		Cellular = spawn(class'EGameplayObject', self);
		Cellular.SetStaticMesh(StaticMesh'EMeshCharacter.Ivan.Cell');
		Cellular.SetCollisionSize(6,1);
		Cellular.SetCollision(false);
		Cellular.bDamageable = false;
		AttachToBone(Cellular, 'CellBone');
	}

	// Satchel
	LookUpSatchel();

	for (i = 0; i < 10; i++)
	{
		VisAverageArray[i] = 100;
	}

	SetPhysics(PHYS_Walking);
}

function LookUpSatchel()
{
	local array<EMemoryStick>	FoundMems;

	if (SatchelItems.Length > 0 || EchelonLevelInfo(Level).GetMemoryStick(FoundMems, self, true))
		Satchel = spawn(class'ESatchel', self);
}

//------------------------------------------------------------------------
// Description		
//		Do a Table lookup on the current Visibility Factor.
//		GetVisibilityFactor() will only compute if necessary for a given frame.
//		
//------------------------------------------------------------------------
event VisibilityRating GetActorVisibility()
{
	return VisibilityTableLookup(GetVisibilityFactor());
}

//------------------------------------------------------------------------
// Description		
//		Show actor stealth and lighting info
//------------------------------------------------------------------------
function show_lighting_debug_info(Canvas Canvas)
{
    local int i,offset_x,offset_y,inc_y;

	offset_x = 20;
	offset_y = 20;
	inc_y = 10;
	
	Canvas.Font = Canvas.ETextFont;
	Canvas.SetPos(offset_x, offset_y);			       
	Canvas.DrawText("Actor Visibility: " $ VisibilityTableLookup(VisibilityFactor),false);
	offset_y = offset_y + inc_y;
		
	Canvas.SetPos(offset_x, offset_y);
	Canvas.DrawText("Base Visibility: " $ VisibilityFactor,false);
	offset_y = offset_y + inc_y;
		    
	Canvas.SetPos(offset_x, offset_y);	
	Canvas.DrawText("Number of Light: " $ RelevantLights.Length,false);
	offset_y = offset_y + inc_y;
	
	Canvas.SetPos(offset_x, offset_y);	
	Canvas.DrawText("Ambient Light Color: R="$RelevantAmbientColor.R$" G="$RelevantAmbientColor.G$" B="$RelevantAmbientColor.B$" A=" $ RelevantAmbientColor.A,false);
	offset_y = offset_y + inc_y;

	for (i = 0;i < RelevantLights.Length;i++)
	{		  	    
	    Canvas.SetPos(offset_x, offset_y);
		Canvas.DrawText("Light Name: " $ RelevantLights[i].Name,false);
		offset_y = offset_y + inc_y;
	}

	offset_y = offset_y + inc_y;
	Canvas.SetPos(offset_x, offset_y);	
	Canvas.DrawText("Last Noise Radius: " $ LastNoiseRadius, false);
	offset_y = offset_y + inc_y;
}


//---------------------------------------[David Kalina - 22 Oct 2001]-----
// 
// Description
//		Return a wait cycle depending on the current MoveFlags.
//		Should be redefined in subclasses.
// 
//------------------------------------------------------------------------

event GetRandomWaitAnim(out name ReturnName)
{
	ReturnName = AWait;
}

function SetVolumeZone(bool bEntering, EVolume Volume)
{
	// Entering volume
	if (bEntering)
	{
		// Cold
		if (Volume.bColdZone && Health > 0)
		{
			if (BreathEmitter == None)
			{
				BreathEmitter = spawn(class'ESmokeBreath', self);
				AttachToBone(BreathEmitter, 'mouthbone');
			}

			BreathEmitter.AutoDestroy						= false;
			BreathEmitter.Emitters[0].ParticlesPerSecond	= BreathEmitter.Emitters[0].default.ParticlesPerSecond;
			BreathEmitter.Emitters[0].RespawnDeadParticles	= true;
		}

		// Water
		if (Volume.bLiquid)
		{
			// If liquid zone .. kill fire emitter
			AttenuateFire(1.0);

			// When entering ocean
			if (Volume.bDyingZone)
			{
				StopAllVoicesActor();
				if (!IsPlaying(Sound'FisherFoley.Play_FisherFallSea'))
					PlaySound(Sound'FisherFoley.Play_FisherFallSea', SLOT_SFX);

				// Ugly patch to choose the right water effect
				if (InStr(eGame.ELevel.GetLocalURL(), "VselkaInfiltration") > 0 )
					Spawn(class'EWaterSplashInfiltration', self,,Location + CollisionHeight * Vect(0,0,1));
				else
					Spawn(class'EWaterSplash', self,,Location + CollisionHeight * Vect(0,0,1));
			}

			if (IsPlaying(Sound'FisherVoice.Play_SamFallDeath'))
				StopSound(Sound'FisherVoice.Play_SamFallDeath');
		}
	}
	// Exiting volumeh
	else
	{
		// Cold
		if (Volume.bColdZone && BreathEmitter != None)
		{
			BreathEmitter.Kill();

			// this emitter will destroy itself over time
			BreathEmitter = None;
		}
	}
}

//************************************************************************
//************************************************************************
//*********														   *******
//********					   SOUND STUFF                          ******
//*********														   *******
//************************************************************************
//************************************************************************
//---------------------------------------[David Kalina - 20 Aug 2001]-----
// 
// Description
//		Get appropriate SurfaceNoiseInfo struct from EchelonGameInfo.
//
// Input
//		ntype : Noise Type of surface
//
// Output
//		function SurfaceNoiseInfo : Noise Info class of surface.
// 
//------------------------------------------------------------------------

function SurfaceNoiseInfo GetFootstepNoiseInfo(SurfaceNoiseType ntype)
{
	if (eGame != none)
	{
		switch (ntype)
		{
			case SN_VeryQuiet:		return eGame.VeryQuietSurface;
			case SN_Quiet:			return eGame.QuietSurface;
			case SN_Normal:			return eGame.NormalSurface;
			case SN_Loud:			return eGame.LoudSurface;
			case SN_VeryLoud:		return eGame.VeryLoudSurface;
		}
	}
}

function SpawnDust(name Bone)
{
	spawn(class'ELedgeDust', self,,GetBoneCoords(Bone).Origin + (Vect(4,0,4)>>Rotation));
}

//---------------------------------------[David Kalina - 25 Apr 2001]-----
// 
// Description
//		Called by Notifications in animations.
// 
//------------------------------------------------------------------------

function Touch(Actor Other)
{
	local EVolumeTrigger volumeTrigger;
	local EVolume volume;
	local EPawn Touched;

	Super.Touch(Other);
	
	// While EVolumeTrigger is not a volume
	volume			= EVolume(Other);
	volumeTrigger	= EVolumeTrigger(Other);
	Touched         = ePawn(Other);

	if (volumeTrigger != None && volumeTrigger.iDirtynessFactor != 0)
	{
		currentDirtynessFactor = volumeTrigger.iDirtynessFactor;
	}
	else if (volume != None && volume.iDirtynessFactor != 0)
	{
		currentDirtynessFactor = volume.iDirtynessFactor;
	}

	if (Touched != None)
	{
		if (Touched.BodyFlames.Length > 0  && bIsPlayerPawn && !bDyingDude)
		{
			AddAmbientDamage(,4);
		}
	}
}

function UnTouch(Actor Other)
{
	local EVolumeTrigger volumeTrigger;
	local EVolume volume;
	local EPawn Touched;

	Super.Touch(Other);
	
	// While EVolumeTrigger is not a volume
	volume			= EVolume(Other);
	volumeTrigger	= EVolumeTrigger(Other);
	Touched         = ePawn(Other);	

	if ((volumeTrigger != None && volumeTrigger.iDirtynessFactor != 0) ||
	   (volume != None && volume.iDirtynessFactor != 0))
	{		
		currentDirtynessFactor = 0;
	}

	if (Touched != None)
	{
		if (Touched.BodyFlames.Length > 0  && !bDyingDude)
		{
			AddAmbientDamage(,-4);
		}
	}
}

function ProcessFootPrint(bool rightFoot, out int footDirtyness, coords footCoord)
{
	local int			pill;
	local Rotator		footStepRotator;
	local vector		HitLocation, HitNormal;
	local Material		HitMaterial;
	local Actor			hitActor;
		
	local EFootPrint	footPrint;
	local int			slice;
	local int			i;
	
	footStepRotator = OrthoRotation(footCoord.XAxis, footCoord.YAxis, footCoord.ZAxis);

	if (currentDirtynessFactor != 0)
	{
		footDirtyness = currentDirtynessFactor;
	}

	hitActor = TraceBone(pill,
					   HitLocation, 
					   HitNormal, 
					   footCoord.Origin + vect(0, 0, -100), 
				       footCoord.Origin,
					   HitMaterial,
					   false);
	
	while (Modifier(HitMaterial) != none)
	{
		HitMaterial = Modifier(HitMaterial).Material;
	}

	if (hitActor != none && HitMaterial != none && (HitMaterial.bLeaveFootStep == true || footDirtyness != 0) && Level.pProjTexture != none)
	{
		if (hitActor.bWorldGeometry || (hitActor.DrawType == DT_StaticMesh && !hitActor.bIsGamePlayObject))
		{
			footStepRotator.Pitch =- 16384;
			footStepRotator.Roll = 0;

			for (i = 0; i < Level.FootStepSurfaceToSubTexLink.Length; i++)
			{
				if (hitMaterial.SurfaceType == Level.FootStepSurfaceToSubTexLink[i].surfType)
				{
					break;
				}
			}
			
			if (i != Level.FootStepSurfaceToSubTexLink.Length)
			{
				if (!rightFoot)
					Level.AddImpact(HitLocation + Vect(0.0f, 0.0f, 1.0f), footStepRotator, true, true, i);
				else
					Level.AddImpact(HitLocation + Vect(0.0f, 0.0f, 1.0f), footStepRotator, true, false, i);
			}
		}
	}

	if (footDirtyness != 0)
		footDirtyness--;
}

function PlayRightFootStep()
{
	CurrentFoot = true;
	PlaySound(Sounds_Move, SLOT_SFX);

	ProcessFootPrint(true, rightFootDirtyness, GetBoneCoords('B R Toe0'));
}

function PlayLeftFootStep()
{
	CurrentFoot = false;
	PlaySound(Sounds_Move, SLOT_SFX);

	ProcessFootPrint(false, leftFootDirtyness, GetBoneCoords('B L Toe0'));
}

function PlayRightHand()
{
	CurrentFoot = true;
	PlaySound(Sound'FisherFoley.Play_Switch_FisherLedgeHand', SLOT_SFX);
	
	SpawnDust('B R hand');
}

function PlayLeftHand()
{
	CurrentFoot = false;
	PlaySound(Sound'FisherFoley.Play_Switch_FisherLedgeHand', SLOT_SFX);
	
	SpawnDust('B L Hand');
}

function PlayGenericFootStep()
{
	if (EPlayerController(Controller) != None)
	{
		if (EPlayerController(Controller).CurrentVolume != None)
		{
			if (!(EPlayerController(Controller).CurrentVolume.bLiquid  && EPlayerController(Controller).CurrentVolume.bDyingZone))
				PlaySound(Sounds_Move, SLOT_SFX);
		}
		else
			PlaySound(Sounds_Move, SLOT_SFX);
	}
	else
		PlaySound(Sounds_Move, SLOT_SFX);
}

function PlayLadderClimb()
{
	PlaySound(Sound'FisherFoley.Play_Random_FisherClimbLadder', SLOT_SFX);
}

function PlayFenceFoot()
{
	PlaySound(Sound'FisherFoley.Play_Random_FisherClimbFenceFo', SLOT_SFX);
}

function PlayVerticalPipeFoot()
{
	PlaySound(Sound'FisherFoley.Play_Switch_FisherClimbTubeFo', SLOT_SFX);
}

function PlayVerticalPipeHand()
{
	PlaySound(Sound'FisherFoley.Play_Random_FisherClimbTubeVHa', SLOT_SFX);
}

function PlayHorizontalPipeHand()
{
	PlaySound(Sound'FisherFoley.Play_Random_FisherClimbTubeHHa', SLOT_SFX);
}

function PlayFenceVibration()
{
	if (EPlayerController(Controller).LastFenceType == SURFACE_FenceMetal)
		PlaySound(Sound'FisherFoley.Play_Random_FisherFenceVib', SLOT_SFX);
	else if (EPlayerController(Controller).LastFenceType == SURFACE_FenceVine)
		PlaySound(Sound'FisherFoley.Play_Random_VineVibration', SLOT_SFX);
}		

function PlayGearRun()
{
	if (SoundWalkingRatio > 0.65f)
		PlaySound(Sound'FisherFoley.Play_Random_FisherRunGear', SLOT_SFX);
}

function PlayGearRoll()
{
	if (EPlayerController(Controller).CurrentVolume != None && EPlayerController(Controller).CurrentVolume.bLiquid == true)
		PlaySound(Sound'FisherFoley.Play_FisherRollWater', SLOT_SFX);
	else
		PlaySound(Sound'FisherFoley.Play_FisherRollGear', SLOT_SFX);

	MakeNoise(200.0f, NOISE_HeavyFootstep);
}

function PlayGearSplitJump()
{
	PlaySound(Sound'FisherFoley.Play_Random_FisherSplitJumpGear', SLOT_SFX);
}

function PlayGearThrow()
{
	PlaySound(Sound'FisherFoley.Play_FisherThrowGear', SLOT_SFX);
}

function PlayCloseAttack()
{
	if (Controller != None && Controller.bIsPlayer)
	{
		if (EPlayerController(Controller).m_targetObject != None && EPlayerController(Controller).m_targetObject.IsA('EPawn'))
			PlaySound(Sound'FisherFoley.Play_FisherCloseAttack', SLOT_SFX);
	}
}

function PlayDropAttack()
{
	PlaySound(Sound'FisherFoley.Play_FisherDropAttack', SLOT_SFX);
}

function PlayCarryBody()
{
	PlaySound(Sound'FisherFoley.Play_FisherCarryBody', SLOT_SFX);
}

function PlayDropBody()
{
	PlaySound(Sound'FisherFoley.Play_FisherDropBody', SLOT_SFX);
}

function PlayPivot()
{
	//Needed a flag and this variable isnt used for SAM
	Bark_Type = BARK_AboutToDie;
	PlaySound(Sounds_Move, SLOT_SFX);	
}

function PlayAttackMove()
{
    PlaySound(Sounds_AttackMove, SLOT_Barks);
}

function PlayAttackGetDown()
{
    PlaySound(Sounds_AttackGetDown, SLOT_Barks);    
}

function PlayAttackStop()
{
    PlaySound(Sounds_AttackStop, SLOT_Barks);
}

function PlayNPCKeyboard()
{
	PlaySound(Sound'Electronic.Play_Sq_ComputerKeyBoard', SLOT_SFX);
}

function StopNPCKeyboard()
{
	PlaySound(Sound'Electronic.Stop_Sq_ComputerKeyBoard', SLOT_SFX);
}

function PlaySneeze()
{
}

//-------------------------------[Matthew Clarke - August 16th 2002]-----
// 
// Description
//
// 
//------------------------------------------------------------------------
event bool ICanBark()
{
    // Not same bark within 1 second
    if ((EchelonLevelInfo(Level).afLastBarked[Bark_Type]) < (Level.Timeseconds - 1))
    {
        EchelonLevelInfo(Level).afLastBarked[Bark_Type] = Level.Timeseconds;
        return true;
    }

    return false;
}

//************************************************************************
//************************************************************************
//*********														   *******
//********					INVENTORY STUFF                         ******
//*********														   *******
//************************************************************************
//************************************************************************

//------------------------------------------------------------------------
// 
// Description
//		Called when Pawn anim state changes - also called to setup
//		initial animations.  MUST BE DEFINED IN SUBCLASS.
//
//------------------------------------------------------------------------
function InitAnims() {}
function SwitchAnims() {}




//---------------------------------------[David Kalina - 19 Jun 2001]-----
// 
// Description
//		Makes sure BaseMoveFlags and current AMove<..> anim set are coherent.
//		Check for potential transition animation and goto transition state
//		if necessary.
// 
// Input
//		NewMoveFlags : Current set of movement animations to choose.
//		bForceUpdate : will update even if MoveFlags are the same (called when changing weapons, e.g.)
// 
//------------------------------------------------------------------------

event UpdateAnimationSet(MoveFlags NewMoveFlags, optional bool bForceUpdate)
{
	local int i;

	// disallow MOVE_NotSpecified to be used
	if (NewMoveFlags == MOVE_NotSpecified)
	{
		plog("WARNING : UpdateAnimationSet being called w/ MOVE_NotSpecified  --  defaulting to MOVE_WalkNormal");
		NewMoveFlags = MOVE_WalkNormal;
	}

	NewMoveFlags = UpdateMoveFlagState(NewMoveFlags, EAIController(Controller).bRequestAwareState);

	if (BaseMoveFlags != NewMoveFlags || bForceUpdate)
	{		

		// will add ETransitionInfo's to the TransitionQueue if necessary
		//log("Dans UpdateAnimationSet checkfortransition NewMoveFlag: "$NewMoveFlags$" BaseMoveFlags: "$BaseMoveFlags);
		CheckForTransition(NewMoveFlags);

		for (i = 0; i < TransitionQueue.Length ; i++)
			plog("		UpdateAnimationSet -- Base "  $ BaseMoveFlags $ " -->  New " $ NewMoveFlags $ " bForceUpdate " $ bForceUpdate $ " -----> Transition : " $ TransitionQueue[i].ATransition);

		BaseMoveFlags = NewMoveFlags;
		SwitchAnims();
	}
	
    //reset anim flag
    if (!Controller.bIsPlayer)
        EAIController(Controller).bRequestAwareState = false;

	// process any transitions on the queue ..
	if (TransitionQueue.Length > 0)
		GotoState('s_Transition');
}

//---------------------------------------[David Kalina - 27 May 2002]-----
// 
// Description
//		
// 
//------------------------------------------------------------------------



//----------------------------------------[David Kalina - 9 Apr 2001]-----
// 
// Description
//		Get a weapon (appropriate to the situation?) from our inventory.
//		If bWeaponInit is true, just place the weapon in hand.
// 
//------------------------------------------------------------------------

function SelectWeapon(optional bool bWeaponInit)
{
	local EInventoryItem	NewItem;

	// Parse Extras Category and if find a weapon, select it

	NewItem = FullInventory.GetItemByClass('EWeapon');
	if (NewItem != none) 
	{
		HandItem		= NewItem;
		CurrentWeapon	= EWeapon(NewItem);
		
		if (NewItem.IsA('EOneHandedWeapon'))
			WeaponHandedness = 1;
		else
			WeaponHandedness = 2;
	}
	else
	{
		// no weapon available -- make sure everything is set accordingly
		HandItem			= none;
		CurrentWeapon		= none;
		WeaponHandedness	= 0;
		WeaponStance		= 0;
	}

	// place weapon in hand immediately if initializing
	if (bWeaponInit)
		InitWeaponAttach();
	
	// update anim set after getting weapon
	UpdateAnimationSet(BaseMoveFlags, true);
}


//---------------------------------------[David Kalina - 25 Sep 2001]-----
// 
// Description
//		Intended to check EAIController state and ensure that our 
//		MoveFlags match the current state.
//
//		Redefined in EAIPawn.
//
// Input
//		NewMoveFlags : 
//
//------------------------------------------------------------------------

event MoveFlags UpdateMoveFlagState(MoveFlags NewMoveFlags , optional bool _bForceAware)
{
	
	return NewMoveFlags;
}

//---------------------------------------[David Kalina - 25 Mar 2002]-----
// 
// Description
//		Return appropriate Reaction Animation based on character and anim state.
// 
//------------------------------------------------------------------------

function GetReactionAnim(out name Anim, out name AnimB, out float BlendAlpha, optional eReactionAnimGroup ReactionGroup) {}


//---------------------------------------[David Kalina - 13 Aug 2001]-----
// 
// Description
//		Check for possible transition animation between 
//		our current BaseMoveFlags and the input NewMoveFlags.
// 
//------------------------------------------------------------------------

event CheckForTransition(MoveFlags NewMoveFlags);




//************************************************************************
//************************************************************************
//*********														   *******
//********				     BLENDING WRAPPERS                      ******
//*********														   *******
//************************************************************************
//************************************************************************

function PlayAnimOnly(name Sequence, optional float Rate, optional float TweenTime, optional bool bBackward, optional bool bContinueAtFrame, optional bool bNoResetAction)
{
	if (Rate == 0.0)
		Rate = 1.0;

	// NOTE : Don't kill PERSONALITYCHANNEL here, should be done separately
	//Log("PlayAnimOnly"@Sequence@Rate@TweenTime@bBackward@bNoResetAction);
	
	AnimBlendParams(BLENDMOVEMENTCHANNEL,0,0,0);
	ForceAnimParams(BLENDMOVEMENTCHANNEL, AnimSequence, 0.f, 0.f);
	AnimBlendParams(REFPOSECHANNEL,0,0,0);
	ForceAnimParams(REFPOSECHANNEL, AnimSequence, 0.f, 0.f);
	if (!bNoResetAction)
		AnimBlendToAlpha(ACTIONCHANNEL,0,0.10);

	PlayAnim(Sequence, Rate, TweenTime, BASEMOVEMENTCHANNEL, bBackward, bContinueAtFrame);
}

event LoopAnimOnly(name Sequence, optional float Rate, optional float TweenTime, optional bool bBackward, optional bool bContinueAtFrame)
{
	if (Rate == 0.0)
		Rate = 1.0;

	//Log("LoopAnimOnly"@Sequence@Rate@TweenTime@bBackward);

	AnimBlendParams(BLENDMOVEMENTCHANNEL,0,0,0);
	AnimBlendParams(REFPOSECHANNEL,0,0,0);
//	AnimBlendParams(ACTIONCHANNEL,0,0,0);

	LoopAnim(Sequence, Rate, TweenTime, BASEMOVEMENTCHANNEL, bBackward, bContinueAtFrame);
}

event StopTurning()
{
	ForceAnimParams(TURNLEFTCHANNEL, ATurnRight, 0.0f, 0.0f);
	AnimBlendParams(TURNLEFTCHANNEL,0,0,0);

	ForceAnimParams(TURNRIGHTCHANNEL, ATurnRight, 0.0f, 0.0f);
	AnimBlendParams(TURNRIGHTCHANNEL,0,0,0);
}

event PlayBlend(SAnimBlend	anims,
					Rotator		lookDir,
					vector		moveDir,
					float		minForwardRatio,
					float		tweenTime,
					optional bool noloop)
{
	local float fRatio, fDot;
	local vector vLookDir, vCross;

	// if we can't blend, just play forward animation
	if (bNoBlending)
	{
		if (noloop)
			PlayAnimOnly(anims.m_forward,,tweenTime);
		else
			LoopAnimOnly(anims.m_forward,,tweenTime);

		return;
	}

	lookDir.Pitch = 0.0;
	vLookDir = Vector(lookDir);
	moveDir.Z = 0.0;
	moveDir	= Normal(moveDir);

	if (VSize(moveDir) == 0.0)
	{
		Log("Invalide moveDir in PlayBlend", , LPAWN | LLEVEL1);
		return;
	}

	fDot = vLookDir Dot moveDir;

	if (fDot >= minForwardRatio)
	{
		if (noloop)
		{
			PlayAnim(anims.m_forward,,tweenTime);
		}
		else
		{
			if (bPitchBlack)
				LoopAnim(APitchBlackF,,tweenTime);
			else
				LoopAnim(anims.m_forward,,tweenTime);
		}
	}
	else
	{
		if (anims.m_backward != '')
		{
			if (noloop)
			{
				PlayAnim(anims.m_backward,,tweenTime);
			}
			else
			{
				LoopAnim(anims.m_backward,,tweenTime);
			}
		}
	}

	if (Abs(fDot) < 0.999)
	{
		fRatio = Acos(Abs(fDot)) * TWOOVERPI;
		vCross = vLookDir Cross moveDir;

		if (vCross.Z < 0.0)
		{
			if (anims.m_backwardLeft != '' && anims.m_backwardRight != '')
			{
				if (fDot >= minForwardRatio)
				{
					SynchAnim(anims.m_forwardLeft, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
				}
				else
				{
					SynchAnim(anims.m_backwardLeft, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
				}
			}
			else
			{
				if (bPitchBlack)
					SynchAnim(APitchBlackL, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
				else
					SynchAnim(anims.m_forwardLeft, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);

			}
		}
		else
		{
			if (anims.m_backwardLeft != '' && anims.m_backwardRight != '')
			{
				if (fDot >= minForwardRatio)
				{
					SynchAnim(anims.m_forwardRight, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
				}
				else
				{
					SynchAnim(anims.m_backwardRight, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
				}
			}
			else
			{
				if (bPitchBlack)
					SynchAnim(APitchBlackR, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
				else
					SynchAnim(anims.m_forwardRight, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);

			}
		}

		PrevMoveBlendAlpha = fRatio;		// set for transition to wait animations if necessary
	}
	else
	{
		AnimBlendParams(BLENDMOVEMENTCHANNEL,0,0,0);
		AnimBlendParams(REFPOSECHANNEL,0,0,0);
	}
}

function PlayMove(SAnimBlend anims, Rotator lookDir, vector moveDir, float tweenTime, optional bool FBNeg , optional bool LRNeg)
{
	local float fDot, fRatio;
	local vector vLookDir, vCross;

	lookDir.Pitch = 0.0;
	vLookDir = Vector(lookDir);
	moveDir.Z = 0.0;
	moveDir	= Normal(moveDir);

	if (VSize(moveDir) == 0.0)
	{
		return;
	}

	WalkingRatio = FClamp(WalkingRatio, 0.3, 1.0);

	fDot = vLookDir Dot moveDir;
	if (fDot > -0.1)
		LoopAnim(anims.m_forward,WalkingRatio,tweenTime);
	else
	{
		if (FBNeg)
			LoopAnim(anims.m_forward,WalkingRatio,tweenTime, , true);
		else
			LoopAnim(anims.m_backward,WalkingRatio,tweenTime);
	}

	fDot = vLookDir Dot moveDir;
	if (Abs(fDot) < 0.999)
	{
		fRatio = Acos(Abs(fDot)) * TWOOVERPI;
		vCross = vLookDir Cross moveDir;

		if (vCross.Z > 0)
			SynchAnim(anims.m_forwardRight, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
		else
		{
			if (LRNeg)
				SynchAnim(anims.m_forwardRight, BLENDMOVEMENTCHANNEL, tweenTime, fRatio,,, true);
			else
				SynchAnim(anims.m_forwardLeft, BLENDMOVEMENTCHANNEL, tweenTime, fRatio);
		}
	}
	else
		AnimBlendToAlpha(BLENDMOVEMENTCHANNEL, 0.0, 0.10);
}

function PlayFenceBlend()
{
	local float fRatio;
	local vector vMoveDir;

	SetPhysics(PHYS_Fence);

	if (VSize(Velocity) == 0.0)
	{
		return;
	}

	vMoveDir = Normal(Velocity);

	if (vMoveDir.Z > -0.1)
		LoopAnim(ABlendFence.m_forward,,0.1);
	else
		LoopAnim(ABlendFence.m_forward,,0.1, , true);

	if (Abs(vMoveDir.Z) < 0.999)
	{
		fRatio = Acos(Abs(vMoveDir.Z)) * TWOOVERPI;

		if ((ToWorldDir(vect(0,1,0)) dot vMoveDir) > 0)
			SynchAnim(ABlendFence.m_forwardRight, BLENDMOVEMENTCHANNEL, 0.1, fRatio);
		else
			SynchAnim(ABlendFence.m_forwardRight, BLENDMOVEMENTCHANNEL, 0.1, fRatio,,, true);
	}
}

//---------------------------------------[David Kalina - 25 Apr 2001]-----
// 
// Description
//		For EAIController - calls PlayAnimOnly and makes sure the 
//		character stops moving.
//
//		Returns TRUE if animation gets played.  
// 
//------------------------------------------------------------------------

event bool PlayAnimNoMovement(name Sequence, optional float Rate, optional float TweenTime, optional bool bBackward)
{
	Acceleration = vect(0,0,0);       // stop moving dammit
	GroundSpeed  = 0;
	
	if (Sequence == '')
		PlayAnimOnly(AWait, Rate, TweenTime, bBackward);
	else
		PlayAnimOnly(Sequence, Rate, TweenTime, bBackward);

	return true;
}



//---------------------------------------[David Kalina - 11 Jun 2001]-----
// 
// Description
//		Take anim Sequence and blend it over any and all existing channels.
// Input
//		Sequence : 
//		Rate : 
//		TweenTime : 
// 
//------------------------------------------------------------------------

event BlendAnimOverCurrent(name Sequence, optional float BlendStrength, optional name BoneName, 
						    optional float Rate, optional float TweenTime, optional int Channel, optional bool bBackward)
{
	// default values for optional vars
	if (BlendStrength == 0.0)	BlendStrength	= 0.5;
	if (Rate == 0.0)			Rate			= 1.0;
	if (Channel == 0)			Channel			= ACTIONCHANNEL;

	//Log("BlendAnimOverCurrent"@Sequence@BlendStrength@BoneName@Rate@TweenTime@Channel@bBackward);

	AnimBlendParams(Channel, 0, 0.0, 0.0, BoneName);
	AnimBlendToAlpha(Channel,BlendStrength,0.10);
    PlayAnim(Sequence, Rate, TweenTime, Channel, bBackward);
}

function vector GetExtent()
{
	local vector Extent;

	Extent.X = CollisionRadius;
	Extent.Y = CollisionRadius;
	Extent.Z = CollisionHeight;

	return Extent;
}


function vector GetCrouchExtent()
{
	local vector Extent;

	Extent.X = CrouchRadius;
	Extent.Y = CrouchRadius;
	Extent.Z = CrouchHeight;

	return Extent;
}

//---------------------------------------[Joshua - 4 Dec 2025]------------
// 
// Description
//		Returns the sort priority for an inventory item class.
//		Lower values appear at the bottom of the inventory list.
//		Items are grouped by category and sorted within each category.
// 
//------------------------------------------------------------------------
function int GetInventorySortPriority(class<EInventoryItem> ItemClass)
{
	local Name ClassName;
	ClassName = ItemClass.Name;

	// CAT_MAINGUN
	if (ClassName == 'EF2000')              return 0;
	if (ClassName == 'ERingAirfoilRound')   return 1;
	if (ClassName == 'EStickyShocker')      return 2;
	if (ClassName == 'ESmokeGrenade')       return 3;
	if (ClassName == 'EDiversionCamera')    return 4;
	if (ClassName == 'EStickyCamera')       return 5;

	// CAT_GADGETS
	if (ClassName == 'EFn7')                return 100;
	if (ClassName == 'ELockpick')           return 101;
	if (ClassName == 'EDisposablePick')     return 102;
	if (ClassName == 'EOpticCable')         return 103;
	if (ClassName == 'ELaserMic')           return 104;
	if (ClassName == 'ECameraJammer')       return 105;

	// CAT_ITEMS
	if (ClassName == 'EMedKit')             return 200;
	if (ClassName == 'EFlare')              return 201;
	if (ClassName == 'EChemFlare')          return 202;
	if (ClassName == 'EFragGrenade')        return 203;
	if (ClassName == 'EConcussionGrenade')  return 204;
	if (ClassName == 'EWallMine')           return 205;

	// Unknown items get sorted to end of their category
	return 999;
}

//---------------------------------------[Joshua - 4 Dec 2025]------------
// 
// Description
//		Sorts the DynInitialInventory array so items appear in a consistent
//		order in the inventory.
// 
//------------------------------------------------------------------------
function SortDynInitialInventory()
{
	local int i, j;
	local class<EInventoryItem> Temp;
	local int PriorityI, PriorityJ;
	local bool bSwapped;

	for (i = 0; i < DynInitialInventory.Length - 1; i++)
	{
		bSwapped = false;
		for (j = 0; j < DynInitialInventory.Length - i - 1; j++)
		{
			if (DynInitialInventory[j] == none || DynInitialInventory[j+1] == none)
				continue;

			PriorityI = GetInventorySortPriority(DynInitialInventory[j]);
			PriorityJ = GetInventorySortPriority(DynInitialInventory[j+1]);

			// Swap if current item has higher priority (should come later)
			if (PriorityI > PriorityJ)
			{
				Temp = DynInitialInventory[j];
				DynInitialInventory[j] = DynInitialInventory[j+1];
				DynInitialInventory[j+1] = Temp;
				bSwapped = true;
			}
		}
		// If no swaps occurred, array is sorted
		if (!bSwapped)
			break;
	}
}

//----------------------------------------[David Kalina - 9 Apr 2001]-----
// 
// Description
//		Called after Controller possesses us so we know it's time to initialize.
//		Spawn & Add Inventory to Controller.
// 
//------------------------------------------------------------------------
function PossessedBy(Controller C)
{
	local int i;
	local EInventoryItem item;

	Super.PossessedBy(C);
	eGame = EchelonGameInfo(Level.Game);

	if (C != none)
	{
		// Joshua - Sort inventory before adding items so they appear in consistent order
		SortDynInitialInventory();

		// spawn & add inventory items to our controller
		for (i = 0; i < DynInitialInventory.Length; i++)
		{
			if (DynInitialInventory[i] != none)
			{
				item = Spawn(DynInitialInventory[i], C);
				if (item == None)
				{
					Log(self$" ERROR: Bad inventory item in DynInitialInventory at index"@i);
					continue;
				}

				if (FullInventory.CanAddItem(item))
					item.Add(C, C, FullInventory);
				else
				{
					Log(self$" ERROR: Can't add item in Pawn's inventory from DynInitialInventory ["$item$"]");
					item.Destroy();
				}
			}
		}
	}
	else
		Log("Warning!  EPawn JustPossessed - no Controller yet, can't add inventory.");

}

//----------------------------------------[David Kalina - 5 Apr 2001]-----
// 
// Description
//		Rotates Pawn towards target rotator - only affects YAW.
//
// Input
//		Target : rotator we wish to move our Rotation towards
//		deltaTime : used to scale rotation
//
// Output
//		bool : true = rotation complete
//
//------------------------------------------------------------------------
event bool RotateTowardsRotator(rotator Target, optional int TurnSpeed, optional float Damping)
{
	local rotator NewRotation;
	local int diff;

	if (TurnSpeed == 0)
		TurnSpeed = YawTurnSpeed;	// use default designer variable

	NewRotation = Target;
	NewRotation.Yaw = InterpolateRotatorValue(TurnSpeed * Level.m_dt, Rotation.Yaw, Target.Yaw);
	
	if (Damping > 0.0)
	{
		NewRotation = InterpolateRotator(Damping, NewRotation, Rotation);
	}

	NewRotation.Pitch = Rotation.Pitch;
	NewRotation.Roll = Rotation.Roll;
	SetRotation(NewRotation);
	
	// are we sufficiently close?	TODO : should this maybe be based on prevRotation?
	if ((Rotation.Yaw & 65535) == (Target.Yaw & 65535)) 
		return true;
	
	return false;	// haven't finished rotating
}

//----------------------------------------[David Kalina - 6 Apr 2001]-----
// 
// Description
//		Given position, rotate Pawn around Z so that it is oriented 
//		towards that position.
//
// Input
//		Target : position of target
//		deltaTime : 
//
//------------------------------------------------------------------------
event bool RotateTowardsPosition(vector Target, optional int TurnSpeed)
{
	local vector vDirection;
	
	vDirection		= Target - location;		// get difference between our position and target position
	vDirection		= Normal(vDirection);		// normalize
	
	return RotateTowardsRotator(Rotator(vDirection), TurnSpeed);
}



//************************************************************************
//************************************************************************
//*********														   *******
//********			 ANIMATION PLAYBACK & MANAGEMENT                ******
//*********														   *******
//************************************************************************
//************************************************************************

//------------------------------------------------------------------------
// Description		
//		Quick wrapper around old AnimSequence
//------------------------------------------------------------------------
function name GetAnimName(optional int Channel)
{
	local name CurrentAnimSeq;
	local float CurrentFrame, CurrentRate;
	GetAnimParams(Channel, CurrentAnimSeq, CurrentFrame, CurrentRate);
	return CurrentAnimSeq;
}

//---------------------------------------[ Alain Turcotte @ 30 mai 2001 ]-
// Prototype		PlayWait
// 
// Description		
//------------------------------------------------------------------------
function PlayWait(float turnSpeed, optional float waitTween)
{
	local name ExtraName, WaitAnim;
	local name CurrentAnimSeq;
	local bool bEW, bEWs, bEWc;

	CurrentAnimSeq = GetAnimName();

	// check extra waiting
	bEW = IsExtraWaiting();
	bEWs = IsExtraWaiting(1);
	bEWc = IsExtraWaiting(2);

	// reset second channel
	AnimBlendToAlpha(BLENDMOVEMENTCHANNEL, 0.0, 0.10);

	if (bIsCrouched)
	{
		if (CurrentAnimSeq == AWait || bEWs)
		{
			if (bEWs)
				waitTween = 0.3;
			else 
				waitTween = 0;
			PlayAnim(AWaitCrouchIn, 1.2, waitTween);
		}
		else
		{
			if (Abs(turnSpeed) > 10000.0 && 
				((IsWaiting() && CurrentAnimSeq != AWaitCrouchIn && !IsTweening(0)) || CurrentAnimSeq == ATurnRightCrouch))
			{
				if (turnSpeed > 0)
				{
					LoopAnimOnly(ATurnRightCrouch, 1.0, 0.05);
				}
				else
				{
					LoopAnimOnly(ATurnRightCrouch, 1.0, 0.05, true);
				}
			}
			// check whether we should switch anim
			else if (ShouldPlaySpecialWait())
			{
				GetRandomWaitAnim(ExtraName);
				PlayAnimOnly(ExtraName,1.0,0.2);
			}
			// If he's not already waiting
			// Or finished his wait animation
			else if (!IsWaiting() || !IsAnimating())
			{
				// If a special anim has just ended, means the player didn't touch anything 
				// so loop to next special anim faster
				if (bEW)
				{
					IdleTime = Level.TimeSeconds - 30;
					LoopAnimOnly(AWaitCrouch);
				}
				else
					LoopAnimOnly(AWaitCrouch,1.0, waitTween);
			}
			// Or has a gun in hand and was extra waiting
			else if (WeaponStance != 0 && IsExtraWaiting())
			{
				IdleTime = 0;
				LoopAnimOnly(AWaitCrouch,,0.2);
			}
			// Reverse progressively animation
			else if (CurrentAnimSeq == AWaitCrouchIn && IsAnimBackward())
			{
				PlayAnim(AWaitCrouchIn,1.2,,,false,true);
			}
		}
	}
	else
	{
		// Try to catch special anim set
		if (WeaponStance == 0 && EPlayerController(Controller).SpecialWaitAnim != '')
		{
			WaitAnim = EPlayerController(Controller).SpecialWaitAnim;
			waitTween = 0.5;
		}
		else
			WaitAnim = AWait;

		if (CurrentAnimSeq == AWaitCrouch || bEWc)
		{
			if (bEWc)
				waitTween = 0.3;
			else 
				waitTween = 0;
			PlayAnim(AWaitCrouchIn,1.2,waitTween,,true);
		}
		else
		{
			if (Abs(turnSpeed) > 10000.0 && ((IsWaiting() && (CurrentAnimSeq != AWaitCrouchIn) && !IsTweening(0)) || CurrentAnimSeq == ATurnRight))
			{
				if (turnSpeed > 0)
				{
					LoopAnimOnly(ATurnRight, 1.0, 0.05);
				}
				else
				{
					LoopAnimOnly(ATurnRight, 1.0, 0.05, true);
				}

			}
			// check whether we should switch anim
			else if (ShouldPlaySpecialWait())
			{
				GetRandomWaitAnim(ExtraName);
				PlayAnimOnly(ExtraName,1.0,0.2);
			}
			// If he's not already waiting
			// Or finished his wait animation
			else if (!IsWaiting() || !IsAnimating())
			{
				// If a special anim has just ended, means the player didn't touch anything 
				// so loop to next special anim faster
				if (bEW)
				{
					IdleTime = Level.TimeSeconds - 30;
					LoopAnimOnly(WaitAnim);
				}
				else
				{
					LoopAnimOnly(WaitAnim,1.0, waitTween);
				}
			}
			// Or has a gun in hand and was extra waiting
			else if (WeaponStance != 0 && IsExtraWaiting())
			{
				IdleTime = 0;
				LoopAnimOnly(AWait,,0.2);
			}
			// Reverse progressively animation
			else if (CurrentAnimSeq == AWaitCrouchIn && !IsAnimBackward())
			{
				PlayAnim(AWaitCrouchIn,1.2,,,true,true);
			}
		}
	}
}

//------------------------------------------------------------------------
// Description		
//		Play a special wait anim after a cycle time
//------------------------------------------------------------------------
function bool ShouldPlaySpecialWait()
{
	return WeaponStance == 0	&&		// Pevent the case where it would continue to loop an extra anim with gun in hand
		   !IsExtraWaiting()	&&
		   !IsPawnTalking()		&&
		   !EPlayerController(Controller).bStopInput && 
			IdleTime != 0		&&
			Level.TimeSeconds - IdleTime > 60.f;
}

//------------------------------------------------------------------------
// Description		
//		Is playing specific waiting anims
//		f = 0 stand or crouch, f = 1 stand only, f = 2 crouch only
//------------------------------------------------------------------------
function bool IsExtraWaiting(optional int f);

//------------------------------------------------------------------------
// Description		
//		is playing any waiting anims
//------------------------------------------------------------------------
function bool IsWaiting()
{
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName();

	return (IsExtraWaiting()					||
			CurrentAnimSeq == AWait				|| 
			CurrentAnimSeq == AWaitCrouch		|| 
			CurrentAnimSeq == AWaitCrouchIn);
}


//---------------------------------------[David Kalina - 29 Aug 2001]-----
// 
// Description
//
//		For the NPC : Wait while facing Focus with body oriented on ForwardRotation.
//		Handles turning, etcetera.
// 
//------------------------------------------------------------------------

event PlayWaitingBlend(vector ForwardDirection, vector FocusDirection, float YawDiff, float TweenTime)
{
	local name CurrentAnimSeq;
	local float CurrentFrame, CurrentRate;
	local vector vCross;
	local int i;

	plog("PlayWaitingBlend in default state... AWaitIn: "$AWaitIn$" AWait: "$AWait);

	if (AWaitIn != '')
	{
		// special stop transition anim
		AddTransition('s_Waiting', AWaitIn,, 0.45f, 0.3f,,true);
	}
	else
	{
		// tweening to wait anims
		AddTransition('s_Waiting', AWait,, 0.275f, 0.3f,,true);
	}
		
	if (TransitionQueue.Length > 0) 
		GotoState('s_Transition');
	
}

function PlayMoveTo(Rotator ViewRotation, optional Actor ViewTarget)
{
	if (!bIsCrouched)
		LoopAnimOnly(AWalk,,0.2);
//	else
//		LoopAnim(AWalkCrouch,,0.2);
}

function DoJumping()
{
	Velocity.Z = JumpZ;
	bWantsToCrouch = false;

    // if we are on a platform
	if (Base != None && Base.bIsMover)
		Velocity.Z += Base.Velocity.Z; 
}

function bool IsJumpingForward()
{
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName();

	return CurrentAnimSeq == AJumpForwardR || CurrentAnimSeq == AJumpForwardL;
}

function bool PlayJumpStart()
{
	local vector horiSpeed;
	local name CurrentAnimSeq;
	local float CurrentFrame, CurrentRate, tweenTime;

	GetAnimParams(0, CurrentAnimSeq, CurrentFrame, CurrentRate);

	horiSpeed = Velocity;
	horiSpeed.Z = 0;
	if (VSize(horiSpeed) <= 10.0)
	{
		if (bWantsToCrouch)
			return false;

		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		PlaySound(Sound'FisherFoley.Play_FisherJumpStaticGear', SLOT_SFX);
		PlayAnimOnly(AJumpStart);
		return true;
	}
	else
	{
		PlaySound(Sound'FisherFoley.Play_FisherJumpDynGear', SLOT_SFX);
		if (bIsCrouched)
			tweenTime = 0.1;
		else
			tweenTime = 0.03;
		if (CurrentFrame < 0.10 || CurrentFrame > 0.70)
			PlayAnimOnly(AJumpForwardR,,tweenTime);
		else
			PlayAnimOnly(AJumpForwardL,,tweenTime);
	}

	return false;
}

function PlayInAir()
{
	local vector horiSpeed, HitLocation, HitNormal, TraceStart, TraceEnd, Extent;
	local name AnimName;
	local EPawn victime;

	if (!Controller.bIsPlayer)
		return;

	AnimName = GetAnimName();

	if (AnimName == ALandAttack)
		return;

	TraceStart = Location;
	TraceStart.Z -= (CollisionHeight - 15.0);
	TraceEnd = TraceStart;
	TraceEnd.Z -= 30.0;
	Extent.X = CollisionRadius;
	Extent.Y = CollisionRadius;
	Extent.Z = 15.0;
	victime = EPawn(Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, Extent, , true));
	if (victime != None && !victime.bOrientOnSlope)
	{
		// Joshua - Set bBlockJumpDetection to prevent head jump from counting as PlayerIdentified
		if (victime.Controller != None && EAIController(victime.Controller) != None)
		{
			EAIController(victime.Controller).bBlockJumpDetection = true;
		}
		PlayAnimOnly(ALandAttack, ,0.1);
		return;
	}

	switch (AnimName)
	{
	case AJumpStart :
		if (!IsAnimating())
			LoopAnimOnly(AFall,,0.75);
		break;

	case AJumpForwardR :
	case AJumpForwardL :
		if (IsAnimating())
			return;

		if (bWantsToCrouch)
			LoopAnimOnly(AFallQuiet,,0.2);
		else
			LoopAnimOnly(AFall,,0.2);
		break;

	case AFall :
	case AFallQuiet :
	case AFallFree :
		// Play fall to death animation if velocity is exceeding defined value
		if (Abs(Velocity.Z) >= eGame.MaxBeforeDeath)
		{
			if (!IsPlaying(Sound'FisherVoice.Play_SamFallDeath') && (!EPlayerController(Controller).bInvincible) &&
				(EPlayerController(Controller).CurrentVolume == None || !EPlayerController(Controller).CurrentVolume.bLiquid))
			{
				PlaySound(Sound'FisherVoice.Play_SamFallDeath', SLOT_SFX);
			}
			LoopAnimOnly(AFallFree,,0.2);
			return;
		}
	default :
		if (!bWantsToCrouch)
			LoopAnimOnly(AFall,,0.2);
		else
			LoopAnimOnly(AFallQuiet,,0.3);
		break;
	}
}

function bool PlayLanding()
{
	local Name AnimName;
	local vector horiSpeed;
	local float TweenTime;
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName();
	
	horiSpeed = Velocity;
	horiSpeed.Z = 0;

	if (CurrentAnimSeq == ALandAttack)
		return true;

	if (bWantsToCrouch)						// Jump on place crouched
	{
		if (Velocity.Z <= -400.0f)
			AnimName = ALandQuiet;
	}
	else if (Velocity.Z <= -750.0f)			// Jump from very high
		AnimName = ALandHi;
	else if (VSize(Acceleration) == 0)
	{
		if (IsJumpingForward())
			TweenTime = 0.1;
		AnimName = ALandLow;
	}

	if (CurrentAnimSeq == ALandQuiet || CurrentAnimSeq == ALandHi || CurrentAnimSeq == ALandLow)
		TweenTime = 0.2;

	SetPhysics(PHYS_Walking);
	if (AnimName != '')
	{
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);

		PlayAnimOnly(AnimName,,TweenTime,,,EPlayerController(Controller).bInGunTransition);
		return true;
	}
	else 
		return false;
}

function PlayDoorOpen(optional bool RightSide)
{		
	if (RightSide)
	{
		if (!bIsCrouched)
			PlayAnimOnly(ADoorOpenRt,,0.20);
		else
			BlendAnimOverCurrent(ADoorOpenRt, 1, UpperBodyBoneName,,0.2);
	}
	else
	{
		if (!bIsCrouched)
			PlayAnimOnly(ADoorOpenLt,,0.20);
		else
			BlendAnimOverCurrent(ADoorOpenLt, 1, UpperBodyBoneName,,0.2);
	}
}

function PlayReload(optional bool upperOnly, optional bool bigTween)
{
	local name BoneName;
	local float tweenTime;
	if (bigTween)
		tweenTime = 0.3;
	else
		tweenTime = 0.2;
	if (VSize(Velocity) > 0 || upperOnly)
		BoneName = UpperBodyBoneName;

	if (!bIsCrouched)
		BlendAnimOverCurrent(AReload, 1, BoneName,,tweenTime);
	else
		BlendAnimOverCurrent(AReloadCrouch, 1, BoneName,,tweenTime);
}

event bool IsReloading()
{
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName(ACTIONCHANNEL);
	
	return ((CurrentAnimSeq == AReload || CurrentAnimSeq == AReloadCrouch) && IsAnimating(ACTIONCHANNEL));
}

function PlayLedgeHoistingEnd()
{
	SetPhysics(PHYS_Linear);
	if (bIsCrouched)
	{
		PlayAnimOnly(AWaitCrouch);
	}
	else
	{
		PlayAnimOnly(AWait);
	}
}

//************************************************************************
//************************************************************************
//*********														   *******
//********			        NARROW LADDER STUFF                     ******
//*********														   *******
//************************************************************************
//************************************************************************

function PlayNarrowLadderInBottom()
{
	PlayAnimOnly(ANLInBottom);
	SetPhysics(PHYS_RootMotion);
}

function PlayNarrowLadderInTop()
{
	SetPhysics(PHYS_Linear);
	PlayAnimOnly(ANLInTop);
}

function PlayNarrowLadderOutBottom()
{
	if (m_climbingUpperHand == CHLEFT)
		PlayAnimOnly(ANLOutBottomLeft, , 0.15, true);
	else
		PlayAnimOnly(ANLOutBottomRight, , 0.15, true);
}

function PlayNarrowLadderUp()
{
	SetPhysics(PHYS_Linear);
	switch (m_climbingUpperHand)
	{
	case CHNONE:
		PlayAnimOnly('LaddStAlBgR');
		m_climbingUpperHand = CHRIGHT;
		break;
	case CHLEFT:
		PlayAnimOnly(ANLUpLeft);
		m_climbingUpperHand = CHRIGHT;
		break;
	case CHRIGHT:
		PlayAnimOnly(ANLUpRight);
		m_climbingUpperHand = CHLEFT;
		break;
	}
}

function bool PlayNarrowLadderDown()
{
	SetPhysics(PHYS_Linear);
	switch (m_climbingUpperHand)
	{
	case CHNONE:
		PlayAnimOnly(ANLTopUpRight, , , true);
		m_climbingUpperHand = CHRIGHT;
		return true;
	case CHLEFT:
		PlayAnimOnly(ANLUpRight, , , true);
		m_climbingUpperHand = CHRIGHT;
		return false;
	case CHRIGHT:
		PlayAnimOnly(ANLUpLeft, , , true);
		m_climbingUpperHand = CHLEFT;
		return false;
	}
}

function PlayNarrowLadderSlideDown(float tweenTime)
{
	SetPhysics(PHYS_Linear);
	m_climbingUpperHand = CHNONE;
	LoopAnimOnly(ANLSlideDown, , tweenTime);
}

function PlayNarrowLadderWait(float tweenTime)
{
	SetPhysics(PHYS_Linear);
	switch (m_climbingUpperHand)
	{
	case CHNONE:
		LoopAnimOnly(ANLWaitTop, , tweenTime);
		break;
	case CHLEFT:
		LoopAnimOnly(ANLWaitLeft, , tweenTime);
		break;
	case CHRIGHT:
		LoopAnimOnly(ANLWaitRight, , tweenTime);
		break;
	}
}

function PlayNarrowLadderTopUp()
{
	SetPhysics(PHYS_Linear);
	switch (m_climbingUpperHand)
	{
		case CHLEFT:
			PlayAnimOnly(ANLTopUpLeft);
			break;
		case CHRIGHT:
			PlayAnimOnly(ANLTopUpRight);
			break;
	}
	m_climbingUpperHand = CHNONE;
}

function PlayNarrowLadderTopDown()
{
	SetPhysics(PHYS_Linear);
	// Always right
	PlayAnimOnly(ANLTopDownRight);
	m_climbingUpperHand = CHRIGHT;
}

function bool PlayNLPLand(bool crouch, float zSpeed)
{
	local name AnimName;
	if (crouch)
		AnimName = ALandQuiet;
	else if (zSpeed < -400.0f)
		AnimName = ALandLow;
	SetPhysics(PHYS_Walking);

	if (AnimName != '')
	{
		PlayAnimOnly(AnimName, , 0.1);
		return true;
	}
	else
	{
		LoopAnimOnly(AWait, 1.0, 0.15);
		return false;
	}
}

//************************************************************************
//************************************************************************
//*********														   *******
//********			              ZIPLINE                           ******
//*********														   *******
//************************************************************************
//************************************************************************
function PlayZipLineWait(bool crouched)
{
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName();

	if ((CurrentAnimSeq == 'ZippStAlBg0' || CurrentAnimSeq == 'ZippCrAlEd0' || CurrentAnimSeq == 'ZippCrAlBg0') &&
		IsAnimating())
		return;

	if (crouched)
		LoopAnimOnly('ZippCrAlDn0');
	else
		LoopAnimOnly('ZippStAlDn0');
}

function PlayZipLineTransition(bool crouched)
{
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName();
	
	if (crouched && CurrentAnimSeq != 'ZippCrAlBg0')
		PlayAnimOnly('ZippCrAlBg0');
	else if (!crouched && CurrentAnimSeq != 'ZippCrAlEd0')
		PlayAnimOnly('ZippCrAlEd0');
}

//************************************************************************
//************************************************************************
//*********														   *******
//********			              PIPE STUFF                        ******
//*********														   *******
//************************************************************************
//************************************************************************
function PlayPipe(name lAnim, name rAnim, optional float tween, optional bool reverse, optional bool noFlip)
{
	if (m_climbingUpperHand == CHLEFT)
	{
		LoopAnimOnly(lAnim, , tween, reverse);
		if (!noFlip)
			m_climbingUpperHand = CHRIGHT;
	}
	else
	{
		LoopAnimOnly(rAnim, , tween, reverse);
		if (!noFlip)
			m_climbingUpperHand = CHLEFT;
	}
}

function PlayPipeOutBottom()
{
	if (m_climbingUpperHand == CHLEFT)
		LoopAnimOnly('pipvstaliol', , 0.15, true);
	else
		LoopAnimOnly('pipvstalior', , 0.15, true);
}

//************************************************************************
//************************************************************************
//*********														   *******
//********			                POLE STUFF                      ******
//*********														   *******
//************************************************************************
//************************************************************************

function PlayPole(Name rightAnim, Name leftAnim, float tweenTime, bool flip, optional bool reverse)
{
	if (m_climbingUpperHand == CHLEFT)
	{
		LoopAnimOnly(leftAnim, , tweenTime, reverse);
		if (flip)
			m_climbingUpperHand = CHRIGHT;
	}
	else
	{
		LoopAnimOnly(rightAnim, , tweenTime, reverse);
		if (flip)
			m_climbingUpperHand = CHLEFT;
	}
}

function PlayRoll()
{
	local name CurrentAnimSeq;
	local float CurrentFrame, CurrentRate;
	
	GetAnimParams(0, CurrentAnimSeq, CurrentFrame, CurrentRate);

	if (CurrentFrame > 0.25 && CurrentFrame < 0.75)
		PlayAnimOnly('RollStAlFdL', , 0.1);
	else
		PlayAnimOnly('RollStAlFdR', , 0.1);
}

function PlayBTW(Name crouchAnimL, Name crouchAnimR, Name standAnimL, Name standAnimR, bool goingRight, float rate, float tweenTime, optional bool bCrouchBackward, optional bool bStandBackward)
{
	if (bIsCrouched)
	{
		if (goingRight)
			LoopAnimOnly(crouchAnimR, rate, tweenTime, bStandBackward);
		else
			LoopAnimOnly(crouchAnimL, rate, tweenTime, bStandBackward);
	}
	else
	{
		if (goingRight)
			LoopAnimOnly(standAnimR, rate, tweenTime, bCrouchBackward);
		else
			LoopAnimOnly(standAnimL, rate, tweenTime, bCrouchBackward);
	}
}

//************************************************************************
//************************************************************************
//*********														   *******
//********			        DAMAGE, DEATH, AND DYING                ******
//*********														   *******
//************************************************************************
//************************************************************************
function int GetApproxPillFromHit(Vector HitLocation)
{
	local Vector	Y, HitDir;
	local float		DotY, Percent;
	local int		PillTag;

	Y		= Vect(0,1,0) >> Rotation;
	HitDir	= HitLocation - Location;
	HitDir.Z = 0;
	HitDir	= Normal(HitDir);
	DotY	= HitDir Dot Y;
	Percent = (HitLocation.Z - Location.Z) / CollisionHeight;

	// Head zone
	if (Percent > 0.68)
		PillTag = P_Head;
	
	// Middle zone .. Check for chest(front) or arms(left/right)
	else if (Percent >= 0)
	{
		// Chest
		if (DotY < 0) 
			PillTag = P_LBody;
		else
			PillTag = P_RBody;
	}
	
	// legs
	else
	{
		if (DotY < 0)
			PillTag = P_LThigh;
		else
			PillTag = P_RThigh;
	}

	if (PillTag == 0)
		Log("ERROR in GetApproxBoneFromHit to calculate pill from cylinder");
	
	return PillTag;
}

function SpawnWallHit(Actor HitActor, vector HitLocation, vector HitNormal, Material HitMaterial)
{
	local EWeapon weapon;
	if (bIsPlayerPawn)
		weapon = EPlayerController(Controller).ActiveGun;
	else
		weapon = CurrentWeapon;
	weapon.SpawnWallHit(HitActor, HitLocation, HitNormal, HitMaterial);
}

//------------------------------------------------------------------------
// Description		
//		This version of TakeDamage uses the PillTag for its basic damage
//		treatment.  
//------------------------------------------------------------------------
function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, vector HitNormal, Vector momentum, class<DamageType> damageType, optional int PillTag)
{
	local Controller Killer;
	local vector flatMomentum;
	local bool bAlreadyDead;
	local class<DamageType> backUpdamageType;

	bAlreadyDead = (Health <= 0);
	flatMomentum = momentum;

	backUpdamageType = damageType;

	//log("GLOBAL TAKE DAMAGE ["$name$"]: damage["$damage$"] by["$instigatedBy$"] type["$damagetype$"] pill["$pilltag$"] health["$health$"] ex["$AmbientDamagePerSeconds$"/"$AmbientDamageFromFire$"] ["$GetStateName()$"]");

	// calculate and apply force of damage
	if (Physics == PHYS_Walking)
		flatMomentum.Z = FMax(flatMomentum.Z, 0.7 * VSize(momentum));

	// Blood effect
	if ((damageType == None) && (!bNoBlood))
    {
		Spawn(class'EBloodSplat', self,, HitLocation, Rotator(Normal(momentum)));
    }

	if (instigatedBy == self) 
		flatMomentum *= 0.6;
	flatMomentum = flatMomentum / Mass;

	AddVelocity(flatMomentum);

	// Check to be sure there is a pill .. else, use body pill
	if (PillTag == 0)
		PillTag = GetApproxPillFromHit(HitLocation);

	// Gives real damage depending on the hit zone
	ResolveDamage(damage, PillTag, damageType);
	
	//Play HitSound depending on the pill
	if (damageType == None)
	{
		if (VSize(Hitlocation) != 0)
		{
		if (PillTag == 1) //head
			PlaySound(Sound'GunCommon.Play_BulletHitHead', SLOT_SFX);
		else //rest of body
			PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);
		}

		if (bIsDog)
			PlaySound(EDog(self).DogHit, SLOT_SFX);
	}
	// If knocked but not on head
	else if (damageType.name == 'EKnocked' && PillTag != P_Head)
	{
		damageType = None;
	}

	//Log(self@damage@damagetype@health);

	// Spawn flames on burned actor if fire comes from another source
	if (damageType != None && damageType.name == 'EBurned' && instigatedBy != self)
		CatchOnFire();

	if (Controller == None)
		return;

	// play damage animations
	if (Health > 0)
	{
		// animation
		if ((Level.TimeSeconds - EAIController(Controller).DamageTimer > 1.5f)  && 
           (Controller.GetStateName() != 's_alarmswitch') && (Controller.GetStateName() != 's_Groggy') &&
		   damageType == None)
			PlayHitE(PillTag, HitLocation, momentum);

		MakeNoise(500.0, NOISE_Scream, CollisionHeight * 2.0f); 

		// resolve other damage types
		ResolveDamageType(PillTag, momentum, damageType);
			
		if (instigatedBy != Self && Controller != None && (Controller.GetStateName() != 's_alarmswitch'))
		{
			//plog("passing damage to controller.");
			Controller.damageAttitudeTo(instigatedBy, Damage, backUpdamageType,PillTag);
		}

		if (instigatedBy != Self && Controller != None && !bIsPlayerPawn && instigatedBy != None && instigatedBy.bIsPlayerPawn && !EAIController(Controller).bWasInjured && !EAIController(Controller).bNotInStats)
		{
			if (!EAIController(Controller).bWasKnockedOut)
			{
				if (bIsDog)
				{
					EPlayerController(instigatedBy.Controller).playerStats.AddStat("EnemyInjured");
					EAIController(Controller).bWasInjured = true;
				}
				else if (bHostile)
				{
					EPlayerController(instigatedBy.Controller).playerStats.AddStat("EnemyInjured");
					EAIController(Controller).bWasInjured = true;
				}
				else
				{
					EPlayerController(instigatedBy.Controller).playerStats.AddStat("CivilianInjured");
					EAIController(Controller).bWasInjured = true;
				}
			}
		}
	}
	else if (!bAlreadyDead)
	{
		if (damageType != None)
		{
			bDontPlayDeathAnim = false;
			DesignerDeathAnim = '';
		}

		if (Controller != None)
		{
			Controller.NextState = '';
			Controller.Enemy = instigatedBy;
		}
		if (instigatedBy != None)
			Killer = instigatedBy.Controller;

		LastDamageType = damageType;
		DiedE(Killer, PillTag, momentum);
	}
}

//------------------------------------------------------------------------
// Description		
//		Resolves damage depending on damagetype and hitlocation
//------------------------------------------------------------------------
function ResolveDamage(out int Damage, out int PillTag, out class<DamageType> damageType)
{
	//Log("Hit damage="$Damage$" of type="$damagetype$" on pill="$PillTag$" health="$health$" w/ modifier="$DamageLookupTable[PillTag-1]);
	if (damageType == None)
	{
		Health -= Damage * DamageLookupTable[PillTag - 1] / 100/*%*/;
	}
	// Check to lose consciousness
	else if ((damageType == class'EKnocked' && Health - Damage <= 0)							||	// Knocked and no more health
			 (damageType == class'EStunned' && (Health - Damage <= 0 || PillTag == P_Head))	||	// Stunned and no more health OR directly on the head
			 (damageType == class'ESleepingGas' && Health - Damage < 20))						// Smoke and mim health reached
	{
		Damage		= 0;
		PillTag		= P_Head;
		damageType	= class'EKnocked';
	}
	else
	{
		Health -= Damage;
		if (damageType == class'EKnocked' && Health > 0 && GetStateName() != 's_Grabbed') //1st time knocked
		{
			Bark_Type = BARK_KnockedOut;
			PlaySound(Sounds_Barks,SLOT_SFX);
		}
	}
}

//------------------------------------------------------------------------
// Description		
//		Sends Pawn & controller in different state
//------------------------------------------------------------------------
function ResolveDamageType(int PillTag, vector Momentum, class<DamageType> DamageType)
{
	local int Speed;
	//Log("Global ResolveDamageType"@PillTag@Momentum@DamageType);

	if (DamageType == None)
		return;

	Speed = VSize(Velocity);
	switch (DamageType.name)
	{
		case 'EKnocked':
			Knocked(PillTag, Momentum); 
			break;
		
		case 'EElectrocuted':
			Electrocuted(); 
			break;
		
		case 'ESleepingGas':
			if (Speed < 0.7f * GetMoveSpeed(MOVE_JogAlert) || Health <= 50)
				Stunned('Gassed');
			break;
		
		case 'EBurned':
			if (Speed < 0.7f * GetMoveSpeed(MOVE_JogAlert) || Health <= 70)
				Stunned('Burned');
			break;
		
		case 'EStunned':
			Stunned('Stunned');
			break;
	}
}

//------------------------------------------------------------------------
// Description		
//		Play Damage depending on hit bone
//		Redefined in EAIPawn for special NPC handling.
//------------------------------------------------------------------------
function PlayHitE(int PillTag, Vector HitLocation, Vector Momentum)
{
	local Name		AnimName;
	local Vector	PawnXAxis, HitDir;
	local bool		bFront;

	// we're in root motion -- don't play animation
	if (!bCollideWorld)
	{
		//plog("PlayHitE returning -- bCollideWorld is false");
		return;
	}

	// if we're peeking around a corner, instead of tweening a damage animation, just undo the peek
	if (bCoverPeeking)
	{
		CoverPeekEnd();
		return;
	}


	//Log("hit on bone"@PillTag);
	Switch (PillTag)
	{
		case P_Head :
			if (bFront)
			{
				//log("front head");
				AnimName = ADamageHeadShotForward;
			}
			else
			{
				//log("back head");
				AnimName = ADamageHeadShotForward;//ADamageHeadShotBack;
			}
			break;

		case P_LUpperArm :
		case P_LForeArm :
			//log("left arm");
			AnimName = ADamageArmLeft;
			break;

		case P_LHand :
			AnimName = AHurtHandLeft;
			break;

		case P_RUpperArm :
		case P_RForeArm :
			//log("right arm");
			AnimName = ADamageArmRight;
			break;

		case P_RHand :
			AnimName = AHurtHandRight;
			break;

		case P_LBody :
			//log("left body");
			AnimName = ADamageChestLeft;
			break;

		case P_RBody :
			//log("right body");
			AnimName = ADamageChestRight;
			break;

		case P_LThigh :
		case P_LCalf :
			//log("left leg");
			AnimName = ADamageLegLeft;
			break;
			
		case P_LFoot :
			AnimName = AHurtFootLeft;
			break;

		case P_RThigh :
		case P_RCalf :
			//log("right leg");
			AnimName = ADamageLegRight;
			break;

		case P_RFoot :
			AnimName = AHurtFootRight;
			break;
	}
	
	//Log(self$" Playhit animation "$AnimName);
	if (bInTransition)
		PlayAnimOnly(AnimName,,0.30);
	else
		PlayAnimOnly(AnimName,,0.10);
	//BlendAnimOverCurrent(AnimName, 0.7, UpperBodyBoneName,,0.2);
}

//------------------------------------------------------------------------
// Description		
//		Should only and maybe not even depend on Bone hit to properly play
//		Velocity falling
//------------------------------------------------------------------------
function PlayDyingE(int PillTag, vector momentum)
{
	local Name Anim;

	if (bDontPlayDeathAnim && DesignerDeathAnim == '')
		return;
	else if (DesignerDeathAnim != '')
		Anim = DesignerDeathAnim;

	// native function will decide what animation to play based on input PillTag and any current momentum
	if (Anim == '')
	Anim = ChooseDeathAnimation(PillTag, momentum);

	// in case anim is not set (bad pilltag, etc.)
	if (Anim == '')
		Anim = ADeathDown;
	
	else if (Anim == ADeathLadder)
		bFallToDeath = true;

	if (GetAnimName() != Anim)
	PlayAnimOnly(Anim, 1.0, 0.2);
}

//------------------------------------------------------------------------
// Description		
//		Same as Died, but for unconscious
//------------------------------------------------------------------------
function Knocked(int PillTag, vector momentum)
{
	// Play Anims & Sound
	PlayDyingE(PillTag, momentum);

	StopAllSoundsActor(true);

	Bark_Type = BARK_KnockedOut;
	PlaySound(Sounds_Barks,SLOT_SFX);

	MakeNoise(KnockedGaspRadius, NOISE_DyingGasp);

	if (Controller != None)
		Controller.GotoState('s_Unconscious');
	GotoState('s_Unconscious');
}

function FallDeadLadder()
{
	PlayAnimOnly(ChooseDeathAnimation(0, vect(0,0,0)), 2.0 ,0.2);
	bFallToDeath = true;
	if (Controller != None)
		Controller.GotoState('s_Unconscious');
	GotoState('s_FallToDeath');
}
//------------------------------------------------------------------------
// Description		
//		Same as Died, but for electrification
//------------------------------------------------------------------------
function Electrocuted()
{
	// must check before Controller.GotoState('s_Unconscious');
	if (EAIController(Controller) != None && EAIController(Controller).bIsOnLadder)
	{
		FallDeadLadder();
		return;
	}

	if (!Controller.bIsPlayer)
	{
		MakeNoise(ElectrocutedGaspRadius, NOISE_DyingGasp);
	}

	if (Controller != None)
		Controller.GotoState('s_Unconscious');
	GotoState('s_Electrocuted');
}

//------------------------------------------------------------------------
// Description		
//		Same as Died, but for stunned
//------------------------------------------------------------------------
function Stunned(name Label)
{
	// must check before Controller.GotoState('s_Unconscious');
	if (EAIController(Controller) != None && EAIController(Controller).bIsOnLadder)
	{
		FallDeadLadder();
		return;
	}

	GotoState('s_Stunned',Label);
}

//---------------------------------------[ Alain Turcotte @ 18 Jul 2001 ]-
// Prototype		Died
// 
// Description		Shortcut to controller change state
//------------------------------------------------------------------------
function DiedE(Controller Killer, int PillTag, vector momentum)
{
	// used to check bDeleteMe flag, but we're not destroying pawns right now
	// used to make sure health was below 0
	// used to inform all other controllers of death
	// used to inform GameInfo of event
	// used to drop inventory

	// Change mesh for dude on fire before death anim
	//if (!Controller.bIsPlayer && BodyFlames.Length > 0)
	//	Do change SKINS

	// Play Anims & Sound
	PlayDyingE(PillTag, momentum);

	StopAllSoundsActor(true);
	
	if (!Controller.bIsPlayer)
	{
		if (bIsDog)
		{
			PlaySound(EDog(self).StopBreath, SLOT_SFX);
			PlaySound(EDog(self).DogHit, SLOT_SFX);
		}
		else
		{
			if (LastDamageType != None && LastDamageType.name == 'EBurned')
				Bark_Type = BARK_InFire;
			else
				Bark_Type = BARK_Dying;

			PlaySound(Sounds_Barks,SLOT_Barks);
		}
	}

	// send trigger event on death ..
	if (Killer != None)
	{
		// add body to ChangedActorsList
		if (Killer.bIsPlayer)
		{
			bKilledByPlayer = true;
			MakeNoise(DyingGaspRadius, NOISE_DyingGasp);
		}
		// If Npc killed the player
		else if (Controller.bIsPlayer)
            EAIController(Killer).NotifyKilledPlayer(self);


		TriggerEvent(Event, self, Killer.Pawn);			
	}
	else
		TriggerEvent(Event, self, None);

	// Don't call this on Controller cause he already calls it on himself in PawnDied
	if (Controller != None && !Controller.bIsPlayer)
	{
		//Log("EPawn Died -- Controller.GotoState('s_Dead');"@self@Controller);

		if (bKeepNPCAlive)
			Controller.GotoState('s_Unconscious');
		else
		    Controller.GotoState('s_Dead');
	}

	if (bFallToDeath)
		GotoState('s_FallToDeath');
	else if (bKeepNPCAlive)
		GotoState('s_Unconscious');
	else
	    GotoState('s_Dying');
}

//************************************************************************
//************************************************************************
//*********														   *******
//********			        AI SPECIFIC ANIMS ?                     ******
//*********														   *******
//************************************************************************
//************************************************************************


//----------------------------------------[David Kalina - 5 Feb 2002]-----
// 
// Description
//		TableAnims interface.
// 
//------------------------------------------------------------------------

function SitDown(bool RightSide, optional bool bUsingTable)
{
	//plog("SitDown called : bRightSide?  " $ RightSide);
	
	LockRootMotion(1, true);					// lock the root with root rotation enabled

	if (!bUsingTable)
	{
		Transition_RootMotion('s_Sitting', ASitDownF, AWaitSitS);
	}
	else
	{
		if (RightSide)
			Transition_RootMotion('s_Sitting', ASitDownR, AWaitSitT);
		else
			Transition_RootMotion('s_Sitting', ASitDownL, AWaitSitT);
	}

	GotoState('s_Transition');
}

function StandUp(bool RightSide, optional bool bUsingTable)
{
	//plog("******************************* Standup called : bRightSide?  " $ RightSide);

	log("StandUp pawn: "$self);

	// make sure we have a valid transition target
	if (AWait == '')
		SwitchAnims();

	LockRootMotion(1, true);					// lock the root with root rotation enabled
	
	if (!bUsingTable)
	{
		Transition_RootMotion('DefaultState', AStandUpF, AWait);
	}
	else
	{
		if (RightSide)
			Transition_RootMotion('DefaultState', AStandUpR, AWait);
		else
			Transition_RootMotion('DefaultState', AStandUpl, AWait);
	}

	GotoState('s_Transition');
}



//----------------------------------------[David Kalina - 5 Dec 2001]-----
// 
// Description
//		Should return the current Pawn MoveSpeed (max. speed)
//		Based on MoveFlags for NPC.
//
//------------------------------------------------------------------------

event float GetMoveSpeed(MoveFlags MoveFlags)
{
	return GroundSpeed;
}




//---------------------------------------[David Kalina - 20 Nov 2001]-----
// 
// Description
//		Choose appropriate transition animation for an NPC throwing a grenade.
// 
//------------------------------------------------------------------------

function PlayThrowGrenade(vector ThrowVelocity)
{
	// TODO : choose animation based on ThrowVelocity -- for now just using overhand toss

	// no tweening -- item selection has us ready to go..
	Transition_Standard(AThrowGrenade, 0.0f, true);

	GotoState('s_Transition');
}

//---------------------------------------[David Kalina - 24 Oct 2001]-----
//
// CoverPeek* 
//
// Description
//		EAIController interface for managing NPC cover peek animations.
//
//------------------------------------------------------------------------

function CoverPeekLeft()
{
	if (!bCoverPeeking)
	{
		bCoverPeeking  = true;
		
		AWait			= APeekLeft;
		
		Transition_Standard(APeekLeftBegin, 0.3f, false);

		GotoState('s_Transition');
	}
}


function CoverPeekRight()
{
	if (!bCoverPeeking)
	{
		bCoverPeeking  = true;
				
		AWait			= APeekRight;

		Transition_Standard(APeekRightBegin, 0.3f, false);

		GotoState('s_Transition');
	}
}

function CoverPeekUp()
{
	if (!bCoverPeeking)
	{
		bCoverPeeking = true;

		AWait			= 'waitStAlFd2';

		CheckForTransition(MOVE_WalkAlert);		// set transition for standing
				
		SwitchAnims();
		
		if (TransitionQueue.Length > 0)
			GotoState('s_Transition');
	}
}

function CoverPeekEnd()
{
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName();
	
	if (bCoverPeeking)
	{
		bCoverPeeking = false;
			
		SwitchAnims();		// will reset to AWait appropriate for current MoveFlag
		
		if (CurrentAnimSeq == APeekLeft)
			Transition_Standard(APeekLeftBegin, 0.3f, false, true);

		else if (CurrentAnimSeq == APeekRight)
			Transition_Standard(APeekRightBegin, 0.3f, false, true);

		if (TransitionQueue.Length > 0)			
			GotoState('s_Transition');
	}
}



//----------------------------------------[David Kalina - 6 Mar 2002]-----
// 
// Description
//		Called when shot narrowly misses Pawn (e.g. hat shot off of our head)
//		Forward event to EAIController in EAIPawn
// 
//------------------------------------------------------------------------

function NotifyShotJustMissed(Pawn Instigator) {}


//************************************************************************
//************************************************************************
//*********														   *******
//********			        GE SPECIFIC ZONES                       ******
//*********														   *******
//************************************************************************
//************************************************************************

function ResetZones()
{
	if (bIsCrouched)
	{
		m_CurrentArmsZone = m_CrouchedArmsZone;
		m_CurrentArmsRadius = m_CrouchedArmsRadius;
		m_CurrentFeetZone = m_CrouchedFeetZone;
		m_CurrentFeetRadius = m_CrouchedFeetRadius;
	}
	else
	{
		m_CurrentArmsZone = m_NormalArmsZone;
		m_CurrentArmsRadius = m_NormalArmsRadius;
		m_CurrentFeetZone = m_NormalFeetZone;
		m_CurrentFeetRadius = m_NormalFeetRadius;
	}
}

function SetCrouchedZones()
{
	m_CurrentArmsZone = m_CrouchedArmsZone;
	m_CurrentArmsRadius = m_CrouchedArmsRadius;
	m_CurrentFeetZone = m_CrouchedFeetZone;
	m_CurrentFeetRadius = m_CrouchedFeetRadius;
}

function SetNormalZones()
{
	m_CurrentArmsZone = m_NormalArmsZone;
	m_CurrentArmsRadius = m_NormalArmsRadius;
	m_CurrentFeetZone = m_NormalFeetZone;
	m_CurrentFeetRadius = m_NormalFeetRadius;
}

function SetLedgeGrabZones()
{
	m_CurrentArmsZone = m_LedgeGrabArmsZone;
	m_CurrentArmsRadius = m_LedgeGrabArmsRadius;
}

function SetHandOverHandZones()
{
	m_CurrentArmsZone = m_HandOverHandArmsZone;
	m_CurrentArmsRadius = m_HandOverHandArmsRadius;
}

function SetNarrowLadderZones()
{
	m_CurrentArmsZone = m_NarrowLadderArmsZone;
	m_CurrentArmsRadius = m_NarrowLadderArmsRadius;
}

function SetPipeZones()
{
	m_CurrentArmsZone = m_PipeArmsZone;
	m_CurrentArmsRadius = m_PipeArmsRadius;
}

function SetZipLineZones()
{
	m_CurrentArmsZone = m_ZipLineArmsZone;
	m_CurrentArmsRadius = m_ZipLineArmsRadius;
}

function SetPoleZones()
{
	m_CurrentArmsZone = m_PoleArmsZone;
	m_CurrentArmsRadius = m_PoleArmsRadius;
}

function SetFenceZones()
{
	m_CurrentArmsZone = m_FenceArmsZone;
	m_CurrentArmsRadius = m_FenceArmsRadius;
}



//
//
// NPC WEAPON / ITEM SELECTION
// Note that weapon is always effectively "selected" for an EAIPawn.
// Also, the WeaponStance variable is used to tell us what type of weapon we have available -- 
// it does not necessarily correspond with our actual stance, as NPC's in default alertness
// will have their weapons at their sides when the game begins.
//
// This code allows the switching of weapons from their "away" and "equipped" locations.
// If an s_Transition's STransitionInfo specifies a WeaponAwayBone, AttachWeaponToHand will be called at the transition animation's Notify.
//
//


//---------------------------------------[David Kalina - 30 Apr 2002]-----
// 
// Description
//		Wrapper for adding Transition that will select our current weapon.
//
//------------------------------------------------------------------------

event Transition_WeaponSelect()
{
	// set WeaponStance so any subsequent animations chosen are from the appropriate set ..
	WeaponStance = WeaponHandedness;

	if (WeaponStance > 0)
	{
	AddTransition('s_Waiting',,,,0.2f,,true,TRANN_WeaponSelect);
	plog("			Transition_WeaponSelect.");
}
}

//---------------------------------------[David Kalina - 30 Apr 2002]-----
// 
// Description
//		Wrapper for adding Transition that will de-select our current weapon.
// 
//------------------------------------------------------------------------

event Transition_WeaponAway()
{
	// if a weapon is in our hands, add the corresponding transition
	if (WeaponStance > 0) 
	{
		plog("			Transition_WeaponAway.");

		//be sure the loop sound is not playing
		if (HandItem != none && HandItem == CurrentWeapon)
		{
			CurrentWeapon.StopLoopSound();
		}

		AddTransition('s_Waiting',,,,0.2f,,true,TRANN_WeaponAway);
	}
}


//----------------------------------------[David Kalina - 2 May 2002]-----
// 
// Description
//		Item selection goes through same process as weapon selection,
//		except PendingItem is set so transition code knows to select item, not weapon.
// 
//------------------------------------------------------------------------

event Transition_ItemSelect(EInventoryItem NewItem)
{	
	PendingItem = NewItem;
	plog("			Transition_ItemSelect.");
	AddTransition('s_Waiting',,,,0.2f,,true,TRANN_ItemSelect);	
}


//---------------------------------------[David Kalina - 30 Apr 2002]-----
// 
// Description
//		Attach selected weapon to appropriate bone location based on 
//		InitialAIState.
//
//------------------------------------------------------------------------

function InitWeaponAttach()
{
	switch (InitialAIState)
	{
		case EAIS_Default : 

			AttachWeaponAway();
			break;

		case EAIS_Aware : 
		case EAIS_Alert : 

			AttachWeaponToHand();
			break;
	}
}


//----------------------------------------[David Kalina - 2 May 2002]-----
// 
// Description
//		Called when playing a transition with a NotifyType specified.
//		Attach / Detach weapon or item depending on NotifyType.
// 
//------------------------------------------------------------------------

event AI_AttachNotify()
{
	if (TransitionQueue.Length == 0)
	{
		log("WARNING : AI_AttachNotify called outside s_Transition?");
		AttachWeaponToHand();
	}
	else
	{
		// if we're playing the animation backwards, call AttachWeaponAway
		switch (TransitionQueue[0].NotifyType) 
		{
			case TRANN_WeaponSelect : 
				AttachWeaponToHand();
				break;
			
			case TRANN_WeaponAway :
				AttachWeaponAway();
				break;

			case TRANN_ItemSelect : 
				AttachItemToHand();
				break;
		}

		// reset transition notify type so s_Transition.EndState() will not call us agaiin.
		TransitionQueue[0].NotifyType = TRANN_None;
	}
}


//---------------------------------------[David Kalina - 30 Apr 2002]-----
// 
// Description
//		Attachs weapon to "Away" bone location.
//
//		Re-define in sub-classes for special cases.
// 
//------------------------------------------------------------------------

function AttachWeaponAway()	
{
	// Equip whatever we have in hand -- we are only looking for weapons in this function
	if (CurrentWeapon != None)
	{	
		plog("		Pre AttachWeaponAway -- CurrentWeapon  " $ CurrentWeapon $ "  HandItem  " $ HandItem $ "  PendingItem  " $ PendingItem $  "  WeaponStance " $ WeaponStance);

		if (WeaponHandedness == 1) 
		{
			FullInventory.UnEquipItem(FullInventory.GetSelectedItem());
			AttachToBone(CurrentWeapon, 'OneHandAwayBone');
			CurrentWeapon.SetRelativeRotation(rot(0,0,0));
		}
		else if (WeaponHandedness == 2)
		{
			FullInventory.UnEquipItem(FullInventory.GetSelectedItem());
			AttachToBone(CurrentWeapon, 'TwoHandAwayBone');
			CurrentWeapon.SetRelativeRotation(rot(-2000,-1000,0));
		}

		CurrentWeapon.bHidden = false;	// make sure unequipping item doesn't hide it
		WeaponStance = 0;
		
		plog("		Post AttachWeaponAway -- CurrentWeapon  " $ CurrentWeapon $ "  HandItem  " $ HandItem $ "  PendingItem  " $ PendingItem $  "  WeaponStance " $ WeaponStance);
	}
}

//---------------------------------------[David Kalina - 30 Apr 2002]-----
// 
// Description
//		Equips weapon by attaching it to WeaponBone.
//
//------------------------------------------------------------------------

function AttachWeaponToHand()
{
	// Equip Current Weapon by placing it in hand
	if (CurrentWeapon != None)
	{		
		plog("		AttachWeaponToHand -- CurrentWeapon  " $ CurrentWeapon $ "  HandItem  " $ HandItem $ "  PendingItem  " $ PendingItem $  "  WeaponStance " $ WeaponStance);

		FullInventory.SetSelectedItem(CurrentWeapon);

		HandItem = CurrentWeapon;

		AttachToBone(CurrentWeapon, 'WeaponBone');		
		CurrentWeapon.SetRelativeLocation(vect(0,0,0));
		CurrentWeapon.SetRelativeRotation(rot(0,0,0));
		CurrentWeapon.bHidden = false;			

		WeaponStance = WeaponHandedness;

		// update animation set now that weapon handedness has changed
		SwitchAnims();

		plog("		Post AttachWeaponToHand -- CurrentWeapon  " $ CurrentWeapon $ "  HandItem  " $ HandItem $ "  PendingItem  " $ PendingItem $  "  WeaponStance " $ WeaponStance);
	}
}


//----------------------------------------[David Kalina - 2 May 2002]-----
// 
// Description
//		Attach PendingItem to our hand and set as selected item.
// 
//------------------------------------------------------------------------

function AttachItemToHand()
{
	// select item if PendingItem not null.
	if (PendingItem != none)
	{
		plog("		Pre AttachItemToHand -- CurrentWeapon  " $ CurrentWeapon $ "  HandItem  " $ HandItem $ "  PendingItem  " $ PendingItem $  "  WeaponStance " $ WeaponStance);

		FullInventory.SetSelectedItem(PendingItem);

		// Remove previous attachment and replace with GameplayObj		
		HandItem = PendingItem;
		
		AttachToBone(PendingItem, 'WeaponBone');
		PendingItem.SetRelativeLocation(Vect(0,0,0));

		PendingItem = none;
		
		SwitchAnims();

		plog("		Post AttachItemToHand -- CurrentWeapon  " $ CurrentWeapon $ "  HandItem  " $ HandItem $ "  PendingItem  " $ PendingItem $  "  WeaponStance " $ WeaponStance);
	}
}


//----------------------------------------[David Kalina - 1 May 2002]-----
// 
// Description
//		Return the appropriate Weapon Selection animation for this NPC.
// 
//------------------------------------------------------------------------

function name GetWeaponSelectAnim()
{
	return '';
}

//----------------------------------------[David Kalina - 2 May 2002]-----
// 
// Description
//		Return current appropriate item selection animation.
// 
//------------------------------------------------------------------------

function name GetItemSelectAnim();


//---------------------------------------[David Kalina - 14 May 2002]-----
// 
// Description
//		Try to get distance we wish to be within from weapon.
//		Otherwise return default property value.
// 
//------------------------------------------------------------------------

function float GetPlayerFarDistance()
{
	if (CurrentWeapon != none)	
		return CurrentWeapon.NPCPreferredDistance;
	else
		return PlayerFarDistance;
}

function float GetPlayerCloseDistance()
{
	if (CurrentWeapon != none)
		return (CurrentWeapon.NPCPreferredDistance - 100.0);
	else
		return PlayerCloseDistance;
}


//************************************************************************
//************************************************************************
//*********														   *******
//********			              STATES                            ******
//*********														   *******
//************************************************************************
//************************************************************************

// ----------------------------------------------------------------------
// state DefaultState
// ----------------------------------------------------------------------
auto state DefaultState
{
}



// ----------------------------------------------------------------------
// state s_Falling -- NPC ONLY
// ----------------------------------------------------------------------

function Fall()
{
	//log("FALL -- goto s_Falling ---------------------------");
	GotoState('s_Falling');
}

function FindFallSpot()
{
	if (FastPointCheck(ToWorld(vect(0, 72, 0)), GetExtent(), true, true))
		Move(ToWorldDir(vect(0, 72, 0)));
	else if (FastPointCheck(ToWorld(vect(0, -72, 0)), GetExtent(), true, true))
		Move(ToWorldDir(vect(0, -72, 0)));
	else if (FastPointCheck(ToWorld(vect(-72, 0, 0)), GetExtent(), true, true))
		Move(ToWorldDir(vect(-72, 0, 0)));
	else if (FastPointCheck(ToWorld(vect(72, 0, 0)), GetExtent(), true, true))
		Move(ToWorldDir(vect(72, 0, 0)));
}

state s_Falling
{
	Ignores PlayBlend, UpdateAnimationSet, PlayWaitingBlend;
	
	function BeginState()
	{
		PlayAnim(AFall,,0.2);
		setPhysics(PHYS_Falling);
	}
	
	function Landed(vector HitNormal)
	{
		//log("S_FALLING ---- LANDED??");
		setPhysics(PHYS_Walking);
		GotoState('DefaultState');
	}
	
}

//
//
//	s_Waiting -- we have come to a complete stop if we are in this state
//
//

state s_Waiting
{
	// this means it's time to exit ...
	function PlayBlend(SAnimBlend anims, Rotator lookDir, vector moveDir, float minForwardRatio, float TweenTim, optional bool noloop)
	{
		// play Wait to Move transition if it exists ..
		if (AWaitOut != '')
		{
			AddTransition('DefaultState', AWaitOut,, 0.45f, 0.3f,,true);
			GotoState('s_Transition');
		}
	    else
	    {
		    // tweening to wait anims
		    AddTransition('DefaultState', AWait,, 0.275f, 0.3f,,true);
            GotoState('s_Transition');
	    }

	}

	//---------------------------------------[David Kalina - 17 Dec 2001]-----
	// 
	// Description
	//		s_Waiting version of PlayWaitingBlend assumes we have already come to a full stop.
	// 
	// Input
	//		ForwardDirection : The direction our legs should be facing
	//		FocusDirection :   Direction we should be looking at right now (body/head).
	//		YawDiff : Any difference here indicates a turn might be necessary.
	//
	//------------------------------------------------------------------------

	event PlayWaitingBlend(vector ForwardDirection, vector FocusDirection, float YawDiff, float TweenTime)
	{
		local vector moveDir, vLookDir, vCross;
		local float fDot, fRatio;


		if (Abs(YawDiff) > 0) 
		{
			if (!IsTweening(0))
				RotateTowardsRotator(Rotator(ForwardDirection), Controller.GetTurnSpeed());
		}

		if (Abs(CurrentYawDiff) < 8192)
		{
			LoopAnim(AWait,,TweenTime);

			if (AWaitLeft != '' && AWaitRight != '' && !bCoverPeeking)
			{
				FocusDirection.Z	= 0.0f;
				FocusDirection		= Normal(FocusDirection);

				ForwardDirection.Z	= 0.0f;
				ForwardDirection	= Normal(ForwardDirection);

				fDot = FocusDirection Dot ForwardDirection;

				//log("  FocusDirection:   " $ FocusDirection $ "  ForwardDirection : "$ ForwardDirection $ "    dotproduct : " $ fDot);

				if (Abs(fDot) < 0.999)
				{
					fRatio	= Acos(Abs(fDot)) * TWOOVERPI;
					vCross = FocusDirection Cross ForwardDirection;

					//log("	fRatio: " $ fRatio @ "   vCross : " $ vCross.Z);
					
					if (vCross.Z < 0.0)
						SynchAnim(AWaitRight, BLENDMOVEMENTCHANNEL, TweenTime, fRatio);
					else
						SynchAnim(AWaitLeft, BLENDMOVEMENTCHANNEL, TweenTime, fRatio);
				}
				else
					AnimBlendToAlpha(BLENDMOVEMENTCHANNEL,0,0.10);
			}
			else
				AnimBlendToAlpha(BLENDMOVEMENTCHANNEL,0,0.10);
		}
	}
}



// ----------------------------------------------------------------------
// state s_LadderClimbing 
//		should only be initiated when pawn is already in exact place to start
// ----------------------------------------------------------------------

function ClimbLadder(bool bClimbingUp)
{
	if (bClimbingUp)
	{
		// set up root motion transition -- no rotation

		LockRootMotion(1, false);							

		Transition_RootMotion('s_LadderClimbing', ANLInBottom, ANLWaitRight);
				
		GotoState('s_Transition');
	}
}

state s_LadderClimbing
{
	function BeginState()
	{
		m_climbingUpperHand = CHRIGHT;
		SetPhysics(PHYS_Linear);
	}

	function ClimbLadder(bool bClimbingUp)
	{
		if (bClimbingUp)
		{
			
		}

		PlayNarrowLadderWait(0.0f);
	}
}



// ----------------------------------------------------------------------
// state s_Transition
//		Plays ATransition and waits for it to finish before returning
//		to Default State.  
//
//		Make sure you ignore any necessary incoming event calls!!!!!!
// ----------------------------------------------------------------------

function AddTransition(name TargetState, optional name TransitionAnim, optional name TargetAnimation, optional float Time, optional float TweenTime, optional bool bRootMotion, optional bool bAllowRotation, optional ETransitionNotifyType NotifyType, optional bool bBackwards)
{	
	local int i;

	TransitionQueue.Length = TransitionQueue.Length + 1;

	TransitionQueue[TransitionQueue.Length - 1].TransitionState				= TargetState;
	TransitionQueue[TransitionQueue.Length - 1].ATransition					= TransitionAnim;
	TransitionQueue[TransitionQueue.Length - 1].ATransitionTarget				= TargetAnimation;
	TransitionQueue[TransitionQueue.Length - 1].TransitionTime				= Time;		
	TransitionQueue[TransitionQueue.Length - 1].TransitionTween				= TweenTime;		
	TransitionQueue[TransitionQueue.Length - 1].bRootMotionTransition			= bRootMotion;		
	TransitionQueue[TransitionQueue.Length - 1].bTransitionWithRotation		= bAllowRotation;	
	TransitionQueue[TransitionQueue.Length - 1].NotifyType					= NotifyType;
	TransitionQueue[TransitionQueue.Length - 1].bBackwards					= bBackwards;

	for (i = 0; i < TransitionQueue.Length; i++)
		plog("TransitionQueue[ " $ i $ "] ==> " 
			@ TransitionQueue[i].TransitionState 
			@ TransitionQueue[i].ATransition 
			@ TransitionQueue[i].ATransitionTarget
			@ TransitionQueue[i].TransitionTime
			@ TransitionQueue[i].TransitionTween
			@ TransitionQueue[i].bRootMotionTransition
			@ TransitionQueue[i].bTransitionWithRotation
			@ TransitionQueue[i].NotifyType
			@ TransitionQueue[i].bBackwards
);

}




//----------------------------------------[David Kalina - 1 May 2002]-----
// 
// Description
//		Adds standard root motion type transition -- 
//		Root motion transitions must enable root motion, disable turning,
//		specify a target animation, and not tween.
//
//------------------------------------------------------------------------

function Transition_RootMotion(name TargetState, name TransitionAnim, name TargetAnim)
{
	plog("Transition RootMotion : " $ TargetState @ TransitionAnim @ TargetAnim);
	AddTransition(TargetState, TransitionAnim, TargetAnim,,,true,false);
}


//----------------------------------------[David Kalina - 1 May 2002]-----
// 
// Description
//		No Frills, "Standard" type transition used for most MoveFlag transitions.
// 
//------------------------------------------------------------------------

function Transition_Standard(name TransitionAnim, float TweenTime, bool bAllowRotation, optional bool bBackwards)
{
	plog("Transition Standard : " $ TransitionAnim @ TweenTime @ bAllowRotation @ bBackwards);
	AddTransition('s_Waiting', TransitionAnim,,,TweenTime,,bAllowRotation,,bBackwards);
}



state s_Transition
{
	Ignores PlayThrowGrenade, UpdateAnimationSet, PlayBlend,		// must ignore function calls that can cause another s_Transition
		CoverPeekLeft, CoverPeekRight, CoverPeekUp, CoverPeekEnd;

	function BeginState()	
	{
		local float AnimTime;

		TmpDamage = 0;

		if (TransitionQueue.Length == 0)
		{
			log("WARNING:  s_Transition : transition queue is empty.");
			GotoState('DefaultState');
			return;
		}
		
		// if TransitionNotify type specified, use that to get animation 

		switch (TransitionQueue[0].NotifyType)
		{
			case TRANN_WeaponSelect : 
			case TRANN_WeaponAway : 
				TransitionQueue[0].ATransition = GetWeaponSelectAnim();		
				if (CurrentWeapon.IsA('EOneHandedWeapon'))
					PlaySound(Sound'FisherEquipement.Play_FisherPistolAim', SLOT_SFX);
				else
					PlaySound(Sound'FisherEquipement.Play_FN2000Aim', SLOT_SFX);
				break;

			case TRANN_ItemSelect : 
				TransitionQueue[0].ATransition = GetItemSelectAnim();
				break;
		}

		// make sure selected animation is valid 

		AnimTime = GetAnimTime(TransitionQueue[0].ATransition);

		if (TransitionQueue[0].ATransition == '' || AnimTime == 0.0f)
		{
			log("WARNING:  s_Transition : invalid transition anim specified.");
			GotoState(TransitionQueue[0].TransitionState);
			bInTransition = false;

			return;
		}

		// everything should be set here ..

		plog("-------- BEGIN STATE ATransition : " $ TransitionQueue[0].ATransition $ "   ATransitionTarget : " $ TransitionQueue[0].ATransitionTarget);
				
		if (TransitionQueue[0].TransitionTime > 0.0f)
			SetTimer(TransitionQueue[0].TransitionTime, false);
		else
		{
			//keep it safe
			if (AnimTime != 0.0f)
				SetTimer(AnimTime + 0.05f, false);
		}
		
		bInTransition = true;
		
		// root motion -- play anim before setting physics
		if (TransitionQueue[0].bRootMotionTransition)
		{	
			// don't PlayAnimOnly as we might want to blend over the root motion
			bCollideWorld = false;
			PlayAnim(TransitionQueue[0].ATransition, RandomizedAnimRate, 0.0f, 0);
			SetPhysics(PHYS_RootMotion);
		}

		// phys_walking - no movement during transition
		else
		{				
			// PlayAnimOnly because we must make sure to stop any active movement channels
			Acceleration = vect(0,0,0);				
			
			// Weapon Away Transitions are weapon select animations played backwards
			if (TransitionQueue[0].NotifyType == TRANN_WeaponAway || TransitionQueue[0].bBackwards)
				PlayAnimOnly(TransitionQueue[0].ATransition,,TransitionQueue[0].TransitionTween,true);
			else
				PlayAnimOnly(TransitionQueue[0].ATransition,,TransitionQueue[0].TransitionTween);
		}
	}



	// TODO : We don't want to call everything in here if we EndState improperly (before transition finishes)
	// e.g., when shot, we don't want to call LoopAnimOnly(), but I'm not sure about the rest of the calls.
	// we might want to interrupt being shot with a transposition of the current animation in non-root motion form

	function EndState()
	{
		plog("-------- END STATE - ATransition : " $ TransitionQueue[0].ATransition);

		bInTransition = false;


		if (TransitionQueue.Length > 0)
		{
			// call AttachNotify if event has not completed the attachment
			if (TransitionQueue[0].NotifyType > TRANN_None)
			{
				plog("Forcing AttachNotify call...");
				AI_AttachNotify();
			}

			TransitionQueue.Remove(0,1);		// pop this transition off the queue
		}
	}

	function TransitionEnd()
	{	
		SetTimer(0, false);

		if (TransitionQueue[0].bRootMotionTransition)
		{	
			// teleport based on difference between initial root offset and current root offset
			
			if (TransitionQueue[0].ATransitionTarget != '')
			{
				// get the offset between current anim and anim we're switching to
				ExitRootMotion(TransitionQueue[0].ATransitionTarget);
				bCollideWorld = true;
			}			
		}

		// inform controller 
		Controller.TransitionEnd();

		if (Health - TmpDamage <= 0)
		{
			if (Controller != None)
			{
				Controller.NextState = '';
				DiedE(none, 1,vect(0,0,0));

			}
				
			return;
		}

		//check the stack
		if (TransitionQueue.Length > 1)
		{
			if (TransitionQueue.Length > 0)
			{
				// call AttachNotify if event has not completed the attachment
				if (TransitionQueue[0].NotifyType > TRANN_None)
				{
					plog("Forcing AttachNotify call...");
					AI_AttachNotify();
				}
			}

			TransitionQueue.Remove(0,1);		// pop this transition off the queue
			BeginState();
		}
		else
		{
			GotoState(TransitionQueue[0].TransitionState);
		}
	}

	function bool PlayAnimNoMovement(name Sequence, optional float Rate, optional float TweenTime, optional bool bBackward)
	{
		return false;		// can not play another anim while in transition
	}

	// allow turning only in specified transitions
	event PlayWaitingBlend(vector ForwardDirection, vector FocusDirection, float YawDiff, float TweenTime)
	{
		if (TransitionQueue[0].bTransitionWithRotation && Abs(YawDiff) > MinTurnThreshold)
		{
			if (Physics != PHYS_RootMotion)
				RotateTowardsRotator(Rotator(ForwardDirection), Controller.GetTurnSpeed());
		}
	}
 
	// s_Transition must end when Transition Anim finishes.  AIController must send us the AnimEnd event
	event AnimEnd(int Channel) 
	{
		if (Channel == 0)
		{
			//log("ANIMEND -- comparing CurrentAnimSeq : " $ CurrentAnimSeq $ "   with ATransition : " $ ATransition);
			plog("ANIMEND called before TransitionEnd --------- Pawn: "$Self);

			if (GetAnimName() == TransitionQueue[0].ATransition)
				TransitionEnd();
		}
	}

	// s_Transition can end when timer expires IFF TransitionTime is specified
	function Timer()
	{
		TransitionEnd();
	}

	// damage will make us abort the transition
	function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector HitNormal, vector momentum, class<DamageType> damageType, OPTIONAL int pillTag)
	{
		// todo : is there a better way to abort a root motion transition??
		
		// don't play animations or go back to default state if in root motion animation
        if (TransitionQueue.Length > 0)
        {
		    if (TransitionQueue[0].bRootMotionTransition)
            {
				damageType = None ;
				if (VSize(Hitlocation) != 0)
				{
				PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);
				}

				// Blood effect
				if ((damageType == None) && (!bNoBlood))
				{
					Spawn(class'EBloodSplat', self,, HitLocation, Rotator(Normal(momentum)));
				}

				// Check to be sure there is a pill .. else, use body pill
				if (PillTag == 0)
					PillTag = GetApproxPillFromHit(HitLocation);

				TmpDamage += Damage * DamageLookupTable[PillTag - 1] / 100;

			    return;
            }
        }
		


		global.TakeDamage(Damage, InstigatedBy, HitLocation, HitNormal, momentum, damageType, pillTag);



		// only change states if we're still alive and the TakeDamage call did not change states for us.
		if (Health > 0 && GetStateName() == 's_Transition')
			GotoState('DefaultState');
	}

}




// ----------------------------------------------------------------------
// state s_Sitting - Sitting in a chair
// ----------------------------------------------------------------------

state s_Sitting
{
	ignores PlayWaitingBlend, PlayBlend;

	function BeginState()
	{	
		bCanFallWalk = false;
		//SetRotation(Chair.Rotation);
	}

	function EndState()
	{	
		bCanFallWalk = true;
	}

	// special TakeDamage for seated Pawns
	function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, vector HitNormal, Vector momentum, class<DamageType> damageType, optional int PillTag)
	{
		local Controller Killer;
		local bool bAlreadyDead;
		bAlreadyDead	= (Health <= 0);
		
		//log("SIT TAKE DAMAGE : " $ Damage @ instigatedBy @ Hitlocation @ "**MOMENTUM** : " @ momentum @ " type: " @ damageType @ " pilltag: " @ PillTag);

		// Blood effect
		if ((damageType == None) && (!bNoBlood))
		{
				Spawn(class'EBloodSplat', self,, HitLocation, Rotator(Normal(momentum)));
		}
		

		// Check to be sure there is a pill .. else, use body pill
		if (PillTag == 0)
			PillTag = GetApproxPillFromHit(HitLocation);
		
		// Gives real damage depending on the hit zone
		ResolveDamage(damage, PillTag, damageType);


		//Play HitSound depending on the pill
		if (damageType == None)
		{
			if (VSize(Hitlocation) != 0)
			{
			if (PillTag == 1) //head
				PlaySound(Sound'GunCommon.Play_BulletHitHead', SLOT_SFX);
			else //rest of body
				PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);
		}
		}
		// If knocked but not on head
		else if (damageType.name == 'EKnocked' && PillTag != P_Head)
			damageType = None;

		// In all case, spawn flames on burned actor
		if (damageType != None && damageType.name == 'EBurned')
			CatchOnFire();

		// play damage animations
		if (Health > 0)
		{
			// sound
			MakeNoise(500.0, NOISE_Scream, CollisionHeight * 2.0f); 

			// resolve other damage types
			ResolveDamageType(PillTag, momentum, damageType);

			if (instigatedBy != None && instigatedBy != Self && Controller != None)
			{
				//plog("passing damage to controller.");
				Controller.damageAttitudeTo(instigatedBy, Damage, damageType);
			}
			
			if (instigatedBy != Self && Controller != None && !bIsPlayerPawn && instigatedBy != None && instigatedBy.bIsPlayerPawn && !EAIController(Controller).bWasInjured && !EAIController(Controller).bNotInStats)
			{
				if (!EAIController(Controller).bWasKnockedOut)
				{
					if (bIsDog)
					{
						EPlayerController(instigatedBy.Controller).playerStats.AddStat("EnemyInjured");
						EAIController(Controller).bWasInjured = true;
					}
					else if (bHostile)
					{
						EPlayerController(instigatedBy.Controller).playerStats.AddStat("EnemyInjured");
						EAIController(Controller).bWasInjured = true;
					}
					else
					{
						EPlayerController(instigatedBy.Controller).playerStats.AddStat("CivilianInjured");
						EAIController(Controller).bWasInjured = true;
					}
				}
			}
		}
		else if (!bAlreadyDead)
		{
			if (Controller != None)
			{
				Controller.NextState = '';
				Controller.Enemy = instigatedBy;
			}
			if (instigatedBy != None)
				Killer = instigatedBy.Controller;
			
			LastDamageType = damageType;
			DiedE(Killer, PillTag, momentum);
		}
	}
		
	function ResolveDamageType(int PillTag, vector Momentum, class<DamageType> DamageType)
	{
		//Log("s_Sitting ResolveDamageType"@PillTag@Momentum@DamageType);

		if (DamageType == None)
			return;

		switch (DamageType.name)
		{
			case 'EKnocked' :		Knocked(PillTag, Momentum); break;
			default :				FallBackInert(); break;
		}
	}

	function FallBackInert()
	{
		StopAllSoundsActor(true);
		PlayAnimOnly(ADeathBack);
		if (Controller != None)
			Controller.GotoState('s_Unconscious');
		GotoState('s_Unconscious');
	}

	//------------------------------------------------------------------------
	// Description		
	//		Dying while seated slightly different from standard.
	//------------------------------------------------------------------------

	function PlayDyingE(int PillTag, vector momentum)
	{
		local Name		Anim;

		if (bSleeping)
		{
			PlayAnimOnly(ADeathDown);
			return;
		}

		if (!bDontPlayDeathSitAnim)
			Anim = ChooseChairDeathAnimation(PillTag, momentum);
		else
			Anim = ADeathForward;

		if (GetAnimName() != Anim)
			PlayAnimOnly(Anim,, 0.1);
	}
	
	function bool PlayAnimNoMovement(name Sequence, optional float Rate, optional float TweenTime, optional bool bBackward)
	{
		// should return true if Sequence is in current (Table.PSA) MeshAnimation 

		if (IsSequenceInCurrentAnim(Sequence))
		{	
			Global.PlayAnimNoMovement(Sequence, Rate, TweenTime);
			return true;
		}

		return false;
	}

}

// ----------------------------------------------------------------------
// state s_Stunned - not unconscious, but incapacitated
// ----------------------------------------------------------------------
state s_Stunned
{
	Ignores Trigger, Bump, HitWall, PhysicsVolumeChange, Falling, PlayHitE, UpdateAnimationSet;

	function BeginState()
	{
		bDontBlink = true;
		bInTransition = true;

		// Make sure Timer is 0
		SetTimer(0, false);

		if (Controller != None)
			Controller.GotoState('s_Stunned');
	}

	function EndState()
	{
		bDontBlink = false;
		AStunBegin	= '';
		AStunned	= '';
		AStunEnd	= '';
		SetTimer(0, false);

		bInTransition = false;
	}

	function Timer()
	{
		// if timer expires, return to regular consciousness
		GotoState(,'End');
	}

	function PlayLeftHand()
	{
		// Anim try to shut off fire
		AttenuateFire(0,1);
	}

	// Prevent the fire from respawning on _wanna stop fire fire Npc_.
	function CatchOnFire()
	{
		if (!IsOnFire())
			Global.CatchOnFire();
	}

	function bool IsOnFire()
	{
		return AStunned == 'FireStAlNt0';
	}

	function ResolveDamageType(int PillTag, vector Momentum, class<DamageType> DamageType)
	{
		if (DamageType == None)
			return;

		switch (DamageType.name)
		{
			case 'EKnocked' :		Knocked(PillTag, Momentum); break;
			case 'EElectrocuted' :	Electrocuted(); break;
			
			case 'ESleepingGas' :
				if (IsOnFire())	
					return;
				if (bInTransition)	
					SetTimer(3, false);
				else
					GotoState(,'Gassed');
				break;
			
			case 'EBurned' :
				// Stay until all flames are gone. Anim time.
				/*if (bInTransition)	
					SetTimer(3, false);
				else
					GotoState(,'Burned');*/
				break;
			
			case 'EStunned' :
				if (bInTransition)	
					SetTimer(3, false);
				else
					GotoState(,'Stunned');
				break;
		}
	}

Gassed:
	//log("label gassed"@AStunned);
	bInTransition = true;
	Bark_Type = BARK_Cough;
	if (AStunned == ACough)
		Goto('RefreshTimer');
	AStunBegin	= 'SmokStAlBg0';
	AStunned	= ACough;
	AStunEnd	= 'SmokStAlEd0';
	Goto('Begin');

Burned:
	//log("label Burned"@AStunned);
	bInTransition = true;
	Bark_Type = BARK_InFire;
	if (IsOnFire())
		Goto('RefreshTimer');
	AStunned	= 'FireStAlNt0';
	Goto('Begin');

Stunned:
	//log("label Stunned"@AStunned);
	bInTransition = true;
	Bark_Type = BARK_KnockedOut;
	if (AStunned == 'stunstalnt0')
		Goto('RefreshTimer');

	AStunBegin	= '';

	if (!bIsCrouched)
	{
	AStunned	= 'stunstalnt0';
		AStunEnd	= 'stunstaled0';
	}
	else
	{
		AStunned	= 'StunCrAlNt0';
		AStunEnd	= 'stunCrAlEd0';
	}

	Goto('Begin');

Begin:
	//log("label Begin"@AStunned);
	Acceleration = vect(0,0,0);

	// Bark set in label above
	if (!IsPlaying(Sounds_Barks))
		PlaySound(Sounds_Barks,SLOT_SFX);
	else
		Bark_Type = BARK_Generic;

	// Play begin
	if (AStunBegin != '')
	{
		PlayAnimOnly(AStunBegin,,0.1, AStunEnd == AStunBegin);
		FinishAnim();
	}

	// Look cycle
	LoopAnimOnly(AStunned,,0.05f);

RefreshTimer:
	//Log("RefreshTimer");
	SetTimer(3, false);
	bInTransition = false;
	Stop;

End:
	//log("label End");
	// Play End if not dying
	if (AStunEnd != '')
	{
		PlayAnimOnly(AStunEnd,,0.1);
		FinishAnim();
	}

	// Get out normally
	if (Controller != none)
		Controller.GotoState(EAIController(Controller).m_LastStateName);

	GotoState('DefaultState');
}

function PlaySpasm()
{
	if (eGame.bNoGore || bDontPlayDeathAnim)
		return;

	switch (GetAnimName())
	{
	case ADeathForwardNtrl:
	case ASpasm1:
		PlayAnimOnly(ASpasm2, 1.5);
		break;
	case ADeathBackNtrl:
	case ASpasm4:
		PlayAnimOnly(ASpasm1, 1.5);
		break;
	case ADeathLeftNtrl:
	case ASpasm2:
		PlayAnimOnly(ASpasm3, 1.5);
		break;
	case ADeathRightNtrl:
	case ASpasm3:
		PlayAnimOnly(ASpasm4, 1.5);
		break;
	case 'XxxxAsNmFd0':
	case 'SpsmAsNmFd0':
		PlayAnimOnly('SpsmAsNmFd0');
		break;
	case 'XxxxAsNmBk0':
	case 'SpsmAsNmBk0':
		PlayAnimOnly('SpsmAsNmBk0');
		break;
	}
}

function RandInertStance()
{
	local name CurrentAnimSeq;
	local float CurrentFrame, CurrentRate, randValue;

	GetAnimParams(BASEMOVEMENTCHANNEL, CurrentAnimSeq, CurrentFrame, CurrentRate);

	randValue = FRand();
	if (randValue < 0.25)
		PlayAnimOnly(ADeathForwardNtrl);
	else if (randValue < 0.5)
		PlayAnimOnly(ADeathBackNtrl);
	else if (randValue < 0.75)
		PlayAnimOnly(ADeathLeftNtrl);
	else
		PlayAnimOnly(ADeathRightNtrl);
	
	PlayAnim(CurrentAnimSeq,,,BLENDMOVEMENTCHANNEL);									// Init channel 
	AnimBlendParams(BLENDMOVEMENTCHANNEL, 1.0);											// Set Blend to 100%
	ForceAnimParams(BLENDMOVEMENTCHANNEL, CurrentAnimSeq, CurrentFrame, CurrentRate);	// Set frame and rate
	AnimBlendToAlpha(BLENDMOVEMENTCHANNEL, 0.0, 0.3);									// Fade to 0
}

// ----------------------------------------------------------------------
// state s_Inert
// ----------------------------------------------------------------------
state s_Inert
{
	Ignores PlayReload, Trigger, Bump, HitWall, PhysicsVolumeChange, Falling,
		PlayHitE, ResolveDamageType;

	function BeginState()
	{
		bDontBlink = true;
		bCanFallWalk = false;
		if (BaseMoveFlags == MOVE_Sit)
			bOrientOnSlope = false;
		else
			bOrientOnSlope = true;
		bBlockProj = false;
		bBlockNPCVision = false;
		bCollideSB = false;
		bCollideWorld = true;
		SetCollision(true, false, false);
		bWantsToCrouch = false;

		StopTurning();		// shouldn't be any turning while Pawn is inert...

		// turn off the NPCZone interaction temporarily (can not grab while falling)
		//plog("EPawn Interaction : " $ Interaction);
		if (Interaction != None && IsAnimating())
			Interaction.GotoState('s_Disabled');
		else if (Interaction != None) // Not animating, don't wait for AnimEnd to change state
			ENpcZoneInteraction(Interaction).ResetInert();

		// FlashLight
		ToggleHeadLight(false);

		// Satchel
		if (Satchel != None)
			Satchel.Throw(Controller, vect(0,0,0));
		Satchel = None;
		
		// Cigaret
		if (Cigaret != None)
			Cigaret.Throw(Controller, vect(0,0,0));
		Cigaret = None;
		
		// Cellular
		if (Cellular != None)
			Cellular.Throw(Controller, vect(0,0,0));
		Cellular = None;
		
		// Remove hat
		if (Hat != None)
			Hat.TakeDamage(0, None, Vect(0,0,0), Vect(0,0,0), Vect(0,0,0), class'Crushed');
		Hat = None;

		SetPhysics(PHYS_Falling);
	}

	function EndState()
	{
		bDontBlink = false;
		bCanFallWalk = true;
		bOrientOnSlope = false;
		bBlockProj = true;
		bCollideSB = true;

		if (Interaction != None && Health > 0)
			ENpcZoneInteraction(Interaction).Release();
	}

	function Landed(vector HitNormal)
	{
		local rotator finalRot;

		if (Velocity.Z < -500)
			TakeDamage((1 - Velocity.Z / 30), Instigator, Location, HitNormal, Vect(0,0,0), class'Crushed');

		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		SetPhysics(PHYS_Walking);
		if (BaseMoveFlags != MOVE_Sit)
			m_inertRot = FindSlopeRotation(Floor, Rotation);
	}

	event AnimEnd(int Channel)
	{
		if (Channel != 0)
			return;

		if (Interaction != None)
			GoToState(, 'ResetInter');

		if (ADeathNeutral != '')
		{
			PlayAnimOnly(ADeathNeutral);

			if (bWasCarried)
			{
				RandInertStance();
				bWasCarried = false;
			}

			SetCollision(false);
			if (BaseMoveFlags == MOVE_Sit)
			{
				SetLocation(Location + (m_locationEnd >> m_inertRot));
				BaseMoveFlags = MOVE_WalkNormal;
				bOrientOnSlope = true;
			}
			else
			{
				Move((m_locationEnd >> m_inertRot) + vect(0,0,5.0));
				Move(vect(0,0,-5.0));
			}
			RotateAroundZ(m_orientationEnd.Yaw);
			m_inertRot = Rotation;
			SetCollision(true);
			FindBase();
			ADeathNeutral = '';
		}
	}

	// redefinition -- light always goes off in s_Inert and inherited states
	event ToggleHeadLight(bool bTurnOn)
	{
		if (!MayUseGunLight)
			return;

		if (FlashLight != None)
			FlashLight.ToggleLight(false);
	}

ResetInter:
	ENpcZoneInteraction(Interaction).ResetInert(); 
	Stop;

FallFromChair:
	if (Interaction != None)
		Interaction.GotoState('s_Disabled');
	if (SetupChairDeath(m_slipeRight))
		PlayAnimOnly('XxxxChAlRt0', , 0.25);
	else
		PlayAnimOnly('XxxxChAlLt0', , 0.25);
	FinishAnim();
}

native(1176) final function bool SetupChairDeath(bool wantsRight);

// ----------------------------------------------------------------------
// state s_Unconscious
// ----------------------------------------------------------------------
state s_Unconscious extends s_Inert
{
	function BeginState()
	{
		Super.BeginState();

		plog("* BEGIN STATE **************************** Health: "$Health);

		ForceFlashLight = false;

		// add body to ChangedActorsList
		Disable('Tick');
        //log("bNeverMarkAsChanged"@bNeverMarkAsChanged@"bKnockedByPlayer"@bKnockedByPlayer);

        if ((!bNeverMarkAsChanged) && (bKnockedByPlayer))
        {
		    Level.AddChange(self, CHANGE_Unconscious);
        }
        else
        {
            // Reset var to default
            bKnockedByPlayer = default.bKnockedByPlayer;
        }
		SetTimer(1.0 + Frand(), false);
	}

	function EndState()
	{
		// remove body from ChangedActorsList
		if (ChangeType == CHANGE_Unconscious)
			Level.RemoveChange(self);

		plog("s_Unconscious: EndState -> Collision are put back...");

		// Reset collision upon reviving
		SetCollision(default.bCollideActors, default.bBlockActors, default.bBlockPlayers);

		//be sure to set back the physic
		SetPhysics(PHYS_Walking);

		Super.EndState();
		SetTimer(0.0, false);
	}
	
	function PlayHitE(int PillTag, Vector HitLocation, Vector Momentum)
	{
		if (!IsAnimating())
			PlaySpasm();
	}

	function PlayDyingE(int PillTag, vector momentum)
	{
		if (!IsAnimating())
			PlaySpasm();
	}

	function Timer()
	{
		if (!IsAnimating())
			PlaySpasm();
		SetTimer(10.0 + 10.0 * Frand(), false);
	}
}

// ----------------------------------------------------------------------
// state s_InitiallyUnconscious
// ----------------------------------------------------------------------
state s_InitiallyUnconscious extends s_Unconscious
{
	function BeginState()
	{
		// make guy look unconscious
		PlayAnim(AnimSequence, 0.0f, 0.0f, 0);
		ForceAnimParams(BASEMOVEMENTCHANNEL, AnimSequence, AnimFrame, AnimRate);

		Super.BeginState();
	}
}

// ----------------------------------------------------------------------
// state s_Dying
// ----------------------------------------------------------------------
state s_Dying extends s_Inert
{
	Ignores PlayDyingE;

	function BeginState()
	{
		Super.BeginState();

		// Only for sam being the killer?
		if ((bKilledByPlayer) &&(!bNeverMarkAsChanged))
        {
			Level.AddChange(self, CHANGE_Dead);
        }
		bKilledByPlayer = false;
		TimeOfDeath = Level.TimeSeconds;			// keep time of death so we can CHECK the FRESHNESS

		// Remove weapon
		if (CurrentWeapon != None)
		{
			FullInventory.UnEquipItem(CurrentWeapon);
			CurrentWeapon.GotoState('s_Dying');
		}

		// get him out of zone
		if (EVolume(PhysicsVolume) != None)
			SetVolumeZone(false, EVolume(PhysicsVolume));

		// Attenuate fire
		SetTimer(10.f + 10 * Frand(), true);

		if (Controller == None)
			return;

		if (Controller.bIsPlayer)
			Controller.PawnDied();
		else
		{
            // 
            EAIController(Controller).RemoveReferencesInPatrolInfo();
			// Destroy controller
			Controller.Destroy();
			// owner and controller will equal none
			UnPossessed();
		}
	}

	function EndState()
	{
		SetTimer(0.f, false);
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, vector HitNormal, Vector momentum, class<DamageType> damageType, optional int PillTag)
	{
		if (PillTag == 0)
			PillTag = GetApproxPillFromHit(HitLocation);

		//Play HitSound depending on the pill
		if (damageType == none)
		{
			if (VSize(Hitlocation) != 0)
			{
			if (PillTag == 1) //head
				PlaySound(Sound'GunCommon.Play_BulletHitHead', SLOT_SFX);
			else //rest of body
				PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);
		}
		}
		else if (damageType == class'EBurned')
			CatchOnFire();
	}

	function Timer()
	{
		AttenuateFire(FRand());
	}
}

// ----------------------------------------------------------------------
// state s_InitiallyDead
// ----------------------------------------------------------------------
state s_InitiallyDead extends s_Dying
{
	function BeginState()
	{
		Health = 0;

		// make guy look dead
		PlayAnim(AnimSequence, 0.0f, 0.0f, 0);
		ForceAnimParams(BASEMOVEMENTCHANNEL, AnimSequence, AnimFrame, AnimRate);

		Super.BeginState();
	}
}

// ----------------------------------------------------------------------
// state s_FallToDeath
// ----------------------------------------------------------------------
state s_FallToDeath
{
	Ignores Trigger, Bump, HitWall, PhysicsVolumeChange, Falling, ResolveDamageType;
	
	function Landed(vector HitNormal)
	{
		setPhysics(PHYS_None);
		PlayAnimOnly('LandStNmXX0');		
		GotoState('s_Dying');
	}

	function BeginState()
	{
		bFallToDeath = false;
		setPhysics(PHYS_Falling);
	}

	event AnimEnd(int Channel)
	{
		if (GetAnimName() == ADeathLadder)
			LoopAnimOnly('FallStNmBk0',,0.1f);
	}
}

// ----------------------------------------------------------------------
// state s_Grabbed
// ----------------------------------------------------------------------
function FinishGrabbing(EPawn p)
{
	SetPhysics(PHYS_Trailer);
	SetLocation(p.Location);
	SetBase(p);
	PlayAnimOnly(AGrabWait);
	TrailerOffset = vect(0,0,0);
	SetCollision(true);
	if (Interaction != None)
		ENpcZoneInteraction(Interaction).NpcGrabbed();
}

state s_Grabbed
{
	function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, vector HitNormal, Vector momentum, class<DamageType> damageType, optional int PillTag)
	{
		local Controller Killer;
		local EPlayerController EPC;
		local bool bAlreadyDead;
		bAlreadyDead	= (Health <= 0);

		if ((damageType == None) && (!bNoBlood))
		{
				Spawn(class'EBloodSplat', self,, HitLocation, Rotator(Normal(momentum)));
		}

		if (PillTag == 0)
			PillTag = GetApproxPillFromHit(HitLocation);

		// Gives real damage depending on the hit zone
		ResolveDamage(damage, PillTag, damageType);

		//Play HitSound depending on the pill
		if (damageType == none)
		{
			if (VSize(Hitlocation) != 0)
			{
			if (PillTag == 1) //head
				PlaySound(Sound'GunCommon.Play_BulletHitHead', SLOT_SFX);
			else //rest of body
				PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);
		}
		}
		// If knocked but not on head
		else if (damageType.name == 'EKnocked' && PillTag != P_Head)
			damageType = None;
		
		if (damageType != None && damageType.name == 'EBurned')
			CatchOnFire();

		if (Controller == None)
			return;

		// play damage animations
		if (Health > 0)
		{
			MakeNoise(500.0, NOISE_Scream, CollisionHeight * 2.0f); 

			// other damage types
			if (damageType != none && damageType.Name == 'EKnocked')
				Knocked(PillTag, momentum);
		}
		else if (!bAlreadyDead)
		{
			LastDamageType = damageType;
			DiedE(Killer, PillTag, momentum);
		}
	}

	function BeginState()
	{
		BaseMoveFlags = MOVE_WalkNormal;
		SwitchAnims();
		bBlockNPCShot = false;
		bBlockNPCVision = false;
		bBlockActors = false;
		bBlockPlayers = false;
		bCollideWorld = false;
		SetCollision(false);
		bTrailerSameRotation = true;
		bTrailerPrePivot = true;
		SetTimer(0.5f, false);
		SetPhysics(PHYS_None);
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
	}

	function EndState()
	{
		SetCollision(true);
		bBlockNPCShot = true;
		bBlockNPCVision = true;
		bBlockActors = true;
		bBlockPlayers = true;
		bCollideWorld = true;
	}

	function Timer()
	{
		Bark_Type = BARK_ChokeGrab;
		PlaySound(Sounds_Barks,SLOT_Barks);
	}
}

function SetupNPCCarry(EPawn p)
{
	local vector dest;
	local name CurrentAnimSeq;
	local float CurrentFrame, CurrentRate;

	GetAnimParams(BASEMOVEMENTCHANNEL, CurrentAnimSeq, CurrentFrame, CurrentRate);

	SetCollision(false, false, false);
	bWantsToCrouch = false;
	SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
	PrePivot = vect(0,0,0);
	dest = p.Location;
	dest.Z += (CollisionHeight - p.CollisionHeight);
	SetLocation(dest);
	SetCollision(true, false, false);
	
	PlayAnimOnly('CaryCrAlUp0', , 0.1);
	
	PlayAnim(CurrentAnimSeq,,,BLENDMOVEMENTCHANNEL);									// Init channel 
	AnimBlendParams(BLENDMOVEMENTCHANNEL, 1.0);											// Set Blend to 100%
	ForceAnimParams(BLENDMOVEMENTCHANNEL, CurrentAnimSeq, CurrentFrame, CurrentRate);	// Set frame and rate
	AnimBlendToAlpha(BLENDMOVEMENTCHANNEL, 0.0, 0.5);									// Fade to 0

	SetPhysics(PHYS_None);
	SetBase(p);
}

state s_Carried
{
	Ignores ResolveDamageType, PlayDyingE, PlayHitE;

	function BeginState()
	{
		bCanFallWalk = false;
		bDontBlink = true;
		RandomizedAnimRate = 1.0;
		bInterpolating = true;
		bOrientOnSlope = false;
		bBlockNPCShot = Health <= 0;
		bBlockNPCVision = false;
		bCollideSB = false;
		bCollideWorld = false;
		SetCollision(true, false, false);
	}

	function EndState()
	{
		bCanFallWalk = true;
		bOrientOnSlope = true;
		bInterpolating = false;
		RandomizedAnimRate = 0.97f + RandRange(0.0f, 0.06f);
		bBlockNPCShot = true;
		bBlockNPCVision = true;
		bCollideSB = true;
		SetPhysics(PHYS_Falling);
		bCollideWorld = true;

		if (bDisableAI)
		{
			if (!bNeverMarkAsChanged)
				Level.AddChange(self, CHANGE_Dead);
		}


		if (Interaction != none)
			ENpcZoneInteraction(Interaction).ResetInert();
	}

	function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, vector HitNormal, Vector momentum, class<DamageType> damageType, optional int PillTag)
	{
		local Controller Killer;
		local bool bAlreadyDead;

		bAlreadyDead	= (Health <= 0);

		// Blood effect
		if ((damageType == None) && (!bNoBlood))
			Spawn(class'EBloodSplat', self,, HitLocation, Rotator(Normal(momentum)));

		// Check to be sure there is a pill .. else, use body pill
		if (PillTag == 0)
			PillTag = GetApproxPillFromHit(HitLocation);

		// Gives real damage depending on the hit zone
		ResolveDamage(damage, PillTag, damageType);
		
		//Play HitSound depending on the pill
		if (damageType == None)
		{
			if (VSize(Hitlocation) != 0)
			{
				if (PillTag == 1) //head
					PlaySound(Sound'GunCommon.Play_BulletHitHead', SLOT_SFX);
				else //rest of body
					PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);
			}
		}

		// Spawn flames on burned actor if fire comes from another source
		if (damageType != None && damageType.name == 'EBurned' && instigatedBy != self)
			CatchOnFire();

		if (Controller == None)
			return;

		if (Health <= 0 && !bAlreadyDead)
		{
			// Other NPC wont try to shoot tru this guy anymore
			bBlockNPCShot = true;

			if (Controller != None)
			{
				Controller.NextState = '';
				Controller.Enemy = instigatedBy;
			}
			if (instigatedBy != None)
				Killer = instigatedBy.Controller;

			LastDamageType = damageType;
			DiedE(Killer, PillTag, momentum);
		}
	}

	function DiedE(Controller Killer, int PillTag, vector momentum)
	{
		StopAllSoundsActor(true);
		
		if (Killer != None)
		{
			if (Killer.bIsPlayer)
				bKilledByPlayer = true;
			TriggerEvent(Event, self, Killer.Pawn);			
		}
		else
			TriggerEvent(Event, self, None);

		if (Controller != None && !Controller.bIsPlayer)
			Controller.GotoState('s_Dead');
	}
}

// ----------------------------------------------------------------------
// state s_Electrocuted
// ----------------------------------------------------------------------
state s_Electrocuted extends s_Inert
{
	event AnimEnd(int Channel)
	{
		if (Channel != 0)
			return;

		if (Interaction != None)
			ENpcZoneInteraction(Interaction).ResetInert(); 
	}

	function BeginState()
	{
		bDontBlink = true;
		SetPhysics(PHYS_None);
		StopAllSoundsActor(true);
	}

Begin:
    Bark_Type = BARK_HitElectric;
    PlaySound(Sounds_Barks,SLOT_Barks);
	LoopAnimOnly('ElecStAlNt0',, 0.1);
	Sleep(1.0f);
	
	// So fall on ground animation
	PlayDyingE(0, Vect(0,0,0));

	// reset interaction now
	if (Interaction != None)
		ENpcZoneInteraction(Interaction).ResetInert();

	GotoState('s_Unconscious');
}

defaultproperties
{
    PlayerFarDistance=2000.000000
    PlayerCloseDistance=1000.000000
    PlayerVeryCloseDistance=300.000000
    DefuseMinePercentage=0.750000
    ExpiredTime=30.000000
    FocusDistanceMin=150.000000
    FocusDistanceMax=2000.000000
    bSendAIEvents=true
    bCanBeGrabbed=true
    bKnockedByPlayer=true
    bIsHotBlooded=true
    bCanWhistle=true
    RandomizedAnimRate=1.000000
    fHideTime=30.000000
    m_VisibilityConeAngle=60.000000
    m_VisibilityMaxDistance=1800.000000
    m_VisibilityAngleVertical=35.000000
    m_MaxPeripheralVisionDistance=200.000000
    bUseTransitionTable=true
    VisTable_Alert(1)=400.000000
    VisTable_Alert(2)=700.000000
    VisTable_Alert(3)=1000.000000
    VisTable_Alert(4)=1300.000000
    VisTable_Investigate(1)=900.000000
    VisTable_Investigate(2)=1200.000000
    VisTable_Investigate(3)=1500.000000
    VisTable_Investigate(4)=1800.000000
    VisTable_Surprised(0)=150.000000
    VisTable_Surprised(1)=175.000000
    VisTable_Surprised(2)=200.000000
    VisTable_Peripheral(3)=125.000000
    VisTable_Peripheral(4)=200.000000
    PrsoUpdate_DefaultMin=10.000000
    PrsoUpdate_DefaultMax=20.000000
    PrsoUpdate_AwareMin=7.000000
    PrsoUpdate_AwareMax=15.000000
    PrsoUpdate_AlertMin=9.000000
    PrsoUpdate_AlertMax=16.000000
    PlayGearSound=true
    YawTurnSpeed=52000
    TurnSpeed_Default=16384
    TurnSpeed_Aware=16384
    TurnSpeed_Alert=60000
    MaxAimAngle_Default=20.000000
    MaxAimAngle_Aware=35.000000
    MaxAimAngle_Alert=60.000000
	DamageLookupTable(0)=100.000000
	DamageLookupTable(1)=50.000000
	DamageLookupTable(2)=10.000000
	DamageLookupTable(3)=10.000000
	DamageLookupTable(4)=5.000000
	DamageLookupTable(5)=20.000000
	DamageLookupTable(6)=20.000000
	DamageLookupTable(7)=10.000000
	DamageLookupTable(8)=35.000000
	DamageLookupTable(9)=10.000000
	DamageLookupTable(10)=10.000000
	DamageLookupTable(11)=5.000000
	DamageLookupTable(12)=20.000000
	DamageLookupTable(13)=20.000000
	DamageLookupTable(14)=10.000000
    RollSpeed=12000.000000
    bCanCrouch=true
    bCanFallWalk=true
    ControllerClass=Class'EAIController'
    bCanClimbLadders=true
    bCanOpenDoors=true
    HearingThreshold=15000.000000
    StopSoundsWhenKilled=true
    CollisionRadius=35.000000
    CollisionHeight=87.500000
}