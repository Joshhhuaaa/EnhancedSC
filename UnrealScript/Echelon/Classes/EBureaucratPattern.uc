class EBureaucratPattern extends EPattern;

/////////////////////////////////////////////////////////////////////////////////////////////
//FLAGS//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
var int bPlayerSeenOnce;		// set true the very first time we see the player and never reset
var int bHiding;




/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////          Idle                ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
function CheckAlarms()
{
	local EAIController     AI;
    local EAlarmPanelObject BestPanel;
	local vector            OffSet;
    local vector            Pos;

    AI = EAIController(Characters[1]);
	BestPanel = AI.ePawn.ForceAlarmPanelRun;

	if ((BestPanel!= None) && (VSize(AI.ePawn.Location - BestPanel.Location) < 200))
	{
		if ((EGroupAI(Owner).CurrentAlarm == None) && (!EGroupAI(Owner).bGroupRunningForAlarm))
		{
			if (AI.ePawn.ForceAlarmPanelRun != None)
			{
				//don't want to trigger the same alarm twice
				if (BestPanel.Alarm.bAlreadyTriggered)
					return;

				OffSet = (vect(50,0,0) >> BestPanel.Rotation);
				OffSet.Z = 0;

				Pos = BestPanel.Location;

				//set the group to be sure nobody else will try to run for an alarm
				EGroupAI(Owner).bGroupRunningForAlarm = true;

				TriggerEvent.EventLocation = Pos + OffSet;
				TriggerEvent.EventTarget = BestPanel;
				GotoPatternLabel('RunToAlarm');


				return;
			}
		}
	}
}


