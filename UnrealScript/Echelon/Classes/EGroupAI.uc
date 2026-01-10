//=============================================================================
// EGroupAI
//
// Group AI Object
// Manages / Coordinates the behaviors of its members
//
//=============================================================================


class EGroupAI extends Actor
	placeable
    native;


#exec Texture Import File=..\Engine\Textures\Echelon\GroupAI.pcx Name=GroupAI Mips=Off Flags=2 NOCONSOLE

struct CheckPointInfo
{
    var EAIController   oController;
    var float           fPatrolCheckPointTimeOut;
};


var()  class<EPattern>   ScriptedPatternClass;
var()  bool				 bEventExclusivity;
var()  bool				 bAlwaysKeepScriptedPattern;
var()  bool				 bInternEventsTriggerDefault;
var    bool				 bExternEventWasSent;
var    bool				 bIsPrimary;
var    bool		         bInitPatterns;
var    bool				 bDestroyScriptedEventAfterEnd;
var    bool              bPlayerDeadSent;
var    bool              bLostPlayerSent;
var    bool	             bGroupRunningForAlarm;
var    bool              bChangeHistory_Init;

var()  bool				 PlayFisherMusic;
var()  bool				 bDontMirrorAttack;

var EPattern      ScriptedPattern;

var ESList		 AIMembers;
var int			 MemberNb;
var EZoneInfo	 LastZoneUsed;
var EAlarm		 CurrentAlarm;

var array<AIEvent>		EventList;


var EPlayerController Player;
var EVolume			  CurrentPlayerVolume;

var() float		DelayBetweenGrenades;
var   float		CurrentGrenadeTimer;
var   float     fSeeInterrogationTimer;

var array <CheckPointInfo> arCheckPointTimers;

struct EChangeEvent
{
    var EChangeType Type;
    var Vector      Location;
    var float       Time;
};

var EChangeEvent                ChangeHistory[16];
var float                       ChangeHistory_LastChangeBark;
var float                       ChangeHistory_PrevChangeBark;

var(Enhanced) bool bPlayerIdentifiedCounted;

native(1418) final function Broadcast(EAIController Instigator,BroadCastType _BCType, Vector _EventLocation, optional bool bOnlyRadio);

native(1550) final function int ChangeHistory_AddChangeAndSuggestBehavior(Vector Location, EChangeType ChangeType);


//--------------------------------------------------[Frederic Blais]-----
//
// Description
//
//
//------------------------------------------------------------------------
function PreBeginPlay()
{
	AIMembers = new class'ESList';
}

//--------------------------------------------------[Frederic Blais]-----
//
// Description
//
//
//------------------------------------------------------------------------
function ResetGrenadeTimer()
{
	CurrentGrenadeTimer = DelayBetweenGrenades;
}

//---------------------------------------[David Kalina - 30 Jul 2001]-----
//
// Description
//		Set default patterns if necessary.
//
//------------------------------------------------------------------------
function PostBeginPlay()
{
	if (ScriptedPatternClass != None)
	{
		//create the scripted pattern / made by the Pattern Editor
		ScriptedPattern	= Spawn(ScriptedPatternClass, self);

		//set exclusivity flag
		ScriptedPattern.bEventExclusivity = bEventExclusivity;

		//log("ScriptedPatternClass created... "$ScriptedPattern);
	}

	Player =  EchelonGameInfo(Level.Game).pPlayer;
	bPlayerIdentifiedCounted = false;
}


//---------------------------------------[David Kalina - 28 Mar 2001]-----
//
// Description
//      Add _AI to my AIMembers list, without prejudice.
//
//------------------------------------------------------------------------
function AddAIMember(EAIController _AI)
{
	local EListNode Node;
	local bool bFound;

	bFound = false;

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		if (EAIController(Node.Data) == _AI)
		{
			bFound = true;
		}

		Node = Node.NextNode;
	}

	if (!bFound)
	{
		//	log("NPC: "$_AI$" added to group: "$self);
		AIMembers.InsertAtEnd(_AI);
		MemberNb++;
	}
}

//--------------------------------------------------[Frederic Blais]-----
// RequestPatternChange
//
// Description: Called from a pattern trigger to start a srcipted pattern.
//
//------------------------------------------------------------------------
function RequestPatternChange(class<EPattern> PatternClass, bool EventEx)
{
	bDestroyScriptedEventAfterEnd = true;

	if (ScriptedPattern != None)
	{
		ScriptedPattern.StopPattern();
		ScriptedPattern.Destroy();
	}

	//set the new scripted pattern
	ScriptedPattern	= spawn(PatternClass,self);

	//set the flag
	ScriptedPattern.bEventExclusivity = EventEx;

	ScriptedPattern.Assign(AIMembers,None);
	ScriptedPattern.StartPattern();
}


//--------------------------------------------------[Frederic Blais]-----
// SendJumpEvent
//
// Description: Jump to a specific label in the current scripted event
//
//------------------------------------------------------------------------
function bool CheckDefaultPatternState()
{
	local EListNode Node;
	local EAIController	C;

	//Init default patterns
	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		C = EAIController(Node.Data);

		if (C.Pattern.GetStateName() != 'Idle')
			return false;

		Node = Node.NextNode;
	}

	return true;
}


