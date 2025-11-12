class ELantern extends EGameplayObject;

#exec OBJ LOAD FILE=..\Animations\ESkelIngredients.ukx PACKAGE=ESkelIngredients

#exec MESH ADDPILLVERTEX MESH=lanternMesh BONE="Bone02" X=20 Y=0.0 Z=0
#exec MESH ADDSPHEREPILL MESH=lanternMesh VERTEX=0 RADIUS=10 TAG=1 PRIORITY=1

// save UKX with #exec changes
#exec SAVEPACKAGE FILE=..\Animations\ESkelIngredients.ukx PACKAGE=ESkelIngredients


function PostBeginPlay()
{
	Super.PostBeginplay();
	
	if (ObjectLights.Length > 0)
	{
		ObjectLights[0].bMovable = true;
		AttachToBone(ObjectLights[0],'Bone03');
	}
	
	LoopAnim('Swing');
}

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'ESkelIngredients.lanternMesh'
}