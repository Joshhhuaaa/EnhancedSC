class EWindowInteraction extends ETriggerInteraction;

var Mover	Window;

enum EWindowType
{
	EWT_Low,
	EWT_High,
	EWT_Rappelling,
};
var EWindowType WindowType;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Window = Mover(Owner);
	if( Window == None )
		Log(self$" ERROR: EWindowInteraction owner is not a mover.");

	// To fit animation
	Window.StayOpenTime = 10.f;
	Window.MoveTime		= 0.7f;
}

/* NOTE

IsAvailable determines the type of window.  This is done because the returned value uses it to determine if the interaction
is available or not depending on distance.  the EWT_Rappelling could be done in the InitInteract but since the others were done there ..

*/

function bool IsAvailable()
{
	local vector AlignedLocation;
	local vector HitLocation, HitNormal;
	local bool	bHigh;
	local float Distance;

	// Window not closed, so not available to interact with
	if( !Window.bClosed )
		return false;

	AlignedLocation		= Owner.Location;
	AlignedLocation.Z	= InteractionPlayerController.Pawn.Location.Z;

	if( InteractionPlayerController.bIsPlayer && InteractionPlayerController.GetStateName() == 's_Rappelling' )
		WindowType = EWT_Rappelling;
	else if( Owner.Location.z-InteractionPlayerController.Pawn.Location.z > 0 )
		WindowType = EWT_High;
	else
		WindowType = EWT_Low;

	// Find ditance to pawn
	Distance = VSize(AlignedLocation-InteractionPlayerController.Pawn.Location);

	// Check availability depending on Type
	switch( WindowType )
	{
	case EWT_Low:
		if( Distance > 45.f )
			return false;
		break;

	case EWT_High:
		if( Distance > 70.f ) 
			return false;
		break;

	case EWT_Rappelling:
		Distance = Owner.Location.z-InteractionPlayerController.Pawn.Location.z;
		if( Distance < -21 || Distance > -18 )
			return false;
		break;
	}

	// Must return a trace from a higher location on Pawn else, high windows hit bsp
	return Trace(HitLocation, HitNormal, InteractionPlayerController.Pawn.ToWorld(Vect(0,0,50)), Owner.Location, true) == InteractionPlayerController.Pawn;
}

function string	GetDescription()
{
	return Localize("Interaction", "Window", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	// set controller's interaction
	Instigator.Interaction = self;

	// Check if it's a high or low animation window
	switch( WindowType )
	{
	case EWT_Low:
		Instigator.GotoState('s_OpenWindow', 'Low');
		break;

	case EWT_High:
		Instigator.GotoState('s_OpenWindow', 'High');
		break;

	case EWT_Rappelling:
		Instigator.GotoState('s_Rappelling', 'OpenWindow');
		break;
	}
}

function SetInteractLocation( Pawn InteractPawn )
{
	local Rotator MoveRot;
	local EPawn InteractEPawn;

	InteractEPawn = EPawn(InteractPawn);
	if (InteractEPawn != none)
	{		
		MoveRot			= Rotator(Owner.Location - InteractEPawn.Location);
		MoveRot.Roll	= 0;
		MoveRot.Pitch	= 0;
		
		InteractEPawn.m_locationStart	= InteractEPawn.Location;
		InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
		InteractEPawn.m_locationEnd		= InteractEPawn.Location;
		InteractEPawn.m_orientationEnd	= MoveRot;
	}
}

