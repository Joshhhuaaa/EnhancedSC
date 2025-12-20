//=============================================================================
// EAIController
//
// Base Echelon AIController.
// Defines common base behaviour for scripted Echelon NPCs:
//      Goal Execution
//      Player Visibility Response
//		Recognition of Changed Actors within the environment
//      Noise Detection
//		Damage Response
//		Generalized Movement & Pathfinding
//      
//=============================================================================


class EAIController extends AIController
    native;


var		EPawn					ePawn;							// EPawn reference
var		EchelonGameInfo			eGame;							// reference to our GameInfo - use to store the gloabl variables and constantes
var		EPawn					Master;							// for AI - Dog relationship
var		EPawn					Leader;							// for GOAL_Follow behavior

// keep bools packed together:

var		bool					bInTransition;					// flag used to stop normal ticking
var		bool					bWaitingForPatrolTrigger;		// am i waiting for a trigger from a patrol?
var		bool					bNotResponsive;					// incapacitated (s_inert / s_groggy / s_grabbed)
var		bool					bAttackCover;					// are we attacking from a covered location?
var		bool					bHittingWall;					// used for gracefully dealing w/ unwanted collisions
var		bool					bNavigateFailure;
var		bool					bDirectionRight;
var		bool					bPlayerSeen;					// is the player currently visible?  used for sending AIEvents to group
var		bool					bCanFire;						// set according to moveflags, and focus based on current animation
var		bool					bClimbingUp;					// ugly, ugly hack
var		bool					bInteractionActive;				// set to true when BeginInteraction() is called
var		bool					bInteractionComplete;			// set to false at beginning of ExecGoal_Interact, set to true by Interaction EndState()
var		bool					bStandUpASAP;					// set to true if we need to exit chair as soon as we sit down..
var		bool					bThrowNow;						// true when it's time to throw a grenade...
var		bool					bIsMoving;						// set according to calls to StartedMoving() and StoppedMoving()
var		bool					bPersonalityAnimActive;			// is personality anim currently playing?
var		bool					bStopPersonalityAnim;			// set to true at certain times if we need to fade out our personality anim
var		bool					bAboutToFall;					// set to true when MayFall is called by the physics -- so AI nav can adjust movement accordingly
var		bool					bShootTarget;
var		bool					bIsOnLadder;					// set once we start climbing, reset when we exit
var		bool					bRetryPathFind;					// set to true when AI has been deadlocked in navigation for x seconds -- will cause Sub_NavTo to reinitialize
var		bool					bInFlashLightVolume;			// are we presently inside a volume that wants us to turn on our flashlight?
var     bool                    bRequestAwareState;
var		bool					bTableChair;
var     bool                    bMasterDeadSent;                // Have we sent the AI_MASTER_DEAD event yet?
var		bool			        bIsAboutToLostThePlayer;
var		bool                    bTimedOutAlready;               // Only send AI_PATROL_TIMEOUT once for WaitingForSig cases
var		bool				    bIgnoreLocalPath;
var		bool                    bTimedForceFire;
var		bool					bWalkReached;
var    	bool					bAccFire;
var	   	bool					bWaitForDoor;

var	   float					LastTryTime;
var	   int						NumberOfTry;						
// misc variables

var     name					m_LastStateName;                // our previous state - temporary?
var     NavigationPoint			m_pNextPatrolPoint;             // currently selected patrol network target
var		NavigationPoint			TempNavPoint;					// EDynamicNavPoint used for setting intermediate move locations off of the network
var		NavigationPoint			TempMovePoint;					// like TempNavPoint, except used in EMoveToward instead of SubGoal_NavigateTo
var     NavigationPoint         TempWalkPoint;                  // Like previous two Nav points, but used in WalkToDestination
var     NavigationPoint			FollowPoint;
var		Actor					TakenPoint;						// currently selected navigation network target THAT WE HAVE A LOCK ON...
var		EInfoPoint				TakenFocus;
var		EInfoPoint				DynamicFocusPoint;				// our personal dynamic focus point that we can move around and use when no other focus points are available
var		float					DamageTimer;					// use so we don't play damage animations instead of moving the NPC
var		float					BumpTimer;						// allows some leeway when player bumps NPC from behind..
var		float					EnvironmentCheckTimer;			// used for timesliced check of LevelInfo.ChangedActorsList
var		float					AICycles;						// for timing the current viewtarget
var		vector					AimDirection;					// direction set in goal execution / movement / stop movement for specifying where to aim at (upper body)
var		vector					LastAimDirection;				// last frame's aim direction .. used for smoothing out the shit
var		float					NextFireTime;					// time (in level seconds) at which we are next allowed to fire our weapon
var		float					NextCoverAttackTime;
var		float					NoAlternatePathTimer;			// set when we can't find an alternate or "local" path -- check again in x seconds.
var		float					DefendCheckTimer;

var		EInfoPoint				FocusAccumulator[5];			// accumulate frame the 5 most relevant focus points in this array, frame by frame 
var		EInfoPoint				FA_Iterator;					// focus accumulator current pointer into ELevel's focus point list
var		int						FA_StepSize;					// how many focus points from the level will we consider in a single frame

// navigation variables

var		byte					myLadderLockInfo;				// personal info about any locked ladder we might possess (how are we going to use the ladder?)
var		int						CurrentGEID;					// used to lock ladders, etc.?
var		int						PreviousRoll;					// store EPawn roll for next frame - for banking into curves
var		vector					StrictFocus;					// if this vector is set, we override state specific ViewRotation modification
var		rotator					PreviousViewRotation;			// used for interpolating to current desired view rotation
var		rotator					CurrentViewRotation;			// set according to results of SetViewRotation and subsequent animation (different in StopMovement / EMoveToward)
var		vector					BumpAcceleration;
var		vector					StepAsideLocation;				// for gettin' out of the way
var     actor					m_pNextNavPoint;                // when path-finding, next navigation point in path
var		actor					IntermediateNavPoint;			// if set, go here before whatever actor is specified in EMoveToward
var		NavigationPoint			AlternativeMovePoint;			// if set, EMoveToward will move here INSTEAD of specified TargetActor and return GS_Complete when it's reached
var		EDoorMover				SpecialMoveDoor;				// door we need to navigate through
var		vector					m_vPrevDestination;				// stored for path-finding reset
var		vector					LadderExitLocation;				// reset ladder based on distance from this location (nav point on other side of ladder)
var		int						LastSmellPoint;
var		name					BlendPersonalityAnim;			// name of currently selected personality animation to be BLENDED at next convenient time
var		name					FullPersonalityAnim;			// name of currently selected personality animation to be PLAYED IN FULL by SubGoal_PlayPersonalityAnim
var		float					PersonalityUpdateTime;			// how long before next update?
var		float					PathBlockStartTime;				// when did we first realize our path was blocked?
var		EPawn					LocalPathBlocker;				// which muthafucka is blocking our way?
var		int						FindLocalPathStep;				// in searching for a local path, only do one costly FindLocalPath call per frame
var		NavigationPoint			WeightedRoute[4];				// used to discourage other AI's from taking the same path as this AI


// alert state variables

var		vector					LastKnownPlayerLocation;		// last known location of player
var		vector					LastKnownPlayerDirection;		// might be useful for knowing which direction we think the player was headed.
var		float					LastKnownPlayerTime;			// time at which we last definitively knew the location of the player
var		float					TimePlayerFirstSeen;			// needed so pattern can evaluate if this is the first time detecting the player
var		float					MonitorTimer;					// used to check every x seconds for events to send to group
var     Actor					TargetActorToFire;
var     vector                  TargetPosition;
var		AIEventType				LastAlertMonitorEventType;		// set during MonitorAlertState so we don't send the same event twice
var     int						FireLocation;				
var		int						VisionLocation;
var		vector					LastSearchLocation;				// used by pattern to check search location reachability

var		ESearchManager			SearchManager;					// Search Manager object -- query for search locations
var		name					ASearchLookA;					// chosen look animation A
var		name					ASearchLookB;					// chosen look animation B

// Goal variables

var		EGoalList				m_pGoalList;					// goal list - use GetCurrent() to obtain current goal
var		float					InternalGoalTimer;				// goal.GoalTimer variable needs to be used in different ways ....
var		float					PersonalityAnimTimer;			// timer for blending playback of personality anims
var		float					FocusTimer;						
var		float					FocusSwitchTime;				// calculated time to keep focus according to EPawn vars FocusSwitchTimeBase/Offset
var		int						NumWanderPoints;				// used for goal_wander

var     Name                    WaitingForSig;   

// Pointer to my group

var		EGroupAI				Group;							// AI currently belongs to this group
var     EAIEvent				AIEvent;


// Group related variables 

var     int						LastGoalStatus;
var     EchelonEnums.GoalType	LastGoalType;
var		int						Type;
var		EPattern				Pattern;
var		vector					TargetLocation;
var     Actor					TargetActor;

// hearing vars

struct SNoiseHistory 
{
	var Vector		nLoc;
	var Pawn		nMaker;
	var NoiseType	nType;
	var float		nTime; 
};

var		SNoiseHistory			NoiseHistory[8];				// array of information about recently heard noise
var		int						NoiseIndex;						// current index into NoiseHistory array

//gun
var bool			bFiring;

// procedural view modification vars

var		float					MostRecentStopTime;				// used so that we don't focus switch immediately after stopping for some small amount of time ..

struct SFocusSwitchInfo
{
	var	float					YawInterpolationSpeed;			// multiplier for smooth interpolation of ViewRotation rotator 
	var	float					YawMinOffset;					// minimum distance of yaw offset in either direction from ForwardDirection
	var	float					YawMaxOffset;					// maximum "
	var	float					MinTurnSpeed;					// minimum speed of turn during focus switching
	var	float					MaxTurnSpeed;					// maximum "
	var float					SwitchTimeBase;					// mimimum time before NPC will shift focus
	var float					SwitchTimeOffset;				// max random offset added to SwitchTimeBase
};

var		SFocusSwitchInfo		FocusInfo;						// struct is modified by the controller for varied usage depending on state

enum CoverAttackDir
{
	CA_Off,
	CA_Left,
	CA_Right,
	CA_Up,
	CA_Waiting
};



var Array<EGameplayObject>      LockedSwitches;   

struct SNavPointTimeout
{
    var NavigationPoint oPoint;
    var float           fReenableTime;
};

var Array<SNavPointTimeout>      NavPointsTimedOut;

var Array<EAIController>         aoCloseControllers;       

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var(Enhanced) bool bIgnoreDamage; // Joshua - Prevent this NPC from taking damage

// Joshua - Player stats
var(Enhanced) bool bWasKnockedOut; // Joshua - Tracks if this NPC was ever knocked out
var(Enhanced) bool bWasInjured; // Joshua - Tracks if this NPC has been injured
var(Enhanced) bool bWasFound; // Joshua - Tracks if this NPC has been found as a body
var(Enhanced) bool bAllowKill;  // Joshua - Allows NPC to be killed without affecting the Stealth Rating
var(Enhanced) bool bAllowKnockout;  // Joshua - Allows NPC to be knocked out without affecting the Stealth Rating
var(Enhanced) bool bBlockDetection;  // Joshua - Allows NPC to detect the player without affecting the Stealth Rating
var(Enhanced) bool bNotInStats; // Joshua - NPC should not be included in the Player Statistics
var(Enhanced) bool bBlockJumpDetection; // Joshua - Workaround so drop attacking NPC doesn't trigger a detection



/***************************************************************************************************
 ******			NATIVE FUNCTIONS               *****************************************************
 ****

	Including point selection, goal execution, navigation, etc.

																							********
     ***********************************************************************************************
***************************************************************************************************/


native(1434) final function RelocatePawnOnGround();

native(1424) final function CoverAttackDir EvaluateCorner(NavigationPoint CoverPoint,  Vector TargetLocation);



//---------------------------------------[David Kalina - 14 Jun 2001]-----
// 
// Description
//		Called when we wish to expand our search.
//		We want to find a search point in a given direction, within a 
//		certain distance, and not too far up or down (hence, Z_Threshold)
//		so we don't end up continuing our search on another floor ..
//
// Input
//		StartPoint:  Location from which we begin our search
//		Direction:	 Direction we wish to look in -- if not specified, check in all directions.
//		Angle :		 Only take nav points within this angle around Direction.
//		MinDist:     Take nav point at least this far from StartPoint
//		MaxDist:	 Take the nav point closest (but less than) this value.
//		Z_Threshold: Cull Nav Points with Z's +/- our EPawn's current Z.
//
// Output
//		NavigationPoint : tha new shit
// 
//------------------------------------------------------------------------

native(1509) final function NavigationPoint ChooseSearchPoint(vector StartPoint,
															  optional vector Direction, 
															  optional float Angle,
															  optional float MinDist,
															  optional float MaxDist, 
															  optional float Z_Threshold);


//---------------------------------------[David Kalina - 28 Apr 2002]-----
// 
// Description
//		Update Search Goal according to input parameters.
// 
//------------------------------------------------------------------------

native(1545) final function UpdateSearchGoal(vector GoalLocation, bool GoalFlag, bool bResetTimer);


//---------------------------------------[David Kalina - 20 Jun 2001]-----
// 
// Description
//		Choose a nearby navigation point from which we can attack the
//		player.
//
// Input
//		MaxDist : Distance within which we will search.
//		Z_Threshold : don't take nav points > +/- this value
// 
//------------------------------------------------------------------------

native(1510) final function NavigationPoint ChooseAttackPoint(float MaxDist, optional float Z_Threshold);
native(1511) final function NavigationPoint ChooseCoverPoint(float MaxDist, optional float Z_Threshold, optional vector TargetLocation);


//----------------------------------------[David Kalina - 3 May 2002]-----
// 
// Description
//		Choose from the list of nearby NavigationPoints with bHidePoint set.
// 
//------------------------------------------------------------------------

native(1547) final function NavigationPoint ChooseHidePoint();


//----------------------------------------[David Kalina - 4 Jul 2001]-----
// 
// Description
//		Sets lock on NavigationPoint specified by Nav.
//		Also clears any existing locks we might hold.
//
// Input
//		Nav : Navigation point we wish to get a lock on.
//
//------------------------------------------------------------------------
native(1512) final function UnlockNavPoint();
native(1421) final function LockNavPoint(NavigationPoint _Nav);



//---------------------------------------[David Kalina - 15 Apr 2002]-----
// 
// Description
//		Clear existing WeightedRoute array and reset the extra cost.
// 
//------------------------------------------------------------------------

native(1544) final function ClearRoutes();


//---------------------------------------[David Kalina - 17 Jul 2001]-----
// 
// Description
//		Called when NPC is supposed to get on ladder.
//		This means we are already at a ladder waypoint - 
//		we should be guaranteed that we are closest to the appropriate ladder.
//
// Input
//		bIsBottom : returned > 0 if closer to bottom of ladder
//		bOtherSide : location check for destination -> must be != bIsBottom to use ladder
//		Destination:  check which side of ladder this point is at (for bOtherSide)
// 
//------------------------------------------------------------------------

native(1516) final function bool FindLadder(out byte bIsBottom, out byte bOtherSide, optional vector Destination);



//---------------------------------------[David Kalina - 18 Apr 2001]-----
// 
// Description
//		AI Goal Processing
//		Evaluates current goal's GoalType and manipulates
//
// Output
//		EchelonEnums.GoalStatus:
//			GS_Executing - Processing.. 
//			GS_Complete  - Just finished goal..
//			GS_Failure   - Can not finish goal
// 
//------------------------------------------------------------------------

native(1522) final function EchelonEnums.GoalStatus ExecuteCurrentGoal();



//----------------------------------------[David Kalina - 2 May 2001]-----
// 
// Description
//		Sub-Goal - called frequently by ExecGoal functions.
//
//		This is the CORE path-finding and movement function.
//		Given a point to reach, it will move us towards that point
//		in every frame adjusting so as to follow the shortest path.
//
// Input
//		Destination : Where we ultimately want to get to.
//		MoveFlags : 
//
// Output
//		function EchelonEnums.GoalStatus : 
//			GS_Executing : Haven't reached point yet
//			GS_Failure   : Won't reach point
//			GS_Complete  : Point reached
//
// Preconditions - MAYBE GONE
//		m_pNextNavPoint MUST be set to None before this is called
//		for the first time in a pathfinding sequence..
//
//------------------------------------------------------------------------


native(1521) final function EchelonEnums.GoalStatus SubGoal_NavigateTo(vector Destination, MoveFlags MoveFlags);


//---------------------------------------[David Kalina - 23 Feb 2002]-----
// 
// Description
//		Use EMoveToward to reach our specified Destination exactly.
// 
//------------------------------------------------------------------------

native(1538) final latent function WalkToDestination(vector Destination);


//---------------------------------------[David Kalina - 10 Apr 2001]-----
// 
// Description
//		Replacement for MoveToward - this one works w/ blending 
//		and lets the Pawn take care of its own speed.
//
// Input
//		TargetActor : target
//		ViewTarget : focus
//		MoveFlags : determine how we attempt to reach given point
// 
// Output
//		bool : GS_Complete  | Reached Destination
//			   GS_Executing | Not there yet ...
//			   GS_Failure   | Can't get there (stuck?)
//
//------------------------------------------------------------------------

native(1518) final function EchelonEnums.GoalStatus EMoveToward(Actor TargetActor, MoveFlags MoveFlags);


//---------------------------------------[David Kalina - 26 Jul 2001]-----
// 
// Description
//		Plays waiting animation appropriate to moveflags.
//		Face vector Focus.  
// 
//------------------------------------------------------------------------

native(1520) final function StopMovement(vector Focus, MoveFlags MoveFlags);


//---------------------------------------[David Kalina - 12 Jun 2001]-----
// 
// Description
//		Use currently selected weapon to attack target.
//
// Input
//		Target : Actor we wish to hurt, badly.
//
//------------------------------------------------------------------------

native(1527) final function SubGoal_AttackTarget(Actor Target, bool bForceFire);


//---------------------------------------[David Kalina - 29 May 2002]-----
// 
// Description
//		Return true if input actor is dead.
//
//------------------------------------------------------------------------

native(1519) final function bool CheckTargetDead(Actor _target);


//----------------------------------------[David Kalina - 4 Sep 2001]-----
// 
// Description
//		Update bPlayerSeen flag and LastKnown* variables.
//		Should we allow optional external updates??  If necessary, it can be done.  
//			e.g. Group communicates player location and while bPlayerSeen is not set, we 'know' player's loc...
//
// Input
//		PlayerPawn :  The Player's Pawn.
//		bIsSeen :	  Do we presently PHYSICALLY see the player?
// 
//------------------------------------------------------------------------

native(1549) final function UpdatePlayerLocation(Pawn PlayerPawn, bool bIsSeen, optional bool ForcedUpdate);

//---------------------------------------[David Kalina - 30 Mar 2002]-----
// 
// Description
//		Handle collision with other Pawns in C++.
// 
//------------------------------------------------------------------------

native(1543) final function NotifyBumpPawn(ePawn BumpPawn);





/***************************************************************************************************
 ******			INTIALIZATION				   *****************************************************
 ****

	X_BeginPlay calls, plus any other initialization related routines.

																							********
     ***********************************************************************************************
***************************************************************************************************/



//---------------------------------------[David Kalina - 27 Jun 2001]-----
// 
// Description
//		Set up randomized time-sliced timer values. 
//
//------------------------------------------------------------------------

function PreBeginPlay()
{
	Super.PreBeginPlay();
	EnvironmentCheckTimer = 0.25 * FRand();
}