//--------------------------------------------------[Frederic Blais]-----
// IsAMemberInAttack
//
//
//------------------------------------------------------------------------
function bool IsAMemberInAttack()
{
	local EListNode Node;
	local EAIController	C;

	//Init default patterns
	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		C = EAIController(Node.Data);

		if ((C != None) && (C.Pattern != None) && (C.Pattern.GetStateName() == 'Attack'))
        {
			return true;
        }

		Node = Node.NextNode;
	}

	return false;
}

//--------------------------------------------------[Frederic Blais]-----
// SetDefaultPattern
//
// Description:
//
//------------------------------------------------------------------------
function SetDefaultPattern()
{
	local EListNode Node;
	local EAIController	C;

	//Init default patterns
	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		C = EAIController(Node.Data);
		if (C.Pattern.GetStateName() != 'Idle')
		{
			C.Pattern.bDontResetMusic = true;
		}
		C.Pattern.GotoState('Idle');
		C.Pattern.bDisableMessages = false;
		C.Pattern.ResetGoals(1);

		Node = Node.NextNode;
	}

}

//--------------------------------------------------[Frederic Blais]-----
// SendJumpEvent
//
// Description: Jump to a specific label in the current scripted event
//
//------------------------------------------------------------------------
event SendJumpEvent(name LabelName,bool bAffectLastZone, bool bForceJump)
{
	if (ScriptedPattern == None)
	{
		//check all the patterns of members of the group are in Idle state
		if (CheckDefaultPatternState())
		{
			//check if we can spawn the pattern class again
			if (ScriptedPatternClass != None)
			{
				//create the scripted pattern / made by the Pattern Editor
				ScriptedPattern	= Spawn(ScriptedPatternClass, self);

				//set exclusivity flag
				ScriptedPattern.bEventExclusivity = bEventExclusivity;

				//ScriptedPattern.Assign(None,C);
				ScriptedPattern.InitPattern();

			}
		}
	}

	// Check if we have a scripted pattern
	if (ScriptedPattern != None)
	{
		if (bAffectLastZone)
			ScriptedPattern.LastZoneTouched = LabelName;

        if ((!ScriptedPattern.bDisableEventTrigger) || (bForceJump))
        {
		    ScriptedPattern.EventJump(LabelName);
        }
	}
}

//--------------------------------------------------[Frederic Blais]-----
// UpdateGoalState
//
// Description: Update the last goal that was running.
//
// Status:
// AI_GOAL_COMPLETE : Goal completed.
// AI_GOAL_FAILURE: Goal failed.
//
// The status are is used by default patterns. To be more specific by the
// latent function WaitForGoal().
//
//------------------------------------------------------------------------
function UpdateGoalState(EAIController Instigator, int Status)
{
	local EGoal Goal;

	//check if we are waiting for that goal
	Goal = Instigator.m_pGoalList.GetCurrent();

	//now the variable bGoalCompleted is just a variable of the aicontroller
	Instigator.LastGoalType   = Goal.m_GoalType;
	Instigator.LastGoalStatus = Status;
}

//--------------------------------------------------[Frederic Blais]-----
// ResetGoals
//
// Description:
//
//------------------------------------------------------------------------
function ResetGoals()
{
	local EListNode Node;

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		EAIController(Node.Data).LastGoalStatus = -1;
		EAIController(Node.Data).LastGoalType = GOAL_TEMP_2;
		EAIController(Node.Data).m_pGoalList.Reset();
		Node = Node.NextNode;
	}

}


//--------------------------------------------------[Frederic Blais]-----
// PlayerIsVisible
//
// Description: check If one member can see the player
//
//------------------------------------------------------------------------
event bool PlayerIsVisible()
{
	local EListNode Node;

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		if (EAIController(Node.Data).bPlayerSeen)
			return true;

		Node = Node.NextNode;
	}

	return false;
}

//--------------------------------------------------[Frederic Blais]-----
// CheckLastKnownPlayerTime
//
// Description:
//
//------------------------------------------------------------------------
function bool CheckLastKnownPlayerTime(float DeltaTime)
{
	local EListNode Node;

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		if ((Level.TimeSeconds - EAIController(Node.Data).LastKnownPlayerTime) <= DeltaTime)
		{
			return true;
		}

		Node = Node.NextNode;
	}

	return false;
}

event GetMostRecentPlayerInfo(out float BestTime, out vector PlayerPos)
{
	local EListNode Node;

	Node = AIMembers.FirstNode;
	BestTime  = EAIController(Node.Data).LastKnownPlayerTime;
	PlayerPos = EAIController(Node.Data).LastKnownPlayerLocation;

	while (Node != None)
	{
		if (EAIController(Node.Data).LastKnownPlayerTime > BestTime)
		{
			BestTime = EAIController(Node.Data).LastKnownPlayerTime;
			PlayerPos = EAIController(Node.Data).LastKnownPlayerLocation;
		}

		Node = Node.NextNode;
	}
}

//--------------------------------------------------[Frederic Blais]-----
// PlayerHasBeenSeen
//
// Description:
//
//------------------------------------------------------------------------
function bool PlayerHasBeenSeen()
{
	local EListNode Node;

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		if ((EAIController(Node.Data).TimePlayerFirstSeen != 0) &&
			(EAIController(Node.Data).TimePlayerFirstSeen < Level.TimeSeconds))
		{
			return true;
		}

		Node = Node.NextNode;
	}

	return false;
}


