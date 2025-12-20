class ESwingingDoor extends EDoorMover;

var		EKnob		MyKnob;

var		Rotator		FrontRotation;
var		Rotator		BackRotation;
var		Vector		FrontPosition;
var		Vector		BackPosition;

var(Door)	bool	NoOpticCable;
var		bool		bKindaInUse;

// Knob stuff
var(Knob)	int		KnobOffsetX;

// Pick locking stuff
enum EPickLockQuadrant
{
	PL_UpLeft,
	PL_UpRight,
	PL_DownLeft,
	PL_DownRight,
	PL_None,
};

var(LockPick)	EPickLockQuadrant	Combinaison[6];
var(LockPick)	float				TimePerQuadrant;
var(LockPick)	int					TiltPerQuadrant;
var(LockPick)	float				MoveThreshold;

var(AI)	        EGroupAI		OpticCableGroupAI;
var(AI)         Name			OpticCableJumpLabel;

var(AI)	        EGroupAI		OpticCableGroupAIBegin;
var(AI)         Name			OpticCableJumpLabelBegin;

// AI modifies these vars in a hacky way so we don't want to mess real values
var EDoorOpener IniFrontOpener,
				IniBackOpener;
var EDoorOpener AIFrontOpener,
				AIBackOpener;

function PostBeginPlay()
{
	local Vector DoorPos;
	local vector min, max;

	Super.PostBeginPlay();

	// Validate opening direction
	if (KeyRot[1].Yaw < 0 && KeyRot[2].Yaw > 0)
	{
		FrontRotation	= KeyRot[2];
		BackRotation	= KeyRot[1];
		FrontPosition	= KeyPos[2];
		BackPosition	= KeyPos[1];
	}
	else if (KeyRot[1].Yaw > 0 && KeyRot[2].Yaw < 0)
	{
		FrontRotation	= KeyRot[1];
		BackRotation	= KeyRot[2];
		FrontPosition	= KeyPos[1];
		BackPosition	= KeyPos[2];
	}
	else
	{
		Log(self@"Problem with opening direction");
	}

	// Spawn knob
	GetBoundingBox(min, max);
	DoorPos  = Location;
	DoorPos += KnobOffsetX * (Vect(1,0,0)>>Rotation);
	DoorPos.Z += (min.Z + 90.f);

	if (InitialState != 'BumpOpenTimed')
	{
		MyKnob = spawn(class'EKnob', self,, DoorPos);
		MyKnob.SetStaticMesh(None);
		Myknob.setBase(self);
	}

	// if linked to an opener object, remove interaction
	if (FrontOpener != None || BackOpener != None)
	{
		// Assigned to something else, toggle door interaction off
		// Joshua - Keep door interaction enabled for optic cable when using new door interaction system
		if (!EchelonGameInfo(Level.Game).bNewDoorInteraction)
			MyKnob.ToggleInteraction(false);
		// Using the opener will unlock it
		Locked = true;
	}

	if (FrontOpener == None)
		FrontOpener = MyKnob;

	if (BackOpener == None)
		BackOpener = MyKnob;

	// Setup
	IniFrontOpener = FrontOpener;
	IniBackOpener = BackOpener;

	ResetNpcVars();
}

// Set AI vars
function ResetNpcVars()
{
	//Log("NPC RESET TO"@IniFrontOpener@IniBackOpener);
	AIFrontOpener = IniFrontOpener;
	AIBackOpener = IniBackOpener;
}

//------------------------------------------------------------------------
// Description		
//		Unlocks a door .. done from pick lock
//------------------------------------------------------------------------
function Unlock()
{
	// Unlock me
	if (Locked)
		Locked = false;

	// Try to unlock linked door
	if (LinkedDoor != None && !bSlave && LinkedDoor.IsA('ESwingingDoor'))
	{
		LinkedDoor.bSlave = true;
		ESwingingDoor(LinkedDoor).UnLock();
		LinkedDoor.bSlave = false;
	}
}

function SetInteraction(class<EInteractObject> ClassName)
{
	if (MyKnob.InteractionClass != None)
	{
		//Log("Changing interaction for door knob from "$myknob.interactionclass$" to "$classname);

		if (MyKnob.Interaction == None)
			Log(self$" Problem with my knob interaction");

		MyKnob.Interaction.Destroy();
		MyKnob.InteractionClass	= ClassName;
		MyKnob.Interaction = Spawn(ClassName, MyKnob, , MyKnob.Location);
	}
}

//------------------------------------------------------------------------
// Description		
//		Check side of the pawn, set First key before calling the Trigger
//------------------------------------------------------------------------
function SetOpeningDirection(EPawn Pawn)
{
	if (GetPawnSide(Pawn) == ESide_Front)
	{
		//Log("Setting key[1] as Front"@Pawn);
		KeyRot[1] = FrontRotation;
		KeyPos[1] = FrontPosition;
	}
	else
	{
		//Log("Setting key[1] as Back"@Pawn);
		KeyRot[1] = BackRotation;
		KeyPos[1] = BackPosition;
	}
}

//------------------------------------------------------------------------
// Description		
//		Returns true if linked to something
//------------------------------------------------------------------------
function bool HasSpecialOpener()
{
	return FrontOpener != MyKnob || BackOpener != MyKnob;
}