//----------------------------------------[David Kalina - 1 Jun 2001]-----
// 
// Description
//		Create clean EAIEvent object for communication with group object.
// 
//------------------------------------------------------------------------
function PostBeginPlay()
{
	Super.PostBeginPlay();
	AIEvent = spawn(class'EAIEvent');//AIEvent = new class'EAIEvent';

	// create unique temp nav points for SubGoal_NavigateTo and EMoveToward
	TempMovePoint		= Spawn(class'EDynamicNavPoint');
	TempNavPoint		= Spawn(class'EDynamicNavPoint');
    TempWalkPoint		= Spawn(class'EDynamicNavPoint');
	DynamicFocusPoint	= Spawn(class'EDynamicFocusPoint');
}


//----------------------------------------[Fresderic Blais - 1 Jun 2001]-----
// 
// Description
//		Reset the list of goals
// 
//------------------------------------------------------------------------
event ResetGoalList()
{
	m_pGoalList.Reset();
}

//----------------------------------------[David Kalina - 7 Mar 2001]-----
// 
// Description
//      Important so we know when the Pawn variable is set
// Input
//		aPawn : Pawn we are possessing.
// 
//------------------------------------------------------------------------

function Possess(Pawn aPawn)
{
    Super.Possess(aPawn);
	
	// cast to EPawn
	
	ePawn = EPawn(aPawn);
	eGame = EchelonGameInfo(Level.Game);
	
	if	(ePawn == none)
		Log("WARNING!!  AIController Pawn is NOT an EPawn.  This is bad.");
	
	// SPAWN INTERACTION ZONE FOR NPC
    if (!ePawn.bForceNoInteraction && !ePawn.bIsDog)
    {
	    ePawn.InteractionClass = class'ENpcZoneInteraction';
	    ePawn.Interaction = Spawn(ePawn.InteractionClass, ePawn);
    }


	//set the actor to defend
	ePawn.DefendActor = GetMatchingActor(ePawn.DefendActorTag);

    // can now call initialization
    GotoState('s_Init');
}


//---------------------------------------[David Kalina - 28 Mar 2001]-----
// 
// Description
//      Add myself to group specified in EPawn.m_GroupTag
//
//------------------------------------------------------------------------

function FindGroup()
{
	local EGroupAI pGroup;
	
	// if tag has been specified, match ourselves with a group
	if (ePawn.m_GroupTag != '')
	{
		foreach DynamicActors(class'EGroupAI', pGroup, ePawn.m_GroupTag)
		{
			Log("GROUP MATCH : " $ ePawn.m_GroupTag,,LAICONTROLLER);
			
			pGroup.AddAIMember(self);	// add self to group
			Group = pGroup;				// set member pointer
			
			//set pawn variable
			EAIPawn(ePawn).Group = Group;

			break;  // first match is all we need right now
		}
	}
	
	// if designer hasn't specified a group, create EGroupOfOne for myself
	if (Group == none)
	{
		Log("FINDGROUP -- no match, spawning default EGroupAI object",,LAICONTROLLER);
		Group = Spawn(class'EGroupAI',, ePawn.m_GroupTag);				
		Group.AddAIMember(self);
	}
}


//---------------------------------------[David Kalina - 19 Apr 2001]-----
// 
// Description
//		Creates our first goal based on EPawn Designer Variables 
//		This initial / default goal will be of lowest priority so it 
//		will always be at the back of the list and executed when there
//		are no other options.
//
//		Also spawns the Goal List.
//
//		Goal will be executed in Default state.
//
//------------------------------------------------------------------------

function SetupInitialGoal()
{
	local EGoal goal;
	
	goal = Spawn(class'EGoal');  //goal = new class'EGoal';							// create an EGoal
	
	goal.Clear();										// initialize
	
	goal.m_GoalType		= ePawn.InitialGoalType;		// set its Type
	
	goal.GoalLocation	= ePawn.InitialGoalLocation;	// set its location
	goal.GoalFocus		= ePawn.InitialGoalFocus;		// set its focus
	goal.GoalTag		= ePawn.InitialGoalTag;			// set its tag
	goal.GoalSound		= ePawn.InitialGoalSound;		// set its sound
	goal.GoalAnim		= ePawn.InitialGoalAnim;		// set its anim
	goal.GoalFlag		= ePawn.InitialGoalFlag;		// set its flag
	goal.GoalValue		= ePawn.InitialGoalValue;
	goal.GoalMoveFlags  = ePawn.InitialGoalMoveFlags;
	goal.GoalWaitFlags	= ePawn.InitialGoalWaitFlags;
	
	goal.Priority		= 0;							// default goal has lowest priority
	
	
	// spawn list and add goal
	m_pGoalList = Spawn(class'EGoalList',self);
	m_pGoalList.pOwner = self;
	m_pGoalList.Insert(goal);
}



//----------------------------------------[David Kalina - 7 Mar 2001]-----
// 
// Description
//      Initialization routine.
//      Determines initial state based on designer vars (is there patrol network?)
// 
//------------------------------------------------------------------------

event InitPatrolNetwork(Name PatrolPointTag)
{
    local NavigationPoint pCurrentPoint;
	
    if  (PatrolPointTag != '') 
    {
        // pawn has specified start point for patrol network
        foreach AllActors(class'NavigationPoint', pCurrentPoint, PatrolPointTag)
        {
			if (pCurrentPoint.Patrol != none)
			{
				//Log("INITPATROLNETWORK - found patrol point matching " $ PatrolPointTag);
				m_pNextPatrolPoint = pCurrentPoint;
				return;
			}
			else
			{
				Log("wARNING:  INITPATROLNETWORK - patrol point failed matching tag: " $ PatrolPointTag $ " .. Target has no PatrolInfo");
				return;
			}
        }
		Log("WARNING:  INITPATROLNETWORK - found no patrol network matching " $ PatrolPointTag);
	}
	else
		Log("WARNING:  INITPATROLNETWORK - NO Patrol Network Specified");
}



/***************************************************************************************************
 ******			MISCELLANEOUS				   *****************************************************
 ****

	Debug functionality
	Events / Notifys (including Touch / Untouch / AnimEnd / etc.)


																							********
     ***********************************************************************************************
***************************************************************************************************/


//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Called by HUD when exec statement ShowDebug is used.
//		Can use here for specific EAIController info (e.g. GoalList)
//
// Input
//		Canvas : 
//		YL : dist between y
//		YPos : current y position
// 
//------------------------------------------------------------------------

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local String T;
	
	Super.DisplayDebug(Canvas, YL, YPos);

	Canvas.DrawColor.B = 255;	
	Canvas.DrawColor.R = 170;
	Canvas.DrawColor.G = 190;

	T = "AICycles:  " $ AICycles $ " bPlayerSeen:  " $ bPlayerSeen $ " GroupAI: "$Group$"  CurrentGEID : " $ CurrentGEID $ "  SpecialMoveDoor:  " $ SpecialMoveDoor $ "  StrictFocus:  " $ StrictFocus $ "  BaseMoveFlags : " ;

	switch (ePawn.BaseMoveFlags)
	{
		case MOVE_WalkRelaxed   : T = T @ "WalkRelaxed";		break;
		case MOVE_WalkNormal	: T = T @ "WalkNormal";			break;
		case MOVE_WalkAlert		: T = T @ "WalkAlert";			break;
		case MOVE_JogAlert		: T = T @ "JogAlert";			break;
		case MOVE_JogNoWeapon	: T = T @ "MOVE_JogNoWeapon";	break;
		case MOVE_CrouchWalk	: T = T @ "CrouchWalk";			break;
		case MOVE_CrouchJog		: T = T @ "CrouchJog";			break;
		case MOVE_Snipe			: T = T @ "Snipe";				break;
		case MOVE_Search		: T = T @ "Search";				break;
	}

	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText(T,false);

	AICycles = 0.0f;
	YPos += YL * 2;
	Canvas.SetPos(4,YPos);

	if (m_pGoalList != none)
		m_pGoalList.DisplayDebug(Canvas, YL, YPos);

	if (Pattern != none)
		Pattern.DisplayDebug(Canvas, YL, YPos);
}


//---------------------------------------[David Kalina - 30 Jan 2002]-----
// 
// Description
//		EAIController PLOG
// 
//------------------------------------------------------------------------

function plog(coerce string S)
{
	log(Pawn.Name $ " - " $ Name $ " -- STATE:  " $ GetStateName() $ " -- " $ S,,LAICONTROLLER);
}


//----------------------------------------[Frederic Blais - 13 NOv 2001]-----
// 
// Description: Check if the cover point is valid for the current attack
//
//------------------------------------------------------------------------

function touch(actor other)
{
	local NavigationPoint Nav;


	Nav = NavigationPoint(other);

	if (Nav != None)
	{
		//log("*************************** ---- Nav point was touched --- by pawn: "$Pawn$" *****************");

		/**** FOR TOUCHING LADDER POINTS ****/

		if (Nav.bLadderPoint)
		{
			// store ID of ladder point so we know we are in the vicinity of a ladder
			//plog(" TOUCH --> Setting Current GEID to Ladder ID : " $ Nav.LadderID);
			SetCurrentLadder(Nav.LadderID);
		}


		/**** FOR TOUCHING COVER POINTS ****/
		
		//UnlockNavPoint();

		//check if the AIController is currently controlled by a scripted pattern
		else if ((Group.ScriptedPattern == None) || (Group.bExternEventWasSent && !Group.bEventExclusivity))
		{
			//log(" ---- Nav point was touched --- by pawn: "$Pawn$" TAKE 2");

			//check it is a cover point
			if (TakenPoint != Nav)
			{
				if (Nav.taken)
					return;

				if (eGame.pPlayer == None)
					return;

				//check if our lastknownplayerLocation is reasonably close to do a cover point attack
				if (VSize(eGame.pPlayer.ePawn.Location - LastKnownPlayerLocation) > 150)
					return;

				if (EvaluateCorner(Nav,eGame.pPlayer.ePawn.Location) > CA_OFF)
				{
					LockNavPoint(Nav);

					Pattern.CoverLocation = Nav.Location;
		
					AIEvent.Reset();
					AIEvent.EventType			= AI_COVERPOINT_TOUCHED;	
					AIEvent.EventTarget			= Nav;

					Group.AIEventCallBack(self, AIEvent);
				}
			}
		}
	}
}


//---------------------------------------[David Kalina - 29 May 2002]-----
// 
// Description
//		If untouching a ladder point, unlock the ladder.
//		Should not be called when ON the ladder (as the NPC might leave
//		the bottom ladder point's radius and re-enter the top ladder point).
// 
//------------------------------------------------------------------------

function UnTouch(actor Other)
{	
	local NavigationPoint Nav;

	if (CurrentGEID <= 0)
		return;

	Nav = NavigationPoint(other);

	if (Nav != None)
	{
		/**** FOR TOUCHING LADDER POINTS ****/
		
		if (Nav.bLadderPoint && Nav.LadderID == CurrentGEID)
		{			
			UnlockLadder();	
		}
	}
}


//---------------------------------------[David Kalina - 22 May 2001]-----
// 
// Description
//		Collision detected with another actor
// 
// Input
//		Other : actor we bump into
//
// Output
//		bool : TRUE = pawn not notified
// 
//------------------------------------------------------------------------

event bool NotifyBump(Actor Other, optional int Pill)
{
	local EPawn BumpeePawn;
	local Controller Bumpee;
	local Vector BumpLoc, BumpDir;

	local Vector PVect,LocationEnd;
	local EGoal Goal;

	BumpeePawn = EPawn(Other);
	if (BumpeePawn != none)
	{
		Bumpee = BumpeePawn.Controller;

		if (Bumpee != none && Bumpee.bIsPlayer)
		{
			// check if player is behind us - if so we want to give some leeway
			BumpLoc = Bumpee.Pawn.Location;
			BumpDir = Normal(BumpLoc - ePawn.Location);

			//Log("BUMP:  " $BumpDir dot Vector(EPawn.Rotation));

			if (BumpDir dot Vector(ePawn.Rotation) < -0.2f)
			{
				if (BumpTimer == 0.0f)
					BumpTimer = Level.TimeSeconds;

				// don't send event right now...
				if (Level.TimeSeconds - BumpTimer < 0.3f)
				{
					//log("BUMP : Don't send event yet.");
					return true;
				}
				/*else if (Level.TimeSeconds - BumpTimer > 2.0f)		// been "a while" since last bump
				{
					//log("BUMP : Resetting BumpTimer.");
					BumpTimer = 0.0f;
					return true;
				}*/
			}

			BumpTimer = 0.0f;
			//log("BUMP : Sending SEE_PLAYER event to GroupAI");

			// standard response is to be surprised...


			if (!bPlayerSeen)
			{
				UpdatePlayerLocation(Bumpee.Pawn, true);

				AIEvent.Reset();
				AIEvent.EventType			= AI_SEE_PLAYER_SURPRISED;		// maybe need bump event
				AIEvent.EventTarget			= Bumpee.Pawn;

				Group.AIEventCallBack(self, AIEvent);
			}
			else
			{
				UpdatePlayerLocation(Bumpee.Pawn, true);
			}

		}
	}		

	if (BumpeePawn == None)
		return true;

	NotifyBumpPawn(BumpeePawn);
		
	return true;	
}

//----------------------------------------[David Kalina - 6 Jun 2001]-----
// 
// Description
//		Try to catch stuck AI.  
//		Once we catch a stuck Pawn, we will do something.
//
// Input
//		HitNormal : 
//		Wall : 
//
// Output
//		event bool : TRUE = pawn not notified
//
//------------------------------------------------------------------------

event bool NotifyHitWall(vector HitNormal, actor Wall)
{
	bHittingWall = true;

	return true;
}


//---------------------------------------[David Kalina - 11 Jun 2001]-----
// 
// Description
//		Weapon is firing, play / blend firing animation in EPawn.
//
//------------------------------------------------------------------------

function NotifyFiring()
{
}

//---------------------------------------[David Kalina - 26 Jun 2001]-----
// 
// Description
//		Called by weapon if we try to fire and there's nothing left in the chamber. 
//
//
//------------------------------------------------------------------------

function NotifyOutOfAmmo()
{
	AIEvent.Reset();
	AIEvent.EventType = AI_NO_AMMO;

	Group.AIEventCallBack(self, AIEvent);
}




//------------------------------------------------------------------------
// Description		
//		Called from the weapon. NPC always reload
//------------------------------------------------------------------------

event AnimEnd(int Channel)
{
	local EWeapon w;

	if (Channel == ePawn.ACTIONCHANNEL && ePawn.HandItem != None)
	{
		// If weapon in Reload state, will catch the AnimEnd
		w = EWeapon(ePawn.HandItem);
		if (w != None)
			w.AnimEnd(69);
	}
	
	// forward all other AnimEnd calls to EPawn
	else
		ePawn.AnimEnd(Channel);
}

function  NotifyReloading()
{
	ePawn.PlayReload();
}



//---------------------------------------[David Kalina - 25 Jul 2001]-----
// 
// Description
//		reset timer - for ExecGoal_Patrol only
// 
//------------------------------------------------------------------------

event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
{
	local EGoal goal;

	goal = m_pGoalList.GetCurrent();


	//reach the default goal
	while (goal != None)
	{
	if (goal.m_GoalType == GOAL_Patrol)
	{
		goal.GoalValue = 0.01f;		// reset timer so that next tick will advance patrol
        bWaitingForPatrolTrigger = false;

		// update focus
		if (m_pNextPatrolPoint.Patrol.m_FocusTag != '')
			goal.GoalFocus = GetMatchingActor(m_pNextPatrolPoint.Patrol.m_FocusTag).Location;							// use m_FocusTag if it exists
		else
			goal.GoalFocus = m_pNextPatrolPoint.Location;

			break;
		}
		
		goal = goal.Next;
	}
}


//---------------------------------------[David Kalina - 23 Jul 2001]-----
// 
// Description
//		Typically the Group AI will instruct us to switch states
//		immediately.  However if we need to wait for some other state
//		to complete, we can override this function (see the ladder code).
//
// Input
//		State : 
// 
//------------------------------------------------------------------------

event GotoStateSafe(name State)
{
	//log("GotoStateSafe - from : " $ GetStateName() $ "  to : " $ State);
	GotoState(State);
}



//---------------------------------------[David Kalina - 24 Oct 2001]-----
// 
// Description
//		Script interface for triggering cover attacks.
//		May be called frequently during
// 
//------------------------------------------------------------------------

event AttackFromCover(CoverAttackDir dir)
{
	switch (dir)
	{
		case CA_Off :

			// reset animation set
			ePawn.CoverPeekEnd();	
			break;

		case CA_Right :

			ePawn.CoverPeekRight();
			break;
			
		case CA_Left : 

			ePawn.CoverPeekLeft();
			break;

		case CA_Up :

			ePawn.CoverPeekUp();
			break;
	}
}


//------------------------------------------------------------------------
// Description
//		Send player dead message.
//------------------------------------------------------------------------

function NotifyKilledPlayer(EPawn Player)
{
	if (!Player.Controller.bIsPlayer)
		return;
	if (Player.Health > 0)
		return;

	log("TESTING NEW AI_PLAYER_DEAD LOC.");

	//be sure that the health is really Null
	AIEvent.EventType		= AI_PLAYER_DEAD;
	AIEvent.EventTarget		= Player;
	AIEvent.EventLocation	= Player.Location;

	Group.AIEventCallBack(self, AIEvent);
}


//----------------------------------------[David Kalina - 6 Mar 2002]-----
//
// Description
//		Should be called if shot clearly just missed us.
//
//		Used when Hat is shot off of head -->
//		other potential uses are for shots that go through cylinder but don't hit pills
//		or collision with other objects on mesh that don't cause TakeDamage() to be called.
// 
// Input
//		Instigator : Pawn whose shot just missed our Pawn.
// 
//------------------------------------------------------------------------

event NotifyShotJustMissed(Pawn Instigator)
{
	// send event to group
	AIEvent.Reset();
	AIEvent.EventType		= AI_SHOT_JUST_MISSED;
	AIEvent.EventTarget		= Instigator;
	AIEvent.EventLocation	= Instigator.Location;
			
	Group.AIEventCallBack(self, AIEvent);
}



//----------------------------------------[David Kalina - 1 May 2001]-----
// 
// Description
//		iterates through level list to find a tag matching the fn input
//
// Input
//		NavPointTag : tag which we are searching for
//
// Output
//		NavigationPoint : FIRST matching nav point
// 
//------------------------------------------------------------------------

function NavigationPoint GetNavigationPoint(Name NavPointTag)
{
	local NavigationPoint nav;

	if  (NavPointTag != '') 
    {
		// faster than iteration
		for (nav = Level.NavigationPointList; nav != None; nav = nav.NextNavigationPoint)
		{
			if (nav.Tag == NavPointTag)
				return nav;
		}
	}

	return none;
}


//---------------------------------------[David Kalina - 13 Mar 2002]-----
// 
// Description
//		Return turn speed as specified per state.
//
//------------------------------------------------------------------------

event int GetTurnSpeed() 
{
	return ePawn.TurnSpeed_Default;
}


//---------------------------------------[David Kalina - 18 Mar 2002]-----
// 
// Description
//		Specify the animations that can be played for each group
//		and choose randomly.
//
//		Forward to EPawn for character-specific reactions.
// 
//------------------------------------------------------------------------

