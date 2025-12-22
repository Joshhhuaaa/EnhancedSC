class EGameplayObject extends Actor
	placeable
	native;

#exec OBJ LOAD FILE=..\StaticMeshes\generic_obj.usx 
#exec OBJ LOAD FILE=..\textures\ETexRenderer.utx 
#exec OBJ LOAD FILE=..\StaticMeshes\LightGenOBJ.usx

enum EGOMsgEvent
{
	GOEV_Trigger,
	GOEV_TakeDamage,
	GOEV_Destructed,
};

// Type of linked object to the alarm
enum ELinkType
{
	EAlarm_None,
	EAlarm_Trigger,
	EAlarm_Object,
}; 

enum EScannedActorType
{
	SCAN_PlayerOnly,
	SCAN_ChangedPawns,
	SCAN_AllPawns,
	SCAN_AllChangedActors,
	SCAN_AllPawnsAndChangedActors
};

enum EDetectionType
{
	DETECT_Movement,
	DETECT_Heat,
};

// Any changes to this struct should be mirrored in C++
struct SpawnInfo
{
	var() bool			SpawnAlwaysOn;				// True if we want this spawnInfo to always be considered
    var() class<Actor>	SpawnClass;					// Class name to spawn
	var() bool			SpawnOnImpact;				// True if you want the particle to be spawned on hitlocation
	var() Vector		SpawnOffset;				// Offset local to owner for a spawned object
	var() float			SpawnAtDamagePercent;		// Min. percentage at which the object will be spawned
	var() Actor			TriggerableActor;			// Trigger actor, dormant emitter or pattern emitter for any reason
};

// Inventory
var			name				ObjectName;
var			EInventory			Inventory;

// Projectile
var()		bool				bPickable;			// Can be picked up
var()		bool				bPushable;			// Can push if bumped
var()		float				HitNoiseRadius;

// Lighting
var()		Array<ELight>		ObjectLights;		// All different linked echelon lights
var()       Array<ShadowProjector> ObjectProjectors; // And the projectors (non shadow buffer version specific)
var			float				LastTimeChange;		// Set for lightmap regeneration

// Visibility calculation
var			Color				RelevantAmbientColor;
var			Array<Actor>		RelevantLights;

// Damage stuff
struct DamagedMesh
{
	var() StaticMesh	StaticMesh;					// mesh to switch to at a certain damage percentage
	var() StaticMesh	CollPrimMesh;				// coll mesh to switch to new mesh
	var() float			Percent;					// .. certain damage percentage
};

var(Damage)	bool				bDamageable;		// Object is damageable
var(Damage) bool				bShatterable;		// Object takes damage when hitting geometry at high speeds
var(Damage)	bool				bExplodeWhenDestructed; // Spawn an explosion for this object when hitpoints = 0
var(Damage)	bool				bDestroyWhenDestructed; // Destroy the actor when hitPoints == 0
var(Damage) bool				bDestroyOnlyByExplosion;// True if this object can only be destroyed by an explosion
var(Damage)	int					HitPoints;			// If bDamageable, its number of hit points
var(Damage)	Array<DamagedMesh>	DamagedMeshes;		// Mesh(es) replacing the original depending on damage on object
var(Damage) Array<SpawnInfo>	SpawnableObjects;	// Table of spawnable objects depending on damage

// Explosion stuff
var(Damage) class<Emitter>		ExplosionClass;		// Emitter to be spawn upon explosion
var(Damage) class<damageType>	ExplosionDamageClass;

var(Damage) float		 		ExplosionDamage;	// Damage for the explosion
var(Damage) float				ExplosionMinRadius;	// Min Radius within which the damage will be maximal
var(Damage) float				ExplosionMaxRadius;	// Max range at which the explosion will do damage
var(Damage) float				ExplosionNoiseRadius;//Noise radius
var(Damage)	float				ExplodeTimer;		// how long after tossing we set up us the bomb
var			float				DestroyTime;
var(Damage)	Array<Sound>		HitSound;			// Noise when hit
var(Damage)	Sound				BounceSound;		// Noise when bounces
var(Damage) Sound				ExplosionSound;		// Noise when explodes

var			int					ExplosionMomentum;	// multiplier for force of explosion

var			int					InitialHitPoints;	// keep track of initial to be able to see current Damage Percentage

var			float				DelayToDestruction;	// Used to delay recursive explosion

var			float               DamagePercent;

// Alarm
var(AI)		EAlarm				Alarm;				// Associated Alarm
var(AI) editconst	ELinkType	AlarmLinkType;		// Type of interaction with Alarm