//--------------------------------------------------[Frederic Blais]-----
//
// Description: Get the closest member from a location
//
//
//------------------------------------------------------------------------
event EAIController GetClosestMember(vector _location, optional actor IgnoredActor, optional bool stopfiring)
{
	local EListNode Node;
	local EAIController AI;
	local float MinDist;

	Node = AIMembers.FirstNode;
	AI = EAIController(Node.Data);
	MinDist = VSize(AI.ePawn.Location - _location);

	while (Node != None)
	{

		if (stopfiring)
		{
			EAIController(Node.Data).bFiring = false;
		}

		if (VSize(EAIController(Node.Data).ePawn.Location - _location) < MinDist)
		{
			if (IgnoredActor != Node.Data)
			{
				MinDist = VSize(EAIController(Node.Data).ePawn.Location - _location);
				AI = EAIController(Node.Data);
			}
		}

		Node = Node.NextNode;
	}

	return AI;

}

//--------------------------------------------------[Frederic Blais]-----
//
// Description: Check if the actor is a member of the group
//
//
//------------------------------------------------------------------------
function bool IsAMember(Actor a)
{
	local EListNode Node;

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		if (Actor(Node.Data) == a)
			return true;

		Node = Node.NextNode;
	}

	return false;
}


//--------------------------------------------------[Frederic Blais]-----
//
//
//
//------------------------------------------------------------------------
function bool AllGroupLostPlayer(EAIController Instigator)
{
	local EListNode Node;
	local int i;

	i = 0;
	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		if ((EAIController(Node.Data).bPlayerSeen) && (Instigator != Actor(Node.Data)))
		{
			i++;
		}

		Node = Node.NextNode;
	}

	if (i == 0)
		return true;
	else
		return false;

}


//--------------------------------------------------[Frederic Blais]-----
//
//
//
//------------------------------------------------------------------------
function SendEnterZone()
{
	local EListNode Node;
	local int i;

	i = 0;
	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		//EAIController(Node.Data).Pattern.TriggerEvent.set(Event);
		//EAIController(Node.Data).Pattern.EventCallBack(AI.Pattern.TriggerEvent,AI);

		Node = Node.NextNode;
	}

}

function ProcessGroupLost()
{
	local EListNode Node;
	local int i;
	//local EAIEvent Event;
	local EAIController C,AI;

	i = 0;
	Node = AIMembers.FirstNode;

	//log("################################# GROUP LOST ##################################");

	//send the closest member
	AI = GetClosestMember(EAIController(Node.Data).eGame.pPlayer.EPawn.Location);

	//check if the character has a default pattern
	if (AI.Pattern == None)
		return;

	AI.AIEvent.Reset();
	AI.AIEvent.EventType = AI_GROUP_LOST_PLAYER;

	AI.Pattern.TriggerEvent.set(AI.AIEvent);
	AI.Pattern.EventCallBack(AI.Pattern.TriggerEvent,AI);


	while (Node != None)
	{
		C =  EAIController(Node.Data);

		C.AIEvent.Reset();
		C.AIEvent.EventType = AI_LOST_PLAYER_AFTER;

		if (AI != C)
		{
			  C.Pattern.TriggerEvent.set(C.AIEvent);
			  C.Pattern.EventCallBack(C.Pattern.TriggerEvent,C);
		}

		Node = Node.NextNode;
	}

}

//--------------------------------------------------[Frederic Blais]-----
// Tick
//
//
//------------------------------------------------------------------------
function Tick(float Delta)
{
	///////////////////////////////////////////////////
	//Initialize default patterns during the first tick
	if (!bInitPatterns)
	{
		InitPatterns();
		bInitPatterns = true;
	}
	//End of Init/////////////////////////////////////

	if (bDestroyScriptedEventAfterEnd)
	{
		if (ScriptedPattern != None)
		{
			if (!ScriptedPattern.bIsRunning)
			{
				//destroy the scripted pattern
				ScriptedPattern.Destroy();

				//reset pointer
				ScriptedPattern	= None;

				//reset the flag
				bDestroyScriptedEventAfterEnd = false;
			}
		}
	}

    // If there are check points to verify, do verification
    VerifyCheckPoints(Delta);

	//grenade timer
	if (CurrentGrenadeTimer > 0)
	{
		CurrentGrenadeTimer -= Delta;
	}
}


//--------------------------------------------------[Frederic Blais]-----
// Timer
//
// Description: Timer used for alarm situations.
//------------------------------------------------------------------------
function timer()
{
	//check to be sure that the group does'nt see the player
	if ((CurrentAlarm == None) && !PlayerIsVisible() && !CheckLastKnownPlayerTime(15.0f))
	{
		//change psychological to default for every members
		ChangeStates('s_default');
	}
}


//--------------------------------------------------[Frederic Blais]-----
// ChangeStates
//
// Description: Change state of every members
//
//------------------------------------------------------------------------
function ChangeStates(name State)
{
	local EListNode Node;
	local EAIController AI;

	//be sure to reset the Alarm timer
	SetTimer(0,false);

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		AI = EAIController(Node.Data);
		if (AI != none && AI.Pawn != none && AI.Pawn.Health > 0)
		{
			AI.GotoStateSafe(State);

			if (State == 's_default')
			{
				AI.Pattern.GotoState('idle');
				EchelonLevelInfo(Level).SendMusicRequest(0,false,AI.Pattern);
				EchelonLevelInfo(Level).SendMusicRequest(1,false,AI.Pattern);
			}

		}
		Node = Node.NextNode;
	}
}