function GetReactionAnim(out name Anim, out name AnimB, out float BlendAlpha, optional eReactionAnimGroup ReactionGroup)
{
	ePawn.GetReactionAnim(Anim, AnimB, BlendAlpha, ReactionGroup);
}



//---------------------------------------[David Kalina - 26 Mar 2002]-----
// 
// Description
//		Must clamp AimAt maximum angle based on state.
// 
//------------------------------------------------------------------------

event float GetMaximumAimAngle()
{
	return ePawn.MaxAimAngle_Default;
}


//---------------------------------------[David Kalina - 10 Dec 2001]-----
// 
// Description
//		Return true if we are able to find and successfully equip an 
//		inventory item of class ItemClass.
// 
//------------------------------------------------------------------------
event bool SelectItem(class<EInventoryItem> ItemClass)
{	
	local EGameplayObject GameplayObj;
	local EInventoryItem NewItem;
	local int i;
	

	// Equip the next one
	NewItem = ePawn.FullInventory.GetItemByClass(ItemClass.name);

	if (NewItem != None)
	{
		// unequip current weapon if any
		if (ePawn.WeaponStance > 0)
		ePawn.Transition_WeaponAway();

		// queue transition to equip selected item
		ePawn.Transition_ItemSelect(NewItem);

		return true;
	}
	else
		return false;
}

//---------------------------------------[David Kalina - 27 Apr 2001]-----
// 
// Description
//		Removes currently selected item from NPC, "throw"-ing it at a specified speed.
// 
//------------------------------------------------------------------------
function DropSelectedItem(vector DropVelocity)
{
	// Throw() function removes the HandItem reference if any ..
	if (ePawn.HandItem != none && ePawn.HandItem != ePawn.CurrentWeapon)
	{
		ePawn.HandItem.Throw(self, DropVelocity);
		ePawn.FullInventory.UnEquipItem(ePawn.FullInventory.GetSelectedItem());
	}
}

//---------------------------------------[David Kalina - 14 Nov 2001]-----
// 
// Description
//		State-based check of current Transition Table.
//		Returns Transition Type based on input rating and distance.
//
//		DEFAULT event uses INVESTIGATE table (because it is simpler - no TRAN_Investigate/Surprised returns)
// 
//------------------------------------------------------------------------
event ETransitionType CheckTransitionTable(VisibilityRating VisRating, float distance)
{
	local float ModDistance;

	if (ePawn.bSniper)
	{
		//if the NPC is a sniper just consider one transition table
		if (distance < ePawn.VisTable_Alert[ VisRating ])
		{
			//log("CheckTransitionTable (SniperMode) -- VisRating " $ VisRating $ " at distance " $ distance $ "  returns TRAN_Alert");
			return TRAN_Alert;
		}
	}
	else
	{

		//check the zone info of the NPC to see if there's fog in the zone (assumption: DistanceFogStart = 0)
		if (Pawn.Region.Zone.bDistanceFog)
		{
			if (distance > Pawn.Region.Zone.DistanceFogEnd)
			{	
				return TRAN_None;
			}

			//modifying the distance in function of the fog distance
			ModDistance = distance * ePawn.m_VisibilityMaxDistance / Pawn.Region.Zone.DistanceFogEnd;

		}
		else
		{
			ModDistance = distance;
		}


		if (ModDistance < ePawn.VisTable_Surprised[ VisRating ])
		{
			//log("CheckTransitionTable -- VisRating " $ VisRating $ " at distance " $ distance $ "  returns TRAN_Surprised");
			return TRAN_Surprised;
		}

		if (ModDistance < ePawn.VisTable_Alert[ VisRating ])
		{
			//log("CheckTransitionTable -- VisRating " $ VisRating $ " at distance " $ distance $ "  returns TRAN_Alert");
			return TRAN_Alert;
		}

		if (ModDistance < ePawn.VisTable_Investigate[ VisRating ])
		{
			//log("CheckTransitionTable -- VisRating " $ VisRating $ " at distance " $ distance $ "  returns TRAN_Investigate");
			return TRAN_Investigate;
		}
	}

	return TRAN_None;
}


//---------------------------------------[David Kalina - 13 Mar 2001]-----
// 
// Description
//		Use table lookup to determine necessary state change, if any.
//
// Input
//		SeenPlayer : The Player's Pawn.
//
//------------------------------------------------------------------------

event SeePlayer(Pawn SeenPlayer)
{
	local int				i;
	local float				Distance;

	if (SeenPlayer != none)
	{
		if (!SeenPlayer.Controller.bIsPlayer)
		{
			log("WARNING!!  SeePlayer event called with non-player?  "  $ SeenPlayer);
			return;
		}

		if (SeenPlayer.bHidden)
			return;

		if (bPlayerSeen)
		{
			UpdatePlayerLocation(SeenPlayer, true);		// no table lookup if player already seen
			return;
		}

		if (ePawn.bUseTransitionTable)
		{

			// obtain player distance
			Distance = VSize(SeenPlayer.Location - ePawn.Location);
			
			// if player is 'invisible' send see_player_surprised event at close range
			if (SeenPlayer.GetActorVisibility() == VIS_Invisible)
			{
				if (Distance < 180.0f)
				{					
					if ((Normal(SeenPlayer.Location - ePawn.Location) dot vector(ePawn.Rotation)) > 0.85f)
					{
						if (!bPlayerSeen)
						{
							UpdatePlayerLocation(SeenPlayer, true);

							// only send event to group  if bplayerseen was previously false
							AIEvent.Reset();
							AIEvent.EventType			= AI_SEE_PLAYER_SURPRISED;
							AIEvent.EventTarget			= SeenPlayer;
							AIEvent.EventLocation		= SeenPlayer.Location;

							Group.AIEventCallBack(self, AIEvent);
						}
						else
							UpdatePlayerLocation(SeenPlayer, true);
					}
				}

				return;
			}
			
			
			switch (CheckTransitionTable(SeenPlayer.GetActorVisibility(), Distance))
			{
				case TRAN_None :
					
					return;
					
				case TRAN_Investigate : 
					
					// compose AIEvent message to send to group
					AIEvent.Reset();
					AIEvent.EventTarget   = SeenPlayer;
					AIEvent.EventLocation = SeenPlayer.Location;
					AIEvent.EventType	  = AI_SEE_PLAYER_INVESTIGATE;
					
					Group.AIEventCallBack(self, AIEvent);
					
					break;
					
				case TRAN_Alert :
					
					// send message to group if player has not already been seen
					if  (!bPlayerSeen)
					{
						UpdatePlayerLocation(SeenPlayer, true);
						
						AIEvent.Reset();
						AIEvent.EventTarget   = SeenPlayer;
						AIEvent.EventLocation = SeenPlayer.Location;
						AIEvent.EventType     = AI_SEE_PLAYER_ALERT;
						
						Group.AIEventCallBack(self, AIEvent);
					}
					else								
						UpdatePlayerLocation(SeenPlayer, true);
					
					break;
					
				case TRAN_Surprised :
					
					// send message to group if player has not already been seen
					if  (!bPlayerSeen)
					{
						UpdatePlayerLocation(SeenPlayer, true);
						
						AIEvent.Reset();
						AIEvent.EventTarget   = SeenPlayer;
						AIEvent.EventLocation = SeenPlayer.Location;
						AIEvent.EventType = AI_SEE_PLAYER_SURPRISED;
						
						Group.AIEventCallBack(self, AIEvent);
					}
					else
						UpdatePlayerLocation(SeenPlayer, true);
					
					break;
			}
		
		}
		else
		{

			if  (!bPlayerSeen)
			{
				// compose AIEvent message to send to group
				AIEvent.Reset();
					
				UpdatePlayerLocation(SeenPlayer, true);

				AIEvent.EventType			= AI_SEE_PLAYER_ALERT;
				AIEvent.EventTarget			= SeenPlayer;
				AIEvent.EventLocation		= SeenPlayer.Location;

				Group.AIEventCallBack(self, AIEvent);			// send message to group
			}
			else
			{
				UpdatePlayerLocation(SeenPlayer, true);
			}
		}
	}
}
	


//---------------------------------------[David Kalina - 22 Jun 2001]-----
// 
// Description
//		Check every x seconds for certain situational events.
//		Only called in state s_Alert.\
//
// Input
//		deltaTime : 
// 
//------------------------------------------------------------------------
function MonitorAlertState(float deltaTime)
{
	local EPawn PlayerPawn;
	local float DistanceToPlayer;

	PlayerPawn = eGame.pPlayer.ePawn;

	MonitorTimer += deltaTime;
	if (MonitorTimer > 0.2f)		// every fifth of a second
	{
		// check player distance
		if ((PlayerPawn != none) && (bPlayerSeen))
		{
			AIEvent.Reset();
			DistanceToPlayer = VSize(PlayerPawn.Location - ePawn.Location);
			
			if (DistanceToPlayer > ePawn.GetPlayerFarDistance())
			{
				if (LastAlertMonitorEventType != AI_PLAYER_FAR)
					AIEvent.EventType			= AI_PLAYER_FAR;
			}
			else if (DistanceToPlayer < ePawn.PlayerVeryCloseDistance)
			{
				if (LastAlertMonitorEventType != AI_PLAYER_VERYCLOSE) 
					AIEvent.EventType			= AI_PLAYER_VERYCLOSE;
			}
			else if (DistanceToPlayer < ePawn.GetPlayerFarDistance() - 100.f)
			{
				if (LastAlertMonitorEventType != AI_PLAYER_CLOSE) 
					AIEvent.EventType			= AI_PLAYER_CLOSE;
			}

			if (AIEvent.EventType > AI_NONE)
			{
				AIEvent.EventTarget		  = PlayerPawn;
				LastAlertMonitorEventType = AIEvent.EventType;
				Group.AIEventCallBack(self, AIEvent);
			}
		}

		MonitorTimer = 0.0f;	// reset timer
	}
}


//---------------------------------------[ Alain Turcotte @ 25 avr. 2001 ]-
// Prototype		PlayerCalcEye
// 
// Description		Calc view for all Type of goggles
//		
// DAK--NOTE this function is duplicated in EPlayerController
// TODO:  if we ever have EController, move this there...
//------------------------------------------------------------------------

event PlayerCalcEye(out vector EyeLocation, out rotator EyeRotation)
{
	local vector X,Y,Z;

	EyeLocation = ePawn.GetBoneCoords(ePawn.EyeBoneName).Origin;
	
	// if get bone coords returns null vector, character is off screen
	if (EyeLocation == vect(0,0,0))
	{
		// position and rotate according to pawn location
		EyeLocation = ePawn.Location; // + vect(0,0, ePawn.CollisionHeight * 0.8);
		EyeRotation = ePawn.Rotation;
	}
	else
	{
		// bone locations are valid - get the bone rotation
		EyeRotation = ePawn.GetBoneRotation(ePawn.EyeBoneName);
		GetAxes(EyeRotation, X, Y, Z);
		EyeRotation = Rotator(Y);
	}
}

//---------------------------------------[Frederic Blais - 10 Dec 2001]-----
// 
//------------------------------------------------------------------------

event SetGrenadeTime(float Time)
{
	ePawn.HandItem.ExplodeTimer = Time;
}

//----------------------------------------[David Kalina - 9 Apr 2001]-----
// 
// Description
//		Returns the position at which we are aiming.
//
//------------------------------------------------------------------------

function vector GetTargetPosition()
{
	return TargetPosition;
}

//------------------------------------------------------------------------
// Description
//		Modify accuracy to be continued ...
//------------------------------------------------------------------------
function Vector AdjustTarget(Vector ShotDirection)
{
	local Rotator AdjustedAim;
	local float DistanceModifier;
	local float	AccuracyResult,VisFact;

	AdjustedAim = Rotator(ShotDirection);

	//In our case 10 meters is the MinAccuracyDistance 
	if (VSize(ShotDirection) > 1000)
	{
		DistanceModifier = 65536 / Pi * ATan(1000 * Tan(500 / 65536 * 2 * Pi) / VSize(ShotDirection));
	}
	else
		DistanceModifier = 1000;

	//consider alarm stages
	AccuracyResult  = ePawn.AccuracyDeviation * EchelonLevelInfo(Level).AlarmModifier[EchelonLevelInfo(Level).AlarmStage];

	//consider visibility of the target
	if (TargetActorToFire == eGame.pPlayer.Pawn)
	{
		VisFact = Clamp(eGame.pPlayer.Pawn.GetVisibilityFactor(), 0.f, 60.0f);

		AccuracyResult *=  (1.0f + (60.0f - VisFact) / 60.0f); 
	}

	//consider the level of difficulty-FBLAIS
	if (EchelonGameInfo(Level.Game).pPlayer.playerInfo.difficulty > 0)
	{
		AccuracyResult *= 0.50f;
	}

	// -0.5 to get it varying from -0.5 to 0.5
	AdjustedAim.Yaw	+=  AccuracyResult * ((FRand() * 0.6f) -0.3f) * DistanceModifier ;
	AdjustedAim.Pitch	+=  AccuracyResult * ((FRand() * 0.6f) - 0.3f) * DistanceModifier;


	return Vector(AdjustedAim);
}



//---------------------------------------[David Kalina - 26 Jun 2001]-----
// 
// Description
//		Checks current goal in list for GoalLocation - if we have 
//		reached that destination, return true.
//
//------------------------------------------------------------------------

function bool ReachedCurrentGoalLocation()
{
	local EGoal goal;
	local float dist;

	goal = m_pGoalList.GetCurrent();

	if (goal.GoalLocation != vect(0,0,0))
	{
		dist = VSize(goal.GoalLocation - ePawn.Location);

		if (dist < 100.0f)
		{
			if (ePawn.IsWaiting())
				return true;
		}

		return false;
	}

	return true;   // no goal location, can't hold it against us
}


//---------------------------------------[David Kalina - 26 Jun 2001]-----
// 
// Description
//		Directly modify current attack goal.
//
//		This is intended for MINOR adjustments to the goal location
//		and is not the same as ChooseAttackPoint which is native 
//		and more thorough.
//
//		Furthermore once we call this function we will not allow the
//		goal location to be modified again until we have reached
//		our new adjusted location.
//
// Output
//		function : 
// 
// PreConditions
//		Must be in an attack goal!
// 
// PostConditions
//		None
// 
//------------------------------------------------------------------------

function AdjustAttackLocation()
{
	local EGoal goal;
	local Actor Target;
	local vector widthLeft, widthRight, vFloorLocation, vDesiredLocation, vEndPoint, vTemp;
	local float temp;

	goal = m_pGoalList.GetCurrent();

	// OK -- FUCK, THIS DOESN'T MAKE ANY SENSE...
	if (ReachedCurrentGoalLocation())
	{
		Target = goal.GoalTarget;

		if (Target != none)
		{
			// check extents to target so weapon has room to operate
			WidthLeft  = ((vect(0,-1,0) >> ePawn.Rotation) * (ePawn.CollisionRadius + 5.0));
			WidthRight = ((vect(0, 1,0) >> ePawn.Rotation) * (ePawn.CollisionRadius + 5.0));

			if (FastTrace(Target.Location + widthLeft, ePawn.Location + WidthLeft))
			{
				// not obstructed to the left, move that way

				vDesiredLocation = ePawn.Location + (widthLeft * 2);	

				// get floor location at specified location
				temp = ePawn.CollisionHeight + 40.0;
				vEndPoint = vDesiredLocation;
				vEndPoint.Z -= temp;

				if (Trace(vFloorLocation, vTemp, vEndPoint, vDesiredLocation) != None)
					goal.GoalLocation = vDesiredLocation;
			}


			else if (FastTrace(Target.Location + widthRight, ePawn.Location + WidthRight))
			{
				// obstructed to the right, move that way
				
				vDesiredLocation = ePawn.Location + (widthRight * 2);  // change to Target.Location for more aggressive behavior

				temp = ePawn.CollisionHeight + 40.0;
				vEndPoint = vDesiredLocation;
				vEndPoint.Z -= temp;

				if (Trace(vFloorLocation, vTemp, vEndPoint, vDesiredLocation) != None)
					goal.GoalLocation = vDesiredLocation;
			}
		}
	}
}



//----------------------------------------[David Kalina - 6 Jan 2002]-----
// 
// Description
//		Event called when Pawn movement first begins.
// 
//------------------------------------------------------------------------

event StartedMoving()
{
	if (!bIsMoving)
	{
		bIsMoving = true;
		UpdateFocusSwitching(ePawn.BaseMoveFlags);
	}
}


//----------------------------------------[David Kalina - 6 Jan 2002]-----
// 
// Description
//		Event called when Pawn movement stops (StopMovement called).
// 
//------------------------------------------------------------------------

event StoppedMoving()
{
	if (bIsMoving)
	{
		bIsMoving = false;
		UpdateFocusSwitching(ePawn.BaseMoveFlags);
	}
}

//---------------------------------------[David Kalina - 28 Feb 2002]-----
// 
// Description
//		How long before we update our personality anim?
// 
//------------------------------------------------------------------------

event float GetPersonalityUpdateTime()
{
	if (PersonalityUpdateTime > 0.0f)
		return PersonalityUpdateTime;

	PersonalityUpdateTime = RandRange(ePawn.PrsoUpdate_DefaultMin, ePawn.PrsoUpdate_DefaultMax);   

	return PersonalityUpdateTime;
}


//----------------------------------------[David Kalina - 2 Mar 2002]-----
// 
// Description
//		Return the laziness factor for focus switching.  
// 
//------------------------------------------------------------------------

event float GetLaziness()
{
	return ePawn.Laziness_DefaultState;
}

//----------------------------------------[David Kalina - 6 Jan 2002]-----
// 
// Description
//		Set FocusInfo properties based on current moveflags and if we are currently moving.
// 
//------------------------------------------------------------------------

function UpdateFocusSwitching(MoveFlags CurMoveFlags)
{
	switch (CurMoveFlags)
	{
		case MOVE_WalkNormal : 
		case MOVE_Search :

			if (bIsMoving)
			{
				// Walk - AWARE
				
				FocusInfo.MinTurnSpeed		= 1.25f;
				FocusInfo.MaxTurnSpeed		= 2.0f;
				FocusInfo.YawMinOffset		= 7000;
				FocusInfo.YawMaxOffset		= 10000;
				FocusInfo.SwitchTimeBase	= 1.2f;
				FocusInfo.SwitchTimeOffset	= 0.75f;
			}
			else
			{
				// Wait - AWARE
								
				FocusInfo.MinTurnSpeed		= 0.65f;
				FocusInfo.MaxTurnSpeed		= 1.5f;
				FocusInfo.YawMinOffset		= 4500;
				FocusInfo.YawMaxOffset		= 9000;
				FocusInfo.SwitchTimeBase	= 2.0f;
				FocusInfo.SwitchTimeOffset	= 1.0f;
			}


			break;

		case MOVE_WalkAlert :
		case MOVE_JogAlert :
			
			if (bIsMoving)
			{
				// Walk - ALERT
				
				FocusInfo.MinTurnSpeed		= 1.25f;
				FocusInfo.MaxTurnSpeed		= 2.25f;
				FocusInfo.YawMinOffset		= 7500;
				FocusInfo.YawMaxOffset		= 11000;
				FocusInfo.SwitchTimeBase	= 1.2f;
				FocusInfo.SwitchTimeOffset	= 0.75f;
			}
			else
			{
				// Wait - ALERT
				
				FocusInfo.MinTurnSpeed		= 0.75f;
				FocusInfo.MaxTurnSpeed		= 1.85f;
				FocusInfo.YawMinOffset		= 6000;
				FocusInfo.YawMaxOffset		= 12000;
				FocusInfo.SwitchTimeBase	= 1.5f;
				FocusInfo.SwitchTimeOffset	= 2.0f;
			}

			break;
	}
}

