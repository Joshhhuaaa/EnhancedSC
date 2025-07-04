
class SpetsnazPattern extends EPattern;

/////////////////////////////////////////////////////////////////////////////////////////////
//FLAGS//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

var int bFirstTimeCharge;
var int bRunForAttackPoint;
var int bReactedToAlarm;
var bool bSearchWasDogTriggered;
var bool bExplosionStimuli;
var float LastRevive;
var int bRunningCoverPoint;

//---------------------------------------[David Kalina - 12 Oct 2001]-----
// 
// Description
//		Display Debug information on screen. 
//
//------------------------------------------------------------------------

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local String T;

	Super.DisplayDebug(Canvas, YL, YPos);
	
	Canvas.DrawColor.B = 200;	
	Canvas.DrawColor.R = 170;
	Canvas.DrawColor.G = 255;
	
	T = "SpetsnazPattern.  bCharge = " $ bCharge;
	
	Canvas.SetPos(4,YPos);
	Canvas.DrawText(T,false);
}


//---------------------------------------[David Kalina - 12 Oct 2001]-----
// 
// Description
//		If Pattern not started, do so now. 
//
//------------------------------------------------------------------------

/*function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
	Log("EVENTCALLBACK being called outside a state -- start pattern.");
	
	StartPattern();
}
*/


//---------------------------------------[Frederic Blais - 18 Oct 2001]-----
// 
// Description
//		Adjust the default pattern  state considering the current goal
//		running.
//
//------------------------------------------------------------------------
event AdjustDefaultPatternState(EchelonEnums.GoalType _GoalT)
{

	switch(_GoalT)
	{
		case GOAL_Attack:
		case GOAL_Charge:
			if(GetStateName() != 'Attack')
			{
				//log("AdjustDefaultPatternState (Attack): "$self);
				//GotoPatternState('Attack');
			}
			break;
		case GOAL_Search:
			if(GetStateName() != 'Search')
			{
				//log("AdjustDefaultPatternState (Search): "$self);
				//GotoPatternState('Search');
			}
			break;
		default:
			break;
	}

	
}


/***************************************************************************************************************************************
		           *********************************************************************************************************************
							                       *************************************************************************************
																				********************************************************


		
			STATE 'Idle'

			Initial Default Pattern State.  
			Responsible for handling all incoming AIEvents for the first time.




  ********************************************************
  *************************************************************************************
  *********************************************************************************************************************
  ***************************************************************************************************************************************/


auto state Idle
{

	//----------------------------------------[David Kalina - 5 Oct 2001]-----
	// 
	// Description
	//		No need to override here.  Example. 
	//	
	//------------------------------------------------------------------------
	
	function GotoPatternLabel(name label)
	{
		//log("GotoPatternLabel  Idle   Label: "$label);
		GotoState('Idle', label);
	}

	function BeginState()
	{
		if(!bDontResetMusic)
		{
		EchelonLevelInfo(Level).SendMusicRequest(0,false,self);
		EchelonLevelInfo(Level).SendMusicRequest(1,false,self);
		}

		//reset the flag
		bDontResetMusic=false;

		ReloadWeapon(1,1);


		if((Characters[1]!= None) && (Characters[1].GetStateName() == 's_Alert'))
        {
			EAIController(Characters[1]).GotoStateSafe('s_Investigate');
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
		if(!CheckGoalPriority(50)  && (Characters[1].GetStateName() != 's_SitDown') && !bDisableMessages)
		{
			switch ( Event.EventType )
			{
				case AI_HEAR_SOMETHING :
					
					switch ( Event.EventNoiseType )
					{
						case NOISE_GrenadeWarning : 
							
							//Goal_Action(...);
							return;
                        
                        case NOISE_Ricochet:

                        if(fLastReflexTime < (Level.TimeSeconds - 5.0f))
                        {							
							plog("REFLEX -- Noise Ricochet response.");
							Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
                            fLastReflexTime = Level.TimeSeconds;							
                        }

                        return;
								
						case NOISE_DyingGasp :
						case NOISE_Explosion :	
							plog("REFLEX -- Dying Gasp / Explosion reaction.");
							Reaction(1, 50, Event.EventLocation, REACT_ImmediateThreat);
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
	function CommunicationCallBack(AIEventType eType)
	{
		switch ( eType )
		{
			case AI_LET_HIM_GO:
				ePawn(Characters[1].Pawn).Bark_Type = BARK_ShootHim;
				Characters[1].Pawn.PlaySound(ePawn(Characters[1].Pawn).Sounds_Barks, SLOT_Barks);
				break;
		}
	}


	//----------------------------------------[David Kalina - 5 Oct 2001]-----
	// 
	// Description
	//		Handle incoming AIEvents by jumping to the appropriate label. 
	// 
	//------------------------------------------------------------------------

	event EventCallBack(EAIEvent Event,Actor TriggerActor)
	{

		if(EAIController(Characters[1]).bNotResponsive)
			return;

		if(!bDisableMessages)
		{

			switch(Event.EventType)
			{
				/*******  EXTERNAL EVENTS  ********************************************/

				case AI_SEE_NPC:
                    EventJump('Greetings');
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

				case AI_SHOT_JUST_MISSED :
					
					EventJump('ShotJustMissedMe');
					break;

				case AI_HEAR_SOMETHING:
					
					switch ( Event.EventNoiseType )
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

							EventJump('HearDamageScream');
							break;


						case NOISE_DyingGasp :

							EventJump('HearFriendlyScream');
							break;

						case NOISE_GrenadeWarning :

							EventJump('HearGrenadeWarning');
							break;

						case NOISE_Alarm :

							log("NOISE_Alarm used?");
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

						case NOISE_TakeCover:
							EventJump('RequestTakeCover');
							break;

                        case NOISE_TurretGunfire :
                            EventJump('HearTurretFire');
                            break;

					}
					break;

				case AI_SEE_CHANGED_ACTOR:
					
					plog("SEE_CHANGED_ACTOR : " $ Event.EventTarget $ "   CHANGE TYPE : " $ Event.EventTarget.ChangeType);

					Level.RemoveChange(Event.EventTarget);		// !!! Don't forget to remove changed actor after handling it !!!

					switch ( Event.EventTarget.ChangeType )
					{
						case CHANGE_Flare :
							EventJump('SeeFlare');
							break;
						
						case CHANGE_Bleeding :
							EventJump('SeeViolence');
							break;

						case CHANGE_WallMine :
							EventJump('SeeWallMine');
							break;

						case CHANGE_Footprints :
							EventJump('SeeFootprints');
							break;

						case CHANGE_DisabledTurret :
							EventJump('SeeDisabledMachinery');
							break;
							
						case CHANGE_DisabledCamera :
							EventJump('SeeBrokenMachinery');
							break;

						case CHANGE_BrokenObject :
							EventJump('SeeBrokenGlass');
							break;

						case CHANGE_BrokenDoor :
							EventJump('SeeBrokenDoor');
							break;

						case CHANGE_Object :
							EventJump('SeeObject');
							break;

						case CHANGE_AirCamera :
							EventJump('SeeAirCamera');
							break;
						
						case CHANGE_ScorchMark :
							EventJump('SeeScorchMark');
							break;

						case CHANGE_BloodStain :
							EventJump('SeeBloodStain');
							break;

						// TODO : For CHANGE_Light* ---> has room gone pitch black??
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




				/*******  INTERNAL EVENTS  ********************************************/


				case AI_PLAYER_DEAD:
					EventJump('PlayerDead');
					break;

				case AI_LOST_PLAYER:
					EventJump('PlayerLost');
					break;
					
				case AI_PLAYER_VERYCLOSE:
				case AI_PLAYER_CLOSE:
				case AI_PLAYER_FAR:
					break;

				case AI_PATROL_TIMEOUT:
					EventJump('PatrolTimeOut');

				case AI_INVESTIGATE:
					EventJump('InvestigateRequestFromGroupMember');
					break;

				case AI_ATTACK:
				case AI_ALARM_UPDATE_POSITION:
					EventJump('AttackRequestFromGroupMember');
					break;

				case AI_SEE_PLAYER_AGAIN:
					EventJump('SeePlayerAgain');
					break;


				case AI_RELEASED:
					EventJump('Released');
					break;

				case AI_REVIVED:
					EventJump('Revived');
					break;

				case AI_NEARLY_DEAD:
					break;

				case AI_INTERROGATION_QUERY_SAM:
					EventJump('InterrogatedResponse');
					break;

				case AI_INTERROGATION_QUERY_NPC:
					EventJump('InterrogatedResponseToNPC');
					break;

				case AI_FORCED_RETINAL_SCAN:
					EventJump('RetinalScanned');
					break;

				case AI_GROUP_LAST_MEMBER:
					EventJump('GroupLastMember');
					break;

				case AI_MASTER_OUT_OF_RADIUS:
					EventJump('SlaveRequestFollow');
					break;

				default:
					break;
			}
		}
	}



/***********************************************************************************************

	STATE : IDLE -- DEFAULT RESPONSES TO INCOMING AIEVENTS

 ************************************************************************************************/



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIAL RESPONSE TO AUDIO STIMULI
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
HearSomethingQuiet:
	
	plog("HearSomethingQuiet"); // straighten up, look around, search at source of sound
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardFoot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_CuriousNoise);
	Broadcast(1, BC_SELF_DIRECTED);
	Jump('Search_Location');
	
HearSomethingInvestigate:
	
	plog("HearSomethingInvestigate - turn towards EventLocation call Search_Location"); // straighten up, turn towards noise, search
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardFoot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_AlarmingNoise);		// then look around
	//Radio();
	Broadcast(1, BC_INFO_BARK_AWARE);
	Jump('Search_Location');

HearDoorOpening:

	plog("HearDoorOpening"); // straighten up, turn towards noise, search
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardFoot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_CuriousNoise);
	Jump('Search_Location');
	
HearGrenadeWarning:
	
	plog("HearGrenadeWarning");
	// move away from grenade landing point.  
	// delay x seconds based on state
	End();
	
HearFriendlyScream:
	
	plog("HearFriendlyScream");	//run in the direction of the scream, wait ... and search
	ResetGoals(1);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
	Goal_MoveTo(1, 35, TriggerEvent.EventTarget.Location, MOVE_JogAlert);
	Goal_Stop(1, 34, 2.0f +  RandBias(0.50, 3.75f), TriggerEvent.EventTarget, MOVE_JogAlert);
	Jump('Search_Directional');


HearDamageScream:

	plog("HearDamageScream");	//run in the direction of the scream, wait ... and search
	ResetGoals(1);
	Jump('Search_Directional');


HearWallMineTick:
	
	plog("HearWallMineTick"); // panic, look around helplessly
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_AboutToDie);
	WaitForGoal(1, GOAL_Action);
	ResetGoals(1);
	Broadcast(1, BC_INFO_BARK_COVER);
	//PossiblyTakeCover(1,1500,'TakeCoverAndWait',TriggerEvent.EventLocation); // try to find cover from the wall mine
	Jump('Search_Directional');


RequestTakeCover:

	plog("RequestTakeCover");
	PossiblyTakeCover(1,1500,'TakeCoverAndWait',TriggerEvent.EventLocation); // try to find cover from the wall grenade
	End();


TakeCoverAndWait:
	
	plog("TakeCoverAndWait");
	Goal_MoveTo(1, 35, CoverLocation, MOVE_JogAlert,,MOVE_JogAlert);
	Goal_Stop(1, 34,10f +  RandBias(0.85, 5.75f), Characters[0].Pawn, MOVE_JogAlert);
	GotoPatternState('TakeCover', 'WaitCover');


HearGunshot:

	plog("HearGunshot");					// straighten up, turn towards noise, search
	CheckIfThreatNearby(1,'HearRicochet');	// if gunshot is nearby, treat gunshot as if it were a ricochet
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardGunShot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_DistantThreat);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Jump('Search_Location');

HearTurretFire:

	plog("HearTurretFire");					// straighten up, turn towards noise, search
	CheckIfThreatNearby(1,'HearCloseTurretFire');	// if gunshot is nearby, treat gunshot as if it were a ricochet
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardGunShot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_DistantThreat);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Jump('Search_Location');

