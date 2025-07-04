////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
class EPattern extends Actor
	native;

// REMOVE ME MATHIEW
const CAM_NONE		   = 0;
const CAM_CONVERSATION = 0;
const CAM_COMMUNICATOR = 0;
// REMOVE ME MATHIEW

// AddTraining mask definition //
const KEY_NONE_MASK         = 0x00000;
const KEY_MOVE_UP_MASK      = 0x00001;
const KEY_MOVE_DOWN_MASK    = 0x00002;
const KEY_MOVE_LEFT_MASK    = 0x00004;
const KEY_MOVE_RIGHT_MASK   = 0x00008;
const KEY_LOOK_UP_MASK      = 0x00010;
const KEY_LOOK_DOWN_MASK    = 0x00020;
const KEY_LOOK_LEFT_MASK    = 0x00040;
const KEY_LOOK_RIGHT_MASK   = 0x00080;
const KEY_INTERACTION_MASK  = 0x00100;
const KEY_SCOPE_MASK        = 0x00200;
const KEY_JUMP_MASK         = 0x00400;
const KEY_DUCK_MASK         = 0x00800;
const KEY_FIRE_MASK         = 0x01000;
const KEY_ALT_FIRE_MASK     = 0x02000;
const KEY_CHANGE_ROF_MASK   = 0x04000;
const KEY_QUICK_MASK        = 0x08000;
const KEY_MENU_MASK         = 0x10000;
const KEY_RESETCAMERA_MASK  = 0x20000;

const BARK_BIT    = 0x00000001;
const SEARCH_BIT  = 0x00000002;

var ECommunicationBox       CommBox;

var Controller		        Characters[10];
var Actor					SoundActors[3];
var int				        CurrentCharacter;
var Sound					CurrentSound;
var Sound					LaserMicSound;
var actor					CurrentSpeaker;
var float					CurrentProgression;
var float					SpeechDuration;
var Name			        CurrentJumpLabel;

var EchelonEnums.GoalType   CurrentGoalExpected;
var EAIEvent		        TriggerEvent;
var EAIController	        TriggerCharacter;
var Controller		        C;

var bool	                bIsRunning;				// False if pattern is complete
var	bool					bConversationRunning;	// False if Close(), EndConversation() or End() was called.
var bool			        bDisableMessages;
var bool                    bDisableEventTrigger;
var bool                    bLookWithStickyCam;
var bool					bRunningAlarm;
var bool			        bInit;
var bool                    bEventExclusivity;
var bool					bDontResetMusic;
var bool					LaserMicInit;
var bool					m_blatent;
var bool					m_bgameover;

var name					LastZoneTouched;
var int						bCharge;
var EVolume					CurrentVolume;
var	float					SessionProgress;

var int                     iSuggestedBehavior;

//communication stuff
var EAIController			CommTarget;
var AIEventType				eCommType;

// Microphone stuff
var ELaserMicMover			MicrophoneMover;

var vector				    CoverLocation;			// used to set a target location before jumping somewhere in the pattern
var EPawn					NearestArmedNPC;
var vector					AlertLocation;
var vector					GrenadeLocation;
var float					GrenadeTime;
var vector					ForceFocusVect;

var actor					LookActor;

var float                   fLastBegForLife;
var float                   fLastMasterOutOfRad;
var float                   fLastReflexTime; 

var String					m_String;
var Sound					m_Sound;
var int						m_CharacterIndex;
var BYTE					m_eEvent;
var BYTE					m_eType;
var float					m_progression;
var float					m_delay;
var float					m_Time;

var Sound					SatelliteCom;

var bool					WaitingForBeep;

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
native(1408) final latent function Talk(sound SoundData,int CharacterIndex, optional float delay,optional bool blatent, optional float progression);
native(1409) final latent function WaitForCommBox();
native(1407) final latent function Speech(string Text, sound SoundData,int CharacterIndex,optional byte Event,optional EchelonEnums.eTransmissionType Type, optional float progression, optional bool bGameOver );
native(1410) final latent function WaitForGoal(int CharacterIndex,EchelonEnums.GoalType Type, optional name Label);
native(1416) final function ProcessAI();
native(1420) final function CheckAttackPoint(int _CharacterIndex, name JumpLabel);
native(1425) final function StopSpeech();
native(1270) final function FreezeTraining();
native(1271) final function LookTarget(name ActorTag, optional bool bWithStickyCam);
native(1322) final function SetPatternAlwaysTick();

event ReflexCallBack(EAIEvent Event) {}
event EventCallBack(EAIEvent Event,Actor TriggerActor) {}
event AdjustDefaultPatternState(EchelonEnums.GoalType _GoalT) {}
event CommunicationCallBack(AIEventType eType) {}


//---------------------------------------[Frederic Blais]-----
// 
// Timer
// 
// Description:  Timer used for communication system
//
//------------------------------------------------------------------------
function Timer()
{
	local EPlayerController EPC;

    EPC = EPlayerController(Characters[0]);	

	if(EPC != None && EPC.bSavingTraining)
	{		
		ConsoleCommand("SAVEGAME FILENAME=TEMP OVERWRITE=TRUE");
	}
	else if(EPC != None && EPC.bLoadingTraining)
	{	
		ConsoleCommand("LOADGAME FILENAME=TEMP");  
	}
	else
	{
	CommTarget.Pattern.CommunicationCallBack(eCommType);
}
}


//---------------------------------------[Frederic Blais]-----
// 
// SendCommunication
// 
// Description: Send a communication to a NPC after a specific time
//
//------------------------------------------------------------------------
function SendCommunication(AIEventType eType, Actor Target, float time)
{
	CommTarget = EAIController(Target);
	eCommType = eType;

	if(CommTarget != None)
		SetTimer(time, false);
}

//---------------------------------------[Frederic Blais]-----
// 
// PostBeginPlay
// 
// Description: Post init.
//
//------------------------------------------------------------------------
function PostBeginPlay()
{
	Super.PostBeginPlay();
	TriggerEvent = spawn(class'EAIEvent');	
}



//---------------------------------------[David Kalina - 12 Oct 2001]-----
// 
// Description
//		Display Debug Information for Pattern.
//
//------------------------------------------------------------------------
function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local String T;
	local String S;

	Canvas.DrawColor.B = 200;	
	Canvas.DrawColor.R = 170;
	Canvas.DrawColor.G = 255;
	
	T = "PATTERN  State: " $ GetStateName() $ "  TriggerEvent:  ";

	S = GetTriggerEventString();

	T = T $ S;
	
	Canvas.DrawText(T,false);	
	YPos += YL;
	Canvas.SetPos(4,YPos);
}



//---------------------------------------[David Kalina - 13 Oct 2001]-----
// 
// Description
//		Shortcut for LPATTERN log w/ standard information attached.
//
//------------------------------------------------------------------------

function plog(coerce string S)
{
	log("P => " $ Characters[1].Pawn.Name $ " -- STATE:  " $ GetStateName() $ " -- " $ S $ 
		" -- " $ " EventTarget : " $ TriggerEvent.EventTarget $ " -- EventActor : " $ TriggerEvent.EventActor,,LPATTERN);
}

//---------------------------------------[David Kalina - 28 Nov 2001]-----
// 
// Description
//		Shortcut for logging the TriggerEvent's information.
//
//------------------------------------------------------------------------

function elog()
{
	local String S;

	S = "  TRIGGEREVENT : " $ GetTriggerEventString();

	log(S $ "  EventLocation:  " $ TriggerEvent.EventLocation $ "  EventTarget:  " $ TriggerEvent.EventTarget $ "  EventActor:" $ TriggerEvent.EventActor);
}


function String GetTriggerEventString()
{
	switch(TriggerEvent.EventType)
	{
        case AI_NONE                        : return "AI_NONE"; break;
        case AI_INVESTIGATE                 : return "AI_INVESTIGATE"; break;
        case AI_ATTACK                      : return "AI_ATTACK"; break;
        case AI_EXTERN_EVENTS               : return "AI_EXTERN_EVENTS"; break;
        case AI_SEE_NPC                     : return "AI_SEE_NPC"; break;
        case AI_SEE_CHANGED_ACTOR           : return "AI_SEE_CHANGED_ACTOR"; break;
        case AI_SEE_INTERROGATION           : return "AI_SEE_INTERROGATION"; break;
        case AI_SEE_PLAYER_INVESTIGATE      : return "AI_SEE_PLAYER_INVESTIGATE"; break;
        case AI_HEAR_SOMETHING              : return "AI_HEAR_SOMETHING"; break;
        case AI_SMELL_SOMETHING             : return "AI_SMELL_SOMETHING"; break;
        case AI_SHOT_JUST_MISSED            : return "AI_SHOT_JUST_MISSED"; break;
        case AI_TAKE_DAMAGE                 : return "AI_TAKE_DAMAGE"; break;
        case AI_SEE_PLAYER_SURPRISED        : return "AI_SEE_PLAYER_SURPRISED"; break;
        case AI_SEE_PLAYER_ALERT            : return "AI_SEE_PLAYER_ALERT"; break;
        case AI_INTERN_EVENTS               : return "AI_INTERN_EVENTS"; break;
        case AI_GOAL_COMPLETE               : return "AI_GOAL_COMPLETE"; break;
        case AI_GOAL_FAILURE                : return "AI_GOAL_FAILURE"; break;
        case AI_DEAD                        : return "AI_DEAD"; break;
        case AI_UNCONSCIOUS                 : return "AI_UNCONSCIOUS"; break;
        case AI_REVIVED                     : return "AI_REVIVED"; break;
        case AI_GRABBED                     : return "AI_GRABBED"; break;
        case AI_RELEASED                    : return "AI_RELEASED"; break;
        case AI_LOST_PLAYER                 : return "AI_LOST_PLAYER"; break;
        case AI_LOST_PLAYER_AFTER           : return "AI_LOST_PLAYER_AFTER"; break;
        case AI_SEE_PLAYER_AGAIN            : return "AI_SEE_PLAYER_AGAIN"; break;
        case AI_UPDATE_SEARCH               : return "AI_UPDATE_SEARCH"; break;
        case AI_SHOT_BLOCKED                : return "AI_SHOT_BLOCKED"; break;
        case AI_STUCK                       : return "AI_STUCK"; break;
        case AI_NEARLY_DEAD                 : return "AI_NEARLY_DEAD"; break;
        case AI_WEAPON_INEFFECTIVE          : return "AI_WEAPON_INEFFECTIVE"; break;
        case AI_LOW_AMMO                    : return "AI_LOW_AMMO"; break;
        case AI_NO_AMMO                     : return "AI_NO_AMMO"; break;
        case AI_PLAYER_FAR                  : return "AI_PLAYER_FAR"; break;
        case AI_PLAYER_CLOSE                : return "AI_PLAYER_CLOSE"; break;
        case AI_PLAYER_VERYCLOSE            : return "AI_PLAYER_VERYCLOSE"; break;
        case AI_PLAYER_DEAD                 : return "AI_PLAYER_DEAD"; break;
        case AI_UPDATE_STRATEGY_REQUEST     : return "AI_UPDATE_STRATEGY_REQUEST"; break;
        case AI_ALARM_ON_PRIMARY            : return "AI_ALARM_ON_PRIMARY"; break;
        case AI_ALARM_ON_SECONDARY          : return "AI_ALARM_ON_SECONDARY"; break;
        case AI_ALARM_UPDATE_POSITION       : return "AI_ALARM_UPDATE_POSITION"; break;
        case AI_ALARM_OFF                   : return "AI_ALARM_OFF"; break;
        case AI_INTERROGATION_QUERY_NPC     : return "AI_INTERROGATION_QUERY_NPC"; break;
        case AI_INTERROGATION_QUERY_SAM     : return "AI_INTERROGATION_QUERY_SAM"; break;
        case AI_FORCED_RETINAL_SCAN         : return "AI_FORCED_RETINAL_SCAN"; break;
        case AI_OUT_OF_DEFEND_RADIUS        : return "AI_OUT_OF_DEFEND_RADIUS"; break;
        case AI_PATROL_TIMEOUT              : return "AI_PATROL_TIMEOUT"; break;
        case AI_GET_DOWN                    : return "AI_GET_DOWN"; break;
        case AI_COVERPOINT_TOUCHED          : return "AI_COVERPOINT_TOUCHED"; break;
        case AI_COVER_LOST_PLAYER           : return "AI_COVER_LOST_PLAYER"; break;
        case AI_GROUP_LAST_MEMBER           : return "AI_GROUP_LAST_MEMBER"; break;
        case AI_GROUP_LOST_PLAYER           : return "AI_GROUP_LOST_PLAYER"; break;
        case AI_GROUP_SEE_PLAYER_AGAIN      : return "AI_GROUP_SEE_PLAYER_AGAIN"; break;
        case AI_MASTER_OUT_OF_RADIUS        : return "AI_MASTER_OUT_OF_RADIUS"; break;
        case AI_HEAR_RICOCHET               : return "AI_HEAR_RICOCHET"; break;
        case AI_COMMUNICATION_EVENTS        : return "AI_COMMUNICATION_EVENTS"; break;
        case AI_ARE_YOU_OK                  : return "AI_ARE_YOU_OK"; break;
        case AI_LET_HIM_GO                  : return "AI_LET_HIM_GO"; break; 
        case AI_MASTER_DEAD                 : return "AI_MASTER_DEAD"; break;
		default : return "Unknown Type: " $ TriggerEvent.EventType;
	}
}

//--------------------------------------------------[Frederic Blais]-----
// 
// Assign
// 
// Description: Assign all the members to a pattern.
//
//------------------------------------------------------------------------
function Assign(ESlist Members,EAIController TriggerMember)
{
	local EListNode Node;
	local EAIController C;
	local int i;

    //log("Assign was called!!!");

	//assign members
	Characters[1] = TriggerMember;

	//check if the list is empty
	if(Members == None)
		return;

	Node = Members.FirstNode;
	i=2;

	while(Node != None)
	{
		C = EAIController(Node.Data);

		switch(C.type)
		{
		case 0:
			//spetsnaz
			if(C == TriggerMember)
            {
				Characters[1] = C;
            }
			else
				Characters[i++] = C;
			break;
		default:
			break;
		}

		Node = Node.NextNode;
	}
}

//--------------------------------------------------[Frederic Blais]-----
// 
// InitPattern
// 
// Description: Set the player, the communication box 
//
//------------------------------------------------------------------------
function InitPattern()
{
	//default init
	Characters[0] = EchelonGameInfo(Level.Game).pPlayer;
	
	//init commbox
	Commbox = EMainHUD(EchelonGameInfo(Level.Game).pPlayer.myHUD).CommunicationBox;	
}


//----------------------------------------[David Kalina - 5 Oct 2001]-----
// 
// Description
//		By default we jump to the input label in state 'Pattern'
//		Can be redefined by patterns that wish to use states.
// 
//------------------------------------------------------------------------

event GotoPatternLabel(name label)
{
	//Log("BASE GotoPatternLabel : " $ label);
	GotoState('Pattern', label);
}


//--------------------------------------------------[Frederic Blais]-----
// 
// StartPattern
// 
// Description: Initialize the pattern AND junmp at the start label
//
//------------------------------------------------------------------------
function StartPattern(optional name Label)
{ 
	InitPattern();
	
	bIsRunning = true;
	bConversationRunning = true;

	if(Label == '')
	{
		GotoPatternLabel('begin');
	}
	else
	{
		GotoPatternLabel(Label);
	}

	ProcessAI();

}

//--------------------------------------------------[Frederic Blais]-----
// 
// StopPattern
// 
// Description: End the processing of the pattern
//
//------------------------------------------------------------------------
function StopPattern( optional bool bInterrupted )
{
	// Stop all sounds
	StopSpeech();
	StopSleep();

	Close(bInterrupted);
	End();
}



//--------------------------------------------------[Frederic Blais]-----
// 
// PatternIsRunning
// 
// Description: Check to see if the pattern is running
//
//------------------------------------------------------------------------
function bool PatternIsRunning()
{
	return bIsRunning;
}