//-----------------------------------[Matthew Clarke - June 4th 2002]-----
// 
// Description
//		Returns whether our Target is currently firing
//      Called by CheckForCoverAttack to peek out only when target is NOT firing
// 
//------------------------------------------------------------------------
event bool TargetIsFiring()
{
    local EPlayerController EPC;
    local EWallSpark        EWS;
    local int               i;

    EPC = eGame.pPlayer;

    if (EPC != None)
    {
        for (i = 0; i < EPC.LatestHits.Length; i++)
        {
            if ((abs(EPC.LatestHits[i].Time - Level.TimeSeconds) < 0.3)
                && ((VSize(EPC.LatestHits[i].Location - ePawn.Location)) < 300.0))
            {
                return true;
            }
        }

    }

    // If no recent hit was close, we presume Sam is not firing at us
    return false;
}

//-----------------------------------[Matthew Clarke - June 5th 2002]-----
// 
// Description
//  When an NPC dies using a strategic point, remove that strategic point
//  from the EVolume so no one uses that strategic point again        
// 
//------------------------------------------------------------------------
function RemoveStrategicPointFromVolume()
{
    local int i;

    // Make sure we were using a Strategic point
    if ((TakenPoint == None) || (Pattern.CurrentVolume == None))
    {
        return;
    }

    // Go through all Strategic points for this volume
    for (i = 0; i < Pattern.CurrentVolume.StrategicPoints.Length; i++)
	{
        // If the strategic point matches where we were standing
        if (Pattern.CurrentVolume.StrategicPoints[i] == TakenPoint)
        {
            // Remove point from array
            Pattern.CurrentVolume.StrategicPoints.Remove(i, 1);
            return;
        }
    }
}

//-----------------------------------[Matthew Clarke - July 31st 2002]-----
// 
// Description       
// 
//------------------------------------------------------------------------
function RemoveReferencesInPatrolInfo()
{
    local NavigationPoint Nav;

	for (Nav = Level.NavigationPointList; Nav != none; Nav = Nav.nextNavigationPoint)
	{
        if ((Nav.Patrol != None) && (Nav.Patrol.m_waitingController == self))
        {
            //log("Removing reference in"@Nav@Nav.Patrol);
            Nav.Patrol.m_waitingController = None;
        }
	}
}

/***************************************************************************************************
 ******			GOAL PROCESSING                *****************************************************
 ****

	Evaluate / Execute Goals according to GEEP (the Goal Evaluation and Execution Protocol)

																							********
     ***********************************************************************************************
***************************************************************************************************/



//---------------------------------------[David Kalina - 22 Aug 2001]-----
// 
// Description
//		Wander between NavigationPoints within a certain radius from a Target
// 
// Input
//		name GoalTag		OPTIONAL:  Used to select GoalTarget.  TempNavPoint spawned if not specified.
//		Actor GoalTarget	The location around which we center our wandering behavior.
//		float GoalValue		Maximum Distance from GoalTarget within which we might choose a Wander point.
//		vector GoalFocus	INTERNAL : Will always be chosen in random direction from current location, about a meter in front.
//		name GoalAnim		OPTIONAL:  Animation played at random points in the Guard execution.
//		Sound GoalSound		OPTIONAL:  Sound that corresponds to randomly chosen animation.
//
//------------------------------------------------------------------------

event EchelonEnums.GoalStatus ExecGoal_Wander(float deltaTime, EGoal goal)
{
	local NavigationPoint	tempNav;
	local int				counter;
	local rotator			RandomRotation;

	// initialize
	if (!goal.bInitialized)
	{
		// set wander center point (target)
		if (Goal.GoalTag != '' && Goal.GoalTarget == none)
			Goal.GoalTarget = GetMatchingActor(goal.GoalTag);

		if (goal.GoalTarget == none)
			Goal.GoalTarget = spawn(class'EDynamicNavPoint', self, 'AutoWanderTag', Destination);

		goal.GoalLocation = goal.GoalTarget.Location;

		if (goal.GoalValue == 0.0f)
			goal.GoalValue = 1000.0f;

		if (goal.GoalWaitFlags == MOVE_NotSpecified)
			goal.GoalWaitFlags = goal.GoalMoveFlags;
		
		// count number of navigation points might be used
		NumWanderPoints = 0;
		foreach RadiusActors(class'NavigationPoint', tempNav, goal.GoalValue, goal.GoalTarget.Location)
		{
			//log("WANDER NAV POINT #" $ NumWanderPoints @ " : " $ tempNav @ tempNav.Tag);
			NumWanderPoints++;
		}

		InternalGoalTimer = 0.0;
		goal.GoalTimer    = FocusInfo.SwitchTimeBase + (FRand() * FocusInfo.SwitchTimeOffset);
		
		goal.bInitialized = true;
	}


	// check timer for location switch		
	
	if (InternalGoalTimer > goal.GoalTimer)		// timer exceeded random value
	{
		// reset focus temporarily
		goal.GoalFocus = vect(0,0,0);

		// choose random nav point as goal location

		counter = rand(NumWanderPoints);

		foreach RadiusActors(class'NavigationPoint', tempNav, goal.GoalValue, goal.GoalTarget.Location)
		{
			counter--;

			if (counter == 0)
			{
				//log("WANDER choosing nav point : " $ tempNav);
				goal.GoalLocation = tempNav.Location;
				break;
			}
		}

		// only if point chosen.  don't understand why it don't work 100% of the time.
		// anyways, if we don't get one this frame, we'll surely get one next frame.
		if (tempNav != none) 
		{
			// choose entirely random yaw to use for our focus, unless specified by PatrolInfo
			if (tempNav.Patrol != none)
			{
				// apply patrol info focus
				if (tempNav.Patrol.m_FocusTag != '')
					goal.GoalFocus = GetMatchingActor(tempNav.Patrol.m_FocusTag).Location;
				
				if (tempNav.Patrol.m_rSleepTime > 0.0f)
					goal.GoalTimer = tempNav.Patrol.m_rSleepTime;
			}
		}

		// always set new focus randomly if not previously set
		if (goal.GoalFocus == vect(0,0,0))
		{
			RandomRotation.Yaw   = rand(32768) * 2;
			RandomRotation.Pitch = 0;
			RandomRotation.Roll  = 0;

			//log(" random focus : " $ RandomRotation);
				
			// offset new focus from location
			// we will walk to location facing it, and when we get there, we will turn
			goal.GoalFocus = goal.GoalLocation + (vector(RandomRotation) * 100.0f);
		}
		

		// set timer
		InternalGoalTimer = 0.0f;
		if (goal.GoalTimer == 0.0f)
			goal.GoalTimer = FocusInfo.SwitchTimeBase + (FRand() * FocusInfo.SwitchTimeOffset);
	
	} 
	
	// move dammit
	
	switch (SubGoal_NavigateTo(goal.GoalLocation, Goal.GoalMoveFlags))
	{
		case GS_Complete : 
		case GS_Failure : 
			InternalGoalTimer += deltaTime;
			StopMovement(goal.GoalFocus, goal.GoalWaitFlags);
			return GS_Executing;

		case GS_Executing :
			return GS_Executing;
	}
}

//---------------------------------------[David Kalina - 31 Aug 2001]-----
// 
// Description
//		Quick Search - check out specified GoalLocation, but don't go
//		any further.
//
// Input
//		GoalTarget		Optional Actor to specify Goal Location
//		GoalLocation	This goal complete's when GoalLocation is visible
//		GoalSound		Optional Initial Sound
//		GoalAnim		Optional Initial Anim to Blend Over Upper Body
//		GoalValue		Distance from GoalLocation we must be within to complete
//
// Output
//		EchelonEnums.GoalStatus : 
//			GS_Complete		See GoalLocation, Nothing There
//							Or GoalLocation is reached / not reachable
//			GS_Executing	What it say
//			
//------------------------------------------------------------------------

event EchelonEnums.GoalStatus ExecGoal_QuickSearch(float deltaTime, EGoal goal)
{
	/****  GOAL INITIALIZATION  ****/

	if (!goal.bInitialized)
	{

		// get target from tag
		if (goal.GoalTarget == none)
			goal.GoalTarget = GetMatchingActor(goal.GoalTag);
		
		// if target specified, take its location 
		if (goal.GoalTarget != none)
			goal.GoalLocation = goal.GoalTarget.Location;

		// play initial sound if it exists
		if (goal.GoalSound != none)
			ePawn.PlaySound(goal.GoalSound, SLOT_SFX); // play sound from pawn

		// play initial anim if it exists
		if (goal.GoalAnim != '')
			ePawn.BlendAnimOverCurrent(goal.GoalAnim,0.5,'B Spine2',,0.2);	

		if (goal.GoalValue == 0.0f)
			goal.GoalValue = 800.0f;		// TODO : add var QuickSearchVisibilityDistance??  

		InternalGoalTimer = 0.0f;

		goal.bInitialized = true;			// goal initialized
	}


	/****  GOAL EXECUTION  ****/
	
	InternalGoalTimer += deltaTime;

	switch (SubGoal_NavigateTo(goal.GoalLocation, Goal.GoalMoveFlags))
	{
		case GS_Complete:  
		case GS_Failure:   
	
			// we either have reached the final destination (which should not happen unless goalvalue is very small)
			// or we can't reach the GoalLocation - since this is a non-critical goal, just return complete and pop

			return GS_Complete;   

		case GS_Executing: 

			// check visibility of location every quarter second

			if (InternalGoalTimer > 0.25f)
			{
				// return complete if within range and point is visible
				if (VSize(goal.GoalLocation - ePawn.Location) < goal.GoalValue)
				{
					if (FastTrace(goal.GoalLocation, ePawn.Location))
						return GS_Complete;
				}
			}

			return GS_Executing;
	}
}





//---------------------------------------[David Kalina - 28 Sep 2001]-----
// 
// Description
//		Event for telling the patrol network to turn around.
// 
//------------------------------------------------------------------------

event SubGoal_PatrolTurnAround()
{
	//plog("Subgoal_PatrolTurnAround");

	SpecialMoveDoor  = none;
	
	m_pNextPatrolPoint.ReverseDirection();
	m_pNextPatrolPoint = m_pNextPatrolPoint.GetNext();
}





//---------------------------------------[Frederic Blais - 17 Jul 2001]---
//------------------------------------------------------------------------
event EchelonEnums.GoalType  GetCurrentGoalType()
{
	local EGoal goal;

	goal = m_pGoalList.GetCurrent();

	return (goal.m_GoalType);
}



//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Generic function for creating a goal and adding it to the list.
//
// 
//------------------------------------------------------------------------

event AddGoal(EchelonEnums.GoalType					_Type, 
				 byte								_Priority,
				 optional Vector					_Location,
				 optional Vector					_Focus,
				 optional Actor						_Target,
				 optional Name						_Tag,
				 optional Name						_Anim,
				 optional Sound						_Sounds,
				 optional bool						_Flag,
				 optional float						_Value,
				 optional MoveFlags					_MoveFlags,
				 optional Vector					_Direction,
				 optional MoveFlags					_WaitFlags,
				 optional bool						_UpdatePlayerPos,
				 optional name						_AnimB)
{
	local EGoal goal;	
	

	if (bNotResponsive && GetStateName() != 's_stunned')
		return;


	//if (pawn.Health > 0)
	//{
		goal = Spawn(class'EGoal');  // new class'EGoal';

		goal.Clear();										// initialize

		goal.m_GoalType		= _Type;						// set its Type
		goal.priority		= _Priority;					// set its priority

		goal.GoalLocation	= _Location;					// set its location
		goal.GoalFocus		= _Focus;						// set its focus
		goal.GoalTarget		= _Target;						// set its target
		goal.GoalTag		= _Tag;							// set its tag
		goal.GoalAnim		= _Anim;						// set its anim
		goal.GoalAnimB		= _AnimB;						// set its anim
		goal.GoalFlag		= _Flag;						// set its flag
		goal.GoalValue		= _Value;						// set its value
		goal.GoalSound		= _Sounds;						// choose sound from array
		goal.GoalMoveFlags  = _MoveFlags;					// your mom
		goal.GoalWaitFlags  = _WaitFlags;					// your grammy
		goal.GoalDirection	= _Direction;					// your dad

		goal.GoalUpdatePlayerPos = _UpdatePlayerPos;

		// i am comment-happy
		m_pGoalList.Insert(goal);							// add goal to list
	//}
	}

event SetDefaultGuard()
{
	ReplaceDefaultGoal(GOAL_Guard,0,ePawn.Location);
}
//---------------------------------------[Frederic Blais]------------
// 
// ReplaceDefaultGoal
//
//-------------------------------------------------------------------
event ReplaceDefaultGoal(EchelonEnums.GoalType				_Type, 
				 byte								_Priority,
				 optional Vector					_Location,
				 optional Vector					_Focus,
				 optional Actor						_Target,
				 optional Name						_Tag,
				 optional Name						_Anim,
				 optional Sound						_Sounds,
				 optional bool						_Flag,
				 optional float						_Value,
				 optional MoveFlags					_MoveFlags,
				 optional Vector					_Direction,
				 optional MoveFlags					_WaitFlags)

{
	local EGoal goal;	
	
	if (pawn.Health > 0)
	{
		goal = Spawn(class'EGoal');  // new class'EGoal';

		goal.Clear();										// initialize

		goal.m_GoalType		= _Type;						// set its Type
		goal.priority		= _Priority;					// set its priority

		goal.GoalLocation	= _Location;					// set its location
		goal.GoalFocus		= _Focus;						// set its focus
		goal.GoalTarget		= _Target;						// set its target
		goal.GoalTag		= _Tag;							// set its tag
		goal.GoalAnim		= _Anim;						// set its anim
		goal.GoalFlag		= _Flag;						// set its flag
		goal.GoalValue		= _Value;						// set its value
		goal.GoalSound		= _Sounds;						// choose sound from array
		goal.GoalMoveFlags  = _MoveFlags;					// your mom
		goal.GoalWaitFlags  = _WaitFlags;					// your grammy
		goal.GoalDirection	= _Direction;					// your dad
		

		m_pGoalList.ReplaceDefaultGoal(goal);				//Replace the end of the list
	}
}

//---------------------------------------[Frederic Blais]------------
// 
// AddGoalDirect
//
//-------------------------------------------------------------------
event AddGoalDirect(EGoal G)
{	
	if (pawn.Health > 0)
		m_pGoalList.Insert(G);
}

//---------------------------------------[Frederic Blais]------------
// 
// ReplaceGoal
//
//-------------------------------------------------------------------
event ReplaceGoal(EGoal G)
{
	m_pGoalList.Replace(G);
}

//-------------------------------[Matthew Clarke - July 15th 2002]---
// 
// TimeoutHidePoint
//
//-------------------------------------------------------------------
event TimeoutHidePoint(NavigationPoint oNP, optional float fTime)
{
    local SNavPointTimeout SNPT;

	if ((oNP == None) || (IsTimedOut(oNP)))
    {
        //log("Can't disable hide point"@ oNP);
        return;
    }

    if (fTime == 0.0f)
    {
        fTime = 10.0f;
    }

//    oNP.bHidePoint = false;

    SNPT.oPoint = oNP;
    SNPT.fReenableTime = Level.Level.TimeSeconds + fTime;

    NavPointsTimedOut[NavPointsTimedOut.Length] = SNPT;

    //log("TimingOut " $ oNP $ " for " $ fTime@"seconds");
    //log("NavPointsTimedOut.Length =  " $ NavPointsTimedOut.Length);
}

//-------------------------------[Matthew Clarke - July 15th 2002]---
// 
// CheckHidePoints
//
//-------------------------------------------------------------------
event CheckHidePoints()
{
    local int i;

    if (NavPointsTimedOut.Length < 1)
    {
        return;    
    }

    for (i = 0; i < NavPointsTimedOut.Length; i++)
    {
        // It's time to remove this one
        if (NavPointsTimedOut[i].fReenableTime < Level.Level.TimeSeconds)
        {
            //log("Reenabling " $  NavPointsTimedOut[i].oPoint);
            /*NavPointsTimedOut[i].oPoint.bHidePoint = true;*/
            NavPointsTimedOut.Remove(i, 1);

            // Do not remove more than one at once
            return;
        }
    }
}

//-------------------------------[Matthew Clarke - July 23th 2002]---
// 
// IsTimedOut
//
//-------------------------------------------------------------------
event bool IsTimedOut(NavigationPoint oNP)
{
    local int i;

    for (i = 0; i < NavPointsTimedOut.Length; i++)
    {
        if (NavPointsTimedOut[i].oPoint == oNP)
        {
            return true;
        }
    }

    return false;
}

//---------------------------[Matthew Clarke - September 3rd 2002]---
// 
// Description
//  Show the player we mean business :
//      Wait 2 seconds, then fire two seconds
//
//-------------------------------------------------------------------
function TimedForceFire()
{  
    bTimedForceFire = false;
    SetTimer(2.0f, false); // Wait 2 seconds before starting to fire
}

//---------------------------[Matthew Clarke - September 3rd 2002]---
// 
// Timer, used in conjunction with TimedForceFire
//
//-------------------------------------------------------------------
function Timer()
{
    if (bTimedForceFire)
    {
        //log("Hold fire");
        bTimedForceFire = false;
    }
    else
    {
        //log("Start firing!");
        bTimedForceFire = true;
        SetTimer(2.0f, false); // Wait 2 seconds before stopping
    }
        
}




/***************************************************************************************************
 ******			AWARENESS STATES	           *****************************************************
 ****

	s_Init			performs some initial AI setup and switches to designer specified default state
	s_Default		default state, weapon away, no focus switching / aiming
	s_Investigate	aware state, gun out but not ready
	s_Alert			alert state, gun ready to fire -- SeePlayer redefined

																							********
     ***********************************************************************************************
***************************************************************************************************/



//----------------------------------------[David Kalina - 7 Mar 2001]-----
// 
// Description
//      Init State
//      First state triggered, but only after this controller has 
//      possessed a Pawn.  
//
//		NOTE : We set the Initial State of the EPawn b/c the SetDefaultState()
//		event may not have been called yet.
// 
//------------------------------------------------------------------------

state s_Init
{
    function BeginState()
    {
		ePawn.SelectWeapon(true);								// WEAPON SELECTION -- initialization, place weapon immediately in hand
        SetupInitialGoal();										// setup initial goal based on EPawn des vars
	    FindGroup();											// find our group 
		ePawn.InitAnims();


		switch (ePawn.InitialAIState)
		{
			case EAIS_Default : 
				GotoStateSafe('s_Default');		
				break;

			case EAIS_Aware :   
				GotoStateSafe('s_Investigate');	
				break;

			case EAIS_Alert :   
				GotoStateSafe('s_Alert');		
				break;

			case EAIS_Dead :
				
				if (!ePawn.bScriptInitialized)
					ePawn.InitialState = 's_InitiallyDead';
				else
					ePawn.GotoState('s_InitiallyDead');

				GotoStateSafe('s_Dead');
				break;

			case EAIS_Unconscious :
				
				if (!ePawn.bScriptInitialized)
					ePawn.InitialState = 's_InitiallyUnconscious';
				else
					ePawn.GotoState('s_InitiallyUnconscious');

				GotoStateSafe('s_Unconscious');
				break;
		}
    }
}



