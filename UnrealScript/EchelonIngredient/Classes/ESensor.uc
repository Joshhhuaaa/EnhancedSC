class ESensor extends EGameplayObject
	abstract
	native;

struct DegRot
{
	var() int PitchDegreeModifier, 
			  YawDegreeModifier, 
			  RollDegreeModifier;
};

var()	DegRot	NeutralRotation;		// Starting point for the head in degree modicier before doing actual patrol angle
var()   int     PatrolAngle;            // Patrol Angle in degree (max angle to search a target)
var()   int     PatrolSpeed;            // Patrol Speed - Number of seconds for a complete rotation
var()   int     RotationVelocity;       // Max speed at which this sensor can rotate on all angles
var()	float   VisibilityConeAngle;
var()	float	VisibilityMaxDistance;

var()	EDetectionType		SensorType;
var()	float				SensorThreshold;	// Depending on SensorType, minimum variation for detection (min. heat intensity, min. movement delta, ...)
var()	EScannedActorType	SensorDetectionType;// detect : only player / only pawns / all changed actors?

var()   bool    FollowUponDetection;    // True if the sensor will target and follow detected actor
var()	bool	ZoomUponDetection;		// True will make the sensor zoom in on the target

var()	bool	ShootUponDetection;		// FollowUponDetection must be true. True will damage actor in line of sight
var()	float	ShootDetectionDelay;	// Number of seconds elapsing from the time the Target is detected to its shooting
var(AI)	float	AlarmDetectionDelay;	// Number of seconds elapsing from the time the Target is detected before sending a message to group AI
var()	float	BulletsPerMinute;		// Number of bullet per minutes
var()	int		BulletDamage;			// Damage each bullet does 
var()	int		DamageMinAmount;		// If bDamageable, the min amount of damage it takes to actually give damage

// INTERNAL VARS.
var     Rotator InitialRotation,		// Object's initial rotation
				PrevRotation;			// To track sound playing

var     int     RealRotationSpeed;      // Object's real Rotation speed in engine basis for one second
var     int     RealPatrolAngle;        // Object's real PatrolAngle in engine basis (base 65535)
var     Actor   Target;                 // Current target
var		float	fDetectionElapsedTime;	// Time elapsed since Target was acquired
var		bool	bAlarmMsgSent;			// True if message has been sent to Alarm
var		float	fGrower;
var		float	fBulletElapsedTime;		// Time elapsed since last bullet was shot

var		Name	HeadBone;
var		Rotator	CurrentRotation;

struct DPInfo // detected pawn info
{
	var Actor		Actor;
	var EChangeType	ChangeType;
};

var array<DPInfo> DetectedActors;		// Ignore ChangedActors

// Audio
var		Sound	Sound_Rot_Loop, 
				Sound_Rot_End,
				SoundAlert,
				SoundFire,
				SoundFire_End,
				SoundZoom,
				SoundReverse,
				SoundDisable,
				DetectedSound,
				BodySound;

var bool   bRotationSoundPlaying;

var Sound				BulletSound;

var material            BulletMaterial;



native(1250) final function bool TargetStillVisible();

event PreBeginPlay()
{
	Super.PreBeginPlay();
}

function PostBeginPlay()
{
	local int		i;
	local Rotator	RealNeutralRot;

	// Apply Neutral Rotation modifier
    if(NeutralRotation.PitchDegreeModifier != 0)
	    RealNeutralRot.Pitch = 65535/(360/float(NeutralRotation.PitchDegreeModifier));

    if(NeutralRotation.YawDegreeModifier != 0)
	    RealNeutralRot.Yaw = 65535/(360/float(NeutralRotation.YawDegreeModifier));

    if(NeutralRotation.RollDegreeModifier != 0)
	    RealNeutralRot.Roll = 65535/(360/float(NeutralRotation.RollDegreeModifier));

	// Keep Starting rotation
    InitialRotation = Rotation + RealNeutralRot;
	CurrentRotation = InitialRotation;

	// Place head at neutral rotation
	SetSensorRotation(InitialRotation);

    // Rotation from "sec for a turn" into 65535 base
    if(PatrolSpeed != 0)
    {
        RealRotationSpeed = 65535/PatrolSpeed;
    }
    else
    {
        log("FIXME: " $ Name $ " PatrolSpeed is null. Would've caused division by 0.");
    }

    // Angle from degree to 65535 base
    if(PatrolAngle != 0)
    {
        RealPatrolAngle = 65535/(360/float(PatrolAngle));
    }
    else
    {
        log("FIXME: " $ Name $ " PatrolAngle is null. Would've caused division by 0.");
    }

    Super.PostBeginPlay();
}

