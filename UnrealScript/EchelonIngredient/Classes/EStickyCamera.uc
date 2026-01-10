class EStickyCamera extends EAirCamera;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

var(StickyCamera) float MinFov;
var(StickyCamera) float MaxFov;
var(StickyCamera) float ZoomSpeed;
var(StickyCamera) float ZoomSpeedController; // Joshua - Console versions used a lower ZoomSpeed
var(StickyCamera) float Damping;

var float current_fov;
var float ZoomAccumulator; // Joshua - Accumulates deltaTime to ensure 30fps zoom rate regardless of actual framerate

// Joshua - Save camera settings for SwitchCam restore
var float SavedFov;
var int SavedRenderingMode;
var bool bHasSavedSettings;

function PostBeginPlay()
{
	Super.PostBeginPlay();

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_stickycam_surv;
    HUDTexSD     = EchelonLevelInfo(Level).TICON.qi_ic_stickycam_surv_sd;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_stickycam_surv;
    ItemName     = "StickyCamera";
	ItemVideoName = "gd_sticky_cam.bik";
    Description  = "StickyCameraDesc";
	HowToUseMe  = "StickyCameraHowToUseMe";

	current_fov	 = MaxFov;
}

//------------------------------------------------------------------------
// Joshua - Override TakeView to restore saved settings when using SwitchCam
//------------------------------------------------------------------------
function TakeView()
{
	Super.TakeView();

	// Restore saved settings if we have them
	if (bHasSavedSettings)
	{
		current_fov = SavedFov;
		RenderingMode = SavedRenderingMode;
		Epc.SetCameraFOV(self, current_fov);
		Epc.SetCameraMode(self, RenderingMode);

		// Restore thermal settings if needed
		if (RenderingMode == REN_ThermalVision)
		{
			Epc.ThermalTexture = Level.pThermalTexture_B;
			Epc.bBigPixels = true;
		}
	}
}

//------------------------------------------------------------------------
// Joshua - Override GiveView to save settings before exiting
//------------------------------------------------------------------------
function GiveView(bool bFromPlayer)
{
	// Save current settings before exiting
	SavedFov = current_fov;
	SavedRenderingMode = RenderingMode;
	bHasSavedSettings = true;

	Super.GiveView(bFromPlayer);
}

state s_Camera
{
	function BeginState()
	{
		Super.BeginState();

		// Joshua - Clear zoom input buttons
		Epc.bIncSpeedPressed = false;
		Epc.bDecSpeedPressed = false;

		// Joshua - Only reset FOV if we don't have saved settings
		// Saved settings are restored in TakeView() when using SwitchCam
		if (!bHasSavedSettings)
			current_fov = MaxFov;

		ZoomAccumulator = 0.0; // Joshua - Reset accumulator when entering camera state
	}

	function Tick(float DeltaTime)
	{
		local bool zoomed;
		local float simDeltaTime;
		local int numUpdates;
		local int i;

		// Joshua - Accumulate actual deltaTime and only update zoom at 30fps intervals
		ZoomAccumulator += DeltaTime;
		simDeltaTime = 1.0f / 30.0f;

        // Night vision
        if (Epc.bDPadLeft != 0)
		{
			if (RenderingMode != REN_NightVision)
			{
				// Joshua - Play sound based on previous mode
				if (RenderingMode == REN_ThermalVision)
					PlaySound(Sound'Interface.Play_FisherSwitchGoggle', SLOT_Interface); // Switching between vision modes
				else
					PlaySound(Sound'FisherEquipement.Play_GoggleRun', SLOT_SFX); // Turning vision on from off
				RenderingMode = REN_NightVision;
			}
			else
				RenderingMode = REN_DynLight;

			Epc.SetCameraMode(self, RenderingMode);
			Epc.bDPadLeft	= 0;
		}
		// Thermal vision
		else if (Epc.bDPadRight != 0)
		{
			if (RenderingMode != REN_ThermalVision)
			{
				// Joshua - Play sound based on previous mode
				if (RenderingMode == REN_NightVision)
					PlaySound(Sound'Interface.Play_FisherSwitchGoggle', SLOT_Interface); // Switching between vision modes
				else
					PlaySound(Sound'FisherEquipement.Play_GoggleRun', SLOT_SFX); // Turning vision on from off
				RenderingMode = REN_ThermalVision;
			}
			else
				RenderingMode = REN_DynLight;

			Epc.SetCameraMode(self, RenderingMode);

	        Epc.ThermalTexture	= Level.pThermalTexture_B;
            Epc.bBigPixels		= true;
			Epc.bDPadRight		= 0;
		}

		// Joshua - Calculate how many 30fps frames have passed
		numUpdates = int(ZoomAccumulator / simDeltaTime);

		// Joshua - Only process zoom if at least one 30fps frame has passed
		if (numUpdates > 0)
		{
			// Joshua -  Subtract the time we're about to process
			ZoomAccumulator -= numUpdates * simDeltaTime;

			// Joshua -  Apply zoom updates (usually just 1, but could be more if frame rate drops)
			for (i = 0; i < numUpdates; i++)
			{
				// Joshua - Adding controller support for Sticky Camera (zoom in)
				if (Epc.bDPadUp != 0)
				{
					current_fov -= simDeltaTime * ZoomSpeedController;
					if (current_fov >= MinFov)
					{
						zoomed = true;
					}
				}
				// Joshua - Adding controller support for Sticky Camera (zoom out)
				else if (Epc.bDPadDown != 0)
				{
					current_fov += simDeltaTime * ZoomSpeedController;
					if (current_fov <= MaxFov)
					{
						zoomed = true;
					}
				}

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
			}

			if (zoomed)
			{
				if (!IsPlaying(Sound'FisherEquipement.Play_StickyCamZoom'))
					PlaySound(Sound'FisherEquipement.Play_StickyCamZoom', SLOT_SFX);
				Level.RumbleVibrate(0.07f, 0.5);
				if (FRand() > 0.5)
					Epc.m_camera.Hit(60, 20000, true);
				else
					Epc.m_camera.Hit(-60, 20000, true);
			}

			// Clamp fov and calculate zoom factor
			current_fov = FClamp(current_fov, MinFov, MaxFov);
			MaxDamping = Damping;
			MaxDamping /= (MaxFov) / current_fov;

			// Modify vision fov
			Epc.SetCameraFOV(self, current_fov);
		}

        Super.Tick(DeltaTime);
	}
}

defaultproperties
{
    MinFov=10.000000
    MaxFov=90.000000
    ZoomSpeed=95.000000
	ZoomSpeedController=30.000000 // Joshua - Console versions used a lower ZoomSpeed
    Damping=400.000000
    MaxQuantity=20
    ObjectHudClass=Class'EStickyView'
    StaticMesh=StaticMesh'EMeshIngredient.Item.StickyCamera'
}