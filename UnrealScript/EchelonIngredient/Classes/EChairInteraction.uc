class EChairInteraction extends EInteractObject;

var EChair		Chair;
var Controller	InteractionController;

var bool BackupCollideActors,
		 BackupBlockActors,
		 BackupBlockPlayers;

//----------------------------------------[David Kalina - 5 Feb 2002]-----
// 
// Description
//		Player can not interact with chair.
// 
//------------------------------------------------------------------------

function Touch(actor Other)
{
	if ( Other.bIsPlayerPawn )
		return;
	
	Super.UnTouch(Other);
}

function UnTouch(actor Other)
{
	if ( Other.bIsPlayerPawn )
		return;

	Super.UnTouch(Other);
}


//----------------------------------------[David Kalina - 1 Feb 2002]-----
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

function SetInteractLocation( Pawn InteractPawn )
{
	local vector MovePos;
	local EPawn InteractEPawn;
	local vector HitLocation, HitNormal;

	Chair = EChair(Owner);
	if( Chair == None )
		Log("EChairInteraction problem with Owner");
	
	InteractEPawn = EPawn(InteractPawn);
	
	if (InteractEPawn != none)
	{	
		MovePos		= Chair.Location;

		// TODO : MovePos calculated based on side of InteractPawn relative to chair's forward x axis

		if(Chair.bBed)
		{
				MovePos	   += (InteractEPawn.CollisionRadius + Chair.default.CollisionRadius + 20) * (vect(0, 1, 0) >> Chair.Rotation);
				InteractEPawn.m_orientationEnd		= Chair.Rotation;
				InteractEPawn.m_orientationEnd.Yaw	-= 16384;

		}
		else
		{
			if(Chair.bTableChair)
			{
				MovePos	   += (-15) * (vect(1, 0, 0) >> Chair.Rotation);
				MovePos	   += (InteractEPawn.CollisionRadius + Chair.CollisionRadius) * (vect(0, 1, 0) >> Chair.Rotation);
				InteractEPawn.m_orientationEnd		= Chair.Rotation;
				InteractEPawn.m_orientationEnd.Yaw	-= 16384;

			}
			else
			{
				MovePos	   += (+5) * (vect(1, 0, 0) >> Chair.Rotation);
				MovePos	   += (InteractEPawn.CollisionRadius + Chair.CollisionRadius) * (vect(1, 0, 0) >> Chair.Rotation);
				InteractEPawn.m_orientationEnd		= Chair.Rotation + Rot(0,+32768,0);

			}
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
	}
}

//----------------------------------------[David Kalina - 1 Feb 2002]-----
// 
// Description
//		Trigger controller state change.
// 
//------------------------------------------------------------------------


function InitInteract( Controller Instigator )
{
	InteractionController = Instigator;
	Chair = EChair(Owner);
	if( Chair == None )
		Log("EChairInteraction problem with Owner");

	// disable chair physics / lock it in position
	BackupCollideActors = Chair.bCollideActors;
	BackupBlockActors = Chair.bBlockActors;
	BackupBlockPlayers = Chair.bBlockPlayers;
	Chair.SetCollision(true, false, true);

	// Make pawn interact
	Instigator.Interaction = self;

	SetRotation(Chair.Rotation);

	// chair interaction not for player
	if( !Instigator.bIsPlayer )
	{
		if(Chair.bTableChair)
			Instigator.GotoState('s_SitDown', 'RightSide');
		else
			Instigator.GotoState('s_SitDown', 'FrontSide');
	}
}

//----------------------------------------[David Kalina - 5 Feb 2002]-----
// 
// Description
//		Called after NPC gets up from chair - re-enable collision on chair.
// 
//------------------------------------------------------------------------

function PostInteract( Controller Instigator )
{
	Chair = EChair(Owner);
	if( Chair == None )
		Log("EChairInteraction problem with Owner");

	// Restore chair collision
	Chair.SetCollision(BackupCollideActors, BackupBlockActors, BackupBlockPlayers);

	Instigator.Interaction = None;

}
