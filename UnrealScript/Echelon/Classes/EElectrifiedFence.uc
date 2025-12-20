class EElectrifiedFence extends EGameplayObject;

var() bool		Electrified;	// True if this fence lectrifies upon bump
var() int		Damage;
var() Sound		HummmSound;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (HummmSound != None)
		SetTimer(GetSoundDuration(HummmSound), true);
}

function Timer()
{
	PlaySound(HummmSound, SLOT_SFX);
}

function Trigger(Actor other, Pawn EventInstigator, optional name InTag)
{
	Super.Trigger(Other, EventInstigator, InTag);

	Electrified = !Electrified;
}

event BulletWentTru(Actor Instigator, vector HitLocation, vector HitNormal, vector Momentum, Material HitMaterial)
{
	if (SurfaceType == SURFACE_FenceMetal)
		PlaySound(Sound'Special.Play_Random_BulletHitFence', SLOT_SFX);
	else if (SurfaceType == SURFACE_FenceVine)
		PlaySound(None/*Waiting for the event*/, SLOT_SFX);

	Instigator.MakeNoise(1000, NOISE_Ricochet);
}

defaultproperties
{
    Electrified=True
    Damage=5
    bDamageable=False
    bClimbable=True
    bNPCBulletGoTru=True
    bPlayerBulletGoTru=True
    SurfaceType=SURFACE_FenceMetal
    bStaticMeshCylColl=False
    bBlockProj=False
    bBlockNPCVision=False
    bCPBlockPlayers=True
    bCPBlockActors=True
    bCPBlockProj=True
}