auto state idle
{
	//----------------------------------------[David Kalina - 5 Oct 2001]-----
	//
	// Description
	//		No need to override here.  Example.
	//
	//------------------------------------------------------------------------

	function GotoPatternLabel(name label)
	{
		GotoState('Idle', label);
	}


	function BeginState()
	{
		EchelonLevelInfo(Level).SendMusicRequest(0,false,self);
		EchelonLevelInfo(Level).SendMusicRequest(1,false,self);

        if (Characters[1] != None)
        {
		    EAIController(Characters[1]).GotoStateSafe('s_Default');
        }
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

	function ReflexCallBack(EAIEvent Event)
	{
		if (!CheckGoalPriority(50) && !bDisableMessages)
		{
		switch (Event.EventType)
		{
			case AI_SEE_PLAYER_SURPRISED:
			case AI_SEE_PLAYER_ALERT:
			case AI_TAKE_DAMAGE:

					EAIController(Characters[1]).GotoStateSafe('s_alert');
					break;

			case AI_HEAR_SOMETHING :

				switch (Event.EventNoiseType)
				{
					case NOISE_GrenadeWarning :

						//Goal_Action(...);
						return;

					case NOISE_Ricochet:

						EAIController(Characters[1]).GotoStateSafe('s_alert');

                        if (fLastReflexTime < (Level.TimeSeconds - 5.0f))
                        {
						    plog("REFLEX -- Noise Ricochet response.");
						    Reaction(1, 55, TriggerEvent.EventLocation, REACT_ImmediateThreat);
                            fLastReflexTime = Level.TimeSeconds;
                        }
						return;

					case NOISE_DyingGasp :
					case NOISE_Explosion :

						Reaction(1, 55, Event.EventLocation, REACT_ImmediateThreat);
						return;
				}

				break;
		}
	}
	}


	//----------------------------------------[Frederic Blais - 5 Oct 2001]-----
	//
	// Description
	//		Communication callback
	//
	//------------------------------------------------------------------------
	function CommunicationCallBack(AIEventType eType){}

	//------------------------------------------------------------------------
	//
	// Description
	//
	//
	//------------------------------------------------------------------------
	function EventCallBack(EAIEvent Event,Actor TriggerActor)
	{
		if (!bDisableMessages)
		{
			switch (Event.EventType)
			{
				/*******  EXTERNAL EVENTS  ********************************************/

				case AI_SEE_NPC:
					break;

				case AI_SEE_PLAYER_SURPRISED:

					EventJump('SeePlayerSurprised');
					break;

				case AI_SEE_PLAYER_ALERT:

					EventJump('SeePlayer');
					break;

				case AI_TAKE_DAMAGE:

					EventJump('TakeDamage');
					break;

				case AI_SEE_PLAYER_INVESTIGATE:

					EventJump('SeePlayerInvestigate');
					break;

                 case AI_SEE_INTERROGATION :
                    EventJump('SeeAnotherNPCInterrogated');
					break;

				case AI_HEAR_SOMETHING:

					switch (Event.EventNoiseType)
					{
						case NOISE_LightFootstep :

							EventJump('HearSomethingQuiet');
							break;

						case NOISE_Object_Falling :
						case NOISE_HeavyFootstep :
						case NOISE_Object_Breaking :

							EventJump('HearSomethingInvestigate');
							break;

						case NOISE_DoorOpening :

							EventJump('HearDoorOpening');
							break;

						case NOISE_Scream :
						case NOISE_DyingGasp :

							EventJump('HearFriendlyScream');
							break;

						case NOISE_GrenadeWarning :

							EventJump('HearGrenadeWarning');
							break;


						case NOISE_Gunfire :

							EventJump('HearGunshot');
							break;

						case NOISE_Ricochet :

							EventJump('HearRicochet');
							break;

						case NOISE_WallMineTick :

							EventJump('HearWallMineTick');
							break;

						case NOISE_Explosion :

							EventJump('HearExplosion');
							break;

						case NOISE_InfoBarkAware:
							EventJump('InfoBarkAware');
							break;

						case NOISE_InfoBarkAlert:
							EventJump('InfoBarkAlert');
							break;

						case NOISE_BackupBarkInvestigate:
							EventJump('InvestigateRequestFromGroupMember');
							break;

						case NOISE_BackUpBarkAttack:
							EventJump('AttackRequestFromGroupMember');
							break;


					}
					break;

				case AI_SEE_CHANGED_ACTOR:

					switch (Event.EventTarget.ChangeType)
					{
						case CHANGE_Footprints :
						case CHANGE_DisabledTurret :
						case CHANGE_DisabledCamera :
							break;

						case CHANGE_BrokenObject :
							EventJump('BrokenObject');
							break;

						case CHANGE_BrokenDoor :
							EventJump('BrokenDoor');
							break;

						case CHANGE_Object :
							EventJump('SeeObject');
							break;

						case CHANGE_ScorchMark :
						case CHANGE_BloodStain :
							break;

						case CHANGE_LightTurnedOff :
							EventJump('LightsTurnedOff');
							break;

						case CHANGE_LightShotOut :
							EventJump('LightsShotOut');
							break;

						case CHANGE_Unconscious :
							EventJump('SeeUnconsciousBody');
							break;

						case CHANGE_Dead :
							EventJump('SeeDeadBody');
							break;

						case CHANGE_Grenade :
							EventJump('SeeLiveGrenade');
							break;

						case CHANGE_DisabledCamera :
							EventJump('SeeBrokenMachinery');
							break;

					}

					Level.RemoveChange(Event.EventTarget);		// !!! Don't forget to remove changed actor after handling it !!!

					break;



				/*******  INTERNAL EVENTS  ********************************************/

				case AI_SEE_PLAYER_AGAIN:
					EventJump('SeePlayer');
					break;

				case AI_PLAYER_VERYCLOSE:
				case AI_PLAYER_CLOSE:
					EventJump('SeePlayer');
					break;

				case AI_PLAYER_FAR:
				case AI_INVESTIGATE:
				case AI_UPDATE_SEARCH:
				case AI_ATTACK:
				case AI_ALARM_UPDATE_POSITION:
				case AI_SHOT_BLOCKED:
					// no response for these behaviors for non violent npc type
					break;

				default:
					break;
			}
		}
	}

// ----- Reaction to visual stimuli -----

SeePlayer:

	log("SeePlayer -- Bureaucrat - "$Characters[1],,LPATTERN);
	PlayerIdentified();
    Broadcast(1, BC_BACKUP_BARK_ATTACK);
	CheckFlags(bPlayerSeenOnce, true, 'RunAndHide');
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeePlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_Surprised);
	Jump('FirstTimeAlerted');


SeePlayerSurprised:

	log("SeePlayerSurprised -- Bureaucrat - "$Characters[1],,LPATTERN);
	PlayerIdentified();
    Broadcast(1, BC_BACKUP_BARK_ATTACK);
	CheckFlags(bPlayerSeenOnce, true, 'RunAndHide');
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SurprisedByPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_Surprised);
	Jump('FirstTimeAlerted');


SeeUnconsciousBody:

	plog("SeeUnconsciousBody -- EventTarget:  " $ TriggerEvent.EventTarget);
	if (!EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats)
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeUnconscious;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
    Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	Broadcast(1, BC_INFO_BARK_AWARE);
	if (!ePawn(TriggerEvent.EventTarget).bNoUnconsciousRevival)
		Goal(1, GOAL_InteractWith, 35,,,TriggerEvent.EventTarget,,,,,,MOVE_JogAlert);
	Jump('Search_Location');


SeeLiveGrenade:

	plog("SeeLiveGrenade");
	PlayerIdentified();
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_GroupScatter;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeGrenade);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('RunAndHide');