//--------------------------------------------------[Frederic Blais]-----
// 
// Goal_Set
// 
// Description: Goal used by the editor. That new function takes tags
//				for focus and target.
//
//------------------------------------------------------------------------
function Goal_Set(int							_CharacterIndex,
				  EchelonEnums.GoalType			_Type, 
				  byte							_Priority,
				  optional Vector				_Location,
				  optional Name					_FocusTag,
				  optional Name					_TargetTag,
				  optional Name					_Tag,
				  optional Name					_Anim,
				  optional bool					_Flag,
				  optional float				_value,
				  optional MoveFlags			_MoveFlags,
				  optional vector				_Direction,
				  optional MoveFlags			_WaitFlags
			  )
{
	local Actor  Target, NavTarget;
	local Vector Focus;
	local EAIController AI;
	local bool _UpdatePlayerPos;

	//CurrentVolume=None;
	_UpdatePlayerPos=false;
	GrenadeLocation= vect(0.0f,0.0f,0.0f);
 
	AI =  EAIController(Characters[_CharacterIndex]);

	AI.TargetLocation = vect(0.0f,0.0f,0.0f);

	if(AI == None)
		return;

	if(AI.bNotResponsive && AI.GetStateName() != 's_stunned')
		return;

	//change the Focus tag to a vector
	if(_FocusTag == 'PLAYER')
	{
		//set the player location
		Focus = Characters[0].pawn.Location;
	}
	else
	{
		if(_FocusTag != '')
		{
			Target = AI.GetMatchingActor( _FocusTag );

            if (Target != None)
            {
			    Focus = Target.Location;
            }
            else
            {
                plog("EPattern::Goal_Set() - Bad Focus Tag : " $ _FocusTag);
                Focus = vect(0,0,0);
            }
		}
		else
			Focus = vect(0,0,0);
	}

	//change the target tag to an actor reference
	if(_TargetTag == 'PLAYER' )
	{
		//set the player reference
		Target= Characters[0].pawn;
	}
	else
	{
		if(_TargetTag != '')
			Target = AI.GetMatchingActor( _TargetTag );
		else
			Target = None;
	}


	if(_Type == GOAL_Charge)
		bCharge=1;


	//check if we are going to attack from a cover point
	if(_Type == GOAL_Attack)
	{
		NavTarget = AI.GetMatchingActor( _Tag );

		if( PathNode(NavTarget) !=  None )
		{
			if(PathNode(NavTarget).bCoverPoint)
				AI.LockNavPoint( PathNode(NavTarget) );
		}
	}

	if((_Type == GOAL_Attack) || (_Type == GOAL_MoveAndAttack))
	{
		bCharge=0;

		if(!AI.epawn.bDrunk)
		{
			if(Characters[0].pawn == Target)
			{
				ForceUpdatePlayerLocation(_CharacterIndex);
				_UpdatePlayerPos=true;
			}

			ChangeState(1,'s_alert');

			if(AI.Pattern != None)
				AI.Pattern.GotoState('Attack');
		}
	}

	AI.AddGoal(_Type,_Priority,_Location,Focus,Target,_Tag,_Anim,,_Flag,_value,_MoveFlags,_Direction,_WaitFlags,_UpdatePlayerPos);

}


//--------------------------------------------------[Frederic Blais]-----
// 
// Goal_Default
// 
// Description: Replace the default goal of a member
//
//------------------------------------------------------------------------
function Goal_Default(	 int					_CharacterIndex,
				  EchelonEnums.GoalType			_Type, 
				  byte							_Priority,
				  optional Vector				_Location,
				  optional Name					_FocusTag,
				  optional Name					_TargetTag,
				  optional Name					_Tag,
				  optional Name					_Anim,
				  optional bool					_Flag,
				  optional float				_value,
				  optional MoveFlags			_MoveFlags,
				  optional vector				_Direction,
				  optional MoveFlags			_WaitFlags
			  )
{
	local Actor  Target;
	local Vector Focus;
	local EAIController AI;

	//CurrentVolume=None;

	AI =  EAIController(Characters[_CharacterIndex]);

	if(AI == None)
		return;

	//change the Focus tag to a vector
	if(_FocusTag == 'PLAYER')
	{
		//set the player location
		Focus = Characters[0].pawn.Location;
	}
	else
	{
		if(_FocusTag != '')
		{
			Target = AI.GetMatchingActor( _FocusTag );
			Focus = Target.Location;
		}
		else
			Focus = vect(0,0,0);
	}

	//change the target tag to an actor reference
	if(_TargetTag == 'PLAYER' )
	{
		//set the player reference
		Target= Characters[0].pawn;
	}
	else
	{
		if(_TargetTag != '')
			Target = AI.GetMatchingActor( _TargetTag );
		else
			Target = None;
	}

	if(_Type == GOAL_Charge)
		bCharge=1;

	if(_Type == GOAL_Attack)
		bCharge=0;

	AI.ReplaceDefaultGoal(_Type,_Priority,_Location,Focus,Target,_Tag,_Anim,,_Flag,_value,_MoveFlags,_Direction,_WaitFlags);
}

//--------------------------------------------------[Frederic Blais]-----
// 
// Goal
// 
// Description: Add a goal to a member of the pattern
//              Usually called by default patterns
//
//------------------------------------------------------------------------
function Goal(	 int							_CharacterIndex,
				 EchelonEnums.GoalType			_Type, 
				 byte							_Priority,
				 optional Vector				_Location,
				 optional Vector				_Focus,
				 optional Actor					_Target,
				 optional Name					_Tag,
				 optional Name					_Anim,
				 optional Sound					_Sounds,
				 optional bool					_Flag,
				 optional float					_value,
				 optional MoveFlags				_MoveFlags,
				 optional bool					_bAltLocation,
				 optional Sound					_Sound,
				 optional vector				_Direction,
				 optional MoveFlags				_WaitFlags
			  )
{
	local NavigationPoint   Nav;
    local bool              bUpdatePlayerLoc;

	//CurrentVolume=None;

	if(_Type == GOAL_Charge)
		bCharge=1;

	if(_Type == GOAL_Attack)
	{
		if( Characters[_CharacterIndex].pawn.bIsCrouched )
		{
			_WaitFlags =  MOVE_CrouchJog;
		}

		bCharge=0;
	}

    // Fail on stuck for goals assigned by default patterns
    if(_Type == GOAL_MoveTo)
    {
        //log("Fail on stuck for goals assigned by default patterns");
        bUpdatePlayerLoc = true;
    }

	if(Characters[_CharacterIndex] != None)
	{

		if(_bAltLocation)
		{
			Nav = EAIController(Characters[_CharacterIndex]).ChooseSearchPoint( _Location );
			EAIController(Characters[_CharacterIndex]).AddGoal(_Type,_Priority,Nav.Location,_Focus,_Target,_Tag,_Anim,_Sounds,_Flag,_value,_MoveFlags,_Direction,_WaitFlags, bUpdatePlayerLoc);
		}
		else
		{

			EAIController(Characters[_CharacterIndex]).AddGoal(_Type,_Priority,_Location,_Focus,_Target,_Tag,_Anim,_Sounds,_Flag,_value,_MoveFlags,_Direction,_WaitFlags, bUpdatePlayerLoc);
		}
	}
}




//////////////////////////////////////////////////////////////////////////////////////////////////////
// shortcuts for default patterns - to increase readability //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//---------------------------------------[David Kalina - 18 Sep 2001]-----
// 
// Goal_Action
//
// Description
//		Wrapper function for adding action Goal.
// 
//------------------------------------------------------------------------
function Goal_Action( int CharIndex, int Priority, optional vector Focus, optional Name Anim, optional Sound Sounds, OPTIONAL float FrameRate, optional MoveFlags _MoveFlags)
{
	bCharge=0;
	//CurrentVolume=None;
	Goal(CharIndex, GOAL_Action, Priority,, Focus,,, Anim, Sounds,,,_MoveFlags,,,,_MoveFlags);
}

//---------------------------------------[David Kalina - 25 Mar 2002]-----
// 
// Description
//		Not really a goal -- sets goal action possibly with blending,
//		depending on the input ReactionType.
// 
//------------------------------------------------------------------------

function Reaction( int CharIndex, int Priority, optional vector Focus, optional eReactionAnimGroup ReactionType, optional actor Target)
{
	local name Anim, AnimB;
	local float BlendAlpha;

	bCharge=0;

	if(Characters[CharIndex].GetStateName() == 's_SitDown')
		return;

	// if AnimB is specified, Goal Action will use it for blending
	Characters[CharIndex].GetReactionAnim(Anim, AnimB, BlendAlpha, ReactionType);
	EAIController(Characters[CharIndex]).AddGoal(GOAL_Action, Priority,, Focus,Target,,Anim,,,BlendAlpha,,,,,AnimB);
}

//---------------------------------------[David Kalina - 18 Sep 2001]-----
// 
// Goal_Search
//
// Description
//		Wrapper function for adding Search Goal.
//		If Search goal already running, just update.
// 
//------------------------------------------------------------------------
function Goal_Search( int CharIndex, 
					  int Priority, 
					  optional vector SearchLocation,  
					  optional vector SearchDirection, 
					  optional bool bFocusSwitching, 
					  optional float SearchTime, 
					  optional MoveFlags _MoveFlags,
					  optional actor  SearchTarget) 
{
	// check existing goal and make sure we don't add redundant search goal

	local EAIController TargetAI;
	local EGoal G;

	//CurrentVolume=None;
	TargetAI = EAIController(Characters[CharIndex]);

	if ( TargetAI != none )
	{
		G = TargetAI.m_pGoalList.GetCurrent();

		if ( G != none )
		{
			// if already executing search goal, UPDATE LOCATION AND RESET TIMER
			// TODO : Replace with more complete goal replacement functionality (reinitialize based on new parameters)
			if ( G.m_GoalType == GOAL_Search )
			{
				G.GoalLocation = SearchLocation;
				G.GoalValue    = EPawn(TargetAI.Pawn).MinSearchTime;
			}
			else
			{
				bCharge=0;
				Goal(CharIndex, GOAL_Search, Priority, SearchLocation,,SearchTarget,,,,bFocusSwitching, SearchTime, _MoveFlags,,,SearchDirection);
			}
		}
	}
}


//---------------------------------------[David Kalina - 18 Sep 2001]-----
// 
// Description
//		Wrapper function for adding Attack Goal.
// 
//------------------------------------------------------------------------

//function Goal_Attack( int CharIndex, int Priority, vector AttackLocation, Actor AttackTarget, optional MoveFlags _MoveFlags, optional MoveFlags WaitFlags)
function Goal_Attack(int CharIndex, int Priority, float TimeToStop , Actor AttackTarget, optional MoveFlags WaitFlags, optional bool flag,optional Name Anim, optional vector _Location, optional bool _bForceFocusTag)
{
	local actor AFocus;

	if(_Location != vect(0,0,0))
	{
		if(VSize(Characters[CharIndex].pawn.Location - _Location) < 800)
		{
			if( Characters[CharIndex].pawn.bIsCrouched )
			{
				WaitFlags = MOVE_CrouchJog;
			}
		}
	}

	ForceFocusVect=vect(0,0,0);

	if(_bForceFocusTag)
	{

		if(CurrentVolume.ForceFocusTag != '')
		{
			AFocus = GetMatchingActor(CurrentVolume.ForceFocusTag);

			if(AFocus != None)
			{
				ForceFocusVect = AFocus.Location;
			}
		}
	}

	bCharge=0;
	//Goal(CharIndex, GOAL_Attack, Priority, AttackLocation,, AttackTarget,,,,,,_MoveFlags,,,,WaitFlags);
	Goal(CharIndex, GOAL_Attack, Priority,_Location,,AttackTarget,,Anim,,flag,TimeToStop,WaitFlags,,,,WaitFlags);
}

//------------------------------------------------------------------------
// 
// Description
//		Wrapper function
//------------------------------------------------------------------------
function Goal_SprayFire(int CharIndex, int Priority, float TimeToStop , Actor AttackTarget, optional MoveFlags WaitFlags, optional bool flag)
{
	bCharge=0;
	//Goal(CharIndex, GOAL_Attack, Priority, AttackLocation,, AttackTarget,,,,,,_MoveFlags,,,,WaitFlags);
	Goal(CharIndex, Goal_SprayFire, Priority,,,AttackTarget,,,,flag,TimeToStop,WaitFlags,,,,WaitFlags);
}

//------------------------------------------------------------------------
// 
// Description
//		Wrapper function
//------------------------------------------------------------------------
function Goal_Stop(  int CharIndex, int Priority, float TimeToStop, optional Actor FocusActor, optional MoveFlags WaitFlags, optional bool flag, optional Vector FocusLocation )
{
	bCharge=0;
	Goal(CharIndex, GOAL_Stop, Priority,,FocusLocation,FocusActor,,,,flag,TimeToStop,WaitFlags,,,,WaitFlags);
}

//------------------------------------------------------------------------
// 
// Description
//		Wrapper function
//------------------------------------------------------------------------
function Goal_MoveTo( int CharIndex, int Priority, vector Location, MoveFlags _MoveFlags, optional vector Focus, optional MoveFlags WaitFlags, optional bool _attack)
{

	bCharge=0;
	//CurrentVolume=None;

	//try to keep coherence in moveflags
	if( Characters[CharIndex].pawn.bIsCrouched )
	{
		_MoveFlags = MOVE_CrouchJog;
		WaitFlags = MOVE_CrouchJog;
	}
	

	// DONE MOVING?
	//if ( VSize(Location - EAIController(Characters[CharIndex]).ePawn.Location) > 100.0f )

	if(_attack)
		Goal(CharIndex, GOAL_MoveAndAttack, Priority, Location, Focus,characters[0].pawn,,,,true,,_MoveFlags,,,,WaitFlags);
	else
		Goal(CharIndex, GOAL_MoveTo, Priority, Location, Focus,characters[0].pawn,,,,true,,_MoveFlags,,,,WaitFlags);

}


//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function  bool ChooseStrategicPoint(EPlayerController P)
{
	local int i, Index;
	local float dotproduct;
	local float BestDistance,CurDist;
	local actor BestPoint;
	local NavigationPoint CurNav;

	BestDistance=0.0f;
	BestPoint=None;

	//pick up one strategic point 
	for(i=0; i < P.CurrentVolume.StrategicPoints.Length; i++)
	{
		if( (P.CurrentVolume.StrategicPoints[i] != None) && 
			((!P.CurrentVolume.StrategicPoints[i].taken) || ( EAIController(Characters[1]).TakenPoint == P.CurrentVolume.StrategicPoints[i] )) )
		{

			if( EPawn(Characters[1].pawn).DefendActor != None )
			{
				CurDist = VSize(P.CurrentVolume.StrategicPoints[i].Location - EPawn(Characters[1].pawn).DefendActor.Location);

				if( CurDist >  EPawn(Characters[1].pawn).DefendDistance )
					continue;
			}
			
			CurDist = VSize(P.CurrentVolume.StrategicPoints[i].Location - Characters[1].pawn.Location);

			CurNav  = P.CurrentVolume.StrategicPoints[i];

			if(CurNav != None)
			{
				if(CurNav.bCoverPoint)
				{
					if(EAIController(Characters[1]).EvaluateCorner(CurNav,Characters[0].pawn.Location) == CA_OFF)
						continue;
				}

				if(BestDistance < 0.1f)
				{
					BestDistance = CurDist;
					BestPoint = P.CurrentVolume.StrategicPoints[i];
					Index=i;
				}
				else
				{
					if(BestDistance > CurDist)
					{
						BestDistance = CurDist;
						BestPoint = P.CurrentVolume.StrategicPoints[i];
						Index=i;
					}
				}
			}
		}

	}

	if(BestPoint != None)
	{
		if(P.CurrentVolume.bDontUseIfPlayerSeen)
		{
			if(EAICOntroller(Characters[1]).bPlayerSeen)
				return false;
		}
		else
		{
			//lock the nav point
			EAIController(Characters[1]).LockNavPoint( P.CurrentVolume.StrategicPoints[Index] );

			//set the new target location of the NPC
			EAIController(Characters[1]).TargetLocation = P.CurrentVolume.StrategicPoints[Index].Location;

			//set the current zone
			CurrentVolume = P.CurrentVolume;

			GrenadeTime=0.0f;

			if(CurrentVolume.bUseGrenadePoints && (CurrentVolume.GrenadePoints[Index] != None))
			{

				GrenadeLocation = CurrentVolume.GrenadePoints[Index].Location;

				plog("--------------------------------- Setting grenade location ------------------------------ "$GrenadeLocation);

				if(EFocusPoint(CurrentVolume.GrenadePoints[Index]) != None)
				{
					GrenadeTime		= EFocusPoint(CurrentVolume.GrenadePoints[Index]).GrenadeTime;
				}	
			}

			return true;
		}
	}
	else
	{
		return false;
	}
}

//------------------------------------------------------------------------
// 
// Description
//		Wrapper function
//------------------------------------------------------------------------
function Goal_Charge( int _CharIndex, int _Priority, Actor _Target, MoveFlags _MoveFlags, optional bool _flag, optional vector Loc, optional bool _DontUseVolume, optional float _value) 
{
	//local bool bPointFound;
	local EPlayerController P;
	local vector SideStepLoc;

	bCharge=0;

	P = EPlayerController(Characters[0]);

	//check if the player is in a special zone
	if(!_DontUseVolume)
	{
		if(P.CurrentVolume != None)
		{
			if(ChooseStrategicPoint(P))
				GotoPatternLabel('PlayerInZone');
		}
	}

	bCharge=1;

	Goal(_CharIndex,GOAL_Charge,_Priority,Loc,,_Target,,,,_flag,_value,_MoveFlags);

}

//End of wrappers ///////////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function CheckIfPlayerStillInZone(name JumpLabel)
{
	local EPlayerController P;

	P = EPlayerController(Characters[0]);

	if(P.CurrentVolume != None)
	{
		if(CurrentVolume == P.CurrentVolume)
		{
			plog("Still in zone");
			GotoPatternLabel(JumpLabel);
		}
	}
}

