class EAlarmInteraction extends EInteractObject;

var EAlarmPanel	Panel;
var Controller InteractionController;

function bool IsAvailable()
{
	return false;
}

//----------------------------------------[David Kalina - 2 Aug 2001]-----
//
// Description
//		Sets EPawn's MoveTo parameters for subsequent MoveToLocation call.
//
// Input
//		InteractPawn : Pawn we will end up moving - should be cast to EPawn
//			in subclasses.
//
// PostConditions
//		The InteractPawn's following vars must be set:
//			m_locationStart
//			m_orientationStart
//			m_locationEnd
//			m_orientationEnd
//
//------------------------------------------------------------------------

function SetInteractLocation(Pawn InteractPawn)
{
	local vector MovePos;
	local EPawn InteractEPawn;
	local NavigationPoint tempnav;
	local vector HitLocation, HitNormal;

	Panel = EAlarmPanel(Owner);
	if (Panel == None)
		Log("EAlarmInteraction problem with Owner");

	InteractEPawn = EPawn(InteractPawn);

	if (InteractEPawn != none)
	{
		// Find position for pawn to kick properly
		MovePos		= Panel.Location;
		MovePos	   += (2.0 + InteractEPawn.CollisionRadius + Panel.default.CollisionRadius) * (vect(1, 0, 0) >> Panel.Rotation);


		if (InteractEPawn.bIsPlayerPawn)
		{
		MovePos.Z	= InteractEPawn.Location.Z;									// keep on same Z
		}
		else
		{
			if (Trace(HitLocation, HitNormal, MovePos + vect(0,0,-200), MovePos,,,,,true) != None)
			{
				HitLocation.Z += InteractEPawn.CollisionHeight;
				MovePos = HitLocation;
			}
		}

		tempnav = spawn(class'EDynamicNavPoint', self, 'TEMP_NavPoint', MovePos);

		InteractEPawn.m_locationStart		= InteractEPawn.Location;
		InteractEPawn.m_orientationStart	= InteractEPawn.Rotation;
		InteractEPawn.m_orientationEnd		= Panel.Rotation;
		InteractEPawn.m_locationEnd			= MovePos;
		InteractEPawn.m_orientationEnd.Yaw	+= 32768;
	}
}

function string	GetDescription()
{
	return Localize("Interaction", "Alarm", "Localization\\HUD");
}

function InitInteract(Controller Instigator)
{
	InteractionController  = Instigator;
	Panel = EAlarmPanel(Owner);
	if (Panel == None)
		Log("EAlarmInteraction problem with Owner");

	// Make pawn interact
	Instigator.Interaction = self;

	if (Panel.bGlassBroken || !Instigator.bIsPlayer)
		Instigator.GotoState('s_AlarmSwitch');
	else
		Instigator.GotoState('s_AlarmSwitch', 'BreakGlass');
}

function Interact(Controller Instigator)
{
	// Trigger object
	Owner.Trigger(Self, Instigator.Pawn);

	//check if the alarm is deactivited
	if (Panel.Alarm.GetStateName() != 's_On')
	{
		Panel.GotoState('s_Activate');
	}
	else
	{
		Panel.GotoState('s_Deactivate');
	}
}

function PostInteract(Controller Instigator)
{
	// reset interaction
	InteractionController = None;
	Instigator.Interaction = None;
}