//------------------------------------------------------------------------
// Description		
//		Check if rotation is within defined range
//------------------------------------------------------------------------
function bool IsWithinRotationRange( Rotator WantedRotation )
{
    local rotator Delta, Range;
	Delta = Normalize(WantedRotation - InitialRotation);
    
	Range = RealPatrolAngle/2 * Rot(1,1,0);

	//Log("Delta"@Delta@"-- Range"@Range@( Abs(Delta.Yaw) < Range.Yaw && Abs(Delta.Pitch) < Range.Pitch ));

	// normalize does that algorithm above, for all parts of the rotator
    return ( Abs(Delta.Yaw) < Range.Yaw &&
             Abs(Delta.Pitch) < Range.Pitch );
}

//------------------------------------------------------------------------
// Description		
//		Prevent the camera from rotating more than its RotationVelocity per seconds
//------------------------------------------------------------------------
function AdjustTrajectory( float DeltaTime, Rotator WantedRotation, bool PlayScan )
{
	local int Delta, y,p;
	local int Ymin, Ymax, Pmin, Pmax;
	local float distance;
	
	Delta = DeltaTime * RotationVelocity;

	WantedRotation.Pitch= InterpolateRotatorValue(Delta, CurrentRotation.Pitch, WantedRotation.Pitch);
	WantedRotation.Yaw	= InterpolateRotatorValue(Delta, CurrentRotation.Yaw, WantedRotation.Yaw);

	// Set the bone rotation
	SetSensorRotation(WantedRotation);

	// Keep current rotation since GetBoneRotation returns local matrices
	CurrentRotation = WantedRotation;

	// rotation sound
	if( CurrentRotation != PrevRotation )
	{
		distance = VSize(GetSensorPosition() - EchelonGameInfo(Level.Game).pPlayer.ePawn.Location);
		if ( !IsPlaying(Sound_Rot_Loop) && ( ( m_bPlayIfSameZone || m_ListOfZoneInfo.Length != 0 || distance < AmbientPlayRadius ) && PlayScan ) )
		{
			if (IsPlaying(SoundFire) && !IsPlaying(SoundFire_End))
				PlaySound(SoundFire_End, SLOT_SFX);
			PlaySound(Sound_Rot_Loop, SLOT_SFX);
			bRotationSoundPlaying = true;
		}
		else if ( bRotationSoundPlaying && ( !m_bPlayIfSameZone && m_ListOfZoneInfo.Length == 0 && distance > AmbientStopRadius ) )
		{
			bRotationSoundPlaying = false;
			PlaySound(Sound_Rot_End, SLOT_SFX);
		}
	}
	else if ( bRotationSoundPlaying )
	{
		bRotationSoundPlaying = false;
		PlaySound(Sound_Rot_End, SLOT_SFX);
	}

	PrevRotation = CurrentRotation;
}

//------------------------------------------------------------------------
// Description		
//		To be redefined in subclasses not using bones
//------------------------------------------------------------------------
event Vector GetSensorPosition()
{
	return GetBoneCoords(HeadBone, true).Origin;
}
event Vector GetSensorDirection()
{
	return GetBoneCoords(HeadBone, true).XAxis;
}
function SetSensorRotation( Rotator NewRotation )
{
	SetBoneDirection(HeadBone, NewRotation);
}

//------------------------------------------------------------------------
// Description		
//		Takes a rotation, and makes it within or closer to valid range
//------------------------------------------------------------------------
function RotateIntoValidRange( float DeltaTime )
{
	local int		Low, High;
	local float		Delta, distance;
	local Rotator	aRotation, tmpRot;

	aRotation = CurrentRotation;
	tmpRot = aRotation;
    tmpRot.Yaw += DeltaTime*RealRotationSpeed;
    if( IsWithinRotationRange(tmpRot) )
	{
		// This simple rotation is valid, get outta there
		//Log("Inside rotation range"@tmpRot@RealRotationSpeed);
		aRotation.Yaw = tmpRot.Yaw;
	}
	else
    {
		distance = VSize(GetSensorPosition() - EchelonGameInfo(Level.Game).pPlayer.EPawn.Location);
		if ( m_bPlayIfSameZone || m_ListOfZoneInfo.Length != 0 || distance < AmbientPlayRadius )
			PlaySound(SoundReverse, SLOT_SFX);

		// Reverse rotation direction (left-to-right VS right-to-left)
        //Log("* * * * * * * * Reverse at"@aRotation);
        RealRotationSpeed = -RealRotationSpeed;

		aRotation.Yaw = tmpRot.Yaw;

		/////////////////////////////////////////////////////////////
		// We're not within range. Find closer value to valid range
		/////////////////////////////////////////////////////////////
		// Get min and max from original rotation
		Low		= InitialRotation.Yaw-(RealPatrolAngle/2);
		High	= InitialRotation.Yaw+(RealPatrolAngle/2);

		if( Abs(aRotation.Yaw-Low) > Abs(aRotation.Yaw-High) )
		{
//			Log("Closer to low"@aRotation.Yaw@Low);
			//aRotation.Yaw = Delta;
			aRotation.Yaw = Low;
		}
		else
		{
//			Log("Closer to high"@aRotation.Yaw@High);
			//aRotation.Yaw -= Delta;
			aRotation.Yaw = High;
		}
	}
	
	// ResetPitch to make it go back gradually to initial position
	aRotation.Pitch = InitialRotation.Pitch;

	// Call the SetRotation
	AdjustTrajectory(DeltaTime, aRotation, true);
}