//--------------------------------------------------[Frederic Blais]-----
// ResetDefaultPatternStates
//
// Description:
//
//------------------------------------------------------------------------
function ResetDefaultPatternStates()
{
	local EListNode Node;
	local EAIController AI;

	//be sure to reset the Alarm timer
	SetTimer(0,false);

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		AI = EAIController(Node.Data);
		if (AI != none && AI.Pawn != none && AI.Pawn.Health > 0)
			AI.Pattern.GotoState('idle');
		Node = Node.NextNode;
	}
}




//--------------------------------------------------[Frederic Blais]-----
// StartAlarmBehavior
//
// Description: Start the primary behavior for each members of group.
//			    This function is called only if we are a PRIMARY group on
//				a alarm call.
//
//------------------------------------------------------------------------
function StartAlarmBehavior(EAIEvent Event,optional bool bForceUpdatePos)
{
	local EListNode Node;

	Node = AIMembers.FirstNode;

	//set that an extern event was sent
	bExternEventWasSent = true;

	while (Node != None)
	{
		if (!EAIController(Node.Data).bNotResponsive)
		{
			if (bForceUpdatePos && (EchelonGameInfo(Level.Game).pPlayer.Pawn != None))
			{
				EAIController(Node.Data).UpdatePlayerLocation(EchelonGameInfo(Level.Game).pPlayer.Pawn, false, true);
			}

			EAIController(Node.Data).Pattern.bDisableMessages = false;
			EAIController(Node.Data).Pattern.bRunningAlarm = false;

			EAIController(Node.Data).Pattern.TriggerEvent.set(Event);
			//start the alarm behavior for the pattern of that member
			EAIController(Node.Data).Pattern.GotoPatternLabel('AlarmBegin');
			EAIController(Node.Data).GotoStateSafe('s_Alert');
		}

		Node = Node.NextNode;
	}
}


function StopConversations()
{
	local EListNode Node;
	local EAIController AI;

	//be sure to reset the Alarm timer
	SetTimer(0,false);

	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		AI = EAIController(Node.Data);
		if (AI != none  && AI.ePawn.Interaction != None)
		{
			if (ENpcZoneInteraction(AI.ePawn.Interaction) != None)
			{
				if (ENpcZoneInteraction(AI.ePawn.Interaction).ConversationPattern != None)
				   ENpcZoneInteraction(AI.ePawn.Interaction).ConversationPattern.StopPattern(true);
			}
		}

		Node = Node.NextNode;
	}

}


//--------------------------------------------------[Frederic Blais]-----
// AIAlarmCallBack
//
// Description: This function is called by EAlarm object when an alarm
//				trigger happens. The group can respond as PRIMARY or as
//				SECONDARY. When an alarm is turned off the group receives
//				AI_ALARM_OFF. That will force secondary groups to switch in
//				default state after a 30 seconds delay. Primary groups do like
//				nothing happened ... I mean they continu to respond to the
//				alarm call.
//
// PRIMARY: The group will CHARGE at player position. Member's state = ALERT
// SECONDARY: Member's state = ALERT
//------------------------------------------------------------------------
event AIAlarmCallBack(EAlarm A, EAIEvent Event, optional bool bForceUpdatePos)
{

	//check if a scripted pattern is running
	if (ScriptedPattern != none)
	{
		//send back the alarm event to the pattern
		ScriptedPattern.TriggerEvent.set(Event);
		ScriptedPattern.EventCallBack(ScriptedPattern.TriggerEvent,None);

		if (ScriptedPattern.bEventExclusivity)
			return;
	}

	////////////////////////////////////////////////////////////////////
	//process ALARM event

	//be sure to kill the scripted pattern
	EndScriptedPattern();

	switch (Event.EventType)
	{
		case AI_ALARM_ON_PRIMARY:
			//start alert Pattern at ALARM label
			CurrentAlarm = A;
			bGroupRunningForAlarm = false;

			//check to stop all conversations running
			StopConversations();

			//check to be sure that the group is not already attacking the player
			if (!PlayerIsVisible())
			{
				//jump at the alarmBegin in members patterns
				StartAlarmBehavior(Event,bForceUpdatePos);
			}

			bExternEventWasSent = true;
			bIsPrimary = true;
			break;
		case AI_ALARM_ON_SECONDARY:
			//change states to ALERT state for group members only
			CurrentAlarm = A;
			ChangeStates('s_Alert');
			bIsPrimary = false;
			break;
		case AI_ALARM_UPDATE_POSITION:
			break;
		case AI_ALARM_OFF:
			//reset the alert state for secondary groups after 30 seconds
			CurrentAlarm = None;

			if (!bIsPrimary)
				SetTimer(30,false);
			break;
		default:
			break;
	}
}

