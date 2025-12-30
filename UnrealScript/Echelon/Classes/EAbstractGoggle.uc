class EAbstractGoggle extends EInventoryItem
	//abstract // Joshua - Binocular support
	notplaceable;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

var int RendType;

// Joshua - Binocular support
var EPlayerController Epc;
var float MinFov;
var float MaxFov;
var float ZoomSpeed;
var float ZoomSpeedController; // Joshua - Console versions used a lower ZoomSpeed
var float Damping;
var float current_fov;
var float ZoomAccumulator; // Joshua - Accumulates deltaTime to ensure 30fps zoom rate regardless of actual framerate

state s_Inventory
{
	function EndState()
	{
		Super.EndState();
		bHidden = true;
	}
}

// Joshua - Binocular support
state s_Zooming
{
	function BeginState()
	{
		Epc = EPlayerController(controller);

		if (Epc == None)
			Log(self$" ERROR: Controller is not a EPlayerController");

		// Don't switch states if coming from split jump
		if (Epc.GetStateName() != 's_SplitZooming')
			Epc.GotoState('s_Zooming');
		ObjectHud.GotoState('s_Zooming');

		Epc.SetCameraFOV(Epc, (MaxFov + MinFov) / 2);
		current_fov = (MaxFov + MinFov) / 2;
		ZoomAccumulator = 0.0; // Reset accumulator when entering zoom state

		AddSoundRequest(Sound'Interface.Play_FisherEquipGoggle', SLOT_Interface, 0.1f);
	}

	function EndState()
	{
		Epc.SetCameraFOV(Epc, (Epc.DesiredFov));

		AddSoundRequest(Sound'Interface.Play_FisherEquipGoggle', SLOT_Interface, 0.1f);

		ObjectHud.GotoState('');
		
		EMainHUD(Epc.myHud).NormalView();
	}

	function bool Scope()
	{
		Epc.ReturnFromInteraction();
		return true;
	}

	function Tick(float DeltaTime)
	{
		local bool zoomed;
		local float simDeltaTime;
		local int numUpdates;
		local int i;

		// Don't process input during cinematics
		if (Epc.bInCinematic)
			return;

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
				if (!IsPlaying(Sound'FisherEquipement.Play_StickyCamZoom'))
					PlaySound(Sound'FisherEquipement.Play_StickyCamZoom', SLOT_SFX);
			}

			// Clamp fov and calculate zoom factor
			current_fov = FClamp(current_fov, MinFov, MaxFov);

			// Modify vision fov
			Epc.SetCameraFOV(Epc, current_fov);
		}

		Super.Tick(DeltaTime);
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
    bEquipable=False
	bPickable=False
	ObjectHudClass=Class'EBinocularView'
	bHidden=True
	bCollideActors=False
    StaticMesh=None
}