function SpawnShellCase();

//---------------------------------------[ Alain Turcotte @ 6 avr. 2001 ]-
// 
// Description		
//
//------------------------------------------------------------------------
function CheckLineTrace( float DeltaTime )
{
	local Vector	HitLocation, HitNormal, vEndTrace, BoneDirection, BonePos;
    local actor		Other, Muzzle;
	local int		PillTag;
	local Material	HitMaterial;
	local EWallHit	Spark;
	local Rotator	projRot;
	local vector	X, Y, Z;
	local Pawn		Instigator;  // Joshua - Added for PlayerStats
	
	// Do nothing if can't pawn bullet
	if( fBulletElapsedTime < (60.0f/BulletsPerMinute) )
		return;

	// Turret will open fire if in line of sight
	BonePos = GetSensorPosition();
	BoneDirection = GetSensorDirection();

	vEndTrace = BonePos + VisibilityMaxDistance * BoneDirection;
	Other = TraceBone(PillTag, HitLocation, HitNormal, vEndTrace, BonePos, HitMaterial, true); // real fire

	if( Other == Target || (Other != None && FRand() > 0.5) )
	{
		vEndTrace = BonePos + VisibilityMaxDistance * GetVectorFrom(Rotator(BoneDirection), 5);
		Other = TraceBone(PillTag, HitLocation, HitNormal, vEndTrace, BonePos, HitMaterial);

		// Shoot
		fBulletElapsedTime = 0.0f;

		if( !IsPlaying(SoundFire) )
			PlaySound(SoundFire, SLOT_SFX);

		// muzzle flash
		Muzzle = Spawn(class'EMuzzleFlash', self);
		Muzzle.SetDrawScale(0.5f);
		Muzzle.SetDrawScale3D(Vect(2,1,1));
		Muzzle.LifeSpan	= 0.01;
		AttachToBone(Muzzle, HeadBone);
		Muzzle.SetRelativeLocation(Vect(52,0,35));

		SpawnShellCase();

		MakeNoise(2000.0, NOISE_TurretGunfire);

		if( Other == None )
			return;

		SpawnWallHit(Other, HitLocation, HitNormal, HitMaterial);

		if( !Other.bWorldGeometry )
		{
			// Joshua - Pass player as instigator if using SCAN_AllPawnsAndChangedActors (IFF disabled)
			if (SensorDetectionType == SCAN_AllPawnsAndChangedActors)
				Instigator = EchelonGameInfo(Level.Game).pPlayer.ePawn;
			else
				Instigator = None;
				
			// momentum almost null to prevent flares and change object to be pushed ayway by turret firing
			Other.TakeDamage(BulletDamage, Instigator, HitLocation, HitNormal, Normal(HitLocation - BonePos) /** 300.f*/, None, PillTag);
		}
    }
	else
		StopFireSound();
}

// Aim at head
function float GetHeightFactor()
{
	return 0.4;
}

function StopFireSound()
{
	if( IsPlaying(SoundFire) && !IsPlaying(SoundFire_End) )
		PlaySound(SoundFire_End, SLOT_SFX);
}

function SpawnWallHit(Actor HitActor, vector HitLocation, vector HitNormal, Material HitMaterial)
{
	local EWallHit Spark;
	local Rotator projRot;

	if( HitActor.bWorldGeometry || HitActor.DrawType == DT_StaticMesh )
	{
		BulletMaterial		= HitMaterial;
		projRot				= Rotator(HitNormal);
		projRot.Roll		= FRand() * 65536;
		Spark				= spawn(class'EWallHit', self,, HitLocation+HitNormal, projRot);
		Spark.HitMaterial	= HitMaterial;
		Spark.HitActor		= HitActor;
		Spark.SndBullet		= BulletSound;	
		Spark.Emit();
		Spark.Noise();
	}
}