//----------------------------------------[David Kalina - 7 Mar 2001]-----
// 
// Description
//      Default State
//
//		Initial state, behavior specified by designer set Goal.
//
//      Implies that no behaviors have been set for the NPC
//      so we will stand our ground.  Nevertheless we must respond 
//      to situations changing in our environment:
//          Seeing the player
//          Seeing something unexpected
//          Hearing a noise
// 
//------------------------------------------------------------------------

state s_Default
{
	function BeginState() {}


	function Tick (float deltaTime)
	{
		if (Group != none)
		{
			switch (ExecuteCurrentGoal())
			{
				case GS_Executing :

					// keep on merrily executing
					break;

				case GS_Complete : 

					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_COMPLETE;
					Group.AIEventCallBack(self, AIEvent);
					break;

				case GS_Failure : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_FAILURE;
					Group.AIEventCallBack(self, AIEvent);
					break;
			}
		}
	}


	//----------------------------------------[David Kalina - 2 Oct 2001]-----
	// 
	// Description
	//		Must now send LOST_PLAYER events from all states. 
	// 
	//------------------------------------------------------------------------
	
    event EnemyNotVisible()
    {
		local EPawn PlayerPawn;
		
		PlayerPawn = eGame.pPlayer.ePawn;
		
		if (bPlayerSeen)
		{
			UpdatePlayerLocation(PlayerPawn, false);

			if (PlayerPawn != none && PlayerPawn.Health > 0)
			{
				AIEvent.Reset();
				AIEvent.EventType	  = AI_LOST_PLAYER;
				AIEvent.EventLocation = PlayerPawn.Location;		// Yowsah!
				AIEvent.EventTarget	  = PlayerPawn;
				Group.AIEventCallBack(self, AIEvent);
			}
		}
		else
		{
			UpdatePlayerLocation(PlayerPawn, false);			// update last known position based on intuition 
		}
	}


    function EndState()
    {
        m_LastStateName = GetStateName();
    }
	
begin:
	//    Log("ECHELON NPC -- DEFAULT STATE BEGIN");
	//	Log("ECHELON NPC -- DEFAULT STATE USING GOAL TYPE : " $ m_pGoalList.GetCurrent().m_GoalType);
}




//----------------------------------------[David Kalina - 7 Mar 2001]-----
// 
// Description
// 
//------------------------------------------------------------------------

state s_Investigate
{
	function BeginState() 
	{
		ePawn.InitialAIState = EAIS_Aware;

		ePawn.StopAllVoicesActor(false, true);
	}

	
	//---------------------------------------[David Kalina - 13 Apr 2001]-----
	// 
	// Description
	//		Execute Current Goal
	// 
	//------------------------------------------------------------------------
	
	function Tick(float deltaTime)
	{
		if (Group != none)
		{
			switch (ExecuteCurrentGoal())
			{
				case GS_Executing :
					// keep on merrily executing
					break;
					
				case GS_Complete : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_COMPLETE;
					Group.AIEventCallBack(self, AIEvent);
					break;
					
				case GS_Failure : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_FAILURE;
					Group.AIEventCallBack(self, AIEvent);
					break;
			}
		}
	}
	
	
	//----------------------------------------[David Kalina - 2 Oct 2001]-----
	// 
	// Description
	//		Must now send LOST_PLAYER events from all states. 
	// 
	//------------------------------------------------------------------------
	
	event EnemyNotVisible()
    {
		local EPawn PlayerPawn;
		
		PlayerPawn = eGame.pPlayer.ePawn;
		
		if (bPlayerSeen)
		{

			UpdatePlayerLocation(PlayerPawn, false);

			if (PlayerPawn != none && PlayerPawn.Health > 0)
			{
				AIEvent.Reset();
				AIEvent.EventType	  = AI_LOST_PLAYER;
				AIEvent.EventLocation = PlayerPawn.Location;		// Yowsah!
				AIEvent.EventTarget	  = PlayerPawn;
				Group.AIEventCallBack(self, AIEvent);
			}
		}
		else
		{
			UpdatePlayerLocation(PlayerPawn, false);			// update last known position based on intuition 
		}
	}

	
	event float GetPersonalityUpdateTime()
	{
		if (PersonalityUpdateTime > 0.0f)
			return PersonalityUpdateTime;

		PersonalityUpdateTime = RandRange(ePawn.PrsoUpdate_AwareMin, ePawn.PrsoUpdate_AwareMax);   

		return PersonalityUpdateTime;
	}

	event float GetLaziness()
	{
		return ePawn.Laziness_AwareState;
	}

	event int GetTurnSpeed() 
	{
		return (ePawn.TurnSpeed_Aware);
	}

	event float GetMaximumAimAngle()
	{
		return ePawn.MaxAimAngle_Aware;
	}

    function EndState()
    {
        m_LastStateName = GetStateName();
    }
}




//----------------------------------------[David Kalina - 7 Mar 2001]-----
// 
// Description
// 
//------------------------------------------------------------------------

state s_Alert
{
	
	function Tick(float deltaTime)
	{
		if (Group != none)
		{
			// check for alert-state-related events to send to group
			MonitorAlertState(deltaTime);	

			switch (ExecuteCurrentGoal())
			{
				case GS_Executing :
					// keep on merrily executing
					break;
					
				case GS_Complete : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_COMPLETE;
					Group.AIEventCallBack(self, AIEvent);
					break;
					
				case GS_Failure : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_FAILURE;
					Group.AIEventCallBack(self, AIEvent);
					break;
			}
		}

		//adjust the transition table (the sniper tables will be Hardcoded)
		if (ePawn.bSniper)
		{
			//check if the pawn is moving
			if (ePawn.Velocity != vect(0,0,0))
			{
				ePawn.m_VisibilityMaxDistance = 1800;

				ePawn.VisTable_Alert[0] = 0.000000;
				ePawn.VisTable_Alert[1] = 400.000000;
				ePawn.VisTable_Alert[2] = 700.000000;
				ePawn.VisTable_Alert[3] = 1000.000000;
				ePawn.VisTable_Alert[4] = 1300.000000;

				ePawn.m_VisibilityConeAngle = 55.50000;

			}
			else
			{
				ePawn.m_VisibilityMaxDistance = 4000;

				ePawn.VisTable_Alert[0] = 0.000000;
				ePawn.VisTable_Alert[1] = 3000.000000;
				ePawn.VisTable_Alert[2] = 3300.000000;
				ePawn.VisTable_Alert[3] = 3600.000000;
				ePawn.VisTable_Alert[4] = 4000.000000;

				ePawn.m_VisibilityConeAngle = 50.000000;

			}
		}
	}
		


	//---------------------------------------[David Kalina - 14 Nov 2001]-----
	// 
	// Description
	//		s_Alert has unique SeePlayer definition because most checks
	//		become unnecessary once the player has been noticed.
	//
	//		Also, some special case stuff for when the player has been
	//		recently seen.
	// 
	//------------------------------------------------------------------------

	event SeePlayer(Pawn SeenPlayer)
    {
		local int				i;
		local float				Distance;
		
		bIsAboutToLostThePlayer = false;

		// only send message to group if SeenPlayer is alive
		if (SeenPlayer != none)
		{			
			if (SeenPlayer.bHidden)
				return;

			if (SeenPlayer.Health > 0)
			{
				// obtain player distance
				Distance = VSize(SeenPlayer.Location - ePawn.Location);

				// no need to check transition table when in alert state
				//Log("S_ALERT : Is Player Seen  ---  bPlayerSeen"  @ bPlayerSeen);
				if (!bPlayerSeen)
				{
					// VISIBILITY DETECTION IS AUTOMATIC if it's been less than TimeBeforeLosingPlayer
					// OR if the player is within PlayerCanHideDistance radius
					//log("*** LastKnownPlayerLocation is : "$LastKnownPlayerLocation$" for Pawn: "$pawn);

					if ((LastKnownPlayerTime > 0) && (LastKnownPlayerLocation != vect(0,0,0)) &&
						 (Level.TimeSeconds - LastKnownPlayerTime < ePawn.TimeBeforePlayerCanHide || 
						  VSize(LastKnownPlayerLocation - SeenPlayer.Location) < ePawn.PlayerCanHideDistance))
					{
						pLog("********** S_ALERT automatically setting bPlayerSeen = true -- LastKnownPlayer Time / Location : " $ LastKnownPlayerTime @ LastKnownPlayerLocation);
						
						UpdatePlayerLocation(SeenPlayer, true);
						
						AIEvent.Reset();
						AIEvent.EventType			= AI_SEE_PLAYER_AGAIN;
						AIEvent.EventTarget			= SeenPlayer;

						Group.AIEventCallBack(self, AIEvent);
					}
					else
					{
						// CHECK VISIBILITY via investigative transition table (mirror of code from s_Investigate SeePlayer()) 
						if (ePawn.bUseTransitionTable)
						{
						
							// if player is 'invisible' send see_player_surprised event at close range
							if (SeenPlayer.GetActorVisibility() == VIS_Invisible)
							{
								if (Distance < 180.0f)
								{					
									if ((Normal(SeenPlayer.Location - ePawn.Location) dot vector(ePawn.Rotation)) > 0.85f)
									{
										UpdatePlayerLocation(SeenPlayer, true);

										//Log("S_ALERT See invisible player within 2 meters.");
									
										AIEvent.Reset();
										AIEvent.EventType			= AI_SEE_PLAYER_SURPRISED;
										AIEvent.EventTarget			= SeenPlayer;
										AIEvent.EventLocation		= SeenPlayer.Location;

										Group.AIEventCallBack(self, AIEvent);
									}
								}
							
								return;
							}
						
							switch (CheckTransitionTable(SeenPlayer.GetActorVisibility(), Distance))
							{
							
								case TRAN_None :
									return;

								default : 

									// compose AIEvent message to send to group
									AIEvent.Reset();
										
									UpdatePlayerLocation(SeenPlayer, true);

									AIEvent.EventType			= AI_SEE_PLAYER_ALERT;
									AIEvent.EventTarget			= SeenPlayer;
									AIEvent.EventLocation		= SeenPlayer.Location;

									Group.AIEventCallBack(self, AIEvent);			// send message to group
							}
						}
						else
						{
							// compose AIEvent message to send to group
							AIEvent.Reset();
								
							UpdatePlayerLocation(SeenPlayer, true);

							AIEvent.EventType			= AI_SEE_PLAYER_ALERT;
							AIEvent.EventTarget			= SeenPlayer;
							AIEvent.EventLocation		= SeenPlayer.Location;

							Group.AIEventCallBack(self, AIEvent);			// send message to group
						}
					}
				}
				else
				{

					
					if ((SeenPlayer.GetVisibilityFactor() < 1) && (Distance > 120))
					{
	
						//check the darkness factor
						if (VSize(EPlayerController(SeenPlayer.Controller).LastVisibleLocation - LastKnownPlayerLocation) < 100)
						{
							UpdatePlayerLocation(SeenPlayer, true);		// no table lookup if player already seen
						}
						else
						{
							if ((Level.TimeSeconds - LastKnownPlayerTime) > 10)
								EnemyNotVisible();
							else if ((Level.TimeSeconds - LastKnownPlayerTime) > 5)
								bIsAboutToLostThePlayer = true;

						}
					}
					else
					{

							UpdatePlayerLocation(SeenPlayer, true);		// no table lookup if player already seen
					}
				}
			}
		}
	}


	event EnemyNotVisible()
    {
		local EPawn PlayerPawn;
		
		PlayerPawn = eGame.pPlayer.ePawn;
		
		if (bPlayerSeen)
		{

			UpdatePlayerLocation(PlayerPawn, false);

			if (PlayerPawn != none && PlayerPawn.Health > 0)
			{
				AIEvent.Reset();
				AIEvent.EventType	  = AI_LOST_PLAYER;
				AIEvent.EventLocation = PlayerPawn.Location;		// Yowsah!
				AIEvent.EventTarget	  = PlayerPawn;
				Group.AIEventCallBack(self, AIEvent);
			}
		}
		else
		{
			UpdatePlayerLocation(PlayerPawn, false);			// update last known position based on intuition 
		}
	}

	event bool NotifyBump(Actor Other, optional int Pill)
	{
		plog("1 - NotifyBump in alert...");

		if (Pattern != None)
		{
			if (Pattern.GetStateName() == 'Attack')
				return true;
		}

		plog("2 - NotifyBump in alert...");

		Global.NotifyBump(Other, Pill);

		return true;
	}

	event float GetPersonalityUpdateTime()
	{
		if (PersonalityUpdateTime > 0.0f)
			return PersonalityUpdateTime;

		PersonalityUpdateTime = RandRange(ePawn.PrsoUpdate_AlertMin, ePawn.PrsoUpdate_AlertMax);   

		return PersonalityUpdateTime;
	}

	event float GetLaziness()
	{
		return ePawn.Laziness_AlertState;
	}

	event int GetTurnSpeed() 
	{
		return ePawn.TurnSpeed_Alert;
	}

	event float GetMaximumAimAngle()
	{
		return ePawn.MaxAimAngle_Alert;
	}

	function BeginState()
	{
		ePawn.InitialAIState = EAIS_Alert;

		ePawn.StopAllVoicesActor(false, true);

		if (ePawn.WeaponHandedness > 0 && ePawn.WeaponStance == 0)
		{
			ePawn.Transition_WeaponSelect();
		}
	}

    function EndState()
    {	
		LastAlertMonitorEventType = AI_NONE;
        m_LastStateName = GetStateName();
    }
}



/***************************************************************************************************
 ******			INTERACTIONS / SPECIAL NAVIGATION			****************************************
 ****

	Ladders
	Doors 
	Keypads
	Retinal Scanners
	Chairs
	Unconscious Revival
	Turret Interactions
	Alarm Switches
	Light Switches
	Throwing (Grenades / Flares)
	Placing Wallmines
	Disabling Wallmines	

																							********
     ***********************************************************************************************
***************************************************************************************************/





//----------------------------------------[David Kalina - 6 Feb 2002]-----
// 
// Description
//		Initializes an interaction with the input Actor.
//		Sets the Interaction pointer and relevant ePawn properties.
// 
// Input
//		InteractObject : The actor we wish to interact with.
//
// Output
//		bool : T | Interaction exists.
// 
// PostConditions
//		Interaction will be set to input InteractObject's appropriate Interaction
//		ePawn's parameters will be set according to SetInteractLocation call
//		Must move to m_locationEnd in order to perform interaction.
// 
//------------------------------------------------------------------------

event bool InitInteraction(Actor InteractObject)
{
	Interaction = InteractObject.GetInteraction(ePawn);

	if (Interaction != none)
	{
		// get and set interaction
		
		bStopPersonalityAnim = true;				// disable personality blending
		
		Interaction.SetInteractLocation(ePawn);
		
		log("   InitInteraction:   InteractObject " $ InteractObject $ "   is at location:  " $ InteractObject.Location $ "  Setting interaction location -> " $ ePawn.m_locationEnd,,LPATTERN);

		return true;
	}
	else
		return false;
}


//----------------------------------------[David Kalina - 6 Feb 2002]-----
// 
// Description
//		Calls InitInteract as long as Interaction is still set.
//		Returns false if there is no interaction.
//
// PreConditions
//		Must be reasonably close to desired interact location before calling.
// 
//------------------------------------------------------------------------

event bool BeginInteraction()
{
	if (Interaction != none)
	{
		// setting interaction and initializing (WILL CAUSE CHANGE STATE)
		
		bInteractionActive = true;
		Interaction.InitInteract(self);

		return true;
	}

	return false;
}




//
//
//	L A D D E R S 
//
//	ClimbLadder currently switches AI to s_ClimbLadder  
//	s_ClimbLadderNew was the beginning of an attempt to move the ladder navigation code over to the EPawn
//
//
 

//----------------------------------------[David Kalina - 3 Dec 2001]-----
// 
// Description
//		Should be called when we exit the LadderPoint's collision radius.
// 
//------------------------------------------------------------------------

event UnlockLadder()
{
	local int i, TempID;
	local NavigationPoint nav;

	TempID = CurrentGEID;

	//plog("Unlocking Ladder : " $ CurrentGEID);
	
	if (eGame.ELevel.IsLadderLockedBy(CurrentGEID,Pawn))
		eGame.ELevel.UnlockLadder(CurrentGEID);

	//plog("resetting my ladder info : " $ CurrentGEID);

	// reset my ladder info
	CurrentGEID = -1;
	myLadderLockInfo = 0;
	LadderExitLocation = vect(0,0,0);

	// are we touching another ladder point?  if so, call SetCurrentLadder!
	for (i = 0; i < ePawn.Touching.Length; i++)
	{
		if (ePawn.Touching[i] != none)
		{
			 nav = NavigationPoint(ePawn.Touching[i]);
			 if (nav != none && nav.bLadderPoint && nav.LadderID != TempID)
			 {
				 SetCurrentLadder(nav.LadderID);
				 return;
			 }
		}
	}
}


//----------------------------------------[David Kalina - 3 Dec 2001]-----
// 
// Description
//		Accessor function for setting ladder ID so we don't have 
//		overlapping Ladder points trying to set conflicting ladder IDs.
//------------------------------------------------------------------------

Event SetCurrentLadder(int LadderID)
{
	if (CurrentGEID < 0)
	{
		//plog("Setting CurrentGEID to Ladder ID : " $ LadderID);
		CurrentGEID = LadderID;
	}
}




state s_ClimbLadderNEW
{
	ignores Untouch;
	
	function BeginState()
    {
		local byte Dummy;
	
		FindLadder(Dummy, Dummy);

		bInTransition		= true;					// disable when on the ladder fully

		ePawn.SetPhysics(PHYS_Linear);
		ePawn.Acceleration = vect(0.0, 0.0, 0.0);
    }

    function EndState()
    {
		// reset flags 
		bInTransition		= false;
		
		ePawn.bCollideWorld = true;
		
		ePawn.m_topHanging	= false;
		ePawn.m_topClimbing = false;

		ePawn.Acceleration	= vect(0, 0, 0);
		ePawn.Velocity		= vect(0, 0, 0);
    }
	
	function Tick(float deltaTime)
	{
		if (Group != none)
		{
			switch (ExecuteCurrentGoal())
			{
				case GS_Executing :
					// keep on merrily executing
					break;
					
				case GS_Complete : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_COMPLETE;
					Group.AIEventCallBack(self, AIEvent);
					break;
					
				case GS_Failure : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_FAILURE;
					Group.AIEventCallBack(self, AIEvent);
					break;
			}
		}
	}

	function GotoStateSafe(name State)
	{
		m_LastStateName = State;	// so when we get off the ladder, our state is coherent w/ our groups
	}
	

	//---------------------------------------[David Kalina - 21 Feb 2002]-----
	// 
	// Description
	//		Forward all ClimbLadder() messages to Pawn -- it handles ladder climbing now.
	//
	//------------------------------------------------------------------------

	event ClimbLadder(bool bClimbingUp)
	{	
		if (!bInTransition)
			ePawn.ClimbLadder(bClimbingUp);
	}


// begin climbing down from the top

FromTop:

// begin climbing up from the ground

FromGround:
	//plog("---------------------------------------------------BEGIN CLIMB FromGround   EPAWN LOCATION : " $ ePawn.Location);

	// move to start point for getting on the ladder from the bottom
	
	bInTransition = true;
	bClimbingUp = true;								// set this flag so we don't exit state prematurely upon collision w/ ground
	
	//ePawn.SetLocation(ePawn.m_LocationEnd);
	//log("MOVETO COMPLETE");
	bInTransition = false;
}