//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function CheckIfInZone(name JumpLabel)
{
	local EPlayerController P;

	P = EPlayerController(Characters[0]);

	plog("CheckIfInZone - Characters[0]: "$EPlayerController(Characters[0])$" Currentvol: "$P.CurrentVolume$" PAwn: "$Characters[1].pawn);
	if(P.CurrentVolume != None)
	{
		if(ChooseStrategicPoint(P))
		{
			//log("Choosing Strategic point "$characters[1].pawn);
			GotoPatternLabel(JumpLabel);
		}
	
		CurrentVolume = P.CurrentVolume;

	}
	else
	{
		CurrentVolume=None;
	}

}

//--------------------------------------------------[Frederic Blais]------
// 
// CheckIfGrabbed
// 
// Description: check if the member is grabbed. Will be used for conversation.
//				Jump to Label if the NPC is grabbed.
//
//------------------------------------------------------------------------
function CheckIfGrabbed(int CharIndex, name JumpLabel)
{
	//check the name of the state
	if(EAIController(Characters[CharIndex]).GetStateName() == 's_Grabbed')
	{
		GotoPatternLabel(JumpLabel);
	}
}

/*-----------------------------------------------------------------------------
 
 Function:      CheckIfIsUnconscious
 
 Description:   check if the member is unconscious. 
                Will be used for conversation.
				Jump to Label if the NPC is unconscious.

-----------------------------------------------------------------------------*/
function CheckIfIsUnconscious(int CharIndex, name JumpLabel)
{
	//check the name of the state
	if((EAIController(Characters[CharIndex]).GetStateName() == 's_Unconscious')
        || ((EAIController(Characters[CharIndex]).GetStateName() == 's_Carried') && (EAIController(Characters[CharIndex]).pawn.health > 0)))

	{
		GotoPatternLabel(JumpLabel);
	}
}

//--------------------------------------------------[Frederic Blais]------
// 
// CheckIfIsDead
// 
// Description: check if the member is dead.
//				Jump to Label if the NPC is dead.
//
//------------------------------------------------------------------------
function CheckIfIsDead(int CharIndex, name JumpLabel)
{
	//check the health of the member
    if( (EAIController(Characters[CharIndex]) == None) 
     || (EAIController(Characters[CharIndex]).epawn == None) 
     || (EAIController(Characters[CharIndex]).epawn.health <= 0)
     || (EAIController(Characters[CharIndex]).epawn.Controller == None))
	{
		GotoPatternLabel(JumpLabel);
	}
}

//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function CheckIfPlayerDead( name JumpLabel)
{
	//check the health of the member
	if(EPlayerController(Characters[0]).epawn.health <= 0)
	{
		GotoPatternLabel(JumpLabel);
	}
}

//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function CheckIfAllMembersDead(name JumpLabel)
{
	local int i;

	for(i=0; i< 10; i++)
	{
		if(!( (EAIController(Characters[i]) == None) || (EAIController(Characters[i]).epawn == None) ||
		    (EAIController(Characters[i]).epawn.health <= 0)))
		{
			return;
		}
	}

	//all members are dead
	GotoPatternLabel(JumpLabel);
}


//---------------------------------------[David Kalina - 19 Mar 2002]-----
// 
// Description
//		Are the sounds of war (gunshots, explosions) near enough to treat as "Nearby" threat?
// 
//------------------------------------------------------------------------

function CheckIfThreatNearby(int CharIndex, name JumpLabel)
{
	local actor TraceActor;
	local vector HitLocation, HitNormal;

	// if event is within x meters, jump

	if ( VSize(TriggerEvent.EventLocation - Characters[CharIndex].Pawn.Location) < 500.0f )
		GotoPatternLabel(JumpLabel);

	// otherwise, check if LOS to event location is clear

	TraceActor = Trace(HitLocation, HitNormal, TriggerEvent.EventLocation, Characters[CharIndex].Pawn.Location, false);
	
	plog("CheckThreatNearby -- Dist to Event : " $ VSize(TriggerEvent.EventLocation - Characters[CharIndex].Pawn.Location) $ "    Trace HitLocation : " $ HitLocation $ " TRACE ACTOR : " $ TraceActor);

	if ( TraceActor == none || TraceActor == TriggerEvent.EventTarget )
		GotoPatternLabel(JumpLabel);			
}





//---------------------------------------[David Kalina - 15 Apr 2002]-----
// 
// Description
//		If in a new GOAL_Charge, continue charging even if the player is seen.
//
//------------------------------------------------------------------------

function CheckIfChargeShouldContinue(int CharIndex, name JumpLabel)
{
	local EAIController TargetAI;
	local EGoal G;

	TargetAI = EAIController(Characters[CharIndex]);

	if ( TargetAI != none )
	{
		G = TargetAI.m_pGoalList.GetCurrent();

		if ( G != none && G.m_GoalType == GOAL_Charge )
		{
			if ( TargetAI.bPlayerSeen ) 
			{
				// only continue checking timer if distance to player is greater than 150.0f
				if ( (VSize(Characters[0].Pawn.Location - TargetAI.Pawn.Location) > 150.0f) )
				{
					GotoPatternLabel(JumpLabel);	
				}
			}
			/*else
			{
				GotoPatternLabel(JumpLabel);
				return;
			}*/
		}
	}
}

//---------------------------------------[David Kalina - 19 Mar 2002]-----
// 
// Description
//		If character specified by index is currently executing
//		the specified goal type, jump to the input label.
//
//------------------------------------------------------------------------

function CheckIfExecutingGoal(int CharIndex, EchelonEnums.GoalType CheckGoalType, name JumpLabel)
{
	local EAIController TargetAI;
	local EGoal G;

	TargetAI = EAIController(Characters[CharIndex]);

	if ( TargetAI != none )
	{
		G = TargetAI.m_pGoalList.GetCurrent();

		if ( G != none && G.m_GoalType == CheckGoalType )
			GotoPatternLabel(JumpLabel);
	}
}

//--------------------------------------------------[Frederic Blais]------
// 
// SetExclusivity
// 
// Description:  Set the exlusivity flag of the pattern. The groupAI
//				 always check that flag for the groupAI.
//
//------------------------------------------------------------------------
function SetExclusivity(bool bEnable)
{
	local int i;
	local EAIController AI;

	plog("SetExclusivity : "$bEnable$" Pattern: "$self);
	bEventExclusivity = bEnable;

	//reset some parameters in the controller when going back to exclusivity FALSE for the default patterns
	/*if(!bEnable)
	{
		for(i=0; i < 10; i++)
		{
			AI = EAIController(Characters[1]);

			if(AI != None)
			{
				AI.group.bExternEventWasSent=false;
				//AI.bPlayerSeen=false;
			}
		}
	}*/
}

//--------------------------------------------------[Frederic Blais]------
// 
// JumpToLastZoneTouched
// 
// Description: 
//
//
//------------------------------------------------------------------------
function JumpToLastZoneTouched()
{
	if(LastZoneTouched != '')
	{
		Jump(LastZoneTouched);
	}
}

//--------------------------------------------------[Frederic Blais]------
// 
// ChangeState
// 
// Description: Change state of a member of the pattern (default,aware, alert)
//
//------------------------------------------------------------------------
function ChangeState(int	_CharacterIndex, name StateLabel)
{

	local EAIController AI;


	AI = EAIController(Characters[_CharacterIndex]);

	if ( AI != none && AI.Pawn != none && AI.Pawn.Health > 0 )
	{
		if(StateLabel == 's_default')
			AI.Pattern.GotoState('idle');

		AI.GotoStateSafe(StateLabel);
	}
}

//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function ChangeGroupState(name StateLabel)
{

	if(EGroupAI(Owner) !=  None)
	{
		EGroupAI(Owner).ChangeStates(StateLabel);
	}
}

//---------------------------------------------------[Frederic Blais]-----
// 
// Broadcast
// 
// Description: Send signal to tell groupAI to broadcast resulting action
//				(in response of a stimuli) to other members.  
//
//------------------------------------------------------------------------
function Broadcast(int	_CharacterIndex, BroadCastType _BCType)
{
	local EAIController AI;
	AI = EAIController(Characters[_CharacterIndex]);

	plog("BROADCASTING TYPE : " $ _BCType);
	
	if((EGroupAI(Owner) != None) && (!AI.EPawn.bDoesntBroadcast))
	{
		EGroupAI(Owner).Broadcast(EAIController(Characters[_CharacterIndex]),_BCType,TriggerEvent.EventLocation);
	}
}

//--------------------------------------------------[Frederic Blais]-----
// 
// GetTargetLocation
// 
// Description: Get the target location set by the GroupAI
//
//------------------------------------------------------------------------
function vector GetTargetLocation(int	_CharacterIndex)
{
	return EAIController(Characters[_CharacterIndex]).TargetLocation;
}

//--------------------------------------------------[Frederic Blais]-----
// 
// AskGroupForPlayerPosition
// 
// Description: If player is visible from the group, update the target location
//				and jump at the specific label.
// 
//------------------------------------------------------------------------
function AskGroupForPlayerPosition(name JumpLabel)
{
	local bool bSomeoneKnowsPlayerLocation;

	bSomeoneKnowsPlayerLocation=false;

	if(EGroupAI(Owner) != None)
	{
		//check basicaly if the playerseen is TRUE one member
		if( EGroupAI(Owner).PlayerIsVisible() )
		{
			bSomeoneKnowsPlayerLocation=true;
		}

		if(bSomeoneKnowsPlayerLocation)
		{

			if(Characters[0].pawn.health > 0)
			{
				//EAIController(Characters[1]).TargetLocation = Characters[0].pawn.Location;
				GotoPatternLabel(JumpLabel);
			}
			else
			{
				//the player is dead
				End();
			}
		}

	}
}

//-------------------------------------------------------[Frederic Blais]-----
// 
// UpdateGoal
// 
// Description: Update goal location, special flag, and the wait flag.
//
//----------------------------------------------------------------------------
function UpdateGoal(int							_CharacterIndex,
				 optional name					_ActorTag,
				 optional bool					_Flag,
				 optional MoveFlags				_WaitFlag
			  )
{
	local EGoal Goal;
	local Actor A;

	if(Characters[_CharacterIndex] != None)
	{
		//check if we are waiting for that goal
		Goal = EAIController(Characters[_CharacterIndex]).m_pGoalList.GetCurrent();

		if(_ActorTag != '')
		{
			A = EAIController(Characters[_CharacterIndex]).GetMatchingActor( _ActorTag );

			if(A != None)
				Goal.GoalLocation	= A.Location;					// set its location
		
			//check if we are going to attack from a cover point
			if(Goal.m_GoalType == GOAL_Attack)
			{
				if( PathNode(A) !=  None )
				{
					if(PathNode(A).bCoverPoint)
						EAIController(Characters[_CharacterIndex]).LockNavPoint(PathNode(A));
				}
			}
		}

		Goal.GoalFlag       = _Flag;
		
		if ( _WaitFlag != MOVE_NotSpecified )
			Goal.GoalWaitFlags  = _WaitFlag;
	}
}

//------------------------------------------------------[Frederic Blais]-----
// 
// UpdateGoalLoc
// 
// Description: Update the goal location.
//
//---------------------------------------------------------------------------
function UpdateGoalMoveFlag(int	_CharacterIndex,  MoveFlags	_MoveFlag)
{
	local EGoal Goal;

	if(Characters[_CharacterIndex] != None)
	{
		Goal = EAIController(Characters[_CharacterIndex]).m_pGoalList.GetCurrent();

		if ( _MoveFlag != MOVE_NotSpecified )
		{
			Goal.GoalMoveFlags  = _MoveFlag;
			Goal.GoalWaitFlags  = _MoveFlag;
		}
	}
}


//------------------------------------------------------[Frederic Blais]-----
// 
// UpdateGoalLoc
// 
// Description: Update the goal location.
//
//---------------------------------------------------------------------------
function UpdateGoalLoc(int _CharacterIndex,Vector _Location)
{
	local EGoal Goal;

	//check if we are waiting for that goal
	Goal = EAIController(Characters[_CharacterIndex]).m_pGoalList.GetCurrent();

	Goal.GoalLocation	= _Location;					// set its location

}


//---------------------------------------[David Kalina - 16 Oct 2001]-----
// 
// Description
//		Update current Search goal according to specified parameters
// 
// Input
//		_CharIndex :   which character we are updating for
//		GoalLocation : new location to search at 
//		GoalFlag :     true = use focus switching
//		bResetTimer :  true = reset timer so search will go on for longer period of time
// 
//------------------------------------------------------------------------
function UpdateSearchGoal(int _CharIndex, vector GoalLocation, bool GoalFlag, bool bResetTimer)
{
	local EAIController AI;
	
	//check if we are waiting for that goal
	AI = EAIController(Characters[_CharIndex]);
	
	if ( AI != none )
		AI.UpdateSearchGoal(GoalLocation, GoalFlag, bResetTimer);
}

//---------------------------------------[David Kalina - 16 Oct 2001]-----
// 
// Description
//		For when we see something and wish to extend the search timer.
//		Can also just reset the timer if we don't specify ExtraSeconds.
//
// Input
//		_CharIndex : 
//		ExtraSeconds : How much we wish to add to search timer.
// 
//------------------------------------------------------------------------
function UpdateSearchTimer(int _CharIndex, optional float ExtraSeconds)
{
	local EGoal Goal;
	local EAIController AI;
	
	//check if we are waiting for that goal
	AI = EAIController(Characters[_CharIndex]);
	Goal = AI.m_pGoalList.GetCurrent();

	if ( Goal.m_GoalType == GOAL_Search )
	{
		if ( ExtraSeconds > 0 )
        {
			Goal.GoalValue += ExtraSeconds;
        }
		else
        {
			Goal.GoalValue = AI.EPawn.MinSearchTime;
        }
	}  
}



//---------------------------------------[David Kalina - 15 Oct 2001]-----
// 
// Description
//		If cover is available, set CoverLocation and jump to 
//		specified Label.
//
// Input
//		_CharIndex :	Character index searching for cover
//		distance :		Maximum distance at which to accept cover
//		Label :			Target label to jump to if cover is available
// 
//------------------------------------------------------------------------
function PossiblyTakeCover(int _CharIndex, float distance, name Label, optional vector TargetLocation)
{
	local EAIController AI;
	local Actor CoverActor;
	local float dotproduct;

	AI = EAIController(Characters[_CharIndex]);

	// reset first
	CoverLocation = vect(0,0,0);

	if ( AI != none )
	{
		if( TargetLocation != vect(0,0,0) )
			CoverActor = AI.ChooseCoverPoint(distance,,TargetLocation);			
		else
		{
			CoverActor = AI.ChooseCoverPoint(distance);

			if (( CoverActor != none ) && AI.bPlayerSeen)
			{
				//do a basic test to avoid the NPC face back the player
				dotproduct = Normal(CoverActor.Location - Characters[1].pawn.Location) dot Normal(Characters[0].pawn.Location - Characters[1].pawn.Location);

				if(dotproduct < -0.6f)
					CoverActor=None; 
				
			}

		}
		
		if ( CoverActor != none )
		{
			
			CoverLocation = CoverActor.Location;
			GotoPatternLabel(Label);
		}
	}
}


//---------------------------------------[David Kalina - 15 Oct 2001]-----
// 
// Description
//		Check EAIController variable to see if the corresponding
//		controller has spotted the player once before.
//
//		If so, jump to specified label.
//
//------------------------------------------------------------------------
function CheckPlayerSeenOnce(int _CharIndex, name Label)
{
	// is this the same frame as when we first saw the player?
	if( (EAIController(Characters[_CharIndex]).TimePlayerFirstSeen != 0) &&
	    (EAIController(Characters[_CharIndex]).TimePlayerFirstSeen < Level.TimeSeconds ) )
	{
		GotoPatternLabel(Label);
	}
}


//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function CheckIfPlayerHasBeenSeenByGroup(name Label)
{
	if(EGroupAI(Owner) != None)
	{
		if(EGroupAI(Owner).PlayerHasBeenSeen())
		{
			GotoPatternLabel(Label);
		}
	}
}

//---------------------------------------------------[Frederic Blais]-----
// 
// CheckIfLastTimeSeenExpired
// 
// Description: Check since how much time we did'nt see the player
//
//------------------------------------------------------------------------
function CheckIfLastTimeSeenExpired(int _CharIndex, float DeltaTime, name Label)
{
	local EAIController AI;

	AI = EAIController(Characters[_CharIndex]);

	if(AI.epawn.ExpiredTime > 0)
	{
		if( (Level.TimeSeconds - AI.LastKnownPlayerTime) > AI.epawn.ExpiredTime )
		{
			GotoPatternLabel(Label);
		}
	}
}