//------------------------------------------------------------------------
// Description		
//		Manage take damage
//------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector HitNormal, Vector momentum, class<DamageType> damageType, optional int PillTag )
{
	if( Damage >= DamageMinAmount )
		Super.TakeDamage( Damage, instigatedBy, hitlocation, HitNormal, momentum, damageType, PillTag );
}

//------------------------------------------------------------------------
// Description		
//		Add a found pawn to prevent stopping on him again.
//------------------------------------------------------------------------
function bool ProcessDetectedPawn()
{
	local int i;
	for( i=0; i<DetectedActors.Length; i++ )
	{
		if( DetectedActors[i].Actor == Target )
		{
			DetectedActors[i].ChangeType = Target.ChangeType;
			Log("Found at"@i);
			return false;
		}
	}

	// Not found
	Log("Added ["$Target$"] at ["$i$"]");
	DetectedActors.Length = i+1;
	DetectedActors[i].Actor = Target;
	DetectedActors[i].ChangeType = Target.ChangeType;

	return false;
}

//--------------------------------------------------------------------------
//
//  State s_Patrol
//  Turret is waiting for something before going into s_Patrol mode
//
//--------------------------------------------------------------------------
state() s_Idle
{
	function BeginState()
	{
		StopFireSound();
		//Log("ESensor is s_Idle:"@self.name);
	}

    function Tick( float DeltaTime )
    {
        if( FollowUponDetection && FrustumScanning(Target,SensorType,SensorThreshold,SensorDetectionType) )
            GoToState('s_Alert');
    }
}

//--------------------------------------------------------------------------
//
//  State s_Patrol
//  Turret is patrolling area determined by designer variables
//
//--------------------------------------------------------------------------
auto state() s_Patrol
{
	function BeginState()
	{
		//Log(self@"************************************ BEGIN s_patrol");
	}

    function Tick( float DeltaTime )
    {
        local Rotator	tmpRotation;
		local float		Delta;

		//Log("ESensor in s_Patrol");
		StopFireSound();

		// Update time
		fBulletElapsedTime += DeltaTime;

		// Update bone rotation
		RotateIntoValidRange(DeltaTime);

		// find target
        if( FollowUponDetection && FrustumScanning(Target,SensorType,SensorThreshold,SensorDetectionType) )
        {
			//Log("Actor found"@Target@);

			// Detect if within sensor rotation range (without this check here, it will switch between alert and patrol repeatedly)
			tmpRotation = Rotator(Target.Location - GetSensorPosition());
			if( IsWithinRotationRange(tmpRotation) )
			{
				//log("frustum scanning going to s_alert  ==> target : " $ Target $ "  sensortype : " $ SensorType $ "  sensorthreshold : " $ SensorThreshold);
				GoToState('s_Alert');
			}
			//else
			//	Log("Not in rotation range"@Target);
        }
    }
}