HearCloseTurretFire:

	plog("HearCloseTurretFire");			// Same as HearRIchochet, but no UpdatePlayerLoc nor alarm
	ResetGoals(1);	
	//ForceUpdatePlayerLocation(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardGunShot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
	//Radio();
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	//CheckAlarmProximity(1,'AlarmAttack',200); //check if NPC is stick to an alarm
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	//CheckAlarmProximity(1,'AlarmAttack');
	Jump('AttackPlayer');

	
HearRicochet:
	
	plog("HearRicochet");					// duck, look around, stand back up -- move in direction of shot
	PlayerIdentified();
	ResetGoals(1);	
	//ForceUpdatePlayerLocation(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}

	CheckIfDirectLine(1,Characters[0].pawn,'HearRicochetB');

	if(Characters[1].GetStateName() != 's_SitDown')
	{
		Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
		DisableMessages(true);
		WaitForGoal(1,GOAL_Action);
		DisableMessages(false);
	}

	Broadcast(1, BC_BACKUP_RADIO_ATTACK);

	CheckAlarmProximity(1,'AlarmAttack',250); //check if NPC is stick to an alarm
	EAIController(Characters[1]).LastKnownPlayerTime = Level.TimeSeconds-15;
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	CheckAlarmProximity(1,'AlarmAttack');
	Jump('AttackPlayer');


HearRicochetB:

	plog("HearRicochetB");
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	GotoPatternState('attack', 'BlindFire');

HearExplosion:
	
	plog("HearExplosion");					// duck and run, search in direction of sound
	CheckIfThreatNearby(1,'HearRicochet');	// if gunshot is nearby, treat gunshot as if it were a ricochet
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardGunShot;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_DistantThreat);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	bExplosionStimuli=true;
	Jump('Search_Location');
	
	
	



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIAL RESPONSE TO VISUAL STIMULI
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	
SeePlayer:
	
	plog("SeePlayer");
	PlayerIdentified();
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeePlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckAlarmProximity(1,'AlarmAttack');
	CheckPlayerSeenOnce(1, 'AttackPlayer');
	// no Goal_Action (radio?)
	Jump('AttackPlayer');
	
SeePlayerSurprised:
	
	plog("SeePlayerSurprised");
	PlayerIdentified();
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SurprisedByPlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckAlarmProximity(1,'AlarmAttack',100);	//check if NPC is stick to an alarm
	CheckPlayerSeenOnce(1, 'AttackPlayer');
	Jump('AttackPlayerSurprised');

	
TakeDamage:
	
	plog("TakeDamage");
	PlayerIdentified();
	ePawn(Characters[1].Pawn).StopAllVoicesActor();
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HitByBullet;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckAlarmProximity(1,'AlarmAttack',100);	//check if NPC is stick to an alarm
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	CheckAlarmProximity(1,'AlarmAttack');
	ResetGoals(1);
	Jump('AttackPlayer');


SeePlayerInvestigate:
	
	plog("SeePlayerInvestigate");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeSomethingMove;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_INFO_BARK_AWARE);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeUnknownPerson);
	Jump('Search_Location');
	
SeeLiveGrenade:
	
	plog("SeeLiveGrenade");
	PlayerIdentified();
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_GroupScatter;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);

	//CheckIfDirectLine(1,Characters[0].pawn,'HearRicochetB');

	if(Characters[1].GetStateName() != 's_SitDown')
	{
		Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeGrenade);
		DisableMessages(true);
		WaitForGoal(1,GOAL_Action);
		DisableMessages(false);
	}

	Broadcast(1, BC_INFO_BARK_COVER);
	PossiblyTakeCover(1,1500,'TakeCoverAndWait',TriggerEvent.EventLocation); // try to find cover from the wall grenade
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	Jump('AttackPlayer');

SeeLiveGrenadeB:

	plog("SeeLiveGrenadeB");
	Broadcast(1, BC_INFO_BARK_COVER);
	GotoPatternState('attack', 'BlindFire');



SeeUnconsciousBody:
	
	plog("SeeUnconsciousBody -- EventTarget:  " $ TriggerEvent.EventTarget);
	if ( !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats )
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	ResetGoals(1);
	bReactedToAlarm=1; //to trigger the postattack behavior
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeUnconscious;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_INFO_RADIO_AWARE);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	if ( !ePawn(TriggerEvent.EventTarget).bNoUnconsciousRevival )
		Goal(1, GOAL_InteractWith, 35,,,TriggerEvent.EventTarget,,,,,,MOVE_JogAlert);
	Jump('Search_Location');
	
SeeDeadBody:
	
	plog("SeeDeadBody" );
	if ( !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats )
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	bReactedToAlarm=1; //to trigger the postattack behavior
	if ( EPawn(TriggerEvent.EventTarget) != none ) 
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
	PlayerIdentified();
	ResetGoals(1);
    if(!ePawn(TriggerEvent.EventTarget).bIsDog)
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
    else
        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	CheckAlarmProximity(1,'AlarmAttack',100);
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	CheckAlarmProximity(1,'AlarmAttack');
	Jump('AttackPlayer');


SeeViolence:

	plog("SeeViolence");
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeBody);
	Jump('Search_Location');
	
SeeFreshMeat:
	
	plog("SeeFreshMeat");	
	ResetGoals(1);
    if(!ePawn(TriggerEvent.EventTarget).bIsDog)
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
    else
        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	CheckLightSwitchProximity(1,'TurnSwitchOn');
	CheckAlarmProximity(1, 'AlarmSearch');
	Jump('Search_Location');

	
SeeDeadBodyCold:
	
	plog("SeeDeadBodyCold");
	ResetGoals(1);
    if(!ePawn(TriggerEvent.EventTarget).bIsDog)
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
    else
        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_INFO_RADIO_ALERT);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);

	//Do not interact with Pawn in fire
	if( TriggerEvent.EventTarget.bIsPawn  && EPawn(TriggerEvent.EventTarget).BodyFlames.Length == 0)
	{
	Goal_MoveTo(1, 36, TriggerEvent.EventTarget.Location, MOVE_JogAlert);
	Goal_Action(1, 35, TriggerEvent.EventTarget.Location, ePawn(Characters[1].Pawn).ACheckDeadBody);
	}

	CheckLightSwitchProximity(1,'TurnSwitchOn');
	Jump('Search_Location');

TurnSwitchOn:

	plog("LightsShotOut -- bark and look around nervously, NO SEARCH.");
	Goal(1, GOAL_InteractWith, 20,,,TriggerEvent.EventTarget,,,,,1.0);
	Jump('Search_Location');

	
SeeObject:
	
	plog("SeeObject - watch it for a second and then search");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	Broadcast(1, BC_SELF_DIRECTED);
	Reaction(1, 50,, REACT_MovingObject, TriggerEvent.EventTarget);
	if ( VSize(TriggerEvent.EventTarget.Velocity) > 10.0f )
		Jump('Search_Origin');
	else
		Jump('Search_Location');
	
SeeAirCamera:
	
	plog("SeeAirCamera - check it out directly -- REACT_MovingObject");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	Reaction(1, 51,, REACT_MovingObject, TriggerEvent.EventTarget);		// specify target so we 'watch' the object if it's moving
	Goal_MoveTo(1, 21, TriggerEvent.EventTarget.Location + vector(TriggerEvent.EventTarget.Rotation) * 100.0f, MOVE_WalkAlert);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeUnknownPerson);

	if(EGamePlayObject(TriggerEvent.EventTarget) != None)
	{
		EGamePlayObject(TriggerEvent.EventTarget).bWasSeen=true;
	}

	Broadcast(1, BC_SELF_DIRECTED);
	Jump('Search_Location');
	
SeeFootprints:

	plog("SeeFootprints - NYI");
	ResetGoals(1);
	Broadcast(1, BC_SELF_DIRECTED);
	Jump('Search_Directional');

SeeDisabledMachinery:

	plog("SeeDisabledMachinery (TURRET)");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeHackedTurret;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_INFO_RADIO_AWARE);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_BrokenObject);
	Goal(1, GOAL_InteractWith, 35,,,TriggerEvent.EventTarget);
	End();
	

SeeBrokenMachinery:
	
	plog("SeeBrokenMachinery (CAMERA)"); // right now, this means we see a broken camera
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeBrokenCamera;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_INFO_RADIO_AWARE);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_BrokenObject);
	Jump('Search_Directional');

SeeBrokenDoor:

	plog("SeeBrokenDoor"); 	// bark and investigate in direction of changed actor
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_SELF_DIRECTED);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_BrokenObject);
	Jump('Search_Directional');
	
SeeBrokenGlass:

	plog("SeeBrokenGlass"); // bark and investigate in direction of changed actor
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_SELF_DIRECTED);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_BrokenObject);
	Jump('Search_Directional');

SeeScorchMark:
	
	plog("SeeScorchMark"); 	// bark and investigate in direction of changed actor
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location);
	Broadcast(1, BC_SELF_DIRECTED);
	Jump('Search_Directional');
	
SeeBloodStain:

	/*plog("SeeBloodStain"); 	// bark and investigate in direction of changed actor
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeBlood;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false); 
	Reaction(1, 50, TriggerEvent.EventTarget.Location);
	Broadcast(1, BC_SELF_DIRECTED);
	Jump('Search_Directional');*/
	
SeeFlare:	

	plog("SeeFlare"); // investigate in direction of changed actor
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeSomethingMove;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_MovingObject);
	Jump('Search_Directional');

SeeWallMine:

	plog("SeeWallMine");
	// must be x% chance of noticing (before event is sent)
	// slowly move towards mine and disable, then search
	// Reaction(...)
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;               // Now replaces BARK_SeeWallMine
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeWallMine);
	Goal(1, GOAL_InteractWith, 35,,,TriggerEvent.EventTarget);			// TODO : Set MoveFlag so we move VERY slowly ...
	Jump('Search_Directional');

