class EVideo extends EGameplayObject;

#exec OBJ LOAD FILE=..\StaticMeshes\EGO_OBJ.usx

function PostBeginPlay()
{
	local EGameplayObject display;
	display = spawn(class'EGameplayObject', self);
	display.SetBase(self);
	display.SetStaticMesh(StaticMesh'EGO_OBJ.ABA_ObjGO.GO_video_Dial_ABA');
	display.SpawnableObjects.Length = 1;
	display.SpawnableObjects[0].SpawnClass = Class'EchelonEffect.EGlassSmallParticle';
	display.SpawnableObjects[0].SpawnAtDamagePercent = 100;
	display.SpawnableObjects[0].SpawnOnImpact = true;
	
	Super.PostBeginPlay();
}

defaultproperties
{
    HitPoints=1200
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.ABA_ObjGO.GO_video_ABA01B',Percent=25.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.ABA_ObjGO.GO_video_ABA02B',Percent=50.000000)
    SpawnableObjects(0)=(SpawnAtDamagePercent=25.000000)
    SpawnableObjects(1)=(SpawnAtDamagePercent=100.000000)
    StaticMesh=StaticMesh'EGO_OBJ.ABA_ObjGO.GO_video_ABA00B'
}