//----------------------------------------[David Kalina - 2 Dec 2001]-----
// 
// Description
//		Try to climb nearby Ladder. 
//		Will change state to s_ClimbLadder if acceptable.
//
//------------------------------------------------------------------------

event ClimbLadder(bool bClimbingUp)
{
	local byte bIsBottom, bDummy;
	
	//plog("Calling LockLadder on " $ CurrentGEID $ " in direction : " $ bClimbingUp);
	
	if (bClimbingUp) 
	{
		eGame.ELevel.LockLadder(CurrentGEID, Pawn, true, false, false, false);
		
		GotoState('s_ClimbLadder', 'FromGround');
	}
	else
	{
		eGame.ELevel.LockLadder(CurrentGEID, Pawn, false, true, false, false);
		
		GotoState('s_ClimbLadder', 'FromTop');
	}
}

// ----------------------------------------------------------------------
// state s_ClimbLadder
// ----------------------------------------------------------------------

state s_ClimbLadder
{
	ignores 
		Untouch,			// don't remove lock on ladder when leaving zone (on ladder)
		ClimbLadder,		// don't reset state code
		MayFall;			// don't "fall" -- should investigate why this is being called improperly -- can fall if shot, but must be handled through damageattitudeto
	
	function BeginState()
    {
		bInTransition = true;
		ePawn.Acceleration = vect(0.0, 0.0, 0.0);
    }

    function EndState()
    {
		// reset flags 
		bInTransition		= false;
		bIsOnLadder			= false;
		
		ePawn.bCollideWorld = true;
		ePawn.m_topHanging	= false;
		ePawn.m_topClimbing = false;
		ePawn.Acceleration	= vect(0, 0, 0);
		ePawn.Velocity		= vect(0, 0, 0);
    }


	function GotoStateSafe(name State)
	{
		m_LastStateName = State;	// so when we get off the ladder, our state is coherent w/ our groups
	}
	
	// Any collision cancels that move
	event bool NotifyLanded(vector HitNormal, Actor HitActor)
	{
		// only "land" and exit state if climbing down (in transition)
		if (!bClimbingUp)
		{
			GotoState(,'OutBottom');
		}

		Disable('NotifyLanded');
		
		return true;
	}

	event bool NotifyHitWall(vector HitNormal, actor Wall)
	{		
		return true;
	}

	event int GetTurnSpeed() 
	{
		return ePawn.TurnSpeed_Alert;
	}

	function SetClimbUpSpeed()
	{
		local vector Z;

		Z = Vect(0,0,1) >> ePawn.Rotation;

		ePawn.LinearSpeed = 106.666;
		ePawn.Acceleration = Z * ePawn.LinearSpeed;  // (32.0f / GetAnimTime(ePawn.ANLUpLeft));           //eGame.m_NLUpwAardSpeed;	
	}

	function SetClimbDownSpeed()
	{
		local vector Z;

		Z = Vect(0,0,1) >> ePawn.Rotation;

		ePawn.LinearSpeed = 106.666;
		Pawn.Acceleration = Z * ePawn.LinearSpeed * -1.0f; 
	}

	
	// s_ladder damage - send event to group but don't force a state change
	function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType,optional int PillTag)
	{	
		if (Other != none && Damage > 0 && DamageType == None)
		{	
			// update last known player location if damage taken
			if (Other.IsPlayerPawn())
				UpdatePlayerLocation(Other, true, true);

			AIEvent.Reset();
			AIEvent.EventType		= AI_TAKE_DAMAGE;
			AIEvent.EventTarget		= Other;
			AIEvent.EventLocation	= Other.Location;

			Group.AIEventCallBack(self, AIEvent);
		}
        else if (Damage > 0) // Hit by Gameplayobject
        {
			AIEvent.Reset();
			AIEvent.EventType		= AI_HEAR_SOMETHING;
	        AIEvent.EventTarget	    = Epawn;
	        AIEvent.EventNoiseType  = NOISE_HeavyFootstep;

			Group.AIEventCallBack(self, AIEvent);        
        }
	}


// begin climbing down from the top

FromTop:
	//plog("---------------------------------------------------BEGIN CLIMB FromTop");
	
	// move to start point for getting on the ladder from the top
	bClimbingUp = false;
	
	// move to start point
	WalkToDestination(ePawn.m_locationEnd);		

	// get on ladder
	ePawn.SetPhysics(PHYS_Linear);					// PlayNarrowLadderInTop
	ePawn.PlayAnimOnly(ePawn.ANLInTop,,0.3f);		// PlayNarrowLadderInTop
	FinishAnim();

	bIsOnLadder = true;								// set flag once actually climbing

	// teleport to on-ladder-at-top location
	ePawn.m_locationEnd = ePawn.m_geoTopPoint;
	ePawn.m_locationEnd += (ePawn.m_geoNormal * (ePawn.CollisionRadius + 2.0));
	ePawn.m_locationEnd.Z -= (2.0 + ePawn.m_NarrowLadderArmsZone.Z);
	ePawn.SetLocation(ePawn.m_locationEnd);
	ePawn.SetRotation(ePawn.Rotation + rot(0, 32768, 0));

	ePawn.m_climbingUpperHand = CHLEFT;

	// we are at the top
	ePawn.m_topHanging = true;
	ePawn.m_topClimbing = true;
	CalculateLadderDestination();
	ePawn.SetLocation(ePawn.m_LocationEnd);
	ePawn.bCollideWorld = true;
	GoTo('GoDown');


// CLIMB DOWN

FromGround:
	// plog("---------------------------------------------------BEGIN CLIMB FromGround   EPAWN LOCATION : " $ ePawn.Location);
	
	bClimbingUp = true;								// set this flag so we don't exit state prematurely upon collision w/ ground
	ePawn.m_climbingUpperHand = CHRIGHT;
	
	WalkToDestination(ePawn.m_locationEnd);			// move to start point

	ePawn.PlayAnimOnly(ePawn.ANLInBottom,,0.3f);	// PlayNarrowLadderInBottom
	ePawn.SetPhysics(PHYS_RootMotion);				// PlayNarrowLadderInBottom
	FinishAnim();
	ePawn.ExitRootMotion(ePawn.ANLWaitRight);
	bIsOnLadder = true;								// set flag once actually climbing

	// Find justified position and move there
	ePawn.SetPhysics(PHYS_Linear);
	if (CalculateLadderDestination())
	{
		ePawn.m_topClimbing = true;
	}

	ePawn.SetLocation(ePawn.m_LocationEnd);
	
	bInTransition = true;

// CLIMB UP

GoUp:
	
	SetClimbUpSpeed();

	//plog("-----Start Climbing Upwards - Location : " $ ePawn.Location $    " Speed : " $ ePawn.Acceleration);

	if (ePawn.m_topClimbing)
	{
		GoTo('ClimbUpTop');
	}
	else
	{
		ePawn.m_locationEnd = ePawn.Location;
		ePawn.m_locationEnd.Z += eGame.m_NLStepSize * 2.0;
		
		ePawn.PlayNarrowLadderUp();
		FinishAnim();
	
		// Find justified position and move there
		if (CalculateLadderDestination())
		{
			// the justified position is at the top of the ladder
			ePawn.m_topClimbing = true;
		}
		ePawn.SetLocation(ePawn.m_LocationEnd);
	}

	bInTransition = false;
	GoTo 'GoUp';


ClimbUpTop:
	// Just get out of the ladder, nothing else to do
	ePawn.m_locationEnd = ePawn.Location + (ePawn.m_NLOutTopAnimOffset >> ePawn.Rotation);
	
	// Already at most top, get out
	ePawn.Acceleration = vect(0,0,0);
	ePawn.bCollideWorld = false;

	bIsOnLadder = true;								// disable flag once leaving ladder

	ePawn.SetCollision(true,false,false);
	
	switch (ePawn.m_climbingUpperHand)
	{
		case CHLEFT:
			ePawn.PlayAnimOnly(ePawn.ANLTopUpLeft);
			break;
		case CHRIGHT:
			ePawn.PlayAnimOnly(ePawn.ANLTopUpRight);
			break;
	}
	ePawn.setPhysics(PHYS_RootMotion);
	ePawn.m_climbingUpperHand = CHNONE;

	FinishAnim();
	
	ePawn.ExitRootMotion('WaitStNmFd0');
	ePawn.bCollideWorld = true;
	ePawn.SetCollision(true,true,true);
	
	GoToState(m_LastStateName);

GoDown:
	SetClimbDownSpeed();

	bInTransition = true;

	// just go down 2 bars
	ePawn.m_locationEnd = ePawn.Location;
	ePawn.m_locationEnd.Z -= eGame.m_NLStepSize * 2.0;
	ePawn.PlayNarrowLadderDown();
	FinishAnim();
	ePawn.m_topClimbing = false;

	// Find justified position and move there
	CalculateLadderDestination();
	ePawn.SetLocation(ePawn.m_LocationEnd);
	bInTransition = false;
	Goto('GoDown');

OutBottom:

	bIsOnLadder = true;								// disable flag once leaving ladder
	ePawn.PlayNarrowLadderOutBottom();
	ePawn.setPhysics(PHYS_RootMotion);
	FinishAnim();
	ePawn.ExitRootMotion('WaitStNmFd0');
	Enable('NotifyLanded');

	GoToState(m_LastStateName);
}




//---------------------------------------[David Kalina - 17 Jul 2001]-----
// 
// Description
//		Triggered when we are about to get onto a ladder.
//		Moves us to the corresponding point on the ladder and then gets off. 
// 
//------------------------------------------------------------------------

// Calculates the closest bar and returns if top of ladder
function bool CalculateLadderDestination()
{
	local vector destination;
	local FLOAT handsHeight, handsHeightJustified, step, remain;
	
	// Find a position aligned with an even bar
	destination = ePawn.m_geoBottomPoint + (ePawn.m_geoNormal * ePawn.m_NarrowLadderArmsZone.X);
	handsHeight = ePawn.Location.Z + ePawn.m_NarrowLadderArmsZone.Z;
	step = handsHeight - ePawn.m_geoBottomPoint.Z;
	remain = step % (eGame.m_NLStepSize * 2.0);	// only at even bars (each bar is 32)

	//log("Destination : " $ destination);
	//log("HandsHeight : " $ handsHeight);
	//log("Step : " $ step);
	//log("Remain : " $ remain);

	if (remain > eGame.m_NLStepSize)
	{
		// closer to the top, justify to the top
		handsHeightJustified = handsHeight - remain + (eGame.m_NLStepSize * 2.0);
	}
	else
	{
		// closer to the bottom, justify to the bottom
		handsHeightJustified = handsHeight - remain;
	}
	destination.Z = handsHeightJustified - ePawn.m_NarrowLadderArmsZone.Z;
	
	// Prepare variables for MoveToDestination
	ePawn.m_locationStart		= ePawn.Location;
	ePawn.m_locationEnd			= destination;
	ePawn.m_orientationStart	= ePawn.Rotation;
	ePawn.m_orientationEnd		= ePawn.Rotation;

	if ((destination.Z + ePawn.m_NarrowLadderArmsZone.Z) > (ePawn.m_geoTopPoint.Z - 1.0))
	{
		return true;
	}
	else
	{
		return false;
	}
}



//
//
//	D O O R S 
//
//	OpenDoor will trigger appropriate action for current SpecialMoveDoor (set by entering a DoorMarker's radius)
//	
//	s_ClimbLadderNew was the beginning of an attempt to move the ladder navigation code over to the EPawn
//
//

//---------------------------------------[David Kalina - 27 Nov 2001]-----
// 
// Description
//		Called when SpecialMoveDoor is set and we are navigating through the Door.
//		Initializes interaction if available, otherwise
//------------------------------------------------------------------------

event bool OpenDoor()
{
	Interaction = SpecialMoveDoor.GetInteraction(ePawn);
	
	if (Interaction != none)
	{
		plog("OPEN DOOR :  Interaction found : " $ Interaction);
		Interaction.InitInteract(self);
		Interaction.SetInteractLocation(ePawn);
		return true;
	}
	else
	{
		log("WARNING:  OPEN DOOR - No Interaction, returning false, will return GS_Failure.");
		return false;
	}
}


//---------------------------------------[David Kalina - 27 Nov 2001]-----
// 
// Description
//		Entering door radius, set SpecialMoveDoor so EMoveToward
//		will handle being in the vicinity of a door.
//
//------------------------------------------------------------------------

event EnteringDoorRadius(EDoorMover Door)
{
	if (SpecialMoveDoor == none)
		SpecialMoveDoor = Door;
	else
	{
		// which is closer, the door whose radius we just entered or the current SpecialMoveDoor?
		if (VSize(Door.myMarker.Location - ePawn.Location) < VSize(SpecialMoveDoor.myMarker.Location - ePawn.Location))
		{
			// distance to new door is closer - replace SpecialMoveDoor

			//plog("Replacing SpecialMoveDoor : " $ SpecialMoveDoor $ "   with Door : " $ Door);
			LeavingDoorRadius();
			SpecialMoveDoor = Door;
		}
	}

}

//---------------------------------------[David Kalina - 27 Nov 2001]-----
// 
// Description
//		Exiting door radius:
//		Unlock door and reset our SpecialMoveDoor reference
//
//------------------------------------------------------------------------

function LeavingDoorRadius()
{
    if (SpecialMoveDoor == None)
    {
        return;
    }

	if (SpecialMoveDoor.UsingController == self)
	{
		//plog("Unlocking SpecialMoveDoor by resetting UsingController.");
		SpecialMoveDoor.UsingController = none;
	}

	SpecialMoveDoor = none;
}


//---------------------------------------[David Kalina - 30 Nov 2001]-----
// 
// Description
//		State triggered by a call to OpenDoor()
//		Moves to proper location and plays animation to open door manually.
// 
//------------------------------------------------------------------------

state s_OpenDoor
{
	function BeginState()
	{
		bWaitForDoor = false;

		//plog("BEGINSTATE - Interaction =>" $ Interaction);
		if (Level.TimeSeconds - LastTryTime < 2.0f)
		{
			NumberOfTry++;

			if (NumberOfTry >= 1)
			{
				//log("The door cannot open");

				if (FRand() > 0.5f)
				{
					ePawn.Bark_Type = BARK_Mystified;
					ePawn.Playsound(ePawn.Sounds_Barks,SLOT_Barks);
				}

				bWaitForDoor = true;
				m_LastStateName = 's_investigate';
				NumberOfTry = 0;
			}
		}
		else
		{
			NumberOfTry = 0;
		}

		LastTryTime = Level.TimeSeconds;
	}

	event bool OpenDoor()
	{
		return true;
	}

	// standard goal execution tick
	function Tick(float deltaTime)
	{
		if (Group != none)
		{
			switch (ExecuteCurrentGoal())
			{
				case GS_Executing :
					
					// keep on merrily executing
					break;
					
				case GS_Complete : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_COMPLETE;
					Group.AIEventCallBack(self, AIEvent);
					break;
					
				case GS_Failure : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_FAILURE;
					Group.AIEventCallBack(self, AIEvent);
					break;
			}
		}
	}

	function GotoStateSafe(name State)
	{		
		m_LastStateName = State;	// so when we stop using the door, our state is coherent w/ our groups
		
		GotoState(State);
	}

	event NotifyAction()
	{
		Interaction.Interact(self);
	}
	
	event bool NotifyBump(Actor Other, optional int Pill)
	{
		return true;
	}

	function EndState()
	{
		ePawn.SetPhysics(PHYS_Walking);

		// used to block EMoveToward's execution
		bInTransition = false;
		bInteractionComplete = true;
	}

	// Check for Bump door
	function bool IsBumpingDoor()
	{
		return EDoorMover(Interaction.Owner.Owner).InitialState == 'BumpOpenTimed';
	}

LockedRt:			// locked doors still open for NPCs
UnLockedRt:
	
	if (bWaitForDoor)
		Sleep(1.25f + 2 * FRand());

	while (ePawn.bInTransition)
    {
		Sleep(0.2);
    }

	WalkToDestination(ePawn.m_locationEnd);
	ePawn.SetPhysics(PHYS_Walking);

	if (IsBumpingDoor())
	{
		Interaction.Interact(self);
		Interaction.Owner.Owner.Bump(ePawn,0);
	}
	else
	{
		bInTransition = true;
		ePawn.PlayDoorOpen(true);   // RIGHT
	}
	
	goto('FinishDoorAnim');

LockedLt:
UnLockedLt:

	if (bWaitForDoor)
		Sleep(1.25f + 2 * FRand());

	while (ePawn.bInTransition)
    {
		Sleep(0.2);
    }

	WalkToDestination(ePawn.m_locationEnd);
	ePawn.SetPhysics(PHYS_Walking);

	if (IsBumpingDoor())
	{
		Interaction.Interact(self);
		Interaction.Owner.Owner.Bump(ePawn,0);
	}
	else
	{
		bInTransition = true;
		ePawn.PlayDoorOpen(false);   // LEFT
	}
	
	goto('FinishDoorAnim');


FinishDoorAnim:

	FinishAnim();
	// if door is still closed, that means we didn't play an animation
	// Alain - Removed this to prevent double opening doors
	//Interaction.Interact(self);
	GotoState(m_LastStateName);
}



//---------------------------------------[David Kalina - 9 Aug 2001]-----
// 
// Description
//		State triggered when we are standing on an EDoorPoint and 
//		want to go through the door USING A RETINAL SCANNER.
// 
//------------------------------------------------------------------------

state s_RetinalScanner
{
	function EndState()
	{
		ePawn.SetPhysics(PHYS_Walking);
		bInteractionComplete = true;
	}

	event bool OpenDoor()
	{
		return true;
	}
		
begin:
	// move to retinal scanner interact location
	WalkToDestination(ePawn.m_locationEnd);

	// play interact animation
	ePawn.PlayAnimNoMovement(ePawn.ARetinalScanBegin,,0.2);
	FinishAnim();
	Interaction.Interact(self);
	ePawn.LoopAnimOnly(ePawn.ARetinalScan,,0.2);
	Stop;

RetinalEnd:
	ePawn.PlayAnimNoMovement(ePawn.ARetinalScanEnd,,0.2);
	FinishAnim();
	GotoState(m_LastStateName);
}


//---------------------------------------[David Kalina - 9 Aug 2001]-----
// 
// Description
//		State triggered when we are standing on an EDoorPoint and 
//		want to go through the door USING A KEYPAD.
// 
//------------------------------------------------------------------------