//---------------------------------------------------[Frederic Blais]-----
// 
// SetPostAttackBehavior
// 
// Description: 
//
//------------------------------------------------------------------------
function SetPostAttackBehavior(int _CharIndex)
{
	local EAIController AI;


	AI = EAIController(Characters[_CharIndex]);


	if( (AI != None) && (AI.epawn.PostAttackPointTag != '') )
	{
		plog("SetPostAttackBehavior : "$AI.epawn.PostAttackPointTag);

		//change the default behavior
		Goal_Default(1,AI.epawn.PostAttackGoalType,0,,AI.epawn.PostAttackFocusTag,,AI.epawn.PostAttackPointTag,AI.ePawn.PostAttackAnim,,,,,);
	}
	
}

//------------------------------------------------------------------------
// 
// Description
//------------------------------------------------------------------------
function Name GetPostAttackPoint(int _CharIndex)
{
	local EAIController AI;

	AI = EAIController(Characters[_CharIndex]);

	return AI.epawn.PostAttackPointTag;
}


//----------------------------------------[David Kalina - 3 May 2002]-----
// 
// Description
//		Set a MoveTo for the input character in a proper hiding location.
//		Generally intended for non-hostile behavior (bureaucrat pattern).
//
// Input
//		_CharIndex : 
//		Priority : 
//		HideMoveFlags : 
//
//------------------------------------------------------------------------

function SetHidePointMoveTo(int _CharIndex, int Priority, MoveFlags HideMoveFlags)
{
	local EGoal goal;	
	local name HideTag;
	local NavigationPoint HidePoint;
	local EAIController AI;

	HideTag = GetPostAttackPoint(_CharIndex);

	AI = EAIController(Characters[_CharIndex]);
	if ( AI != none )
	{			
		if ( HideTag != '' )
        {
			HidePoint = NavigationPoint(GetMatchingActor(HideTag));		// if hide point pre-specified, use it
        
            if (!(AI.IsTimedOut(HidePoint)))
            {
                AI.TimeoutHidePoint(HidePoint);
            }
            else
            {
                HidePoint = AI.ChooseHidePoint();
            }
        }
		else 
        {
			HidePoint = AI.ChooseHidePoint();							// otherwise, get a HidePoint from the AI.
        }


		if ( HidePoint != none )
		{
			plog("Choosing Hide Point -- " $ HidePoint);

			// add MoveTo goal directly -- do this because we want to set the GoalSubject explicitly as it will be used in pathfinding as the EndAnchor
			goal = Spawn(class'EGoal');  

			goal.Clear();										

			goal.m_GoalType		= GOAL_MoveTo;					
			goal.priority		= Priority;					

			goal.GoalSubject	= HidePoint;
			goal.GoalLocation	= HidePoint.Location;		
			goal.GoalMoveFlags  = HideMoveFlags;			
			goal.GoalWaitFlags  = HideMoveFlags;
            goal.GoalFlagB      = true;             // Fail if Sam is in the way

            goal.GoalUpdatePlayerPos = true;        // Fail on stuck

			AI.AddGoalDirect(goal);
		}
		else
        {
			plog("Unable to choose a hide point. Will hide right here");	
            
            goal = Spawn(class'EGoal');  
            
			goal.Clear();										

			goal.m_GoalType		= GOAL_MoveTo;					
			goal.priority		= Priority;					

			goal.GoalSubject	= AI.EPawn;
			goal.GoalLocation	= AI.EPawn.Location;		
			goal.GoalMoveFlags  = HideMoveFlags;			
			goal.GoalWaitFlags  = HideMoveFlags;

            goal.GoalUpdatePlayerPos = true;        // Fail on stuck

			AI.AddGoalDirect(goal);
        }
	}
}


//--------------------------------------------------[Frederic Blais]-----
// 
// CheckIsAlive
// 
// Description: Check if the specific member is alive. If not, jump to specific
//				label.
//
//------------------------------------------------------------------------
function CheckIsAlive(int i, name JumpLabel)
{
	if(EAIController(Characters[i]).pawn.health <= 0)
		GotoPatternLabel(JumpLabel);

}

//---------------------------------------[Frederic Blais]-----
// 
// DisableMessages
// 
// Description: Prevent the event callback to process AIEvent messages.
//
//------------------------------------------------------------------------
function DisableMessages(bool bDisableAIEvents, optional bool bDisableTriggers)
{
	bDisableMessages = bDisableAIEvents;
    bDisableEventTrigger = bDisableTriggers;
}

//---------------------------------------[Frederic Blais]-----
// 
// SetFlags
// 
// Description: Set a variable value.
//
//------------------------------------------------------------------------
function SetFlags(out int Variable, bool bIsTrue)
{
	Variable = int(bIsTrue);
}


//---------------------------------------[Frederic Blais]-----
// 
// CheckFlags
// 
// Description: Check variable value.  If it matches then jump to a 
//              specific label.
//
//------------------------------------------------------------------------
function CheckFlags(int Variable, bool bCheck, name JumpLabel)
{
	if(Variable == int(bCheck))
	{
		GotoPatternLabel(JumpLabel);
	}
}


//-----------------------------------------------[Frederic Blais]-----
// 
// Jump
// 
// Description: Jump to a specific label in the pattern.
//
//----------------------------------------------------------------------
function Jump( name JumpLabel)
{
	GotoPatternLabel(JumpLabel);
}


//--------------------------------------------------[Frederic Blais]-----
// 
// EventJump
// 
// Description: Called from the eventcallback. Jump to a specific label
//				in the pattern AND force that label to be executed immediatly.
//
//------------------------------------------------------------------------
function EventJump(name JumpLabel)
{
	//if the pattern was not running is now running
	if(!bIsRunning)
	{
		InitPattern();
		bIsRunning=true;
	}

		GotoPatternLabel(JumpLabel);
		ProcessAI();
}

//--------------------------------------------------[Frederic Blais]-----
// 
// GotoPatternState
// 
// Description: Forced immediat change state
//
//------------------------------------------------------------------------
function GotoPatternState(name State, optional name JumpLabel)
{
	GotoState(State,JumpLabel);
	ProcessAI();
}

//--------------------------------------------------[Frederic Blais]-----
// 
// JumpRandom
// 
// Description: Jump to a random label
//
//------------------------------------------------------------------------
function JumpRandom(name JumpLabel1, float Limit1,
					optional name JumpLabel2, optional float Limit2,
					optional name JumpLabel3, optional float Limit3,
					optional name JumpLabel4, optional float Limit4,
					optional name JumpLabel5, optional float Limit5 )
{
	local float Nb;

	//pick up a number between 0-1
	Nb = FRand();

	if( (Limit1 != 0) && (Nb < Limit1) )
	{
		GotoPatternLabel(JumpLabel1);
		return;
	}

	if( (Limit2 != 0) && (Nb < Limit2) )
	{
		GotoPatternLabel(JumpLabel2);
		return;
	}

	if( (Limit3 != 0) && (Nb < Limit3) )
	{
		GotoPatternLabel(JumpLabel3);
		return;
	}

	if( (Limit4 != 0) && (Nb < Limit4) )
	{
		GotoPatternLabel(JumpLabel4);
		return;
	}

	if( (Limit5 != 0) && (Nb <= Limit5) )
	{
		GotoPatternLabel(JumpLabel5);
		return;
	}

	log("WARNING: JumpRandom failed in pattern: "$self,,LPATTERN);
}



//---------------------------------------------------[Frederic Blais]-----
// 
// AddGoal
// 
// Description: Add a player goal.
//
//------------------------------------------------------------------------
function AddGoal(name ID,
				 string Text,
				 optional int iGoalPriority,
				 optional string SubText,
				 optional string TextSection,
				 optional string TextKey,
				 optional string TextPackage,
				 optional string ShortSection,
				 optional string ShortKey,
				 optional string ShortPackage)
{
	if(EPlayerController(Characters[0]) != None)
	{
		EPlayerController(Characters[0]).AddGoal(ID, Text, TextSection, TextKey, TextPackage, iGoalPriority, SubText, ShortSection, ShortKey, ShortPackage);
	}

}

//--------------------------------------------------[Frederic Blais]-----
// 
// GoalCompleted
// 
// Description: Set an existing player goal as completed.
//
//------------------------------------------------------------------------
function GoalCompleted(name ID)
{
	if(EPlayerController(Characters[0]) != None)
	{
		EPlayerController(Characters[0]).SetGoalStatus(ID, true);
	}
}

//-----------------------------------------------[Francois Schelling]-----
// 
// RemovePlayerGoalsAndNotes
// 
// Description: 
//
//------------------------------------------------------------------------
function RemovePlayerGoalsAndNotes(bool bClearGoals, name goalID, bool bClearNotes)
{
    local EListNode Node;
	local ENote		Note;

	if(EPlayerController(Characters[0]) == None)
        return;

    if(bClearGoals)
    {
        EPlayerController(Characters[0]).GoalList.Clear();
    }
    else if(goalID != '')
    {
        Node = EPlayerController(Characters[0]).GoalList.FirstNode;

        while(Node != None)
        {
	        Note = ENote(Node.Data);
	        if(Note != None && Note.ID == goalID)
	        {
		        EPlayerController(Characters[0]).GoalList.Remove(Note);
		        break;
	        }
	        Node = Node.NextNode;
        }
    }

    if(bClearNotes)
    {
        EPlayerController(Characters[0]).NoteBook.Clear();
    }
}

//--------------------------------------------------[Frederic Blais]-----
// 
// AddNote
// 
// Description: Add player Note.
//
//------------------------------------------------------------------------
// string Text is only kept for backward compatibility
function AddNote(string Text, optional string Section, optional string Key, optional string Package)
{
	if(EPlayerController(Characters[0]) != None)
		EPlayerController(Characters[0]).AddNote(Text, Section, Key, Package, false);
}

//-----------------------------------------------[Francois Schelling]-----
// 
// AddTrainingData
// 
// Description: Add player Training Data.
//
//------------------------------------------------------------------------
function AddTrainingData(string Text, int gpMask, optional bool bHideController)
{
    local array<EchelonEnums.eKEY_BIND> Keys;
    local int i;
	local EPlayerController Epc;

	Epc = EPlayerController(Characters[0]);
	if( Epc == None)
		return;

	if((gpMask & KEY_MOVE_UP_MASK) == KEY_MOVE_UP_MASK)
        Keys[i++] = KEY_MOVE_UP;

    if((gpMask & KEY_MOVE_DOWN_MASK) == KEY_MOVE_DOWN_MASK)
        Keys[i++] = KEY_MOVE_DOWN;

    if((gpMask & KEY_MOVE_LEFT_MASK) == KEY_MOVE_LEFT_MASK)
        Keys[i++] = KEY_MOVE_LEFT;

    if((gpMask & KEY_MOVE_RIGHT_MASK) == KEY_MOVE_RIGHT_MASK)
        Keys[i++] = KEY_MOVE_RIGHT;

    if((gpMask & KEY_LOOK_UP_MASK) == KEY_LOOK_UP_MASK)
        Keys[i++] = KEY_LOOK_UP;

    if((gpMask & KEY_LOOK_DOWN_MASK) == KEY_LOOK_DOWN_MASK)
        Keys[i++] = KEY_LOOK_DOWN;

    if((gpMask & KEY_LOOK_LEFT_MASK) == KEY_LOOK_LEFT_MASK)
        Keys[i++] = KEY_LOOK_LEFT;

    if((gpMask & KEY_LOOK_RIGHT_MASK) == KEY_LOOK_RIGHT_MASK)
        Keys[i++] = KEY_LOOK_RIGHT;
    
    if((gpMask & KEY_INTERACTION_MASK) == KEY_INTERACTION_MASK)
        Keys[i++] = KEY_INTERACTION;

    if((gpMask & KEY_SCOPE_MASK) == KEY_SCOPE_MASK)
        Keys[i++] = KEY_SCOPE;

    if((gpMask & KEY_JUMP_MASK) == KEY_JUMP_MASK)
        Keys[i++] = KEY_JUMP;

    if((gpMask & KEY_DUCK_MASK) == KEY_DUCK_MASK)
        Keys[i++] = KEY_DUCK;

    if((gpMask & KEY_FIRE_MASK) == KEY_FIRE_MASK)
        Keys[i++] = KEY_FIRE;

    if((gpMask & KEY_ALT_FIRE_MASK) == KEY_ALT_FIRE_MASK)
        Keys[i++] = KEY_ALT_FIRE;

    if((gpMask & KEY_CHANGE_ROF_MASK) == KEY_CHANGE_ROF_MASK)
        Keys[i++] = KEY_CHANGE_ROF;

    if((gpMask & KEY_QUICK_MASK) == KEY_QUICK_MASK)
        Keys[i++] = KEY_QUICK;

    if((gpMask & KEY_MENU_MASK) == KEY_MENU_MASK)
        Keys[i++] = KEY_MENU;

    if((gpMask & KEY_RESETCAMERA_MASK) == KEY_RESETCAMERA_MASK)
        Keys[i++] = KEY_RESETCAMERA;

	Epc.AddTrainingData(self, Text, Keys, bHideController);
}


//-----------------------------------------------[Francois Schelling]-----
// 
// PlayerMove
// 
// Description: Stop player mouvement.
//
//------------------------------------------------------------------------
function PlayerMove(BOOL bPlayerMove)
{
	Characters[0].FlushMouseMoveMessages();
	EPlayerController(Characters[0]).bStopInput = !bPlayerMove;
}

/*-----------------------------------------------------------------------------
 Function:      InventoryManager

 Description:   Add or Remove Item to pattern member inventory
-----------------------------------------------------------------------------*/
function InventoryManager(int index, bool bAdd, Name Tag, int Qty, optional bool bByClassName, optional class<EInventoryItem> AddRemoveClass, optional bool bBullets)
{
    local Actor             TagActor;
    local EPlayerController EPC;
    local EInventoryItem	Item;
    local int               i;

    if(index == 0)
    {
        EPC = EPlayerController(Characters[0]);
        TagActor = GetMatchingActor(Tag);
        if(TagActor != None)
    	    Item = EInventoryItem(TagActor);

        // Verify if we can add the item
        if (EPC == None)
        {
            log("EPC == None");
            return;
        }


        if(bAdd)
        {

            if(bBullets)
            {
                if (EPC.MainGun != None)
                {
                    EPC.MainGun.Ammo = Min(EPC.MainGun.Ammo + Qty, EPC.MainGun.MaxAmmo);
                }
                else if (EPC.HandGun != None)
                {
                    EPC.HandGun.Ammo = Min(EPC.HandGun.Ammo + Qty, EPC.HandGun.MaxAmmo);
                }
            }
            else if (bByClassName)
            {
                //log("InventoryManager - Adding - By Class Name " $ Qty $ " x " $ AddRemoveClass);

                while (Qty > 0)
                {
                    Item = Spawn(AddRemoveClass, EPC);
                    
                    if (Item != None)
                    {
                        if(EPawn(EPC.Pawn).FullInventory.CanAddItem(Item))
                        {
                            Item.Add(EPC, EPC, EPawn(EPC.Pawn).FullInventory);

							if ( EWeapon(Item) != None )
							{
								EWeapon(Item).BulletSound = EchelonLevelInfo(Level).AmbientPlaySound;
							}
                        }
                        else
                        {
                            //log("too many of those already. will be destroyed" $ Item);
                            Item.Destroy();
                            break;
                        }
                    } 

                    Qty--;
                }
            }
            else // NOT bByClassName
            {
                //log("InventoryManager - Adding - By Instance " $ Item);

                if (Item != None)
                {
                    Item.Add(EPC, EPC, EPawn(EPC.Pawn).FullInventory);
                }            
            }


        }
        else // Remove
        {
            if(bBullets)
            {
                if (EPC.MainGun != None)
                {
                    EPC.MainGun.Ammo = Max(EPC.MainGun.Ammo - Qty, 0);
                    EPC.MainGun.ClipAmmo = Min(EPC.MainGun.Ammo, EPC.MainGun.ClipAmmo);
                }
                else if (EPC.HandGun != None)
                {
                    EPC.HandGun.Ammo = Max(EPC.HandGun.Ammo - Qty, 0);
                    EPC.HandGun.ClipAmmo = Min(EPC.HandGun.Ammo, EPC.HandGun.ClipAmmo);                
                }
            }
            else if (bByClassName)
            {       
                //log("InventoryManager - Remove - By Class Name " $ Qty $ " x " $ AddRemoveClass);
            
                Item = EPawn(EPC.Pawn).FullInventory.GetItemByClass(AddRemoveClass.Name);

                if (Item == None)
                {
                    //log("no item found for that class");
                    return;
                }

                if(Qty > 0) // Remove quantity Qty
                {
                    while (((EPawn(EPC.Pawn).FullInventory.GetItemByClass(AddRemoveClass.Name) != None)) && (Qty > 0))
                    {
                        Item = EPawn(EPC.Pawn).FullInventory.GetItemByClass(AddRemoveClass.Name);

                        EPawn(EPC.Pawn).FullInventory.RemoveItem(Item, 1, false);
                        Item.Destroy();

                        Qty--;
                    }
                }
                else        // Remove all
                {
                    while (EPawn(EPC.Pawn).FullInventory.GetItemByClass(AddRemoveClass.Name) != None)
                    {
                        Item = EPawn(EPC.Pawn).FullInventory.GetItemByClass(AddRemoveClass.Name);

                        EPawn(EPC.Pawn).FullInventory.RemoveItem(Item, 1, false);
                        Item.Destroy();
                    }
                }
            }
            else // NOT bByClassName
            {
                //log("InventoryManager - Removing - By Instance " $ Item);

                EPawn(EPC.Pawn).FullInventory.RemoveItem(Item, 1, false);
                Item.Destroy();
            }
        }
    }
}

