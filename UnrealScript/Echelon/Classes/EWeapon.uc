//=============================================================================
// EWeapon
//
// Base Weapon class - defines state management and common weapon properties
//=============================================================================
class EWeapon extends EInventoryItem
	native
	abstract;

#exec OBJ LOAD FILE=..\Sounds\Special.uax

var	int						Ammo;					// Total ammo
var	const int				MaxAmmo;				// Maximum available ammo for this weapon
var	int						ClipAmmo;				// Current ammo loaded in clip
var	const int				ClipMaxAmmo;			// Maximum available ammo for a clip
var	const float				RateOfFire;				// how frequently we are allowed to fire (seconds)
var const int				BaseDamage;				// base damage inflicted by our projectiles
var	const int				BaseMomentum;			// force of impact of bullet
var	const int				FireNoiseRadius;		// noise radius of this weapon

var sound					FireSingleShotSound,	// sound the weapon makes immediately after firing
							FireAutomaticSound,
							FireAutomaticEndSound,
							ReloadSound,			// sound the weapon makes while reloading
							EmptySound,				// sound the weapon makes when no more ammo in the weapon
							BulletSound;

var material				BulletMaterial;

enum ERateOfFireMode
{
	ROF_Single,
	ROF_Burst,
	ROF_Auto,
};

var	ERateOfFireMode			eROFMode;
var	int						BulletsToFire;			// When firing, this number of bullets will be shot depending on the ROF

var	const int				ShootingRange;			// Distance at which the weapon's bullets can reach
var	const int				NPCPreferredDistance;	// if beyond this distance, NPC group will receive AI_PLAYER_FAR event
var	const class<Projectile>	EjectedClass;			// if we want to eject some cartridge / shell from weapon...
var const vector			EjectedOffset;
var const vector			EjectedVel;
var	const class<Actor>		MuzzleFlashClass;		// effect 
var	const Vector			MuzzleOffset;			// Offset of the end of the muzzle (for flash, particle, etc ...)
var EWeaponMagazine			Magazine;
var const StaticMesh		MagazineMesh;
var const vector			MagazineOffset;

// ATTACH
var bool					InTargetingMode;
var	const name				AttachAwayTag;

// RECOIL
var const float				RecoilStrength;
var const float				RecoilAngle;
var const float				RecoilStartAlpha;
var const float				RecoilFadeIn;
var const float				RecoilFadeOut;

// ACCURACY
var bool					UseAccuracy;
// Joshua - <const float> to <float>, we need to change this value for bPS2FN7Accuracy option
var float					AccuracyMovementModifier;	// Desired accuracy when moving
var float					AccuracyReturnModifier;		// Speed at which it comes back to desired
var float					AccuracyBase;				// Base accuracy, will never be lower
var const float				AccuracyDesired;			// Where we want the accuracy to be
var	const float				Accuracy;					// Current/Actual weapon accuracy at a certain time
var const float				RealAccuracy;
var bool					bJustFired;

// RETICLE
var EObjectHUD				WeaponReticle;
var	int						ReticuleTex;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	WeaponReticle = EWeaponReticle(ObjectHud);
	if( WeaponReticle == None )
		Log(self$" ERROR: Defined ObjectHud not a EWeaponReticle");

    ReticuleTex = EchelonLevelInfo(Level).TGAME.tar_pistol;

	if( MagazineMesh != None )
	{
		Magazine = spawn(class'EWeaponMagazine', self);
		Magazine.SetStaticMesh(MagazineMesh);
		ResetMagazine();
	}
}

function Destroyed()
{
	if( Magazine != None )
		Magazine.Destroy();
	
	Super.Destroyed();
}

event SetSecondaryAmmo(EInventoryItem Item);

//------------------------------------------------------------------------
// Description
//		Kill old Controller variable -- if it was in the old Controller's
//		inventory, remove the item from that inventory.
//------------------------------------------------------------------------
function ResetController()
{
	local EPawn OwnerPawn;
	
	// Reset OwnerPawn's CurrentWeapon property
	if ( Controller != none )
	{		
		OwnerPawn = EPawn(Controller.Pawn);
		if ( OwnerPawn != none )
		{
			OwnerPawn.CurrentWeapon = none;
		}
	}

	Super.ResetController();
}

function bool NotifyPickup( Controller Instigator )
{
	Super.NotifyPickup(Instigator);
	
	return false;
}