SeeDeadBody:

	plog("SeeDeadBody");
	if (!EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats)
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	if (EPawn(TriggerEvent.EventTarget) != none)
	{
		plog("   Time Since Death :  " $ Level.TimeSeconds - EPawn(TriggerEvent.EventTarget).TimeOfDeath);
		if (Level.TimeSeconds - EPawn(TriggerEvent.EventTarget).TimeOfDeath < 10f)
			Jump('SeeJustDied');
		else
			Jump('SeeDeadBodyCold');
	}
	else
		Jump('SeeDeadBodyCold');


SeeJustDied:

	plog("JustDied");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
    Broadcast(1, BC_INFO_BARK_ALERT);
	Jump('FirstTimeAlerted');


SeeDeadBodyCold:

	plog("SeeDeadBodyCold");
	ResetGoals(1);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
    Broadcast(1, BC_INFO_RADIO_ALERT);
	Jump('FirstTimeAlerted');


SeePlayerInvestigate:

	plog("SeePlayerInvestigate");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeSomethingMove;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeUnknownPerson);
    Broadcast(1, BC_INFO_BARK_AWARE);
	Jump('Search_Location');


LightsTurnedOff:

	plog("LightsTurnedOff -- bark and look around nervously, move to light switch and re-enable");
    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);
	ResetGoals(1);
    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {
        if (TriggerEvent.EventTarget.owner.GetStateName() == 's_Off')
        {
	        ePawn(Characters[1].Pawn).Bark_Type = BARK_LightsOut;
        }
        else    // s_On
        {
	        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
        }

	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
        Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeLightsOut);
	    Broadcast(1, BC_SELF_DIRECTED);
    }
	ChangeState(1,'s_Alert');
	CheckSwitchAlreadyLocked(1, TriggerEvent.EventTarget.owner);
    if ((iSuggestedBehavior & SEARCH_BIT) == SEARCH_BIT)
    {
	    Jump('Search_Location');
    }
	End();


LightsShotOut:

	plog("LightsShotOut");
    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);
	ResetGoals(1);
    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_LightShot;
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	    Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeLightsOut);
	    Broadcast(1, BC_SELF_DIRECTED);
    }
	ChangeState(1,'s_Alert');
    if ((iSuggestedBehavior & SEARCH_BIT) == SEARCH_BIT)
    {
        //log("SEARCH_BIT was on jumping to Search_Directional");
	    Jump('Search_Location');
    }
	End();


SeeObject:

	plog("SeeObject - watch it for a second and then search");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	Reaction(1, 50,, REACT_MovingObject, TriggerEvent.EventTarget);
	Broadcast(1, BC_SELF_DIRECTED);
	Jump('Search_Location');


BrokenDoor:

	plog("BrokenDoor");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_BrokenObject);		// specify target so we 'watch' the object if it's moving
	Broadcast(1, BC_SELF_DIRECTED);
	End();


BrokenObject:

	plog("BrokenObject");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_BrokenObject);		// specify target so we 'watch' the object if it's moving
	Broadcast(1, BC_SELF_DIRECTED);
	End();


SeeAnotherNPCInterrogated:

	plog("SeeAnotherNPCInterrogated");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_DropHim;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeInterrogation);
	SendCommunication(AI_LET_HIM_GO,TriggerEvent.EventTarget,0.8f);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('FirstTimeAlerted');

// ----- Audio Stimuli -----


HearSomethingQuiet:

	plog("HearSomethingQuiet");
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_CuriousNoise);
	Broadcast(1, BC_SELF_DIRECTED);
	End();


HearSomethingInvestigate:

	plog("HearSomethingInvestigate");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardFoot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_AlarmingNoise);
	Broadcast(1, BC_INFO_BARK_AWARE);
	Jump('Search_Location');
	End();


HearDoorOpening:

	plog("HearDoorOpening");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardFoot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_CuriousNoise);
	Broadcast(1, BC_SELF_DIRECTED);
	End();


HearGunshot:

	plog("HearGunshot");
	CheckIfThreatNearby(1,'HearRicochet');	// if gunshot is nearby, treat gunshot as if it were a ricochet
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardGunShot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_DistantThreat);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Jump('FirstTimeAlerted');


HearRicochet:

	plog("HearRicochet");
	PlayerIdentified();
	ResetGoals(1);
	ForceUpdatePlayerLocation(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
    Reaction(1, 52, TriggerEvent.EventLocation, REACT_ImmediateThreat);
    //WaitForGoal(1,GOAL_Action);
	Jump('FirstTimeAlerted');


HearExplosion:

	plog("HearExplosion");					// duck and run, search in direction of sound
	CheckIfThreatNearby(1,'HearRicochet');	// if gunshot is nearby, treat gunshot as if it were a ricochet
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardGunShot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_DistantThreat);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Jump('Search_Location');


HearGrenadeWarning:

	plog("HearGrenadeWarning");
	ResetGoals(1);
	//Goal_Action(1, 15,TriggerEvent.EventLocation, 'ReacStNmCC0');	 // do we take time to react?
	Jump('RunAndHide');


