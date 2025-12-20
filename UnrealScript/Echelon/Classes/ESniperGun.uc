class ESniperGun extends ETwoHandedWeapon
	abstract
	native;

// SNIPING VARS
var(Sniper) Array<float>	FOVs;					// not to be designer vars eventually
var			int				FOVIndex;
var			Rotator			SniperNoisedRotation;
var			bool			bSniperMode;
var			ESniperNoise	Sn;
var			float			LastSniperModeTime;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var			ERateOfFireMode	eROFMode_old; // Joshua - QoL improvement: Switch back to previous RoF when leaving sniper mode

function PostBeginPlay()
{
	Super.PostBeginPlay();
}

function CheckShellCase();

function UpdateSniperNoise(float DeltaTime)
{
	if (bSniperMode)
	{
		SniperNoisedRotation = Controller.Rotation;
		if (Sn.Update(DeltaTime, EPlayerController(Controller)))
		{
			if (!WeaponReticle.IsInState('s_Blinking'))
				WeaponReticle.GotoState('s_Blinking');
		}
		else
			WeaponReticle.GotoState('s_Selected');
		SniperNoisedRotation += Sn.GetNoise();
		LastSniperModeTime = Level.TimeSeconds;
	}
	else
	{
		// 2.0 is safety delay before reseting
		if (Sn != None &&
			(LastSniperModeTime + 2.0) < Level.TimeSeconds)
		{
			Sn.ResetFatigue();
			LastSniperModeTime = 1000000.0;
		}
		if (WeaponReticle != None && WeaponReticle.IsInState('s_Blinking'))
			WeaponReticle.GotoState('s_Selected');

		if (Sn != None &&
			LastSniperModeTime < Level.TimeSeconds)
		{
			if (EPlayerController(Controller).Pawn.IsPlaying(Sound'FisherVoice.Play_Sq_FisherHeartBeat'))
				EPlayerController(Controller).Pawn.PlaySound(Sound'FisherVoice.Stop_Sq_FisherHeartBeat', SLOT_SFX);

			if (EPlayerController(Controller).m_holdingBreath)
				EPlayerController(Controller).m_holdingBreath = false;
		}
	}
}

//------------------------------------------------------------------------
// Description		
//		I need to overload every tick so that the noise is persistent even
//		when we change state
//------------------------------------------------------------------------
state s_Selected
{
	function BeginState()
	{
		Super.BeginState();
		if (Sn == None && Controller.bIsPlayer)
		{
			Sn = spawn(class'ESniperNoise', self);
			if (Sn == None)
				Log("ERROR: SniperNoise could not be spawned for"@self);
		}
	}

	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
		UpdateSniperNoise(DeltaTime);
		CheckShellCase();
	}
}

state s_Firing
{
	function BeginState()
	{
		Super.BeginState();
		if (bSniperMode)
			Sn.Recoil(EPlayerController(Controller));
	}

	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
		UpdateSniperNoise(DeltaTime);
		CheckShellCase();
	}
}

state s_Reloading
{
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
		CheckShellCase();
	}
}

//------------------------------------------------------------------------
// Description		
//		Only return SniperNoisedRotation when updated in DrawView
//------------------------------------------------------------------------
event Vector GetFireEnd()
{
	if (bSniperMode)
	{
		return GetFireStart() + (vect(1, 0, 0) >> SniperNoisedRotation) * ShootingRange;
	}
	else
		return Super.GetFireEnd();
}

function Vector GetFireDirection(Vector ShotDirection)
{
	if (bSniperMode)
		return Vector(SniperNoisedRotation);
	else
		return Super.GetFireDirection(ShotDirection);
}

/* Joshua - Replacing with ZoomIn and ZoomOut functions like SCPT
function Zoom(optional bool bInit)
{
	// nothing to do if only one zoom
	if (FOVIndex < FOVs.Length - 1 && !bInit)
	{
		FOVIndex++;
	}
	else
		FOVIndex = 0;

	// modify vision fov
	if (Controller != None && Controller.bIsPlayer)
	{
		// Changing directly zoom might mess up cinematic camera.
		EPlayerController(Controller).SetCameraFOV(Controller, GetZoom());
	}
}
 */

function ZoomIn(optional bool bInit)
{
    local float factor;
    local EPlayerController EPC;
	local int oldFOVIndex;
    
    EPC = EPlayerController(Controller);
	oldFOVIndex = FOVIndex;
    
    if (bInit)
    {
        if (EPC != None && !EPC.bF2000ZoomLevels)
            FOVIndex = FOVs.Length - 1;
        else
            FOVIndex = 0;
    }
    else
    {
        if (EPC != None && !EPC.bF2000ZoomLevels)
            FOVIndex = FOVs.Length - 1;
        else if (FOVIndex < FOVs.Length - 1)
            FOVIndex++;
    }

    if (Controller != None && Controller.bIsPlayer)
    {
        EPC.SetCameraFOV(Controller, GetZoom());
        
        factor = EPC.DesiredFOV / GetZoom();
        // Only play sound if the zoom level actually changed
        if (EPC.bF2000ZoomLevels && FOVIndex != oldFOVIndex)
            Controller.Pawn.PlaySound(Sound'Interface.Play_FisherEquipStickyCam', SLOT_SFX);
    }
}

function ZoomOut()
{
    local float factor;
    local EPlayerController EPC;
	local int oldFOVIndex;
    
    EPC = EPlayerController(Controller);
	oldFOVIndex = FOVIndex;
    
    // If bF2000ZoomLevels is false, don't allow zooming out
    if (EPC != None && !EPC.bF2000ZoomLevels)
        return;
        
    if (FOVIndex <= 0)
        return;

    FOVIndex--;

    if (Controller != None && Controller.bIsPlayer)
    {
        EPC.SetCameraFOV(Controller, GetZoom());

        factor = EPC.DesiredFOV / GetZoom();
        // Only play sound if the zoom level actually changed
        if (EPC.bF2000ZoomLevels && FOVIndex != oldFOVIndex)
            Controller.Pawn.PlaySound(Sound'Interface.Play_FisherEquipStickyCam', SLOT_SFX);
    }
}

// Joshua - Validate zoom level if zoom levels were disabled while in-game
function ValidateZoomLevel()
{
    if (!EPlayerController(Controller).bF2000ZoomLevels && FOVIndex != FOVs.Length - 1)
    {
        FOVIndex = FOVs.Length - 1;
    }
}

function float GetZoom()
{
	return FOVs[FOVIndex];
}

function SetSniperMode(bool bIsSniping)
{
	bSniperMode = bIsSniping;
	
	// if in sniper mode, allow only single fire
	if (bSniperMode)
	{
		if (IsPlaying(FireAutomaticSound))
			PlaySound(FireAutomaticEndSound, SLOT_SFX);

		GotoState('s_Selected');

		
		eROFMode_old = eROFMode; // Joshua - Switch back to previous RoF when leaving sniper mode
		eROFMode = ROF_Single;

		//Zoom(true);
		ZoomIn(true); // Joshua - Replacing with ZoomIn and ZoomOut functions like SCPT

		if (Controller.bIsPlayer)
			EPlayerController(Controller).iRenderMask = 1;
	}
	else if (Controller.bIsPlayer)
	{
		// Joshua - Switch back to previous RoF when leaving sniper mode
		if (eROFMode_old != eROFMode)
		{
			eROFMode = eROFMode_old;
		}
		EPlayerController(Controller).iRenderMask = 0;
	}
}
