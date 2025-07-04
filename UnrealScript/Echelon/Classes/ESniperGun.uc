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

function PostBeginPlay()
{
	Super.PostBeginPlay();
}

function CheckShellCase();

function UpdateSniperNoise(float DeltaTime)
{
	if(bSniperMode)
	{
		SniperNoisedRotation = Controller.Rotation;
		if(Sn.Update(DeltaTime, EPlayerController(Controller)))
		{
			if(!WeaponReticle.IsInState('s_Blinking'))
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
		if(	Sn != None &&
			(LastSniperModeTime + 2.0) < Level.TimeSeconds)
		{
			Sn.ResetFatigue();
			LastSniperModeTime = 1000000.0;
		}
		if(WeaponReticle != None && WeaponReticle.IsInState('s_Blinking'))
			WeaponReticle.GotoState('s_Selected');

		if(	Sn != None &&
			LastSniperModeTime < Level.TimeSeconds )
		{
			if ( EPlayerController(Controller).Pawn.IsPlaying(Sound'FisherVoice.Play_Sq_FisherHeartBeat') )
				EPlayerController(Controller).Pawn.PlaySound(Sound'FisherVoice.Stop_Sq_FisherHeartBeat', SLOT_SFX);

			if ( EPlayerController(Controller).m_holdingBreath )
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
		if(Sn == None && Controller.bIsPlayer)
		{
			Sn = spawn(class'ESniperNoise', self);
			if( Sn == None )
				Log("ERROR: SniperNoise could not be spawned for"@self);
		}
	}

	function Tick( float DeltaTime )
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
		if(bSniperMode)
			Sn.Recoil(EPlayerController(Controller));
	}

	function Tick( float DeltaTime )
	{
		Super.Tick(DeltaTime);
		UpdateSniperNoise(DeltaTime);
		CheckShellCase();
	}
}

state s_Reloading
{
	function Tick( float DeltaTime )
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
	if(bSniperMode)
	{
		return GetFireStart() + (vect(1, 0, 0) >> SniperNoisedRotation) * ShootingRange;
	}
	else
		return Super.GetFireEnd();
}

function Vector GetFireDirection( Vector ShotDirection )
{
	if( bSniperMode )
		return Vector(SniperNoisedRotation);
	else
		return Super.GetFireDirection(ShotDirection);
}


function Zoom( optional bool bInit )
{
	// nothing to do if only one zoom
	if( FOVIndex < FOVs.Length - 1 && !bInit )
	{
		FOVIndex++;
	}
	else
		FOVIndex = 0;

	// modify vision fov
	if( Controller != None && Controller.bIsPlayer )
	{
		// Changing directly zoom might mess up cinematic camera.
		EPlayerController(Controller).SetCameraFOV(Controller, GetZoom());
	}
}

function float GetZoom()
{
	return FOVs[FOVIndex];
}

function SetSniperMode( bool bIsSniping )
{
	bSniperMode = bIsSniping;
	
	// if in sniper mode, allow only single fire
	if( bSniperMode )
	{
		if ( IsPlaying(FireAutomaticSound) )
			PlaySound(FireAutomaticEndSound, SLOT_SFX);

		GotoState('s_Selected');

		eROFMode = ROF_Single;
		Zoom(true);

		if( Controller.bIsPlayer )
			EPlayerController(Controller).iRenderMask = 1;
	}
	else if( Controller.bIsPlayer )
		EPlayerController(Controller).iRenderMask = 0;
}


