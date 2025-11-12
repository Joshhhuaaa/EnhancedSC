class EBreakableGlass extends Mover
		placeable;

#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

var() class<Emitter>	BreakEmitterClass;
var() int				ImpactResistance;
var() int				HitBeforeShatter;

var() name				GroupTag;
var() name				JumpLabel;

//------------------------------------------------------------------------
// Description		
//		Called from EPlayerController to break when pass through it
//------------------------------------------------------------------------
function Timer()
{
	if (SavedTrigger == None)
		Log("ERROR : Should have a breaker pawn to go through glass");

	Bump(SavedTrigger);
}

//------------------------------------------------------------------------
// Description		
//		Bumps should destroy at a minimum velocity
//------------------------------------------------------------------------
function Bump(Actor Other, optional int Pill)
{
	local float ImpactForce;
	local float ImpactMass;

	// Check force of impact OR number of hits
	ImpactForce = Normal(Other.Velocity) dot Vector(Rotation);
	ImpactMass = VSize(Other.Velocity);
	if (Other.bIsGamePlayObject)
		ImpactMass *= Other.Mass / class'EGameplayObject'.default.Mass; 
		
	//Log("VSize(Other.Velocity)"@VSize(Other.Velocity));
	//Log("ImpactMass"@ImpactMass@Other.Mass@class'EGameplayObject'.default.Mass);
	//Log("ImpactResistance"@ImpactResistance);
	//Log("Abs(ImpactForce)"@Abs(ImpactForce));
	
	if ((!Other.bIsPawn && ImpactMass > ImpactResistance) ||
		(Other.bIsPawn && Abs(ImpactForce) < 0.5f && ImpactMass > ImpactResistance * 1.5f))
	{
		TakeDamage(ImpactMass, EPawn(Other), Location, Location - Other.Location, Location - Other.Location, None, 69);
	}

	// Reduce ImpactResistance under shock from any object
	if (!Other.bIsPawn)
		ImpactResistance /= 2;
}

//------------------------------------------------------------------------
// Description		
//		Damage from bullet
//------------------------------------------------------------------------
event BulletWentTru(Actor Instigator, vector HitLocation, vector HitNormal, vector Momentum, Material HitMaterial)
{
	local int i;
	local vector x,y,z;
	local EBulletImpact bulletImpact;

	HitBeforeShatter--;

	Super.BulletWentTru(Instigator, HitLocation, HitNormal, Momentum, HitMaterial);

	// if max hit or bad luck
	if (HitBeforeShatter <= 0 || FRand() > 0.7f)
		TakeDamage(100, EPawn(Instigator), HitLocation, HitNormal, Momentum, None, 69);
}

//------------------------------------------------------------------------
// Description		
//		Glass should only be destroyed from Bullets, by its own Bump event
//		and from EPlayerController short attack
//
//		Valid TakeDamage will have Pill tag == 69
//------------------------------------------------------------------------
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	local EGroupAI	Group;

	if (!(DamageType == class'Crushed' || DamageType == class'EBurned' || 
		 (DamageType == None && PillTag == 69)))
		return;

	if (BreakEmitterClass != None)
	{
		Velocity = Momentum;
		if (DamageType != None)
			Momentum /= 10.f;
		Spawn(BreakEmitterClass, self);
	}

	Instigator = EventInstigator;

	//make AI noise
	MakeNoise(2500, NOISE_Object_Breaking);
	PlaySound(Sound'DestroyableObjet.Play_BigWindowDestroyed', SLOT_SFX);

	//send an EventTrigger when the glass breaks
	if (GroupTag != '')
	{
		foreach DynamicActors(class'EGroupAI', Group, GroupTag)
		{
			Group.SendJumpEvent(JumpLabel,false,false);
			break;
		}	
	}

	if (OpeningSoundEvents.Length != 0)
	{
        for (iSoundNb = 0; iSoundNb < OpeningSoundEvents.Length; iSoundNb++)
        {
            PlaySound(OpeningSoundEvents[iSoundNb], SoundType);
        }
    }

	// add to changed actors list
	Level.AddChange(self, CHANGE_BrokenObject);

	// Track stats if the player destroyed the glass
	if (EventInstigator != None && EventInstigator.bIsPlayerPawn)
	{
		EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("ObjectDestroyed");
	}

	FakeDestroy();
}

function FakeDestroy()
{
	local int i;

	// Removed any attached object
	// Double loop needed because the Go gets detach in falling physics, 
	//    thus messing with the array while looping
	while (Attached.Length > 0)
	{
		//Log(self$" broken loses attach"@Attached[i]);
		if (Attached[0].bIsGameplayObject)
			EGameplayObject(Attached[0]).TakeHit();
		else
			Attached[0].SetBase(None);
	}

	// make it disappear
	SetCollision(false, false, false);
	bHidden = true;
}

defaultproperties
{
    BreakEmitterClass=Class'EchelonEffect.EGlassParticle'
    ImpactResistance=300
    HitBeforeShatter=2
    Physics=PHYS_None
    InitialState="None"
    bNPCBulletGoTru=true
    bPlayerBulletGoTru=true
    SoundRadiusSaturation=500.000000
    bBlockNPCShot=false
    bBlockNPCVision=false
    HeatOpacity=0.300000
}