//---------------------------------------------------[Frederic Blais]-----
// 
// ReloadWeapon
// 
// Description: 
//
//------------------------------------------------------------------------
function ReloadWeapon(int _index, float ratio)
{
	local EWeapon currentWeapon;
	local EAIController	AI;

	AI = EAIController(Characters[_index]);

	if(AI != None && AI.GetStateName() != 's_Unconscious' && AI.ePawn.Health > 0)
	{
		currentWeapon = EWeapon(AI.ePawn.HandItem);

		if(currentWeapon != None)
		{
			if( ( currentWeapon.ClipAmmo / currentWeapon.ClipMaxAmmo ) < ratio )
			{
				currentWeapon.Reload();
				currentWeapon.ClipAmmo = currentWeapon.ClipMaxAmmo;
			}
		}
	}
}

//---------------------------------------------------[Frederic Blais]-----
// 
//
//------------------------------------------------------------------------
function ResolveBlocked(int _index, name JumpLabel)
{
	local EAIController	AI;
	local vector HitLocation, HitNormal;

	AI = EAIController(Characters[_index]);
	
	//left
	if( AI.ePawn.Trace(HitLocation,HitNormal,Characters[0].pawn.Location,AI.ePawn.ToWorld(vect(0,-60,0)),true)  == Characters[0].pawn)
	{
		if( AI.ePawn.FastPointCheck(AI.ePawn.ToWorld(vect(0,-60,0)), AI.ePawn.GetExtent(), true, true) )
		{
			EAIController(Characters[1]).TargetLocation=AI.ePawn.ToWorld(vect(0,-60,0));
			GotoPatternLabel(JumpLabel);
			return;
		}
	}

	if( AI.ePawn.Trace(HitLocation,HitNormal,Characters[0].pawn.Location,AI.ePawn.ToWorld(vect(0,60,0)),true) == Characters[0].pawn)
	{
		//right
		if( AI.ePawn.FastPointCheck(AI.ePawn.ToWorld(vect(0,60,0)), AI.ePawn.GetExtent(), true, true) )
		{
			EAIController(Characters[1]).TargetLocation=AI.ePawn.ToWorld(vect(0,60,0));
			GotoPatternLabel(JumpLabel);
			return;
		}
	}
}

//--------------------------------------------------[Frederic Blais]-----
// 
// Close
// 
// Description:  Close the speech set.
//
//------------------------------------------------------------------------
function Close( optional bool bInterrupted )
{
	if ( CommBox.CurrentOwner == self )
		CommBox.UnLock();
	
	// Close conversation segment
	bConversationRunning = false;

	// Notify Npc interaction conversation segment is over
	if( !bInterrupted && ENpcZoneInteraction(Owner) != None )
		ENpcZoneInteraction(Owner).PostInteract(Characters[0]);
}

//------------------------------------------------[Frederic Blais]-----
// 
// Console
// 
// Description:  Add console transmission to the communication box
//
//------------------------------------------------------------------------
function Console(String Text, byte Event)
{
	if(CommBox!= None)
		CommBox.AddTransmission( self, TR_CONSOLE, Text,None,Event);
}

//------------------------------------------------------------------------
// Description		
//		Completely ends a conversation. To place at the end of every conversation
//------------------------------------------------------------------------
function EndConversation()
{
	if( ENpcZoneInteraction(Owner) == None )
		Log(self$" ERROR : EndConversation() called on a non-conversation pattern.");
	else
		ENpcZoneInteraction(Owner).EndEvent();
}

//---------------------------------------[Frederic Blais]-----
// 
// End
// 
// Description: End the processing of the pattern. Go to state Idle.
//
//------------------------------------------------------------------------
function End()
{
	// ERROR check
	if( ENpcZoneInteraction(Owner) != None && bConversationRunning )
	{
		Log(self$" ERROR : Conversation Pattern End() called wihout a Close()");
		Close();
	}

	GotoState('Idle');
	bIsRunning = false;
}

//---------------------------------------[Frederic Blais]-----
// 
// StepForward
// 
// Description: Used in the conversation interaction to step 
//              forward in the conversation.
//
//------------------------------------------------------------------------
function StepForward()
{
	StopSpeech();
	StopSleep();
}


//-----------------------------------------------[Frederic Blais]-----
// 
// GameOver
// 
// Description:  Send a game over event at the player Controller.
//---------------------------------------------------------------------
function GameOver(optional bool bMissionComplete, optional int iFailureType)
{
	EPlayerController(Characters[0]).EndMission(bMissionComplete, iFailureType);
}


//-----------------------------[Matthew Clarke - August 20th 2002]-----
// 
// ShakeCamera
//
//---------------------------------------------------------------------
function ShakeCamera(int iShakeValue1, int iShakeValue2, int iShakeValue3)
{
    EPlayerController(Characters[0]).m_camera.Shake(iShakeValue1,   // Strength
                                                    iShakeValue2,   // Speed
                                                    iShakeValue3);  // Fade Out
}

//-------------------------------------------------[Frederic Blais]-----
// 
// ResetGroup
// 
// Description: Reset the goals and the states of group.
//
//------------------------------------------------------------------------
function ResetGroup()
{
	if(EGroupAI(Owner) != None)
	{
		EGroupAI(Owner).ResetGoals();
		EGroupAI(Owner).ChangeStates('s_default');
	}
}

//--------------------------------[Matthew Clarke - August 26th 2002]-----
// 
// ResetAllNPCs
// 
// Description: Resets All NPCs, used when Sam dies
//
//------------------------------------------------------------------------
function ResetAllNPCs(int iCharIndex)
{
    local Controller C;
    local EAIController AI;

    // Circle through all Controllers
    for (C = Level.ControllerList; C != None; C = C.nextController)  
    {
        AI = EAIController(C);

        if((AI != None) && (AI.EPawn != None) && (!AI.EPawn.bDisableAI))  
        {
            //log("resetting"@AI.EPawn);
            // Reset Goals for this guy/gal
            AI.LastGoalType = GOAL_TEMP_2;
            AI.LastGoalStatus = -1;
            AI.m_pGoalList.Reset();
            AI.LockedSwitches.Remove(0, AI.LockedSwitches.Length);

            // Reset his/her default pattern
            if ( (AI.Pawn != None) 
              && (AI.Pawn.Health > 0)  
              && (AI != Characters[iCharIndex]))    // Do not reset our on pattern yet, we will do do that later)
            {
                //log("resetting"@AI.EPawn@"'s pattern");
			    AI.Pattern.GotoState('idle');
            }

            // Setup post attack if available
            if( (AI != None) && (AI.epawn.PostAttackPointTag != '') )
	        {
                //log("setting post attack for"@AI.EPawn);
		        AI.Pattern.Goal_Default(iCharIndex, 
                             AI.epawn.PostAttackGoalType,
                             0,,AI.epawn.PostAttackFocusTag,,
                             AI.epawn.PostAttackPointTag,
                             AI.ePawn.PostAttackAnim,,,,,);
	        }

        }
    }
}


/*-----------------------------------------------------------------------------
 Function:

 Description: 
-----------------------------------------------------------------------------*/
function ResetDefaultPatterns()
{
	if(EGroupAI(Owner) != None)
		EGroupAI(Owner).ResetDefaultPatternStates();
}

//---------------------------------------------------[Frederic Blais]-----
// 
// ResetGroupGoals
// 
// Description: Reset the goals for all members of the group
//
//------------------------------------------------------------------------
function ResetGroupGoals()
{
	if(EGroupAI(Owner) != None)
		EGroupAI(Owner).ResetGoals();
}


//--------------------------------------------------[Frederic Blais]-----
// 
// PlayerIsVisible
// 
// Description: If the player is not visible jump to a specific label.
//------------------------------------------------------------------------
function PlayerIsVisible(int CharacterIndex, name JumpLabel)
{
	if(!EAIController(Characters[CharacterIndex]).bPlayerSeen)
		GotoPatternLabel(JumpLabel);
}


//---------------------------------------------------[Frederic Blais]-----
// 
// AllGroupLostPlayer
// 
// Description: Check if all the group lost the player. If yes jump to
//              a the given JumpLabel. 
//
//------------------------------------------------------------------------
function AllGroupLostPlayer(name JumpLabel, optional actor triggerActor, optional name Label)
{
	local EListNode Node;
	local int i;

	if(EGroupAI(Owner) != None)
	{
		i=0;
		Node = EGroupAI(Owner).AIMembers.FirstNode;

		while(Node != None)
		{
			if( (EAIController(Node.Data).bPlayerSeen) && (TriggerActor != Actor(Node.Data)) )
			{
				i++;
			}

			Node = Node.NextNode;
		}

		if(i == 0)
		{
			if(triggerActor != None)
				TriggerCharacter  = EAIController(triggerActor);

			GotoPatternLabel(JumpLabel);
		}
		else
		{
			if(Label != '')
				GotoPatternLabel(Label);
		}
	}
}


//-------------------------------------------------[Frederic Blais]-----
// 
// Radio
// 
//------------------------------------------------------------------------
function Radio()
{
	local EPawn MyEpawn;

	MyEpawn = ePawn(Characters[1].Pawn);
	
	Goal(1,GOAL_Action, 32,,,characters[0].pawn,, MyEpawn.ARadioBegin,,,,MOVE_WalkNormal);
	Goal(1,GOAL_Action, 31,,,characters[0].pawn,, MyEpawn.ARadio,EPawn(Characters[1].pawn).Sounds_Barks,,,MOVE_WalkNormal);
	Goal(1,GOAL_Action, 30,,,characters[0].pawn,, MyEpawn.ARadioEnd,,,,MOVE_WalkNormal);
}

//-------------------------------------------------[Frederic Blais]-----
// 
// SetPlayerDeadAction
// 
// Description: Eventually we will set different player dead reactions
//
//------------------------------------------------------------------------
function SetPlayerDeadAction(int	_Index)
{
	local  vector Tmp,Tmp2;
	local EPawn MyEpawn;

	MyEpawn = ePawn(Characters[_Index].Pawn);

	Tmp = Characters[0].pawn.Location + Vector(MyEpawn.Rotation) * 90;
	Tmp2= Tmp + Normal(Characters[_Index].pawn.Location - Tmp) * 150;
	//Tmp2= Tmp + ( Normal(Vect(0,0,-1) cross Vector(EPawn(Characters[0].pawn).Rotation)) * 15 );

	//ePawn(Characters[_Index].Pawn).Bark_Type = BARK_PlayerKilled;
    //Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Goal(_Index,GOAL_MoveTo, 33,Tmp2,Tmp,,,,,,,MOVE_WalkNormal);
	//Goal(_Index,GOAL_Action, 32,Tmp2,Tmp,,, MyEpawn.ARadioBegin,,,,MOVE_WalkNormal);
	Goal(_Index,GOAL_Action, 31,Tmp2,Tmp,,, MyEpawn.ARadio, /*MyEpawn.Sounds_Barks*/,,,MOVE_WalkNormal);
	//Goal(_Index,GOAL_Action, 30,Tmp2,Tmp,,, MyEpawn.ARadioEnd,,,,MOVE_WalkNormal);
}

//-------------------------------------------------[Frederic Blais]-----
// 
// ResetGoals
// 
// Description: Reset the goals for a specific member of the pattern.
//------------------------------------------------------------------------
function ResetGoals(int	_CharacterIndex)
{
	EAIController(Characters[_CharacterIndex]).LastGoalType = GOAL_TEMP_2;
	EAIController(Characters[_CharacterIndex]).LastGoalStatus = -1;
	EAIController(Characters[_CharacterIndex]).m_pGoalList.Reset();
	//EAIController(Characters[_CharacterIndex]).m_pGoalList.ResetBasics();

    EAIController(Characters[_CharacterIndex]).LockedSwitches.Remove(0, EAIController(Characters[_CharacterIndex]).LockedSwitches.Length);
}



////////// ZONE AND SECTOR REALATED STUFF ////////////////////////////////////////////////


//---------------------------------------------------[Frederic Blais]-----
// 
// ResetSector
// 
// Description: Reset the last zone used in the groupAI.
//
//------------------------------------------------------------------------
function ResetSector()
{
	if(EGroupAI(Owner) != None)
		EGroupAI(Owner).LastZoneUsed=None;
}


//--------------------------------------------------[Frederic Blais]-----
// 
// PlayerIsInASector
// 
// Description: check if the player is in a EZoneInfo
//
//------------------------------------------------------------------------
function PlayerIsInASector(name JumpLabel, optional bool bCheckPlayer)
{
	if( EZoneInfo(Characters[0].pawn.region.zone) != none )
		GotoPatternLabel(JumpLabel);
}


//--------------------------------------------------[Frederic Blais]-----
// 
// PlayerIsInASector
// 
// Description: check if the player is in a EZoneInfo
//
//------------------------------------------------------------------------
function CheckIfCanThrowGrenade(name JumpLabel)
{

	if(CurrentVolume != None)
	{
		if(EGroupAI(Owner) != None)
		{

			if(EGroupAI(Owner).CurrentGrenadeTimer <= 0)
			{

				if(CurrentVolume.bGrenadeAllowed)
				{

					if(GrenadeLocation != Vect(0,0,0))
					{

						EGroupAI(Owner).ResetGrenadeTimer();
						GotoPatternLabel(JumpLabel);
					}
				}
			}		
		}
	}
}


//-----------------------------------------------------[Frederic Blais]-----
// 
// PlayerIsInAZone
//
// Description:  Check if the player is in a special Zone. 
//----------------------------------------------------------------------------
function PlayerIsInAZone(name JumpLabel, optional bool bCheckPlayer)
{
	local EPlayerController P;

	P = EPlayerController(Characters[0]);
	if( P.CurrentVolume != none)
	{
		if(bCheckPlayer)
		{
			//check the player acceleration
			if( (P.aForward > P.eGame.m_forwardGentle) || (P.aForward < P.eGame.m_backwardGentle) ||
				(P.aStrafe  > P.eGame.m_rightGentle)   || (P.aStrafe < P.eGame.m_leftGentle) )
			{
				return;
			}

		}

		GotoPatternLabel(JumpLabel);
	}

}

//---------------------------------------[Frederic Blais]-----
// 
// PlayZoneLocation
// 
// Description:  Play zone location.
//------------------------------------------------------------------------
function PlayZoneLocation(int _CharacterIndex)
{
	if( EAIController(Characters[_CharacterIndex]) != None)
	{
		//EAIController(Characters[_CharacterIndex]).EPawn.playsound(Sound'ZONE_1', SLOT_SFX);

	}
	//reset the zone
	EPlayerController(Characters[0]).CurrentVolume = none;

}

//---------------------------------------[Frederic Blais]-----
// 
// PlayZoneLocation
// 
// Description:  Play zone location.
//------------------------------------------------------------------------
function CheckIfCornerPeeking(int _CharacterIndex,name JumpLabel)
{
	if( EAIController(Characters[_CharacterIndex]) != None)
	{
		if(EAIController(Characters[_CharacterIndex]).EPawn.bCoverPeeking)
		{
			GotoPatternLabel(JumpLabel);
		}

	}

}



//-------------------------------------------------[Frederic Blais]-----
// 
// CheckLightSwitchProximity
// 
//
//------------------------------------------------------------------------
function CheckLightSwitchProximity(int _CharacterIndex, name JumpLabel, optional float MaxDist)
{
	local EGamePlayObject GObject, BestSwitch;	
	local float BestDistance;
	local bool SwitchFound;

	if(MaxDist == 0)
		MaxDist=1000.0f;


	foreach RadiusActors ( class'EGamePlayObject', GObject, MaxDist, Characters[_CharacterIndex].pawn.Location ) 
	{
		if( GObject.IsA('ELightSwitch') )
		{

			if( GObject.GetStateName() != 's_On')
			{

				if(!SwitchFound)
				{
					if(Characters[_CharacterIndex].pawn.Region.ZoneNumber == GObject.Region.ZoneNumber)
					{
						BestDistance = VSize(GObject.Location - Characters[_CharacterIndex].pawn.Location);
						BestSwitch=GObject;

						SwitchFound=true;

					}
				}
				else
				{

					if(Characters[_CharacterIndex].pawn.Region.ZoneNumber == GObject.Region.ZoneNumber)
					{
						if(BestDistance > VSize(GObject.Location - Characters[_CharacterIndex].pawn.Location))
						{
							BestDistance = VSize(GObject.Location - Characters[_CharacterIndex].pawn.Location);
							BestSwitch=GObject;
						}
					}

				}

			}
		}
	}


	if(SwitchFound)
	{
		TriggerEvent.EventTarget = BestSwitch;
		GotoPatternLabel(JumpLabel);
	}
}