LightsTurnedOff:

	plog("LightsTurnedOff -- bark and look around nervously, move to light switch and re-enable, NO SEARCH.  Light OWNER: " $ TriggerEvent.EventTarget.owner);
	
    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);

    // Debug
    switch(iSuggestedBehavior)
    {
        case 0:log("Idle - LightsTurnedOff - Do Nothing"); break; 
        case 1:log("Idle - LightsTurnedOff - Bark Only"); break;
        case 2:log("Idle - LightsTurnedOff - Search Only"); break;
        case 3:log("Idle - LightsTurnedOff - Bark and Search"); break;
        default: break;
    }
    
    ResetGoals(1);

    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {
        if(TriggerEvent.EventTarget.owner.GetStateName() == 's_Off')
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

	ChangeState(1,'s_investigate');

	EAIController(Characters[1]).EPawn.ForceFlashLight=false;
    CheckSwitchAlreadyLocked(1, TriggerEvent.EventTarget.owner);
	
    if ((iSuggestedBehavior & SEARCH_BIT) == SEARCH_BIT)
    {
        log("SEARCH_BIT was on jumping to Search_Directional");
	    Jump('Search_Directional');        
    }

	End();


LightsShotOut:

	plog("LightsShotOut -- bark and look around nervously, NO SEARCH.");

    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);

    // Debug
    switch(iSuggestedBehavior)
    {
        case 0:log("Idle - LightsShotOut - Do Nothing"); break; 
        case 1:log("Idle - LightsShotOut - Bark Only"); break;
        case 2:log("Idle - LightsShotOut - Search Only"); break;
        case 3:log("Idle - LightsShotOut - Bark and Search"); break;
        default: break;
    }

	ResetGoals(1);

    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {

	    ePawn(Characters[1].Pawn).Bark_Type = BARK_LightShot;
	    Talk(EPawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	    Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeLightsOut);
        Broadcast(1, BC_SELF_DIRECTED);
    }

	ChangeState(1,'s_investigate');
	EAIController(Characters[1]).EPawn.ForceFlashLight=false;

    if ((iSuggestedBehavior & SEARCH_BIT) == SEARCH_BIT)
    {
        log("SEARCH_BIT was on jumping to Search_Directional");
	    Jump('Search_Directional');        
    }
	
	End();


		
RoomWentPitchBlack:
	
	// NOTE : NOT REFERENCED YET
	plog("RoomWentPitchBlack");	
	// walk slowly with hands out, towards a light switch if available, or rooms exit
	ResetGoals(1);
	Broadcast(1, BC_SELF_DIRECTED);
	End();
	
ShotJustMissedMe :
	
	plog("Shot just missed me - NYI"); // duck and run in random direction, then search
	Jump('HearRicochet');
	
	
SeeAnotherNPCInterrogated:
	
	plog("SeeAnotherNPCInterrogated -- NOT HANDLED YET.");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_DropHim;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeInterrogation);
	SendCommunication(AI_LET_HIM_GO,TriggerEvent.EventTarget,0.8f);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('AttackPlayer');	
	End();
	



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INTERNAL STIMULI
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SlaveRequestFollow:

	plog("SlaveRequestFollow");
    bSearchWasDogTriggered = true;
    ePawn(Characters[1].Pawn).Bark_Type = BARK_DogHasScent;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Jump('Search_LocationFocus');

	
PatrolTimeOut:

	plog("PatrolTimeOut : wHERE'S Mah tRIGGUH?");
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_BrokenObject);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Jump('Search_Directional');


Released:
	
	plog("Released by player -- turn towards player");
	Goal_Stop(1, 50, 3.0f, Characters[0].Pawn, MOVE_WalkNormal);
	End();

	
Revived:

	plog("Revived");
	ResetGoals(1);
	Jump('Search_Directional');
	

NearlyDead:
	
	plog("Nearly Dead -- NOT HANDLED YET");

	// % time panic, run, and hide
	// % time drop to knees, beg for life ..

	End();
	
InterrogatedResponse:
	
	plog("Being Interrogated by Sam -- standard response?");
	End();
	
InterrogatedResponseToNPC:
	
	plog("Being Interrogated and another NPC just yelled at Sam to drop our ass.");

	ePawn(Characters[1].Pawn).Bark_Type = BARK_ShootHim;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_SELF_DIRECTED);
	
	End();
	
RetinalScanned:
	
	plog("Retinal Scanned - grunt here.");
	End();
	
GroupLastMember:
	
	plog("GroupLastMember -- NOT HANDLED YET.");
	End();
	
	
PlayerDead:

	plog("PlayerDead");
	//ResetGoals(1);
    Sleep(3);
    ResetAllNPCs(1);
	SetPlayerDeadAction(1);
    WaitForGoal(1,GOAL_MoveTo,);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_PlayerKilled;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	WaitForGoal(1,GOAL_Action,);
	ResetGroup();
	GotoPatternState('Idle');
	End();

Greetings:
   plog("Greetings");
   if(ePawn(Characters[1].Pawn).ICanBark())
   {
        log("Greet other dude");
		ePawn(Characters[1].Pawn).Bark_Type = BARK_NormalGreeting;
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
   }
   End();
	
	
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEARCH BEHAVIOR TRIGGERS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		

Search_Location:

	plog("Search_Location -- Search at Event Location THEN in Random Direction");
	GotoPatternState('Search', 'Search_Location');

Search_Directional:

	plog("Search_Directional -- Search at Event Location THEN in Event Direction");
	GotoPatternState('Search', 'Search_Directional');
	
Search_Origin:

	plog("Search_Origin -- Search at Event Location THEN in Origin Direction");
	GotoPatternState('Search', 'Search_Origin');

Search_GeneralDirection:
	
	plog("Search_GeneralDirection -- In Direction of Event");
	GotoPatternState('Search', 'Search_GeneralDirection');

Search_General:

	plog("Search_General -- Use Last Known Player Location OR Forward Direction");
	GotoPatternState('Search', 'Search_General');

Search_CHEAT:
	
	log("Search_CHEAT -- Using Current Player Location as search key.   ** REPLACE **");
	GotoPatternState('Search', 'Search_CHEAT');

Search_LocationFocus:
	GotoPatternState('Search', 'Search_LocationFocus');
	

// auxiliary search calls - intent is to do something before jumping to specific appropriate search label
	
AlarmSearch:
	
	plog("AlarmSearch");
    ChangeState(1,'s_alert');
	DisableMessages(true);
	bRunningAlarm=true;
	Goal(1,GOAL_InteractWith, 9,TriggerEvent.EventLocation,,TriggerEvent.EventTarget,,,,true,,MOVE_JogAlert  );
	WaitForGoal(1,GOAL_InteractWith);
	bRunningAlarm=false;
	DisableMessages(false);
	Jump('Search_General');

	
InvestigateRequestFromGroupMember:

	plog("InvestigateRequestFromGroupMember");
	ResetGoals(1);
	ChangeState(1,'s_investigate');
	Goal_Stop(1, 50, 1.0f +  RandBias(0.50, 2.0f),, MOVE_Search,,TriggerEvent.EventLocation);
    if(ePawn(Characters[1].Pawn).ICanBark())
	{
		ePawn(Characters[1].Pawn).Bark_Type = BARK_CombArea;
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 4, 0, false);
	}
	Jump('Search_Location');


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFYING PSYCHOLOGICAL STATES
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

InfoBarkAware:

	plog("InfoBarkAware");
	ChangeState(1,'s_investigate');
	Goal_Stop(1, 50, 2.5f +  RandBias(0.50, 2.5f),,,,TriggerEvent.EventLocation);
	Goal(1,GOAL_Action, 7,,,,, 'LookStNmRt0',);
	Goal(1,GOAL_Action, 8,,,,, 'LookStNmRt0',);
	Goal(1,GOAL_Action, 9,,,,, 'LookStNmLt0',);

	End();


InfoBarkAlert:

	plog("InfoBarkAlert");
	ChangeState(1,'s_alert');
	Goal_Stop(1, 50, 2.5f +  RandBias(0.50, 2.5f),,,,TriggerEvent.EventLocation);
	End();



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ATTACK BEHAVIOR TRIGGERS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
AttackRequestFromGroupMember:
	
	plog("AttackRequestFromGroupMember");
	ChangeState(1,'s_alert');
	ForceUpdatePlayerLocation(1);
	CheckAlarmProximity(1,'AlarmAttack');
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	ResetGoals(1);
	Jump('AttackPlayer');

	
SeePlayerAgain:
	
	plog("SeePlayerAgain.");
	PlayerIsVisible(1,'PlayerLost');
	ResetGoals(1);
	Jump('AttackPlayer');

	
PlayerInZone:

	ResetGoals(1);
	log("Player In Zone - IDLE "$Characters[1].pawn);
	GotoPatternState('Attack', 'PlayerInZone');

AlarmAttack:
	
	plog("AlarmAttack");
    ChangeState(1,'s_alert');
	DisableMessages(true);
	bRunningAlarm=true;
	Goal(1,GOAL_InteractWith, 45,TriggerEvent.EventLocation,,TriggerEvent.EventTarget,,,,true,,MOVE_JogAlert);
	WaitForGoal(1,GOAL_InteractWith);
	bRunningAlarm=false;
	DisableMessages(false);
	//AllGroupLostPlayer('AttackedFromUnknownLocation');
	//Jump('AttackPlayer');
	Jump('AttackedFromUnknownLocation');

AlarmBegin:

	plog("AlarmBegin - response to an alarm call");
	ResetGoals(1);
	GotoPatternState('Attack', 'AlarmAttack');
	End();

AttackPlayer:
	
	plog("AttackPlayer");
	PlayerIdentified();
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Attack', 'AttackPlayer');
	End();	

AttackPlayerSurprised:

	plog("AttackPlayer - surprised");
	PlayerIdentified();
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Attack', 'AttackPlayerSurprised');
	End();	


AttackedFromUnknownLocation:
	
	plog("AttackedFromUnknownLocation");
	PlayerIdentified();
	//ForceUpdatePlayerLocation(1);
	AskGroupForPlayerPosition('SamIsSeenByOneMember');
	GotoPatternState('Attack', 'AttackedFromUnknownLocation');
	End();	

SamIsSeenByOneMember:

	plog("SamIsSeenByOneMember");
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Attack', 'PlayerLost');
	End();	
	

}




/***************************************************************************************************************************************
		           *********************************************************************************************************************
							                       *************************************************************************************
																				********************************************************


		
			STATE 'TakeCover'




  ********************************************************
  *************************************************************************************
  *********************************************************************************************************************
  ***************************************************************************************************************************************/

state TakeCover
{
	
	function BeginState()
	{
		//ChangeState(1,'s_alert');
	}


	//----------------------------------------[Frederic Blais - 12 Oct 2001]-----
	// 
	// Description
	//		OVERRIDEN Function so GotoPatternLabel calls are done w/in this state.
	//	
	//------------------------------------------------------------------------
	
	function GotoPatternLabel(name label)
	{
		GotoState('Search', label);
	}

	
	
	//---------------------------------------[Frederic Blais - 10 Oct 2001]-----
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
		if(!CheckGoalPriority(50) && !bDisableMessages)
		{
			switch ( Event.EventType )
			{
				case AI_HEAR_SOMETHING :
					
					switch ( Event.EventNoiseType )
					{
						case NOISE_GrenadeWarning : 
							return;
							
						case NOISE_DyingGasp :
						case NOISE_Explosion :	
							plog("REFLEX - Dying Gasp Response / Explosion reaction.");
							Reaction(1, 50, Event.EventLocation, REACT_ImmediateThreat);
							
							return;
					}
					
					break;
			}
		}
	}
	

	//----------------------------------------[Frederic Blais - 5 Oct 2001]-----
	// 
	// Description
	//		Handle incoming AIEvents by jumping to the appropriate label. 
	// 
	//------------------------------------------------------------------------
	
	event EventCallBack(EAIEvent Event,Actor TriggerActor)
	{

		if(EAIController(Characters[1]).bNotResponsive)
			return;

		if(!bDisableMessages)
		{
			switch(Event.EventType)
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

				case AI_SEE_PLAYER_AGAIN:
					EventJump('SeePlayerAgain');
					break;


				/*******  INTERNAL EVENTS  ********************************************/


				case AI_ATTACK:
					EventJump('AttackRequestFromGroupMember');
					break;

		
				default:
					break;


			}
		}
	}

WaitCover:

	plog("WaitCover");
	WaitForGoal(1,GOAL_MoveTo,'CoverFailed');
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	Jump('AttackPlayer');


CoverFailed:

	plog("Cover Failed");
	ResetGoals(1);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	Jump('AttackPlayer');


