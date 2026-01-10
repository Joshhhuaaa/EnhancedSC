class EDoorStealthInteraction extends EInteractObject;

var ESwingingDoor MyDoor;
var Controller ActiveController;
var bool LeftSideInteraction;

var bool			bStealthOpenDoor;
var bool			bInterrupted;
var Rotator			backupKeyRotation;
var float			backupMoveTime;
var bool			backupPlayerStayOpen;
var bool			bStoppedPushing;

function string GetDescription()
{
    return Localize("Interaction", "Door1", "Localization\\HUD");
}

function bool IsAvailable()
{
    // Hide the stealth interaction for locked doors if using the new door interaction system
    if (EchelonGameInfo(Level.Game).bNewDoorInteraction && MyDoor.Locked)
    {
        return false;
    }

    // Find the main door interaction and checking if it's available
    if (MyDoor.MyKnob != None && MyDoor.MyKnob.Interaction != None &&
        EDoorInteraction(MyDoor.MyKnob.Interaction) != None)
    {
        return EDoorInteraction(MyDoor.MyKnob.Interaction).IsAvailable();
    }

    return Super.IsAvailable();
}

function InitInteract(Controller Instigator)
{
	// Reset value
	bStealthOpenDoor = false;
	bInterrupted = false;
	bStoppedPushing = false;

    Instigator.Interaction = self;
    ActiveController = Instigator;
    LeftSideInteraction = MyDoor.GetPawnSide(EPawn(Instigator.Pawn)) == ESide_Front;

	// Joshua - Replaced below with holster
    //if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
    //    EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';

    if (MyDoor.Locked || !MyDoor.Usable)
    {
        // Play locked/jammed animation, do not try to stealth open
		// Joshua - Holster weapon before trying to open locked/jammed door
		if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
		{
			// Joshua - Disable re-drawing weapon after Open Door Stealth
			//EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';

			if (LeftSideInteraction)
				Instigator.GotoState('s_OpenDoor', 'HolsterThenLockedLt');
			else
				Instigator.GotoState('s_OpenDoor', 'HolsterThenLockedRt');
		}
		else
		{
			if (LeftSideInteraction)
				Instigator.GotoState('s_OpenDoor', 'LockedLt');
			else
				Instigator.GotoState('s_OpenDoor', 'LockedRt');
		}
    }
    else
    {
		MyDoor.bInUse = true;
		EPlayerController(Instigator).m_BTWSide = !LeftSideInteraction;
		// Joshua - Holstering weapon before opening door
        if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
        {
			// Joshua - Disable re-drawing weapon after Open Door Stealth
            //EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';
            Instigator.GotoState('s_OpenDoorStealth', 'HolsterThenStealth');
        }
		else
		{
			// Only do stealth open if door is unlocked and usable
			Instigator.GotoState('s_OpenDoorStealth', 'BeginStealth');
		}
    }
}

function Interact(Controller Instigator)
{
	if ((!MyDoor.Locked || !Instigator.bIsPlayer) && !MyDoor.IsOpened())
	{
		// Joshua - Only apply if door is usable (not jammed)
		if (Instigator.bIsPlayer && MyDoor.Usable)
		{
			if (LeftSideInteraction)
			{
				backupKeyRotation = MyDoor.FrontRotation;
				MyDoor.FrontRotation = MyDoor.Rotation;
				MyDoor.FrontRotation.Yaw = 2000;
			}
			else
			{
				backupKeyRotation = MyDoor.BackRotation;
				MyDoor.BackRotation = MyDoor.Rotation;
				MyDoor.BackRotation.Yaw = -2000;
			}

			backupMoveTime = MyDoor.MoveTime;
			backupPlayerStayOpen = MyDoor.bNoPlayerStayOpen;
			MyDoor.bNoPlayerStayOpen = true;
			MyDoor.bSteatlh = true;
			MyDoor.MoveTime	*= 0.5f;
			MyDoor.bTriggerOnceOnly = true;
			MyDoor.bInUse = true;
		}

		MyDoor.Trigger(Instigator.Pawn, Instigator.Pawn);
	}

	if (MyDoor.Locked)
		MyDoor.PlaySound(MyDoor.LockedSound, SLOT_SFX);
}