//--------------------------------------------------[Frederic Blais]-----
// ProcessDead
//
// Description: Remove the member from the member list.
//
//------------------------------------------------------------------------
function ProcessDead(EAIController Instigator)
{
	if (Instigator != None)
	{
	//remove that member from the group
	AIMembers.Remove(Instigator);

	//check if the NPC is dead
		if ((Instigator.Pawn != None) && (Instigator.Pawn.Health <= 0) && (!Instigator.ePawn.bKeepNPCAlive))
	{
		//AI_DEAD
		//destroy the default pattern
		if (Instigator.Pattern != None)
			Instigator.Pattern.Destroy();

	}
	else
	{
		//AI_UNCONSCIOUS - AI_GRABBED
		//reset the state of the default pattern
		if (Instigator.Pattern != None)
			Instigator.Pattern.GotoState('idle');

	}
	}

	//eventually we have to check if the group is empty
	//TODO
}


//--------------------------------------------------[Frederic Blais]-----
// InitPatterns
//
// Description: Init all basic patterns of the members.
//
//------------------------------------------------------------------------
function InitPatterns()
{
	local EListNode Node;
	local EAIController	C;

	//Check if the group is controlled by a scripted pattern
	if (ScriptedPattern != none)
	{
		//ScriptedPattern.Assign(None,C);
		ScriptedPattern.InitPattern();
	}

	//Init default patterns
	Node = AIMembers.FirstNode;

	while (Node != None)
	{
		C = EAIController(Node.Data);

		//spawn the default pattern - FBlais
		C.Pattern = spawn(C.ePawn.BasicPatternClass,self);

		if (C.Pattern != None)
		{
			C.Pattern.Assign(None,C);
			C.Pattern.InitPattern();
		}

		Node = Node.NextNode;
	}
}

/*-----------------------------------------------------------------------------
 Function:      VerifyCheckPoints

 Description:   For each group member, verify if member had set a checkpoint and
                is is failing it
-----------------------------------------------------------------------------*/
function VerifyCheckPoints(float Delta)
{
 local int           iCounter;
    local int           iCounter2;

    local EListNode     oNode;
	local EAIController oController;



    for (iCounter = 0; iCounter < arCheckPointTimers.Length; iCounter++)
    {
        arCheckPointTimers[iCounter].fPatrolCheckPointTimeOut -=  Delta;

        if (arCheckPointTimers[iCounter].fPatrolCheckPointTimeOut < 0)
        {
            // We need to find a non-dead/non-unconscious co-group member to send AI_PATROL_TIMEOUT msg
            // TODO: when heartbeat code is code, leader or dispatcher should the one sending msg
            for (oNode = AIMembers.FirstNode; oNode != None; oNode = oNode.NextNode)
            {
                oController = EAIController(oNode.Data);

                if (oController != None)
                {
                    if (IsAMember(oController))
                    {
                        break;
                    }
                }
            }

            if (oController != None)
            {
                // Send message
                // send AIEvent to GroupAI
                oController.AIEvent.Reset();
                oController.AIEvent.EventType = AI_PATROL_TIMEOUT;
                oController.AIEvent.EventLocation = oController.EPawn.Location;
                oController.AIEvent.EventTarget = oController.EPawn;
                AIEventCallBack(oController, oController.AIEvent);

                // Remove from arCheckPointTimers
                log("Remove from arCheckPointTimers ");
                arCheckPointTimers.remove(iCounter, 1);

                // cant continue iterating if we removed
                // Destroy oEvent?
            }
            return;


        }
    }
}

/*-----------------------------------------------------------------------------
 Function:      AddOrUpdateCheckPoint

 Description:   Add or updates a CheckPoint in arCheckPointTimers
-----------------------------------------------------------------------------*/
event AddOrUpdateCheckPoint(EAIController oController,  float fPatrolCheckPointTimeOut)
{
    local CheckPointInfo    oNewCPI;
    local int               iCounter;


    // Verify if we are updating the timer
    for (iCounter = 0; iCounter < arCheckPointTimers.Length; iCounter++)
    {
        if (arCheckPointTimers[iCounter].oController == oController)
        {
            // Update timer
            arCheckPointTimers[iCounter].fPatrolCheckPointTimeOut = fPatrolCheckPointTimeOut;
            return;
        }

    }

    // We are not updating a timer, we are adding a new timer
    oNewCPI.oController = oController;
    oNewCPI.fPatrolCheckPointTimeOut = fPatrolCheckPointTimeOut;

    arCheckPointTimers[arCheckPointTimers.Length] = oNewCPI;
}

//--------------------------------------------------[Frederic Blais]-----
// EndScriptedPattern
//
// Description:
//
//------------------------------------------------------------------------
event EndScriptedPattern()
{
	if (ScriptedPattern != None)
	{
        /*// MClarke : July 30th 2002
        // Reset Goals given by scripted pattern
        if (ScriptedPattern.bIsRunning)
        {
            ScriptedPattern.ResetGroupGoals();
        }*/

        // Force closing the speech set
        ScriptedPattern.Close();
		ScriptedPattern.End();

		if (!bAlwaysKeepScriptedPattern)
		{

			ScriptedPattern.Destroy();
			ScriptedPattern = None;
		}

		// Reset the flag
		bDestroyScriptedEventAfterEnd = false;
	}
}

