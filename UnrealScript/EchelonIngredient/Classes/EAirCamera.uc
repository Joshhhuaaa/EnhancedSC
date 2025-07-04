class EAirCamera extends ESecondaryAmmo
	abstract;

var	Rotator				camera_rotation;
var EPlayerController	Epc;
var float				MaxDamping;
var bool				bDirectShot;

// Backup controller setting
var Texture				BackupThermalTexture;
var bool				BackupbBigPixels;		

var int					RenderingMode;

const					CameraAdjustment = 5;

function TakeView()
{
	Enable('Tick');
	
	// Block the PlayerController. Ends in s_camera EndState
	Epc.backupRotation = Epc.Rotation;
	Epc.SetCameraFOV(self, Epc.DesiredFov);
	Epc.SetBase(self);
	Epc.SetRelativeLocation(-CameraAdjustment*Vect(1,0,0));
	Epc.SetRelativeRotation(Rot(0,32767,0));
	Epc.m_camera.GoToState('s_Fixed');
	if( !Epc.bVideoMode )
		Epc.bLockedCamera = true;
	Epc.SetViewTarget(self);
	
	BackupThermalTexture= Epc.ThermalTexture;
    BackupbBigPixels	= Epc.bBigPixels;		

	RenderingMode		= REN_DynLight;
	Epc.SetCameraMode(self, RenderingMode);

	//log("* * * TAKE"@RelativeLocation@RelativeRotation@Epc.backupRotation@Epc.FovAngle@Epc.Base@Epc.RelativeLocation@Epc.RelativeRotation@Epc.bLockedCamera@Epc.ViewTarget);

	ObjectHud.GotoState('s_Online');
}

function GiveView( bool bFromPlayer )
{
	//log("* * * GIVE");
	ObjectHud.GotoState('');

	// Restore vision
	Epc.PopCamera(self);
	Epc.ThermalTexture	= BackupThermalTexture;
    Epc.bBigPixels		= BackupbBigPixels;		

	// UnBlock the PlayerController
	Epc.bLockedCamera = false;
	Epc.bDisableWhistle = false;
	Epc.m_camera.GotoState('s_Following');
	Epc.SetRotation(Epc.backupRotation);
	Epc.SetBase(None);
	Epc.SetViewTarget(Epc.Pawn);
	Disable('Tick');

	if( !bFromPlayer )
		return;
	
	Controller = None;
	if( !Epc.OnGroundScope() )
		Log("ERROR: OnGroundScope should never fail here.  Make sure everything's set so that it returns in FirstPersonTargeting");
}

function HudView( bool bIn )
{
	//Log("HUD VIEW!!!"@bIn@Controller);
	
	if( Controller == None )
		return;
	if( bIn )
	{
		TakeView();
		WallAdjust();
	}
	else
		GiveView(false);
}

function WallAdjust()
{
	// set once Camera location
	Epc.SetRelativeLocation(CameraAdjustment * Vect(1,0,0));
	Epc.SetRelativeRotation(Rot(0,0,0));
}

function Select( EInventory Inv )
{
	Super.Select(Inv);
	PlaySound(Sound'Interface.Play_FisherEquipStickyCam', SLOT_Interface);
}

function rotator GetStillRotation( vector HitNormal )
{
	return FindSlopeRotation(HitNormal, Rotation);
}

function Throw(Controller Thrower, vector ThrowVelocity)
{
	bDirectShot = true;
	Super.Throw(Thrower, ThrowVelocity);
}

function HitFakeBackDrop()
{
	if( Controller != None && Epc != None )
		GiveView(true);
	Super.HitFakeBackDrop();
}

// In '' state, after camera
function HitWall( Vector HitNormal, Actor Wall )
{
	Velocity = (5 + (FRand()*75)) * (Vector(Rotation) + HitNormal);
	TakeHit();
	SetCollision(false);
}

