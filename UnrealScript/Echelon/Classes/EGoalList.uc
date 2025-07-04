//=============================================================================
// EGoalList
//
//		Maintains list of Goals for an EAIController.
//		Extends Actor so we can display debug information.
//=============================================================================


class EGoalList extends Actor
	native;


var		EGoal					pHead;
var		EAIController			pOwner;




//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Accessor for currently active goal in list (the head).
//		Is this really necessary?
// 
//------------------------------------------------------------------------

event EGoal GetCurrent()
{
	return pHead;
}




//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Inserts goal G into this list based on priority.
//
// Input
//		G : Goal to insert.
//
//------------------------------------------------------------------------

function Insert( EGoal G )
{
	local EGoal tempGoal;

	// handle empty list
	if (pHead == none)
		pHead = G;

	// handle insertion of new head
	else if (G.Priority >= pHead.Priority)
	{
		tempGoal	= pHead;
		pHead		= G;
		pHead.Next	= tempGoal;

		///////////////////////////////////////////
		//adjust the default pattern if there's one
		if(EAIController(Owner) != None && EAIController(Owner).Pattern != None)
			EAIController(Owner).Pattern.AdjustDefaultPatternState(pHead.m_GoalType);
	}

	// call recursive insert if not base case
	else
		pHead.Next = PriorityInsert( G, pHead.Next );
}




//---------------------------------------[David Kalina - 13 Jun 2001]-----
// 
// Description
//		Searches the Goal List for a goal with EQUAL PRIORITY AND TYPE.
//		If it finds such a goal, it will replace it with this functions arg.
//
// Input
//		G : Updated Goal
//
// Output
//		T : update successful
//      F : no matching goal found
// 
//------------------------------------------------------------------------

function bool Replace( EGoal G )
{
	local EGoal tempGoal;

	// base case
	if (pHead == none)
		return false;

	// replace head of list?
	else if (pHead.Priority == G.Priority && pHead.m_GoalType == G.m_GoalType)
	{
		tempGoal = pHead;
		pHead	 = G;
	}

	// recurse through remainder of list
	return RecursiveReplace( G, pHead );	
}


//---------------------------------------[Frederic Blais - 13 Jun 2001]-----
// 
// Description
// 
//------------------------------------------------------------------------
function ReplaceDefaultGoal(EGoal G)
{
	local EGoal PrevGoal,CurGoal;

	// base case
	if (pHead == none)
		return;


	//force the priority to zero
	G.Priority = 0;

	//check one goal case
	if (pHead.Next == None)
	{
		pHead.Destroy();
		pHead=G;
	}
	else
	{
		PrevGoal = pHead;
		CurGoal  = pHead;

		//reach the default goal
		while (CurGoal.Next != None)
		{
			PrevGoal= CurGoal;
			CurGoal = CurGoal.Next;
		}
		
		//replace the default goal of the list AND destroy the older
		PrevGoal.Next = G;
		G.Next=None;
		CurGoal.Destroy();
	}
}


//---------------------------------------[David Kalina - 13 Jun 2001]-----
// 
// Description
//		First passed head of list - checks current Next pointer to see if 
//		it should be replaced. 
// 
//------------------------------------------------------------------------

function bool RecursiveReplace ( EGoal G, EGoal Current )
{
	local EGoal tempGoal;

	if ( Current.Next == none )
		return false;

	else if ( Current.Next.Priority == G.Priority && Current.Next.m_GoalType == G.m_GoalType )
	{
		// found a match
		tempGoal		= Current.Next;
		Current.Next	= G;
		G.Next			= tempGoal.Next;

		return true;
	}
	else
		return RecursiveReplace( G, Current.Next );
}




//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Recursive insertion of new Goal into list based on priority.
//		If newGoal's priority is greater than the currentGoal, 
//		we return newGoal. 
//
// Input
//		newGoal : the goal we are trying to insert
//		currentGoal : the goal we are presently comparing with
//
// Output
//		function EGoal : 
//
//------------------------------------------------------------------------

function EGoal PriorityInsert( EGoal newGoal, EGoal currentGoal )
{
	if (currentGoal == none)
		return newGoal;

	if (newGoal.Priority >= currentGoal.Priority)
	{
		newGoal.Next = currentGoal;
		return newGoal;
	}

	currentGoal.Next = PriorityInsert( newGoal, currentGoal.Next );
	return currentGoal;
}