//-------------------------------------------------[Matthew Clarke]-------
// 
// CheckLightSwitchVolumeAndAdd
//  Check for a light switch associated with the volume where the 
//  event just happened 
//
//------------------------------------------------------------------------
function CheckLightSwitchVolumeAndAdd(int _CharacterIndex, Vector _Location)
{
    local EVolume itVol;

    foreach DynamicActors(class'EVolume', itVol)
    {
        if((itVol.EncompLoc(_Location)) && (itVol.LightSwitch != None))
        {
            //plog(itVol $ " Encompasses the Event");

        	if(((itVol.LightSwitch.IsA('ELightSwitch') 
                   || (itVol.LightSwitch.IsA('ELightSwitchKal')))) 
             && (itVol.LightSwitch.GetStateName() != 's_On'))
	        {
                //plog(itVol $ " is chosen");
                CheckSwitchAlreadyLocked(1, itVol.LightSwitch);
                return;
	        }
        }
    }
}

//-------------------------------------------------[Frederic Blais]-----
// 
// GetNearestNavPoint
//
//------------------------------------------------------------------------
function vector GetNearestNavPointLocation()
{
    local NavigationPoint   NavStart;
	local NavigationPoint	tmpNav;
	local float				BestDistance;

	NavStart = EPlayerController(Characters[0]).EPawn.GetAnchorForLocation(Characters[0].Pawn.Location);


	if((NavStart != None) && (Level.TimeSeconds - NavStart.LastTimeUsed < 30))
		NavStart=None;


	if(NavStart != None)
	{
		NavStart.LastTimeUsed = Level.TimeSeconds;
		return NavStart.Location;
	}
	else
	{
		NavStart=None;

		//find the nearest nav point
		foreach RadiusActors ( class'NavigationPoint', tmpNav, 1000, Characters[0].Pawn.Location ) 
		{
			if(NavStart != None)
			{

				if( VSize(Characters[0].pawn.Location - tmpNav.Location) < BestDistance )
				{
					if(Level.TimeSeconds - NavStart.LastTimeUsed > 30)
					{
						NavStart=tmpNav;
						BestDistance = VSize(Characters[0].pawn.Location - tmpNav.Location);
					}
				}

			}
			else
			{
				if(Level.TimeSeconds - tmpNav.LastTimeUsed > 30)
				{
					NavStart=tmpNav;
					BestDistance = VSize(Characters[0].pawn.Location - tmpNav.Location);
				}
			}
		}

		if(NavStart != None)
		{
			NavStart.LastTimeUsed = Level.TimeSeconds;
			return NavStart.Location;
		}
		else
		{
			log("WARNING: No point was found for SEARCH_CHEAT after charging the player: Player location was selected.");
			//return Characters[0].pawn.Location;
			return vect(0,0,0);
		}

	}
}


//-------------------------------------------------[Frederic Blais]-----
// 
// CheckAlarmProximity
// 
// Description: Check if an alarm panel is near. If yes jump to the given label.
// If there are many AlarmPanels, the best one is chosen based on route length to panel
//
//------------------------------------------------------------------------
function CheckAlarmProximity(int _CharacterIndex, name JumpLabel, optional float MaxDist)
{
	local EAlarmPanelObject Panel; 
    local EAlarmPanelObject BestPanel;	
	local vector            OffSet;
    local vector            Pos;
	local float             BestDistance;
	local bool              PanelFound;
	local EAIController     AI;
	local int               TempDist;
    local NavigationPoint   NavStart; 
    local NavigationPoint   NavEnd;
    local EZoneInfo         EZIPanel;
    local EZoneInfo         EZIPlayer;
    
	plog(self@"::CheckAlarmProximity()");

    AI = EAIController(Characters[_CharacterIndex]);

	PanelFound=false;    

	if(MaxDist == 0)
    {
		MaxDist = 1500.0f;
    }

	//check to be sure that we are not already responding to an alarm
	if(EGroupAI(Owner) != None)
	{
		if((EGroupAI(Owner).CurrentAlarm == None) && (!EGroupAI(Owner).bGroupRunningForAlarm))
		{
			if(AI.epawn.ForceAlarmPanelRun != None)
			{
				BestPanel = AI.epawn.ForceAlarmPanelRun;

				//don't want to trigger the same alarm twice
				if(BestPanel.Alarm.bAlreadyTriggered)
					return;

				OffSet = (vect(50,0,0) >> BestPanel.Rotation);
				OffSet.Z = 0;

				Pos = BestPanel.Location;
				Pos.Z = Characters[_CharacterIndex].pawn.Location.Z;

				//set the group to be sure nobody else will try to run for an alarm
				EGroupAI(Owner).bGroupRunningForAlarm=true;

				TriggerEvent.EventLocation = Pos + OffSet ;
				TriggerEvent.EventTarget = BestPanel;
				GotoPatternLabel(JumpLabel);

				return;
			}
		


			foreach RadiusActors ( class'EAlarmPanelObject', Panel, MaxDist, Characters[_CharacterIndex].pawn.Location ) 
			{
				//check if the Z is acceptable
				if( Abs(Panel.Location.Z - Characters[_CharacterIndex].pawn.Location.Z) <  Characters[_CharacterIndex].pawn.CollisionHeight)
				{	
					//check if it's the first panel
					if( !PanelFound && !Panel.Alarm.bAlreadyTriggered )
					{
						NavStart = AI.EPawn.GetAnchor();
						NavEnd = AI.EPawn.GetAnchorForLocation(Panel.Location + (vect(50,0,0) >> Panel.Rotation));

						BestDistance = AI.EPawn.ArePointsConnected(NavStart, NavEnd);  
                    
						plog("BestDistance"@BestDistance);

						if ((BestDistance != 0) || (NavStart == NavEnd))
						{
							BestPanel = Panel;
							PanelFound = true;
						}
					}
					else
					{
						if(!Panel.Alarm.bAlreadyTriggered)
						{
							NavStart = AI.EPawn.GetAnchor();
							NavEnd = AI.EPawn.GetAnchorForLocation(Panel.Location + (vect(50,0,0) >> Panel.Rotation));

							TempDist = AI.EPawn.ArePointsConnected(NavStart, NavEnd); 

							plog("TempDist"@TempDist);

							if((TempDist != 0) || (NavStart == NavEnd))
							{
								if(BestDistance > TempDist)
								{
									BestDistance = TempDist;
									BestPanel=Panel;
								}
							}
						}
					}
				}
			}
            

			if(PanelFound)
			{
                // Ignore Panel if Sam is closer to the panel than we are.

                NavStart = AI.EPawn.GetAnchorForLocation(Characters[0].pawn.Location);
                NavEnd = AI.EPawn.GetAnchorForLocation(BestPanel.Location + (vect(50,0,0) >> BestPanel.Rotation));
                TempDist = AI.EPawn.ArePointsConnected(NavStart, NavEnd);

                if(((BestDistance > TempDist) && (TempDist != 0)) || (NavStart == NavEnd))
                {
                    plog("Ignoring Panel because Sam is closer to the panel than we are");
                    plog("my dist : " $ BestDistance@"sams dist : "$ TempDist);
                    return;
                }      

                EZIPanel = EZoneInfo(BestPanel.region.zone);

                // Check if EZoneInfo doesn't want us to go for alarm if player and I are in same zone.
                if((EZIPanel != None) && !EZIPanel.bUseAlarmIfPlayerIsInZone)
                {
                    if(EZIPanel == Characters[0].pawn.region.zone)
                    {
                        return;
                    }
    
                }

				//don't want to trigger the same alarm twice
				if(BestPanel.Alarm.bAlreadyTriggered)
					return;

				OffSet = (vect(50,0,0) >> BestPanel.Rotation);
				OffSet.Z = 0;

				Pos = BestPanel.Location;
				Pos.Z = Characters[_CharacterIndex].pawn.Location.Z;

				//set the group to be sure nobody else will try to run for an alarm
				EGroupAI(Owner).bGroupRunningForAlarm=true;

				TriggerEvent.EventLocation = Pos + OffSet ;
				TriggerEvent.EventTarget = BestPanel;
				GotoPatternLabel(JumpLabel);
			}
		}
	}
}

/*-----------------------------------------------------------------------------
 Function: 

 Description:
-----------------------------------------------------------------------------*/
function SendMasterOutOfRadius(actor MasterPawn, vector SlaveLocation)
{
	local EAIController AI;

	AI = EAIController(EPawn(MasterPawn).controller);

    // One AI_MASTER_OUT_OF_RADIUS to Master every 5 seconds, max
    // It calls EFindPath everytime so it's sorta FPS-taxing
	if((AI != None) && ((Level.TimeSeconds - fLastMasterOutOfRad) > 5.0f))
	{
		plog("SendMasterOutOfRadius - AI_MASTER_OUT_OF_RADIUS send to master");

        fLastMasterOutOfRad = Level.TimeSeconds;

		AI.AIEvent.Reset();
		AI.AIEvent.EventLocation = SlaveLocation;
		AI.AIEvent.EventType = AI_MASTER_OUT_OF_RADIUS;

		AI.group.AIEventCallBack(AI, AI.AIEvent);
	}
}

/*-----------------------------------------------------------------------------
 Function: 

 Description:
-----------------------------------------------------------------------------*/
function BroadcastToMaster()
{
	local EAIController AI;

	if( EAIController(Characters[1]).Master != None)
	{
	AI = EAIController(EAIController(Characters[1]).Master.controller);
	
		if( AI != None && AI.group != None )
	{
		AI.group.Broadcast(EAIController(Characters[1]),BC_BACKUP_RADIO_ATTACK,Characters[0].Pawn.Location,true);
	}
}
}

/*-----------------------------------------------------------------------------
 Function: 

 Description:
-----------------------------------------------------------------------------*/
function CheckIfPeeking(int _CharacterIndex,name JumpLabel)
{
	local EAIController AI;

	AI = EAIController(Characters[_CharacterIndex]);

	if(AI.TakenPoint != None)
	{
		//if( VSize(AI.TakenPoint.Location - AI.EPawn.Location) <=  (AI.EPawn.CollisionRadius*2) )
		if( NavigationPoint(AI.TakenPoint).bCoverPoint)
			GotoPatternLabel(JumpLabel);
	}
}

/*-----------------------------------------------------------------------------
 Function: 

 Description:
-----------------------------------------------------------------------------*/
function CheckTouchingCoverPoints(int _CharacterIndex,name JumpLabel)
{
	local NavigationPoint CoverPoint;
	local EAIController AI;

	AI = EAIController(Characters[_CharacterIndex]);

	ForEach AI.EPawn.TouchingActors(class'NavigationPoint', CoverPoint)
	{
		if((CoverPoint.bCoverPoint) && (AI.TakenPoint != CoverPoint))
		{
			if (CoverPoint.taken)
				continue;

			if( VSize(CoverPoint.Location - AI.EPawn.Location) <  (AI.EPawn.CollisionRadius*2) )
				continue;

			if(AI.EvaluateCorner(CoverPoint,Characters[0].pawn.Location) > CA_OFF)
			{
				AI.LockNavPoint(CoverPoint );
				CoverLocation=CoverPoint.Location;
				GotoPatternLabel(JumpLabel);
				return;
			}

		}
	}
}

/*-----------------------------------------------------------------------------
 Function:      CheckDistanceGreaterThan

 Description:  
-----------------------------------------------------------------------------*/
function CheckDistanceGreaterThan(int iIndex, name JumpLabel, float Distance)
{
	if( VSize(Characters[0].pawn.Location - Characters[iIndex].pawn.Location) > Distance )
		GotoPatternLabel(JumpLabel);
}

/*-----------------------------------------------------------------------------
 Function:      SetFlashLight

 Description:   Pattern event, toggles flashlight on/off
-----------------------------------------------------------------------------*/
function SetFlashLight(int iIndex, bool TurnOn)
{
	local EPawn ePawn;
	ePawn = EPawn(Characters[iIndex].pawn);
	
	if( ePawn == None )
		Log(self$" ERROR: Invalid Pawn in SetFlashLight");
	if( !ePawn.MayUseGunLight )
		Log("WARNING: Pattern Pawn is set to toggle flashLight with MayUseGunLight set to false"@self@ePawn);
	
	ePawn.ToggleHeadLight(TurnOn);
}

/*-----------------------------------------------------------------------------
 Function:      KillNPC

 Description:   Pattern event, sets Health to 0
-----------------------------------------------------------------------------*/
function KillNPC(int iIndex, optional bool bJustKnockOut, optional bool bDontAddToChgActLst)
{
	local EPawn  EP;

    //log("KillNPC"@iIndex@bJustKnockOut@bDontAddToChgActLst);

	EP = EPawn(Characters[iIndex].pawn);
	// Joshua - NPCs killed or knocked with the KillNPC will not affect the Stealth Rating
	EAIController(EP.Controller).bNotInStats = true;

    if (EP != None)
    {
        if(!bJustKnockOut)
        {
            // Kill him
			EP.bKeepNPCAlive=false;
            EP.TakeDamage( 20000, None, Vect(0,0,0), Vect(0,0,0), Vect(0,0,0), None);
        }
        else
        {
            // Just knock out so the dude is unconscious
            EP.bKnockedByPlayer = !bDontAddToChgActLst;
            EP.TakeDamage(EP.health/2, None, EP.Location, Vect(0,0,0), Vect(0,0,0), class'EKnocked', EP.P_Head);        
        }
    }
}


/*-----------------------------------------------------------------------------
 Function:      Teleport

 Description:   Teleports an NPC to a given location
-----------------------------------------------------------------------------*/
function Teleport(int iIndex, Name Tag)
{
    local EAIController EAI;
    local Actor         Target;
	local int			i;

	local vector HitLocation, HitNormal, endTrace;
	

	if(Tag != '')
	{
		Target = GetMatchingActor(Tag);
	}

	if(iIndex > 0)
	{
		//teleport one NPC
		EAI = EAIController(Characters[iIndex]);
        
		if ((Target != None) && (EAI.ePawn != None))
		{
			endTrace = Target.Location;
			endTrace.Z -= 150;

			//be sure the location is OK
			if( EAI.ePawn.Trace(HitLocation, HitNormal, endTrace, Target.Location, false, EAI.ePawn.GetExtent()) != None)
			{
				for(i=0; i<10; i++)
				{
					 EAI.ePawn.VisAverageArray[i] = 50;
				}

				EAI.ePawn.SetLocation(HitLocation);

                if(Target.bDirectional)
                {
                    EAI.ePawn.SetRotation(Target.Rotation);
                }

                EAI.EPawn.Anchor = None;
                EAI.ClearRoutes(); 

				EAI.EPawn.RelevantLights.Remove(0, EAI.EPawn.RelevantLights.Length);
			}
		}
	}
	else
	{
		//teleport the player
		if(Target != None)
		{
			plog("Teleporting the player...");

			Characters[0].pawn.SetLocation(Target.Location);
			Characters[0].pawn.SetRotation(Target.Rotation);
			Characters[0].SetRotation(Target.Rotation);
		}
	}
}


/*-----------------------------------------------------------------------------
 Function:      LevelChange

 Description:   Changes play to a given level
-----------------------------------------------------------------------------*/
function LevelChange(string URL)
{
	//don't travel if SAM is dead
	if(Characters[0].pawn.health > 0)
	{
		ConsoleCommand("TRAVEL MAPNAME="$URL@"ITEMS=TRUE");
		EPlayerController(Characters[0]).playerStats.OnLevelChange(); // Joshua - For mission statistics, saves the mission time from the previous part
	}
}

/*-----------------------------------------------------------------------------
 Function:      AddToInventory

 Description:   Add Item to pattern member inventory

 Comments:      There's no one-stop-shopping function to add an inventory item
                So we'll walk the long run
                Part of this code is ripped from class EPickupInteraction
-----------------------------------------------------------------------------*/
function AddToInventory(Name Tag, name JumpLabel)
{
    local Actor             TagActor;
	local EInventoryItem	Item;
    local EPlayerController EPC;
    local EAIController     AI;            // Used statically for GetMatchingActor

    TagActor = GetMatchingActor(Tag);
    EPC = EPlayerController(Characters[0]);

    if (EPC == None)
    {
        GotoPatternLabel(JumpLabel);
        return;
    }
    
    // Verify if we can add the item
	Item = EInventoryItem(TagActor);

    // Add to inventory
	if(Item != None)
	{
		// If it's a EGameplayObject, just pick it up and leave in hands 
		// else, if it's an inventoryItem and enough space in inventory
		if( ! EPawn(EPC.Pawn).FullInventory.CanAddItem(Item) )
		{
			EPC.SendTransmissionMessage(Localize("Transmission", "NoPickUp", "Localization\\HUD") $ Localize("InventoryItem", Item.ItemName, "Localization\\HUD"), TR_INVENTORY);
			GotoPatternLabel(JumpLabel);
			return;                
		}
    
		// Add to inventory
		Item.Add(EPC, EPC, EPawn(EPC.Pawn).FullInventory);
		EPC.SendTransmissionMessage(Localize("InventoryItem", Item.ItemName, "Localization\\HUD") $ Localize("Transmission", "PickUp", "Localization\\HUD"), TR_INVENTORY);
		
	}
    else
    {
		plog("Item to add from pattern: "$self$" is not an inventory item.");

        // Item is None
        GotoPatternLabel(JumpLabel);
        return; 
    }
}

