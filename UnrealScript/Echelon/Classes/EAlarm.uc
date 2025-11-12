class EAlarm extends Actor
	placeable;

enum eAlarmEvent
{
	AE_NONE,
	AE_DISABLE_ALARM,
	AE_ENABLE_ALARM
};

var eAlarmEvent			Event;
var EAIEvent			AIEvent;

var Controller			TriggerActor;
var Actor				InstigatorActor;
var array<Actor>		AlarmTriggers;			// Objects that may trigger the alarm on & off
var array<Actor>		AlarmObjects;			// Objects that will react to the alarm state changes (lights,doors,etc...)

var() array<EGroupAI>	PrimaryGroups;
var() array<EGroupAI>	SecondaryGroups;

var() float				DelayBeforeAlarmOff;	// 0 will never turn off the alarm (will be object triggered)
var() bool				bForceCallToInstigatorGroup;
var() bool				bTakePlayerPosition;

var	  bool				bAlreadyTriggered;
var   bool				bForceUpdatePos;

//----------------------------------------[Frederic Blais - 1 Aout 2001]-----
// 
// Description
//		Create clean EAIEvent object for communication with group object.
// 
//------------------------------------------------------------------------
function PostBeginPlay()
{
	Super.PostBeginPlay();
	AIEvent = spawn(class'EAIEvent');
}

//------------------------------------------------------------------------
// Description		
//		
//------------------------------------------------------------------------
function LinkTrigger(Actor A)
{
	AlarmTriggers[AlarmTriggers.Length] = A;
}

//------------------------------------------------------------------------
// Description		
//		
//------------------------------------------------------------------------
function LinkObject(Actor A)
{
	AlarmObjects[AlarmObjects.Length] = A;
}

//------------------------------------------------------------------------
// Description		
//		
//------------------------------------------------------------------------
function EnableAlarm(Actor Instigator, Controller Triggerer, optional bool _bForceUpdatePos)
{
	//Log("Enable alarm"@Instigator@Triggerer);

	//don't start the alarm if it's already started
	if (GetStateName() != 's_On')
	{
		InstigatorActor	= Instigator;
		TriggerActor	= Triggerer;

		//increase alarm stage
		if (!bAlreadyTriggered)
			EchelonLevelInfo(Level).IncreaseAlarmStage();

		bAlreadyTriggered = true;

		if (bTakePlayerPosition || _bForceUpdatePos)
		{
			bForceUpdatePos = true;
		}
		else
		{
			bForceUpdatePos = false;
		}


		GotoState('s_On');
	}
}

//------------------------------------------------------------------------
// Description		
//		
//------------------------------------------------------------------------
function DisableAlarm(Actor Instigator)
{
	//Log(Instigator$" disables alarm");

	GotoState('s_Off');
}