//------------------------------------------------------------------------
// Description		
//		Reset magazine values
//------------------------------------------------------------------------
function ResetMagazine()
{
	if( Magazine == None )
		return;

	Magazine.SetBase(self);
	if( MagazineOffset == Vect(0,0,0) )
		Log(self$" WARNING: MagazineMesh specified without offset");
	Magazine.SetRelativeLocation(MagazineOffset);
	Magazine.SetRelativeRotation(rot(0,0,0));
	Magazine.bHidden = false;
}

//------------------------------------------------------------------------
// Description		
//		Shouldn't add any weapon except for AIController
//------------------------------------------------------------------------
function bool CanAddThisItem( EInventoryItem ItemToAdd )
{
	return Owner != None && !Controller(Owner).bIsPlayer;
}

//------------------------------------------------------------------------
// Description		
//		Pulling the trigger
//------------------------------------------------------------------------
event Fire()
{
	PlaySound(EmptySound, SLOT_SFX);

	if (ClipAmmo == 0)
	{
		//unlimited ammo
		if(( Controller != none ) && (!Controller.bIsPlayer))
		{
			ClipAmmo = ClipMaxAmmo-1;
			Ammo=100;
		}
		
		if( eROFMode == ROF_Single )
		{
			if (Ammo > 0)
				Reload();
			else
				OutOfAmmo();
		}
	}
	else
		GotoState('s_Firing');
}

//------------------------------------------------------------------------
// Description		
//		Not clear what to do here
//------------------------------------------------------------------------
function AltFire();

//------------------------------------------------------------------------
// Description		
//		Reload weapon
//------------------------------------------------------------------------
function bool Reload()
{
	if( Controller(owner) != None  && Controller(owner).pawn != None && Controller(owner).pawn.health > 0 && Owner.GetStateName() != 's_Unconscious' && Owner.GetStateName() != 's_groggy' )
	{
	//Log("Reload Ammo["$ammo$"] ClipAmmo["$clipammo$"] MaxAmmo["$maxammo$"] ClipMaxAmmo["$clipmaxammo$"]");
	if( Ammo > ClipAmmo && ClipAmmo != ClipMaxAmmo && Controller.MayReload() )
	{
		GotoState('s_Reloading');
		return true;
	}
	}
	return false;
}

function StepReload( int Step );

function OutOfAmmo()
{
	if( Controller != none )
		Controller.NotifyOutOfAmmo();
}

function SpawnShellCase()
{
	local Projectile s;
	local vector localVel;
	if( EjectedClass != None )
	{
		s = Spawn(EjectedClass, self, , ToWorld(EjectedOffset));
		if ( s != None ) 
	    {
			localVel = EjectedVel;
			localVel.X += (FRand() * 10.0) - 5.0;
			localVel.Y += (FRand() * 20.0) - 10.0;
			localVel.Z += (FRand() * 10.0) - 5.0;
		    s.Eject(ToWorldDir(localVel) + 0.7 * Controller.Pawn.Velocity);
	    }
	}
}

//------------------------------------------------------------------------
// Description		
//		Firing base functions
//------------------------------------------------------------------------
final function FireWeapon()
{
	local vector		FlashPos;
	local Actor			f;
	local EAIController AI;
	local Sound			SoundName;
	local Rotator		ViewRotation;

	// reduce bullets to shoot
	BulletsToFire--;
	bJustFired = true;
	//
	// Shake, Recoil
	//

	//
	// Spawn shell
	//
	SpawnShellCase();

	//
	// Spawn the muzzleFlash
	//
	if( MuzzleFlashClass != None )
	{
		f = Spawn(MuzzleFlashClass, self,, ToWorld(MuzzleOffset));
		f.SetBase(self);
		// Make it live for 1 frame
		f.LifeSpan	= 0.01;
	} 

	//
	// Do Fire
	//
	// exit if bDebugWeapon is on
	AI = EAIController(Controller);
	if ( AI != none && AI.EPawn != none && AI.EPawn.bDebugWeapon )
		return;

	TraceFire();

	// Reduce ammo
	if(ClipAmmo > 0)
	{		
		ClipAmmo--;
		Ammo--;
		if (( Controller != none ) && (Controller.bIsPlayer))
		{
			if ( EPlayerController(Controller).bFullAmmo )
			{	
				++ClipAmmo;
				++Ammo;
			}
		}

		
		if ( (ClipAmmo == 0) && self.IsA('EFn7'))
			AddSoundRequest(Sound'FisherEquipement.Play_FNPistolEmpty', SLOT_SFX, 0.05f);
	}

	Controller.NotifyFiring();	// inform controller weapon is firing for anim purposes

	Controller.Pawn.PhysicsVolume.CheckExplosive(self, Controller.Pawn);
}