HearFriendlyScream:

	plog("HearFriendlyScream");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
    Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
	Goal_Charge(1,36,None,MOVE_JogAlert,true,TriggerEvent.EventLocation);
	Goal_Stop(1, 35, 2.0f, TriggerEvent.EventTarget, MOVE_JogAlert);
	Jump('FirstTimeAlerted');


HearWallMineTick:

	plog("HearWallMineTick");
	ResetGoals(1);
	Broadcast(1, BC_SELF_DIRECTED);
	Jump('RunAndHide');


// ----- Action Labels -----

TakeDamage:

	log("TakeDamage -- Bureaucrat - "$Characters[1],,LPATTERN);
	PlayerIdentified();
	ePawn(Characters[1].Pawn).StopAllVoicesActor();
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HitByBullet;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	CheckFlags(bPlayerSeenOnce, true, 'RunAndHide');
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('FirstTimeAlerted');


FirstTimeAlerted:
	PlayerIdentified();
	ResetGoals(1);
	ChangeState(1,'s_alert');
    SetFlags(bPlayerSeenOnce, true);
    CheckFlags(int(ePawn(Characters[1].Pawn).bJustHides), true, 'RunAndHide');
	CheckAlarmProximity(1,'RunToAlarm');
	DisableMessages(true);
	Sleep(0.0);
	DisableMessages(false);
	CheckNearestArmedNPC('ReachArmedNPC');
	Jump('RunAndHide');


RunToAlarm:

	log("EA1Npc - RunToAlarm"@Characters[1],,LPATTERN);
	DisableMessages(true);
	bRunningAlarm = true;
	Goal(1,GOAL_InteractWith, 45,TriggerEvent.EventLocation,,TriggerEvent.EventTarget,,,,,,MOVE_JogAlert);
	WaitForGoal(1,GOAL_InteractWith, 'RunAndHide_EnableMessages');
	bRunningAlarm = false;
	DisableMessages(false);
	Jump('RunAndHide');


Search_Location:

	plog("Search_Location -- Search at Event Location THEN in Random Direction");
	GotoPatternState('Search', 'Search_Location');


AlarmBegin:

	plog("AlarmBegin");
	GotoPatternState('RunAway', 'StartRun');

RunAndHide_EnableMessages:

	plog("RunAndHide_EnableMessages");
	bRunningAlarm = false;
	DisableMessages(false);

RunAndHide:

	plog("RunAndHide");
	GotoPatternState('RunAway', 'StartRun');

ReachArmedNPC:

	plog("ReachArmedNPC");
	GotoPatternState('RunAway', 'ReachArmedNPC');


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFYING PSYCHOLOGICAL STATES
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

InfoBarkAware:

	plog("InfoBarkAware");
	ChangeState(1,'s_investigate');
	End();


InfoBarkAlert:

	plog("InfoBarkAlert");
	ChangeState(1,'s_alert');
	End();


InvestigateRequestFromGroupMember:

	plog("InvestigateRequestFromGroupMember");
	ChangeState(1,'s_investigate');
	End();


AttackRequestFromGroupMember:

	plog("AttackRequestFromGroupMember");
	Jump('FirstTimeAlerted');

}



/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////          Search                /////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