// AI related
var(AI)		EGroupAi			GroupAI;
var(AI)		name				JumpLabel;
var(AI)		name				DestroyedJumpLabel;
var(AI)     bool                TriggerPatternJustOnce;
var(AI)		bool				ChangeListWhenThrown;		// place object on changed actor list when Throw() is called?  default to true
var(AI)		bool				ChangeListWhenDamaged;		// send as changeActor when damaged.
var         bool                PatternAlreadyTrigger;
var			bool				bIsSwitchObject;
var			bool				bWasSeen;					//just to know if the NPC has seen the object

// Hud/View
var			class<EObjectHUD>	ObjectHudClass;
var			EObjectHUD			ObjectHud;

var(AI) enum ECanTriggerType
{
	PlayerTriggered,	
	NPCTriggered,	    
	PawnTriggered,
    NoRestriction

} TriggerType;

// Native functions
native(1230) final function bool FrustumScanning(out	   Actor				FoundActor, 
												  optional EDetectionType		DetectionType,
												  optional float				DetectionThreshold,
												  optional EScannedActorType	ActorDetectionType);

native(1129) final function CheckSBOwner(vector Momentum);

// Called from HUD on hud_master Object
function HudView(bool bIn);
function DrawView(HUD Hud, ECanvas Canvas)
{
	if (ObjectHud != None)
		ObjectHud.DrawView(Hud, Canvas);
}

function PreBeginPlay()
{
	local int i;
	Super.PreBeginPlay();
	for (i = 0; i < ObjectLights.Length; i++)
	{
		if (ObjectLights[i] != None && ObjectLights[i].Isa('Elight'))
		{
			ObjectLights[i].SetController(self);
		}
		else
			Log(self$" WARNING: Obsoletes light refs in ObjectLights array at index:"$i);
	}
	// JFP: Set the controller for the projectors as well?
}



//------------------------------------------------------------------------
// Description		
//		Prepare object (inventory, alarm and lights)
//------------------------------------------------------------------------
function PostBeginPlay()
{
	// keep values
	InitialHitPoints = HitPoints;

	////////////////////////////////////////////////////
	// ALARM
	////////////////////////////////////////////////////
	if (Alarm != None)
	{
		Switch (AlarmLinkType)
		{
		case EAlarm_Trigger : 
			Alarm.LinkTrigger(self);
			break;

		case EAlarm_Object :
			Alarm.LinkObject(self);
			break;

		case EAlarm_None :
			Log(self$":: Linked to Alarm["$Alarm$"] although type set to "$AlarmLinkType);
			break;
		}
	}

	////////////////////////////////////////////////////
	// PICK (must be done before the Super.PostBeginPlay
	////////////////////////////////////////////////////
	if (bPickable)
		InteractionClass = class'EPickupInteraction';

	if (ObjectHudClass != None && ObjectHud == None)
		ObjectHud = spawn(ObjectHudClass, self);

	Super.PostBeginPlay();
}

//------------------------------------------------------------------------
// Description		
//		Base function for use and fire
//------------------------------------------------------------------------
function Use();
function bool Scope();

//------------------------------------------------------------------------
// Description		
//		When an object is picked up on ground
//------------------------------------------------------------------------
function bool NotifyPickup(Controller Instigator)
{
	SetOwner(Instigator);
	GotoState('s_Selected');

	return false;
}

function name GetHandAttachTag()
{
	return 'WeaponBone';
}

//------------------------------------------------------------------------
// Description		
//		Changes my state and adds object to ChangedActor list IF thrown by player.
//
// Input
//		Thrower :		Controller responsible for throwing the object.
//		ThrowVelocity:  Speed applied to object immediately.
//------------------------------------------------------------------------
function Throw(Controller Thrower, vector ThrowVelocity)
{	
	local vector HitLocation, HitNormal, Extent;
	local actor HitActor;

	Velocity = ThrowVelocity;
	
	if (ChangeListWhenThrown && Thrower.bIsPlayer)
		Level.AddChange(self, CHANGE_Object);

	// set instigator for damage
	Instigator = Thrower.Pawn;

	// Must remove object from hand if it's the current one
	// Ie. shooting a sec.ammo shouldn't change handitem.
	// Do it before the gotoState because throwing an inv.item might put the next in queue in pawn's hand
	if (Epawn(thrower.Pawn).handitem == self)
		Epawn(thrower.Pawn).handitem = None;
	
	if (Base != None)
		Base.DetachFromBone(self);

	// Set this to prevent throwing object through Actor w/ CollPrim
	bCollideWorld = true;

	Extent.X = CollisionRadius;
	Extent.Y = CollisionRadius;
	Extent.Z = CollisionHeight;
	HitActor = Trace(HitLocation, HitNormal, Location, Thrower.Pawn.Location, true, Extent);
	if (HitActor != None)
		SetLocation(HitLocation);

	GotoState('s_Flying');
}