//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Pops off the head of the list.  No deletion required,
//		as I believe garbage collection will handle it..
// 
//------------------------------------------------------------------------

function Pop()
{
	local EGoal temp;

	if(pHead != None)
	{
		//be sure to not remove the default goal
		if(pHead.Next != none)
		{

			temp = pHead;
			pHead = pHead.Next;
			temp.Destroy();

			if ( pHead.Next == none )
			{
				// popped to the default goal
				pHead.bInitialized = false;

				//reset NPC
				EAIController(Owner).m_vPrevDestination = vect(0,0,0);
                EAIController(Owner).EPawn.Anchor = None;
                EAIController(Owner).ClearRoutes(); 

			}


			///////////////////////////////////////////
			//adjust the default pattern if there's one
			//if(EAIController(Owner) != None && EAIController(Owner).Pattern != None)
			//	EAIController(Owner).Pattern.AdjustDefaultPatternState(pHead.m_GoalType);

		}
		else
		{
			//log("** Trying to POP the default goal - Operation aborted - Owner: "$pOwner$" **");
		}

		/*
		else
		{
			log("Default Goal can not be removed from AIController : " $ pOwner $ ".  Will replace with GOAL_Guard at current location.");

			pHead.Destroy();
			pHead = none;

			temp = Spawn(class'EGoal');  // new class'EGoal';

			temp.Clear();
			temp.m_GoalType		= GOAL_Guard;
			temp.Priority		= 1;
			temp.GoalLocation	= pOwner.EPawn.Location;
			temp.GoalMoveFlags	= MOVE_WalkNormal;

			Insert(temp);
		}
		*/
	}
	else
	{
		log("Warning: Trying to Pop a goal from an Empty list.");
	}		
}


//---------------------------------------[David Kalina - 23 Apr 2001]-----
//
// PopDefault
//
// Description: Remove the default goal
// 
//------------------------------------------------------------------------
function PopDefault()
{
	if(pHead.Next == none)
	{
		pHead.Destroy();
		pHead = none;
	}
}

//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Removes all BUT default goal (last goal in chain)
//
//------------------------------------------------------------------------
function Reset()
{
	if (pHead != none)
	{
		while (pHead.Next != none)
		{
			Pop();
		}
	}
}

function ResetBasics()
{
	local EGoal CurGoal, tmp, prec;

	if (pHead != none)
	{
		CurGoal =  pHead;
		prec = pHead;

		while (CurGoal != none)
		{
			if((CurGoal.Priority < 30) && (CurGoal.Next != None))
			{
				tmp = CurGoal;
				prec.Next = CurGoal.Next;
				CurGoal = CurGoal.Next;

				if( pHead == tmp)
					pHead = CurGoal;

				tmp.Destroy();
				
			}
			else
			{
				prec = CurGoal;
				CurGoal = CurGoal.Next;
			}
		}

		if ( pHead.Next == none )
		{
			// popped to the default goal
			pHead.bInitialized = false;
		}
	}
}

//---------------------------------------[Frederic Blais - 23 Apr 2001]-----
// 
// Description
//		Returns true if a goal with that specific priority is existing
//
//------------------------------------------------------------------------
function bool CheckGoalPriority(byte _priority)
{
	local EGoal CurGoal;


	if (pHead != none)
	{
		CurGoal = pHead;

		while (CurGoal != none)
		{
			if(CurGoal.Priority == _priority)
				return true;

			CurGoal = CurGoal.Next;
		}
	}

	return false;
}

