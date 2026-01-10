class EChanderler extends EGamePlayObjectLight;

#exec OBJ LOAD FILE=..\textures\LightGenTex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\LightGenOBJ.usx

function PostBeginPlay()
{
	SpawnPart(Vect(0,0,0), 20);
	SpawnPart(Vect(5.918,10.211,-6.231), DrawScale);
	SpawnPart(Vect(11.847,-0.001,-6.231), DrawScale);
	SpawnPart(Vect(5.923,-10.327,-6.231), DrawScale);
	SpawnPart(Vect(-5.984,-10.215,-6.231), DrawScale);
	SpawnPart(Vect(-11.817,-0.001,-6.231), DrawScale);
	SpawnPart(Vect(-5.924,10.209,-6.231), DrawScale);

	// Remove linked lights once distributed among parts.
	ObjectLights.Remove(0,ObjectLights.Length);

	Super.postBeginPlay();
}

function SpawnPart(vector Offset, float Scale)
{
	local EChanderlerPart Part;
	local int i;

	Part = spawn(class'EChanderlerPart', self,, ToWorld(DrawScale * Offset));
	Part.SetDrawScale(Scale);
	Part.bAcceptsProjectors = false;

	// Disitribute lights through all parts
	for (i = 0; i < ObjectLights.Length; i++)
		Part.ObjectLights[Part.ObjectLights.Length] = ObjectLights[i];
	Part.PreBeginPlay();
}

defaultproperties
{
    StaticMesh=StaticMesh'LightGenOBJ.Chanderler.Go_Chanderler'
    DrawScale=10.000000
}