//------------------------------------------------------------------------
// Description		
//		Send to object when stopped moving (PHYS_None)
//------------------------------------------------------------------------
function StoppedMoving()
{
	//Log(self@"StoppedMoving");

	// Give default interaction back to object
	if (bPickable && Interaction == None)
	{
		//Log(self$" thrown, giving pickup interaction");
		InteractionClass = class'EPickupInteraction';
		Interaction		 = Spawn(InteractionClass, self);
	}

	SetCollision(true, false, false);
}

function rotator GetStillRotation(vector HitNormal)
{
	local Rotator NewRot;
	NewRot = Rotator(HitNormal);
	NewRot.Roll = Rotation.Roll;
	NewRot.YAw = Rotation.Yaw;
	return NewRot;
}

function HitFakeBackDrop()
{
	Log(self@"HitFakeBackDrop");
	Destroy();
}

function BaseChange()
{
	//Log(self$" Changing base to Base["$Base$"] bCollideActors["$bCollideActors$"/"$default.bCollideActors$"] bBlockActors["$bBlockActors$"/"$default.bBlockActors$"] bBlockPlayers["$bBlockPlayers$"/"$default.bBlockPlayers$"] bCollideWorld["$bCollideWorld$"/"$default.bCollideWorld$"]");
	if (Base == None && 
		(bCollideActors || default.bCollideActors) && 
		((bBlockActors || default.bBlockActors) || (bBlockPlayers || default.bBlockPlayers)))
	{
		bCollideWorld = true;
		SetCollision(true, (bBlockActors || default.bBlockActors), (bBlockPlayers || default.bBlockPlayers));
		SetPhysics(PHYS_Falling);
	}
	else if (Base != None && Base.bIsPawn && AttachmentBone == '')
	{
		bCollideWorld = true;
		SetCollision(true);
		SetPhysics(PHYS_Falling);
		SetLocation(Location + vect(0,0,-2));
	}
}

//------------------------------------------------------------------------
// Description		
//		Do treatment depending on light vars
//------------------------------------------------------------------------
event VisibilityRating GetActorVisibility()
{
	return VisibilityTableLookup(GetVisibilityFactor());
}

//------------------------------------------------------------------------
// Description		
//		Called when this actor has no more HitPoints
//------------------------------------------------------------------------
event Destructed()
{
	local int	i;
	local bool	bHasDestroyedMesh;

	DestroyTime = Level.TimeSeconds;

	// Send destructed msg
	SendMessage(GOEV_Destructed);

	PlaySound(AmbientStopSound, SLOT_SFX);

	// Make all attached object lose their base(this)
	for (i = 0; i < Attached.Length; i = i)
	{
		//Log(self$" destructed loses attach"@Attached[i]@Attached[i].AttachmentBone);
		if (Attached[i].bIsGameplayObject && Attached[i].AttachmentBone == '')
			EGameplayObject(Attached[i]).TakeHit();
		else
			i++;
	}

	if (bExplodeWhenDestructed)
		Explode();

	else if (bShatterable)
		Shatter();

	// if actor has a 100% destroyed mesh, don't destroy it
	for (i = 0; i < DamagedMeshes.Length; i++)
	{
		if (DamagedMeshes[i].Percent == 100)
		{
			bDestroyWhenDestructed = false;
			break;
		}
	}
	
	// send event to GroupAI when destroyed
	if (GroupAI != None && DestroyedJumpLabel != '')
		GroupAI.SendJumpEvent(DestroyedJumpLabel, false, false);

	// Joshua - Only track stats if the player destroyed the object and it's not an EGameplayObjectPattern
	if (Instigator != None && Instigator.bIsPlayerPawn && !IsA('EGameplayObjectPattern'))
	{
		if (ObjectLights.Length > 0) // If object has lights, consider it light destroyed
			EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("LightDestroyed");
		else
			EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("ObjectDestroyed");
	}

	if (bDestroyWhenDestructed)
		Destroy();
	else if (GetStateName() == self.class.name)
		GotoState('s_Destructed');
}

//---------------------------------------[David Kalina - 28 Nov 2001]-----
// 
// Description
//		For objects that have bShatterable == true upon destruction.
//
//------------------------------------------------------------------------

final function Shatter()
{
	PlaySound(ExplosionSound, SLOT_SFX);
	MakeNoise(ExplosionNoiseRadius, NOISE_Object_Breaking);
}

