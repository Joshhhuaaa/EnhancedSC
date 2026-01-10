class EDogPattern extends EPattern;

/////////////////////////////////////////////////////////////////////////////////////////////
//FLAGS//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
var int bPlayerSeenOnce;		// set true the very first time we see the player and never reset
var int bHiding;
var vector BestDest;
var int NumberOfTry;
var int LastTimeDamage;

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////          Idle                ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

auto state idle
{
	//----------------------------------------[David Kalina - 5 Oct 2001]-----
	//
	// Description
	//		No need to override here.  Example.
	//
	//------------------------------------------------------------------------

	function BeginState()
	{
		if ((Characters[1]!= None) && (Characters[1].GetStateName() == 's_Alert'))
		{
			EAIController(Characters[1]).GotoStateSafe('s_Investigate');
		}
	}

	function GotoPatternLabel(name label)
	{
		GotoState('Idle', label);
	}




	//---------------------------------------[David Kalina - 10 Oct 2001]-----
	//
	// Description
	//		All Events sent through here.
	//		This function sets HIGH-PRIORITY Goals (all Action?)
	//		So that the AI will respond to certain things regardless of whether or
	//		not it is running a DEFAULT or a SCRIPTED pattern.
	//
	//		TODO : How do we change the default patterns state when a
	//		scripted pattern is running???
	//
	//		Add this / distinguish in each state
	//
	// Input
	//		Event :
	//
	//------------------------------------------------------------------------

	function ReflexCallBack(EAIEvent Event){}


	//----------------------------------------[Frederic Blais - 5 Oct 2001]-----
	//
	// Description
	//		Communication callback
	//
	//------------------------------------------------------------------------
	function CommunicationCallBack(AIEventType eType){}


	function EventCallBack(EAIEvent Event,Actor TriggerActor)
	{
		if (!bDisableMessages)
		{
			switch (Event.EventType)
			{
				/*******  EXTERNAL EVENTS  ********************************************/


				case AI_SEE_PLAYER_SURPRISED:
				case AI_SEE_PLAYER_ALERT:
				case AI_TAKE_DAMAGE:
				case AI_ATTACK:
				case AI_SEE_INTERROGATION :

					EventJump('SeePlayer');
					break;

				case AI_SEE_PLAYER_INVESTIGATE:

					EventJump('SeePlayerInvestigate');
					break;

				case AI_HEAR_SOMETHING:

					switch (Event.EventNoiseType)
					{
						case NOISE_LightFootstep :
						case NOISE_Object_Falling :
						case NOISE_HeavyFootstep :
						case NOISE_Object_Breaking :

							EventJump('HearSomethingInvestigate');
							break;

						case NOISE_BackUpBarkAttack:
							EventJump('AttackRequest');
							break;

					}
					break;

				case AI_MASTER_DEAD:

					EventJump('MasterIncapacitated');
					break;


			/*	case AI_SEE_CHANGED_ACTOR:

					switch (Event.EventTarget.ChangeType)
					{
						case CHANGE_Unconscious :
							EventJump('SeeUnconsciousBody');
							break;

						case CHANGE_Dead :
							EventJump('SeeDeadBody');
							break;


					}

					Level.RemoveChange(Event.EventTarget);		// !!! Don't forget to remove changed actor after handling it !!!

					break;*/

				case AI_SMELL_SOMETHING:

					EventJump('SmellSomethingInvestigate');
					break;


				/*******  INTERNAL EVENTS  ********************************************/

				case AI_SEE_PLAYER_AGAIN:
					EventJump('SeePlayerAgain');
					break;

				case AI_PLAYER_VERYCLOSE:
				case AI_PLAYER_CLOSE:
				case AI_PLAYER_FAR:
				case AI_INVESTIGATE:
				case AI_UPDATE_SEARCH:
				case AI_ALARM_UPDATE_POSITION:
				case AI_SHOT_BLOCKED:
					// no response for these behaviors for non violent npc type
					break;

				default:
					break;
			}
		}
	}

SeePlayer:

	plog("SeePlayer");
	PlayerIdentified();
	GotoPatternState('Wait', 'StartBark');
	End();

SeeUnconsciousBody:

	plog("SeeUnconsciousBody");
	End();

SeeDeadBody:

	plog("SeeDeadBody");
	End();

MasterIncapacitated:

	plog("MasterIncapacitated");
    Goal(1, GOAL_Wait, 2, TriggerEvent.EventTarget.Location,,,,'LookStNmUp0',,,,MOVE_JogAlert);
    //Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
    //Broadcast(1, BC_BACKUP_BARK_INVESTIGATE);
    //ePawn(Characters[1].Pawn).PlayDogHit();
    //Sleep(3);
    //ePawn(Characters[1].Pawn).PlayDogHit();
	End();

SeePlayerInvestigate:

	plog("SeePlayerInvestigate");
    eDog(Characters[1].Pawn).PlayDogBark();
	Jump('Search_Location');

HearSomethingInvestigate:

	plog("HearSomethingInvestigate");
    eDog(Characters[1].Pawn).PlayDogBark();
	Jump('Search_Location');

SmellSomethingInvestigate:

	plog("SmellSomethingInvestigate");
    eDog(Characters[1].Pawn).PlayDogBark();
	CheckSmellPoints(1,'SmellPointFound');
	Jump('Search_Location');

SmellPointFound:
	GotoPatternState('Search', 'SmellPointFound');

Search_Location:

	plog("Search_Location -- Search at Event Location");
	GotoPatternState('Search', 'Search_Location');


AttackRequest:

	plog("AttackRequest");
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Wait', 'AttackRequest');


}



