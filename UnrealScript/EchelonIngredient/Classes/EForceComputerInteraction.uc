class EForceComputerInteraction extends EComputerInteraction;

function bool IsAvailable()
{
	return InteractionPlayerController.GetStateName() == 's_grab' && Super.IsAvailable();
}

// Should this override EComputerInteraction::Interact?
function Interact(Controller Instigator)
{
	// Trigger object
	Owner.Trigger(Self, Instigator.Pawn);
}