//------------------------------------------------------------------------
// Description		
//		Any explosion should call this.
//------------------------------------------------------------------------
final function Explode()
{
	local actor		Victims;
	local float		damageScale, dist;
	local vector	dir;
	local Pawn		OriginalInstigator; // Joshua - Workaround for objects destroyed
	local float		dam; // Joshua - Scaling damage as NPCs have 150 HP on Hard diffculty

	// Sound
	PlaySound(ExplosionSound, SLOT_SFX);
	
	// Noise
	MakeNoise(ExplosionNoiseRadius, NOISE_Explosion);

	// Spawn emitter
	//Log("Spawning explosion class="$ExplosionClass);
	if (ExplosionClass != None)
		spawn(ExplosionClass, self);

	if (bHurtEntry) // prevent take damage recursion
		return;

	if (ExplosionDamage == 0) 
		return;

	// Joshua - If this explosion comes from an EGameplayObjectPattern, clear the Instigator
	// so objects destroyed by the explosion don't count toward player stats
	OriginalInstigator = Instigator;
	if (IsA('EGameplayObjectPattern'))
		Instigator = None;

	bHurtEntry = true;
	foreach CollidingActors(class 'Actor', Victims, ExplosionMaxRadius)
	{
		if (Victims != self && FastTraceBsp(Victims.Location))
		{
			//Log(Victims);
			dir = Victims.Location - Location;
			dist = FMax(1,VSize(dir));

			// if distance is within the minimum radius, apply maximum damage,
			// else, do some cals
			damageScale = 1;
			//Log(dist@ExplosionMaxRadius@ExplosionMinRadius);
			if (dist > ExplosionMinRadius)
				damageScale = 1 - FMax(0,(dist - ExplosionMinRadius) / (ExplosionMaxRadius - ExplosionMinRadius));

			//Log(explosiondamage@damagescale);
			//Log(self$" HURT radius processing damage["$damageScale*explosiondamage$"] to: "$victims$" at dist="$dist$" with damageScale="$damageScale);

			dir = dir / dist; 

 			// Joshua - Scaling damage as NPCs have 150 HP on Hard diffculty
			dam = damageScale * ExplosionDamage;
			if (EchelonGameInfo(Level.Game).pPlayer.playerInfo.Difficulty > 0 && EchelonGameInfo(Level.Game).bScaleGadgetDamage)
				dam *= 1.5f;

			Victims.TakeDamage
			(
				dam, // Joshua - Scaling damage as NPCs have 150 HP on Hard diffculty
				Instigator,
				Location, // GERONIMO TEST
				dir,
				//Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * ExplosionMomentum * dir),
				ExplosionDamageClass
);
		} 
	}
	
	// Joshua - Restore original instigator
	Instigator = OriginalInstigator;
	bHurtEntry = false;
}

//------------------------------------------------------------------------
// Description		
//		Manage take damage
//------------------------------------------------------------------------
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	//Log(self$" EGO takes damage["$damage$"] at HitPoints["$HitPoints$"] from "$EventInstigator@GetStateName());
	Instigator = EventInstigator;

	// Send takedamage msg
	SendMessage(GOEV_TakeDamage);

	// Transfer momentum to soft body
	Velocity += Momentum * class'EGameplayObject'.default.Mass / Mass;
	CheckSBOwner(Velocity);

	// Move object depending on mass (move only if mass specified and !shaterable damageable)
	if (Mass != class'EGameplayObject'.default.Mass && (!bShatterable || (bShatterable && !bDamageable)) && !(Base != None && Base.bIsSoftBody))
		TakeHit();

	// If object is to be destroyed with this damage and not bDestroyOnlyByExplosion only
	if (bDestroyOnlyByExplosion && 
		HitPoints - Damage <= 0 && 
		(DamageType == None || (DamageType.Name != 'Crushed' && DamageType.Name != 'EBurned')))
	{
		//Log(self$"bDestroyOnlyByExplosion true ignoring destructor damage");
		Damage = 0;
	}

	// Sent damage
	ProcessDamage(Damage, DamageType, HitLocation, HitNormal);
}

function TakeHit()
{
	GotoState('s_Flying');
}

event BulletWentTru(Actor Instigator, vector HitLocation, vector HitNormal, vector Momentum, Material HitMaterial)
{
	Super.BulletWentTru(Instigator, HitLocation, HitNormal, Momentum, HitMaterial);
	TakeDamage(100, Pawn(Instigator), HitLocation, HitNormal, Momentum, None);
}


//------------------------------------------------------------------------
// Description		
//		Wrapper around ProcessDamage
//------------------------------------------------------------------------
final function DestroyObject()
{
	ProcessDamage(HitPoints, None, Location, Vector(Rotation));
}