state s_KeyPadInteract 
{
	function EndState()
	{
		ePawn.SetPhysics(PHYS_Walking);
		bInteractionComplete = true;

		if (Interaction != None)
			Interaction.LockOwner(false);
			
	}

	function NotifyAction()
	{
		if (Interaction == None)
			return;

		Interaction.KeyEvent("Interaction", IST_Press, 1, true);
		// If after interacting, the interaction is None, this means the code is completed for the Npc.
		if (Interaction == None)
			GotoState(m_LastStateName);
	}

	function bool OpenDoor()
	{
		return true;
	}

	// Joshua - Fix NPCs being softlocked if knocked in a keypad interaction
	function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType, optional int PillTag)
	{
		if (DamageType == class'EKnocked' && Other != None && Other.IsPlayerPawn())
		{
			// Clean up interaction state
			if (Interaction != None)
			{
				Interaction.LockOwner(false);
				Interaction = None;
			}
			
			bInteractionComplete = false;
			bInteractionActive = false;
			
			// If PillTag == 1, it's a full grab, let global handler take over
			if (PillTag == 1)
			{
				Global.damageAttitudeTo(Other, Damage, damageType, PillTag);
				return;
			}
			
			// Otherwise it's just a elbow hit, exit to alert state and let EPawn handle the stagger animation
			m_LastStateName = 's_Alert';
			GotoState('s_Alert');
			
			// Still notify the group about taking damage
			AIEvent.Reset();
			AIEvent.EventType = AI_TAKE_DAMAGE;
			AIEvent.EventTarget = Other;
			AIEvent.EventLocation = Other.Location;
			Group.AIEventCallBack(self, AIEvent);
			return;
		}
		
		// For other damage types, send event to group and exit interaction
		if (Other != None && Damage > 0)
		{
			if (Other.IsPlayerPawn())
				UpdatePlayerLocation(Other, true, true);

			AIEvent.Reset();
			AIEvent.EventType = AI_TAKE_DAMAGE;
			AIEvent.EventTarget = Other;
			AIEvent.EventLocation = Other.Location;

			Group.AIEventCallBack(self, AIEvent);
			
			// Exit keypad interaction
			GotoState(m_LastStateName);
		}
	}

begin:
	// move to interact location
	WalkToDestination(ePawn.m_locationEnd);
	
	Interaction.LockOwner(true);

	ePawn.LoopAnimOnly('KpadStNmNt0',,0.2);
}

state s_ElevatorInteract
{
	function EndState()
	{
		ePawn.SetPhysics(PHYS_Walking);
		bInteractionComplete = true;
	}

	function NotifyAction()
	{
		if (Interaction == None)
			return;

		Interaction.KeyEvent("Interaction", IST_Press, 1, true);
		GotoState(m_LastStateName);
	}

	// Joshua - Fix NPCs being softlocked if knocked in a elevator interaction
	function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType, optional int PillTag)
	{
		// Handle being knocked during elevator interaction
		if (DamageType == class'EKnocked' && Other != None && Other.IsPlayerPawn())
		{
			// Clean up interaction state
			Interaction = None;
			bInteractionComplete = false;
			bInteractionActive = false;
			
			// If PillTag == 1, it's a full grab, let global handler take over
			if (PillTag == 1)
			{
				Global.damageAttitudeTo(Other, Damage, damageType, PillTag);
				return;
			}
			
			// Otherwise it's just a elbow hit, exit to alert state and let EPawn handle the stagger animation
			m_LastStateName = 's_Alert';
			GotoState('s_Alert');
			
			// Still notify the group about taking damage
			AIEvent.Reset();
			AIEvent.EventType = AI_TAKE_DAMAGE;
			AIEvent.EventTarget = Other;
			AIEvent.EventLocation = Other.Location;
			Group.AIEventCallBack(self, AIEvent);
			return;
		}
		
		// For other damage types, send event to group and exit interaction
		if (Other != None && Damage > 0)
		{
			if (Other.IsPlayerPawn())
				UpdatePlayerLocation(Other, true, true);

			AIEvent.Reset();
			AIEvent.EventType = AI_TAKE_DAMAGE;
			AIEvent.EventTarget = Other;
			AIEvent.EventLocation = Other.Location;

			Group.AIEventCallBack(self, AIEvent);
			
			// Exit elevator interaction
			GotoState(m_LastStateName);
		}
	}

begin:
	// move to interact location
	WalkToDestination(ePawn.m_locationEnd);
	
	//Interaction.LockOwner(true);

	ePawn.LoopAnimOnly('KpadStNmNt0',,0.2);
}

// ----------------------------------------------------------------------
// state s_SitDown -- triggered by InitInteract() call to EChairInteraction
//
//		StandUp() when GotoStateSafe is called 
//		bInTransition is set to make sure transition completes before doing anything else
// ----------------------------------------------------------------------

state s_SitDown extends s_Default
{
	ignores NotifyBump, MayFall, BeginInteraction;

	function AdjustStandUp()
	{
		if (m_LastStateName == 's_alert')
		{
			if (ePawn.bSleeping)
			{
				ePawn.AStandUpR						= 'LaidBdAlUpR';
				ePawn.AStandUpL						= 'LaidBdAlUpL';
			}
			else
			{
				if (!ePawn.bDrunk)
				{
					ePawn.AStandUpR						= 'SittAsAlUpR';
					ePawn.AStandUpL						= 'SittAsAlUpL';
					ePawn.AStandUpF						= 'SittChAlUp0';
				}
			}
	}
	}

	function GotoStateSafe(name State)
	{
		plog("--------------------> GotoStateSafe called : " $ State$" EPawn current state: "$ePawn.GetStateName());

		m_LastStateName = State;

		// only stand when first interaction (sitting) is complete
		/*if (bInteractionComplete && !ePawn.bInTransition && (ePawn.GetStateName() != 's_Transition'))
		{
			log("Standing up... "$bTableChair);
			ePawn.StandUp(true,bTableChair);
		}*/

		//else
		if (ePawn.TransitionQueue.Length > 0)
		{
			if ((ePawn.TransitionQueue[0].ATransition != ePawn.AStandUpR) && 
				(ePawn.TransitionQueue[0].ATransition != ePawn.AStandUpF))
            {
				bStandUpASAP = true;
            }
		}
	}

	function TransitionEnd()
	{
		local EGoal goal;

		log("TransitionEnd: "$ePawn.TransitionQueue[0].ATransition$" EPawn.AStandUpR: "$ePawn.AStandUpR$" for Pawn: "$Pawn);

		// 1st transition = sitting down
		//if (!bInteractionComplete)
		if ((ePawn.TransitionQueue[0].ATransition != ePawn.AStandUpR) && 
			(ePawn.TransitionQueue[0].ATransition != ePawn.AStandUpF))
		{
			if ((ePawn.TransitionQueue[0].ATransition == ePawn.ASitDownR) ||
				(ePawn.TransitionQueue[0].ATransition == ePawn.ASitDownF))
			{
				//plog("bInteractionComplete is false -- we just finished sitting down");

				ePawn.SetRotation(Interaction.Rotation);
				bInteractionComplete = true;

			}
		}

		// 2nd transition = standing up
		else
		{
			//log("Pawn: "$pawn$" GotoState: "$m_LastStateName);
			//RelocatePawnOnGround();

			ePawn.ADeathForward				    = 'XxxxStAlFd0';
			ePawn.ADeathBack					= 'XxxxStAlBk0';
			ePawn.ADeathLeft					= 'XxxxStAlLt0';
			ePawn.ADeathRight					= 'XxxxStAlRt0';
			ePawn.ADeathDown					= 'XxxxStAlDn0';

			bInteractionComplete = true;

			plog("bInteractionComplete is true -- we just finished standing up PAWN: "$m_LastStateName);
			GotoState(m_LastStateName);
		}
	}

	function Tick(float deltaTime)
	{
		local EGoal goal;



		if (ePawn.TransitionQueue.Length > 0)
		{
			if ((ePawn.TransitionQueue[0].ATransition == ePawn.AStandUpR) ||
				(ePawn.TransitionQueue[0].ATransition == ePawn.AStandUpF))
				return;
		}

		// if stand up is queued, perform action now
		if (bInteractionComplete && !ePawn.bInTransition && bStandUpASAP)
		{
			AdjustStandUp();

			ePawn.StandUp(true,bTableChair);
			return;
		}

		// execute current goal
		if (Group != none)
		{

			goal = m_pGoalList.GetCurrent();

			if (goal.m_GoalType != GOAL_Wait)
			{
				if ((bInteractionComplete) && !ePawn.bInTransition && (ePawn.GetStateName() != 's_Transition'))
				{
					//log("Standing up... "$bTableChair);
					AdjustStandUp();

					ePawn.StandUp(true,bTableChair);
				}

				return;
			}

			if (!bInteractionComplete)
				return;

			switch (ExecuteCurrentGoal())
			{
				case GS_Executing :

					// keep on merrily executing
					break;

				case GS_Complete : 

					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_COMPLETE;
					Group.AIEventCallBack(self, AIEvent);
					break;

				case GS_Failure : 
					
					// send message to group
					AIEvent.Reset();
					AIEvent.EventType = AI_GOAL_FAILURE;
					Group.AIEventCallBack(self, AIEvent);
					break;
			}
		}
	}

	function BeginState()
	{
		//log("BeginState sitdown state: for pawm: "$pawn);

		bInTransition = true;
		bStandUpASAP = false;

	}

	function EndState()
	{
		//log("Exiting sitdown state: for pawm: "$pawn);
		ePawn.bYawDiffSet = false;

		Interaction.PostInteract(self);
		

		bInTransition			= false;
		bInteractionActive		= false;
		bInteractionComplete	= false;
		Interaction				= none;
	}

	function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType,optional int PillTag)
	{
		local bool bNoStand;

		//don't stand up
		if (Group != None  &&  Group.ScriptedPattern != None  && Group.bEventExclusivity == true)
			bNoStand = true;

		if (!bNoStand)
		{
			if (bInteractionComplete && !ePawn.bInTransition && (ePawn.GetStateName() != 's_Transition'))
			{
				//plog("Taking damage - getttonup...");
				AdjustStandUp();

				ePawn.StandUp(true,bTableChair);
			}
			else
			{
				//plog("Taking damage before sitting down -- stand up as soon as animation is complete.");
				if ((ePawn.TransitionQueue[0].ATransition != ePawn.AStandUpR) && 
					(ePawn.TransitionQueue[0].ATransition != ePawn.AStandUpF))
					bStandUpASAP = true;
			}
		}

        if (Other != None && DamageType == None)
        {		
		    // send event to group
		    AIEvent.Reset();
		    AIEvent.EventType		= AI_TAKE_DAMAGE;
		    AIEvent.EventTarget		= Other;
		    AIEvent.EventLocation	= Other.Location;
		    
		    Group.AIEventCallBack(self, AIEvent);
        }
        else  // Damage done via a EGameplayObject - just send a changed actor
        {
		    // send event to group
			AIEvent.Reset();
			AIEvent.EventType		= AI_HEAR_SOMETHING;
	        AIEvent.EventTarget	    = ePawn;
	        AIEvent.EventNoiseType  = NOISE_HeavyFootstep;

			Group.AIEventCallBack(self, AIEvent);             
        }
	}
	
	function SetWaitAnim(int Side)
	{
		local EGoal goal;

		goal = m_pGoalList.GetCurrent();

		if (goal.GoalAnimB == '')
		{
			switch (Side)
			{
			case 0:
				goal.GoalAnim = ePawn.AWaitSitT;
				break;
			case 1:
				goal.GoalAnim = ePawn.AWaitSitT;
				break;
			case 2:
				goal.GoalAnim = ePawn.AWaitSitS;
				break;
			}
		}
	}
LeftSide:
	WalkToDestination(ePawn.m_locationEnd);
	ePawn.SitDown(false,true);
	SetWaitAnim(0);
	bTableChair = true;
	Stop;

RightSide:
	WalkToDestination(ePawn.m_locationEnd);
	ePawn.SitDown(true,true);
	SetWaitAnim(1);
	bTableChair = true;
	Stop;

FrontSide:
	WalkToDestination(ePawn.m_locationEnd);
	ePawn.SitDown(true,false);
	SetWaitAnim(2);
	bTableChair = false;
	Stop;

}


// ----------------------------------------------------------------------
// NPC Throwing Object States - triggered by event call ThrowGrenade()
// ----------------------------------------------------------------------

event EchelonEnums.GoalStatus ThrowGrenade(vector Direction)
{
	// must have grenade in hand to continue...


	plog("		THROW GRENADE -- EPawn Hand Item " $ ePawn.HandItem);

	// wait for any scheduled transitions to complete before starting our throw
	if (ePawn.bInTransition)
		return GS_Executing;

	if (ePawn.HandItem != none && ePawn.HandItem.IsA('EFragGrenade') || ePawn.HandItem.IsA('ESmokeNPCGrenade') || ePawn.HandItem.IsA('EConcussionGrenade') || ePawn.HandItem.IsA('EFlare'))
	{
		ePawn.HandItem.Use();		// should send us to state s_Throw
		return GS_Executing;
	}
	else
		return GS_Failure;
}


// ----------------------------------------------------------------------
// state s_Throw - start the transition anim in EPawn and wait for notification
// ----------------------------------------------------------------------

state s_Throw extends s_Alert
{
	Ignores GotoStateSafe, SeePlayer, HearNoise, NotifyBump;

	function NotifyAction()
	{
		bThrowNow = true;
	}

	function BeginState()
	{
		// SelectGrenade call now in ExecGoal_ThrowGrenade
		ePawn.GetBoneCoords('WeaponBone', true);

		bThrowNow = false;
	}

	function TransitionEnd()
	{
		GotoState(m_LastStateName);
	}

	event EchelonEnums.GoalStatus ThrowGrenade(vector Direction)
	{
		// will be blocked by EPawn s_Transition after playback starts
		ePawn.PlayThrowGrenade(Direction);

		if (bThrowNow)
		{
			if (ePawn.HandItem != none)
			{
				log("s_Throw: "$ePawn.HandItem);
				ePawn.HandItem.SetLocation(ePawn.GetBoneCoords('WeaponBone', true).Origin);
				ePawn.HandItem.Throw(self, Direction);
				
				return GS_Complete;
			}
		}
		else
			return GS_Executing;
	}

	function EndState()
	{
		m_LastStateName = 's_Alert';

		ePawn.SelectWeapon();
	}


	function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType,optional int PillTag)
	{
		local vector DropVelocity;
		local name   CurrentAnimSeq;
		local float  CurrentFrame, CurrentRate;
		
		ePawn.GetAnimParams(0, CurrentAnimSeq, CurrentFrame, CurrentRate);

		// drop grenade if not thrown yet - base damageAttitudeTo will change our state
		
		// plog(" EPawn Frame # " $ CurrentFrame);
		
		DropVelocity   = vect(0,0,0);
		DropVelocity.X = 100.0f * CurrentFrame;
		
		DropSelectedItem(DropVelocity);

		GotoState('s_Alert');
	}
}



// ----------------------------------------------------------------------
// state s_ReviveAnotherNPC
// ----------------------------------------------------------------------

function Revive() {}	// only defined in s_unconscious

state s_ReviveAnotherNPC
{
	function EndState()
	{
		bInteractionComplete = true;
	}

	function NotifyAction()
	{
			Interaction.Interact(self);
	}

begin:
	// will call NotifyAction at correct moment in animation
	ePawn.CurrentYawDiff = 0;
	
	ePawn.PlayAnimNoMovement(ePawn.AReviveBody,,0.2f);		
	FinishAnim();

	GotoState(m_LastStateName);
}


// ----------------------------------------------------------------------
// state s_Turret -- triggered by InitInteract() call to ETurretInteraction
// ----------------------------------------------------------------------

state s_Turret
{
	Ignores GotoStateSafe, SeePlayer, HearNoise, NotifyBump;
	
	function EndState()
	{
		bInteractionComplete = true;
	}

	function NotifyAction()
	{
		Interaction.Interact(self);
	}
	
begin:
	// will call NotifyAction at correct moment in animation
	// TODO : REPLACE ANIMATION!
	ePawn.CurrentYawDiff = 0;
	ePawn.PlayAnimNoMovement(ePawn.ASearchBody);		
	FinishAnim();
	GotoState(m_LastStateName);
}




// ----------------------------------------------------------------------
// state s_PlaceWallMine -- triggered by InitInteract() call to EWallMineInteraction
// not actually for placing a wallmine - purpose is to disable (must conform to forced GotoState() call from interaction)
// ----------------------------------------------------------------------

event EchelonEnums.GoalStatus PlaceWallMine(vector Location)
{
	//plog("CALLING PLACE WALL MINE ..");

	if (ePawn.HandItem != none && ePawn.HandItem.IsA('EWallMine'))
	{
		//plog("CALLING USE ****** ..");
	
		ePawn.HandItem.Use();
	}
	else
		return GS_Complete;

	return GS_Executing;
}

state s_PlaceWallMine
{
	Ignores GotoStateSafe, SeePlayer, HearNoise, NotifyBump;

	function EndState()
	{
		ePawn.SelectWeapon();
		Interaction = none;
	}
	
	event EchelonEnums.GoalStatus PlaceWallMine(vector Location)
	{
		return GS_Executing;	
	}

	function NotifyAction()
	{
		// Unhide item in hand from animation
		ePawn.HandItem.bHidden = false;
	}

begin:
	ePawn.CurrentYawDiff = 0;
	ePawn.PlayAnimNoMovement(ePawn.APlaceWallMineBegin,,0.3);
	FinishAnim();

	ePawn.PlayAnimNoMovement(ePawn.APlaceWallMine,,0.2);
	FinishAnim();
	ePawn.HandItem.GotoState('s_PawnPlacement','PlaceOnWall');

	ePawn.PlayAnimNoMovement(ePawn.APlaceWallMineEnd,,0.2);
	FinishAnim();

	GotoState(m_LastStateName);
}


// ----------------------------------------------------------------------
// state s_DisableWallMine -- triggered by InitInteract() call to EWallMineInteraction
// not actually for placing a wallmine - purpose is to disable (must conform to forced GotoState() call from interaction)
// ----------------------------------------------------------------------

state s_DisableWallMine
{
	Ignores GotoStateSafe, SeePlayer, HearNoise, NotifyBump;
	
	function EndState()
	{
		bInteractionComplete = true;
	}
	
Begin:
	ePawn.CurrentYawDiff = 0;
	ePawn.PlayAnimNoMovement(ePawn.APlaceWallMineEnd,,0.1,true);
	FinishAnim();

	ePawn.LoopAnimOnly(ePawn.APlaceWallMine,,0.1);
	Sleep(3);

	Interaction.Interact(self);

	ePawn.PlayAnimNoMovement(ePawn.APlaceWallMineEnd,,0.3);
	FinishAnim();

	GotoState(m_LastStateName);
}


// ----------------------------------------------------------------------
// state s_AlarmSwitch -- triggered by InitInteract() call to EAlarmInteraction
// ----------------------------------------------------------------------

state s_AlarmSwitch extends s_Alert
{
	Ignores GotoStateSafe;
	
	function NotifyAction()
	{
		//NOTIFY IS NOT WORKING PROPERLY
		//Interaction.Interact(self);
	}
	
	function Tick(float deltaTime) {}

	function EndState()
	{		
		bInteractionComplete = true;
	}
	
begin:
	// will call NotifyAction at correct moment in animation
	// TODO : REPLACE ANIMATION!
	//log("    s_AlarmSwitch - BEGIN " $ Level.TimeSeconds);

	WalkToDestination(ePawn.m_LocationEnd);
	ePawn.PlayAnimNoMovement(ePawn.AAlarmInteract,,0.2f);
	FinishAnim();
	Interaction.Interact(self);
	GotoState(m_LastStateName);
}

// ----------------------------------------------------------------------
// state s_SwitchObject -- triggered by InitInteract() call to ETriggerInteraction
// ----------------------------------------------------------------------

state s_SwitchObject extends s_default
{
	Ignores GotoStateSafe;

	function Tick(float deltaTime)
	{
	}

	function EndState()
	{
		if (Interaction !=None)
			Interaction.Interact(self);

		bInteractionComplete = true;

	}
	
begin:
	WalkToDestination(ePawn.m_LocationEnd);
	ePawn.PlayAnimNoMovement(ePawn.ALightSwitchInteract);
	FinishAnim();
	GotoState(m_LastStateName);
}





