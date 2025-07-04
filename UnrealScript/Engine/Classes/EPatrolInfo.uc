//=============================================================================
//	EPatrolInfo
//
//	Info class for Patrol Points (referenced by NavigationPoints)
//
//=============================================================================


class EPatrolInfo extends Object
	native;



var(Patrol)		array<Name>				m_sNextPatrolPointTag;			// Tag name of next patrol point in network

var				array<NavigationPoint>	m_pNext;                        // reference to next patrol point in network
var				array<NavigationPoint>	m_pPrevious;                    // reference to previous patrol point in network

var(Patrol)		float					m_rSleepTime;                   // WHEN REACHED : how long we will pause at this waypoint (seconds)
var(Patrol)		Name					m_FocusTag;						// WHILE MOVING TO : tag of object to use as focus
var(Patrol)		Sound					m_PatrolSound;					// WHEN REACHED : sound to play 
var(Patrol)		Name					m_PatrolAnim;					// WHEN REACHED : animation to play 
var(Patrol)		float					m_WaitForTriggerTime;			// WHEN REACHED : sleep for this long OR until Patrol Point receives a Trigger Event
var(Patrol)		Name					m_GroupTag;
var(Patrol)		Name					m_JumpLabel;
var(Patrol)     Name                    m_SyncSig;

var				Controller				m_WaitingController;			// set by controller when reached if m_WaitForTrigger != ''

// keep bools packed!
var				bool					m_bPatrolBackwards;             // are we navigating a non-circular patrol network in reverse?
var(Patrol)     bool                    m_bWasANavPoint;                // Used in Patrol Tool when deleting a patrol network     
var(Patrol)     bool                    m_bUseAsCheckPoint;             // Do we use m_WaitForTriggerTime as check point
var(Patrol)     bool                    m_bNoStrictWaitFocus;           // if true, don't use target as strictfocus

var(Patrol)		float					m_RandomStopPercentage;			// WHEN REACHED : how likely [0..1] we are to stop at this nav point
var(Patrol)		Name					m_WaitFocusTag;					// WHEN REACHED : tag of object to use as focus
var				Mover					m_pPassThroughMover;			// If patrol next tag passes through a mover (EDoorMover specifically), save reference here

defaultproperties
{
    m_bWasANavPoint=true
}