//------------------------------------------------------------------------
// Description		
//		Damage processing from Takedamage or destroy
//------------------------------------------------------------------------
function ProcessDamage(int Damage, class<DamageType> DamageType, Vector HitLocation, Vector HitNormal)
{
	local Vector	SpawnLocation, X,Y,Z, Min,Max;
	local rotator	SpawnRotation;
	local int		i, iChosenMesh;
	local float		SmallestDelta, Delta;
	local bool		bAlreadyAdded;
	local bool		bObjectModifed;
	local bool		bPlayBounce;
	local EVolume	V;
	
	bPlayBounce = true;


	// Do nothing if object already destroyed
	if (HitPoints <= 0)
	{
		//log("Do nothing if object already destroyed");
		return;
	}

	// Process damage
	if (bDamageable)
	{
		HitPoints = FMax(0, HitPoints - Damage);
		//Log(self@"goes from"@HitPoints+Damage@" hp to"@hitpoints);
	}

	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	// Spawnable objects
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	// Error check
	if (InitialHitPoints == 0)
		Log(self$" Warning: Base class EGameplayObject::PostBeginPlay may have been not called in this object class hierarchy");
	DamagePercent = 100 * (1 - HitPoints / float(InitialHitPoints));
	//Log("default="@InitialHitPoints@"hp left="@hitpoints@"percent="@damagepercent);

	for (i = 0; i < SpawnableObjects.Length; i++)
    {
		// If Current level of damage >= Object damage value
		if (DamagePercent >= SpawnableObjects[i].SpawnAtDamagePercent)
		{
			// check spawn location, in case damage direct only 
			if (SpawnableObjects[i].SpawnOnImpact && DamageType == None)
			{
				SpawnLocation = HitLocation;
				SpawnRotation = Rotator(HitNormal);
			}
			else
			{
				SpawnLocation = Location;
				SpawnRotation = Rotation;
			}

			// calculate offset local to self
			if (SpawnableObjects[i].SpawnOffset != Vect(0,0,0))
			{
				GetAxes(Rotation, X,Y,Z);
				SpawnLocation += SpawnableObjects[i].SpawnOffset.X * X + 
								 SpawnableObjects[i].SpawnOffset.Y * Y + 
								 SpawnableObjects[i].SpawnOffset.Z * Z;
			}

			//Log("Spawning "$SpawnableObjects[i].SpawnClass$" at "$SpawnableObjects[i].SpawnAtDamagePercent);

			// spawn an object form a class name
			if (SpawnableObjects[i].SpawnClass != None)
			{
				spawn(SpawnableObjects[i].SpawnClass, self,, SpawnLocation, SpawnRotation);
				bObjectModifed = true; // Joshua - Only flag as modified if there's a SpawnClass
			}

			// Trigger linked actor
			if (SpawnableObjects[i].TriggerableActor != None)
			{
				//Log(self$" Triggering from spawnable object"@SpawnableObjects[i].TriggerableActor);
				SpawnableObjects[i].TriggerableActor.Trigger(self, None);
				bObjectModifed = true; // Joshua - Only flag as modified if there's a TriggerableActor
			}

			// remove reference once spawned
			if (bDamageable && !SpawnableObjects[i].SpawnAlwaysOn)
			{
				SpawnableObjects.remove(i,1);
				i--;
			}

			// Joshua - Avoid setting this if an EGO's SpawnableObject is null, 
			// it would disable the light even though the mesh hasn't changed
			//bObjectModifed = true; 
		}
	}

	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	// Damage Meshes
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////

	// If there is damage done, maybe mesh will change
	if (bDamageable && Damage > 0 && DamagedMeshes.Length > 0)
	{
		//Log("Comparing with damaged mesh array["$DamagedMeshes.Length$"] for damage="$Damage);
		// be sure to have the greatest delta
		SmallestDelta = 101;
		iChosenMesh = -1;

		for (i = 0; i < DamagedMeshes.Length; i++)
		{
			// Find the more accurate mesh depending on DamagePercent
			Delta = DamagePercent - DamagedMeshes[i].Percent;
			//Log(" ... current Mesh["$DamagedMeshes[i].StaticMesh$"] at percent["$DamagedMeshes[i].Percent$"] for current DamagePercent="$DamagePercent);
			if (DamagePercent >= DamagedMeshes[i].Percent && Delta < SmallestDelta)
			{
				//Log("		- Could use this mesh for Delta["$Delta$"] smaller than SmallestDelta="$SmallestDelta);
				// keep this delta to be able to find a more accurate mesh in the array
				SmallestDelta = Delta;
				
				// use the most accurate mesh
				SetStaticMesh(DamagedMeshes[i].StaticMesh);
				// change collision mesh if specified
				if (DamagedMeshes[i].CollPrimMesh != None)
					SetCollisionPrim(DamagedMeshes[i].CollPrimMesh);

				// Joshua - Remove all skins from the object when switching to the damaged mesh
				// Fixes a Kola Cell laptop with screen skin applied, not sure if this fix should apply to other EGameplayObjects
				if (IsA('ELaptop'))
				Skins.Remove(0, Skins.Length);

				iChosenMesh = i;
				bObjectModifed = true;
			}
		}

		if (iChosenMesh == -1)
		{
			ForEach TouchingActors(class'EVolume',V)
			{
				if (V.bLiquid)
					bPlayBounce = false;
			}

			if (bPlayBounce)
				PlaySound(BounceSound, SLOT_SFX);		
		}
		else
		{
			if (HitPoints > 0)
			{
				if (iChosenMesh < HitSound.Length && HitSound[iChosenMesh] != None)
					PlaySound(HitSound[iChosenMesh], SLOT_SFX);
				else if (HitSound.Length > 0)
					PlaySound(HitSound[0], SLOT_SFX);
			}
			else if (HitSound.Length > 0) //Play the last sound of the array
				PlaySound(HitSound[HitSound.Length - 1], SLOT_SFX);
		}
	}
	else
	{
		if (!(IsA('EGamePlayObjectLight') && (HitPoints > 0))) 
		{
		if (HitSound.Length > 0)
			PlaySound(HitSound[0], SLOT_SFX);
	}
	}

	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	// Lights
	/////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////
	// Blow up lights when it has spawned objects OR changed mesh OR no more HitPoints
	if (bObjectModifed || HitPoints <= 0)
	{
		for (i = 0; i < ObjectLights.Length; i++)
		{
			if (ObjectLights[i] == None)
				continue;
			
			//Log("Destroying upon damage light"@i@"from"@self);
			ObjectLights[i].TurnOff(CHANGE_LightShotOut,Instigator);
			ObjectLights[i] = None;
			bAlreadyAdded = true;
		}

		// JFP: Shadow projector addition, PC specific
		for (i = 0; i < ObjectProjectors.Length; i++)
		{
			if (ObjectProjectors[i] == none)
				continue;
			ObjectProjectors[i].TurnOff(CHANGE_LightShotOut, Instigator);
			bAlreadyAdded = true;
		}
	}

	if (ChangeListWhenDamaged && !bAlreadyAdded)
		Level.AddChange(self, CHANGE_BrokenObject);


	// Notify class that item has been damaged to death
	if (HitPoints <= 0)
		Destructed();
}