/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////          Search                /////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

state Search
{

	//----------------------------------------[David Kalina - 12 Oct 2001]-----
	//
	// Description
	//		OVERRIDEN Function so GotoPatternLabel calls are done w/in this state.
	//
	//------------------------------------------------------------------------
	function BeginState()
	{
		EAIController(Characters[1]).GotoStateSafe('s_Investigate');
	}

	function GotoPatternLabel(name label)
	{
		GotoState('Search', label);
	}


	function ReflexCallBack(EAIEvent Event)
	{}


	//----------------------------------------[David Kalina - 5 Oct 2001]-----
	//
	// Description
	//		Handle incoming AIEvents by jumping to the appropriate label.
	//
	//------------------------------------------------------------------------

	function EventCallBack(EAIEvent Event,Actor TriggerActor)
	{
		if (!bDisableMessages)
		{
			switch (Event.EventType)
			{

				/*******  EXTERNAL EVENTS  ********************************************/


				case AI_SEE_PLAYER_SURPRISED:
				case AI_SEE_PLAYER_ALERT:
				case AI_TAKE_DAMAGE:
				case AI_ATTACK:
				case AI_SEE_INTERROGATION :

					EventJump('SeePlayer');
					break;

				case AI_SEE_PLAYER_INVESTIGATE:

					//EventJump('UpdateSearch');
					break;

				case AI_MASTER_OUT_OF_RADIUS:
					EventJump('MasterOutOfRadius');
					break;

				case AI_HEAR_SOMETHING:

					switch (Event.EventNoiseType)
					{
						case NOISE_LightFootstep :
						case NOISE_Object_Falling :
						case NOISE_HeavyFootstep :
						case NOISE_Object_Breaking :

							EventJump('Search_Location');
							break;

						case NOISE_BackUpBarkAttack:
							EventJump('AttackRequest');
							break;
					}
					break;



				case AI_MASTER_DEAD:

					EventJump('MasterIncapacitated');
					break;

			}
		}
	}


/***********************************************************************************************

	STATE : SEARCH -- RESPONSES TO INCOMING AIEVENTS

 ************************************************************************************************/



WaitSearch:

	plog("WaitSearch");
	WaitForGoal(1,GOAL_MoveTo);
    RemoveUsedSmellPoint(1);
	CheckSmellPoints(1,'SmellPointFound');

SearchFailed:

	plog("SearchFailed");
	Goal_Stop(1, 14, 2.0f,, MOVE_WalkNormal);
	GotoPatternState('Idle');


SmellPointFound:

	plog("SmellPointFound");
	ResetGoals(1);
	Goal_Stop(1, 14, 1.0f,, MOVE_Search,, AlertLocation);
	Goal(1,GOAL_MoveTo, 9, AlertLocation,,,,,,,,MOVE_Search);
	Jump('WaitSearch');


MasterOutOfRadius:

	plog("MasterOutOfRadius");
	SendMasterOutOfRadius(TriggerEvent.EventTarget, TriggerEvent.EventLocation);
	Jump('WaitSearch');

////////////////////////////////
/// SEARCH BEHAVIOR TRIGGERS ///
////////////////////////////////
SeePlayer:
	plog("SeePlayer");
	PlayerIdentified();
	GotoPatternState('Wait', 'StartBark');
	End();


Search_Location:

	plog("Search_Location -- Search at Smell Point Location");

	ResetGoals(1);
	Goal_Stop(1, 14, 1.0f,, MOVE_Search,, TriggerEvent.EventLocation);
	Goal(1,GOAL_MoveTo, 9,TriggerEvent.EventLocation ,,,,,,,,MOVE_Search);
	Jump('WaitSearch');


AttackRequest:

	plog("AttackRequest");
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Wait', 'AttackRequest');


MasterIncapacitated:

	plog("MasterIncapacitated");
    Goal(1, GOAL_Wait, 2, TriggerEvent.EventTarget.Location,,,,'LookStNmUp0',,,,MOVE_JogAlert);
    //Broadcast(1, BC_BACKUP_BARK_INVESTIGATE);
	End();

}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////                Wait                    /////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
state Wait
{

	function BeginState()
	{
		EAIController(Characters[1]).GotoStateSafe('s_Alert');
	}

	function GotoPatternLabel(name label)
	{
		GotoState('Wait', label);
	}

	function EventCallBack(EAIEvent Event,Actor TriggerActor)
	{
		if (!bDisableMessages)
		{

			switch (Event.EventType)
			{
				case AI_SEE_PLAYER_SURPRISED:
				case AI_SEE_PLAYER_ALERT:
				case AI_TAKE_DAMAGE:
				case AI_SEE_INTERROGATION :

					EventJump('SeePlayer');
					break;

				case AI_LOST_PLAYER:
				case AI_GROUP_LOST_PLAYER:
					EventJump('PlayerLost');
					break;


				case AI_HEAR_SOMETHING:

					switch (Event.EventNoiseType)
					{
						case NOISE_BackUpBarkAttack:
							EventJump('AttackRequest');
							break;

						case NOISE_Ricochet :
							EventJump('SeePlayer');
							break;


					}
					break;

				case AI_PLAYER_CLOSE:
				case AI_PLAYER_FAR:
					EventJump('PlayerLost');
					break;

				case AI_PLAYER_VERYCLOSE:
					//EventJump('PlayerIsVeryClose');
					break;

			}
		}
	}

	function Tick(float delta)
	{
		if ((VSize(Characters[0].Pawn.Location - Characters[1].Pawn.Location) < 100) &&  Characters[1].Pawn.Velocity != vect(0,0,0) && (Level.TimeSeconds - LastTimeDamage) > 1.0)
		{
			if (EPawn(Characters[1].Pawn).ICanBark())
				Characters[1].Pawn.Playsound(Sound'play_random_dogbark',SLOT_Barks);

			NumberOfTry = 0;
			LastTimeDamage = Level.TimeSeconds;
			MakeDamage(Characters[0].Pawn,120);
		}
		else if ((VSize(Characters[0].Pawn.Location - Characters[1].Pawn.Location) < 130) &&  Characters[1].Pawn.Velocity != vect(0,0,0) && (Level.TimeSeconds - LastTimeDamage) > 1.0)
		{
			if (EPawn(Characters[1].Pawn).ICanBark())
				Characters[1].Pawn.Playsound(Sound'play_random_dogbark',SLOT_Barks);

			NumberOfTry = 0;
			LastTimeDamage = Level.TimeSeconds;
			MakeDamage(Characters[0].Pawn,60);
		}

	}


WaitBark:

	plog("WaitBark");
	CheckFlags(bCharge,true,'WaitCharge');
	WaitForGoal(1,GOAL_Stop);
	CheckDistanceGreaterThan(1,'PlayerLost', 100);
	CheckIfDirectLine(1,Characters[0].Pawn,'MakeDamage');
	Jump('WaitBark');


WaitCharge:

	plog("WaitCharge");
	WaitForGoal(1,GOAL_Charge,'AfterChargefailure');
	bCharge = 0;
	CheckDistanceGreaterThan(1,'AfterChargeCompleted', 100);
	CheckIfDirectLine(1,Characters[0].Pawn,'MakeDamage');
	Jump('PlayerLost');

AfterChargefailure:

	plog("WaitChargeFailure");
	bCharge = 0;
	//Goal_Stop(1, 16, 1.0f, Characters[0].Pawn, MOVE_JogAlert);
	Jump('AfterChargeFailed');

AfterChargeCompleted:

	plog("AfterChargeCompleted");

	if (EAIController(Characters[1]).bPlayerSeen)
	{
		if (EPawn(Characters[1].Pawn).ICanBark())
			Characters[1].Pawn.Playsound(Sound'play_random_dogbark',SLOT_Barks);

		BroadcastToMaster();
		Jump('PlayerLost');
	}

	if (EAIController(EAIController(Characters[1]).Master.Controller).Pattern.GetStateName() == 'attack')
	{
		Jump('AfterChargeFailed');
	}
	else
	{
		TriggerEvent.EventLocation = GetNearestNavPointLocation();
		GotoPatternState('Search', 'Search_Location');
	}

AfterChargeFailed:

	plog("AfterChargeFailed");
	bCharge = 0;

	if (EAIController(Characters[1]).bPlayerSeen)
		BroadcastToMaster();

	if (NumberOfTry < 32)
	{
		NumberOfTry++;
		Jump('PlayerLost');
	}
	else
	{
		BestDest = GetNearestNavPointLocation();

		if ((VSize(Characters[0].Pawn.Location - Characters[1].Pawn.Location) > 500))
		{
			NumberOfTry = 0;
			Goal_Charge(1,15,Characters[0].Pawn,MOVE_JogAlert,,BestDest);
	Jump('WaitCharge');
		}
		else
		{
			NumberOfTry = 0;
			Goal_Stop(1, 15, 0.8f, Characters[0].Pawn, MOVE_Snipe);
			Jump('WaitBark');
		}
	}

MakeDamage:

	plog("MakeDamage");

	NumberOfTry = 0;

	if (Characters[0].Pawn.Health <= 0)
	{
		ResetGoals(1);
		End();
	}
	else
	{
		MakeDamage(Characters[0].Pawn,150);
		Broadcast(1, BC_BACKUP_BARK_ATTACK);
		Goal_Stop(1, 15, 0.3f, Characters[0].Pawn, MOVE_Snipe);
		Jump('WaitBark');
	}


SeePlayer:

	plog("SeePlayer");
	PlayerIdentified();
	BroadcastToMaster();

	if (EPawn(Characters[1].Pawn).ICanBark())
		Characters[1].Pawn.Playsound(Sound'play_random_dogbark',SLOT_Barks);

	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	CheckDistanceGreaterThan(1,'PlayerLost', 100);
	CheckIfDirectLine(1,Characters[0].Pawn,'MakeDamage');
	Jump('PlayerLost');


PlayerIsVeryClose:

	plog("PlayerIsVeryClose");
	ResetGoals(1);
	Goal_Stop(1, 15, 0.5f, Characters[0].Pawn, MOVE_Snipe);
	Jump('WaitBark');


StartBark:

	plog("StartBark");
	ResetGoals(1);
	BroadcastToMaster();
	Jump('SeePlayer');


AttackRequest:

	plog("AttackRequest");
	ForceUpdatePlayerLocation(1);
	CheckFlags(bCharge,true,'PlayerLost');
	PlayerIsVisible(1,'PlayerLost');
	ResetGoals(1);
	BroadcastToMaster();
	Goal_Stop(1, 15, 0.5f, Characters[0].Pawn, MOVE_Snipe);
	Jump('WaitBark');


PlayerLost:

	plog("PlayerLost");
	ResetGoals(1);
	bCharge = 1;
	Goal_Charge(1,15,Characters[0].Pawn,MOVE_JogAlert,,,,);
	Jump('WaitCharge');


}
