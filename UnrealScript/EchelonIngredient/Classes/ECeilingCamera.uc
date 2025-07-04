class ECeilingCamera extends EBaseCam;

function PostBeginPlay()
{
	if( !bDamageable )
	{
		Mesh = SkeletalMesh'ceilCamUnbreakMesh';
		CameraHeadMesh = StaticMesh'EMeshIngredient.object.CeilUnCamCMesh';
		CameraBaseMesh = StaticMesh'EMeshIngredient.object.CeilUnBaseCMesh';
	}

	Super.PostBeginPlay();
}

defaultproperties
{
    CameraHeadMesh=StaticMesh'EMeshIngredient.Object.CeilCamCMesh'
    CameraBaseMesh=StaticMesh'EMeshIngredient.Object.CeilBaseCMesh'
    PatrolAngle=360
    SoundAlert=Sound'Electronic.Play_CameraDomeZoom'
    SoundReverse=Sound'Electronic.Play_CameraDomeScanSwitch'
    Mesh=SkeletalMesh'ESkelIngredients.ceilCamMesh'
    CollisionRadius=26.000000
    CollisionHeight=12.000000
}