SeePlayer:
	
	plog("SeePlayer");
	PlayerIdentified();
	ResetGoals(1);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckPlayerSeenOnce(1, 'AttackPlayer');
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeePlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Jump('AttackPlayer');
	

SeePlayerSurprised:
	
	plog("SeePlayerSurprised");
	PlayerIdentified();
	ResetGoals(1);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckPlayerSeenOnce(1, 'AttackPlayer');
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SurprisedByPlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Jump('AttackPlayerSurprised');


AttackRequestFromGroupMember:

	plog("AttackRequestFromGroupMember");
	CheckAlarmProximity(1,'AlarmAttack');
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	ResetGoals(1);
	Jump('AttackPlayer');


AttackPlayer:

	plog("AttackPlayer");
	PlayerIdentified();
	GotoPatternState('Attack', 'AttackPlayer');
	End();	

	
AttackPlayerSurprised:

	plog("AttackPlayer - surprised");
	PlayerIdentified();
	GotoPatternState('Attack', 'AttackPlayerSurprised');
	End();	


AttackedFromUnknownLocation:

	plog("AttackedFromUnknownLocation");
	PlayerIdentified();
	GotoPatternState('Attack', 'AttackedFromUnknownLocation');
	End();	

}



/***************************************************************************************************************************************
		           *********************************************************************************************************************
							                       *************************************************************************************
																				********************************************************


		
			STATE 'Search'

			Search Behavior DefaultPattern State.  
			Responsible for handling all incoming AIEvents in the context of an ongoing search.




  ********************************************************
  *************************************************************************************
  *********************************************************************************************************************
  ***************************************************************************************************************************************/

state Search
{
	
	function BeginState()
	{
		plog("BeginState ---- Search");

        ChangeState(1,'s_investigate');

		EchelonLevelInfo(Level).SendMusicRequest(1,false,self);
		EchelonLevelInfo(Level).SendMusicRequest(0,true,self);

		ReloadWeapon(1,1);

	}

	/*function EndState()
	{
		EchelonLevelInfo(Level).SendMusicRequest(0,false,self);
	}*/

	//----------------------------------------[David Kalina - 12 Oct 2001]-----
	// 
	// Description
	//		OVERRIDEN Function so GotoPatternLabel calls are done w/in this state.
	//	
	//------------------------------------------------------------------------
	
	function GotoPatternLabel(name label)
	{
		//log("GotoPatternLabel  Search   Label: "$label);
		GotoState('Search', label);
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
		if(!CheckGoalPriority(50) && !bDisableMessages)
		{
			switch ( Event.EventType )
			{
				case AI_HEAR_SOMETHING :
					
					switch ( Event.EventNoiseType )
					{
						case NOISE_GrenadeWarning : 
							
							//Reaction(...);
							return;
							
						case NOISE_Ricochet:
							plog("REFLEX -- Noise Ricochet response.");
							Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
							return;
								
						case NOISE_DyingGasp :
						case NOISE_Explosion :	
							plog("REFLEX -- Dying Gasp / Explosion reaction.");
							Reaction(1, 50, Event.EventLocation, REACT_ImmediateThreat);
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
	
	event EventCallBack(EAIEvent Event,Actor TriggerActor)
	{

		if(EAIController(Characters[1]).bNotResponsive)
			return;

		if(!bDisableMessages)
		{
			switch(Event.EventType)
			{

				/*******  EXTERNAL EVENTS  ********************************************/

				case AI_SEE_NPC:
                    EventJump('Greetings');
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
					
					EventJump('ShotJustMissedMe');
					break;

				case AI_HEAR_SOMETHING:
					
					switch ( Event.EventNoiseType )
					{
						case NOISE_LightFootstep :
						case NOISE_Object_Falling :
						case NOISE_HeavyFootstep :
						case NOISE_Object_Breaking :
						case NOISE_DoorOpening :
							
							EventJump('UpdateSearch');
							break;

						case NOISE_DyingGasp :

							EventJump('HearFriendlyScream');
							break;

						case NOISE_GrenadeWarning :

							EventJump('HearGrenadeWarning');
							break;

						case NOISE_Alarm :

							plog("NOISE_Alarm used?");
							break;

						case NOISE_Ricochet :
							
							EventJump('HearRicochet');
							break;
							
						case NOISE_WallMineTick :

							EventJump('HearWallMineTick');
							break;

						case NOISE_Gunfire :
						case NOISE_Explosion :                 
							
							EventJump('HearViolentNoise');
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

						case NOISE_TakeCover:
							EventJump('RequestTakeCover');
							break;

                        case NOISE_TurretGunfire :
							EventJump('HearTurretFire');
							break;
					}
					break;

				case AI_SEE_CHANGED_ACTOR:

					plog("AI_SEE_CHANGED_ACTOR");

					if(Event.EventTarget.ChangeType == CHANGE_Unconscious)
					{
						if( Level.TimeSeconds - LastRevive < 5.0f )
							return;
					}

					Level.RemoveChange(Event.EventTarget);		// !!! Don't forget to remove changed actor after handling it !!!

					switch ( Event.EventTarget.ChangeType )
					{
						case CHANGE_Bleeding :
							EventJump('SeeViolence');
							break;

						case CHANGE_WallMine :
							EventJump('SeeWallMine');
							break;

						case CHANGE_Footprints :
							EventJump('SeeFootprints');
							break;

						case CHANGE_DisabledTurret :
							EventJump('SeeDisabledMachinery');
							break;
						
						case CHANGE_Flare :
						case CHANGE_DisabledTurret :
						case CHANGE_BrokenObject :
						case CHANGE_BrokenDoor :
						case CHANGE_ScorchMark :
						case CHANGE_BloodStain :
							EventJump('UpdateSearchTime');
							break;

						case CHANGE_Object :
							EventJump('SeeObject');
							break;

						case CHANGE_AirCamera :
							EventJump('SeeAirCamera');
							break;

						// TODO : For CHANGE_Light* ---> has room gone pitch black??
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
							log("CHANGE_Dead");
							EventJump('SeeDeadBody');
							break;

						case CHANGE_Grenade :
							EventJump('SeeLiveGrenade');
							break;
					}

					//Level.RemoveChange(Event.EventTarget);		// !!! Don't forget to remove changed actor after handling it !!!

					break;




				/*******  INTERNAL EVENTS  ********************************************/
				case AI_OUT_OF_DEFEND_RADIUS:
					EventJump('OutOfDefendRadius');
					break;

				case AI_PLAYER_DEAD:
					EventJump('PlayerDead');
					break;

				case AI_LOST_PLAYER:
					break;
					
				case AI_PLAYER_VERYCLOSE:
				case AI_PLAYER_CLOSE:
				case AI_PLAYER_FAR:
				case AI_PATROL_TIMEOUT:
					break;

				case AI_INVESTIGATE:
					EventJump('InvestigateRequestFromGroupMember');
					break;

				case AI_ATTACK:
				case AI_ALARM_UPDATE_POSITION:
					EventJump('AttackRequestFromGroupMember');
					break;

				case AI_SEE_PLAYER_AGAIN:
					EventJump('SeePlayerAgain');
					break;


				case AI_RELEASED:
					EventJump('Released');
					break;

				case AI_REVIVED:
					EventJump('Revived');
					break;

				case AI_NEARLY_DEAD:
					break;

				case AI_INTERROGATION_QUERY_SAM:
					EventJump('InterrogatedResponse');
					break;

				case AI_INTERROGATION_QUERY_NPC:
					EventJump('InterrogatedResponseToNPC');
					break;

				case AI_FORCED_RETINAL_SCAN:
					EventJump('RetinalScanned');
					break;

				case AI_GROUP_LAST_MEMBER:
					EventJump('GroupLastMember');
					break;

				case AI_UPDATE_SEARCH:
					EventJump('UpdateSearch');
					break;
					
				case AI_MASTER_OUT_OF_RADIUS:
					EventJump('SlaveRequestFollow');
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

	WaitForGoal(1,GOAL_Search);
	CheckPlayerSeenOnce(1, 'SearchFailedAfterPlayerSeen');
	CheckFlags(bReactedToAlarm,true,'SearchFailedAfterPlayerSeen');
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


OutOfDefendRadius:

	plog("OutOfDefendRadius");
	UpdateSearchGoal(1, Characters[1].Pawn.Location, true, false);
	Jump('WaitSearch');

	//Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	//Goal_Search(1, 15, Characters[1].Pawn.Location,,false);
	//Jump('SearchFailed');


SearchFailedAfterPlayerSeen:

	plog("Search Failed after Player Already Seen.  Dammit.");
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SearchFailedPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
    Reaction(1, 9,, REACT_SearchFailed);
	WaitForGoal(1, GOAL_Action);
	ResetGoals(1);
	SetPostAttackBehavior(1);
	GotoPatternState('Idle');	


SearchFailed:

	plog("Search failed");
	//Goal(1,GOAL_Action, 9,,,,, 'lookStNmRt2',);
	//Goal(1,GOAL_Action, 9,,,,, 'lookStNmRt2',);
	//Goal(1,GOAL_Action, 9,,,,, 'lookStNmBk2',);
    if(bSearchWasDogTriggered)
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_DogLostTrail;
    else
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_SearchFailedOther;
    bSearchWasDogTriggered = false;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50,, REACT_SearchFailed);
	GotoPatternState('Idle');	


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEARCH RESPONSE TO AUDIO STIMULI
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
HearGrenadeWarning:
	
	plog("HearGrenadeWarning-- NOT HANDLED YET");
	Jump('WaitSearch');
	
	
HearWallMineTick:
	
	plog("HearWallMineTick");		// panic, look around helplessly
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation);
	Broadcast(1, BC_INFO_BARK_COVER);
	PossiblyTakeCover(1,1500,'TakeCoverAndWait',TriggerEvent.EventLocation); // try to find cover from the wall mine
	Jump('Search_Directional');

HearViolentNoise:
	
	plog("HearViolentNoise -- gunshot / explosion -- if close, treat as ricochet");
	CheckIfThreatNearby(1,'HearRicochet');	
	Jump('UpdateSearch');

HearTurretFire:

	plog("HearViolentNoise -- gunshot / explosion -- if close, treat as ricochet");
	CheckIfThreatNearby(1,'HearCloseTurretFire');	
	Jump('UpdateSearch');

	
HearRicochet:
	
	plog("HearRicochet");
	PlayerIdentified();
	ResetGoals(1);	
	//ForceUpdatePlayerLocation(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}

	CheckIfDirectLine(1,Characters[0].pawn,'HearRicochetB');

	if(Characters[1].GetStateName() != 's_SitDown')
	{
		Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
		DisableMessages(true);
		WaitForGoal(1,GOAL_Action);
		DisableMessages(false);
	}

	Broadcast(1, BC_BACKUP_RADIO_ATTACK);

	CheckAlarmProximity(1,'AlarmAttack',250); //check if NPC is stick to an alarm
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	CheckAlarmProximity(1,'AlarmAttack');
	Jump('AttackPlayer');


HearRicochetB:

	plog("HearRicochetB");
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	GotoPatternState('attack', 'BlindFire');

HearCloseTurretFire:

	plog("HearCloseTurretFire");    // Same as HearRicochet, but no UpdatePlayerLocation nor CheckAlarmProximity
	ResetGoals(1);	
	//ForceUpdatePlayerLocation(1);
	//ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardGunShot;
	//Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_ImmediateThreat);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	//CheckAlarmProximity(1,'AlarmAttack',100); //check if NPC is stick to an alarm
	//CheckAlarmProximity(1,'AlarmAttack');
	Jump('AttackedFromUnknownLocation');



HearFriendlyScream:
	
	plog("HearFriendlyScream");		// run in the direction of the scream, wait ... and search
	ResetGoals(1);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_ImmediateThreat);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Goal_MoveTo(1, 36, TriggerEvent.EventTarget.Location, MOVE_JogAlert);
	Goal_Stop(1, 35, 2.0f +  RandBias(0.50, 5.75f), TriggerEvent.EventTarget, MOVE_JogAlert);
	Jump('Search_Directional');

Greetings:
    plog("Greetings");
    if(ePawn(Characters[1].Pawn).ICanBark())
    {
        log("Greet other dude");
		ePawn(Characters[1].Pawn).Bark_Type = BARK_InvestigationGreeting;
        Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    }
    Jump('WaitSearch');


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


RequestTakeCover:

	plog("RequestTakeCover");
	PossiblyTakeCover(1,1500,'TakeCoverAndWait',TriggerEvent.EventLocation); // try to find cover from the wall grenade
	End();


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEARCH RESPONSE TO VISUAL STIMULI
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		
SeePlayer:
SeePlayerAgain:
	
	plog("SeePlayer");
	PlayerIdentified();
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SeePlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckAlarmProximity(1,'AlarmAttack');
	CheckPlayerSeenOnce(1, 'AttackPlayer');
	Jump('AttackPlayer');
	

SeePlayerSurprised:
	
	plog("SeePlayerSurprised");
	PlayerIdentified();
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_SurprisedByPlayer;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	CheckPlayerSeenOnce(1, 'AttackPlayer');
	Jump('AttackPlayerSurprised');

	
TakeDamage:
	
	plog("TakeDamage");
	PlayerIdentified();
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	ePawn(Characters[1].Pawn).StopAllVoicesActor();
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HitByBullet;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	CheckAlarmProximity(1,'AlarmAttack',100);
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	ResetGoals(1);
	CheckAlarmProximity(1,'AlarmAttack');
	Jump('AttackPlayer');


AttackRequestFromGroupMember:
	
	plog("AttackRequestFromGroupMember");
	ChangeState(1,'s_alert');
	ForceUpdatePlayerLocation(1);
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	ResetGoals(1);
	Jump('AttackPlayer');


InvestigateRequestFromGroupMember:

    plog("InvestigateRequestFromGroupMember");
	ChangeState(1,'s_investigate');
	Goal_Stop(1, 50, 1.0f +  RandBias(0.50, 2.0f),, MOVE_Search,,TriggerEvent.EventLocation);
    if(ePawn(Characters[1].Pawn).ICanBark())
	{
		ePawn(Characters[1].Pawn).Bark_Type = BARK_CombArea;
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 4, 0, false);
	}
    UpdateSearchTimer(1, 15.0f);
    Jump('UpdateSearch');


SeeLiveGrenade:
	
	plog("SeeLiveGrenade");
	PlayerIdentified();
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_GroupScatter;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);

	//CheckIfDirectLine(1,Characters[0].pawn,'HearRicochetB');

	if(Characters[1].GetStateName() != 's_SitDown')
	{
		Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeGrenade);
		DisableMessages(true);
		WaitForGoal(1,GOAL_Action);
		DisableMessages(false);
	}

	Broadcast(1, BC_INFO_BARK_COVER);
	PossiblyTakeCover(1,1500,'TakeCoverAndWait',TriggerEvent.EventLocation); // try to find cover from the wall grenade
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	Jump('AttackPlayer');

SeeLiveGrenadeB:

	plog("SeeLiveGrenadeB");
	Broadcast(1, BC_INFO_BARK_COVER);
	GotoPatternState('attack', 'BlindFire');


TakeCoverAndWait:
	
	plog("TakeCoverAndWait");
	Goal_MoveTo(1, 36, CoverLocation, MOVE_JogAlert,,MOVE_JogAlert);
	Goal_Stop(1, 35,10f +  RandBias(0.85, 5.75f), Characters[0].Pawn, MOVE_JogAlert);
	GotoPatternState('TakeCover', 'WaitCover');

SeeUnconsciousBody:
	
	plog("SeeUnconsciousBody -- EventTarget:  " $ TriggerEvent.EventTarget);
	if ( !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats )
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	//ResetGoals(1);
	bReactedToAlarm=1; //to trigger the postattack behavior
	
	if(Level.TimeSeconds - LastRevive > 15)
	{
		ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeUnconscious;
		Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
		Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	}

    if ( !ePawn(TriggerEvent.EventTarget).bNoUnconsciousRevival )
	{
		LastRevive = Level.TimeSeconds;
	    Goal(1, GOAL_InteractWith, 35,,,TriggerEvent.EventTarget,,,,,,MOVE_JogAlert);
	}
	Broadcast(1, BC_INFO_RADIO_AWARE);
	Jump('Search_Location');
	
SeeDeadBody:
	
	plog("SeeDeadBody");
	if ( !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound && !EAIController(EPawn(TriggerEvent.EventTarget).Controller).bNotInStats )
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
		EAIController(EPawn(TriggerEvent.EventTarget).Controller).bWasFound = true;
	}
	bReactedToAlarm=1; //to trigger the postattack behavior
	if ( EPawn(TriggerEvent.EventTarget) != none ) 
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
	PlayerIdentified();
	ResetGoals(1);
    if(!ePawn(TriggerEvent.EventTarget).bIsDog)
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
    else
        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	CheckAlarmProximity(1,'AlarmAttack',100);
	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	ResetGoals(1);
	CheckAlarmProximity(1,'AlarmAttack');
	Jump('AttackPlayer');



SeeViolence:

	plog("SeeViolence");
	ResetGoals(1);
	if(ePawn(Characters[1].Pawn).ICanBark())
	{
	ePawn(Characters[1].Pawn).Bark_Type = BARK_UnderFire;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	}
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeBody);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	Jump('Search_Directional');
	

