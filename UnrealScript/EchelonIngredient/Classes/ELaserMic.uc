class ELaserMic extends EInventoryItem;

var EPlayerController	Epc;
var	EMicro				Micro;

var Actor				CurrentTarget;
var	ELaserMicMover		LaserMicTarget;

// Joshua - Zoom functionality
var float MinFov;
var float MaxFov;
var float ZoomSpeed;
var float ZoomSpeedController; // Joshua - Console versions used a lower ZoomSpeed
var float Damping;
var float current_fov;
var float ZoomAccumulator; // Joshua - Accumulates deltaTime to ensure 30fps zoom rate regardless of actual framerate

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
	if (LaserMicTarget != None)
		LaserMicTarget.TouchedByLaserMic = false;
	LaserMicTarget	= None;
	Epc.MicroTarget = None;
}

function Select(EInventory Inv)
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
		if (Epc == None)
			Log(self$" ERROR: Controller is not a EPlayerController");

		// Once Micro set, send Controller into lasermic state
		Epc.GotoState('s_LaserMicTargeting');
		ObjectHud.GotoState('s_Use');

		CurrentTarget = None;
		ResetTarget();

		// Micro
		Micro.SetCollision(true);
		ZoomAccumulator = 0.0; // Joshua - Reset accumulator when entering laser mic state
		// Joshua - Zoom functionality
		if (Epc.bLaserMicZoomLevels)
		{
			// Joshua - Vision functionality
			if (Epc.bLaserMicVisions)
				Epc.SetCameraFOV(Epc, (MaxFov + MinFov) / 2);
			else
				Epc.SetCameraFOV(self, (MaxFov + MinFov) / 2);
			current_fov = (MaxFov + MinFov) / 2;
		}
		else
		{
			// Joshua - Vision functionality
			if (Epc.bLaserMicVisions)
				Epc.SetCameraFOV(Epc, 30.0);
			else
				Epc.SetCameraFOV(self, 30.0);
			current_fov = 30.0;
		}
		Epc.iRenderMask = 3;
	}

	function EndState()
	{
		Micro.SetCollision(false);
		Epc.SetCameraFOV(Epc, (Epc.DesiredFov)); // Joshua - Necessary to reset FOV when using Laser Mic visions
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

	// Joshua - Zoom functionality
	function Zoom(float DeltaTime)
	{
		local bool zoomed;
		local float simDeltaTime;
		local int numUpdates;
		local int i;

		// Accumulate actual deltaTime and only update zoom at 30fps intervals
		ZoomAccumulator += DeltaTime;
		simDeltaTime = 1.0f / 30.0f;
		
		// Calculate how many 30fps frames have passed
		numUpdates = int(ZoomAccumulator / simDeltaTime);
		
		// Only process zoom if at least one 30fps frame has passed
		if (numUpdates > 0)
		{
			// Subtract the time we're about to process
			ZoomAccumulator -= numUpdates * simDeltaTime;
			
			// Apply zoom updates (usually just 1, but could be more if frame rate drops)
			for (i = 0; i < numUpdates; i++)
			{
				// Zoom in
				if (Epc.bIncSpeedPressed == true)
				{
					Epc.bIncSpeedPressed = false;
					current_fov -= simDeltaTime * ZoomSpeed;
					if (current_fov >= MinFov)
					{
						zoomed = true;
					}
				}
				// Zoom out
				else if (Epc.bDecSpeedPressed == true)
				{
					Epc.bDecSpeedPressed = false;
					current_fov += simDeltaTime * ZoomSpeed;	    
					if (current_fov <= MaxFov)
					{
						zoomed = true;
					}
				}

				// Zoom in
				if (Epc.bDPadUp != 0)
				{
					current_fov -= simDeltaTime * ZoomSpeedController;
					if (current_fov >= MinFov)
					{
						zoomed = true;
					}
				}
				// Zoom out
				else if (Epc.bDPadDown != 0)
				{
					current_fov += simDeltaTime * ZoomSpeedController;	    
					if (current_fov <= MaxFov)
					{
						zoomed = true;
					}
				}
			}

			if (zoomed)
			{
				// Attached the sound to the PlayerController to fix an issue where the sound position wasn't updating in real time
				if (!Epc.IsPlaying(Sound'FisherEquipement.Play_StickyCamZoom'))
					Epc.PlaySound(Sound'FisherEquipement.Play_StickyCamZoom', SLOT_SFX);
			}

			// Clamp fov and calculate zoom factor
			current_fov = FClamp(current_fov, MinFov, MaxFov);

			// Modify vision fov
			if (Epc.bLaserMicVisions)
				Epc.SetCameraFOV(Epc, current_fov);
			else
				Epc.SetCameraFOV(self, current_fov);
		}
	}		

	function Tick(float DeltaTime)
	{
		// Update mic location for sound engine
		Micro.SetLocation(Epc.m_TargetLocation - Epc.ToWorldDir(vect(25,0,0)));

		// Always look up CurrentTarget if it's a Mic Mover, in case the conversation is turned on/off while pointing it.  
		// Else, the conversation will only get detected unless you change to a different target
		if (Epc.m_targetActor != CurrentTarget || CurrentTarget.IsA('ELaserMicMover'))
		{
			// Only change target (and log) when actually true
			if (Epc.m_targetActor != CurrentTarget)
			{
				//Log("s_Microiing new TARGET ="@Epc.m_targetActor);
				CurrentTarget = Epc.m_targetActor;
			}
			
			// process valid target
			if (CurrentTarget.IsA('ELaserMicMover'))
			{
				LaserMicTarget = ELaserMicMover(CurrentTarget);
				LaserMicTarget.TouchedByLaserMic = true;
				SetLaserLocked(true);
				
				// Set sound object when touching a valid mic mover
				Epc.MicroTarget = Micro;
				
				//Log("Valid Target"@LaserMicTarget);
			}
			// If not touching a valid target, reset flags
			else if (LaserMicTarget != None)
			{
				LaserMicTarget.TouchedByLaserMic = false;
				SetLaserLocked(false);
				ResetTarget();
			}
		}

		// Reset pointers if the mic mover pattern is not yet started
		if (LaserMicTarget != None && LaserMicTarget.LinkedSession == None)
			ResetTarget();
		
		// Joshua - Zoom functionality
		if (Epc.bLaserMicZoomLevels)
			Zoom(DeltaTime);
	}
}

defaultproperties
{
    MinFov=14.000000
    MaxFov=70.000000
    ZoomSpeed=95.000000
	ZoomSpeedController=30.000000 // Joshua - Console versions used a lower ZoomSpeed
    Damping=200.000000
    Category=CAT_GADGETS
    ObjectHudClass=Class'ELaserMicView'
    StaticMesh=None
    CollisionRadius=4.000000
    CollisionHeight=4.000000
}