//---------------------------------------[David Kalina - 23 Apr 2001]-----
// 
// Description
//		Uses ShowDebug exec statement to show info for current
//		ViewTarget
//
// Input
//		Canvas : 
//		YL : distance between lines
//		YPos : current y position
// 
//------------------------------------------------------------------------

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local EGoal Current;
	local string T, goalstring;
	local int i;

	Canvas.DrawColor.B = 255;	
	Canvas.DrawColor.R = 170;
	Canvas.DrawColor.G = 128;

	if (pHead == none)
	{
		Canvas.DrawText("Goal List -- Empty");
		return;
	}
	else
	{
		for (Current = pHead; Current != none; Current = Current.Next)
		{
			i++;

			T = "Goal #" $ i $ ":";

			// setup goalstring based on goal Type
			switch (Current.m_GoalType)
			{	
				case GOAL_Guard			: goalstring = "GOAL_Guard";			break;
				case GOAL_Defend		: goalstring = "GOAL_Defend";			break;
				case GOAL_Patrol		: goalstring = "GOAL_Patrol";			break;
				case GOAL_Action		: goalstring = "GOAL_Action";			break;
				case GOAL_MoveTo		: goalstring = "GOAL_MoveTo";			break;
				case GOAL_Search		: goalstring = "GOAL_Search";			break;
				case GOAL_QuickSearch	: goalstring = "GOAL_QuickSearch";		break;
				case GOAL_Wander		: goalstring = "GOAL_Wander";			break;
				case GOAL_Attack		: goalstring = "GOAL_Attack";			break;
				case GOAL_InteractWith	: goalstring = "GOAL_InteractWith";		break;
				case GOAL_Transmission	: goalstring = "GOAL_Transmission";		break;

				case GOAL_Wait			: goalstring = "GOAL_Wait";				break;

				case GOAL_Follow		: goalstring = "GOAL_Follow";			break;
				case GOAL_Attack_Follow : goalstring = "GOAL_Attack_Follow";    break;
				case GOAL_Charge		: goalstring = "GOAL_Charge";			break;
				case GOAL_MoveAndAttack : goalstring = "GOAL_MoveAndAttack";	break;
				case GOAL_Stop			: goalstring = "GOAL_Stop";				break;
				case GOAL_ThrowGrenade  : goalstring = "GOAL_ThrowGrenade";		break;
				case GOAL_SprayFire		: goalstring = "GOAL_SprayFire";		break;
				case GOAL_PlaceWallMine : goalstring = "GOAL_PlaceWallMine";	break;

				case GOAL_TEMP_1		: goalstring = "GOAL_TEMP_1";			break;
				case GOAL_TEMP_2		: goalstring = "GOAL_TEMP_2";			break;
				case GOAL_TEMP_3		: goalstring = "GOAL_TEMP_3";			break;
				case GOAL_TEMP_4		: goalstring = "GOAL_TEMP_4";			break;
			}

			T = T $ goalstring $ " Priority: " $ Current.Priority;
			
			switch (Current.GoalMoveFlags)
			{
				case MOVE_WalkRelaxed   : T = T @ "Move: WalkRelaxed";			break;
				case MOVE_WalkNormal	: T = T @ "Move: WalkNormal";			break;
				case MOVE_WalkAlert		: T = T @ "Move: WalkAlert";			break;
				case MOVE_JogAlert		: T = T @ "Move: JogAlert";				break;
				case MOVE_JogNoWeapon	: T = T @ "Move: JogNoWeapon";			break;
				case MOVE_CrouchWalk	: T = T @ "Move: CrouchWalk";			break;
				case MOVE_CrouchJog		: T = T @ "Move: CrouchJog";			break;
				case MOVE_Snipe			: T = T @ "Move: Snipe";				break;
				case MOVE_Search		: T = T @ "Move: Search";				break;
			}


			if (Current.GoalLocation != vect(0,0,0))
				T = T @ "Location: "	$ Current.GoalLocation;
			if (Current.GoalFocus != vect(0,0,0))
				T = T @ "Focus: "		$ Current.GoalFocus;
			if (Current.GoalTarget != none)
				T = T @ "Target: "		$ Current.GoalTarget;
			if (Current.GoalTag != '')
				T = T @ "Tag: "			$ Current.GoalTag;
			if (Current.GoalSound != none)
				T = T @ "Sound: "		$ Current.GoalSound; 
			if (Current.GoalAnim != '')
				T = T @ "Anim: "		$ Current.GoalAnim;
			if (Current.GoalValue > 0.0f)
				T = T @ "Value:  "		$ Current.GoalValue;
			
			T = T @ "Flag:  "			$ Current.GoalFlag;

						
			Canvas.DrawText(T, false);
			YPos += YL * 2;
			Canvas.SetPos(4,YPos);
		}
	}
}

defaultproperties
{
    bHidden=true
}