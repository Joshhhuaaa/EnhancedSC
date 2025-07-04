class ECamera extends EBaseCam;

function PostBeginPlay()
{
	if( !bDamageable )
	{
		Mesh = SkeletalMesh'camUnBreakMesh';
		CameraHeadMesh = StaticMesh'EMeshIngredient.object.UnCamCMesh';
		CameraBaseMesh = StaticMesh'EMeshIngredient.object.UnBaseCMesh';
	}

	Super.PostBeginPlay();
}

defaultproperties
{
    CameraHeadMesh=StaticMesh'EMeshIngredient.Object.CamCMesh'
    CameraBaseMesh=StaticMesh'EMeshIngredient.Object.BaseCMesh'
    Mesh=SkeletalMesh'ESkelIngredients.camMesh'
    CollisionRadius=26.000000
    CollisionHeight=12.000000
}