class ECameraJammer extends EInventoryItem;

var()	int			JammingDegree;
var()	int			JammingDistance;
var()	float		BatteryCharge;
var		float		CurrentCharge;

var		float		RealJammingAngle;

//var actor prevactor;
var EBaseCam			JammedCamera;

var EchelonLevelInfo eLevel;

function PostBeginPlay()
{
	Super.PostBeginPlay();

    eLevel = EchelonLevelInfo(Level);

	CurrentCharge = BatteryCharge;

	// Calculate one time the degree in radian
	RealJammingAngle = Cos((JammingDegree * PI) / 180);

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_camerajammer;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_camerajammer;
    ItemName     = "CameraJammer";
	ItemVideoName = "gd_camera_jammer.bik";
    Description  = "CameraJammerDesc";
	HowToUseMe  = "CameraJammerHowToUseMe";
}

function DrawAdditionalInfo(HUD Hud, ECanvas Canvas)
{	
    //ObjectHUD.DrawView(Hud, Canvas);
}

//------------------------------------------------------------------------
// Description		
//		Charge/Spend battery juice
//------------------------------------------------------------------------
function ModifyCharge(float c)
{
	CurrentCharge += c;
	if (CurrentCharge > BatteryCharge)
		CurrentCharge = BatteryCharge;
	else if (CurrentCharge < 0)
		CurrentCharge = 0;
}

function Jam(EBaseCam Cam)
{
	Cam.Jammed();
	JammedCamera = Cam;

	// Joshua - Adding the option to use Camera Jammer camera behavior from Pandora Tomorrow
	if (EPlayerController(Controller).bCameraJammerAutoLock)
		EPlayerController(Controller).JammedCam = Cam;
}

function UnJam()
{
	if (JammedCamera != None)
	{
		PlaySound(Sound'FisherEquipement.Stop_CameraJammerRun', SLOT_SFX);
		JammedCamera.UnJammed();		
	}
	JammedCamera = None;

	// Joshua - Adding the option to use Camera Jammer camera behavior from Pandora Tomorrow
	if (EPlayerController(Controller).bCameraJammerAutoLock)
		EPlayerController(Controller).JammedCam = None;
}

//------------------------------------------------------------------------
// Description		
//		Return the first camera within angle
//------------------------------------------------------------------------
function EBaseCam CamInCone()
{
	local EBaseCam	Camera;
	local Vector	CamDir, ViewDir;
	local float		ViewAngle;

	ForEach VisibleCollidingActors(class'EBaseCam', Camera, JammingDistance)
	{
		// Don't bother with deactivated camera
		if (Camera.GetStateName() == 's_Deactivated' || Camera.GetStateName() == 's_Destructed')
            continue;

		CamDir		= Normal(Camera.Location - Location);
		ViewDir		= Normal(Controller.GetTargetPosition() - Location);
        ViewAngle	= ViewDir dot CamDir;

		if (ViewAngle >= RealJammingAngle)
            break;
		else
			Camera = None;
	}			
	
	return Camera;
}

state s_Inventory
{
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
		
		// Restore batteryCharge over time at 1/4 the speed
		ModifyCharge(0.5f * DeltaTime);
	}

    function BeginState()
    {
		Super.BeginState();
        ObjectHud.GotoState('');
    }
}

function Select(EInventory Inv)
{
	Super.Select(Inv);
	
	// Joshua - Don't play sound during silent restore (sorting)
	if (!Inv.bSilentRestore)
		PlaySound(Sound'Interface.Play_FisherEquipCamJammer', SLOT_Interface);
}

state s_Selected
{
	function bool Scope()
	{
		GotoState('s_Jamming');
		return true;
	}

	function Tick(float DeltaTime)
	{		
		Super.Tick(DeltaTime);

		// Restore batteryCharge over time at 1/4 the speed
		ModifyCharge(0.5f * DeltaTime);
	}
}

state s_Jamming
{
	function BeginState()
	{		
		Controller.GotoState('s_CameraJammerTargeting');
	}

	function EndState()
	{		
        UnJam();
		PlaySound(Sound'FisherEquipement.Stop_CameraJammerRun', SLOT_SFX);
		EPlayerController(Controller).ReturnFromInteraction();
	}

	function bool Scope()
	{		
		GotoState('s_Selected');
		return true;
	}

	function Tick(float DeltaTime)
	{
		local EBaseCam	Camera;

		// No jamming while jammer not ready 
		if (EPlayerController(Controller) == None || EPlayerController(Controller).bInTransition)
			return;

		// Check for trigger release/no more battery
		if (!Controller.Pawn.PressingFire() || CurrentCharge <= 0)
		{
			// Was just targeting before release
			if (JammedCamera != None)
			{
				if (!IsPlaying(Sound'FisherEquipement.Play_CamerajammerNoPower'))
					PlaySound(Sound'FisherEquipement.Play_CamerajammerNoPower', SLOT_SFX);

				UnJam();
			}

			// Restore batteryCharge over time at 1/4 the speed
			if (!Controller.Pawn.PressingFire())
				ModifyCharge(0.5f * DeltaTime);
			return;
		}

		// Trying to jam
		// Reduce battery charge
		ModifyCharge(-DeltaTime);

		Super.Tick(DeltaTime);

		Camera = CamInCone();
		if (Camera != None)
		{
			if (Camera != JammedCamera)
			{
				UnJam();
				if (!IsPlaying(Sound'FisherEquipement.Play_CameraJammerRun'))
					PlaySound(Sound'FisherEquipement.Play_CameraJammerRun', SLOT_SFX);
				Jam(Camera);
			}
		}
		else
		{
			UnJam();
		}
	}
}

defaultproperties
{
    JammingDegree=15
    JammingDistance=2500
    BatteryCharge=10.000000
    Category=CAT_GADGETS
    ObjectHudClass=Class'ECameraJammerView'
    StaticMesh=StaticMesh'EMeshIngredient.Item.CameraJammer'
    CollisionRadius=2.000000
    CollisionHeight=2.000000
}