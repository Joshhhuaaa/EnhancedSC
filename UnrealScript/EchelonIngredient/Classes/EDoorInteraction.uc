class EDoorInteraction extends EInteractObject;

var ESwingingDoor	MyDoor;
var bool			LeftSideInteraction;
var Controller		ActiveController;

var EDoorStealthInteraction StealthInteraction;
var EDoorBreakLockInteraction BreakLockInteraction;
var EDoorOpticalInteraction OpticalInteraction;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	MyDoor = ESwingingDoor(Owner.Owner);
	if (MyDoor == None)
		Log("WARNING : EDoorInteraction does not have a matching EDoorMover");

    // Spawn stealth interaction
	if (StealthInteraction == None)
    	StealthInteraction = Spawn(class'EDoorStealthInteraction', Owner);
    StealthInteraction.MyDoor = MyDoor;
    
    // Spawn break lock interaction
    if (BreakLockInteraction == None)
        BreakLockInteraction = Spawn(class'EDoorBreakLockInteraction', Owner);
    BreakLockInteraction.MyDoor = MyDoor;

    // Spawn optical interaction
	if (OpticalInteraction == None && !ESwingingDoor(Owner.Owner).NoOpticCable)
		OpticalInteraction = Spawn(class'EDoorOpticalInteraction', Self);
    OpticalInteraction.MyDoor = MyDoor;

}

function string GetDescription()
{
	if (EchelonGameInfo(Level.Game).bNewDoorInteraction)
	{
		if (MyDoor.Locked)
			return Localize("InventoryItem", "Lockpick", "Localization\\HUD");
		else
			return Localize("Interaction", "Door0", "Localization\\HUD");
	}
	else
		return Localize("Interaction", "Door0", "Localization\\HUD");
}

function bool IsAvailable()
{
    local vector PawnDir, OwnerDir;

    // Check how high keyboard is compared to player Z.  12-15 being the perfect height.
    if (Abs(InteractionPlayerController.Pawn.Location.Z - Owner.Location.Z) > 50)
        return false;

    if (InteractionPlayerController == None)
        return Super.IsAvailable();

    if (EchelonGameInfo(Level.Game).pPlayer.EPawn == None)
        return Super.IsAvailable();

	// Joshua - While carrying a body, hide the lockpick interaction
	if (MyDoor.Locked)
	{
		if (EchelonGameInfo(Level.Game).pPlayer.m_AttackTarget != None && EchelonGameInfo(Level.Game).pPlayer.m_AttackTarget.GetStateName() == 's_Carried')
		{
			return false;
		}
	}

    // Joshua - Handle weapon state changes for all interactions
    if (EchelonGameInfo(Level.Game).pPlayer.GetStateName() == 's_FirstPersonTargeting')
    {
        // Remove interactions when weapon is drawn
        InteractionPlayerController.IManager.RemoveInteractionObj(BreakLockInteraction);
        InteractionPlayerController.IManager.RemoveInteractionObj(OpticalInteraction);
        // Also remove main door interaction if it's for lockpicking in new door system
        if (EchelonGameInfo(Level.Game).bNewDoorInteraction && MyDoor.Locked)
            InteractionPlayerController.IManager.RemoveInteractionObj(Self);
    }
	// Joshua - When carrying a body, remove Break Lock, Optic Cable, and Open Door Stealth
    else if (EchelonGameInfo(Level.Game).pPlayer.m_AttackTarget != None && EchelonGameInfo(Level.Game).pPlayer.m_AttackTarget.GetStateName() == 's_Carried')
    {
        InteractionPlayerController.IManager.RemoveInteractionObj(BreakLockInteraction);
        InteractionPlayerController.IManager.RemoveInteractionObj(OpticalInteraction);
        InteractionPlayerController.IManager.RemoveInteractionObj(StealthInteraction);
        // Joshua - Remove Lock Pick interaction if using new door interaction system
        if (EchelonGameInfo(Level.Game).bNewDoorInteraction && MyDoor.Locked)
            InteractionPlayerController.IManager.RemoveInteractionObj(Self);
    }
    else
    {
        // Joshua - Re-add interactions when weapon is put away
        if (MyDoor.bClosed && InteractionPlayerController.CanAddInteract(self) && EchelonGameInfo(Level.Game).bNewDoorInteraction)
        {
            // Re-add lockpick interaction
            if (!MyDoor.Locked || (ELockpick(EchelonGameInfo(Level.Game).pPlayer.EPawn.FullInventory.GetItemByClass('ELockpick')) != None && !MyDoor.HasSpecialOpener()))
                InteractionPlayerController.IManager.AddInteractionObj(Self);

            // Re-add disposable pick interaction - door must be locked
            if (MyDoor.Locked && EDisposablePick(EchelonGameInfo(Level.Game).pPlayer.EPawn.FullInventory.GetItemByClass('EDisposablePick')) != None && !MyDoor.HasSpecialOpener())
            {
                BreakLockInteraction.MyDoor = MyDoor;
                InteractionPlayerController.IManager.AddInteractionObj(BreakLockInteraction);
            }

            // Re-add optic cable interaction
            if (EOpticCable(EchelonGameInfo(Level.Game).pPlayer.EPawn.FullInventory.GetItemByClass('EOpticCable')) != None && !MyDoor.NoOpticCable)
            {
                OpticalInteraction.InteractionPlayerController = InteractionPlayerController;
                InteractionPlayerController.IManager.AddInteractionObj(OpticalInteraction);
            }
        }
    }

    return Super.IsAvailable();
}

