class ESniperNoise extends Actor;

var(Noise)	config	float	pitchSize;
var(Noise)	config	float	pitchSpeed;
var(Noise)	config	float	yawSize;
var(Noise)	config	float	yawSpeed;
var(Noise)	config	float	noiseUpSpeed;
var(Noise)	config	float	noiseDownSpeed;

var(Recoil)	config	float	recoilUpSpeed;
var(Recoil)	config	float	recoilDownSpeed;
var(Recoil)	config	float	recoilFatigueUp;
var(Recoil)	config	int		recoilSize;
var(Recoil)	config	int		recoilPitchAdd;
var(Recoil)	config	int		recoilYawAdd;

var(Hold)	config	float	holdMax;
var(Hold)	config	float	tiredMax;

var					float	fatigueLevel;
var					float	noiseDamping;
var					rotator	deltaRot;
var					int		recoilAdd;
var					bool	recoilUp;
var					bool	isTired;

function rotator GetNoise()
{
	return deltaRot;
}

function Recoil(EPlayerController EPC)
{
	local rotator setRot;
	setRot = EPC.Rotation;
	setRot.Pitch += recoilPitchAdd;
	if (FRand() > 0.5)
		setRot.Yaw += recoilYawAdd;
	else
		setRot.Yaw -= recoilYawAdd;
	EPC.SetRotation(setRot);

	fatigueLevel += recoilFatigueUp;
	fatigueLevel = FClamp(fatigueLevel, 0.0, 1.0);
	if (fatigueLevel == 1.0)
		isTired = true;
	recoilUp = true;
}

function ResetFatigue()
{
	fatigueLevel = 0.0;
	noiseDamping = 1.0;
	deltaRot = rot(0,0,0);
	recoilAdd = 0;
	recoilUp = false;
	isTired = false;
}

function bool Update(float deltaTime, EPlayerController EPC)
{
	local bool holding;
	local float PosVar;

	PosVar = EPC.GetSniperPosVar();

	pitchSize = DampFloat(pitchSize, default.pitchSize / PosVar, 100.0, deltaTime);
	yawSize = DampFloat(yawSize, default.yawSize / PosVar, 100.0, deltaTime);
	noiseUpSpeed = DampFloat(noiseUpSpeed, default.noiseUpSpeed * PosVar, 1.0, deltaTime);
	noiseDownSpeed = DampFloat(noiseDownSpeed, default.noiseDownSpeed * PosVar, 1.0, deltaTime);
	holdMax = DampFloat(holdMax, default.holdMax * PosVar, 1.0, deltaTime);

	deltaRot.Yaw = Sin(Level.TimeSeconds * yawSpeed) * yawSize * noiseDamping;
	deltaRot.Pitch = Sin(Level.TimeSeconds * pitchSpeed) * pitchSize * noiseDamping;
	deltaRot.Pitch += recoilAdd;

	holding = EPC.bAltFire != 0 && !isTired;

	if (holding)
		fatigueLevel += deltaTime / holdMax;
	else
		fatigueLevel -= deltaTime / tiredMax;

	fatigueLevel = FClamp(fatigueLevel, 0.0, 1.0);

	if (fatigueLevel == 1.0)
		isTired = true;
	else if (fatigueLevel == 0.0)
		isTired = false;

	if (holding && !isTired)
	{
		if (EPC.m_holdingBreath == false)
		{
			EPC.Pawn.PlaySound(Sound'FisherEquipement.Play_FN2000Crisp', SLOT_SFX);
			EPC.Pawn.PlaySound(Sound'FisherVoice.Play_Sq_FisherHeartBeat', SLOT_SFX);
			EPC.Pawn.PlaySound(Sound'FisherVoice.Play_FisherBreathOut', SLOT_SFX);
		}
		EPC.m_holdingBreath = true;
		noiseDamping = DampFloat(noiseDamping, 0.0, noiseDownSpeed, deltaTime);
	}
	else
	{
		if (EPC.m_holdingBreath == true)
		{
			EPC.Pawn.PlaySound(Sound'FisherVoice.Stop_Sq_FisherHeartBeat', SLOT_SFX);
			EPC.Pawn.StopSound(Sound'FisherVoice.Play_FisherBreathOut', 0.25f);
			EPC.Pawn.AddSoundRequest(Sound'FisherVoice.Play_FisherBreathIn', SLOT_SFX, 0.25f);
		}
		EPC.m_holdingBreath = false;
		noiseDamping = DampFloat(noiseDamping, 1.0, noiseUpSpeed, deltaTime);
	}

	if (recoilUp)
	{
		recoilAdd = DampInt(recoilAdd, recoilSize, recoilUpSpeed, deltaTime);
		if (recoilAdd == recoilSize)
			recoilUp = false;
	}
	else
		recoilAdd = DampInt(recoilAdd, 0, recoilDownSpeed, deltaTime);

	return isTired;
}

defaultproperties
{
    pitchSize=300.000000
    pitchSpeed=2.570000
    yawSize=250.000000
    yawSpeed=2.100000
    noiseUpSpeed=1.600000
    noiseDownSpeed=1.600000
    recoilUpSpeed=15000.000000
    recoilDownSpeed=3000.000000
    recoilFatigueUp=0.300000
    recoilSize=800
    recoilPitchAdd=400
    recoilYawAdd=200
    holdMax=3.000000
    tiredMax=3.000000
    bHidden=true
}