SeeFreshMeat:
	
	plog("SeeFreshMeat");	
	ResetGoals(1);
    if(!ePawn(TriggerEvent.EventTarget).bIsDog)
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
    else
        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	Broadcast(1, BC_BACKUP_RADIO_INVESTIGATE);
	CheckLightSwitchProximity(1,'TurnSwitchOn');
	CheckAlarmProximity(1, 'AlarmSearch');
	Jump('Search_Location');
	

SeeDeadBodyCold:
	
	plog("SeeDeadBodyCold");
	ResetGoals(1);
    if(!ePawn(TriggerEvent.EventTarget).bIsDog)
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_SeeCorpse;
    else
        ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_SeeBody);
	Broadcast(1, BC_INFO_RADIO_ALERT);

	if( TriggerEvent.EventTarget.bIsPawn  && EPawn(TriggerEvent.EventTarget).BodyFlames.Length == 0)
	{
	Goal_MoveTo(1, 36, TriggerEvent.EventTarget.Location, MOVE_JogAlert);
	Goal_Action(1, 35, TriggerEvent.EventTarget.Location, ePawn(Characters[1].Pawn).ACheckDeadBody);
	}

	CheckLightSwitchProximity(1,'TurnSwitchOn');
	Jump('Search_Location');


TurnSwitchOn:

	plog("TurnSwitchOn");
	Goal(1, GOAL_InteractWith, 24,,,TriggerEvent.EventTarget,,,,,1.0);
	Jump('Search_Location');

	
SeeWallMine:
	
	plog("SeeWallMine"); // that's fucked up -- move slowly and disable/remove	
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;               // Replaces BARK_SeeWallMine
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeWallMine);
	Goal(1, GOAL_InteractWith, 14,,,TriggerEvent.EventTarget);			// TODO : Set MoveFlag so we move VERY slowly ...
	Jump('UpdateSearchTime');
	
SeeFootprints:
	
	plog("SeeFootprints");
	Jump('UpdateSearchTime');
	
	
SeeDisabledMachinery:
	
	plog("SeeDisabledMachinery");
	Jump('UpdateSearchTime');
	
	
SeeObject:
	
	plog("SeeObject - watch it for a second and then search");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	Reaction(1, 50,, REACT_MovingObject, TriggerEvent.EventTarget);		// specify target so we 'watch' the object if it's moving
	Broadcast(1, BC_SELF_DIRECTED);
	if ( VSize(TriggerEvent.EventTarget.Velocity) > 10.0f )
		Jump('Search_Origin');
	else
		Jump('Search_Location');
		
SeeAirCamera:
	
	plog("SeeAirCamera - check it out directly -- REACT_MovingObject");
	ResetGoals(1);
	ePawn(Characters[1].Pawn).Bark_Type = BARK_Mystified;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	Reaction(1, 51,, REACT_MovingObject, TriggerEvent.EventTarget);		// specify target so we 'watch' the object if it's moving
	Goal_MoveTo(1, 36, TriggerEvent.EventTarget.Location + vector(TriggerEvent.EventTarget.Rotation) * 100.0f, MOVE_WalkAlert);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeUnknownPerson);
	Broadcast(1, BC_SELF_DIRECTED);

	if(EGamePlayObject(TriggerEvent.EventTarget) != None)
	{
		EGamePlayObject(TriggerEvent.EventTarget).bWasSeen=true;
	}

	Jump('Search_Location');
	
LightsTurnedOff:
	
	plog("LightsTurnedOff -- bark and look around nervously, move to light switch and re-enable. Light OWNER: " $ TriggerEvent.EventTarget.owner);
	//ResetGoals(1);

    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);

    // Debug
    switch(iSuggestedBehavior)
    {
        case 0:log("Search - LightsTurnedOff - Do Nothing"); break; 
        case 1:log("Search - LightsTurnedOff - Bark Only"); break;
        case 2:log("Search - LightsTurnedOff - Search Only"); break;
        case 3:log("Search - LightsTurnedOff - Bark and Search"); break;
        default: break;
    }

    UpdateSearchTimer(1, 10.0f);

    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {
        if(TriggerEvent.EventTarget.owner.GetStateName() == 's_Off')
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
	EAIController(Characters[1]).EPawn.ForceFlashLight=false;
    CheckSwitchAlreadyLocked(1, TriggerEvent.EventTarget.owner);
    Jump('WaitSearch');

	
	
LightsShotOut:
	
	plog("LightsShotOut -- bark and look around nervously, NO SEARCH.");

    iSuggestedBehavior = AddChangeAndSuggestBehavior(1, vector(TriggerEvent.EventTarget.Rotation), CHANGE_LightTurnedOff);

    // Debug
    switch(iSuggestedBehavior)
    {
        case 0:log("Search - LightsShotOut - Do Nothing"); break; 
        case 1:log("Search - LightsShotOut - Bark Only"); break;
        case 2:log("Search - LightsShotOut - Search Only"); break;
        case 3:log("Search - LightsShotOut - Bark and Search"); break;
        default: break;
    }  

    UpdateSearchTimer(1, 10.0f);

	//ResetGoals(1);
    if ((iSuggestedBehavior & BARK_BIT) == BARK_BIT)
    {
	    ePawn(Characters[1].Pawn).Bark_Type = BARK_LightShot;
	    Talk(EPawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	    Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeLightsOut);
	    EAIController(Characters[1]).EPawn.ForceFlashLight=false;
	    Broadcast(1, BC_SELF_DIRECTED);
    }
	
	ChangeState(1,'s_investigate');
    Jump('WaitSearch');


	
SeeAnotherNPCInterrogated:
	
	plog("SeeAnotherNPCInterrogated -- NOT HANDLED YET.");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_DropHim;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeInterrogation);
	SendCommunication(AI_LET_HIM_GO,TriggerEvent.EventTarget,0.8f);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('AttackPlayer');	
	
	