//------------------------------------------------------------------------
// Description		
//		Send event to pattern on Trigger .. may be called from sub-classes
//------------------------------------------------------------------------
function TriggerPattern(optional Pawn TriggerInvestigator)
{
    
    if (!CanTrigger(TriggerInvestigator))
    {
        // Incorrect TriggerType, return
        return;
    }

	if (PatternAlreadyTrigger && TriggerPatternJustOnce)
		return;
	if (GroupAI == None || JumpLabel == '')
		return;

	//Log(self$" TriggerPattern"@GroupAI@JumpLabel);
	GroupAI.SendJumpEvent(JumpLabel, false, false);
	PatternAlreadyTrigger = true;
}

//------------------------------------------------------------------------
// Description		
//		Checks if Pattern can be triggered based on TriggerType
//------------------------------------------------------------------------
function bool CanTrigger(Pawn TriggerInvestigator)
{
    if (TriggerType == NoRestriction)
    {
        return true;
    }

    if ((TriggerType == PawnTriggered) && (TriggerInvestigator != None))
    {
        return true;
    }

    switch (TriggerType)
	{
		case PlayerTriggered:
			return TriggerInvestigator.IsPlayerPawn();
		case NPCTriggered:
			return (EAIController(TriggerInvestigator.controller) != None);
	}

    return false;
}

//------------------------------------------------------------------------
// Description		
//		utility somwhere ...
//------------------------------------------------------------------------
function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{
	local int i;

	// Send Trigger msg
	SendMessage(GOEV_Trigger);

	if (Other != None && Other.IsA('EInteractObject'))
		TriggerPattern(EventInstigator);

	for (i = 0; i < ObjectLights.Length; i++)
    {
        if (ObjectLights[i] != None)
		    ObjectLights[i].Trigger(Other, EventInstigator, InTag);
    }

	// JFP: Shadow projector addition, PC specific
	for (i = 0; i < ObjectProjectors.Length; i++)
	{
		if (ObjectProjectors[i] != none)
			ObjectProjectors[i].Trigger(Other, EventInstigator, InTag);
	}
}

