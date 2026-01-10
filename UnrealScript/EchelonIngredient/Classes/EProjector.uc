class EProjector extends ESensor;

var()	Array<EProjectorPathPoint>	ProjectorPoints;
var		int							CurrentPoint;
var()	float						ResumePatrolTime;
var()   Array<EGroupAI>	            SupportGroups;
var()   int                         ProjPatrolSpeed;
var()   int                         ProjAlertSpeed;

event PreBeginPlay()
{
	Super.PreBeginPlay();
}

function PostBeginPlay()
{
	// set values from light
	VisibilityConeAngle = SpotWidth * 0.6f;
	VisibilityMaxDistance = MaxDistance;

	if (ProjectorPoints.Length < 0)
		SetPhysics(PHYS_None);

	Super.PostBeginPlay();

	if (ProjectorPoints.Length > 0)
    {
		SetRotation(Rotator(ProjectorPoints[CurrentPoint].Location - Location));

        // Set the desired rotation to the first patrol point
        DesiredRotation = Rotator(ProjectorPoints[CurrentPoint].Location - Location);
    }
}

event Vector GetSensorPosition()
{
	return Location;
}
event Vector GetSensorDirection()
{
	return Vector(Rotation);
}
function SetSensorRotation(Rotator NewRotation)
{
	SetRotation(NewRotation);
}

//------------------------------------------------------------------------
// Description
//		Gets next patrol point in array
//------------------------------------------------------------------------
function int GetNextPoint()
{
	if (CurrentPoint < ProjectorPoints.Length - 1)
		return CurrentPoint + 1;
	else
		return 0;
}

//------------------------------------------------------------------------
// Description
//		Check if support groups see the player
//------------------------------------------------------------------------
function bool GroupsSeePlayer()
{
    local int i;

    // Check if GroupAI's see the player
    // Use their help then
	for (i = 0; i < SupportGroups.Length ; i++)
    {
        if (SupportGroups[i].PlayerIsVisible())
        {
            return true;
        }
    }

    return false;
}

//------------------------------------------------------------------------
// Description
//		Toggle projector's light beam
//------------------------------------------------------------------------
event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
{
	if (LightType == LT_None)
		LightType = LT_Steady;
	else
		LightType = LT_None;
}

function bool IsRotationValid(vector TargetLocation)
{
	local vector targetDir, initialDir;
	local float dotP, Angle;
	initialDir = vector(InitialRotation);
	targetDir = Normal(TargetLocation - Location);
	dotP = initialDir dot targetDir;
	Angle = (Acos(dotP) * 180.0) / PI;
	//log("initialDir["$initialDir$"] targetDir["$targetDir$"] dotp["$dotp$"] Angle["$Angle$"]");
	return Angle < (PatrolAngle / 2);
}

//------------------------------------------------------------------------
// Description
//		Patrol between projector points
//------------------------------------------------------------------------
auto state s_ProjectorPatrol
{
	function BeginState()
	{
		if (ProjPatrolSpeed != -1)
        {
            RotationRate.Pitch = ProjPatrolSpeed;
            RotationRate.Yaw = ProjPatrolSpeed;
            RotationRate.Roll = ProjPatrolSpeed;
        }

		Super.BeginState();
	}

	function Tick(float DeltaTime)
	{
		if (ProjectorPoints.Length == 0)
			return;

		// Check if point is reached
		if ((Rotation.Pitch&65535) == (DesiredRotation.Pitch&65535) &&
			(Rotation.Yaw&65535) == (DesiredRotation.Yaw&65535)		&&
			(Rotation.Roll&65535) == (DesiredRotation.Roll&65535)	&&
			TimerRate == 0)
		{
			//Log("Point "$ProjectorPoints[CurrentPoint]$" found");

			// If this patrol point wants the projector to wait, else move to next
			if (ProjectorPoints[CurrentPoint].PatrolWaitTime > 0)
			{
				//Log("Setting timer["$ProjectorPoints[CurrentPoint].PatrolWaitTime$"] at point="@ProjectorPoints[CurrentPoint]);
				SetTimer(ProjectorPoints[CurrentPoint].PatrolWaitTime, false);
			}
			else
				Timer();
		}

		if (FollowUponDetection &&
			(GroupsSeePlayer() && IsRotationValid(EchelonGameInfo(Level.Game).pPlayer.EPawn.Location)) ||
			(FrustumScanning(Target,,,SensorDetectionType)) && IsRotationValid(Target.Location))
		{
			//Log("Alert form patrol tick");
			GotoState('s_ProjectorAlert');
	}
	}

	function Timer()
	{
		// Move on to next point
		CurrentPoint = GetNextPoint();
		DesiredRotation = Rotator(ProjectorPoints[CurrentPoint].Location - Location);

		//Log("Moving to next point="@ProjectorPoints[CurrentPoint]);
	}
}