ShotJustMissedMe :
	
	plog("Shot just missed me - NYI"); // duck and run in random direction, then search
	Jump('HearRicochet');

Revived:
	
	ResetGoals(1);
	Jump('Search_Directional');
	
	
PlayerDead:
	
	plog("PlayerDead");
    Sleep(3);
	ResetAllNPCs(1);
	SetPlayerDeadAction(1);
    WaitForGoal(1,GOAL_MoveTo,);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_PlayerKilled;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	WaitForGoal(1,GOAL_Action,);
	GotoPatternState('Idle');
	End();


SlaveRequestFollow:

	plog("SlaveRequestFollow");
	UpdateSearchTimer(1, 10.0f);   // add 10 seconds to search 
	UpdateSearchGoal(1, TriggerEvent.EventLocation, true, true); // set new search location, disable focus switching, reset timer		
	Jump('WaitSearch');


////////////////////////////////
/// SEARCH BEHAVIOR TRIGGERS ///
////////////////////////////////


Search_Location:
	
	plog("Search_Location -- Search at Event Location THEN in Random Direction");
	if(bExplosionStimuli)
		Goal_Search(1, 15, TriggerEvent.EventLocation,,false,,MOVE_JogAlert);
	else
	Goal_Search(1, 15, TriggerEvent.EventLocation,,false);
	bExplosionStimuli=false;

    CheckLightSwitchVolumeAndAdd(1, TriggerEvent.EventLocation);
	Jump('WaitSearch');
	
Search_LocationFocus:

	plog("Search_Location -- Search Location with focus switching");
	Goal_Search(1, 15, TriggerEvent.EventLocation,,true);
    CheckLightSwitchVolumeAndAdd(1, TriggerEvent.EventLocation);
	Jump('WaitSearch');
	

Search_Directional:
	
	plog("Search_Directional -- Search in DIRECTION OF EVENT from current pawn location");
	Goal_Search(1, 15,, TriggerEvent.EventLocation - Characters[1].Pawn.Location, false);
    CheckLightSwitchVolumeAndAdd(1, TriggerEvent.EventLocation);
	Jump('WaitSearch');

	
Search_Origin:
	
	plog("Search_Origin -- Search at ORIGIN of the event");
	Goal_Search(1, 15, TriggerEvent.EventTarget.Instigator.Location,, false);
    CheckLightSwitchVolumeAndAdd(1, TriggerEvent.EventTarget.Instigator.Location);
	Jump('WaitSearch');


Search_GeneralDirection:
	
	plog("Search_GeneralDirection -- In Direction of Event");
	Goal_Search(1, 15,, TriggerEvent.EventTarget.Instigator.Location - TriggerEvent.EventLocation, true);
    CheckLightSwitchVolumeAndAdd(1, TriggerEvent.EventTarget.Instigator.Location);
	Jump('WaitSearch');	
	
	
Search_General:
	
	plog("Search_General -- Use Last Known Player Location OR Forward Direction");
	Goal_Search(1, 15,,, true);
	Jump('WaitSearch');
	
	
Search_CHEAT:
	
	plog("Search_CHEAT -- Using Current Player Location as search key.   ** REPLACE **");	
	Goal_Search(1, 15,GetNearestNavPointLocation(),,false,,,Characters[0].pawn);
	Jump('WaitSearch');
	




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ATTACK BEHAVIOR TRIGGERS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		
	
AlarmAttack:
	
	plog("AlarmAttack");
    ChangeState(1,'s_alert');
	DisableMessages(true);
	bRunningAlarm=true;
	Goal(1,GOAL_InteractWith, 45,TriggerEvent.EventLocation,,TriggerEvent.EventTarget,,,,true,,MOVE_JogAlert);
	WaitForGoal(1,GOAL_InteractWith);
	bRunningAlarm=false;
	DisableMessages(false);
	AllGroupLostPlayer('AttackedFromUnknownLocation');
	Jump('AttackPlayer');
	
		
AlarmSearch:
	
	plog("AlarmSearch");
	ChangeState(1,'s_alert');
	DisableMessages(true);
	bRunningAlarm=true;
	Goal(1,GOAL_InteractWith, 45,TriggerEvent.EventLocation,,TriggerEvent.EventTarget,,,,true,,MOVE_JogAlert  );
	WaitForGoal(1,GOAL_InteractWith);
	bRunningAlarm=false;
	DisableMessages(false);
	Jump('Search_General');
		

AlarmBegin:

	plog("AlarmBegin - response to an alarm call");
	ResetGoals(1);
	GotoPatternState('Attack', 'AlarmAttack');
	End();


AttackPlayer:
	
	plog("AttackPlayer");
	PlayerIdentified();
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Attack', 'AttackPlayer');
	End();	

AttackPlayerSurprised:

	plog("AttackPlayer - surprised");
	PlayerIdentified();
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Attack', 'AttackPlayerSurprised');
	End();	

AttackedFromUnknownLocation:
	
	plog("AttackedFromUnknownLocation");
	PlayerIdentified();
	ForceUpdatePlayerLocation(1);
	GotoPatternState('Attack', 'AttackedFromUnknownLocation');
	End();	


}








/***************************************************************************************************************************************
		           *********************************************************************************************************************
							                       *************************************************************************************
																				********************************************************


		
			STATE 'Attack'

			Attack Behavior DefaultPattern State.  
			Responsible for handling all incoming AIEvents in the context of an ongoing attack.




  ********************************************************
  *************************************************************************************
  *********************************************************************************************************************
  ***************************************************************************************************************************************/



state Attack
{
	function Tick( float Delta )
	{
		local EGoal Goal;

		Super.Tick(  Delta);

		Goal = EAIController(Characters[1]).m_pGoalList.GetCurrent();

		if(Goal.m_GoalType ==GOAL_Charge )
			CheckIfInZone('PlayerInZone');

		EAIController(Characters[1]).EPawn.ForceFlashLight=false;

	}
	
	function BeginState()
	{
		bCharge=0;
		SetFlags(bFirstTimeCharge,true);
		SetFlags(bRunForAttackPoint,false);

		if(!EGroupAI(Owner).bDontMirrorAttack)
			EchelonLevelInfo(Level).SendMusicRequest(1,true,self);

		EchelonLevelInfo(Level).SendMusicRequest(0,false,self);

		ChangeState(1,'s_alert');
	}

	/*function EndState()
	{
		EchelonLevelInfo(Level).SendMusicRequest(1,false,self);
	}*/

	//----------------------------------------[David Kalina - 12 Oct 2001]-----
	// 
	// Description
	//		OVERRIDEN Function so GotoPatternLabel calls are done w/in this state.
	//	
	//------------------------------------------------------------------------
	
	function GotoPatternLabel(name label)
	{
		GotoState('Attack', label);
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
		switch ( Event.EventType )
		{
			case AI_SEE_CHANGED_ACTOR:

				switch ( Event.EventTarget.ChangeType )
				{
					case CHANGE_WallMine :
						//log("Distance: "$VSize(Event.EventTarget.Location - Characters[1].pawn.Location));
						if(VSize(Event.EventTarget.Location - Characters[1].pawn.Location) > 550)
						{
							Goal_Attack(1, 44, 0.0f, Event.EventTarget, MOVE_JogAlert,false);
							Goal_Stop(1, 43, 0.5f, Event.EventTarget, MOVE_JogAlert);

							Level.RemoveChange(Event.EventTarget);
						}
						break;
				}
				
				//Level.RemoveChange(Event.EventTarget);		// !!! Don't forget to remove changed actor after handling it !!!
				break;

			case AI_HEAR_SOMETHING :
			
				switch ( Event.EventNoiseType )
				{
					case NOISE_GrenadeWarning : 
						
						//Goal_Action(...);
						return;
						
					case NOISE_DyingGasp :				
						return;
				}
			
				break;

			case AI_LOST_PLAYER:
				ReloadWeapon(1,0.25f);
				break;

		}
	}
	
	
	//----------------------------------------[David Kalina - 5 Oct 2001]-----
	// 
	// Description
	//		Handle incoming AIEvents by jumping to the appropriate label. 
	// 
	//------------------------------------------------------------------------
	
	event EventCallBack(EAIEvent Event,Actor TriggerActor)
	{
		if(EAIController(Characters[1]).bNotResponsive)
			return;


		if(!bDisableMessages)
		{
			switch(Event.EventType)
			{

				/*******  EXTERNAL EVENTS  ********************************************/

			
				case AI_SEE_PLAYER_SURPRISED:
				case AI_SEE_PLAYER_ALERT:
					EventJump('SeePlayer');
					break;

				case AI_SEE_PLAYER_AGAIN:
					EventJump('SeePlayerAgain');
					break;

				case AI_SEE_INTERROGATION :
					EventJump('SeeAnotherNPCInterrogated');
					break;

				case AI_TAKE_DAMAGE:
					EventJump('TakeDamage');
					break;

				case AI_SEE_NPC:
				case AI_SEE_PLAYER_INVESTIGATE:
				case AI_SHOT_JUST_MISSED :
					break;

				case AI_HEAR_SOMETHING:
					
					switch ( Event.EventNoiseType )
					{
						case NOISE_LightFootstep :
						case NOISE_Object_Falling :
						case NOISE_HeavyFootstep :
						case NOISE_Object_Breaking :
						case NOISE_Gunfire :
                        case NOISE_TurretGunfire :
							//EventJump('MaybeUpdatePlayerLocation');
							break;
							
						case NOISE_GrenadeWarning :
							//EventJump('HearGrenadeWarning');
							break;

						case NOISE_WallMineTick :
							//EventJump('HearWallMineTick');
							break;

						case NOISE_Ricochet:
							EventJump('HearRicochet');
							break;

						case NOISE_DoorOpening :
						case NOISE_Scream :
						case NOISE_DyingGasp :
						case NOISE_Alarm :
						case NOISE_Ricochet :
						case NOISE_Explosion :
							break;

						case NOISE_BackUpBarkAttack:
							EventJump('AttackRequest');
							break;

					}
					break;

				case AI_SEE_CHANGED_ACTOR:

					switch ( Event.EventTarget.ChangeType )
					{
						case CHANGE_LightTurnedOff :
							//   EventJump('LightsTurnedOff');
							break;

						case CHANGE_LightShotOut :
							//EventJump('RoomWentPitchBlack');
							break;

						case CHANGE_Footprints :
							//EventJump('SeeFootprints');
							break;

						case CHANGE_Grenade :
							//EventJump('SeeLiveGrenade');
							break;
					}

					break;

				/*******  INTERNAL EVENTS  ********************************************/

				
				case AI_PLAYER_DEAD:
					EventJump('PlayerDead');
					break;
					
				case AI_ATTACK:
					EventJump('AttackRequest');
					break;

				case AI_LOST_PLAYER:
					EventJump('PlayerLost');
					break;

				case AI_LOST_PLAYER_AFTER:
					EventJump('PlayerLostAfter');
					break;

				case AI_GROUP_LOST_PLAYER:
					EventJump('GroupLost');
					break;

				case AI_PLAYER_VERYCLOSE:
					EventJump('PlayerIsVeryClose');
					break;

				case AI_PLAYER_CLOSE:
					EventJump('PlayerIsClose');
					break;

				case AI_PLAYER_FAR:
					EventJump('PlayerIsFar');
					break;

				case AI_SHOT_BLOCKED:
					EventJump('Blocked');
					break;

				case AI_NEARLY_DEAD:
					EventJump('NearlyDead');
					break;

				case AI_COVERPOINT_TOUCHED:
					EventJump('CoverPointTouched');
					break;
				
				case AI_COVER_LOST_PLAYER:
					EventJump('CoverPointLostPlayer');
					break;

				case AI_OUT_OF_DEFEND_RADIUS:
					EventJump('OutOfDefendRadius');
					break;

				case AI_UPDATE_SEARCH:
				case AI_PATROL_TIMEOUT:
				case AI_INVESTIGATE:
				case AI_ALARM_UPDATE_POSITION:
				case AI_RELEASED:
				case AI_REVIVED:
				case AI_INTERROGATION_QUERY_SAM:
				case AI_INTERROGATION_QUERY_NPC:
				case AI_FORCED_RETINAL_SCAN:
				case AI_GROUP_LAST_MEMBER:

				default:
					break;

			}
		}
	}



/***********************************************************************************************

	STATE : ATTACK -- RESPONSES TO INCOMING AIEVENTS

 ************************************************************************************************/

// Wait labels :  If Goal completes, Change States
	
WaitAttack:
	
	plog("WaitAttack");
	CheckFlags(bCharge,true,'WaitChargeAttack');
	WaitForGoal(1,Goal_Attack);
	CheckIfInZone('PlayerInZone');
	//CheckIfPlayerStillInZone('AttackPlayerInZone');
	SetFlags(bRunForAttackPoint,false);
	SetFlags(bRunningCoverPoint,false);
	PlayerIsVisible(1,'NotVisibleAfterAttack');
	CheckIfLastTimeSeenExpired(1,10,'AfterChargeCompleted');
	CheckIfPeeking(1,'AttackPlayer');
	Jump('AttackPlayer');


NotVisibleAfterAttack:

	plog("NotVisibleAfterAttack");
	AskGroupForPlayerPosition('PlayerLost');
	CheckIfLastTimeSeenExpired(1,30,'AfterChargeCompleted');
	CheckIfPeeking(1,'AttackPlayer');
	Jump('PlayerLost'); //sheat
	//Jump('AttackPlayer');

WaitChargeAttack:
	
	plog("WaitChargeAttack");
	WaitForGoal(1,GOAL_Charge,'WaitChargeAttackFailed');
	plog("WaitChargeAttack - charge complete");
	CheckIfInZone('PlayerInZone');
	PlayerIsVisible(1,'AfterChargeCompleted');
	Jump('AttackPlayer');

AfterChargeCompleted:

	plog("AfterChargeCompleted");
	AskGroupForPlayerPosition('PlayerLost');

	if( EAIController(Characters[1]).epawn.ExpiredTime > 0 )
		Jump('Search_CHEAT');
	else
	{
		CheckIfInZone('PlayerInZone');
		CheckAttackPoint(1,'AttackPointFound');
		Jump('AttackPlayer');
	}


WaitChargeAttackFailed:

	plog("WaitChargeAttack - charge failed - The player is not reachable");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	AskGroupForPlayerPosition('NotExpired');
	//Checkflags(bFirstTimeCharge,true,'FirstTimeCharge'); //if first time charge
	CheckIfLastTimeSeenExpired(1,30,'TimeExpired');
	CheckIfInZone('PlayerInZone');
	CheckAttackPoint(1,'AttackPointFound');
	Jump('AttackPlayer');

FirstTimeCharge:

	plog("FirstTimeCharge - Time Expired ignored");
	CheckPlayerSeenOnce(1, 'FirstTimeChargeB');
	Jump('AfterChargeCompleted'); //we've never seen the player so search around player location

FirstTimeChargeB:

    plog("FirstTimeChargeB ");
	SetFlags(bFirstTimeCharge,false);
	CheckIfInZone('PlayerInZone');
	CheckAttackPoint(1,'AttackPointFound');
	Jump('AttackPlayer');


NotExpired:

	plog("NotExpired");
	//ForceUpdatePlayerLocation(1);
	CheckIfInZone('PlayerInZone');
	CheckAttackPoint(1,'AttackPointFound');
	//CheckIfLastTimeSeenExpired(1,30,'TimeExpired');
	Jump('AttackPlayer');


OutOfDefendRadius:

	plog("OutOfDefendRadius");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	CheckIfInZone('PlayerInZone');

	if(!EAIController(Characters[1]).bPlayerSeen)
	{
		PossiblyTakeCover(1, 0, 'TakeCoverAndCharge');
		CheckAttackPoint(1,'AttackPointFound');
	}
	CheckIfLastTimeSeenExpired(1,30,'TimeExpired');
	Jump('AttackPlayer');


TimeExpired:

	plog("TimeExpired - Go to post attack position");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	SetPostAttackBehavior(1);
	GotoPatternState('Idle');	


AttackPointFound:

	plog("Attack point found");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,true);
	Goal_MoveTo(1, 15, GetTargetLocation(1), MOVE_JogAlert, Characters[0].Pawn.Location, MOVE_JogAlert,true);
	Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 15.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');


