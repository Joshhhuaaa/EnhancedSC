class ETrapInteraction extends ETriggerInteraction;

var ETrapMover Trap;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Trap = ETrapMover(Owner);
	if (Trap == None)
		Log(self$" ERROR: ETrapInteraction owner is not a ETrapMover.");

	// Force opening time to fit Key Pitch .. ideal is Key1 pitch = -20934 & Time == 1.66f
	Trap.MoveTime = Trap.KeyRot[1].Pitch * 1.66f / -20934;
	SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
	SetLocation(Owner.ToWorld(vect(-70.0f,0.0f,0.0f)));
}

function bool IsAvailable()
{
	return Trap.bClosed;
}

function string	GetDescription()
{
	return Localize("Interaction", "Trap", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	Instigator.Interaction = self;
	if (Instigator.GetStateName() == 's_NarrowLadder')
		Instigator.GotoState(, 'OpenTrap');
	else
		Instigator.GotoState('s_OpenWindow', 'Trap');
}

function Interact(Controller Instigator)
{
	Trap.Trigger(Instigator.Pawn, Instigator.Pawn);
}

function PostInteract(Controller Instigator)
{
	Instigator.Interaction = None;

	if (Trap.bTriggerOnceOnly)
		Destroy();
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Rotator MoveRot;
	local EPawn InteractEPawn;

	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn != none)
	{
		MoveRot.Yaw	= Owner.Rotation.Yaw;

		InteractEPawn.m_locationStart		= InteractEPawn.Location;
		InteractEPawn.m_orientationStart	= InteractEPawn.Rotation;
		InteractEPawn.m_locationEnd			= Owner.ToWorld(vect(-135.0,-15,89.0));
		InteractEPawn.m_orientationEnd		= MoveRot;
	}
}

defaultproperties
{
    CollisionRadius=70.000000
    CollisionHeight=30.000000
}