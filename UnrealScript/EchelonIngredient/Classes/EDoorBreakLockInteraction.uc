class EDoorBreakLockInteraction extends EInteractObject;

var ESwingingDoor MyDoor;
var Controller ActiveController;
var bool LeftSideInteraction;

function string GetDescription()
{
    return Localize("InventoryItem", "DisposablePick", "Localization\\HUD");
}

function bool IsAvailable()
{
    // Only available for locked doors when using the new door interaction system
    if (EchelonGameInfo(Level.Game).bNewDoorInteraction && MyDoor.Locked)
    {
        return true;
    }

    return false;
}

function InitInteract(Controller Instigator)
{
    local EDisposablePick PickItem;

    // Set controller's interaction
    Instigator.Interaction = self;
    ActiveController = Instigator;

    // Get door opening direction
    LeftSideInteraction = MyDoor.GetPawnSide(EPawn(Instigator.Pawn)) == ESide_Front;

    if (Instigator.bIsPlayer)
    {
        EPlayerController(Instigator).GotoState('s_PlayerWalking');

        PickItem = EDisposablePick(EPawn(Instigator.Pawn).FullInventory.GetItemByClass('EDisposablePick'));
        if (PickItem != None)
        {
            // Unequip current weapon if any
			if (EPawn(Instigator.Pawn).WeaponStance > 0)
	            EPawn(Instigator.Pawn).Transition_WeaponAway();

            PickItem.GotoState('s_Selected', 'AutoUse');
        }
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

    MovePos = Owner.Location;
    if (InteractEPawn.bIsPlayerPawn)
    {
        MovePos -= 1.2f * InteractEPawn.CollisionRadius * Y;
    }
    else
    {
        MovePos -= 1.2f * InteractEPawn.CollisionRadius * Y;
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

    InteractEPawn.m_locationStart = InteractEPawn.Location;
    InteractEPawn.m_orientationStart = InteractEPawn.Rotation;
    InteractEPawn.m_locationEnd = MovePos;
    InteractEPawn.m_orientationEnd = Rotator(Y);
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
    iPriority=5002
}