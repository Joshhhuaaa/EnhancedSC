class EDoorMover extends Mover
	abstract
	native;

#exec OBJ LOAD FILE=..\StaticMeshes\Generic_Mesh.usx

enum EDoorSide
{
	ESide_Front,
	ESide_Back,
};

var(Door)	EAlarm		Alarm;				// Associated ZoneAlarm
var(Door)	bool		Usable;				// If true, door can be used, else, blocked (from pattern, deco door, etc...)
var(Door)	bool		Locked;
var			bool		bInUse;				// optic cable, stealth
var			bool		bTempNoCollide;		// used during path building
var			Controller	UsingController;	// Controller who is using us
var(Door)	EDoorOpener	FrontOpener,
						BackOpener;			// Controller (EKeyPad or ERetinalScanner .. 
var(Door)	EDoorMover	LinkedDoor;			// In case double door and wants to remove open interaction

// used for generating EDoorMarker at appropriate location
var(Door)	float		DoorWidth;
var(Door)	float		DoorRadius;

var(Door)	float		DoorPathExtraCost;
var(Door)	bool		bNoPlayerStayOpen;

// AI Pattern trigger
var(AI)	EGroupAI		OpenGroupAi;
var(AI) name			OpenJumpLabel;
var(AI)	bool			bOpenTriggerOnceOnly;
var		bool			bOpenAlreadyTriggered;

var(AI)	EGroupAI		CloseGroupAi;
var(AI) name			CloseJumpLabel;
var(AI)	bool			bCloseTriggerOnceOnly;
var		bool			bCloseAlreadyTriggered;

var(Door)   bool        bPropagatesSound;

native(1558) final function PropagateSound(Actor oOriginalWallHit);

function PostBeginPlay()
{
	// Inform Alarm I'm an object to trigger
	if (Alarm != None)
		Alarm.LinkObject(self);

	// Link openers to self
	if (FrontOpener != None)
		FrontOpener.LinkActor(self);
	if (BackOpener != None)
		BackOpener.LinkActor(self);

    // Support doors specified as usable by designers
        SetUsable(Usable);

	// Make sure LD did not mess up
	if (InitialState == 'BumpOpenTimed')
		BumpType = BT_PawnBump;

	Super.PostBeginPlay();
}

//---------------------------------------[Matthew Clarke - Sept 9 2002]-----
// 
// Description
//
//------------------------------------------------------------------------
function SetUsable (bool _bUsable)
{
    Usable = _bUsable;

    if (myMarker != None)
    {
        myMarker.bBlocked = !_bUsable; 
    }
}

//---------------------------------------[David Kalina - 28 Nov 2001]-----
// 
// Description
//		Returns which side of the door the pawn is on given the CURRENT LOCATION/ROTATION of the door.
//
//------------------------------------------------------------------------

function EDoorSide GetPawnSide(Pawn A)
{
	// NOTE : using BaseRot and BasePos instead of Rotation and Location (because they change during gameplay)

	if (((Vect(1,0,0) >> Rotation) Cross (A.Location - Location)).Z <= 0)
	{
		//Log("Bump in front"@FrontOpener);
		return ESide_Front;
	}
	else
	{
		//Log("Bump on back"@BackOpener);
		return ESide_Back;
	}
}

//---------------------------------------[David Kalina - 28 Nov 2001]-----
// 
// Description
//		Returns which side of the door an actor is on given the INITIAL LOCATION / ROTATION of the door.
//------------------------------------------------------------------------

event EDoorSide GetActorSide(Actor A)
{
	// NOTE : using BaseRot and BasePos instead of Rotation and Location (because they change during gameplay)
	
	if (((Vect(1,0,0) >> BaseRot) Cross (A.Location - BasePos)).Z <= 0)
	{
		//Log("Bump in front"@FrontOpener);
		return ESide_Front;
	}
	else
	{
		//Log("Bump on back"@BackOpener);
		return ESide_Back;
	}
}

