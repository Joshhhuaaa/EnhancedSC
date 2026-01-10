class ECeillingFan extends EGameplayObject;

#exec OBJ LOAD FILE=..\textures\ETexIngredient.utx
#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

var		EGameplayObject	myWings;
var()	int				RotationSpeed;

function PostBeginPlay()
{
	myWings = spawn(class'EGameplayObject', self,,ToWorld(Vect(0,0,-3)));
	if (myWings == None)
		Log("Couldn't spawn a Ceilling Fan wings for"@self);
	myWings.SetStaticMesh(StaticMesh'EMeshIngredient.Object.CeillingFanWings');
	myWings.SetDrawScale(DrawScale * 0.8f);
	myWings.bDamageable = false;

	myWings.SetPhysics(PHYS_Rotating);
	myWings.bFixedRotationDir = true;
	myWings.RotationRate.Yaw = RotationSpeed;

	tag = 'fan';
	myWings.tag = 'wing';

	Super.PostBeginPlay();
}

state s_Destructed
{
	function Tick(float DeltaTime)
	{
		myWings.RotationRate.Yaw = Clamp(myWings.RotationRate.Yaw, 0, myWings.RotationRate.Yaw - 10000 * DeltaTime);
		if (myWings.RotationRate.Yaw <= 0)
		{
			myWings.SetPhysics(PHYS_None);
			Disable('Tick');
		}
	}
}

defaultproperties
{
    RotationSpeed=100000
    bDestroyWhenDestructed=False
    StaticMesh=StaticMesh'EMeshIngredient.Object.ceillingfan'
    CollisionRadius=8.000000
    CollisionHeight=2.000000
}