state Search
{
	//------------------------------------------------------------------------
	//
	// Description
	//
	//
	//------------------------------------------------------------------------
	function BeginState()
	{
		ChangeState(1,'s_investigate');

		EchelonLevelInfo(Level).SendMusicRequest(1,false,self);
		EchelonLevelInfo(Level).SendMusicRequest(0,true,self);

	}

	//----------------------------------------[David Kalina - 12 Oct 2001]-----
	//
	// Description
	//		OVERRIDEN Function so GotoPatternLabel calls are done w/in this state.
	//
	//------------------------------------------------------------------------

	function GotoPatternLabel(name label)
	{
		GotoState('Search', label);
	}

	//------------------------------------------------------------------------
	//
	// Description
	//
	//
	//------------------------------------------------------------------------
	function ReflexCallBack(EAIEvent Event)
	{
		if (!CheckGoalPriority(50) && !bDisableMessages)
		{
		switch (Event.EventType)
		{
			case AI_SEE_PLAYER_SURPRISED:
			case AI_SEE_PLAYER_ALERT:
			case AI_TAKE_DAMAGE:

					EAIController(Characters[1]).GotoStateSafe('s_alert');
					return;

			case AI_HEAR_SOMETHING :

				switch (Event.EventNoiseType)
				{
					case NOISE_Ricochet:

						EAIController(Characters[1]).GotoStateSafe('s_alert');
						return;

					case NOISE_GrenadeWarning :

						//Goal_Action(...);
						return;

					case NOISE_DyingGasp :

						Goal_Action(1, 50, Event.EventLocation, 'BoomStHu2');

						return;
				}

				break;
		}
	}
	}


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

				case AI_SEE_NPC:
					break;

				case AI_SEE_PLAYER_SURPRISED:

					EventJump('SeePlayerSurprised');
					break;

				case AI_SEE_PLAYER_ALERT:

					EventJump('SeePlayer');
					break;

				case AI_TAKE_DAMAGE:

					EventJump('TakeDamage');
					break;

				case AI_SEE_PLAYER_INVESTIGATE:

					EventJump('UpdateSearchB');
					break;

				case AI_SEE_INTERROGATION :
                    EventJump('SeeAnotherNPCInterrogated');
					break;

				case AI_SHOT_JUST_MISSED :

					break;

				case AI_HEAR_SOMETHING:

                    switch (Event.EventNoiseType)
					{
						case NOISE_LightFootstep :
						case NOISE_Object_Falling :
						case NOISE_HeavyFootstep :
						case NOISE_Object_Breaking :
						case NOISE_DoorOpening :

							EventJump('UpdateSearch');
							break;

						case NOISE_Scream :
						case NOISE_DyingGasp :

							EventJump('HearFriendlyScream');
							break;

						case NOISE_GrenadeWarning :

							EventJump('HearGrenadeWarning');
							break;

						case NOISE_Explosion :
						case NOISE_Gunfire :

							EventJump('HearViolentNoise');
							break;

						case NOISE_Ricochet :

							EventJump('HearRicochet');
							break;

						case NOISE_WallMineTick :

							EventJump('HearWallMineTick');
							break;



							EventJump('HearExplosion');
							break;

						case NOISE_InfoBarkAware:
							EventJump('InfoBarkAware');
							break;

						case NOISE_InfoBarkAlert:
							EventJump('InfoBarkAlert');
							break;

						case NOISE_BackupBarkInvestigate:
							EventJump('UpdateSearch');
							break;

						case NOISE_BackUpBarkAttack:
							EventJump('AttackRequestFromGroupMember');
							break;
                    }
                    break;

                case AI_SEE_CHANGED_ACTOR:

				    Level.RemoveChange(Event.EventTarget);		// !!! Don't forget to remove changed actor after handling it !!!
                    					switch (Event.EventTarget.ChangeType)
					{
						/*case CHANGE_Bleeding :
							EventJump('SeeViolence');
							break;*/

						case CHANGE_WallMine :
							EventJump('SeeWallMine');
							break;

						case CHANGE_Footprints :
						case CHANGE_Flare :
						case CHANGE_BrokenObject :
						case CHANGE_BrokenDoor :
						case CHANGE_ScorchMark :
						case CHANGE_BloodStain :
						case CHANGE_Object :
							EventJump('UpdateSearch');
							break;

						case CHANGE_AirCamera :
							EventJump('SeeAirCamera');
							break;

						case CHANGE_LightTurnedOff :
							EventJump('LightsTurnedOff');
							break;

						case CHANGE_LightShotOut :
							EventJump('LightsShotOut');
							break;

						case CHANGE_Unconscious :
							EventJump('SeeUnconsciousBody');
							break;

						case CHANGE_Dead :
							EventJump('SeeDeadBody');
							break;

						case CHANGE_Grenade :
							EventJump('SeeLiveGrenade');
							break;
					}
                    break;

                default:
                    break;

			}
		}
	}


/***********************************************************************************************

	STATE : SEARCH -- RESPONSES TO INCOMING AIEVENTS

 ************************************************************************************************/



WaitSearch:

	plog("WaitSearch");
	WaitForGoal(1,GOAL_Search);
    CheckPlayerSeenOnce(1, 'SearchFailedAfterPlayerSeen');
	Jump('SearchFailed');


UpdateSearch:

    plog("UpdateSearch "); // depending on incoming event, might be good to stop the NPC and turn him around?
    //Goal_Stop(1, 25, 2.0f +  RandBias(0.50, 1.0f),,,,TriggerEvent.EventLocation);
    CheckLightSwitchVolumeAndAdd(1, TriggerEvent.EventLocation);
	Jump('UpdateSearchB');


UpdateSearchB:

	plog("UpdateSearchB "); // depending on incoming event, might be good to stop the NPC and turn him around?
	UpdateSearchTimer(1, 10.0f);   // add 10 seconds to search
	UpdateSearchGoal(1, TriggerEvent.EventLocation, false, true); // set new search location, disable focus switching, reset timer
	Jump('WaitSearch');


UpdateSearchTime:

	plog("UpdateSearchTime");
	UpdateSearchTimer(1, 10.0f);   // add 10 seconds to search
	Jump('WaitSearch');


SearchFailed:

	plog("SearchFailed");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SearchFailedOther;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50,, REACT_SearchFailed);
	GotoPatternState('Idle');