function PostInteract(Controller Instigator)
{
	if (MyDoor.Locked)
	{
		// Send transmission if Player
		if (Instigator.bIsPlayer && EPlayerController(Instigator) != None)
			EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "DoorLock", "Localization\\HUD"), TR_CONSOLE);
	}
	else if (!MyDoor.Usable)
	{
		// Send transmission if Player
		if (Instigator.bIsPlayer && EPlayerController(Instigator) != None)
			EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "DoorJam", "Localization\\HUD"), TR_CONSOLE);
	}
	else
	{
		// Only restore stealth values if they were applied (door was usable when interact was called)
		if (MyDoor.bSteatlh)
		{
			// Restore values
			if (LeftSideInteraction)
			{
				MyDoor.FrontRotation = backupKeyRotation;
			}
			else
			{
				MyDoor.BackRotation = backupKeyRotation;
			}

			MyDoor.bTriggerOnceOnly = false;
			MyDoor.bNoPlayerStayOpen = backupPlayerStayOpen;
			MyDoor.bSteatlh = false;
			MyDoor.bInUse = false;
			MyDoor.MoveTime = backupMoveTime;
		}

		// Wanna open door in stealth mode
		if (bStealthOpenDoor)
		{
			if (!bInterrupted)
			{
				MyDoor.GotoState('TriggerOpenTimed','Open');
				Instigator.GotoState(,'OpenDoor');
			}
			else
			{
				Instigator.GotoState(,'InterruptOpening');
			}
		}
		// Interruption while trying to open door
		else if (bInterrupted)
		{
			Instigator.GotoState(,'InterruptStealth');
		}
		// Wanna close it .. check for interruption
		else
		{
			MyDoor.GotoState('TriggerOpenTimed','Close');
			Instigator.GotoState(,'CloseDoor');
		}
	}
}

function KeyEvent(String Key, EInputAction Action, FLOAT Delta, optional bool bAuto)
{
	local bool StillMoving;

	StillMoving = MyDoor.bOpening || MyDoor.bInterpolating; // prevent opening before door finishes its movement

	switch (Key)
	{
	case "Neutral" :
		if (StillMoving) break;
		bStoppedPushing = true;
		break;

	case "Forward" :
		if (StillMoving) break;
		bStealthOpenDoor = true;
		PostInteract(ActiveController);
		break;

	case "Backward" :
		if (StillMoving || !bStoppedPushing) break;
		bStealthOpenDoor = false;
		PostInteract(ActiveController);
		break;

	case "Interrupted" :
		bInterrupted = true;
		PostInteract(ActiveController);
		break;
	}
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	local vector HitLocation, HitNormal;

	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn == None)
		return;

	GetAxes(Owner.Rotation, X, Y, Z);

	// switch Y angle
	if (!LeftSideInteraction)
		Y = -Y;

	MovePos	= Owner.Location;
	if (InteractEPawn.bIsPlayerPawn)
	{
		MovePos -= 1.2f * InteractEPawn.CollisionRadius * Y;
	}
	else
	{
		MovePos	-= 1.2f * InteractEPawn.CollisionRadius * Y;
	}
	MovePos -= 1.3f * InteractEPawn.CollisionRadius * X;


	if (InteractEPawn.bIsPlayerPawn)
	{
	    MovePos.Z = InteractEPawn.Location.Z; // keep on same Z
	}
	else
	{
		if (Trace(HitLocation, HitNormal, MovePos + vect(0,0,-200), MovePos,,,,,true) != None)
		{
			HitLocation.Z += InteractEPawn.CollisionHeight;
			MovePos = HitLocation;
		}
	}

	InteractEPawn.m_locationStart	= InteractEPawn.Location;
	InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd		= MovePos;
	InteractEPawn.m_orientationEnd	= Rotator(Y);
}

function Touch(actor Other)
{
    local Pawn P;
    P = Pawn(Other);
    if (P == None || !P.bIsPlayerPawn || P.Controller == None)
        return;

    InteractionPlayerController = PlayerController(P.Controller);
}

function UnTouch(actor Other)
{
    local Pawn P;
    P = Pawn(Other);
    if (P == None || !P.bIsPlayerPawn || P.Controller == None)
        return;

    InteractionPlayerController = None;
}

defaultproperties
{
    iPriority=5001
}