event Vector GetFireStart()
{
	if(Controller.bIsPlayer)
	{
		return EPlayerController(Controller).GetFireStart();
	}
	else
	{
		return  Location;//ToWorld(MuzzleOffset);
	}
}

event Vector GetFireEnd()
{
	return Controller.GetTargetPosition();
}

function Vector GetFireDirection( Vector ShotDirection )
{
	return GetVectorFrom(Rotator(ShotDirection),Sqrt(RealAccuracy)*7);
}

function SpawnWallHit(Actor HitActor, vector HitLocation, vector HitNormal, Material HitMaterial)
{
	local EWallHit Spark;
	local Rotator projRot;

	// Hit world geometry
	if( HitActor.bWorldGeometry || HitActor.DrawType == DT_StaticMesh )
	{
		BulletMaterial		= HitMaterial;
		projRot				= Rotator(HitNormal);
		projRot.Roll		= FRand() * 65536;
		Spark				= Spawn(class'EWallHit', Controller(owner).pawn,, HitLocation+HitNormal, projRot);
		Spark.hitMaterial	= HitMaterial;
        Spark.HitActor		= HitActor;
		Spark.SndBullet		= BulletSound;
		Spark.Emit();
        Spark.Noise();
	}
}


//------------------------------------------------------------------------
// Description
//		Hitscan weapon - gets targeting information from our Owner/Controller
//------------------------------------------------------------------------
function TraceFire()
{
	local Actor HitActor;
	local vector HitLocation, HitNormal, StartTrace, EndTrace, ShotDirection;
	local int PillTag;
	local Material HitMaterial;
	local EPlayerController EPC;
	local int InflictedDamage;

	if( Controller == None )
		Log("WEAPON WARNING : TraceFire() has no Controller Owner");

	MakeNoise(FireNoiseRadius, NOISE_Gunfire);

	// get basic start and end positions
	StartTrace	= GetFireStart();
	ShotDirection = GetFireEnd() - StartTrace;

	if(Controller.bIsplayer)
		EndTrace = StartTrace + (ShootingRange * GetFireDirection(ShotDirection) );
	else
		EndTrace = StartTrace + (ShootingRange * Controller.AdjustTarget(ShotDirection));

	HitActor = Controller.Pawn.TraceBone(PillTag, HitLocation, HitNormal, EndTrace, StartTrace, HitMaterial, true);
	//Log("Hitting"@HitActor@"on bone"@PillTag);

	InflictedDamage = BaseDamage;

	if( HitActor == None )
		return;

	// Npc should not shoot each other when walking around
	if( !Controller.bIsPlayer )
	{
		// Make sure that the intention of the NPC is not to shoot another NPC
		if( HitActor.bIsPawn && !EPawn(HitActor).bIsPlayerPawn && EAIController(Controller).TargetActorToFire != HitActor )
		{
			// Although Npc will get shot if he's being grabbed
			// If shooting a grabbed Npc, reduce damage
			if( EPawn(HitActor).GetStateName() == 's_Grabbed' || EPawn(HitActor).GetStateName() == 's_Carried')
			{
				InflictedDamage /= 5;
			}
			else
			{
				//Log("Npc["$Controller.pawn$"] cancel target["$HitActor$" "$HitActor.GetStateName()$"]");
				HitActor = None;
				return;
			}
		}

		//If the bullet hit the geometry, check if it went trough Sam's cylinder
		//If yes, play a bullet whistle sound effect
		if( HitActor != None && HitActor.bWorldGeometry && 
			DistancePointToLine(EchelonGameInfo(Level.Game).pPlayer.EPawn.GetBoneCoords(EchelonGameInfo(Level.Game).pPlayer.EPawn.EyeBoneName).Origin, StartTrace, EndTrace ) < 22 )
		{
			EchelonGameInfo(Level.Game).pPlayer.EPawn.PlaySound(Sound'GunCommon.Play_Random_BulletWhistle', SLOT_SFX);
		}
	}

	if( HitActor == None )
		return;

	SpawnWallHit(HitActor, HitLocation, HitNormal, HitMaterial);

    // If it's Sam firing at NPC, add hit location and time to hit array
    if( Controller.bIsPlayer )
		EPlayerController(Controller).AddHit(HitLocation, Level.TimeSeconds);
	
	if( HitActor != self && HitActor != Controller.Pawn && !HitActor.bWorldGeometry )
	{
		//Log("["$Controller.Pawn$"] deals damage["$InflictedDamage$"] to ["$HitActor$"]");
		HitActor.TakeDamage(InflictedDamage, Controller.Pawn, HitLocation, HitNormal, Normal(HitLocation - GetFireStart()) * BaseMomentum, None, PillTag);
	}
}

