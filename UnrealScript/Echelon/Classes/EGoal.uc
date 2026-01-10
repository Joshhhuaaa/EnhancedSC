//=============================================================================
// EGoal
//		Information representing Goal used by EAIControllers
//=============================================================================
class EGoal extends Actor
	native;


var		EchelonEnums.GoalType	m_GoalType;				// Type of goal

var		EGoal					Next;					// pointer to next goal in list


// data that can be used for executing different goaltypes

var		Vector					GoalLocation;			// typically movement destination
var		Vector					GoalFocus;				// vector representing what we're looking at / focusing on
var		Vector					GoalDirection;			// directional component of goal - can indicate a direction noise came in, etc..
var		Actor					GoalTarget;				// actor that represents our target
var		Actor					GoalSubject;			// actor representing something other than target (squad leader, defend location, etc.)
var		Name					GoalTag;
var		Sound					GoalSound;
var		Name					GoalAnim;
var		Name					GoalAnimB;
var		float					GoalTimer;				// used by goal execution functions for timing purposes
var		float					GoalValue;				// floating point value can be used for anything
var		MoveFlags				GoalMoveFlags;			// defines set of movement animations to used if goal requires movement
var		MoveFlags				GoalWaitFlags;			// move flags for waiting - when NPC stops moving, use these
var		bool					bInitialized;			// have I been initialized?
var		bool					GoalFlag;
var		bool					GoalFlagB;
var     bool					GoalUpdatePlayerPos;

var		byte					Priority;				// goal priority (0 = lowest, 10 = highest, can change if we need it to ..)



//---------------------------------------[David Kalina - 18 Apr 2001]-----
//
// Description
//		Clears / Re-initalizes a Goal by resetting its data
//
//------------------------------------------------------------------------
function Clear()
{
	GoalLocation	= vect(0,0,0);
	GoalFocus		= vect(0,0,0);
	GoalTarget		= none;
	GoalTag			= '';
	GoalSound		= none;
	GoalAnim		= '';
	GoalTimer		= 0.0f;
	GoalValue		= 0.0f;
	GoalMoveFlags	= MOVE_WalkNormal;		// most common movement (methinks)
	GoalWaitFlags   = MOVE_NotSpecified;
	GoalUpdatePlayerPos = false;

	bInitialized = false;
}

defaultproperties
{
    bHidden=True
}