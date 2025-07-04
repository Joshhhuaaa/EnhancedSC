class ELaserMic extends EInventoryItem;

var EPlayerController	Epc;
var	EMicro				Micro;

var Actor				CurrentTarget;
var	ELaserMicMover		LaserMicTarget;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    
	HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_lasermic;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_lasermic;
    ItemName     = "LaserMic";
	ItemVideoName = "gd_lasermic.bik";
    Description  = "LaserMicDesc";
	HowToUseMe  = "LaserMicHowToUseMe";

	Micro = spawn(class'EMicro', self);
}

function ResetTarget()
{
	if( LaserMicTarget != None )
		LaserMicTarget.TouchedByLaserMic = false;
	LaserMicTarget	= None;
	Epc.MicroTarget = None;
}

function Select( EInventory Inv )
{
	Super.Select(Inv);
	PlaySound(Sound'Interface.Play_FisherEquipLaserMic', SLOT_Interface);
}

state s_Selected
{
	function bool Scope()
	{
		GotoState('s_Microiing');
		return true;
	}
}

state s_Microiing
{
	function BeginState()
	{
		Epc = EPlayerController(controller);
		if( Epc == None )
			Log(self$" ERROR: Controller is not a EPlayerController");

		// Once Micro set, send Controller into lasermic state
		Epc.GotoState('s_LaserMicTargeting');
		ObjectHud.GotoState('s_Use');

		CurrentTarget = None;
		ResetTarget();

		// Micro
		Micro.SetCollision(true);
		Epc.SetCameraFOV(self, 30);
		Epc.iRenderMask = 3;
	}

	function EndState()
	{
		Micro.SetCollision(false);
		Epc.PopCamera(self);
		Epc.iRenderMask = 0;
		
		ResetTarget();

		ObjectHud.GotoState('');
	}

	function bool Scope()
	{
		EPlayerController(Controller).ReturnFromInteraction();
		return true;
	}

	function Tick( float DeltaTime )
	{
		// Update mic location for sound engine
		Micro.SetLocation(Epc.m_TargetLocation-Epc.ToWorldDir(vect(25,0,0)));

		// Always look up CurrentTarget if it's a Mic Mover, in case the conversation is turned on/off while pointing it.  
		// Else, the conversation will only get detected unless you change to a different target
		if( Epc.m_targetActor != CurrentTarget || CurrentTarget.IsA('ELaserMicMover') )
		{
			// Only change target (and log) when actually true
			if( Epc.m_targetActor != CurrentTarget )
			{
				//Log("s_Microiing new TARGET ="@Epc.m_targetActor);
				CurrentTarget = Epc.m_targetActor;
			}
			
			// process valid target
			if( CurrentTarget.IsA('ELaserMicMover') )
			{
				LaserMicTarget = ELaserMicMover(CurrentTarget);
				LaserMicTarget.TouchedByLaserMic = true;
				SetLaserLocked(true);
				
				// Set sound object when touching a valid mic mover
				Epc.MicroTarget = Micro;
				
				//Log("Valid Target"@LaserMicTarget);
			}
			// If not touching a valid target, reset flags
			else if( LaserMicTarget != None )
			{
				LaserMicTarget.TouchedByLaserMic = false;
				SetLaserLocked(false);
				ResetTarget();
			}
		}

		// Reset pointers if the mic mover pattern is not yet started
		if( LaserMicTarget != None && LaserMicTarget.LinkedSession == None )
			ResetTarget();
	}
}

defaultproperties
{
    Category=CAT_GADGETS
    ObjectHudClass=Class'ELaserMicView'
    StaticMesh=none
    CollisionRadius=4.000000
    CollisionHeight=4.000000
}