/////////////////////////////////////////////////////////////////////////
// Rate of fire functions
/////////////////////////////////////////////////////////////////////////
function bool SwitchROF()
{
	switch( eROFMode )
	{
	case ROF_Single : eROFMode = ROF_Burst; return true;
	case ROF_Burst : eROFMode = ROF_Auto; return true;
	case ROF_Auto :	eROFMode = ROF_Single; return true;
	}
}

event bool IsROFModeAvailable(ERateOfFireMode rof)
{
    return true;
}

function int GetNbBulletsFromROF()
{
	switch( eROFMode )
	{
	case ROF_Single : 
		return 1;
	case ROF_Burst : 
		return Min(3, ClipAmmo);
	case ROF_Auto :	
		return ClipAmmo;
	}
}

// ----------------------------------------------------------------------
// state s_Pickup - Weapon is thrown on ground from pawn.
// ----------------------------------------------------------------------
state s_Flying
{
	Ignores HitWall;

	function BeginState()
	{
		Super.BeginState();
		
		bBounce				= false;
		bFixedRotationDir	= false;
		bRotateToDesired	= true;
		RotationRate		= Rot(65535,65535,65535);
		DesiredRotation		= Rot(0,0,16383); // Should be floor normal
	}

	function Landed( vector HitNormal )
	{
		StoppedMoving();
	}
}

// ----------------------------------------------------------------------
// state s_Pickup - Weapon is on the ground and available and may be picked up
// ----------------------------------------------------------------------
state s_Pickup
{
	function BeginState()
	{
		SetCollision(true);
	}
}

// ----------------------------------------------------------------------
// state s_Inventory
// ----------------------------------------------------------------------
state s_Inventory
{
	Ignores Fire, AltFire, Reload;

	function BeginState()
	{
		Super.BeginState();

		if( WeaponReticle != None )
			EWeaponReticle(WeaponReticle).SetEpc();
	}
}

// ----------------------------------------------------------------------
// state s_Selected
// ----------------------------------------------------------------------
state s_Selected
{
	function BeginState()
	{
		//Log("Ammo["$Ammo$"] MaxAmmo["$MaxAmmo$"] ClipAmmo["$ClipAmmo$"] ClipMaxAmmo["$ClipMaxAmmo$"] C0["$Ammo/ClipMaxAmmo$"] C1["$(Ammo-ClipAmmo)/ClipMaxAmmo$"] C2["$(Ammo-ClipMaxAmmo)/ClipMaxAmmo$"] C3["$(Ammo-ClipAmmo)/ClipMaxAmmo$"]");


		if( WeaponReticle != None )
			WeaponReticle.GotoState('s_Selected');

		Super.BeginState();

		// if holding trigger when no more bullet, produce empty gun sound
		if( ClipAmmo == 0 && eROFMode != ROF_Single && Controller.Pawn.PressingFire() )
			Fire();
	}

	// Never allow change in Firing mode when pulling trigger. No override of this in sub-class
	function bool SwitchROF()
	{
		if( Controller.Pawn.PressingFire() )
			return false;
		
		return Global.SwitchROF();
	}

	function Use()
	{
		Fire(); // overrides egameplayobject Use()
	}

	// I hate to do this . but need to know when trigger is released
	function Tick( float DeltaTime )
	{
        Super.Tick(DeltaTime);
		if( WeaponReticle != None )
			WeaponReticle.ObjectHudTick(DeltaTime);

        if( BulletsToFire == 0 && ClipAmmo == 0 && Ammo > 0	&& eROFMode != ROF_Single && !Controller.Pawn.PressingFire() )
		{
		    Reload();
		}
	}
}

