class EWallMine extends EInventoryItem
	config(Enhanced) // Joshua - Class, configurable in Enhanced config
	native;

var() int	DetectionRadius,
			DetectionHeight;
// Joshua - ExplosionDelay, configurable in Enhanced config
var() config float	ExplosionDelay;			// Time left before explosion, may be set in editor .. must not be modified while playing
var() float ActivationDelay;		// Time before wallmine activates on wall
var() int	MovementThreshold;
var() float TickNoiseRadius;		// how far noise of WallMineTick travels 
var	  bool	Emitting;				// True if emitting
var Controller Defuser;

var   EVolumeTrigger	DetectionVolume;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Destroy Interaction if placed on wall by designer
	if( InitialState != '' )
	{
		InteractionClass = None;
		Interaction.Destroy();
	}

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_wallmines;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_wallmines;
    ItemName     = "WallMine";
	ItemVideoName = "gd_wallmine.bik";
    Description  = "WallMineDesc";
	HowToUseMe  = "WallMineHowToUseMe";
}

function Deactivate( bool Success )
{
	// Only send when defuse is good.
	if( Success )
	TriggerPattern();
}

event Destroyed()
{
	Super.Destroyed();

	if( DetectionVolume != None )
		DetectionVolume.Destroy();
}

function Detonate( Controller Instigator )
{
	GotoState('s_Activated');
}

function SpawnInteraction()
{
	ResetInteraction();
	InteractionClass = class'EWallMineInteraction';
	Interaction = spawn(InteractionClass, self);
}

function bool CheckWallInFront()
{
	local Vector	HitLocation, HitNormal, StartTrace, EndTrace;
	local Actor		Hit;

	if ( Controller.bIsPlayer )
	{
		StartTrace = Controller.Pawn.ToWorld(Controller.Pawn.CollisionRadius * Vect(1,0,0));
		StartTrace += Controller.Pawn.CollisionHeight * Vect(0,0,0.5);
		EndTrace = StartTrace + Controller.Pawn.ToWorldDir(15.f * Vect(1,0,0));
	}
	else
	{
		StartTrace = Controller.Pawn.ToWorld(Controller.Pawn.CollisionRadius * Vect(0,1,0));	// offset to the right
		EndTrace = Controller.Pawn.ToWorld(Controller.Pawn.CollisionRadius*2.0f * Vect(1,0,0));	// check in front of pawn
	}

	Hit = Controller.Pawn.Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	if( Hit == None || Hit.bIsPawn )
	{
		log("No object in front of mine");
		return false;
	}

	return true;
}

function Select( EInventory Inv )
{
	if (GetStateName() != 's_Selected')
		PlaySound(Sound'Interface.Play_FisherEquipWallMine', SLOT_Interface);
	Super.Select(Inv);
}

state s_Inventory
{
	function EndState()
	{
		Super.EndState();
		bHidden = true;
	}
}

state s_Selected
{
	function Use()
	{
		if( !CheckWallInFront() )
			return;

		// Remove mine interaction
		ResetInteraction();

		// send message to Owner (Controller) that item can be place
		Owner.GotoState('s_PlaceWallMine');
	}
}

state s_PawnPlacement
{
	function BeginState()
	{
		// make sure timer is resetted
		SetTimer(0,false);
	}

	function EndState()
	{
		// make sure timer is resetted
		SetTimer(0,false);
	}

	function Timer()
	{
		GotoState('s_OnWall');
	}

	function Tick( float DeltaTime )
	{
		if( !CheckWallInFront() )
		{
			Controller.GotoState(,'Aborted');
			GotoState('s_Selected');
		}
	}

	function bool CalculatePosition( bool bTest )
	{
		local Vector	X,Y,Z, HitLocation, HitNormal, start, end;
		local Actor		Hit;

		// Check if there's a wall near
		GetAxes(Controller.Pawn.Rotation, X, Y, Z);

		if ( Controller.bIsPlayer ) 
		{
			start	= Location - (X * 10.f); // Start will be just behind hand wallmine to prevent sticking it over another wallmine
			end		= Location + (X * (Controller.Pawn.CollisionRadius * 2.0));
		}
		else
		{
			start	= Location - (X * Controller.Pawn.CollisionRadius); // start behind current location if NPC is placing
			end		= Location + (X * (Controller.Pawn.CollisionRadius * 4.0));
		}

		Hit = Controller.Pawn.Trace(HitLocation, HitNormal, end, start, true);
		// Abort if no wall in front or already a wallmine
		if( Hit == None || Hit.class == self.class )
		{
			Log(self$" WARNING: Wallmine HitActor moved or not valid.");
			return false;
		}

		// If just first check
		if( bTest )
			return true;

		// If wall is valid and is actual hand placement
		if( HitNormal Dot Vector(Controller.Pawn.Rotation) > 0 )
			HitNormal = -HitNormal;
		SetLocation(HitLocation+CollisionRadius/2.f*HitNormal);
		SetRotation(Rotator(HitNormal));
		SetBase(Hit);

		return true;
	}

QuickCheck:
	// Quick check for spot before doing loop cycle
	if( !CalculatePosition(true) )
	{
		Controller.GotoState(,'Aborted');
		GotoState('s_Selected');
	}
	Stop;

PlaceOnWall:
	Disable('Tick');
	// Find real spot for actual placement
	if( !CalculatePosition(false) )
	{
		Controller.GotoState(,'Aborted');
		GotoState('s_Selected');
	}
	// activate collision to be able to shoot it
	SetCollision(true, true, true);
	bCollideWorld = true;
	// Spawn the deactivation interaction
	SpawnInteraction();
	// Remove from inventory
	ProcessUseItem();
	// Remove controller here
	Controller = None;
	// Add to changed actor list from player only
	Level.AddChange(self, CHANGE_WallMine);
	// Start activation timer
	SetTimer(ActivationDelay, false);
}

