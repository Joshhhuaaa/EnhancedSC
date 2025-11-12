class EForceRetinalSafeInteraction extends ERetinalSafeInteraction;

function bool IsAvailable()
{
	return InteractionPlayerController.GetStateName() == 's_grab' && Super.IsAvailable();
}

function PostInteract(Controller Instigator)
{
	local EPawn InteractEPawn;

	// Only set everything if granted class is valid on scanner
	if (Instigator.bIsPlayer && 
		EPlayerController(Instigator).m_AttackTarget != None && 
		Scanner.IsValid(EPlayerController(Instigator).m_AttackTarget))
	{
		// Set JumpLabel so as soon as the out of scan is finished, he's gonna turn around and release the guy.
		EPlayerController(Instigator).JumpLabel = 'TurnRelease';

		InteractEPawn = EPawn(Instigator.Pawn);
		InteractEPawn.m_locationStart		= InteractEPawn.Location;
		InteractEPawn.m_orientationStart	= InteractEPawn.Rotation;
		InteractEPawn.m_locationEnd			= InteractEPawn.ToWorld(Vect(-100,0,0));
		InteractEPawn.m_orientationEnd		= InteractEPawn.Rotation + Rot(0,32768,0);
	}

	Super.PostInteract(Instigator);
}