// ----------------------------------------------------------------------
// state s_Reloading
// ----------------------------------------------------------------------
state s_Reloading
{
	Ignores Fire, AltFire, Reload;

	function BeginState()
	{
		if( WeaponReticle != None )
			WeaponReticle.GotoState('s_Reloading');

		// Do not reload if there's no clip left || clip is already full
		if( Ammo == 0 || ClipAmmo == ClipMaxAmmo )
			Log(self$" ERROR: Shouldn't be in reload state");

		// Check if Controller can go into states to play animation
		Controller.NotifyReloading();

		if(IsPlaying(FireAutomaticSound))
			PlaySound(FireAutomaticEndSound, SLOT_SFX);

		PlaySound(ReloadSound, SLOT_SFX);
	}

	function EndEvent()
	{
		StepReload(4);
		GotoState('s_Selected');
	}

	event AnimEnd( int Channel )
	{
		if( Channel == 69 && MaxAmmo > 0 )
		{
			if(Ammo > ClipMaxAmmo)
				ClipAmmo = ClipMaxAmmo;
			else
				ClipAmmo = Ammo;
		}

		EndEvent();
	}

	function StepReload( int Step )
	{
		if( Magazine == None )
			return;
		switch( Step )
		{
		case 1 :
			EPawn(Controller.Pawn).AttachToBone(Magazine, 'LeftHandBone');
			Magazine.SetRelativeLocation(vect(0,0,0));
			Magazine.SetRelativeRotation(rot(0,0,0));
			break;
		case 2 :
			Magazine.bHidden = true;
			break;
		case 3 :
			Magazine.bHidden = false;
			break;
		case 4 :
			EPawn(Controller.Pawn).DetachFromBone(Magazine);
			ResetMagazine();
			break;
		}
	}

	function Tick( float DeltaTime )
	{
		Super.Tick(DeltaTime);
		if( WeaponReticle != None )
			WeaponReticle.ObjectHudTick(DeltaTime);
	}
}

// ----------------------------------------------------------------------
// state s_Firing
// ----------------------------------------------------------------------
state s_Firing
{
	Ignores Fire, AltFire, Reload, SwitchROF; // Never allow change in Firing mode. No override of this in sub-class

	function BeginState()
	{
		if( WeaponReticle != None )
			WeaponReticle.GotoState('s_Firing');

		BulletsToFire = GetNbBulletsFromROF();

		switch( eROFMode )
		{
		case ROF_Single : 
			PlaySound(FireSingleShotSound, SLOT_SFX);
			break;
		case ROF_Burst : 
			PlaySound(FireAutomaticSound, SLOT_SFX); // Joshua - Originally played no sound, restored for burst fire
			break;
		case ROF_Auto :	
			PlaySound(FireAutomaticSound, SLOT_SFX);
			break;
		}

		// Shoot a bullet now
		FireWeapon();

		SetTimer(RateOfFire,false);
	}

	event Timer()
	{
		// if no more bullets OR mode auto and released trigger
		if( BulletsToFire == 0 || ( (eROFMode==ROF_Auto || !Controller.bIsPlayer) && !Controller.Pawn.PressingFire()) )
		{
			if(IsPlaying(FireAutomaticSound))
				PlaySound(FireAutomaticEndSound, SLOT_SFX);

			GotoState('s_Selected');
		}
		else
		{
			SetTimer(RateOfFire,false);
			FireWeapon();
	}
	}

	function Tick( float DeltaTime )
	{
		Super.Tick(DeltaTime);
		if( WeaponReticle != None )
			WeaponReticle.ObjectHudTick(DeltaTime);
	}
}






state s_Dying
{
	function BeginState()
	{
		if(IsPlaying(FireAutomaticSound))
			PlaySound(FireAutomaticEndSound, SLOT_SFX);

		SetTimer(1.f + FRand(), true);
		SetCollision(true, false, false);
	}

	function Timer()
	{
		if ( !PlayerCanSeeMe() ) 
			Destroy();
	}
}

function StopLoopSound(){}

defaultproperties
{
    BaseMomentum=150
    ShootingRange=15000
    NPCPreferredDistance=2000
    EjectedVel=(X=0.000000,Y=80.000000,Z=60.000000)
    bPickable=false
    ObjectHudClass=Class'EWeaponReticle'
    SoundRadiusSaturation=1000.000000
    CollisionRadius=5.000000
    CollisionHeight=3.000000
}