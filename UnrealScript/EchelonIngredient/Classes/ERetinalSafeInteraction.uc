class ERetinalSafeInteraction extends EInteractObject;

var ERetinalSafe		Scanner;

function string	GetDescription()
{
	return Localize("Interaction", "RetSafe", "Localization\\HUD");
}

function GetScanner()
{
	Scanner = ERetinalSafe(Owner);
	if( Scanner == None )
		Log("ERetinalSafeInteraction problem with Owner");
}

function InitInteract( Controller Instigator )
{
	if ( Scanner == none )
		GetScanner();

	// Make scanner begin process
	Scanner.GotoState('s_Use');

		// Make pawn interact
	Instigator.Interaction = self;
	if( Instigator.GetStateName() == 's_Grab' )
		Instigator.GotoState(,'RetinalScan');
	else
		Instigator.GotoState('s_RetinalScanner');
}

function Interact( Controller Instigator )
{
	if ( Scanner == none )
		GetScanner();

	// Trigger object only if scanned pawn has valid class
	if( Scanner.IsValid(Instigator.Pawn) )
		Owner.Trigger(Self, Instigator.Pawn);

	Scanner.ValidateUser(Instigator.Pawn);
}

function PostInteract( Controller Instigator )
{
	Instigator.Interaction = None;

	// Alone or grab both call this
	Instigator.GotoState(,'RetinalEnd');
}

function SetInteractLocation( Pawn InteractPawn )
{
	local vector MovePos, X,Y,Z;
	local EPawn InteractEPawn;
	
	if ( Scanner == none )
		GetScanner();

	InteractEPawn = EPawn(InteractPawn);
	if( InteractEPawn == None )
		return;

	GetAxes(Scanner.Rotation, X,Y,Z);

	// set location depending on state
	MovePos		= Scanner.Location;
	MovePos    += Scanner.default.CollisionRadius * X;
	switch( InteractEPawn.Controller.GetStateName() )
	{
	case 's_RetinalScanner':
		MovePos    += (2.f + InteractEPawn.CollisionRadius) * X;
		break;

	case 's_Grab':
		MovePos    += InteractEPawn.CollisionRadius*1.8f * X;
		break;
	}
	MovePos.Z	= InteractEPawn.Location.Z;									// keep on same Z
	
	InteractEPawn.m_locationStart		= InteractEPawn.Location;
	InteractEPawn.m_orientationStart	= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd			= MovePos;
	InteractEPawn.m_orientationEnd		= Rotator(-X);
}