state() s_OnWall
{
	function BeginState()
	{
		SetOwner(None);

		HeatIntensity = 0.85;

		// activate collision to be able to shoot it
		SetCollision(true, true, true);
		// Spawn the deactivation interaction
		SpawnInteraction();

		// Activate detection zone
		DetectionVolume = spawn(class'EVolumeTrigger', self);
		DetectionVolume.SetCollisionSize(DetectionRadius, DetectionHeight);
		DetectionVolume.RepeatTriggerTime = 0.1f;

		// to change to non emitting
		SetTimer(0.5, true);
	}

	function EndState()
	{
		SetTimer(0.f, false);
		
		Skins[1]=Material'ETexIngredient.Object.wallminegreenGLW';
		LastTimeChange = Level.TimeSeconds;
		HeatIntensity = 0;
		Emitting = false;
	}

	event Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		local EPawn P;
		if( !Other.IsA('EVolumeTrigger') )
			return;

		P = EPawn(EventInstigator);

		// While interacting with wallmine, Defuser is Instigator and must not be detected while moving towards it
		if( Defuser != None && P == Defuser.Pawn )
		{
			//Log("Movement from defuser");
			return;
		}

		if( P.bIsNPCPawn )
			MovementThreshold = P.GetMoveSpeed(MOVE_WalkRelaxed) + 5;
		else
			MovementThreshold = default.MovementThreshold;

		//Log("VolumeTriggered Emitting="$Emitting$" Displacement="$VSize(EventInstigator.Velocity)$" MovementThreshold="$MovementThreshold$" Trace="$TraceTarget(EventInstigator.Location, Location, EventInstigator)@VSize(EventInstigator.Velocity) > MovementThreshold);
		if( Emitting && VSize(EventInstigator.Velocity) > MovementThreshold && TraceTarget(EventInstigator.Location, Location, EventInstigator) )
			GotoState('s_Activated');
	}

	function Deactivate( bool Success )
	{
		// stop light
		HeatIntensity = 0;
		Skins[1]=Material'ETexIngredient.Object.wallminegreenGLW';
		Disable('Timer');

		// No more need for this
		DetectionVolume.Destroy();

		//log("trying to deactivate .. will explode?"@Emitting@Success);

		Global.Deactivate(Success);
	}

	function Timer()
	{
		Emitting = !Emitting;
		if( Emitting )
		{
			PlaySound(Sound'FisherEquipement.Play_WallMineActivated', SLOT_SFX);
			Skins[1]=Material'ETexIngredient.Object.wallmineredGLW';
		}
		else
		{
			Skins[1]=Material'ETexIngredient.Object.wallminegreenGLW';
		}
		
		LastTimeChange = Level.TimeSeconds;
	}
}

state() s_Activated
{
	function BeginState()
	{
		Skins[1]=Material'ETexIngredient.Object.wallmineredGLW';

		// Play detected sound
		PlaySound(Sound'FisherEquipement.Play_Sq_WallMineWarning', SLOT_SFX);
		
		// Make Noise for AI detection.
		MakeNoise(TickNoiseRadius, NOISE_WallMineTick);

		// Start Timer
		SetTimer(0.1, true);
		Emitting = true;
	}

	function Timer()
	{
		if( Skins[1] == Material'ETexIngredient.Object.wallminegreenGLW' )
		{
			Skins[1]=Material'ETexIngredient.Object.wallmineredGLW';
		}
		else
		{
			Skins[1]=Material'ETexIngredient.Object.wallminegreenGLW';
		}
	}

	function Detonate( Controller Instigator )
	{
		if( Interaction != None && Defuser != None && Defuser.GetStateName() == 's_DisableWallMine' )
		{
			Defuser.Interaction = None;
			Defuser.GotoState(,'Aborted');
		}

		if( Instigator != None )
			Super.TakeDamage(HitPoints, Instigator.Pawn, Vect(0,0,0), Vect(0,0,0), Vect(0,0,0), None);
		else
			Super.TakeDamage(HitPoints, None, Vect(0,0,0), Vect(0,0,0), Vect(0,0,0), None);
	}

begin:
	Sleep(ExplosionDelay);
	Detonate(None);
}

state s_Flying
{
	Ignores ProcessUseItem;

	function BeginState()
	{
		Super.BeginState();
		SetCollisionSize(1, CollisionHeight);
	}

	// As soon as wall mine begins falling, explode upon contact
	function Bump( Actor Other, optional int Pill )
	{
		Super.Bump(Other, Pill);
		bFixedRotationDir = false;
		Detonate(None);
	}
	function Landed( vector HitNormal )
	{
		Super.Landed(HitNormal);
		bFixedRotationDir = false;
		Detonate(None);
	}
	function HitWall( Vector HitNormal, Actor Wall )
	{
		Super.HitWall(HitNormal, Wall);
		bFixedRotationDir = false;
		Detonate(None);
	}
}

defaultproperties
{
    DetectionRadius=200
    DetectionHeight=100
    ExplosionDelay=1.750000
    ActivationDelay=8.0000000
    MovementThreshold=200
    TickNoiseRadius=500.0000000
    MaxQuantity=3
    bDamageable=true
    bExplodeWhenDestructed=true
    ExplosionSound=Sound'FisherEquipement.Play_WallMineExplosion'
    StaticMesh=StaticMesh'EMeshIngredient.Item.wallmine'
    CollisionRadius=4.5000000
    CollisionHeight=5.5000000
}