/***************************************************************************************************
 ******			ANIMATION RELATED STATES					****************************************
 ****

	Taking Damage
	Falling
	Stunned
	Groggy
	Unconscious
	Dead
																							********
     ***********************************************************************************************
***************************************************************************************************/




// ----------------------------------------------------------------------
// state s_TakingDamage - wait for damage to complete before returning to previous state
// ----------------------------------------------------------------------


function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType,optional int PillTag)
{
	local EGoal goal;
	log("damageAttitudeTo: Other: "$Other$" Damage: "$Damage$" damageType: "$damageType$" PillTag: "$PillTag);

    //log("damageAttitudeTo");
	
	if (DamageType == class'EKnocked' && PillTag != 1 && Other.IsPlayerPawn())
	{
		bShootTarget = true;

		if (EchelonLevelInfo(Level).bOnlyUseSingleShot)
			bAccFire = true;
		else
			NextFireTime = Level.TimeSeconds + 0.3;
		

		//check if the NPC is in a reaction
		goal = m_pGoalList.GetCurrent();

		log("Goal priority: "$goal.priority);

		if (goal.priority >= 50)
		{
			//stun the NPC
			ePawn.GotoState('s_Stunned','Stunned'); 
		}
		else
		{

			if (Pattern != None &&  Pattern.GetStateName() == 'attack')
			{
				ePawn.BlendAnimOverCurrent(ePawn.ADamageHeadShotForward, 1, ePawn.UpperBodyBoneName,1.0,0.2);

				return;
			}

			if (!bPlayerSeen)
			{
				AIEvent.Reset();
				AIEvent.EventType		= AI_TAKE_DAMAGE;
				AIEvent.EventTarget		= Other;
				AIEvent.EventLocation	= Other.Location;

				Group.AIEventCallBack(self, AIEvent);

				DamageTimer = Level.TimeSeconds;

				return;
			}

		}
	}

	// damage handled entirely by pawn
	//else if (damageType != None)
	//	return;

	// update last known player location if damage taken
	else if (Other != None && Damage > 0 && Other.IsPlayerPawn())
		UpdatePlayerLocation(Other, true, true);

	//damage from turret
	if (Other == None && Damage > 0 && DamageType == None)
		return;



	// only block other commands by changing states within range of timer ..
	if (Level.TimeSeconds - DamageTimer > 1.5f)
	{
        if (Other != None && DamageType == None)
        {
			if (Other.IsPlayerPawn())
        {
            AIEvent.Reset();
		    AIEvent.EventType		= AI_TAKE_DAMAGE;
		    AIEvent.EventTarget		= Other;
		    AIEvent.EventLocation	= Other.Location;

		    Group.AIEventCallBack(self, AIEvent);

		    DamageTimer = Level.TimeSeconds;
		    GotoState('s_TakingDamage');
        }
        else
        {
				DamageTimer = Level.TimeSeconds;
				GotoState('s_TakingDamage');
			}
        }
        else
        {
            AIEvent.Reset();
			AIEvent.EventType		= AI_HEAR_SOMETHING;
	        AIEvent.EventTarget	    = Epawn;
	        AIEvent.EventNoiseType  = NOISE_HeavyFootstep;

			Group.AIEventCallBack(self, AIEvent); 

		    DamageTimer = Level.TimeSeconds;
        }
	}
}

state s_TakingDamage extends s_Alert
{
	//ignores SeePlayer, HearNoise, KilledBy, NotifyBump;

	function Tick(float deltaTime){}
	function EndState(){}
	function GotoStateSafe(Name State)
	{
		m_LastStateName = State;
	}

	function AnimEnd(int Channel)
	{
		Global.AnimEnd(Channel);

		// if damage animation completes, return to last state
		if (Channel == 0)
			GotoState(m_LastStateName);
	}

	function Timer()
	{
		GotoState(m_LastStateName);
	}

begin:
	ePawn.Acceleration = vect(0,0,0);
}




//---------------------------------------[David Kalina - 25 May 2001]-----
// 
// Description
//		If we're about to fall, set flag so possibilitys can be handled elsewhere.
//		If SetFall is called, then we ARE falling..
//
//------------------------------------------------------------------------

event MayFall()
{
	//plog("MayFall called - setting bAboutToFall to true");
	bAboutToFall = true;						// set so TurnSmooth will opt to turn immediately	
}

function SetFall()
{
	//plog("Set Fall -- going to s_Falling");
	GotoState('s_Falling');						// s_Falling exists to ignore normal AI goal execution, which will reset our physics improperly	
}

state s_Falling
{
	function GotoStateSafe(name State)
	{
		//plog("GotoStateSafe called from falling w/ state : " $ state);
		m_LastStateName = State;
	}
		
	event bool NotifyLanded(vector HitNormal, Actor HitActor)
	{
		//plog("s_Falling NotifyLanded -- GotoState " $ m_LastStateName);
		GotoState(m_LastStateName);
		return false;		// let pawn handle it
	}
}

// ----------------------------------------------------------------------
// state s_Grabbed
// ----------------------------------------------------------------------

state s_Grabbed
{
	ignores GotoStateSafe,SeePlayer, HearNoise, KilledBy, NotifyBump, BaseChange;

	function BeginState()
	{

		EchelonLevelInfo(Level).SendMusicRequest(0,false,Pattern);
		EchelonLevelInfo(Level).SendMusicRequest(1,false,Pattern);

		ePawn.StopAllSoundsActor(true);
		ePawn.GotoState('s_Grabbed');

		//remove the guy from the group
		AIEvent.Reset();
		AIEvent.EventType = AI_GRABBED; //should be AI_GRABBED
		Group.AIEventCallBack(self, AIEvent);

		bNotResponsive = true;

		GrabReset();
	}

	function EndState()
	{
		local EGoal goal;

		ePawn.GotoState('s_Waiting');

		ePawn.bCollideWorld = true;
		ePawn.SetCollision(true, true, true);

		//add the guy to the group
		AIEvent.Reset();
		AIEvent.EventType = AI_RELEASED;
		Group.AIEventCallBack(self, AIEvent);

		bNotResponsive = false;

		goal = m_pGoalList.GetCurrent();
		goal.bInitialized = false;

		m_vPrevDestination = vect(0,0,0);

		//if the NPC is out of his ZoneAI kill him
		if (ePawn.bDisableAI)
		{
			ePawn.Health = 0.0f;
		}

		if (eGame.pPlayer.Pawn.Physics == PHYS_Falling)
		{
			//trigger an attack against the player
			AIEvent.Reset();
			AIEvent.EventType		= AI_TAKE_DAMAGE;
			AIEvent.EventTarget		= eGame.pPlayer.Pawn;
			AIEvent.EventLocation	= eGame.pPlayer.Pawn.Location;
			Group.AIEventCallBack(self, AIEvent);
		}

	}

	function GrabReset()
	{
		ePawn.CurrentYawDiff = 0; //reset turning
		m_pGoalList.Reset();
		UnlockNavPoint();				// unlock existing nav points
		ClearRoutes();					// clear the existing WeightedRoute array and the route cache
		Interaction = none;				// drop any existing interactions - if not, and we are destroyed, the Interaction will be destroyed!!

		bInTransition			= false;
		bInteractionActive		= false;
		bInteractionComplete	= false;

		if (Pattern != None)
			Pattern.bDisableMessages = false;

	}

Fall:
	if (ePawn.Interaction != None)
		ENpcZoneInteraction(ePawn.Interaction).Release();
	ePawn.GotoState('s_Falling');
	ePawn.bCollideWorld = true;
	ePawn.FindFallSpot();
	GotoState('s_Falling');

FinishAlone:
	ePawn.PlayAnimOnly(ePawn.AWait, , 0.2);
	Goto('EndConscious');

Release:
	ePawn.PlayAnimOnly(ePawn.AGrabRelease);
	FinishAnim();
	ePawn.PlayAnimOnly(ePawn.AWait);
	ePawn.SetCollision(false);
	ePawn.Move(ToWorldDir(vect(72,0,0)));
	ePawn.SetCollision(true);
	Goto('EndConscious');

EndConscious:
	ePawn.SetPhysics(PHYS_Walking);

	if (ePawn.Interaction != None)
		ENpcZoneInteraction(ePawn.Interaction).Release();
	GotoState('s_default');
}

// ----------------------------------------------------------------------
// state s_Carried
// ----------------------------------------------------------------------

state s_Carried
{
	ignores SeePlayer, HearNoise, KilledBy, NotifyBump, BaseChange,damageAttitudeTo;

	function EndState()
	{
		//if the NPC is out of his ZoneAI kill him
		if (ePawn.bDisableAI)
		{
			ePawn.Health = 0.0f;
		}


		m_LastStateName = GetStateName();
	}

}


// ----------------------------------------------------------------------
// state s_Stunned -- we can't move for x seconds
//		waiting for Pawn to reset our state
// ----------------------------------------------------------------------

state s_Stunned
{
	Ignores  SeePlayer, HearNoise, NotifyBump;

	function BeginState()
	{

		ePawn.CurrentYawDiff = 0;
		bNotResponsive = true;
		bPlayerSeen = false;			// no need to call UpdatePlayerLocation, just set this to false

		if (Pattern != None && !Pattern.bRunningAlarm)
			Pattern.bDisableMessages = false;


		if (Pattern != None &&  Pattern.GetStateName() != 'attack' && !Pattern.bRunningAlarm)
		{
			m_pGoalList.Reset();
			bPlayerSeen = false;			// no need to call UpdatePlayerLocation, just set this to false
			UnlockNavPoint();				// unlock existing nav points
			ClearRoutes();					// clear the existing WeightedRoute array and the route cache
			Interaction = none;				// drop any existing interactions - if not, and we are destroyed, the Interaction will be destroyed!!
		}


	}

	event GotoStateSafe(name State)
	{
		m_LastStateName = State;
	}


	function EndState()
	{
		bNotResponsive = false;
		bPlayerSeen = false;


		if (Pattern != None) 
		{
			if (!Pattern.bRunningAlarm)
			{

				if (Pattern.GetStateName() != 'attack')
				{
					if (group != None)
					{
						AIEvent.Reset();
						AIEvent.EventType		= AI_HEAR_SOMETHING;
						AIEvent.EventTarget	    = self;
						AIEvent.EventNoiseType   = NOISE_HeavyFootstep;

						Group.AIEventCallBack(self, AIEvent);
					}
				}
				else
				{
					if (TargetActorToFire.GetVisibilityFactor() < 1)
					{

						Pattern.GotoState('idle');
						
						if (!(Group != None && Group.ScriptedPattern != None && Group.ScriptedPattern.bEventExclusivity))
						{
							m_pGoalList.Reset();
						}


						UnlockNavPoint();				// unlock existing nav points
						ClearRoutes();					// clear the existing WeightedRoute array and the route cache
						Interaction = none;				// drop any existing interactions - if not, and we are destroyed, the Interaction will be destroyed!!

						AIEvent.Reset();
						AIEvent.EventType		= AI_HEAR_SOMETHING;
						AIEvent.EventTarget	    = self;
						AIEvent.EventNoiseType   = NOISE_HeavyFootstep;

						Group.AIEventCallBack(self, AIEvent);

					}
				}
			}

		}
	}
}


// ----------------------------------------------------------------------
// state s_Groggy -- go here after being revived
// ----------------------------------------------------------------------
state s_Groggy
{
	Ignores GotoStateSafe, SeePlayer, HearNoise, NotifyBump;

	function Timer()
	{
		ePawn.GotoState('DefaultState');
		
		// If We don't want the grab interaction to be active immediately, set it here.
		if (ePawn.Interaction != None)
			ePawn.Interaction.SetCollision(false);

      	ePawn.SetCollision(true,true,true);
	}

	function EndState()
	{
		bNotResponsive = false;
						
		if (Pattern != None)
			Pattern.SetPostAttackBehavior(1);
	
		// Restore Interaction
		if (ePawn.Interaction != None)
			ePawn.Interaction.SetCollision(true);

		AIEvent.Reset();
		AIEvent.EventType		= AI_REVIVED;
		Group.AIEventCallBack(self, AIEvent);

	}

    function damageAttitudeTo(pawn Other, float Damage, class<DamageType> damageType,optional int PillTag)
    {
        m_LastStateName = 's_alert';

        Global.damageAttitudeTo(Other,  Damage,  damageType);
    }


begin:
		
	//be sure to set back the physic
	//ePawn.LoopAnimOnly(Epawn.ARecover,,0.2);
    m_LastStateName = 's_Investigate'; //be sure to not go back in unconscious

	ePawn.CurrentYawDiff = 0;
	SetTimer(1.0f, false);
	ePawn.SetCollision(false,false,false);
    

    if (!ePawn.bKeepNPCAlive)          // This lets the NPC up on its feet real quick for E3 resets in DemoX
    {
	    ePawn.PlayAnimNoMovement(ePawn.ARecover,,0.4);		
	    FinishAnim();
    }
    else
    {
        Timer();
    }

	GotoState('s_Investigate');
}


// ----------------------------------------------------------------------
// state s_Inert
// ----------------------------------------------------------------------
state s_Inert
{
	Ignores SeePlayer, HearNoise, KilledBy, NotifyBump, GotoStateSafe, damageAttitudeTo;

	event AnimEnd(int Channel)
	{
		ePawn.AnimEnd(Channel);
	}

	function BeginState()
	{
		EchelonLevelInfo(Level).SendMusicRequest(0,false,Pattern);
		EchelonLevelInfo(Level).SendMusicRequest(1,false,Pattern);

		bPlayerSeen = false;			// no need to call UpdatePlayerLocation, just set this to false
		bNotResponsive = true;			// either dead or unconscious, no longer respond to / search for stimuli

		if ((ePawn.HandItem != none) && (ePawn.HandItem == ePawn.CurrentWeapon) && (GetStateName() != 's_Dead'))
		{
			ePawn.CurrentWeapon.StopLoopSound();
		}

		//reset goal list
		//LastGoalStatus = -1;
		m_pGoalList.Reset();

		LockedSwitches.Remove(0, LockedSwitches.Length);

		ePawn.CurrentYawDiff = 0;

		UnlockNavPoint();				// unlock existing nav points

		ClearRoutes();					// clear the existing WeightedRoute array and the route cache

		DropSelectedItem(vect(0,0,0));	// drop ITEM if in hand (not weapons!)

		Interaction = none;				// drop any existing interactions - if not, and we are destroyed, the Interaction will be destroyed!!
	}
}


// ----------------------------------------------------------------------
// state s_Dead
// ----------------------------------------------------------------------
state s_Dead extends s_Inert
{
	function BeginState()
	{

        // Remove strategic point from EVolume if we died while using a strategic point
        RemoveStrategicPointFromVolume();

		Super.BeginState();

		bBlockJumpDetection = false;

		if (ePawn.bKilledByPlayer && !ePawn.bIsPlayerPawn && !bNotInStats)
		{
			if (ePawn.bIsDog)
			{
				if (bAllowKill)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKilledRequired");
				else
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKilled");
				
				// If this dog was previously injured, subtract from injured stat
				if (bWasInjured)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyInjured", -1);
					
				// If this dog was previously knocked out, subtract from knockout stat
				if (bWasKnockedOut)
				{
					if (bAllowKnockout)
						EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOutRequired", -1);
					else
						EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOut", -1);
				}
			}
			// Regular NPCs
			else if (ePawn.bHostile)
			{
				if (bAllowKill)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKilledRequired");
				else
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKilled");

				// If this NPC was previously injured, subtract from injured stat
				if (bWasInjured)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyInjured", -1);

				// If this NPC was previously knocked out, subtract from knockout stat
				if (bWasKnockedOut)
				{
					if (bAllowKnockout)
						EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOutRequired", -1);
					else
						EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOut", -1);
				}
			}
			else
			{
				if (bAllowKill)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianKilledRequired");
				else
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianKilled");

				// If this NPC was previously injured, subtract from injured stat
				if (bWasInjured)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianInjured", -1);

				// If this NPC was previously knocked out, subtract from knockout stat
				if (bWasKnockedOut)
				{
					if (bAllowKnockout)
						EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianKnockedOutRequired", -1);
					else
						EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianKnockedOut", -1);
				}
			}
		}

		if (m_LastStateName != 's_Carried' || (group != None && group.ScriptedPattern !=  None && group.bAlwaysKeepScriptedPattern))
		{
			AIEvent.Reset();
			AIEvent.EventType = AI_DEAD;

			if (Group != None)
				Group.AIEventCallBack(self, AIEvent);
		}

		if (m_pGoalList != None)
		{
			m_pGoalList.Reset();
			m_pGoalList.PopDefault();
		}

		// unlock any ladders or doors:
		
		if (CurrentGEID >= 0)
			UnlockLadder();		

		if (SpecialMoveDoor != none)
			LeavingDoorRadius();
		

		Group = None;

		//destroy the default pattern
		if (Pattern != None)
			Pattern.Destroy();
	}
}


// ----------------------------------------------------------------------
// state s_Unconscious
// ----------------------------------------------------------------------
state s_Unconscious extends s_Inert
{
	function BeginState()
	{
		Super.BeginState();

		bBlockJumpDetection = false;

		if (ePawn.bKnockedByPlayer && !ePawn.bIsPlayerPawn && !bWasKnockedOut && !bNotInStats)
		{
			// Special handling for dogs
			if (ePawn.bIsDog)
			{
				// Count dogs as enemy knockouts regardless of hostility
				if (bAllowKnockout)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOutRequired");
				else
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOut");
				bWasKnockedOut = true;
				
				// If this dog was previously injured, subtract from injured stat
				if (bWasInjured)
				{
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyInjured", -1);
					bWasInjured = false;
				}
			}
			// Regular NPCs
			else if (ePawn.bHostile)
			{
				if (bAllowKnockout)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOutRequired");
				else
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyKnockedOut");
				bWasKnockedOut = true;

				// If this NPC was previously injured, subtract from injured stat
				if (bWasInjured)
				{
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("EnemyInjured", -1);
					bWasInjured = false;
				}
			}
			else
			{
				if (bAllowKnockout)
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianKnockedOutRequired");
				else
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianKnockedOut");
				bWasKnockedOut = true;

				// If this NPC was previously injured, subtract from injured stat
				if (bWasInjured)
				{
					EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("CivilianInjured", -1);
					bWasInjured = false;
				}
			}
		}

		// unlock any ladders or doors:
		
		if (CurrentGEID >= 0)
			UnlockLadder();		
		
		else if (SpecialMoveDoor != none)
			LeavingDoorRadius();

		// only add to changed actor list if not by a door or ladder -- revival near these objects could be tricky..
		if (m_LastStateName != 's_Carried')
		{
			AIEvent.Reset();
			AIEvent.EventType = AI_UNCONSCIOUS;
			Group.AIEventCallBack(self, AIEvent);
		}

		if (Pattern != None)
		{
			Pattern.bDisableMessages = false;
			Pattern.GotoState('Idle');
		}
	}

	function EndState()
	{
		m_LastStateName = GetStateName();
	}

	// bring me back to life
	function Revive()
	{
		GotoState('s_Groggy');
	}
}

defaultproperties
{
    FA_StepSize=3
    CurrentGEID=-1
    FocusInfo=(YawInterpolationSpeed=25000.000000,YawMinOffset=4000.000000,YawMaxOffset=8000.000000,MinTurnSpeed=1.250000,MaxTurnSpeed=3.000000,SwitchTimeBase=1.200000,SwitchTimeOffset=0.750000)
}