SearchFailedAfterPlayerSeen:

	plog("Search Failed after Player Already Seen.  Dammit.");
	Reaction(1, 50,, REACT_SearchFailed);
	WaitForGoal(1, GOAL_Action);
	ResetGoals(1);
	GotoPatternState('Idle');


////////////////////////////////
/// SEARCH BEHAVIOR TRIGGERS ///
////////////////////////////////
SeePlayer:

	log("SeePlayer -- Bureaucrat - "$Characters[1],,LPATTERN);
	PlayerIdentified();
    ChangeState(1,'s_alert');
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckFlags(bPlayerSeenOnce, true, 'RunAndHide');
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeePlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_Surprised);
	Jump('FirstTimeAlerted');


TakeDamage:

	log("TakeDamage -- Bureaucrat - "$Characters[1],,LPATTERN);
	PlayerIdentified();
    ChangeState(1,'s_alert');
	ePawn(Characters[1].Pawn).StopAllVoicesActor();
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	CheckFlags(bPlayerSeenOnce, true, 'RunAndHide');
	Jump('FirstTimeAlerted');


SeePlayerSurprised:

	log("SeePlayerSurprised -- Bureaucrat - "$Characters[1],,LPATTERN);
	PlayerIdentified();
    ChangeState(1,'s_alert');
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckFlags(bPlayerSeenOnce, true, 'RunAndHide');
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SurprisedByPlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_Surprised);
	Jump('FirstTimeAlerted');


LightsTurnedOff:

	plog("LightsTurnedOff -- bark and look around nervously, move to light switch and re-enable");
    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);
    UpdateSearchTimer(1, 10.0f);
    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {
        if (TriggerEvent.EventTarget.owner.GetStateName() == 's_Off')
        {
	        ePawn(Characters[1].Pawn).Bark_Type = BARK_LightsOut;
        }
        else    // s_On
        {
	        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
        }
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
        Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeLightsOut);
	    Broadcast(1, BC_SELF_DIRECTED);
    }
	CheckSwitchAlreadyLocked(1, TriggerEvent.EventTarget.owner);
	Jump('UpdateSearch');


LightsShotOut:

	plog("LightsShotOut");
    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);
    UpdateSearchTimer(1, 10.0f);
    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_LightShot;
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	    Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeLightsOut);
	    Broadcast(1, BC_SELF_DIRECTED);
    }
	Jump('UpdateSearch');

SeeUnconsciousBody:

	plog("SeeUnconsciousBody -- EventTarget:  " $ TriggerEvent.EventTarget);
	if (!EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats)
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeUnconscious;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	Goal(1, GOAL_InteractWith, 35,,,TriggerEvent.EventTarget,,,,,,MOVE_JogAlert);
    Broadcast(1, BC_INFO_RADIO_AWARE);
	Jump('UpdateSearch');

SeeDeadBody:

	plog("SeeDeadBody");
	if (!EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats)
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	if (EPawn(TriggerEvent.EventTarget) != none)
	{
		plog("   Time Since Death :  " $ Level.TimeSeconds - EPawn(TriggerEvent.EventTarget).TimeOfDeath);
		if (Level.TimeSeconds - EPawn(TriggerEvent.EventTarget).TimeOfDeath < 2.0f)
			Jump('SeeJustDied');
		else if (Level.TimeSeconds - EPawn(TriggerEvent.EventTarget).TimeOfDeath < 5.0f)
			Jump('SeeFreshMeat');
		else
			Jump('SeeDeadBodyCold');
	}
	else
		Jump('SeeDeadBodyCold');

SeeJustDied:

	plog("JustDied");
	ResetGoals(1);
    ChangeState(1,'s_alert');
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
    Broadcast(1, BC_INFO_BARK_ALERT);
	Jump('FirstTimeAlerted');

SeeDeadBodyCold:

	plog("SeeDeadBodyCold");
	ResetGoals(1);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
    Broadcast(1, BC_INFO_RADIO_ALERT);
	Jump('FirstTimeAlerted');

SeeAnotherNPCInterrogated:

	plog("SeeAnotherNPCInterrogated -- NOT HANDLED YET.");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_DropHim;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeInterrogation);
	SendCommunication(AI_LET_HIM_GO,TriggerEvent.EventTarget,0.8f);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('FirstTimeAlerted');


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEARCH RESPONSE TO AUDIO STIMULI
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HearGrenadeWarning:

	plog("HearGrenadeWarning");
	ResetGoals(1);
	Jump('RunAndHide');


HearWallMineTick:

	plog("HearWallMineTick");
	ResetGoals(1);
	Broadcast(1, BC_INFO_BARK_COVER);
	Jump('RunAndHide');


