class EStickyCameraGoalVolume extends EVolume;

var() EGameplayObject GoalObject;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( GoalObject == None )
		Log("ERROR: GoalObject is None for GoalVolume"@self);

	if( GoalObject.GroupAI == None )
		Log("ERROR: GoalObject's GroupAI is None for GoalVolume"@self@GoalObject);

	if( GoalObject.JumpLabel == '' )
		Log("ERROR: GoalObject's JumpLabel is '' for GoalVolume"@self@GoalObject);
}

//------------------------------------------------------------------------
// Description		
//		Wrapper to deactivate the volume after goal completed
//------------------------------------------------------------------------
function TriggerGoal()
{
	GoalObject.TriggerPattern();
	GoalObject = None;

	SetCollision(false);
}