/*-----------------------------------------------------------------------------
    Function :      ToggleLights

    Description:    Toggle one or more lights using a light switch
-----------------------------------------------------------------------------*/
function ToggleLights(Name oSwitchTag, bool bTurnOn)
{
    local EGameplayObject oSwitch;

    oSwitch = EGameplayObject(GetMatchingActor(oSwitchTag));

    if (oSwitch != None)
    {
        if (bTurnOn)
        {
            oSwitch.GotoState('s_On');
            plog("oSwitch.GotoState('s_On')");
        }
        else
        {
            oSwitch.GotoState('s_Off');
            plog("oSwitch.GotoState('s_Off')");
        }
    }
}

//--------------------------------------------------[Frederic Blais]-----
// 
// ForceUpdatePlayerLocation
// 
//------------------------------------------------------------------------
function ForceUpdatePlayerLocation(int iIndex)
{
	EAIController(Characters[iIndex]).UpdatePlayerLocation( Characters[0].pawn, false, true );
}

//--------------------------------------------------[Frederic Blais]-----
// 
// GetSmellDeltaTime
// 
//------------------------------------------------------------------------
function int GetSmellDeltaTime(int SmellIndexFound)
{
	local EPlayerController PC;

	PC = EPlayerController(Characters[0]);

	if(PC.CurrentSmellIndex > SmellIndexFound)
	{
		return (PC.CurrentSmellIndex - SmellIndexFound);
	}	
	else
	{
		return (20 - SmellIndexFound + PC.CurrentSmellIndex);
	}

}

//--------------------------------------------------[Frederic Blais]-----
// 
// CheckSmellPoint
// 
//------------------------------------------------------------------------
function CheckSmellPoints(int Index, name JumpLabel)
{
	local int i,SmellPointRadius,BestSmellPoint,BestDeltaTime; 
	local EAIController AI;
	local EPlayerController PC;

	BestSmellPoint=-1;
	BestDeltaTime=20;

	AI = EAIController(characters[Index]);
	PC = EPlayerController(Characters[0]);

	//check if we are intersecting with smelling trail
	for(i=0; i<20; i++)
	{
		SmellPointRadius = 800; // - (GetSmellDeltaTime(i) * 10);

		if(PC.SmellArray[i] == vect(0,0,0))
			continue;

		//check we are intersecting
		if( (VSize(PC.SmellArray[i] - AI.EPawn.Location) < ( AI.EPawn.SmellRadius + SmellPointRadius)) &&
			(VSize(PC.SmellArray[i] - AI.EPawn.Location) > 35) )
	   {
		   //check if it's the best choice
		   if(BestDeltaTime >= GetSmellDeltaTime(i))
		   {
				BestSmellPoint=i;
				BestDeltaTime = GetSmellDeltaTime(i);
		   }
	   }
	}

	if(BestSmellPoint >= 0)
	{
		AlertLocation = PC.SmellArray[BestSmellPoint];
		GotoPatternLabel(JumpLabel);
	}
}

//--------------------------------------------------[Matthew Clarke]------
// 
// RemoveUsedSmellPoint
//  Removes a smell point we already used to start a MoveTo
// 
//------------------------------------------------------------------------
function RemoveUsedSmellPoint(int Index)
{
    local int               i;
	local EAIController     AI;
	local EPlayerController PC;

	AI = EAIController(characters[Index]);
	PC = EPlayerController(Characters[0]);

    for(i = 0; i < 20; i++)
	{
        // Check if it was that point the trigered the searcj
        if(AlertLocation == PC.SmellArray[i])
        {
            // Remove the point from the smell point array
            PC.SmellArray[i] = vect(0,0,0);
        }
	}
}

//--------------------------------------------------[Frederic Blais]-----
// 
// LockDoor
// 
//------------------------------------------------------------------------
function LockDoor(Name matchTag, bool IsLocked, bool IsUsable)
{
    local EDoorMover  Door;

    if(matchTag != '')
    {
		foreach DynamicActors(class'EDoorMover', Door)
        {
			if (Door.Tag == matchTag)
            {
				Door.Locked = IsLocked;
                //Door.Usable = IsUsable;
                Door.SetUsable(IsUsable);
            }
        }

    }
}

//--------------------------------------------------[Frederic Blais]-----
// 
// SendTransmission
// 
//------------------------------------------------------------------------
function SendNPCTransmission(string Text, sound SoundData)
{
	EMainHUD(EPlayerController(Characters[0]).myHUD).CommunicationBox.AddTransmission( self, TR_NPCS,Text, SoundData);
}


//--------------------------------------------------[Frederic Blais]-----
// 
// CheckIfDirectLine
// 
//------------------------------------------------------------------------
function CheckIfDirectLine(int iIndex, Actor target,name JumpLabel)
{
	local vector HitLocation,HitNormal;
	local Actor Result;
	local int PillTag;
	local Material HitMaterial;
   
    //should be NPC_SHOT 
	//Result = Characters[iIndex].pawn.Trace(HitLocation,HitNormal,target.Location,Characters[iIndex].pawn.Location,true);

	//Result = Characters[iIndex].pawn.TraceBone(PillTag, HitLocation, HitNormal, target.Location, Characters[iIndex].pawn.Location, HitMaterial, false);
    if( Characters[iIndex].pawn.TraceTarget(target.Location, Characters[iIndex].pawn.Location,target,false,false,true) )
        GotoPatternLabel(JumpLabel);

	//if(Result == target)
	//	GotoPatternLabel(JumpLabel);
}

/*-----------------------------------------------------------------------------
 Function:      GetMatchingActor

 Description:   -
-----------------------------------------------------------------------------*/
function Actor GetMatchingActor(Name MatchTag)
{
    local Actor FoundAct; 

	foreach AllActors(class'Actor', FoundAct)
	{
        if (FoundAct.Tag == MatchTag)
            return FoundAct;
	}

    return None;
}

//--------------------------------------------------[Frederic Blais]-----
// 
// CheckNearestArmedNPC
// 
//------------------------------------------------------------------------
function CheckNearestArmedNPC(name JumpLabel)
{
	local EAIPawn             P;
    local EAIController      AI;
    local float             fTempDist;
    local float             fBestDist;
    local EPawn             oNearest;
    local NavigationPoint   NavStart;
    local NavigationPoint   NavEnd;

    AI = EAIController(Characters[1]);
    fBestDist = -1;

    NavStart = Epawn(AI.Pawn).GetAnchorForLocation(AI.Pawn.Location);

    NearestArmedNPC = None; // Reset

	foreach RadiusActors ( class'EAIPawn', P, 2500, Characters[1].pawn.Location )
	{            
		if( (P.Controller != None)
         && (EAIController(P.Controller).Pattern.GetStateName() != 'attack') 
         && (!P.bDisableAI)  
         && (P.IsA('EAIProfessional')))
		{
			NavEnd = Epawn(AI.Pawn).GetAnchorForLocation(P.Location);

			if((NavEnd != None) && (NavStart != None))
			{
				fTempDist = Epawn(AI.Pawn).ArePointsConnected(NavStart, NavEnd); 
			}
        
			if(fTempDist != 0)
			{
				if((fBestDist == -1) || (fTempDist < fBestDist))
				{
					//log("Temp nearest armed"@P);
					NearestArmedNPC = P;
					fBestDist = fTempDist;
				}
			}
		}
	}
    
    //log("NearestArmedNPC"@NearestArmedNPC);
    if (NearestArmedNPC != None)
    {
        GotoPatternLabel(JumpLabel);
    }
}

//--------------------------------------------------[Matthew Clarke]-----
// 
// CheckSwitchAlreadyLocked
//   Check if ASwitch is already locked
//      If it is, return
//      If it is NOT, lock it and interact with it 
//------------------------------------------------------------------------
function CheckSwitchAlreadyLocked(int CharIndex, Actor ASwitch)
{
    local Controller C;
    local EAIController AI;
    local EGameplayObject EGO;
    local int i;

    EGO = EGameplayObject(ASwitch);

    if(EGO == None)
    {
        log(ASwitch $ "is Not a EGameplayObject");
        return;
    }

    for (C = Level.ControllerList; C != None; C = C.nextController)  
    {
        AI = EAIController(C);

        if(AI != None)
        {

            for(i = 0; i < AI.LockedSwitches.Length; i++)
            {
                if(AI.LockedSwitches[i] == EGO)
                {
                    return;
                }
            }
        }
    }

    // Set switch as ours
    EAIController(Characters[CharIndex]).LockedSwitches[EAIController(Characters[CharIndex]).LockedSwitches.Length] = EGO;
    Goal(1, GOAL_InteractWith, 24,,,ASwitch,,,,, 1.0);
}

/*-----------------------------------------------------------------------------
 Function:      SendUnrealEvent

 Description:   -
-----------------------------------------------------------------------------*/
function SendUnrealEvent(name EventName)
{
	if(EventName == 'SaveWhoAreYou' && EPlayerController(Characters[0]).bShouldTurnFast)
	{
		GotoState(, 'KillNikoAndPlayerBecauseMoved');
	}
	else
	{
		log("Event "$EventName$" sent...");
		Super.TriggerEvent(EventName, self, Characters[0].pawn);
	}
}

/*-----------------------------------------------------------------------------
 Function:      CinCamera

 Description:   -
-----------------------------------------------------------------------------*/
function CinCamera(int bEndCinematic, optional Name pos, optional Name target, optional Name MClarkeDeleteMe)
{
	local EPlayerController Epc;
    local Actor  aPos, aTarget;

	Epc = EPlayerController(Characters[0]);

	if( bEndCinematic == 0 )
	{
		// Stop player control //
		// Try to catch whether the cinematic should be launched
		if( !Epc.ToggleCinematic(self, true) )
		{
			End();
			return;
		}

	    // Move the camera //
        if( pos != '' )
		{
			aPos = GetMatchingActor(pos);
            if( aPos != None )
                Epc.SetLocation(aPos.Location);
		}

        // Rotate the camera //
        if( target != '' )
        {
            aTarget = GetMatchingActor(target);
            if( aTarget != None )
            {
                if( aPos != None )
                    Epc.SetRotation(Rotator(aTarget.Location - aPos.Location));
                else
                    Epc.SetRotation(Rotator(aTarget.Location - Epc.Location));
            }
        }
    }
    else
    {
		Epc.ToggleCinematic(self, false);
    }
}

/*-----------------------------------------------------------------------------
 Function:      AlarmNPC

 Description:   -
-----------------------------------------------------------------------------*/
function AlarmNPC(Pawn Target)
{
    

    if((TriggerEvent != None) && (Target != None))
    {
	    TriggerEvent.Reset();
	    TriggerEvent.EventLocation = AlertLocation;	

	    EAIController(Target.controller).Group.StartAlarmBehavior(TriggerEvent);
    }
    else
    {
        log("AlarmNPC::TriggerEvent"@TriggerEvent);
        log("AlarmNPC::Target"@Target);
    }
}

/*-----------------------------------------------------------------------------
 Function:      GetNearestArmedNPC

 Description:   -
-----------------------------------------------------------------------------*/
function EPawn GetNearestArmedNPC()
{
	return NearestArmedNPC;
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

	if( EAIController(Characters[1]).m_pGoalList.CheckGoalPriority(_priority) )
		return true;
	else
		return false;
}

// REMOVE ME MATHIEW
function ChangeHUD(name HUDState);
function SendHUDKeyEvent(EInputAction Action, EchelonEnums.eKEY_BIND Key);
function MenuTraining(bool bBegin);
function MoveCamera(int eMode, optional float CamAng);
function Open(optional bool bCloseSecondaryViewport);
function WaitForPlayerInput(optional EchelonEnums.eKEY_BIND Key, optional name JumpLabel, optional name lookActor);
// REMOVE ME MATHIEW

/*---------------------------------[Frederic Blais - 15 Feb 2002]---------

 Function:      SendPatternEvent

 Description:   -
-----------------------------------------------------------------------------*/
function SendPatternEvent(name GroupTag, name JumpLabel)
{
	local EGroupAI Group;

	foreach DynamicActors( class'EGroupAI', Group, GroupTag)
	{
		Group.SendJumpEvent(JumpLabel,false,false);
		break; 
	}			
}

/*---------------------------------[Frederic Blais - 15 Feb 2002]---------

 Function:      StartAlarm

 Description:   -
-----------------------------------------------------------------------------*/
function StartAlarm(name AlarmTag, optional int StartAlarm)
{
	local EAlarm Alarm;

	foreach DynamicActors( class'EAlarm', Alarm, AlarmTag)
	{
		if(StartAlarm > 0)
		{
			Alarm.EnableAlarm(Characters[0].pawn,None);
		}
		else
		{
			Alarm.DisableAlarm(Characters[0].pawn);
		}

		break; 
	}			
}

/*---------------------------------[Frederic Blais - 15 Feb 2002]---------

 Function:      MakeDamage

-----------------------------------------------------------------------------*/
function MakeDamage(Pawn _Target, int _dammage)
{
	_Target.TakeDamage( _dammage, None, Vect(0,0,0), Vect(0,0,0), Vect(0,0,0), None);
}

/*---------------------------------[Frederic Blais - 15 Feb 2002]---------

 Function:      ResetNPC

 Description:   -
-----------------------------------------------------------------------------*/
function ResetNPC(int _index, bool bResetInteraction,  optional name _tag)
{
	//if(bAll)
	//{
		if(Characters[_index] != None)
		{
			//reset health
			Characters[_index].pawn.health  = EAIController(Characters[_index]).epawn.InitialHealth;

			// Reset Interaction
			if( bResetInteraction && EPawn(Characters[_index].Pawn).Interaction != None )
				ENpcZoneInteraction(EPawn(Characters[_index].Pawn).Interaction).ResetConversation();

			//avoid NPCs burning
			EAIController(Characters[_index]).ePawn.AttenuateFire(1);

			//reset the gun state
			if(EAIController(Characters[_index]).ePawn.CurrentWeapon != None)
				EAIController(Characters[_index]).ePawn.CurrentWeapon.GotoState('s_Selected');

			EAIController(Characters[_index]).ResetGoalList();

            // Make sure we aren't seeing the player anymore
            EAIController(Characters[_index]).bPlayerSeen = false;
            EAIController(Characters[_index]).LastKnownPlayerTime = 0.0f;
            EAIController(Characters[_index]).LastKnownPlayerLocation = vect(0.0f, 0.0f, 0.0f);
            EAIController(Characters[_index]).LastKnownPlayerDirection = vect(0.0f, 0.0f, 0.0f);


			//reset epawn
			EAIController(Characters[_index]).ePawn.GotoState('DefaultState'); 

			//reset controller state
			if(!EAIController(Characters[_index]).epawn.bKeepNPCAlive)
			{
            if ((EAIController(Characters[_index]).GetStateName() == 's_Unconscious')
            ||  (EAIController(Characters[_index]).GetStateName() == 's_Grabbed')
            ||  ((EAIController(Characters[_index]).GetStateName() == 's_Carried') 
              && (EAIController(Characters[_index]).pawn.health > 0)))
            {
			    EAIController(Characters[_index]).GotoState('s_Groggy');
            }
			}
			else
			{
				if(EAIController(Characters[_index]).group.scriptedpattern != None)
				{
					EAIController(Characters[_index]).group.scriptedpattern.bDisableMessages = false;
					EAIController(Characters[_index]).group.scriptedpattern.bDisableEventTrigger = false;
				}

				EAIController(Characters[_index]).bNotResponsive=false;
				EAIController(Characters[_index]).GotoState('s_default');
			}

			//reset default pattern Idle
			EAIController(Characters[_index]).Pattern.GotoState('Idle');


			//put the NPC back in the pattern
			if(EAIController(Characters[_index]).group !=  None)
			{
				EAIController(Characters[_index]).group.AddAIMember(EAIController(Characters[_index]));
			}

		}
		else
		{
			log("Characters[_index] is NONE");
			//we have to spawn a new controller

			//we have to spawn a new default pattern

		}
	//}
	/*else
	{
		Characters[_index].pawn.health  = 100;
	}*/
}