//--------------------------------------------------------------------------
//
//  State s_Alert
//  Turret has detected an object inside its Field Of View. Will try to
//      target(orient) on player according to its physical limit
//
//--------------------------------------------------------------------------
state s_Alert
{
	function BeginState()
	{
		//Log(self@"************************************ BEGIN s_Alert by"@Target);
		bAlarmMsgSent = false;
		fDetectionElapsedTime = 0.0f;

		StopFireSound();

		PlaySound(Sound_Rot_End, SLOT_SFX);

		if( !IsPlaying(SoundZoom) )
			PlaySound(SoundZoom,SLOT_SFX);

		if( !IsPlaying(SoundAlert) )
			PlaySound(SoundAlert, SLOT_SFX);
	}

	function EndState()
	{
		StopSound(Sound_Rot_Loop);
		if( !IsPlaying(SoundZoom) )
			PlaySound(SoundZoom,SLOT_SFX);

		StopSound(SoundAlert);
	}

    function Tick( float DeltaTime )
    {
		local vector hitl, hitn;
        local Vector	SpecificLocation;
        local Rotator	rSeekingDir;
     
		//Log("ESensor in s_Alert");

		// Update time
		fBulletElapsedTime += DeltaTime;
		fDetectionElapsedTime += DeltaTime;

        // Be sure Target is not None								// Go back in s_Patrol if:
        if( FollowUponDetection == false						||	// if changed in real time, else, never supposed to be here
			Target == None )										// No more target
		{
			//Log("Full of shit cases say i can't stay alerted");
			TargetNotVisible();
            return;
		}

		if( SensorType == 1 && Target.HeatIntensity == 0 )
		{
			//Log(self$" Target emits no more heat if in heat mode");
			TargetNotVisible();
            return;
		}

		if( !TargetStillVisible() )
		{
			//Log(self$" can't see target anymore");
			TargetNotVisible();
            return;
		}

        // Try to move sensor orientation in direction of Target
		if( Target.bIsPawn )
			SpecificLocation = Target.GetBoneCoords('B Spine').Origin;
		else
			SpecificLocation = Target.Location;
		SpecificLocation += Target.ToWorldDir(GetHeightFactor()*Target.CollisionHeight*Vect(0,0,1));

		// If seeking dir is out of range, do not move turret over to it.
		// So adjust only after .. else, the result will be the camera will try to move
        rSeekingDir = Rotator(SpecificLocation - GetSensorPosition());
        if( !IsWithinRotationRange(rSeekingDir) )
		{
			//Log("Not Within rotation dir");
            TargetNotVisible();
            return;
		}
        AdjustTrajectory(DeltaTime, rSeekingDir, false);

		if( fDetectionElapsedTime >= AlarmDetectionDelay )
		{
			// Alert pattern
			TriggerPattern();

			if( Alarm != None && !bAlarmMsgSent )
			{
				if  ( self.IsA('EBasecam') && !Alarm.IsInState('s_On') )
				{
					if (Target.bIsPlayerPawn)
					{
					AddOneVoice();
					EchelonGameInfo(Level.Game).pPlayer.EPawn.PlaySound( DetectedSound, SLOT_Voice );
				}
					else if ( !Target.bIsPlayerPawn && SensorDetectionType == SCAN_ChangedPawns )
					{
						AddOneVoice();
						EchelonGameInfo(Level.Game).pPlayer.EPawn.PlaySound( BodySound, SLOT_Voice );
						
						// Joshua - Add to the BodyFound stat when a body is detected by a camera
						if (EPawn(Target) != None && !EAIController(EPawn(Target).Controller).bWasFound && !EAIController(EPawn(Target).Controller).bNotInStats)
						{
							EAIController(EPawn(Target).Controller).bWasFound = true;
							EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
						}
					}
				}

				Alarm.EnableAlarm(Target, None);
				bAlarmMsgSent = true;
			}
			
			if( Target.bIsPawn && !Target.bIsPlayerPawn )
			{
				if( ProcessDetectedPawn() )
				{
					//Log(Target$" pawn detected");
					TargetNotVisible();
					return;
				}
			}
		}

		// Don't do treatment if we're not supposed to shoot
		if( ShootUponDetection && fDetectionElapsedTime >= ShootDetectionDelay )
			CheckLineTrace(DeltaTime);
		else
			StopFireSound();
    }

    event TargetNotVisible()
    {
        Target = None;
        GoToState('s_Patrol');
    }
}

//--------------------------------------------------------------------------
//
//  State s_Test
//  Test mode or perhaps an ingame testmode. Movement is sinuidal
//
//--------------------------------------------------------------------------
state() s_Test
{
	function BeginState()
	{
		fGrower=0.0f;
	}

    function Tick( float DeltaTime )
    {
        local Rotator ViewRotation;
        ViewRotation = Rotator(GetSensorDirection());

		// Update time
		fBulletElapsedTime += DeltaTime;
		fDetectionElapsedTime += DeltaTime;

		fGrower += 0.02f;
        ViewRotation.Yaw += DeltaTime*RealRotationSpeed;
        ViewRotation.Pitch = 5000*cos(fGrower);
		AdjustTrajectory(DeltaTime, ViewRotation, true);
    }
}

//--------------------------------------------------------------------------
//  State s_Deactivated
//--------------------------------------------------------------------------
state s_Deactivated
{
	Ignores TakeDamage;
    
	function BeginState()
	{
		StopFireSound();
		StopSound(Sound_Rot_Loop);
		PlaySound(SoundDisable);

		// Should always be deactivated from Player for this AddChange to be valid
		// Will be false from EBaseCam Trigger from Pattern
		if( ChangeListWhenDamaged )
			Level.AddChange(self, CHANGE_DisabledTurret);
		ChangeListWhenDamaged = true;
	}

	function EndState()
	{
		// Remove it when not deactivated anymore ...
		Level.RemoveChange(self);
	}
}

defaultproperties
{
    PatrolAngle=90
    PatrolSpeed=15
    RotationVelocity=5000
    VisibilityConeAngle=40.000000
    VisibilityMaxDistance=500.000000
    BulletsPerMinute=60.000000
    BulletDamage=1
    HeadBone="Head"
    DrawType=DT_Mesh
    bBlockPlayers=true
    bBlockActors=true
}