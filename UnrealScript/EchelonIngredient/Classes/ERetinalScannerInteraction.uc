////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Name: Retinal Scanner door opening Interaction
//
// Description: Interaction to be able to open a door from a Retinal Scanner depending on who is scanned
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ERetinalScannerInteraction extends EInteractObject;

var ERetinalScanner		Scanner;

function GetScanner()
{
	Scanner = ERetinalScanner(Owner);
	if( Scanner == None )
		Log("ERetinalScannerInteraction problem with Owner");
}

function string	GetDescription()
{
	return Localize("Interaction", "RetScan", "Localization\\HUD");
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

	// Trigger object
	if( !Instigator.bIsPlayer && Instigator.GetStateName() == 's_Grabbed' )
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
	local vector HitLocation, HitNormal;
	
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
		MovePos    += InteractEPawn.CollisionRadius * X;
		break;

	case 's_Grab':
		MovePos    += InteractEPawn.CollisionRadius*1.7f * X;
		break;
	}

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
	
	InteractEPawn.m_locationStart		= InteractEPawn.Location;
	InteractEPawn.m_orientationStart	= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd			= MovePos;
	InteractEPawn.m_orientationEnd		= Rotator(-X);
}

defaultproperties
{
    iPriority=4000
}