//------------------------------------------------------------------------
// Description		
//		Push if pushable upon bump
//------------------------------------------------------------------------
function Bump(actor Other, optional int Pill)
{
	local float speed, oldZ;
	local bool bPlayBounce;
	local EVolume V;
	
	bPlayBounce = true;

	CheckSBOwner(Other.Velocity * default.Mass / Mass * Other.Mass / Mass);

	if (bPushable && (EPawn(Other)!=None) && (Other.Mass > 40))
	{
		oldZ = Velocity.Z;
		speed = VSize(Other.Velocity);
		if (speed > 0.0)
			Velocity = Other.Velocity * FMin(120.0, 20 + speed) / speed;
		if (Physics == PHYS_None) 
			Velocity.Z = 25;
		else
			Velocity.Z = oldZ;
		SetPhysics(PHYS_Falling);
	}

	ForEach TouchingActors(class'EVolume',V)
	{
		if (V.bLiquid)
			bPlayBounce = false;
	}

	if (bPlayBounce)
		PlaySound(BounceSound, SLOT_SFX);
}

//------------------------------------------------------------------------
//		Message system from Owned to Owner
//------------------------------------------------------------------------
function SendMessage(EGOMsgEvent Event, optional EGameplayObject Sender)
{
	local actor SendTo;

	// Send it to Owner or Base
	SendTo = Owner;
	if (SendTo == None)
		SendTo = Base;

	// if no Sender by default, make it self
	if (Sender == None)
		Sender = self;

	if (SendTo != None && SendTo.IsA('EGameplayObject'))
	{
		//Log(self$" MSG SENDS == GOEvent["$Event$"] from["$Sender$"]");
		EGameplayObject(SendTo).ReceiveMessage(Sender, Event);
	}
}
function ReceiveMessage(EGameplayObject Sender, EGOMsgEvent Event)
{
	//Log(self$" MSG RECEIVES == GOEvent["$Event$"] from["$Sender$"]");

	// Try to pass msg to owner
	SendMessage(Event, Sender);
}

state s_Selected
{
	function BeginState()
	{
		bCollideWorld = false;
		SetCollision(false, false, false);
		ResetInteraction();
	}

	function Use()
	{
		local EPlayerController EPC;
		// Treatment for NPC throw
		EPC = EPlayerController(Owner);
		if (EPC == None)
			Owner.GotoState('s_Throw');
	}
}

