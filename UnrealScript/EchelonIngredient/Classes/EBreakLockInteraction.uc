class EBreakLockInteraction extends EInteractObject;

var EDisposablePick Pick;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Pick = EDisposablePick(Owner);
	if( Pick == None )
		Log("WARNING : EBreakLockInteraction does not have a valid owner");
}

function InitInteract( Controller Instigator )
{
	// set controller's interaction
	Instigator.Interaction = self;
	Instigator.GotoState('s_BreakLock');
}

function Interact( Controller Instigator )
{
	local EInventory Inv;

	// Joshua - Prevent switching to the Disposable Pick after using one with new door interaction system
	if (EchelonGameInfo(Level.Game).bNewDoorInteraction)
	{
		if( Pick.Controller != None )
		{
			Inv = EPawn(Pick.Controller.Pawn).FullInventory;
			Inv.RemoveItem(Pick, 1);
		}
	}
	else
	{
		// Destroy one disposable pick
		Pick.ProcessUseItem();
	}

	// When placing on door
	Pick.PlaceOnDoor();
}

function PostInteract( Controller Instigator )
{
	// reset interaction
	Instigator.Interaction	= None;
	Destroy();
}

function SetInteractLocation( Pawn InteractPawn )
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	local int YawAligner;
	
	InteractEPawn = EPawn(InteractPawn);
	if( InteractEPawn == None )
		return;

	GetAxes(Pick.Door.MyKnob.Rotation, X, Y, Z);
	YawAligner = -4000;
	// Get door opening direction
	if( Pick.Door.GetPawnSide(InteractPawn) != ESide_Front )
	{
		Y = -Y;
		YawAligner = -YawAligner;
	}
	
	MovePos	 = Pick.Door.MyKnob.Location;
	MovePos -= 1.3f * InteractEPawn.CollisionRadius * Y;
	MovePos -= 0.7f * InteractEPawn.CollisionRadius * X;
	MovePos.Z	= InteractEPawn.Location.Z;

	InteractEPawn.m_locationStart	= InteractEPawn.Location;
	InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
	InteractEPawn.m_locationEnd		= MovePos;
	InteractEPawn.m_orientationEnd	= Rotator(Y) + YawAligner * Rot(0,1,0);
}

defaultproperties
{
    bCollideActors=false
}