//----------------------------------------[David Kalina - 9 May 2002]-----
// 
// Description
//		Checking an open door to see what side of the frame it's on.
//		Results are invalid if the door is closed, so it shouldn't be called in that situation.
// 
//------------------------------------------------------------------------

event EDoorSide GetDoorSide()
{
	if (((Vect(1,0,0) >> Rotation) cross (Vect(1,0,0) >> BaseRot)).Z <= 0)
		return ESide_Back;
	else
		return ESide_Front;
}


function EInteractObject GetInteraction(Pawn InteractPawn)
{
	if (GetPawnSide(InteractPawn) == ESide_Front && FrontOpener != None)
		return FrontOpener.GetInteraction(InteractPawn);	// can be None
	else if (GetPawnSide(InteractPawn) == ESide_Back && BackOpener != None)
		return BackOpener.GetInteraction(InteractPawn);	// can be None
	else
		return None;
}

//------------------------------------------------------------------------
// Description		
//		Returns true if linked to something
//------------------------------------------------------------------------
function bool HasSpecialOpener()
{
	return FrontOpener != None || BackOpener != None;
}

//------------------------------------------------------------------------
// Description		
//		Allow special processing in subclasses
//------------------------------------------------------------------------
function bool CanOpenSpecial()
{
	return false;
}

//------------------------------------------------------------------------
// Description		
//		Allow opener processing on sub-classes independently of Trigger availability
//------------------------------------------------------------------------
function OpenerTrigger(EDoorOpener Other, Pawn EventInstigator)
{
	Trigger(Other, EventInstigator);
}

//------------------------------------------------------------------------
// Description		
//		Allow special trigger processing in subclasses
//------------------------------------------------------------------------
function bool CanDoTrigger(Actor Other, Pawn EventInstigator)
{
	return Usable;
}

//------------------------------------------------------------------------
// Description		
//		Will manually call a trigger on the door
// Conditions:
//		Will work in default state (TriggerOpenTimed)
//		For now, bumpingactor needs to be a pawn
//------------------------------------------------------------------------
function Bump(actor Other, optional int Pill)
{
	local EPawn  P;
	
	//Log(Other$" Bumps in Door mover "$self);

	// if door locked
	if (Locked || !bClosed)
	{
		//Log(self$" is locked");
		return;
	}

	// Needs to be an EPawn
	P = EPawn(Other);
	if (P == None)
		return;

	// If door is opened by door opener AND no special Case of opening
	if (GetInteraction(P) != None && !CanOpenSpecial())
	{
		//Log(self@GetInteraction(P) != None@!CanOpenSpecial());
		return;
	}

	// do the trigger
		Trigger(P,P);
}

//------------------------------------------------------------------------
// Description		Return true if door is completely opened
//------------------------------------------------------------------------
function bool IsOpened()
{
	return !bClosed;
}

//------------------------------------------------------------------------
// Description		Disable interaction from the moment the door opens
//------------------------------------------------------------------------
function DoOpen()
{
	if (bOpening)
		return;

	Super.DoOpen();

	// Turn off interaction(s) on Openers only if it's knob
	if (!HasSpecialOpener())
	{
		if (FrontOpener != None)
			FrontOpener.ToggleInteraction(false);
		if (BackOpener != None)
			BackOpener.ToggleInteraction(false);

		// Turn off interaction(s) on LinkedDoor
		if (LinkedDoor != None)
		{
			if (LinkedDoor.FrontOpener != None)
				LinkedDoor.FrontOpener.ToggleInteraction(false);
			if (LinkedDoor.BackOpener != None)
				LinkedDoor.BackOpener.ToggleInteraction(false);
		}
	}

	//send an EventTrigger when the door opens
	if (OpenGroupAi == None)
		return;
	if (bOpenAlreadyTriggered && bOpenTriggerOnceOnly)
		return;

	bOpenAlreadyTriggered = true;
	OpenGroupAi.SendJumpEvent(OpenJumpLabel,false,false);
}