//------------------------------------------------------------------------
// State s_Flying (when object is thrown in the air)
//------------------------------------------------------------------------
state s_Flying
{
	function BeginState()
	{
		bHidden				= false;

		bCollideWorld		= true;
		bBounce				= true;
		bFixedRotationDir	= true;

		if (abs(RotationRate.Pitch)<10000) 
			RotationRate.Pitch=10000;
		if (abs(RotationRate.Roll)<10000) 
			RotationRate.Roll=10000;			

		SetCollision(true, true, false);
		SetPhysics(PHYS_Falling);
	}

	function Throw(Controller Thrower, vector ThrowVelocity)
	{
		Global.Throw(Thrower, ThrowVelocity);
		BeginState();
	}

	function TakeHit()
	{
		BeginState();
	}

	function Bump(Actor Other, optional int Pill)
	{
		local EPawn DamageInstigator;
		local float BumpDamage;

		// don't apply damage unless this thing is moving
		if (VSize(Velocity) < 20.0f)
			return;

		BumpDamage = Min(VSize(Velocity), 100) * Mass / class'EGameplayObject'.default.Mass;
		//Log(self$" BUMPS"@BumpDamage@Other@VSize(Velocity));

		if (Other.bIsPawn)
		{
			if (Mass > 40 && VSize(Velocity) > 300)
				Other.TakeDamage(10, None, Location, Velocity, Velocity, class'EKnocked', Pill);
			if (bIsProjectile)
				SetCollision(false);
		}
		else if ((Other.bIsGameplayObject && Mass > 40) || Other.bIsSoftBody)
		{
			// Send instigator for thrown object on other object
			if (Owner != None && Owner.bIsPawn)
				DamageInstigator = EPawn(Owner);
			else if (Controller(Owner) != None)
				DamageInstigator = EPawn(Controller(Owner).Pawn);

			Other.TakeDamage(BumpDamage, DamageInstigator, Location, Velocity, Velocity, class'EKnocked', Pill);
		}
	}

	function Landed(vector HitNormal)
	{
		if (bIsProjectile)
			SetCollision(true);
	}

	function HitWall(Vector HitNormal, Actor Wall)
	{
		local float Speed;
		local bool bPlayBounce;
		local EGameplayObject HitGo;
		local EVolume V;

		//Log(self@"* * HitWall"@Wall@hitnormal@Velocity);
		RandSpin(100000);

		if (Wall.bIsMover)
			Velocity -= Wall.Velocity;

		// Reflect on no-wall or pawn
		//	Velocity += Wall.Velocity;
		if (Wall == None || !Wall.bIsSoftBody)
			Velocity = 0.5* ((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping //1+coef

		// Maybe not needed...
		if (VSize(Velocity) > 2000.0)
			Velocity = Normal(Velocity) * 2000.0;
		
		Speed = VSize(Velocity);
		if (Wall.bIsMover)
			Velocity += Wall.Velocity;

		// if pawn, will slow down on its reflected trajectory
		// if softbody, will slow down on its normal trajectory
		if (Wall != None && (Wall.bIsSoftBody || Wall.bIsPawn))
		{
			Velocity.X *= 0.2;
			Velocity.Y *= 0.2;
		}

		RotationRate.Yaw = RotationRate.Yaw * 0.75;
		RotationRate.Roll = RotationRate.Roll * 0.75;
		RotationRate.Pitch = RotationRate.Pitch * 0.75;

		// if object hits bsp at high speed, it shatters
		if (Speed > 200 && bDamageable && bShatterable && !Wall.bIsSoftBody && !Wall.bIsPawn)
		{
			ProcessDamage(HitPoints, None, Location, HitNormal);

			// Shatter hit object
			HitGo = EGameplayObject(Wall);
			if (HitGo != None && HitGo.bDamageable && HitGo.bShatterable)
				HitGo.ProcessDamage(HitGo.HitPoints, None, Wall.Location, HitNormal);

			return;
		}

		// Dont stop for SoftBody
		if (((speed < 60 && HitNormal.Z > 0.7) || !bBounce) && (Wall == None || !Wall.bIsSoftBody))
		{
			SetPhysics(PHYS_None);
			bBounce = false;

			bFixedRotationDir	= false;
			bRotateToDesired	= false;
			RotationRate		= Rot(0,0,0);
			SetRotation(GetStillRotation(HitNormal));

			StoppedMoving();
		}
		else if (speed > 40) 
		{
			bPlayBounce = true;

			ForEach TouchingActors(class'EVolume',V)
			{
				if (V.bLiquid)
					bPlayBounce = false;
			}

			if (bPlayBounce && (Wall == None || !Wall.bIsSoftBody))
				PlaySound(BounceSound, SLOT_SFX);
		}

		if (HitNoiseRadius > 0)
		{			
			MakeNoise(HitNoiseRadius, NOISE_Object_Falling, 250.0f);
		}
	}

	function RandSpin(float spinRate)
	{
		DesiredRotation = RotRand();

		RotationRate.Yaw	= spinRate * 2 *FRand() - spinRate;
		RotationRate.Pitch	= spinRate * 2 *FRand() - spinRate;
		RotationRate.Roll	= spinRate * 2 *FRand() - spinRate;	
	}
}

//------------------------------------------------------------------------
// State s_Dying (Use this state to make object Destroy() only when player can't see them anymore)
//------------------------------------------------------------------------
state s_Dying
{
	function BeginState()
	{
		SetTimer(1.f + FRand(), true);
		SetCollision(true, false, false);
	}

	function EndState()
	{
		SetTimer(0, false);
	}

	function Timer()
	{
		if (!PlayerCanSeeMe()) 
			Destroy();
	}
}

//------------------------------------------------------------------------
// State s_Destructed (when object is destroyed. Only for simple object with no states)
//------------------------------------------------------------------------
state s_Destructed
{
	function ProcessDamage(int Damage, class<DamageType> DamageType, Vector HitLocation, Vector HitNormal);
	function Trigger(actor Other, pawn EventInstigator, optional name InTag);

	function Tick(float DeltaTime)
	{
		// Reduce heat to 0
		if (HeatIntensity > 0)
			HeatIntensity -= deltaTime / 10.f/*seconds*/;
		else
		{
			HeatIntensity = 0.f;
			Disable('Tick');
		}
	}
}

defaultproperties
{
    ObjectName="DefaultObject"
    LastTimeChange=-1.000000
    bDamageable=True
    bDestroyWhenDestructed=True
    HitPoints=100
    ExplosionClass=Class'EchelonEffect.EExplosion'
    ExplosionDamageClass=Class'EBurned'
    ExplosionDamage=200.000000
    ExplosionMinRadius=200.000000
    ExplosionMaxRadius=500.000000
    ExplosionNoiseRadius=2000.000000
    ExplosionMomentum=60000
    TriggerPatternJustOnce=True
    ChangeListWhenThrown=True
    ChangeListWhenDamaged=True
    TriggerType=NoRestriction
    bAcceptsProjectors=True
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'generic_obj.Misc.G_O'
    bCollideActors=True
    bStaticMeshCylColl=True
    bBlockProj=True
    bBlockBullet=True
    bBlockNPCVision=True
    bSideFadeEffect=True
    VolumeLightMesh=StaticMesh'LightGenOBJ.LightCubebeam.lightcubebeamB'
    SpotProjectedMaterial=ELightBeamMaterial'ETexRenderer.Dev.SpotLightBeam_Default'
    bIsGamePlayObject=True
    bIsTouchable=False
}