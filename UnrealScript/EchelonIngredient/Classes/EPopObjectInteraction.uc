class EPopObjectInteraction extends EInteractObject;

var Controller	InteractionController;
var vector		ViewRelativeLocation;
var rotator		ViewRelativeRotation;

// values to restore
var Actor		iniBase;
var Vector		iniLocation;
var Rotator		iniRotation;

function InitInteract( Controller Instigator )
{
	InteractionController	= Instigator;

	// Make pawn interact
	Instigator.Interaction = self;

	if( Instigator.bIsPlayer )
	{
		// backup old values
		iniBase = Owner.Base;
		if( iniBase == None )
		{
			iniLocation = Owner.Location;
			iniRotation	= Owner.Rotation;
		}
		else
		{
			iniLocation	= Owner.RelativeLocation;
			iniRotation	= Owner.RelativeRotation;
		}

		Owner.SetBase(Instigator);

		Owner.SetRelativeRotation(ViewRelativeRotation);
		Owner.SetRelativeLocation(ViewRelativeLocation);
	}
}

function PostInteract( Controller Instigator )
{
	// restore old values
	if( Instigator.bIsPlayer )
	{
		Owner.SetBase(iniBase);
		if( iniBase != None )
		{
			Owner.SetRelativeLocation(iniLocation);
			Owner.SetRelativeRotation(iniRotation);
		}
		else
		{
			Owner.SetLocation(iniLocation);
			Owner.SetRotation(iniRotation);
		}
	}

	Owner.GotoState('s_Idle');

	if( Instigator.bIsPlayer )
		EPlayerController(Instigator).ReturnFromInteraction();

	Instigator.Interaction	= None;
	InteractionController	= None;
}

defaultproperties
{
    iPriority=3000
}