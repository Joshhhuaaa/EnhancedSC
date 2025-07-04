class ETriggerInteraction extends EInteractObject;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Owner.IsA('Mover') && (Owner.InitialState != 'TriggerOpenTimed' && Owner.InitialState != 'TriggerToggle') )
		Log(self$" ERROR: ETriggerInteraction mover owner is not in state TriggerToggle/TriggerOpenTimed."@Owner.InitialState);
}

function string	GetDescription()
{
	return Localize("Interaction", "Switch", "Localization\\HUD");
}

function InitInteract( Controller Instigator )
{
	if( !Instigator.bIsPlayer )
		Instigator.GotoState('s_SwitchObject');
	else
	{
		Interact(Instigator);
		PostInteract(Instigator);
	}
}

function Interact( Controller Instigator )
{
	Owner.Trigger(Self, Instigator.Pawn);
}

function PostInteract( Controller Instigator )
{
	EPlayerController(Instigator).ReturnFromInteraction();

	// Destroy interaction if owner switch is flagged trigger only once
	if( Owner != None && Owner.IsA('ESwitchObject') && ESwitchObject(Owner).TriggerOnlyOnce )
		Destroy();

}

function SetInteractLocation( Pawn InteractPawn )
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	local vector HitLocation, HitNormal;
	
	InteractEPawn = EPawn(InteractPawn);
	
	if (InteractEPawn != none)
	{		
		// get owner rotation axes for positioning
		GetAxes(Owner.Rotation, X, Y, Z);
		
		MovePos = Owner.Location;
		MovePos -= (0.5 * InteractEPawn.CollisionRadius) * Y;
		MovePos += (1.25 * InteractEPawn.CollisionRadius) * X;

		if(InteractEPawn.bIsPlayerPawn)
        {
			MovePos.Z	= InteractEPawn.Location.Z;									// keep on same Z
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
		InteractEPawn.m_orientationEnd	= Rotator(-X);
	}	
}