/*-----------------------------------------------------------------------------
 Function: 

 Description:
-----------------------------------------------------------------------------*/
function LaserMicSession(int bEndLaserMic, optional Name target, optional float SuccessRate, optional Name SuccessLabel)
{
	if(bEndLaserMic > 0)
	{
		plog("Laser Mic Session Ended.  Success Requested: "$SuccessRate$" Session Success: "$SessionProgress);
		// validate stuff
		if(SuccessRate <= SessionProgress)
		{
			//lasermic session is a succes
			MicrophoneMover.PlaySound(Sound'FisherEquipement.Play_LaserRecordOK', SLOT_Interface);
			GotoPatternLabel(SuccessLabel);
		}

		// destroy volume when conversation is over
		MicrophoneMover.LinkedSession = None;
		MicrophoneMover = None;

		SetLaserMicSession(false);

	}
	else
	{
		SessionProgress=0;
		LaserMicInit = true;

		SetLaserMicSession(true);

		if( MicrophoneMover != None )
			Log(self$" ERROR: MicrophoneMover should be None for Pattern.");
		else if( target != '' )

		{
			MicrophoneMover = ELaserMicMover(GetMatchingActor(target));
			MicrophoneMover.LinkedSession = self;
		}
	}
}


//------------------------------------------------------------------------
// Description		
//		Return touching Mic, use if( GetTouchingMic() == None ) to check
//		if a Micro is touching
//------------------------------------------------------------------------
event bool MicIsTouchingSession()
{
	return MicrophoneMover != None && MicrophoneMover.TouchedByLaserMic;
}

//-----------------------------------[Matthew Clarke - June 5th 2002]-----
// 
// Description
//    Mostly a wrapper
// 
//------------------------------------------------------------------------
function int AddChangeAndSuggestBehavior(int _CharacterIndex, Vector Location, EChangeType ChangeType)
{
    if(EAIController(Characters[_CharacterIndex]).Group != None)
    {
        return EAIController(Characters[_CharacterIndex]).Group.ChangeHistory_AddChangeAndSuggestBehavior(Location, ChangeType);
    }
}

//-----------------------------------[Matthew Clarke - July 3rd 2002]-----
// 
// Description
//    Pattern Editor Action, checks for a specific firing mode by the player
//    TO be used in Training maps patterns
// 
//------------------------------------------------------------------------
function CheckFireMode(int iSnipeMode, int iBurstMode, Name JumpLabel)
{
    local EPlayerController EPC;
    local ESniperGun ESG;

    EPC = EPlayerController(Characters[0]);

    if(EPC == None)
    {
        return;
    }

    ESG = ESniperGun(EPC.MainGun);

    if(ESG == None)
    {
        return;
    }

    if (iSnipeMode != -1)
    {
        if(((iSnipeMode == 1) && (!ESG.bSniperMode)) || ((iSnipeMode == 0) && (ESG.bSniperMode))) 
        {
            GotoPatternLabel(JumpLabel); 
        }
    }

    if (iBurstMode != -1)
    {
        if(((iBurstMode == 1) && (ESG.eROFMode != ROF_Single)) || ((iBurstMode == 0) && (ESG.eROFMode != ROF_Auto))) 
        {
            GotoPatternLabel(JumpLabel);
        }    
    }

    // Succeeded
    return;
}

//-----------------------------------[Matthew Clarke - July 9th 2002]-----
// 
// Description
//    Adds some recon information to Sam's PDA
// 
//------------------------------------------------------------------------
function AddRecon(class<ERecon> ReconClassName)
{
    local EPlayerController EPC;

    EPC = EPlayerController(Characters[0]);	

	if(EPC != None)
	{
		EPC.AddRecon(ReconClassName);
	}

}

//-----------------------------------[Matthew Clarke - July 16th 2002]-----
// 
// Description
//    Checks if Sam has been unseen for X seconds
// 
//------------------------------------------------------------------------
function CheckIfPlayerUnseenWithin(float fMinimumUnseenTime, Name JumpLabel)
{
    local EAIController EAIC;

    EAIC = EAIController(Characters[1]);

    if(fMinimumUnseenTime == 0.0f)
    {
        return;
    }

    if (EAIC == None)
    {   
        return;
    }

    if ((Level.TimeSeconds - EAIC.LastKnownPlayerTime) > fMinimumUnseenTime)
    {
        GotoPatternLabel(JumpLabel);
    }
}

//-----------------------------------[Matthew Clarke - July 29th 2002]-----
// 
// Description
//    Beg for life if haven't in last 10 secs
// 
//------------------------------------------------------------------------
function bool BegForLife(int _CharacterIndex)
{
    local EAIController EAIC;

    EAIC = EAIController(Characters[1]);

    if (EAIC == None)
    {   
        return false;
    }

    if ((Level.TimeSeconds - fLastBegForLife) > 10.0f)
    {
        fLastBegForLife = Level.TimeSeconds;

        return true;
    }
    
    return false;
}

//-----------------------------------[Matthew Clarke - July 30th 2002]-----
// 
// Description
//
// 
//------------------------------------------------------------------------
function IgnoreAlarmStage(bool bIgnore)
{
    EchelonLevelInfo(Level).bIgnoreAlarmStage = bIgnore;
}

//-----------------------------------[Matthew Clarke - August 1st 2002]-----
// 
// Description
//    Set a Stop Goal to hide. Set focus on player if seen
// 
//------------------------------------------------------------------------
function SetHideGoal(int _CharacterIndex)
{
    local NavigationPoint oNP;
    local Vector          oFocus;

    // Find NPC's anchor
    oNP = EPawn(Characters[_CharacterIndex].Pawn).GetAnchorForLocation(Characters[_CharacterIndex].Pawn.Location);
    
    if((oNP != None) && (oNP.bDirectional))
    {
        // Anchor is directional, use its direction to hide
        oFocus = Characters[_CharacterIndex].Pawn.Location + (Vector(oNP.Rotation) * 300.0f);
    }
    else
    {
        // Anchor is not directional, use current rotation to hide
        oFocus = Characters[_CharacterIndex].Pawn.Location + (Vector(Characters[_CharacterIndex].Pawn.Rotation) * 300.0f);
    }

	EAIController(Characters[_CharacterIndex]).AddGoal(Goal_Wait,14,,oFocus,,,'PrsoCrAlCC0',,,4.0f,MOVE_CrouchJog,,MOVE_CrouchJog);
}

//--------------------------------[Matthew Clarke - August 25th 2002]-----
// 
// Description
//  This is used in the 0_0_3_Training map when the player fails a 
//  challenge. It saves/restore the challenge's initial state
// 
//------------------------------------------------------------------------
function QuickSaveLoad(bool bSave, bool bFade)
{
	local EPlayerController EPC;

    EPC = EPlayerController(Characters[0]);
	
    if(bSave)
    {
		if(EPC != None)
		{	
			EPC.bAutoSaveLoad = true;
			EPC.bSavingTraining = true;
			SetTimer(0.1f,false);
		}
		else
		{
        ConsoleCommand("SAVEGAME FILENAME=TEMP OVERWRITE=TRUE");
    }
    }
    else
    {
		if(EPC != None)		
		{		
			EPC.bAutoSaveLoad = true;
			EPC.bLoadingTraining = true;
			SetTimer(0.1f,false);
		}
    else
    {
        ConsoleCommand("LOADGAME FILENAME=TEMP");    
    }
}
}

//--------------------------------[Matthew Clarke - August 29th 2002]-----
// 
// Description
// 
//------------------------------------------------------------------------
function SetAlarmStage(int iNewStage)
{
	// Joshua - Clamp to 2 in Elite mode as 3 alarms and the mission's over
	if (IsEliteMode() && iNewStage <= 3)
    {
        iNewStage = 2;
    }
    if((iNewStage >= 0) && (iNewStage <= 3))
    {
        EchelonLevelInfo(Level).AlarmStage = iNewStage;
    }
    else
    {
        log("SetAlarmStage -> Invalid alram stage : "@iNewStage);
    }
}

//--------------------------------[Matthew Clarke - August 30th 2002]-----
// 
// Description
// 
//------------------------------------------------------------------------
function CheckIfShotAllCams(name JumpLabel)
{
    local ESecondaryAmmo ESA;
    local EPlayerController EPC;

    EPC = EPlayerController(Characters[0]);	

    if(EPC == None)
    {
        return;
    }
  
    // Check Number of cams in inventory
    if(EPawn(EPC.Pawn).FullInventory.GetNbItemInCategory(CAT_MAINGUN) > 1) // F2000 itself counts as 1
    {
        // Still posesses 1+ cam , get out
        return;
    }

    // Check if cam is flying, get out
    // CHeck if player controlling cam, get out
    foreach DynamicActors (class'ESecondaryAmmo', ESA)
    {
        if ((ESA.GetStateName() == 's_Flying')
          ||(ESA.GetStateName() == 's_Camera'))
        {
            return;
        }
    }

    // Player is out of cams
    //log("Player is out of cams");
    GotoPatternLabel(JumpLabel);
}

//--------------------------------[Matthew Clarke - September 4th 2002]-----
// 
// Description
//  To be used in 5_1_1_PresidentialPalace. 
//    Jumps to a label if player tries to attack
// 
//------------------------------------------------------------------------
function CheckPlayerPlan(Name JumpLabel)
{
    local EPlayerController EPC;

    EPC = EPlayerController(Characters[0]);	

    if ((EPC.EPawn.bIsCrouched) 
     || (EPC.GetStateName() == 's_PlayerJumping') 
     || (EPC.GetStateName() == 's_FirstPersonTargeting') 
     || (EPC.GetStateName() == 's_PlayerSniping')
     || (EPC.GetStateName() == 's_Throw'))
    {
        GotoPatternLabel(JumpLabel);    
    }
}

//--------------------[Matthew Clarke - January 20, 2003 - XBOX_LIVE]-----
// 
// Description
//  Enable disable EGroupAI's directly from patterns, just like a EZoneAI
// 
//------------------------------------------------------------------------
function ToggleGroupAI(bool bEnable, Name GroupTag0, Name GroupTag1, Name GroupTag2, Name GroupTag3,
                       Name GroupTag4, Name GroupTag5)
{
    local EAIPawn       NPC;
    local bool          bAlarmIsRunning;
    local bool          bBodyFound;
    local array<Name>   GroupTagsInArray;   // Used so we can do a for loop
    local int           i;                  // counter

    GroupTagsInArray.Length = GroupTagsInArray.Length + 6;

    GroupTagsInArray[0] = GroupTag0;
    GroupTagsInArray[1] = GroupTag1;
    GroupTagsInArray[2] = GroupTag2;
    GroupTagsInArray[3] = GroupTag3;
    GroupTagsInArray[4] = GroupTag4;
    GroupTagsInArray[5] = GroupTag5;
    
    if(bEnable) // We're putting a EGroupAI ON duty - Just enable AI + Modify their music
    {
    	// Try to find the NPCs
	    foreach DynamicActors( class'EAIPawn', NPC)
	    {
		    for ( i = 0; i < GroupTagsInArray.Length; i++ )
		    {
			    if(NPC.m_GroupTag == GroupTagsInArray[i])
			    {
				    log("NPC "$NPC$" was reenabled...");				    
				    NPC.bDisableAI=false;
				    NPC.bDisableAIforSound=false;

                    // Cancel music request for that NPC
				    if( NPC.controller != None && EAIController(NPC.controller).pattern != None)
				    {
					    // Check the current state of the default pattern
					    if(EAIController(NPC.controller).pattern.GetStateName() == 'search')
					    {
						    EchelonLevelInfo(Level).SendMusicRequest(0,true,EAIController(NPC.controller).pattern, true);
						    EchelonLevelInfo(Level).SendMusicRequest(1,false,EAIController(NPC.controller).pattern);
					    }

					    if(EAIController(NPC.controller).pattern.GetStateName() == 'attack')
					    {
						    EchelonLevelInfo(Level).SendMusicRequest(0,false,EAIController(NPC.controller).pattern);
						    EchelonLevelInfo(Level).SendMusicRequest(1,true,EAIController(NPC.controller).pattern, true);
					    }
				    }
			    }
            }
        }
    }
    else        // We're putting a EGroupAI OFF duty - Check Alarms + Disable AI + Modify Music + Check Inert Bodies 
    {
    	// Do a first pass to see if alarms are running
	    foreach DynamicActors( class'EAIPawn', NPC)
	    {
		    for ( i = 0; i < GroupTagsInArray.Length; i++ )
		    {
			    if(NPC.m_GroupTag == GroupTagsInArray[i])
			    {
				    if(NPC.group != None)
				    {
					    // Avoid triggering an alarm if:
					    // 1- The Body is in a group that is attacking
					    // 2- The Body is in a group that is on an alarm
					    if( (NPC.group.CurrentAlarm != None) || NPC.group.IsAMemberInAttack() )
					    {
						    bAlarmIsRunning=true;
						    break;
					    }
				    }

			    }
            }
	    }

        // Disable NPC corresponding to EGroupAI
        foreach DynamicActors( class'EAIPawn', NPC)
	    {
		    for ( i = 0; i < GroupTagsInArray.Length; i++ )
		    {
			    if(NPC.m_GroupTag == GroupTagsInArray[i])
			    {	
				    //check if the NPC is inert
				    if( (NPC.GetStateName() == 's_Unconscious') || (NPC.GetStateName() == 's_Dying'))
				    {
					    if(NPC.LastRenderTime < Level.TimeSeconds - 2.0f)
					    {
						    //check visibility factor for each NPC
						    if((NPC.GetVisibilityFactor(true) > 30) && (!NPC.bIsDog) && (!NPC.bSniper))
						    {
							    if( !NPC.bBodyDetected && !bAlarmIsRunning )
							    {
								    //flag the NPC as found
								    NPC.bBodyDetected=true;

								    bBodyFound=true;
							    }
						    }
					    }
				    }

				    if( NPC.controller != None && EAIController(NPC.controller).pattern != None)
				    {
					    //cancel music request for that NPC
					    EchelonLevelInfo(Level).SendMusicRequest(0,false,EAIController(NPC.controller).pattern);
					    EchelonLevelInfo(Level).SendMusicRequest(1,false,EAIController(NPC.controller).pattern);
				    }

				    log("NPC "$NPC$" was disabled...");
				    NPC.bDisableAI=true;
				    NPC.bDisableAIforSound=true;
				    NPC.StopAllVoicesActor(true);
			    }
            }
        }

        // Report inert NPCs 
        if(bBodyFound)
	    {
		    log("** An Inert NPC was found **");

            if (!((EchelonLevelInfo(Level)).bIgnoreAlarmStage))
            {
    	        //send NPC transmission
		        EchelonGameInfo(Level.Game).pPlayer.SendTransmissionMessage(Localize("Transmission", "BodyFound", "Localization\\HUD"), TR_NPCS);

			    AddOneVoice();
			    EchelonGameInfo(Level.Game).pPlayer.EPawn.PlaySound( (EchelonLevelInfo(Level)).FindCorpseSound, SLOT_Voice );

		        //play alarm sound
		        PlaySound(Sound'Electronic.Play_Seq_AlarmFindBody', SLOT_Interface);
		        PlaySound(Sound'Electronic.Stop_Seq_AlarmFindBody', SLOT_Interface);

		        //increase alarm stage
		        EchelonLevelInfo(Level).IncreaseAlarmStage();
            }
	    }
    }
}

//--------------------------------[Joshua - May 12th 2025]-----
//
// Description
//  Set profile deletion for permadeath mode.
//
//
//------------------------------------------------------------------------
function SetProfileDeletion()
{
    local EPlayerController EPC;

    EPC = EPlayerController(Characters[0]);

	if(EPC.eGame.bPermadeathMode)
		EPC.bProfileDeletionPending = true;
}

//--------------------------------[Joshua - May 21st 2025]-----
//
// Description
//  Check if the profile is on Elite difficulty.
//
//
//------------------------------------------------------------------------
function bool IsEliteMode()
{
    local EPlayerController EPC;

    EPC = EchelonGameInfo(Level.Game).pPlayer;

	return EPC.eGame.bEliteMode;
}


//--------------------------------[Joshua - June 1st 2025]-----
//
// Description
// Set when the player is identified by NPCs. For dogs, checks if their master's group
// has already identified the player to prevent duplicate counts.
//
//------------------------------------------------------------------------
function PlayerIdentified()
{
    local EAIController  MasterController, DogController;
    local EPawn MasterPawn;
    
    if(EGroupAI(Owner).bPlayerIdentifiedCounted || 
       EAIController(Characters[1]).bBlockDetection || 
       EAIController(Characters[1]).bBlockJumpDetection ||
	   EAIController(Characters[1]).bNotInStats)
    {
        return;
    }

    // Check if this is a dog with a master
    if(Characters[1] != None && EDog(Characters[1].Pawn) != None)
    {
        DogController = EAIController(Characters[1]);

        if(DogController.Master != None)
        {
            MasterPawn = DogController.Master;
            MasterController = EAIController(MasterPawn.Controller);

            if(MasterController != None && MasterController.Group != None)
            {
                if(MasterController.Group.bPlayerIdentifiedCounted)
                    return;

                MasterController.Group.bPlayerIdentifiedCounted = true;
            }
        }
    }

    EGroupAI(Owner).bPlayerIdentifiedCounted = true;
    EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("PlayerIdentified");
}

//default state
auto state idle{}
state Pattern{}

defaultproperties
{
    LaserMicSound=Sound'FisherEquipement.Play_LaserMicTargetOK'
    bEventExclusivity=true
    SatelliteCom=Sound'Interface.Play_SatelitteCom'
    bHidden=true
}