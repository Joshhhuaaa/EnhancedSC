class ESlidingDoor extends EDoorMover;

var bool	HasBeenCrackedOpened;

//------------------------------------------------------------------------
// Description
//		Make it open if the door has already been opened by Sam
//------------------------------------------------------------------------
function bool CanOpenSpecial()
{
	//Log(self$" Can open special "@HasBeenCrackedOpened);
	return HasBeenCrackedOpened;
}

function OpenerTrigger(EDoorOpener Other, Pawn EventInstigator)
{
	// If door opened by Sam, no more need to use interaction. ALthough it's still linked to it for Npc's
	if (EventInstigator.Controller.bIsPlayer)
		HasBeenCrackedOpened = true; //bTriggerOnceOnly = true; // to leave door opened

	Super.OpenerTrigger(Other, EventInstigator);
}

function bool CanDoTrigger(Actor Other, Pawn EventInstigator)
{
	local EAlarm AlarmTrigger;

	// in case other is unknown (elevatorpanel activating doors)
	if (Other == None)
		return Super.CanDoTrigger(Other, EventInstigator);

	// Triggered by the alarm
	AlarmTrigger = EAlarm(Other);
	if (AlarmTrigger != None)
	{
//		Log("AE_ENABLE_ALARM "@self);
//		Log("	Event="$AlarmTrigger.Event);
//		Log("	KeyNum="$KeyNum);
//		Log("	Location="$Location$" Rotation="$Rotation);
//		Log("	BasePos="$BasePos$" BaseRot="$BaseRot);
//		Log("	IsOpened()"@IsOpened());
//		Log("	BaseRot & BasePos"@baserot == rotation && basepos == location);

		switch (AlarmTrigger.Event)
		{
		case AE_ENABLE_ALARM :

			// Lock the door
			//Log(self@"gets locked by alarm");
			Locked = true;

			// Don't trigger door if it's already closed
			if (!IsOpened())
			{
				//Log(self$" Don't trigger already closed door for enable alarm");
				return false;
			}

			break;

		case AE_DISABLE_ALARM :

			// Unlock door
			//Log(self@"gets Unlocked by alarm");
			Locked = false;

			// Do nothing in this event mode
			//Log(self$" Don't trigger door for disable alarm");
			return false;
			break;
		}
	}

	//Log("	Triggered ...");
	return Super.CanDoTrigger(Other, EventInstigator);
}

// Used for BumpOpenTimed doors linked (kal1) and Elevator doors.
function MakeGroupReturn(Actor Other)
{
	Super.MakeGroupReturn(Other);

	//Log(name$" MakeGroupReturn"@bSlave@LinkedDoor@LinkedDoor.bSlave);

	if (LinkedDoor != None && Other != LinkedDoor && !LinkedDoor.bSlave)
	{
		// Prevents recursion
		LinkedDoor.bSlave = true;
		LinkedDoor.MakeGroupReturn(self);
		LinkedDoor.bSlave = false;
	}
}

state BumpOpenTimed
{
	function Bump(actor Other, optional int Pill)
	{
		if (LinkedDoor != None && !bSlave)
		{
			// Prevents recursion
			LinkedDoor.bSlave = true;
			LinkedDoor.Bump(Other, Pill);
			LinkedDoor.bSlave = false;
		}
		Super.Bump(Other, Pill);
	}
}