HearViolentNoise:

	plog("HearViolentNoise");
    CheckIfThreatNearby(1,'HearRicochet');
    Jump('Search_Location');


HearRicochet:

	plog("HearRicochet");
	PlayerIdentified();
	ResetGoals(1);
    ChangeState(1,'s_alert');
    ForceUpdatePlayerLocation(1);
	Reaction(1, 52, TriggerEvent.EventLocation, REACT_ImmediateThreat);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
    //WaitForGoal(1,GOAL_Action);
	Jump('FirstTimeAlerted');


HearFriendlyScream:

	plog("HearFriendlyScream");
	ResetGoals(1);
    ChangeState(1,'s_alert');
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Goal_Charge(1,36,None,MOVE_JogAlert,true,TriggerEvent.EventLocation);
	Goal_Stop(1, 35, 2.0f, TriggerEvent.EventTarget, MOVE_JogAlert);
	Jump('FirstTimeAlerted');


// ----- Action Labels -----

FirstTimeAlerted:
	PlayerIdentified();
	ResetGoals(1);
	ChangeState(1,'s_alert');
	SetFlags(bPlayerSeenOnce, true);
    CheckFlags(int(ePawn(Characters[1].Pawn).bJustHides), true, 'RunAndHide');
	CheckAlarmProximity(1,'RunToAlarm');
	DisableMessages(true);
	Sleep(0.0);
	DisableMessages(false);
    CheckNearestArmedNPC('ReachArmedNPC');
	Jump('RunAndHide');


ReachArmedNPC:

	plog("ReachArmedNPC");
	GotoPatternState('RunAway', 'ReachArmedNPC');


RunToAlarm:

	log("EA1Npc - RunToAlarm"@Characters[1],,LPATTERN);
	ChangeState(1,'s_alert');
	DisableMessages(true);
	bRunningAlarm = true;
	Goal(1,GOAL_InteractWith, 45,TriggerEvent.EventLocation,,TriggerEvent.EventTarget,,,,,,MOVE_JogAlert);
	WaitForGoal(1,GOAL_InteractWith, 'RunAndHide_EnableMessages');
	bRunningAlarm = false;
	DisableMessages(false);
	Jump('RunAndHide');


Search_Location:

	plog("Search_Location -- Search at Event Location THEN in Random Direction");
	Goal_Search(1, 15, TriggerEvent.EventLocation,,false);
	Jump('WaitSearch');

RunAndHide_EnableMessages:

	plog("RunAndHide_EnableMessages");
	bRunningAlarm = false;
	DisableMessages(false);

RunAndHide:

	plog("RunAndHide");
	GotoPatternState('RunAway', 'StartRun');


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFYING PSYCHOLOGICAL STATES
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

InfoBarkAware:

	plog("InfoBarkAware");
	ChangeState(1,'s_investigate');
	Goal_Stop(1, 50, 2.0f +  RandBias(0.50, 2.5f),,,,TriggerEvent.EventLocation);
	Jump('WaitSearch');


InfoBarkAlert:

	plog("InfoBarkAlert");
	ChangeState(1,'s_alert');
	Goal_Stop(1, 50, 2.0f +  RandBias(0.50, 2.5f),,,,TriggerEvent.EventLocation);
	Jump('WaitSearch');


InvestigateRequestFromGroupMember:

	plog("InfoBarkAware");
	ChangeState(1,'s_investigate');
	Goal_Stop(1, 50, 2.0f +  RandBias(0.50, 2.5f),,,,TriggerEvent.EventLocation);
	Jump('WaitSearch');


AttackRequestFromGroupMember:

	plog("AttackRequestFromGroupMember");
	Jump('RunAndHide');


AlarmBegin:

	plog("AlarmBegin");
	GotoPatternState('RunAway', 'StartRun');


}



/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////          Hide                  /////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

state Hide
{
	//------------------------------------------------------------------------
	//
	// Description
	//
	//
	//------------------------------------------------------------------------
	function BeginState()
	{
		EchelonLevelInfo(Level).SendMusicRequest(0,false,self);
		EchelonLevelInfo(Level).SendMusicRequest(1,false,self);

		ChangeState(1,'s_alert');
	}

	//----------------------------------------[David Kalina - 12 Oct 2001]-----
	//
	// Description
	//		OVERRIDEN Function so GotoPatternLabel calls are done w/in this state.
	//
	//------------------------------------------------------------------------

	function GotoPatternLabel(name label)
	{
		GotoState('Hide', label);
	}


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

				case AI_TAKE_DAMAGE:

					EventJump('TakeDamage');
					break;

                case AI_PLAYER_VERYCLOSE:

					EventJump('PlayerVeryClose');
					break;

			}
		}
	}

