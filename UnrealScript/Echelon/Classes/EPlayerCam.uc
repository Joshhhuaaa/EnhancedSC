//=============================================================================
// EPlayerCam
//
// PlayerCam
//=============================================================================
class EPlayerCam extends Actor
	native;

var()		ECamParam			m_camParam[NUMCAMMODE];	// taken from Actor.uc
var()		ECamMode			m_camMode;
var			EVolumeSize			m_volSize;
var			EPlayerController	m_EPC;
var			EPawn				m_sam;
var			float				m_prevTargetZ;
var			vector				m_prevLocalTarget;
var			float				m_prevDistance;
var			float				m_prevIdealDistance;
var			bool				m_rotatedSam;
var			bool				m_fixedTarget;
var			float				m_fixedTargetSpeed;
var			vector				m_fixedTargetPos;
var			vector				m_fixedTargetPos2;
var			vector				m_prevStartPos;
var			vector				m_prevOffset;
var			vector				m_prevGlobalOffset;
var			float				m_prevCloseupAdjust;
var			float				m_dampedTurn;
var			float				m_dampedLookUp;
var			int					m_hitRoll;
var			int					m_hitFadeOut;
var			int					m_tiltPitch;
var			int					m_tiltTargetPitch;
var			int					m_tiltSpeed;
var			int					m_tiltFadeOut;
var			int					m_shakeRoll;
var			int					m_shakeTargetRoll;
var			int					m_shakeSpeed;
var			int					m_shakeFadeOut;

// Rotation
var() float	m_yawSpeed;
var() float	m_pitchSpeed;
var() int	m_minPitch;
var() int	m_maxPitch;
var() float	m_pitchCurveBias;
var() float	m_constraintSpeed;
var rotator m_resettingRotation;
var() float	m_resetPitchSpeed;
var() float	m_resetYawSpeed;

// Distance
var() float	m_absoluteMinDist;
var() float	m_targetZMaxDist;
var() float	m_collisionRadius;
var() float	m_collisionHeight;
var() float	m_NPCDistance;
var() float	m_minCleanDist;
var() float	m_closeupDist;
var() float	m_closeupHeight;
var() float	m_closeupDamping;

native(1117) final function InitCameraSettings();
native(1118) final function FollowingRotation(actor ViewActor);
native(1124) final function bool ResettingRotation();
native(1119) final function FollowingCalcView(actor ViewActor, out vector CameraLocation, out rotator CameraRotation);
native(1120) final function SetMode(ECamMode mode);
native(1140) final function UpdateView(Rotator rot, bool relative);

// state override
function UpdateRotation(actor ViewActor);
function ResetRotation(rotator resetRot, float rate);
function CalcView(actor ViewActor, out vector CameraLocation, out rotator CameraRotation);

function bool IsBTW()
{
	return m_camMode >= ECM_BTW && m_camMode <= ECM_BTWRightFP;
}

function Hit(int strenght, int fadeOut, optional bool noRumble)
{
	if (!noRumble)
		Level.RumbleShake(0.1, 1.0);
	m_hitRoll = strenght;
	m_hitFadeOut = fadeOut;
}


function Tilt(int strenght, int speed, int fadeOut, optional bool noRumble)
{
	if (!noRumble)
		Level.RumbleShake(0.3, 0.75);
	m_tiltPitch = strenght;
	m_tiltTargetPitch = strenght;
	m_tiltSpeed = speed;
	m_tiltFadeOut = fadeOut;
}

function Shake(int strenght, int speed, int fadeOut, optional bool noRumble)
{
	if (!noRumble)
		Level.RumbleShake(0.3, 0.75);
	m_shakeRoll = strenght;
	m_shakeTargetRoll = strenght;
	m_shakeSpeed = speed;
	m_shakeFadeOut = fadeOut;
}

function ResetEffects()
{
	m_hitRoll = 0;
	m_tiltPitch = 0;
	m_tiltTargetPitch = 0;
	m_shakeRoll = 0;
	m_shakeTargetRoll = 0;
}

function PostBeginPlay()
{
	// Read Settings from SplinterCellSettings.ini
	InitCameraSettings();

	// Some default values
	m_prevDistance = 200.0;
	m_prevIdealDistance = 200.0;
}

function SetFixeTarget(vector targetPos, float speed, optional vector targetPos2)
{
	m_fixedTargetSpeed = speed;
	m_fixedTargetPos = targetPos;
	m_fixedTargetPos2 = targetPos2;
	m_fixedTarget = true;
}

function StopFixeTarget()
{
	m_fixedTarget = false;
}

function float GetCurrentDistance()
{
	return m_camParam[m_camMode].Distance[m_volSize];
}

auto state s_Following
{
	function ResetRotation(rotator resetRot, float rate)
	{
		local vector currentDir, wantedDir;
		currentDir = Vector(m_EPC.Rotation);
		wantedDir = Vector(resetRot);
		if ((currentDir dot wantedDir) < 0.92)
		{
			m_resettingRotation = resetRot;
			m_resetPitchSpeed = default.m_resetPitchSpeed * rate;
			m_resetYawSpeed = default.m_resetYawSpeed * rate;
			GoToState('s_Reseting');
		}
		m_EPC.bResetCamera = 0;
	}

	function UpdateRotation(actor ViewActor)
	{
		local rotator tmp;

		if (m_EPC.bResetCamera != 0)
		{
			tmp = m_EPC.Pawn.Rotation;
			if (!m_EPC.CanResetCameraYaw())
				tmp.Yaw = m_EPC.Rotation.Yaw;
			tmp = Normalize(tmp);
			ResetRotation(tmp, 0.8);
		}
		FollowingRotation(ViewActor);
	}

	function CalcView(actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
	{
		FollowingCalcView(ViewActor, CameraLocation, CameraRotation);
	}
}

state s_Reseting extends s_Following
{
	function UpdateRotation(actor ViewActor)
	{
		if (ResettingRotation())
		{
			m_EPC.ePawn.YawTurnSpeed = m_EPC.ePawn.default.YawTurnSpeed;
			GoToState('s_Following');
		}
	}
}

state s_Fixed
{
	function BeginState()
	{
		ResetEffects();
	}

	function EndState()
	{
		ResetEffects();
	}

	function UpdateRotation(actor ViewActor)
	{
		UpdateView(m_EPC.Rotation, false);
	}
	
	function CalcView(actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
	{
	}
}

defaultproperties
{
    m_yawSpeed=40000.000000
    m_pitchSpeed=25000.000000
    m_minPitch=-16380
    m_maxPitch=16380
    m_pitchCurveBias=0.200000
    m_constraintSpeed=30000.000000
    m_resetPitchSpeed=45000.000000
    m_resetYawSpeed=75000.000000
    m_absoluteMinDist=25.000000
    m_targetZMaxDist=100.000000
    m_collisionRadius=15.000000
    m_collisionHeight=15.000000
    m_NPCDistance=200.000000
    m_closeupDist=200.000000
    m_closeupHeight=20.000000
    m_closeupDamping=0.600000
    bHidden=True
}