function InitInteract(Controller Instigator)
{
	local ELockpick LockpickItem; // Joshua - Add lockpick interaction
	local EDisposablePick DisposablePickItem; // Joshua - Add disposable pick interaction
	local EOpticCable OpticCableItem; // Joshua - Add optical cable interaction

	// set controller's interaction
	Instigator.Interaction = self;
	ActiveController = Instigator;

	// Get door opening direction
	LeftSideInteraction = MyDoor.GetPawnSide(EPawn(Instigator.Pawn)) == ESide_Front;
	//Log("	Left side? "@LeftSideInteraction);

	//	if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
	//		EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';

	// Joshua - Add lockpick interaction
	if (EchelonGameInfo(Level.Game).bNewDoorInteraction)
	{
		if (Instigator.bIsPlayer &&  MyDoor.Locked)
		{
			EPlayerController(Instigator).GotoState('s_PlayerWalking');
			
			// Check for regular lockpick first
			LockpickItem = ELockpick(EPawn(Instigator.Pawn).FullInventory.GetItemByClass('ELockpick'));
			if (LockpickItem != None)
			{
				// Unequip current weapon if any
				if (EPawn(Instigator.Pawn).WeaponStance > 0)
					EPawn(Instigator.Pawn).Transition_WeaponAway();

				LockpickItem.GotoState('s_Selected','AutoUse');
			}
			// If we got here by using a disposable pick interaction, use it instead
			else if (self == BreakLockInteraction)
			{
				DisposablePickItem = EDisposablePick(EPawn(Instigator.Pawn).FullInventory.GetItemByClass('EDisposablePick'));
				if (DisposablePickItem != None)
				{
					// Unequip current weapon if any
					if (EPawn(Instigator.Pawn).WeaponStance > 0)
						EPawn(Instigator.Pawn).Transition_WeaponAway();

					DisposablePickItem.GotoState('s_Selected','AutoUse');
				}
			}
			else if (self == OpticalInteraction)
			{
				OpticCableItem = EOpticCable(EPawn(Instigator.Pawn).FullInventory.GetItemByClass('EOpticCable'));
				if (OpticCableItem != None)	
				{
					// Unequip current weapon if any
					if (EPawn(Instigator.Pawn).WeaponStance > 0)
						EPawn(Instigator.Pawn).Transition_WeaponAway();

					OpticCableItem.GotoState('s_InteractSelected','AutoUse');
				}
			}
		}
		else
		{
			// Joshua - Replaced below with holster
			//if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
			//	EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';

			// If door is not locked, open it (no animation)
			if (MyDoor.Locked || !MyDoor.Usable)
			{
				//Log("		Locked");
				if (LeftSideInteraction)
					Instigator.GotoState('s_OpenDoor', 'LockedLt');
				else
					Instigator.GotoState('s_OpenDoor', 'LockedRt');
			}
			else
			{
				if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
				{
					EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';
					
					// Joshua - Holstering weapon before opening door
					if (LeftSideInteraction)
						Instigator.GotoState('s_OpenDoor', 'HolsterThenOpenLt');
					else
						Instigator.GotoState('s_OpenDoor', 'HolsterThenOpenRt');
				}
				else
				{
					if (LeftSideInteraction)
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
		}
	}
	else
	{
		// Joshua - Replaced below with holster
		//if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
		//	EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';

		// If door is not locked, open it (no animation)
		if (MyDoor.Locked || !MyDoor.Usable)
		{
			//Log("		Locked");
			if (LeftSideInteraction)
				Instigator.GotoState('s_OpenDoor', 'LockedLt');
			else
				Instigator.GotoState('s_OpenDoor', 'LockedRt');
		}
		else
		{
			if (Instigator.bIsPlayer && Instigator.GetStateName() == 's_FirstPersonTargeting')
			{
				EPlayerController(Instigator).JumpLabel = 'BackToFirstPerson';

				// Joshua - Holstering weapon before opening door
				if (LeftSideInteraction)
					Instigator.GotoState('s_OpenDoor', 'HolsterThenOpenLt');
				else
					Instigator.GotoState('s_OpenDoor', 'HolsterThenOpenRt');
			}
			else
			{
				if (LeftSideInteraction)
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
	}
}

function Interact(Controller Instigator)
{
	if ((!MyDoor.Locked || !Instigator.bIsPlayer) && !MyDoor.IsOpened())
		MyDoor.Trigger(Instigator.Pawn, Instigator.Pawn);

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
	MovePos.Z = InteractEPawn.Location.Z;	// keep on same Z
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

    if (MyDoor.bClosed && InteractionPlayerController.CanAddInteract(self) && IsAvailable())
    {
		if (EchelonGameInfo(Level.Game).bNewDoorInteraction)
        {
            // Joshua - Add main door interaction for unlocked doors (always available)
            // or for locked doors when weapon is not drawn (or carrying a body) and player has lockpick
			if (!MyDoor.Locked || 
				(P.Controller.GetStateName() != 's_FirstPersonTargeting' && 
				P.Controller.GetStateName() != 's_Carry' &&
				ELockpick(EPawn(P).FullInventory.GetItemByClass('ELockpick')) != None && 
				!MyDoor.HasSpecialOpener()))
            {
                InteractionPlayerController.IManager.AddInteractionObj(Self);
            }

            // Add disposable pick interaction if player doesn't have weapon drawn or carrying a body
            if (P.Controller.GetStateName() != 's_FirstPersonTargeting' && P.Controller.GetStateName() != 's_Carry')
            {
                if (MyDoor.Locked && (EDisposablePick(EPawn(P).FullInventory.GetItemByClass('EDisposablePick')) != None) && !MyDoor.HasSpecialOpener())
                {
                    BreakLockInteraction.MyDoor = MyDoor;
                    InteractionPlayerController.IManager.AddInteractionObj(BreakLockInteraction);
                }
            }

            // Add Optic Cable interaction if player doesn't have weapon drawn or carrying a body
            if (EOpticCable(EPawn(P).FullInventory.GetItemByClass('EOpticCable')) != None
            && P.Controller.GetStateName() != 's_FirstPersonTargeting'
			&& P.Controller.GetStateName() != 's_Carry'
            && !MyDoor.NoOpticCable)
            {
                OpticalInteraction.InteractionPlayerController = PlayerController(P.Controller);
                InteractionPlayerController.IManager.AddInteractionObj(OpticalInteraction);
            }
        }
        else
            InteractionPlayerController.IManager.AddInteractionObj(Self);

		// Hide Open Door Stealth if locked in new door interaction system or if player is carrying a body
		if ((!EchelonGameInfo(Level.Game).bNewDoorInteraction || !MyDoor.Locked) && P.Controller.GetStateName() != 's_Carry')
		{
			InteractionPlayerController.IManager.AddInteractionObj(StealthInteraction);
		}
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
    InteractionPlayerController.IManager.RemoveInteractionObj(BreakLockInteraction);
	InteractionPlayerController.IManager.RemoveInteractionObj(OpticalInteraction);
    InteractionPlayerController = None;
}

// Joshua - Function to refresh interactions when bNewDoorInteraction setting changes
function RefreshInteractions()
{
    local Pawn P;
    
    // Only refresh if there's a player currently in range
    if (InteractionPlayerController == None)
        return;
    
    P = InteractionPlayerController.Pawn;
    if (P == None || !P.bIsPlayerPawn)
        return;
    
    // Remove all existing interactions first
    InteractionPlayerController.IManager.RemoveInteractionObj(Self);
    InteractionPlayerController.IManager.RemoveInteractionObj(StealthInteraction);
    InteractionPlayerController.IManager.RemoveInteractionObj(BreakLockInteraction);
	InteractionPlayerController.IManager.RemoveInteractionObj(OpticalInteraction);
    
	// Add interactions based on current settings
	if (MyDoor.bClosed && InteractionPlayerController.CanAddInteract(self) && IsAvailable())
	{
		if (EchelonGameInfo(Level.Game).bNewDoorInteraction)
		{
			// Add main door interaction for unlocked doors (always available)
			// or for locked doors when weapon is not drawn and player has lockpick
			if (!MyDoor.Locked || 
				(P.Controller.GetStateName() != 's_FirstPersonTargeting' && 
				 ELockpick(EPawn(P).FullInventory.GetItemByClass('ELockpick')) != None && 
				 !MyDoor.HasSpecialOpener()))
			{
				InteractionPlayerController.IManager.AddInteractionObj(Self);
			}

			// Add disposable pick interaction if player doesn't have weapon drawn or carrying a body
			if (P.Controller.GetStateName() != 's_FirstPersonTargeting' && P.Controller.GetStateName() != 's_Carry')
			{
				if (MyDoor.Locked && (EDisposablePick(EPawn(P).FullInventory.GetItemByClass('EDisposablePick')) != None) && !MyDoor.HasSpecialOpener())
				{
					BreakLockInteraction.MyDoor = MyDoor;
					InteractionPlayerController.IManager.AddInteractionObj(BreakLockInteraction);
				}
			}
			
			// Add Optic Cable interaction if player doesn't have weapon drawn or carrying a body
			if (EOpticCable(EPawn(P).FullInventory.GetItemByClass('EOpticCable')) != None
			&& P.Controller.GetStateName() != 's_FirstPersonTargeting'
			&& P.Controller.GetStateName() != 's_Carry'
			&& !MyDoor.NoOpticCable)
			{
				OpticalInteraction.MyDoor = MyDoor;
				InteractionPlayerController.IManager.AddInteractionObj(OpticalInteraction);
			}
		}
		else
			InteractionPlayerController.IManager.AddInteractionObj(Self);

		// Hide Open Door Stealth if locked in new door interaction system or if player is carrying a body
		if ((!EchelonGameInfo(Level.Game).bNewDoorInteraction || !MyDoor.Locked) && P.Controller.GetStateName() != 's_Carry')
		{
			InteractionPlayerController.IManager.AddInteractionObj(StealthInteraction);
		}
	}
}

defaultproperties
{
    iPriority=5000
}