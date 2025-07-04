class EVan extends EAnimatedObject;

var EGameplayObject		GazTank;
var EGameplayObject		Van;
var EGameplayObject		Trailer;

#exec OBJ LOAD FILE=..\Animations\ETrk.ukx PACKAGE=ETrk

#exec MESH CLEARATTACHTAGS MESH=Trk

#exec MESH ATTACHNAME MESH=Trk BONE="TRK_Trailer"	TAG="Front"	YAW=-64 PITCH=-64 ROLL=0 X=0 Y=0 Z=0
#exec MESH ATTACHNAME MESH=Trk BONE="TRK_cargo"		TAG="Back"	YAW=-64 PITCH=-64 ROLL=0 X=0 Y=0 Z=0

#exec SAVEPACKAGE FILE=..\Animations\ETrk.ukx PACKAGE=ETrk

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Tank
	GazTank = spawn(class'EGameplayObject', self);
	GazTank.Tag = 'GazTank';
	GazTank.SetStaticMesh(None);
	GazTank.SetCollisionPrim(StaticMesh'EMeshIngredient.object.TruckTank');
	GazTank.bBlockBullet = false;
	GazTank.bCPBlockBullet = true;
	GazTank.SetBase(self);
	GazTank.SetRelativeRotation(Rot(0,-16383,0));
	//GazTank.bDamageable = false;

	// Van
	Van = spawn(class'EGameplayObject', self);
	Van.Tag = 'Van';
	Van.SetStaticMesh(None);
	Van.SetCollision(false);
	//Van.SetCollisionPrim(StaticMesh'EMeshIngredient.Vehicle.Van_Front');
	//Van.bDamageable = false;
	//Van.bBlockBullet = false;
	//Van.bCPBlockBullet = true;
	//Van.bCPBlockPlayers = true;
	//Van.bHidden = true;
	//Van.SetBase(self);
	//Van.SetRelativeRotation(Rot(0,-16383,0));
	AttachToBone(Van, 'Front');

	// Trailer
	Trailer = spawn(class'EGameplayObject', self);
	Trailer.Tag = 'Trailer';
	Trailer.SetStaticMesh(None);
	Trailer.SetCollision(false);
	//Trailer.SetCollisionPrim(StaticMesh'EMeshIngredient.Vehicle.Van_Back');
	//Trailer.bDamageable = false;
	//Trailer.bBlockBullet = false;
	//Trailer.bCPBlockBullet = true;
	//Trailer.bCPBlockPlayers = true;
	//Trailer.bHidden = true;
	AttachToBone(Trailer, 'Back');
}

function ReceiveMessage( EGameplayObject Sender, EGOMsgEvent Event )
{
	if( Sender == GazTank && Event == GOEV_Destructed )
		DestroyObject();

	Super.ReceiveMessage(Sender, Event);
}

function Destructed()
{
	if( Van != None )
	{
		Van.SetStaticMesh(StaticMesh'EMeshIngredient.Vehicle.Van_Front');
		DetachFromBone(Van);
		Van.bHidden = false;
	}

	if( Trailer != None )
	{
		Trailer.SetStaticMesh(StaticMesh'EMeshIngredient.Vehicle.Van_Back');
		DetachFromBone(Trailer);
		Trailer.bHidden = false;
	}

	Mesh = None;
	bHidden = true;

	Super.Destructed();
}

defaultproperties
{
    NeutralPoseAnim="4330trk5"
    bLoopNeutral=true
    NeutralAnims(0)="4330trk7"
    TriggeredAnimations(0)="4330trk6"
    TriggeredAnimations(1)="4330trk8"
    bExplodeWhenDestructed=true
    bDestroyWhenDestructed=false
    ExplosionClass=Class'EchelonEffect.EDrumExplosionParticle'
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'ETrk.Trk'
    CollisionHeight=45.000000
    bCollideActors=false
}