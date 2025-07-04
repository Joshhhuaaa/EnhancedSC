//=============================================================================
// NavigationPoint.
//
// NavigationPoints are organized into a network to provide AIControllers 
// the capability of determining paths to arbitrary destinations in a level
//
//=============================================================================
class NavigationPoint extends Actor
	hidecategories(Lighting,LightColor,Force)
	native;

#exec Texture Import File=Textures\S_Pickup.pcx Name=S_Pickup Mips=Off MASKED=1 NOCONSOLE
#exec Texture Import File=Textures\SpwnAI.pcx Name=S_NavP Mips=Off MASKED=1 NOCONSOLE

// not used currently
#exec Texture Import File=Textures\SiteLite.pcx Name=S_Alarm Mips=Off MASKED=1 NOCONSOLE

//------------------------------------------------------------------------------
// NavigationPoint variables
var const array<ReachSpec> PathList; //index of reachspecs (used by C++ Navigation code)
var() name ProscribedPaths[4];	// list of names of NavigationPoints which should never be connected from this path
var() name ForcedPaths[4];		// list of names of NavigationPoints which should always be connected from this path
var int visitedWeight;
var const int bestPathWeight;
var const NavigationPoint nextNavigationPoint;
var const NavigationPoint nextOrdered;	// for internal use during route searches
var const NavigationPoint prevOrdered;	// for internal use during route searches
var const NavigationPoint previousPath;
var int cost;					// added cost to visit this pathnode
var() int ExtraCost;			// Extra weight added by level designer

var transient bool bEndPoint;	// used by C++ navigation code
var bool bSpecialCost;			// if true, navigation code will call SpecialCost function for this navigation point
var bool taken;					// set when a creature is occupying this spot
var() bool bBlocked;			// this path is currently unuseable 
var() bool bPropagatesSound;	// this navigation point can be used for sound propagation (around corners)
var() bool bOneWayPath;			// reachspecs from this path only in the direction the path is facing (180 degrees)
var() bool bNeverUseStrafing;	// shouldn't use bAdvancedTactics going to this point
var const bool bAutoBuilt;		// placed during execution of "PATHS BUILD"
var	bool bSpecialMove;			// if true, pawn will call SuggestMovePreparation() when moving toward this node
var bool bNoAutoConnect;		// don't connect this path to others except with special conditions (used by LiftCenter, for example)
var	const bool	bNotBased;		// used by path builder - if true, no error reported if node doesn't have a valid base
var const bool  bAutoPlaced;	// placed as marker for another object during a paths define
var const bool  bPathsChanged;	// used for incremental path rebuilding in the editor

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * Purpose : Special Navigation vars - ladder climbing / interaction / etc
// ***********************************************************************************************
var()	bool			bLadderPoint;
var()	bool			bCoverPoint;
var		bool			bDoorPoint;				// set in EDoorPoint class
var()	bool			bFindBaseOnBuild;		// if false, don't call FindBase during path build
var		bool			bIsLadderTop;			// true if this node is at the top of a ladder
var()	bool			bSearchPoint;			// true if this point should be chosen for search purposes
var()	bool			bHidePoint;				// true if NPCs should try to flee to this point (can also be used for motivating search points) 
var()   bool            bIgnoreAwarenessForAnim;// true if NPCs should not play an anim based on awareness for this NavPOint (in front of computer for example)
var()   bool            bDoNotUseAsHidePoint;
var		int				LadderID;				// ladder ID associated with this Nav Point (if any)
var		float			LastTimeCalculated;
var		float			LastTimeUsed;			// Last time we used that point as Search point


var(Patrol) editinline	EPatrolInfo				Patrol;							// Patrol Information
var(Patrol)				MoveFlags				m_ForcedMoveFlag;				// WHILE MOVING TO : use this moveflag, MOVE_NotSpecified is default
var(Patrol)				MoveFlags				m_ForcedWaitFlag;				// WHEN AT, and using as Cover Point : use this waitflag, MOVE_NotSpecified is default

// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

event int SpecialCost(Pawn Seeker);

// Accept an actor that has teleported in.
// used for random spawning and initial placement of creatures
event bool Accept( actor Incoming, actor Source )
{
	// Move the actor here.
	taken = Incoming.SetLocation( Location );
	if (taken)
	{
		Incoming.Velocity = vect(0,0,0);
		Incoming.SetRotation(Rotation);
	}
	Level.Game.PlayTeleportEffect(Incoming, true, false);
	TriggerEvent(Event, self, Pawn(Incoming));
	return taken;
}

/* SuggestMovePreparation()
Optionally tell Pawn any special instructions to prepare for moving to this goal
(called by Pawn.PrepareForMove() if this node's bSpecialMove==true
*/
event bool SuggestMovePreparation(Pawn Other)
{
	return false;
}

/* ProceedWithMove()
Called by Controller to see if move is now possible when a mover reports to the waiting
pawn that it has completed its move
*/
function bool ProceedWithMove(Pawn Other)
{
	return true;
}

/* MoverOpened() & MoverClosed() used by NavigationPoints associated with movers */
function MoverOpened();
function MoverClosed();

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * Purpose : Special Navigation events and functions
// ***********************************************************************************************

//----------------------------------------[David Kalina - 9 Feb 2001]-----
// 
// Description
//      Using designer specified Tags, sets next NavigationPoint in sequence.
//      And makes sure it knows we are the previous NavigationPoint.
// 
//------------------------------------------------------------------------

function PostBeginPlay()
{
    local NavigationPoint pCurrentPoint;
	local int i;

	if(bCoverPoint)
	{
		SetCollisionSize(250.0f, 100.0f);
		SetCollision(true);
	}

	if (Patrol != none)
	{
		for (i = 0; i < Patrol.m_sNextPatrolPointTag.Length; i++)
		{
			if ( Patrol.m_sNextPatrolPointTag[i] != '' )
			{
				foreach AllActors(class 'NavigationPoint', pCurrentPoint, Patrol.m_sNextPatrolPointTag[i])
				{
					if (pCurrentPoint.Patrol != none)
					{
						Patrol.m_pNext[i] = pCurrentPoint;
						Patrol.m_pNext[i].SetPreviousPatrolPoint(self);
					}
					else
						log("WARNING : NavigationPoint Tag " $ Tag $ " specified as part of Patrol Network, has NO EPatrolInfo");
				}
			}
		}
	}
}


//---------------------------------------[David Kalina - 25 Jul 2001]-----
// 
// Description
//		If a controller is waiting at this point,
//		trigger it so it knows to continue on its path
//		and clear our Patrol.m_WaitingController var.
// 
//------------------------------------------------------------------------

function Trigger( Actor other, Pawn EventInstigator, optional name InTag)		// UBI MODIF - DAK - added optional InTag parameter
{
	if (Patrol != none)
	{
		if (Patrol.m_WaitingController != none)
		{
			Patrol.m_WaitingController.Trigger( other, EventInstigator, Tag ); 
		}

		Patrol.m_WaitingController = none;
	}
}


//----------------------------------------[David Kalina - 9 Feb 2001]-----
// 
// Description
//      Sets link to previous patrol point in network.
//
// Input
//		_pPrevious : Reference to patrol point that has set us as its next in sequence
//
//------------------------------------------------------------------------

function SetPreviousPatrolPoint(NavigationPoint _pPrevious)
{
	local int i;

	if (Patrol != none)
	{
		Patrol.m_pPrevious[Patrol.m_pPrevious.Length] = _pPrevious;
	}	
}




//---------------------------------------[David Kalina - 12 Mar 2001]-----
// 
// Description
//      Return next patrol point in network.
//      Will reverse 'direction' of network if it is non-circular and
//      we have reached the end.
//
// Input 
//		if bNoReverse is true, return nothing upon reaching the end of a one-way patrol
//		currently used for test GetNext calls from navigation code
//
//------------------------------------------------------------------------