//------------------------------------------------------------------------
// Description		
//		Movement abortion need to inform Controller
//------------------------------------------------------------------------
function MakeGroupReturn(Actor Other)
{
	if (EDoorInteraction(MyKnob.Interaction).ActiveController != None &&
		EDoorInteraction(MyKnob.Interaction).ActiveController.bIsPlayer)
		EDoorInteraction(MyKnob.Interaction).ActiveController.EndEvent();

	if (EDoorInteraction(MyKnob.Interaction).StealthInteraction != None &&
		EDoorInteraction(MyKnob.Interaction).StealthInteraction.ActiveController != None &&
		EDoorInteraction(MyKnob.Interaction).StealthInteraction.ActiveController.bIsPlayer)
		EDoorInteraction(MyKnob.Interaction).StealthInteraction.ActiveController.EndEvent();

	Super.MakeGroupReturn(Other);
}

//------------------------------------------------------------------------
// Description		
//		We have to overload to choose opening direction
//------------------------------------------------------------------------
function DoOpen()
{
	local EPawn		Pawn;
	local EGroupAI	TmpOpenGroupAi;

	// DoOpen should not set opening direction if it is encrohacing, keep previous
	if (bClosing)
	{
		Super.DoOpen();
		return;
	}

	Pawn = EPawn(SavedTrigger);
	if (Pawn != None)
		SetOpeningDirection(Pawn);

	// When Npc finally opens door
	if (EAIPawn(SavedTrigger) != None)
		ResetNpcVars();

	// Prevent lauching pattern in begin stealth
	TmpOpenGroupAi = OpenGroupAi;
	if (GetStateName() == 'TriggerToggle')
		OpenGroupAi = None;
	
	Super.DoOpen();
	
	// Restore Group Ai
	OpenGroupAi = TmpOpenGroupAi;
}

//------------------------------------------------------------------------
// Description		
//		Pass event if door is unlocked
//------------------------------------------------------------------------
function Bump(actor Other, optional int Pill)
{
	local EPawn Pawn;
	
	if (Locked || !bClosed)
	{
		//Log(self$" is locked");
		return;
	}

	Pawn = EPawn(Other);
	if (Pawn == None)
		return;

		SetOpeningDirection(Pawn);
		Super.Bump(Other, Pill);
	}

//------------------------------------------------------------------------
// Description		
//		Door openers only unlocks door + procesing for both Player and Npcs
//------------------------------------------------------------------------
function OpenerTrigger(EDoorOpener Other, Pawn EventInstigator)
{
	if (Other == None)
		return;

		// Retinal scanner or Keypad should unlock doors only if it's sam using them.
		if (EventInstigator.Controller.bIsPlayer)
		{
			// Once unlock, toggle door interaction on
			MyKnob.ToggleInteraction(true);
			// Using the opener unlocks the door
			Locked = false;

			// Once unlocked by player, assign myknob to this door 
			FrontOpener = MyKnob;
			BackOpener	= MyKnob;
		}
		else
		{
			// Npcs should hack their own vars
			AIFrontOpener = MyKnob;
			AIBackOpener  = MyKnob;
		}
}

//------------------------------------------------------------------------
// Description		
//		Check if door can be opened
//------------------------------------------------------------------------
function bool CanDoTrigger(Actor Other, Pawn EventInstigator)
{
	//Log(self$" get triggered by"@other@EventInstigator@savedtrigger);
	//Log("Opening["$bOpening$"] Closing["$bClosing$"] Closed["$bClosed$"] InUse["$bInUse$"]");

	// Make sure this is set here too
	if (EAIPawn(SavedTrigger) != None)
		ResetNpcVars();

	//Log("	Triggered ...");
	return !bKindaInUse && Super.CanDoTrigger(Other, EventInstigator);
}

// Npc should call this
function EInteractObject GetInteraction(Pawn InteractPawn)
{
	if (InteractPawn.Controller.bIsPlayer)
		return Super.GetInteraction(InteractPawn);
	else
	{
		// Use Npc hacky vars
		if (GetPawnSide(InteractPawn) == ESide_Front && AIFrontOpener != None)
			return AIFrontOpener.GetInteraction(InteractPawn);	// can be None
		else if (GetPawnSide(InteractPawn) == ESide_Back && AIBackOpener != None)
			return AIBackOpener.GetInteraction(InteractPawn);	// can be None
		else
			return None;
	}
}

function StayOpen(Actor Other, bool pawnOpen, bool playerOpen)
{
	// On Npc call, force stay open if used by optic cable
	pawnOpen = pawnOpen || bKindaInUse;
	// On Npc call, abort if opened stealth by player
	pawnOpen = pawnOpen && !bSteatlh;

	Super.StayOpen(Other, pawnOpen, playerOpen);
}

// Joshua - Option to randomize lock pick combinations
function RandomizeLockPattern()
{
    local int i;
    
    // Skip if all combinations are PL_None
    if (Combinaison[0] == PL_None && 
       Combinaison[1] == PL_None &&
       Combinaison[2] == PL_None &&
       Combinaison[3] == PL_None &&
       Combinaison[4] == PL_None &&
       Combinaison[5] == PL_None)
    {
        return;
    }

    // Randomize each non-None position
    for (i = 0; i < 6; i++)
    {
        if (Combinaison[i] != PL_None)
        {
            switch (Rand(4))
            {
                case 0: Combinaison[i] = PL_UpLeft; break;
                case 1: Combinaison[i] = PL_UpRight; break;
                case 2: Combinaison[i] = PL_DownLeft; break;
                case 3: Combinaison[i] = PL_DownRight; break;
            }
        }
    }
}

defaultproperties
{
    KnobOffsetX=120
    TimePerQuadrant=1.000000
    TiltPerQuadrant=5
    MoveThreshold=0.100000
    OpeningSound=Sound'Door.Play_WoodDoorOpen'
    OpeningStealthSound=Sound'Door.Play_WoodDoorOpenSilent'
    ClosedSound=Sound'Door.Play_WoodDoorClose'
}