//--------------------------------------------------[Frederic Blais]-----
// checkInterrogation
//
// Description:
//
//------------------------------------------------------------------------
function checkInterrogation(EAIController Instigator, EAIEvent Event)
{
	switch (Event.EventType)
	{
	case AI_SEE_PLAYER_SURPRISED:
	case AI_SEE_PLAYER_ALERT:
    case AI_SEE_PLAYER_AGAIN:

		//check if the player is grabbing a NPC
		if (((Instigator.eGame.pPlayer.GetStateName() == 'S_Grab') || (Instigator.eGame.pPlayer.GetStateName() == 'S_GrabTargeting'))
            && (fSeeInterrogationTimer < (Level.TimeSeconds - 7.0f)))
		{
            fSeeInterrogationTimer = Level.TimeSeconds;
			Event.EventTarget = Instigator.eGame.pPlayer.m_AttackTarget.controller;
			Event.EventType   = AI_SEE_INTERROGATION;
			log("GroupAI - AI_SEE_INTERROGATION "$Event.EventTarget);

		}

		break;
	default:
		break;
	}

}

//--------------------------------------------------[Frederic Blais]-----
// AIEventCallBack
//
// Description: Main message loop of the groupAI
//
//------------------------------------------------------------------------
event AIEventCallBack(EAIController Instigator, EAIEvent Event)
{
	local AIEvent E;
	local string S;
	local bool 	SendToCallBack, bForceInternEvent;
	local ENpcZoneInteraction C;
	local EAIController AI;
	local EchelonLevelInfo LInfo;

	//check for disabled AI
	/*if (Instigator.ePawn.bDisableAI && (Instigator.ePawn.LastRenderTime < Level.TimeSeconds - 1.0f))
	{
		return;
	}*/

	//init the flag
	SendToCallBack = false;
	bForceInternEvent = false;

	//ignored changed actors added by one member of the group
	if (Event.EventType == AI_SEE_CHANGED_ACTOR)
	{
		//log("Event.EventTarget: "$Event.EventTarget$" Instigator: "$Event.EventTarget.Instigator$" Controller: "$Event.EventTarget.Instigator.controller);

		if (IsAMember(Event.EventTarget.Instigator.controller))
		{
			//log("ignored changed actors added by one member of the group");
			return;
		}
	}

    // Ignore Damage taken by turret

	//////////////////////////////////////////////////////////////////////////////////////
	// comment out to turn off ...
	switch (Event.EventType)
	{
        case AI_NONE                        : S = "AI_NONE"; break;
        case AI_INVESTIGATE                 : S = "AI_INVESTIGATE"; break;
        case AI_ATTACK                      : S = "AI_ATTACK"; break;
        case AI_EXTERN_EVENTS               : S = "AI_EXTERN_EVENTS"; break;
        case AI_SEE_NPC                     : S = "AI_SEE_NPC"; break;
        case AI_SEE_CHANGED_ACTOR           : S = "AI_SEE_CHANGED_ACTOR"; break;
        case AI_SEE_INTERROGATION           : S = "AI_SEE_INTERROGATION"; break;
        case AI_SEE_PLAYER_INVESTIGATE      : S = "AI_SEE_PLAYER_INVESTIGATE"; break;
        case AI_HEAR_SOMETHING              : S = "AI_HEAR_SOMETHING"; break;
        case AI_SMELL_SOMETHING             : S = "AI_SMELL_SOMETHING"; break;
        case AI_SHOT_JUST_MISSED            : S = "AI_SHOT_JUST_MISSED"; break;
        case AI_TAKE_DAMAGE                 : S = "AI_TAKE_DAMAGE"; break;
        case AI_SEE_PLAYER_SURPRISED        : S = "AI_SEE_PLAYER_SURPRISED"; break;
        case AI_SEE_PLAYER_ALERT            : S = "AI_SEE_PLAYER_ALERT"; break;
        case AI_INTERN_EVENTS               : S = "AI_INTERN_EVENTS"; break;
        case AI_GOAL_COMPLETE               : S = "AI_GOAL_COMPLETE"; break;
        case AI_GOAL_FAILURE                : S = "AI_GOAL_FAILURE"; break;
        case AI_DEAD                        : S = "AI_DEAD"; break;
        case AI_UNCONSCIOUS                 : S = "AI_UNCONSCIOUS"; break;
        case AI_REVIVED                     : S = "AI_REVIVED"; break;
        case AI_GRABBED                     : S = "AI_GRABBED"; break;
        case AI_RELEASED                    : S = "AI_RELEASED"; break;
        case AI_LOST_PLAYER                 : S = "AI_LOST_PLAYER"; break;
        case AI_LOST_PLAYER_AFTER           : S = "AI_LOST_PLAYER_AFTER"; break;
        case AI_SEE_PLAYER_AGAIN            : S = "AI_SEE_PLAYER_AGAIN"; break;
        case AI_UPDATE_SEARCH               : S = "AI_UPDATE_SEARCH"; break;
        case AI_SHOT_BLOCKED                : S = "AI_SHOT_BLOCKED"; break;
        case AI_STUCK                       : S = "AI_STUCK"; break;
        case AI_NEARLY_DEAD                 : S = "AI_NEARLY_DEAD"; break;
        case AI_WEAPON_INEFFECTIVE          : S = "AI_WEAPON_INEFFECTIVE"; break;
        case AI_LOW_AMMO                    : S = "AI_LOW_AMMO"; break;
        case AI_NO_AMMO                     : S = "AI_NO_AMMO"; break;
        case AI_PLAYER_FAR                  : S = "AI_PLAYER_FAR"; break;
        case AI_PLAYER_CLOSE                : S = "AI_PLAYER_CLOSE"; break;
        case AI_PLAYER_VERYCLOSE            : S = "AI_PLAYER_VERYCLOSE"; break;
        case AI_PLAYER_DEAD                 : S = "AI_PLAYER_DEAD"; break;
        case AI_UPDATE_STRATEGY_REQUEST     : S = "AI_UPDATE_STRATEGY_REQUEST"; break;
        case AI_ALARM_ON_PRIMARY            : S = "AI_ALARM_ON_PRIMARY"; break;
        case AI_ALARM_ON_SECONDARY          : S = "AI_ALARM_ON_SECONDARY"; break;
        case AI_ALARM_UPDATE_POSITION       : S = "AI_ALARM_UPDATE_POSITION"; break;
        case AI_ALARM_OFF                   : S = "AI_ALARM_OFF"; break;
        case AI_INTERROGATION_QUERY_NPC     : S = "AI_INTERROGATION_QUERY_NPC"; break;
        case AI_INTERROGATION_QUERY_SAM     : S = "AI_INTERROGATION_QUERY_SAM"; break;
        case AI_FORCED_RETINAL_SCAN         : S = "AI_FORCED_RETINAL_SCAN"; break;
        case AI_OUT_OF_DEFEND_RADIUS        : S = "AI_OUT_OF_DEFEND_RADIUS"; break;
        case AI_PATROL_TIMEOUT              : S = "AI_PATROL_TIMEOUT"; break;
        case AI_GET_DOWN                    : S = "AI_GET_DOWN"; break;
        case AI_COVERPOINT_TOUCHED          : S = "AI_COVERPOINT_TOUCHED"; break;
        case AI_COVER_LOST_PLAYER           : S = "AI_COVER_LOST_PLAYER"; break;
        case AI_GROUP_LAST_MEMBER           : S = "AI_GROUP_LAST_MEMBER"; break;
        case AI_GROUP_LOST_PLAYER           : S = "AI_GROUP_LOST_PLAYER"; break;
        case AI_GROUP_SEE_PLAYER_AGAIN      : S = "AI_GROUP_SEE_PLAYER_AGAIN"; break;
        case AI_MASTER_OUT_OF_RADIUS        : S = "AI_MASTER_OUT_OF_RADIUS"; break;
        case AI_HEAR_RICOCHET               : S = "AI_HEAR_RICOCHET"; break;
        case AI_COMMUNICATION_EVENTS        : S = "AI_COMMUNICATION_EVENTS"; break;
        case AI_ARE_YOU_OK                  : S = "AI_ARE_YOU_OK"; break;
        case AI_LET_HIM_GO                  : S = "AI_LET_HIM_GO"; break;
        case AI_MASTER_DEAD                 : S = "AI_MASTER_DEAD"; break;
	}

	if (S == "")
		log("GROUPAI RECEIVING Callback:  " $ Event.EventType @ " from AICONTROLLER(Pawn) : " $ Instigator.Pawn,,LPATTERN);
	else
		log("GROUPAI RECEIVING Callback:  " $ S @ " from AICONTROLLER(Pawn) : " $ Instigator.Pawn,,LPATTERN);

	//avoid greetings to break the scripted pattern
	if ((Event.EventType == AI_SEE_NPC) && (ScriptedPattern != none))
	{
		return;
	}

	LInfo = EchelonLevelInfo(Level);

	//send all events to the level pattern if there is one
	if ((LInfo != None) && (LInfo.Pattern != None))
	{
		if (!LInfo.Pattern.bInit)
			LInfo.Pattern.InitPattern();

		//Set the trigger character of the event
		LInfo.Pattern.TriggerCharacter = Instigator;

		//just send back the event to the member pattern
		LInfo.Pattern.TriggerEvent.set(Event);
		LInfo.Pattern.EventCallBack(LInfo.Pattern.TriggerEvent,Instigator);
	}

    //check if the player is interrogating a NPC
	checkInterrogation(Instigator,Event);

	//check if we have to put back the member
	if ((Event.EventType == AI_REVIVED) || (Event.EventType == AI_RELEASED))
	{
		Instigator.Pattern.bDisableMessages = false;
		AddAIMember(Instigator);
	}

	//check to be sure that the Instigator is a member of the group
	if (!IsAMember(Instigator))
	{
		//check if the Message is AI_DEAD and the NPC is already unconscious
		if (Event.EventType != AI_DEAD)
		{
			log("Stimuli received from an Non-Member - Maybe Dead or Unconscious NPC");
			return;
		}
	}



	////////////////////////////////////////////////////////////////////////////////
	//check some specific cases
	switch (Event.EventType)
	{
		case AI_GOAL_COMPLETE:
			UpdateGoalState(Instigator,1);
			Instigator.m_pGoalList.Pop();
			break;
		case AI_GOAL_FAILURE:
			UpdateGoalState(Instigator,0);
			Instigator.m_pGoalList.Pop();
			break;
		case AI_DEAD:
		case AI_UNCONSCIOUS:
		case AI_GRABBED:
			SendToCallBack = true;
			ProcessDead(Instigator);
			break;
		default:
			SendToCallBack = true;
			break;
	}

	//some controller can be disconnected
	if (!Instigator.Epawn.bSendAIEvents)
		return;

	// call default pattern's reflex handling routine
	if (Instigator.Pattern != None)
		Instigator.Pattern.ReflexCallback(Event);

	///////////////////////////////////////////////////////////////////////////////////////
	//Check if the instigator has a conversation associated
	C = ENpcZoneInteraction(Instigator.Epawn.Interaction);
	if (C != None && C.ConversationPattern != None && SendToCallBack)
	{
		//send back the stimuli to the conversation pattern
		C.ConversationPattern.EventCallBack(Event,Instigator);
	}

	///////////////////////////////////////////////////////////////////////////////////////
	//scripted event case
	if (ScriptedPattern != none)
	{
		if (SendToCallBack)
		{
			//Set the trigger character of the event
			ScriptedPattern.TriggerCharacter = Instigator;

			if (Event.EventType == AI_HEAR_SOMETHING)
			{
				if (Event.EventNoiseType == NOISE_Ricochet)
				{
					Event.EventType = AI_HEAR_RICOCHET;
					ScriptedPattern.TriggerEvent.set(Event);
					ScriptedPattern.EventCallBack(ScriptedPattern.TriggerEvent,Instigator);
					Event.EventType = AI_HEAR_SOMETHING;
				}
			}

			//just send back the event to the member pattern
			ScriptedPattern.TriggerEvent.set(Event);
			ScriptedPattern.EventCallBack(ScriptedPattern.TriggerEvent,Instigator);
		}

		//check if the pattern wants exclusivity
		if (ScriptedPattern.bEventExclusivity)
		{
			return;
		}
	}

	//reset the flag if the player is seen
	if (Instigator.bPlayerSeen)
	{
		bLostPlayerSent = false;
	}

	//consider some barks as intern events
	if (Event.EventType == AI_HEAR_SOMETHING)
	{
		if ((Event.EventNoiseType == NOISE_InfoBarkAware) || (Event.EventNoiseType == NOISE_InfoBarkAlert) ||
			(Event.EventNoiseType == NOISE_BackupBarkInvestigate) || (Event.EventNoiseType == NOISE_BackUpBarkAttack)
			|| (Event.EventNoiseType == NOISE_TakeCover))
		{
			bForceInternEvent = true;
		}
	}

	//check if we just received an INTERN event
	if ((Event.EventType > AI_INTERN_EVENTS) || bForceInternEvent)
	{
		/*if (!bExternEventWasSent)
			return;*/

		if (SendToCallBack)
		{
			if (Event.EventType == AI_PLAYER_DEAD)
			{
				if (bPlayerDeadSent)
					return;

				//be sure to send that message only one time for the group
				bPlayerDeadSent = true;

				//who's the nearest member from the player
				AI = GetClosestMember(Instigator.eGame.pPlayer.EPawn.Location,,true);

				if (AI.Pattern != None)
				{
					AI.Pattern.TriggerEvent.set(Event);
					AI.Pattern.EventCallBack(AI.Pattern.TriggerEvent,AI);
				}

			}
			else if (Event.EventType == AI_LOST_PLAYER)
			{
				//player lost choose attack point

				if (!PlayerIsVisible())
				{
					ProcessGroupLost();
				}
				else
				{
					if (Instigator.Pattern != None)
					{
						Instigator.Pattern.TriggerEvent.set(Event);
						Instigator.Pattern.EventCallBack(Instigator.Pattern.TriggerEvent,Instigator);
					}
				}

			}
			else
			{
				//just send back the event to the member pattern
				if (Instigator.Pattern != None)
				{
					Instigator.Pattern.TriggerEvent.set(Event);
					Instigator.Pattern.EventCallBack(Instigator.Pattern.TriggerEvent,Instigator);
				}
			}
		}
	}
	else
	{
		//reset default pattern if it's the first
		if (!bExternEventWasSent)
		{
			if ((Instigator.Pattern != None) && (ScriptedPattern != None))
			{
				if (Instigator.Pattern.GetStateName() != 'Attack')
					SetDefaultPattern();
				else
				{
					if (Event.EventType >= AI_TAKE_DAMAGE)
						SetDefaultPattern();
					else
					{
						if ((Event.EventType == AI_HEAR_SOMETHING) && (Event.EventNoiseType == NOISE_Ricochet))
							SetDefaultPattern();
					}
				}
			}
		}

		bExternEventWasSent = true;

		//the event is an EXTERN stimuli
		E.EventType      = Event.EventType;
		E.EventLocation  = Event.EventLocation;
		E.EventTarget    = Event.EventTarget;
		E.EventActor     = Event.EventActor;
		E.ReceivedTime   = Event.ReceivedTime;
		E.Instigator     = Event.Instigator;
		E.EventNoiseType = Event.EventNoiseType;

		E.EventBroadcastType  = Event.EventBroadcastType;

		E.ReceivedTime = Level.TimeSeconds;
		E.Instigator   = Instigator;

		//add the event in the list - All events will be processed at the end of the frame
		EventList[EventList.Length] = E;
	}
}

defaultproperties
{
    bEventExclusivity=True
    DelayBetweenGrenades=10.000000
    fSeeInterrogationTimer=-10.000000
    bHidden=True
    Texture=Texture'GroupAI'
}