state s_Flying
{
	Ignores WallAdjust;

	function BeginState()
	{
		Epc = EPlayerController(Controller);
		if( Epc != None )
			EMainHUD(Epc.myHud).Slave(self);

		Super.BeginState();
	}

	function Bump( Actor Other, optional int Pill )
	{
		if( Other.bIsPawn || Other.bIsSoftBody )
			bDirectShot = false;

		Super.Bump(Other, Pill);
	}

	function HitWall( Vector HitNormal, Actor Wall )
	{
		local rotator initial_rotation;

		// Don't stick if wall ...
		if( (Controller == None && !bDirectShot) ||	// was already used
			Wall.bIsPawn ||							// is a pawn
			(Wall.bIsGameplayObject && (EInventoryItem(Wall)!=None || EGameplayObject(Wall).DestroyTime == Level.TimeSeconds)) || // is another inventory item
			(Wall.bIsGameplayObject && Wall.CollisionPrimitive == None && Wall.bStaticMeshCylColl ) ||
			(!bDirectShot && HitNormal.Z<0.7f) ||	// is a rebound and foor z too abrupt
			Wall.IsA('EBreakableGlass') )			// is a breakable glass because will shatter
		{
			bDirectShot = false;
			Super.HitWall(HitNormal, Wall);
			return;
		}

		// Fix rotation on wall direction if direct shot
		if( bDirectShot )
			initial_rotation = Normalize(Rotator(HitNormal));
		else
			initial_rotation = FindSlopeRotation(HitNormal, Rotation);
		SetRotation(initial_rotation);

		bDirectShot = false;

		// Do this to prevent camera from moving on wall
		SetPhysics(PHYS_None);
		bFixedRotationDir = false;
		RotationRate = Rot(0,0,0);

		// Has to stick on wall,mover, etc .. if it moves
		SetBase(Wall);

		// Give pickup interaction
		Interaction = Spawn(InteractionClass, self);

		// Prevent camera from taking control is Player is dead
		if( Controller == None )
		{
			GotoState('');
			return;
		}

		// Remove possibility to launch another cam while one already in the air
		if( Controller.GetStateName() != 's_FrozenInput' )
			GotoState('s_Camera');
	}

	function Tick( float deltaTime )
	{
		if( Epc == None )
			return;

		// if player is dead, stop processing
		if( Epc.bFire != 0 || Epc.Pawn.Health <= 0 )
			GiveView(true);
	}
}

//------------------------------------------------------------------------
// state s_Camera - Camera is in Use
//------------------------------------------------------------------------
state s_Camera
{
	function BeginState()
	{
		Level.AddChange(self, CHANGE_AirCamera);

		if( !Epc.bVideoMode )
			Epc.UsePalm();

		WallAdjust();

		Epc.m_camera.Tilt(2000, 50000, 5000);

		Epc.bDisableWhistle = true;
	}

	// same as Normalize for a rotator but for an int only
	function int CenterToZero( int v )
	{
		v = v & 65535; 
		if( v >= 32769 ) 
			v -= 65536;
		return v;
	}

	function int GetIntInRange( int iStart, int iRange, int iCur )
	{
		local int iDelta;
		iDelta = CenterToZero(iCur - iStart);
		if(iDelta < 0)
			return CenterToZero(iStart + Max(-iRange, iDelta));
		else
			return CenterToZero(iStart + Min(iRange, iDelta));
	}

	function Tick( float deltaTime )
	{
		local Rotator previous_rotation, delta_rotation, clamped_rotation;
		local float deltaMov;
		previous_rotation = camera_rotation;

		// Set camera rotation from player camera movement.
		// MaxDamping is set in sub-classes depending on camera type
		clamped_rotation		= camera_rotation;
		clamped_rotation.Yaw   += Epc.aTurn * MaxDamping;
		clamped_rotation.pitch -= Epc.aLookUp * MaxDamping;

		camera_rotation.yaw = GetIntInRange(0, 8191, clamped_rotation.yaw);
		camera_rotation.pitch = GetIntInRange(0, 8191, clamped_rotation.pitch);
		
		// Motor rumble
		delta_rotation = previous_rotation - camera_rotation;
		if( delta_rotation != Rot(0,0,0) )
		{
			deltaMov = (FMax(Abs(delta_rotation.pitch), Abs(delta_rotation.yaw))/MaxDamping);
			if(FRand() > 0.5)
				Epc.m_camera.Hit(60 * deltaMov, 20000, true);
			else
				Epc.m_camera.Hit(-60 * deltaMov, 20000, true);
			Level.RumbleVibrate(0.07f, deltaMov * 0.5);
		}

		// control Camera
		Epc.m_camera.UpdateView(camera_rotation, true);

		// if player is dead, stop processing
		if( Epc.bFire != 0 || Epc.Pawn.Health <= 0 )
		{
			Epc.bFire = 0;
			GiveView(true);
		}
	}
}

//------------------------------------------------------------------------
// Description		
//		Do treatment depending on light vars (50% of the visibility)
//------------------------------------------------------------------------
event VisibilityRating GetActorVisibility()
{
	return VisibilityTableLookup( GetVisibilityFactor()/2 );
}

defaultproperties
{
    MaxDamping=400.000000
    ChangeListWhenThrown=false
    CollisionRadius=1.000000
    CollisionHeight=2.000000
}