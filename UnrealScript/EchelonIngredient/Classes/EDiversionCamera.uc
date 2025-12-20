class EDiversionCamera extends EAirCamera;

var		Emitter	GazCloud;
var		float	r;
var		bool	bUsedUp;

function PostBeginPlay()
{
	Super.PostBeginPlay();

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_stickycam_div;
    HUDTexSD     = EchelonLevelInfo(Level).TICON.qi_ic_stickycam_div_sd;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_stickycam_div;
    ItemName     = "DiversionCamera";
	ItemVideoName = "gd_diversion_cam.bik";
    Description  = "DiversionCameraDesc";
	HowToUseMe  = "DiversionCameraHowToUseMe";
}

function LostChild(Actor Other)
{
	if (Other == GazCloud)
		GazCloud = None;
}

state s_Camera
{
	function BeginState()
	{
		Epc.bAltFire = 0;
		Epc.bInteraction = false; // Joshua - Set the interaction to false when entering the camera
		Super.BeginState();
	}

	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
       
        // Diversion Cam specific stuff
		if (Epc.eGame.bUseController) // Joshua - Adding controller support for Diversion Cameras
		{
			if (Epc.bJump != 0 && !bUsedUp)
			{
				bUsedUp = true;
				// Remove pickup interaction
				bPickable = false;
				ResetInteraction();

				// gaz
				GazCloud		= spawn(class'ECo2', self,,, Epc.Rotation);

				PlaySound(Sound'FisherEquipement.Play_StickyCamGas', SLOT_SFX);
				AddSoundRequest(Sound'FisherEquipement.Stop_StickyCamGas', SLOT_SFX, 2.5f);

				Epc.bJump = 0;
			}
			else if (Epc.bDuck != 0)
			{
				PlaySound(Sound'FisherEquipement.Play_Random_StickyCamNoise', SLOT_SFX);

				if (!bWasSeen)
					MakeNoise(1250, NOISE_Object_Falling);

				Epc.bDuck = 0;
			}
		}
		else
		{
			if (Epc.bAltFire != 0 && !bUsedUp)
			{
				bUsedUp = true;
				// Remove pickup interaction
				bPickable = false;
				ResetInteraction();

				// gaz
				GazCloud		= spawn(class'ECo2', self,,, Epc.Rotation);

				PlaySound(Sound'FisherEquipement.Play_StickyCamGas', SLOT_SFX);
				AddSoundRequest(Sound'FisherEquipement.Stop_StickyCamGas', SLOT_SFX, 2.5f);

				Epc.bAltFire = 0;
			}
			else if (Epc.bInteraction == true)
			{
				PlaySound(Sound'FisherEquipement.Play_Random_StickyCamNoise', SLOT_SFX);

				if (!bWasSeen)
					MakeNoise(1250, NOISE_Object_Falling);

				Epc.bInteraction = false;
			}
		}
	}
}

defaultproperties
{
    MaxQuantity=5
    ObjectHudClass=Class'EDiversionView'
    StaticMesh=StaticMesh'EMeshIngredient.Item.StickyCamera'
}