//------------------------------------------------------------------------
// Description		Enables the interaction once the door closes
//------------------------------------------------------------------------
function FinishedClosing()
{
	// If door was in changed actors list from Player, will remove it
	Level.RemoveChange(self);

	// Turn on interaction(s) on Opener if player
	if (!HasSpecialOpener())
	{
		if (FrontOpener != None)
			FrontOpener.ToggleInteraction(true);
		if (BackOpener != None)
			BackOpener.ToggleInteraction(true);

		// Turn on interaction(s) on LinkedDoor
		if (LinkedDoor != None)
		{
			if (LinkedDoor.FrontOpener != None)
				LinkedDoor.FrontOpener.ToggleInteraction(true);
			if (LinkedDoor.BackOpener != None)
				LinkedDoor.BackOpener.ToggleInteraction(true);
		}
	}

	// Do this after to have a valid SavedTrigger
	Super.FinishedClosing();

	// NotifyAI
	if (CloseGroupAi == None)
		return;
	if (bCloseAlreadyTriggered && bCloseTriggerOnceOnly)
		return;

	bCloseAlreadyTriggered = true;
	CloseGroupAi.SendJumpEvent(CloseJumpLabel,false,false);
}

//------------------------------------------------------------------------
// Description		
//		Leave Global Trigger here .. call from any other states
//------------------------------------------------------------------------
function Trigger(Actor Other, Pawn EventInstigator, optional name Intag)
{
	CanDoTrigger(Other, EventInstigator);
}

event StayOpen(Actor Other, bool pawnOpen, bool playerOpen)
{
	if (bClosed)
	{
		//Log(self$" NEVER EVER!!!! Call stay open on a closed door");
		return;
	}
	if ((!bNoPlayerStayOpen && playerOpen) || pawnOpen)
	{
		GotoState('s_StayOpen');

		if (LinkedDoor != None && Other != LinkedDoor && !LinkedDoor.bSlave)
		{
			LinkedDoor.bSlave = true;
			LinkedDoor.StayOpen(self, pawnOpen, playerOpen);
			LinkedDoor.bSlave = false;
		}
	}
}

state s_StayOpen
{
	Ignores Trigger;

	function BeginState()
	{		
		if (bClosed)
			Log(self$" In s_StayOpen but closes PROBLEM!!!!");
		SetTimer(StayOpenTime, false);
	}

	function StayOpen(Actor Other, bool pawnOpen, bool playerOpen)
	{
		if ((!bNoPlayerStayOpen && playerOpen) || pawnOpen)
		{
			BeginState();

			if (LinkedDoor != None && Other != LinkedDoor && !LinkedDoor.bSlave)
			{
				LinkedDoor.bSlave = true;
				LinkedDoor.StayOpen(self, pawnOpen, playerOpen);
				LinkedDoor.bSlave = false;
			}
		}
	}

	function Timer()
	{
		GotoState(InitialState, 'Close');
	}

begin:
	FinishInterpolation();
	FinishedOpening();
}

// Must leave it between state call to prevent calling the one from base class Mover
state TriggerOpenTimed
{
	function Trigger(Actor Other, Pawn EventInstigator, optional name Intag)
	{
		// Do not move this to global.trigger, since Super.Trigger will call the non-existant mover global.trigger function. 
		// So wouldn't do anything!
		if (CanDoTrigger(Other, EventInstigator))
			Super.Trigger(Other, EventInstigator, Intag);
	}
}

// If door has been kicked, ignore stayopen
state TriggerToggle
{
	Ignores StayOpen;
}

defaultproperties
{
    Usable=True
    DoorWidth=128.000000
    DoorRadius=160.000000
    DoorPathExtraCost=500.000000
    bOpenTriggerOnceOnly=True
    bCloseTriggerOnceOnly=True
    bUseTriggered=True
    InitialState="TriggerOpenTimed"
    CollisionRadius=10.000000
    CollisionHeight=10.000000
    CollisionPrimitive=StaticMesh'Generic_Mesh.Door.door_gen'
    bBlockPlayers=False
    bBlockActors=False
    bBlockCamera=False
    bCPBlockPlayers=True
    bCPBlockActors=True
    bCPBlockCamera=True
    bDirectional=True
}