state() s_On
{
	function EnableAlarm(Actor Instigator, Controller Triggerer,optional bool _bForceUpdatePos);

	function BeginState()
	{
		local int i;
		local vector OffSet,Pos;
		local bool bUseObjectLocation;

		bUseObjectLocation = true;

		//Log("BEGINSTATE Alarm s_On");

		//set event
		Event = AE_ENABLE_ALARM;

		if (TriggerActor != None && EAIController(TriggerActor) != None)
		{
			EAIController(TriggerActor).Group.currentAlarm = self;
			EAIController(TriggerActor).Group.bIsPrimary = true;
			EAIController(TriggerActor).Group.bGroupRunningForAlarm = false;
		}

		//go throught the object list
		//Log("Alarm objects:"@AlarmObjects.Length);
		for (i = 0; i < AlarmObjects.Length; i++)
		{
			//Log("   "@i@AlarmObjects[i]);
			AlarmObjects[i].Trigger(self,None);
		}

		//send message to primary group
		AIEvent.Reset();
		AIEvent.EventType	  = AI_ALARM_ON_PRIMARY;
		AIEvent.EventTarget   = InstigatorActor;


		if ((InstigatorActor != None) && (TriggerActor != None))
		{
			if (EAIController(TriggerActor) != None)
			{
				//check if the pawn has seen the player
				if ((EAIController(TriggerActor).TimePlayerFirstSeen != 0) &&
					(EAIController(TriggerActor).TimePlayerFirstSeen < Level.TimeSeconds))
				{
					//check if the time is smaller than 15 sec.
					//if ((Level.TimeSeconds - EAIController(TriggerActor).LastKnownPlayerTime) < 15)
					//{
						AIEvent.EventLocation = EAIController(TriggerActor).LastKnownPlayerLocation;
						bUseObjectLocation = false;
						log("************** Sending LastKnownPlayerLocation for alarmCall ***************");
					//}
				}
			}
			
			if (bUseObjectLocation)
			{
			OffSet = (vect(50,0,0) >> InstigatorActor.Rotation);
			OffSet.Z = 0;

			Pos = InstigatorActor.Location;
			Pos.Z = TriggerActor.Pawn.Location.Z;

			AIEvent.EventLocation = Pos + OffSet;	
		}

			
		}
		else
		{
			AIEvent.EventLocation = InstigatorActor.Location;
		}

		//fix consistency bug when setting exclusivity true during an alarm run from scripted pattern
		if (bForceCallToInstigatorGroup)
		{
			if (EAIController(TriggerActor).pattern != None)
			{
				EAIController(TriggerActor).pattern.DisableMessages(false);
			}
		}


		for (i = 0; i < PrimaryGroups.Length; i++)
		{
			if (PrimaryGroups[i] != None)
			{
				if (TriggerActor != None && EAIController(TriggerActor) !=  None)
				{
					//don't send message to the trigger group
					if ((EAIController(TriggerActor).Group != PrimaryGroups[i]) || (bForceCallToInstigatorGroup))
					{
						PrimaryGroups[i].AIAlarmCallBack(self, AIEvent,bForceUpdatePos);
					}
				}
				else
				{

					PrimaryGroups[i].AIAlarmCallBack(self, AIEvent,bForceUpdatePos);
				}
			}
		}

		//send message to secondary group
		AIEvent.EventType	  = AI_ALARM_ON_SECONDARY;

		for (i = 0; i < SecondaryGroups.Length; i++)
		{
			if (SecondaryGroups[i] != None)
			{
				SecondaryGroups[i].AIAlarmCallBack(self, AIEvent);
			}
		}

		//We want to disable the sound of the alarm
		SetTimer(DelayBeforeAlarmOff,false);

		// reset vars
		InstigatorActor = None;
		TriggerActor = None;
	}

	function Timer()
	{
		DisableAlarm(Instigator);
	}
}

state s_Off
{
	function BeginState()
	{
		local int i;

		//Log("-------------------------------------  Alarm going off...");

		//set event
		Event = AE_DISABLE_ALARM;

		//go through the object list
		for (i = 0; i < AlarmObjects.Length; i++)
			AlarmObjects[i].Trigger(self,None);

		//send message to all groups
		AIEvent.Reset();
		AIEvent.EventType	  = AI_ALARM_OFF;
		AIEvent.EventTarget   = Instigator;

		if (Instigator != None)
			AIEvent.EventLocation = Instigator.Location;	

		for (i = 0; i < PrimaryGroups.Length; i++)
		{
			if (PrimaryGroups[i] != None)
			{
				PrimaryGroups[i].AIAlarmCallBack(self, AIEvent);
			}
		}

		for (i = 0; i < SecondaryGroups.Length; i++)
		{
			if (SecondaryGroups[i] != None)
			{
				SecondaryGroups[i].AIAlarmCallBack(self, AIEvent);
			}
		}
	}
}

defaultproperties
{
    DelayBeforeAlarmOff=15.000000
    bHidden=true
}