event NavigationPoint GetNext(optional bool bNoReverse)
{
	if (Patrol != none) 
	{
		// IF WE ARE MOVING FORWARDS ..
		if  (!Patrol.m_bPatrolBackwards)
		{
			if  (Patrol.m_pNext.Length > 0)
			{
				// choose randomly from dynarray
				return Patrol.m_pNext[ rand(Patrol.m_pNext.Length) ];
			}
			else
			{				
				if ( bNoReverse )
					return none;

				// at path's end .. reverse our direction
				SetAllPatrolDirections(true);

				return Patrol.m_pPrevious[ rand(Patrol.m_pPrevious.Length) ];
			}
		}

		// GOING BACKWARDS 
		else 
		{
			if  (Patrol.m_pPrevious.Length > 0)
			{
				return Patrol.m_pPrevious[ rand(Patrol.m_pPrevious.Length) ];
			}
			else
			{
				if ( bNoReverse )
					return none;

				// reverse our direction
				SetAllPatrolDirections(false);

				return Patrol.m_pNext[ rand(Patrol.m_pNext.Length) ];
			}
		}
	}
}


//----------------------------------------[David Kalina - 3 Aug 2001]-----
// 
// Description
//		Perhaps called when Goal_Patrol fails because a path is
//		blocked ..?  
// 
//------------------------------------------------------------------------

function ReverseDirection()
{
	if (Patrol.m_bPatrolBackwards)
		SetAllPatrolDirections(false);
	else
		SetAllPatrolDirections(true);
}


//---------------------------------------[David Kalina - 12 Mar 2001]-----
// 
// Description
//      Should be called from terminal point in non-circular path.
//      Iterates through all members of path in given direction and
//      sets their m_bPatrolBackwards value to represent same dir.
//
//		Note : With dynamic array addition, it may not propagate through
//		the whole network.  But when we go backwards on a patrol path,
//		we will likely take the same path - when we end up at the start
//		node, the rest of the network should receive this message.
//
// Input
//		_isBackwards : desired value of m_bPatrolBackwards
//
//------------------------------------------------------------------------

function SetAllPatrolDirections(bool _isBackwards)
{
	local int i;
	
	if (Patrol != none)
	{
		// prevent against infinite recursion
		if (Patrol.m_bPatrolBackwards == _isBackwards)
			return;

		Patrol.m_bPatrolBackwards = _isBackwards;

		if (_isBackwards) 
		{
			for ( i = 0; i < Patrol.m_pPrevious.Length; i++ )
				Patrol.m_pPrevious[i].SetAllPatrolDirections(_isBackwards);
		}
		else
		{
			for ( i = 0; i < Patrol.m_pNext.Length; i++ )
				Patrol.m_pNext[i].SetAllPatrolDirections(_isBackwards);
		}
	}
}

// navigation points send touch events to Controllers
function touch(actor other)
{
	local Pawn myPawn;
	if ( other != none && other.bIsPawn )
	{
		myPawn = Pawn(other);
		
		if((myPawn.Controller != None) && (!myPawn.Controller.bIsPlayer))
			myPawn.Controller.touch(self);
	}
}

function untouch(actor other)
{
	local Pawn myPawn;
	if ( other != none && other.bIsPawn )
	{
		myPawn = Pawn(other);
		if((myPawn.Controller != None) && (!myPawn.Controller.bIsPlayer))
			myPawn.Controller.untouch(self);
	}
}
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************

defaultproperties
{
    bPropagatesSound=true
    bFindBaseOnBuild=true
    bStatic=true
    bHidden=true
    Texture=Texture'S_NavP'
    bCollideWhenPlacing=true
    CollisionRadius=80.000000
    CollisionHeight=100.000000
    bCollideWorld=true
    bIsNavPoint=true
}