WaitAndAttack:
	
	plog("WaitAndAttack");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	Goal_Attack(1,14, 2.0f +  RandBias(0.4, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');


/*****  EXTERNAL EVENTS  *****/

TakeDamage:

	plog("TakeDamage");
	PlayerIdentified();
	SetFlags(bFirstTimeCharge,true);
	ForceUpdatePlayerLocation(1);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	ePawn(Characters[1].Pawn).StopAllVoicesActor();
	ePawn(Characters[1].Pawn).Bark_Type = BARK_HitByBullet;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	CheckIfPeeking(1,'WaitAttack');
	CheckIfInZone('PlayerInZone');

	if( (VSize(Characters[0].Pawn.Location - Characters[1].Pawn.Location) > 600 ) ||
		!EAIController(Characters[1]).bPlayerSeen )
	    PossiblyTakeCover(1, 1500.0f, 'TakeCoverAndCharge');

	PlayerIsVisible(1,'AttackedFromUnknownLocation');
	ResetGoals(1);
	Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	UpdateGoalMoveFlag(1,MOVE_CrouchJog);
	Jump('WaitAttack');
				
	
AttackedFromUnknownLocation:

	plog("AttackedFromUnknownLocation");
	PlayerIdentified();
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	//Checkflags(bFirstTimeCharge,true,'BlindFire');
	CheckIfDirectLine(1,Characters[0].pawn,'BlindFire');
	PossiblyTakeCover(1, 1500.0f, 'TakeCoverAndCharge');
	Jump('PlayerLost');

HearRicochet:

	plog("HearRicochet");
	PlayerIdentified();
	ForceUpdatePlayerLocation(1);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('WaitAttack');

	//SetFlags(bFirstTimeCharge,true);
	//PlayerIsVisible(1,'AttackedFromUnknownLocation');
	//Jump('AttackPlayer');
	
/*
LightsTurnedOff : 

	plog("LightsTurnedOff -- if player is not seen, try to turn lights back on.  Light OWNER: " $ TriggerEvent.EventTarget.owner);
	PlayerIsVisible(1, 'WaitAttack');
	Goal(1, GOAL_InteractWith, 14,,,TriggerEvent.EventTarget.owner,,,,,,MOVE_JogAlert);
	Jump('WaitAttack');*/

BlindFire:

	plog("BlindFire");
	//ForceUpdatePlayerLocation(1);
	EAIController( Characters[1] ).LastKnownPlayerTime = Level.TimeSeconds-15;
	Goal_Attack(1, 16,3f +  RandBias(0.35, 3.75f), Characters[0].Pawn, MOVE_JogAlert,true, EAIController( Characters[1] ).epawn.ASprayFire);
	//Goal_SprayFire(1, 16, 20.25f +  RandBias(0.35, 3.0f), Characters[0].Pawn, MOVE_JogAlert,true);
	PossiblyTakeCover(1, 1500.0f, 'TakeCoverAndChargeB');
	Jump('WaitAttack');

TakeCoverAndCharge:
	
	plog("TakeCoverAndCharge - CoverLocation:  " $ CoverLocation);
	ForceUpdatePlayerLocation(1);

TakeCoverAndChargeB:
	SetFlags(bRunForAttackPoint,true);
   /* ePawn(Characters[1].Pawn).Bark_Type = BARK_LookingForYou;
    // MClarke test
    if(ePawn(Characters[1].Pawn).ICanBark())
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);*/
	Goal_MoveTo(1, 15, CoverLocation, MOVE_JogAlert,,MOVE_JogAlert);
	Goal_Attack(1, 14,5f +  RandBias(0.5, 10.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	//Goal_Charge(1,13,Characters[0].pawn,MOVE_JogAlert);
	//Jump('WaitChargeAttack');
	Jump('WaitAttack');


PlayerInZoneA:

	plog("PlayerInZoneA");
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	Jump('PlayerInZone');

PlayerInZone:

	plog("PlayerInZone");
	AskGroupForPlayerPosition('PlayerZoneSeq');
    CheckIfLastTimeSeenExpired(1,30,'AfterChargeCompleted');

PlayerZoneSeq:

	plog("PlayerZoneSeq");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	Goal_MoveTo(1, 12, GetTargetLocation(1), MOVE_JogAlert, Characters[0].Pawn.Location, MOVE_JogAlert,false);
	Goal_Attack(1, 10,2f +  RandBias(0.85, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false,,GetTargetLocation(1),true);
	CheckIfCanThrowGrenade('ThrowGrenade');
	Jump('WaitPlayerInZone');


WaitPlayerInZone:

	log("WaitPlayerInZone - "$Characters[1].pawn);
	Jump('WaitAttack');


SeePlayer:

	plog("See Player Alert-Surprised");
	PlayerIdentified();
	CheckIfChargeShouldContinue(1, 'SeePlayerB');
	Jump('SeePlayerB');

SeePlayerB:

	plog("SeePlayerB");
	Sleep(0.9);
	Jump('SeePlayerC');

SeePlayerC:

	plog("SeePlayerC");
	ResetGoals(1);
	Broadcast(1, BC_BACKUP_RADIO_ATTACK);
	SetFlags(bRunForAttackPoint,false);
	PlayerIsVisible(1,'NotVisibleAfterAttack');
	CheckIfPeeking(1,'AttackPlayer');
	Jump('AttackPlayer');

SeePlayerAgain:
	
	plog("SeePlayerAgain.");
	CheckIfExecutingGoal(1, GOAL_MoveAndAttack, 'WaitAttack');
	SetFlags(bRunForAttackPoint,false);
	//CheckIfPlayerStillInZone('WaitAttack');
	CheckIfInZone('PlayerInZoneA');
	CheckIfPeeking(1,'WaitAttack');
	CheckIfChargeShouldContinue(1, 'SeePlayerAgainB');
	Jump('SeePlayerAgainC');

SeePlayerAgainB:

	plog("SeePlayerAgainB.");
	Sleep(0.9);
	Jump('SeePlayerAgainC');

SeePlayerAgainC:

	plog("SeePlayerAgainC.");
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('AttackPlayer');

SeeAnotherNPCInterrogated:
	
	plog("SeeAnotherNPCInterrogated -- NOT HANDLED YET.");
	ePawn(Characters[1].Pawn).Bark_Type = BARK_DropHim;
	Talk(ePawn(Characters[1].Pawn).Sounds_Barks,1,0,false);
	Reaction(1, 50, TriggerEvent.EventTarget.Location, REACT_SeeInterrogation);
	SendCommunication(AI_LET_HIM_GO,TriggerEvent.EventTarget,0.8f);
	Broadcast(1, BC_BACKUP_BARK_ATTACK);
	Jump('WaitAttack');	


CoverPointTouched:

	plog("CoverPointTouched");
	//CheckIfPlayerStillInZone('WaitAttack');
	CheckIfInZone('PlayerInZone');
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	Jump('TakeCoverAndChargeAfter');


MaybeUpdatePlayerLocation:

	plog("MaybeUpdatePlayerLocation, if we don't see the player");
	CheckFlags(bCharge, false, 'WaitAttack');
	Jump('WaitChargeAttack');



HearGrenadeWarning:
	plog("HearGrenadeWarning");
HearWallMineTick:
	plog("HearWallMineTick");
RoomWentPitchBlack:
	plog("RoomWentPitchBlack");
SeeFootprints:
	plog("SeeFootprints");
SeeLiveGrenade:
	plog("SeeLiveGrenade");


/*****  INTERNAL EVENTS  *****/
	
	
PlayerDead:
	
	plog("PlayerDead");
	DisableMessages(true);
	ResetGoals(1);
	Goal_Stop(1, 16, 3.0f, Characters[0].pawn, MOVE_JogAlert);
    Sleep(3);
	ResetAllNPCs(1);
	SetPlayerDeadAction(1);
    WaitForGoal(1,GOAL_MoveTo,);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_PlayerKilled;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
	WaitForGoal(1,GOAL_Action,);
	//ResetGroup();
	ResetDefaultPatterns();
	DisableMessages(false);
	GotoPatternState('Idle');
	End();
		

AttackRequest:

	plog("AttackRequest");
	ForceUpdatePlayerLocation(1);
	CheckIfExecutingGoal(1, GOAL_Action, 'WaitAttack');
	CheckIfExecutingGoal(1, GOAL_MoveAndAttack, 'WaitAttack');
	//CheckIfPlayerStillInZone('WaitAttack');
	CheckIfInZone('PlayerInZone');
	CheckIfCornerPeeking(1,'WaitAttack');
	CheckIfExecutingGoal(1, GOAL_Attack, 'AttackRequestGoalAttack');
	CheckAttackPoint(1,'AttackPointFound');
	PlayerIsVisible(1,'AttackReqNotVisible');
	Jump('WaitAttack');

AttackRequestGoalAttack:

	plog("AttackRequestGoalAttack");
	PlayerIsVisible(1,'AttackReqNotVisible');
	Jump('WaitAttack');


AttackReqNotVisible:

	plog("AttackReqNotVisible");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	CheckIfDirectLine(1,Characters[0].pawn,'SprayFire');
	Jump('PlayerLost');

	//PlayerIsVisible(1,'PlayerLost');
	//PossiblyTakeCover(1, 0, 'TakeCoverAndChargeAfter');
	//Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	//Jump('WaitAttack');


SprayFire:

	plog("SprayFire");
	Goal_Attack(1, 26, 2.25f +  RandBias(0.50, 1.75f), Characters[0].Pawn, MOVE_JogAlert,true);
	PlayerIsVisible(1,'PlayerLost');
	PossiblyTakeCover(1, 0, 'TakeCoverAndChargeAfter');
	Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');


CoverPointLostPlayer:

	plog("CoverPointLostPlayer");
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	CheckIfInZone('PlayerInZone');
	CheckTouchingCoverPoints(1,'CoverPointTouched');
	Goal_Charge(1,15,Characters[0].pawn,MOVE_JogAlert);
	Jump('WaitChargeAttack');


PlayerLost:
	
	plog("PlayerLost");
	CheckFlags(bRunForAttackPoint,true,'ContinueAttackPointRun');
	CheckFlags(bRunningCoverPoint,true,'ContinueCoverRunning');
	//ForceUpdatePlayerLocation(1);
	//CheckIfPlayerStillInZone('AttackPlayer');
	CheckIfInZone('PlayerInZone');
	//log("before CheckIfPeeking in PlayerLost");
	CheckIfPeeking(1,'AttackPlayer');
	CheckTouchingCoverPoints(1,'CoverPointTouched');
	//CheckAttackPoint(1,'AttackPointFound');
	//ReloadWeapon(1,0.45f);
	Goal_Charge(1,15,Characters[0].pawn,MOVE_JogAlert);
	Jump('WaitChargeAttack');
	
PlayerLostAfter:

	plog("PlayerLostAfter");
	CheckIfExecutingGoal(1, GOAL_Charge, 'WaitChargeAttack');
	CheckFlags(bRunForAttackPoint,true,'ContinueAttackPointRun');
	CheckFlags(bRunningCoverPoint,true,'ContinueCoverRunning');
	SetFlags(bRunForAttackPoint,false);
	//ForceUpdatePlayerLocation(1);
	//CheckIfPlayerStillInZone('AttackPlayer');
	CheckIfInZone('PlayerInZone');
	CheckIfPeeking(1,'AttackPlayer');
	CheckTouchingCoverPoints(1,'CoverPointTouched');
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	Goal_Attack(1, 16, 2.0f +  RandBias(0.50, 4.0f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');


GroupLost:

	plog("GroupLost");
	CheckIfExecutingGoal(1, GOAL_Charge, 'WaitChargeAttack');
	CheckFlags(bRunningCoverPoint,true,'ContinueCoverRunning');
	
	if( VSize(Characters[0].pawn.Location - EAIController(Characters[1]).LastKnownPLayerLocation) < 200 )
		CheckFlags(bRunForAttackPoint,true,'ContinueAttackPointRun');

	SetFlags(bRunForAttackPoint,false);
	//ForceUpdatePlayerLocation(1);
	//CheckIfPlayerStillInZone('WaitAttack');
	CheckIfInZone('PlayerInZone');
	CheckIfPeeking(1,'WaitAttack');
	CheckTouchingCoverPoints(1,'CoverPointTouched');
	ResetGoals(1);

    /*ePawn(Characters[1].Pawn).Bark_Type = BARK_LookingForYou;

    // MClarke test
    if(ePawn(Characters[1].Pawn).ICanBark())
    {
	    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    }*/

	Goal_Stop(1, 16, 0.5 + RandBias(0.50, 2.0f), Characters[0].pawn, MOVE_JogAlert);
	Goal_Charge(1,15,Characters[0].pawn,MOVE_JogAlert);
	Jump('WaitChargeAttack');


ContinueAttackPointRun:

	plog("ContinueAttackPointRun");
	SetFlags(bRunForAttackPoint,false);
	Jump('WaitAttack');

ContinueCoverRunning:

	plog("ContinueCoverRunning");
	SetFlags(bRunningCoverPoint,false);
	Jump('WaitAttack');


TakeCoverAndChargeAfter:

	plog("TakeCoverAndCharge - CoverLocation:  " $ CoverLocation);
	ResetGoals(1);
	bRunningCoverPoint=1;
	Goal_MoveTo(1, 15, CoverLocation, MOVE_JogAlert,,MOVE_JogAlert,true);
	Goal_Attack(1, 14,5f +  RandBias(0.5, 4.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	//Goal_Charge(1,13,Characters[0].pawn,MOVE_JogAlert);
	//Jump('WaitChargeAttack');
	Jump('WaitAttack');


PlayerIsVeryClose:
	
	plog("The player is VERRRRRY close");
	CheckIfExecutingGoal(1, GOAL_Action, 'WaitAttack');		// skip this block if in the middle of action
	CheckIfInZone('PlayerInZone');
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 15.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');
	

PlayerIsClose:

	plog("The player is close");
	CheckFlags(bRunForAttackPoint,true,'WaitAttack');
	ResetGoals(1);
	Goal_Attack(1, 14,5f +  RandBias(0.5, 4.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');

	
PlayerIsFar:
	
	plog("The player is far.");
	CheckIfInZone('PlayerInZone');
	CheckFlags(bRunForAttackPoint,true,'WaitAttack');
	ResetGoals(1);
	SetFlags(bRunForAttackPoint,false);
	Goal_Charge(1,15,Characters[0].pawn,MOVE_JogAlert);
	Jump('WaitChargeAttack');


Blocked:
	
	plog("Blocked");
	//CheckIfPlayerStillInZone('WaitAttack');
	CheckIfInZone('PlayerInZone');
	//ResolveBlocked(1,'AfterBlocked');
	CheckAttackPoint(1,'AttackPointFound');
	//CheckFlags(bCharge,true,'WaitChargeAttack');
	Jump('WaitAttack');

AfterBlocked:
	plog("AfterBlocked");
	Goal_MoveTo(1, 15, GetTargetLocation(1), MOVE_WalkAlert,,MOVE_WalkAlert,false);
	Jump('WaitAttack');

TryAttackPoint:
	plog("TryAttackPoint");
	Jump('WaitAttack');

///////////////////////////////////////////////////////////////////////////////////////////
// TRIGGER SEARCH BEHAVIOR
///////////////////////////////////////////////////////////////////////////////////////////


Search_Location:

	plog("Search_Location -- Search at Event Location THEN in Random Direction");
	ResetGoals(1);
	GotoPatternState('Search', 'Search_Location');


Search_Directional:

	plog("Search_Directional -- Search at Event Location THEN in Event Direction");
	ResetGoals(1);
	GotoPatternState('Search', 'Search_Directional');
	

Search_GeneralDirection:
	
	plog("Search_GeneralDirection -- In Direction of Event");
	ResetGoals(1);
	GotoPatternState('Search', 'Search_Directional');

Search_General:

	plog("Search_General -- Use Last Known Player Location OR Forward Direction");
	ResetGoals(1);
	GotoPatternState('Search', 'Search_General');


Search_CHEAT:
	
	plog("Search_CHEAT -- Using Current Player Location as search key.   ** REPLACE **");
	ResetGoals(1);
	GotoPatternState('Search', 'Search_CHEAT');

AlarmBegin:
AlarmAttack:
	plog("AlarmAttack");
	ResetGoals(1);	
	//ForceUpdatePlayerLocation(1);
	//EAIController( Characters[1] ).LastKnownPlayerTime = Level.TimeSeconds;
	bReactedToAlarm=1;
	Goal_Charge(1,15,TriggerEvent.EventTarget,MOVE_JogAlert,true,TriggerEvent.EventLocation);
	//Goal_Charge(1,15,TriggerEvent.EventTarget,MOVE_JogAlert,true);
	Jump('WaitChargeAttack');


// ATTACK BEHAVIOR
AttackPlayerInZone:
	plog("AttackPlayerInZone");
	ResetGoals(1);
	CheckIfCanThrowGrenade('ThrowGrenade');
	Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');
	
ThrowGrenade:
	plog("ThrowGrenade");
	DisableMessages(true);
	
	if( VSize(Characters[1].Pawn.Location-GetTargetLocation(1)) < 50 )
	{
	Goal(1,GOAL_ThrowGrenade, 11,GrenadeLocation,GetTargetLocation(1),,,,,false,GrenadeTime);
	WaitForGoal(1,GOAL_ThrowGrenade);
	log("------------------------------------------ after goal throw grenade -------------------------------");
	}
	DisableMessages(false);
	Jump('WaitAttack');


AttackPlayer:

	plog("AttackPlayer");
	PlayerIdentified();
	CheckIfInZone('PlayerInZone');
	ResetGoals(1);
	Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');

AttackPlayerSurprised:

	plog("AttackPlayer -- Surprised");
	PlayerIdentified();
	CheckIfInZone('PlayerInZone');
	ResetGoals(1);
	Reaction(1, 50, TriggerEvent.EventLocation, REACT_Surprised);
	Goal_Attack(1, 14, 5.0f +  RandBias(0.50, 5.75f), Characters[0].Pawn, MOVE_JogAlert,false);
	Jump('WaitAttack');


}