//------------------------------------------------------------------------
// Description
//  When the player is seen
//------------------------------------------------------------------------
state s_ProjectorAlert
{
	function BeginState()
	{
		//Log(self@"alerted by"@Target);

		bAlarmMsgSent = false;
		fDetectionElapsedTime = 0.0f;

        if (ProjAlertSpeed != -1)
        {
            RotationRate.Pitch = ProjAlertSpeed;
            RotationRate.Yaw = ProjAlertSpeed;
            RotationRate.Roll = ProjAlertSpeed;
        }

		// Alert pattern
		TriggerPattern();
	}

	function Tick(float DeltaTime)
	{
        if (GroupsSeePlayer() && IsRotationValid(EchelonGameInfo(Level.Game).pPlayer.EPawn.Location))
        {
			//Log("Group see player");
            DesiredRotation = Rotator(EchelonGameInfo(Level.Game).pPlayer.EPawn.Location - Location);
        }

        // If Target can not be seen, pause then go back to patrol
		else if (FrustumScanning(Target,,,SensorDetectionType) && IsRotationValid(Target.Location))
		{
            //log("In frustum : "$Target);

			// Update time
			fDetectionElapsedTime += DeltaTime;

			if (fDetectionElapsedTime >= AlarmDetectionDelay && Alarm != None && !bAlarmMsgSent)
			{
                //log("Sending alarm primary message .... "$self);
                if (Target.bIsPlayerPawn)
                {
                    // Alarm w/ ForceUpdateLocation
				    Alarm.EnableAlarm(Target, None,true);
                }
                else
                {
                    // Alarm without ForceUpdateLocation
                    Alarm.EnableAlarm(Target, None, false);
                }
				bAlarmMsgSent = true;
			}

			if (TimerRate != 0)
				SetTimer(0, false);

			DesiredRotation = Rotator(Target.Location - Location);
		}
		else if (TimerRate == 0)
		{
			//Log("Target lost .. setting timer");
			SetTimer(ResumePatrolTime, false);
		}
	}

    //------------------------------------------------------------------------
    // Description
    //  Goes back to s_ProjectorPatrol
    //------------------------------------------------------------------------
	function Timer()
	{
		GotoState('s_ProjectorPatrol');
	}
}

defaultproperties
{
    ResumePatrolTime=3.000000
    ProjPatrolSpeed=-1
    ProjAlertSpeed=-1
    FollowUponDetection=True
    bDestroyWhenDestructed=False
    AlarmLinkType=EAlarm_Trigger
    Physics=PHYS_Rotating
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'LightGenOBJ.UnbreakableLight.ABA_spot_aba00B'
    bBlockActors=False
    bBlockNPCVision=False
    LightType=LT_Steady
    LightEffect=LE_ESpotShadow
    LightBrightness=255
    LightHue=72
    LightSaturation=232
    LightRadius=154
    LightCone=70
    MinDistance=85.000000
    MaxDistance=2000.000000
    SpotHeight=40.000000
    SpotWidth=40.000000
    RotationRate=(Pitch=5000,Yaw=5000,Roll=5000)
    bRotateToDesired=True
}