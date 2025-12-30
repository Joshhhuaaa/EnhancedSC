// Joshua - New antenna switch interaction for Abattoir
class EAntennaSwitchAbaInteraction extends EInteractObject;

#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

function string	GetDescription()
{
	return Localize("HUD", "DestroyAntenna", "Localization\\Enhanced");
}

function InitInteract(Controller Instigator)
{
	local EPlayerController Epc;

	Instigator.Interaction = self;

	// Enable damage on the object so it can be destroyed by the interaction
	if (Owner.IsA('EGameplayObject'))
		EGameplayObject(Owner).bDamageable = True;

	if (Instigator.bIsPlayer)
	{
		Epc = EPlayerController(Instigator);
		Epc.JumpLabel = 'DefuseStand';
		Instigator.GotoState('s_DestroyAntenna');
	}
	else
	{
		// NPCs use the switch object state
		Instigator.GotoState('s_SwitchObject');
	}
}

function Interact(Controller Instigator)
{
	// Trigger the switch owner
	Owner.Trigger(Self, Instigator.Pawn);
	
	// Destroy the object
	if (Owner.IsA('EGameplayObject'))
		EGameplayObject(Owner).DestroyObject();
	
	// Continue to finish animation and return to walking
	if (Instigator.bIsPlayer)
		Instigator.GotoState(,'FinishInteraction');
}

function PostInteract(Controller Instigator)
{
	Instigator.Interaction = None;
	
	if (Instigator.bIsPlayer)
		EPlayerController(Instigator).ReturnFromInteraction();

	// Destroy interaction if owner switch is flagged trigger only once
	if (Owner != None && Owner.IsA('ESwitchObject') && ESwitchObject(Owner).TriggerOnlyOnce)
		Destroy();
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	
	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn == none)
		return;

	// Get object rotation axes for positioning
	GetAxes(Owner.Rotation, X, Y, Z);
	
	MovePos = Owner.Location;
	MovePos += 1.1f * InteractEPawn.CollisionRadius * X;
	MovePos.Z = InteractEPawn.Location.Z;
	
	InteractEPawn.m_locationStart	= InteractEPawn.Location;
	InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd		= MovePos;
	InteractEPawn.m_orientationEnd	= Rotator(-X);
}

defaultproperties
{
    iPriority=20000
}