PlayerVeryClose:
	plog("PlayerVeryClose");
    if (BegForLife(1))
    {
        ePawn(Characters[1].Pawn).Bark_Type = BARK_BegForLife;
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1 , 0, false);
        Reaction(1, 50, Characters[0].Pawn.Location, REACT_AboutToDie);
        WaitForGoal(1, Goal_Action);
    }
    ResetGoals(1);
	Jump('RunAndHide');

WaitHide:

	plog("WaitHide");
	WaitForGoal(1,Goal_Wait);
    CheckIfPlayerUnseenWithin(ePawn(Characters[1].Pawn).fHideTime, 'EndHide');
	Jump('StartHide');

StartHide:

	plog("StartHide");
	SetHideGoal(1);
	//Goal_Stop(1, 14, 2.0f +  RandBias(0.50, 5.75f),,MOVE_CrouchJog);
	Jump('WaitHide');

TakeDamage:

	plog("TakeDamage");
	PlayerIdentified();
	ePawn(Characters[1].Pawn).StopAllVoicesActor();
	Sleep(0.5);
    ResetGoals(1);
	Jump('RunAndHide');

RunAndHide:

	plog("RunAndHide");
	GotoPatternState('RunAway', 'StartRun');

EndHide:

    plog("EndHide");        // Reset All Goals + return to Default behavior
	SetPostAttackBehavior(1);
    ChangeState(1,'s_Default');
    GotoPatternState('Idle');
    End();



}




/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////          RunAway                  //////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
state RunAway
{
	function Timer()
	{
		CheckAlarms();
		SetTimer(0.3f,false);
	}

    //------------------------------------------------------------------------
	//
	// Description
	//
	//
	//------------------------------------------------------------------------
	function BeginState()
	{
		EchelonLevelInfo(Level).SendMusicRequest(1,false,self);
		EchelonLevelInfo(Level).SendMusicRequest(0,true,self);

		ChangeState(1,'s_alert');
        ResetGoals(1);
		SetTimer(0.3f,false);
	}

	//----------------------------------------[David Kalina - 12 Oct 2001]-----
	//
	// Description
	//		OVERRIDEN Function so GotoPatternLabel calls are done w/in this state.
	//
	//------------------------------------------------------------------------

	function GotoPatternLabel(name label)
	{
		GotoState('RunAway', label);
	}


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
					break;


                // MClarke : experimental
               case AI_SHOT_BLOCKED:
                    log("BureaucratPattern - state RunAway - AI_SHOT_BLOCKED");
                    GotoPatternLabel('RunFailed');
                    break;
			}
		}
	}




WaitRun:

	plog("WaitRun");
	WaitForGoal(1,Goal_MoveTo, 'RunFailed');
	GotoPatternState('Hide', 'StartHide');
    End();


ReachArmedNPC:

	plog("ReachArmedNPC");
	Goal(1,GOAL_MoveTo, 15, GetNearestArmedNPC().Location,,,,,,,,MOVE_JogAlert);
	//Goal_Charge(1,15,None,MOVE_JogAlert,true,GetNearestArmedNPC().Location,true);
	WaitForGoal(1,GOAL_MoveTo,'AlarmBegin');
	plog("Ask to another NPC for Help");
	AlarmNPC(GetNearestArmedNPC());
	Jump('StartRun');

AlarmBegin:
    plog("AlarmBegin");
	Jump('StartRun');

StartRun:

	plog("StartRun");
    ResetGoals(1);
	if (EAIController(Characters[1]).ePawn.bUsePostAttackSetup)
	{
		SetPostAttackBehavior(1);
		Jump('End');
	}
	else
	{
		SetPostAttackBehavior(1); //be sure the postattack behavior is set
		DisableMessages(true);
		Sleep(0.0);
		DisableMessages(false);
		SetHidePointMoveTo(1, 35, MOVE_JogAlert);
		Jump('WaitRun');
	}

RunToAlarm:

	log("EA1Npc - RunToAlarm"@Characters[1],,LPATTERN);
	ChangeState(1,'s_alert');
	DisableMessages(true);
	bRunningAlarm = true;
	Goal(1,GOAL_InteractWith, 45,TriggerEvent.EventLocation,,TriggerEvent.EventTarget,,,,,,MOVE_JogAlert);
	WaitForGoal(1,GOAL_InteractWith, 'RunAndHide_EnableMessages');
	bRunningAlarm = false;
	DisableMessages(false);
	Jump('RunAndHide');


RunFailed:

    plog("RunFailed"); // Most probably because Sam was in our way. Choose another Hide Point
    if (BegForLife(1))
    {
        ePawn(Characters[1].Pawn).Bark_Type = BARK_BegForLife;
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1 , 0, false);
        Reaction(1, 50, Characters[0].Pawn.Location, REACT_AboutToDie);
        WaitForGoal(1,Goal_Action);
    }
    Sleep(0.0);
    Jump('StartRun');


End:
    plog("End");

}

