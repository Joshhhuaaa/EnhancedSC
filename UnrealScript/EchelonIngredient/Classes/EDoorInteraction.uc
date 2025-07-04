class EDoorInteraction extends EInteractObject;

var ESwingingDoor	MyDoor;
var bool			LeftSideInteraction;
var Controller		ActiveController;

var EDoorStealthInteraction StealthInteraction;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	MyDoor = ESwingingDoor(Owner.Owner);
	if( MyDoor == None )
		Log("WARNING : EDoorInteraction does not have a matching EDoorMover");

    // Spawn stealth interaction
	if (StealthInteraction == None)
    	StealthInteraction = Spawn(class'EDoorStealthInteraction', Owner);
    StealthInteraction.MyDoor = MyDoor;
}

function string	GetDescription()
{
 	return Localize("Interaction", "Door0", "Localization\\HUD");
}

function bool IsAvailable()
{
	local vector PawnDir, OwnerDir;

	// Check how high keyboard is compared to player Z.  12-15 being the perfect height.
	if( Abs(InteractionPlayerController.Pawn.Location.Z - Owner.Location.Z) > 50 )
		return false;

	return Super.IsAvailable();
}

function InitInteract( Controller Instigator )
{
	// set controller's interaction
	Instigator.Interaction = self;
	ActiveController = Instigator;

	// Get door opening direction
	LeftSideInteraction = MyDoor.GetPawnSide(EPawn(Instigator.Pawn)) == ESide_Front;
	//Log("	Left side? "@LeftSideInteraction);

	if( Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting' )
		EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';
	
	// If door is not locked, open it (no animation)
	if( MyDoor.Locked || !MyDoor.Usable )
	{
		//Log("		Locked");
		if( LeftSideInteraction )
			Instigator.GotoState('s_OpenDoor', 'LockedLt');
		else
			Instigator.GotoState('s_OpenDoor', 'LockedRt');
	}
	else
	{
		if( LeftSideInteraction )
		{
			//Log("		Open left");
			Instigator.GotoState('s_OpenDoor', 'UnLockedLt');
		}
		// Interact right
		else
		{
			//Log("		Open right");
			Instigator.GotoState('s_OpenDoor', 'UnLockedRt');
		}
	}
}

function Interact( Controller Instigator )
{
	if( (!MyDoor.Locked || !Instigator.bIsPlayer) && !MyDoor.IsOpened() )
		MyDoor.Trigger(Instigator.Pawn, Instigator.Pawn);

	if( MyDoor.Locked )
		MyDoor.PlaySound(MyDoor.LockedSound, SLOT_SFX);
}

function PostInteract( Controller Instigator )
{
	if( MyDoor.Locked )
	{
		// Send transmission if Player
		if( Instigator.bIsPlayer && EPlayerController(Instigator) != None)
			EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "DoorLock", "Localization\\HUD"), TR_CONSOLE);
	}
	else if( !MyDoor.Usable )
	{
		// Send transmission if Player
		if( Instigator.bIsPlayer && EPlayerController(Instigator) != None)
			EPlayerController(Instigator).SendTransmissionMessage(Localize("Transmission", "DoorJam", "Localization\\HUD"), TR_CONSOLE);
	}
}

function SetInteractLocation( Pawn InteractPawn )
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	local vector HitLocation, HitNormal;

	InteractEPawn = EPawn(InteractPawn);
	if( InteractEPawn == None )
		return;

	GetAxes(Owner.Rotation, X, Y, Z);

	// switch Y angle
	if( !LeftSideInteraction )
		Y = -Y;
	
	MovePos	= Owner.Location;
	if( InteractEPawn.bIsPlayerPawn )
	{
			MovePos -= 1.2f * InteractEPawn.CollisionRadius * Y;
	}
	else
	{
		MovePos	-= 1.2f * InteractEPawn.CollisionRadius * Y;
	}
	MovePos -= 1.3f * InteractEPawn.CollisionRadius * X;


	if(InteractEPawn.bIsPlayerPawn)
	{
	MovePos.Z = InteractEPawn.Location.Z;	// keep on same Z
	}
	else
	{
		if( Trace(HitLocation, HitNormal, MovePos + vect(0,0,-200), MovePos,,,,,true) != None )
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

    if (MyDoor.bClosed && InteractionPlayerController.CanAddInteract(self) && IsAvailable())
    {
        InteractionPlayerController.IManager.AddInteractionObj(Self);
        InteractionPlayerController.IManager.AddInteractionObj(StealthInteraction);
    }
    else
        UnTouch(Other);
}

function UnTouch(actor Other)
{
    local Pawn P;
    P = Pawn(Other);
    if (P == None || !P.bIsPlayerPawn || InteractionPlayerController == None)
        return;

    InteractionPlayerController.IManager.RemoveInteractionObj(Self);
    InteractionPlayerController.IManager.RemoveInteractionObj(StealthInteraction);
    InteractionPlayerController = None;
}

defaultproperties
{
    iPriority=5000
}