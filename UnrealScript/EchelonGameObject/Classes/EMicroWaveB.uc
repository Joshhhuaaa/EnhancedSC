class EMicroWaveB extends EGameplayObject;

#exec OBJ LOAD FILE=..\StaticMeshes\EGO_OBJ.usx

function PostBeginPlay()
{
	local EGameplayObject display;
	display = spawn(class'EGameplayObject', self);
	display.SetBase(self);
	display.SetStaticMesh(StaticMesh'EGO_OBJ.GenObjGO.GO_MicroWaveGlow00B');
	display.SpawnableObjects.Length = 2;
	display.SpawnableObjects[0].SpawnClass = Class'EchelonEffect.EGlassSmallParticle';
	display.SpawnableObjects[0].SpawnAtDamagePercent = 100;
	display.SpawnableObjects[0].SpawnOnImpact = true;
	display.SpawnableObjects[1].SpawnClass = Class'EchelonEffect.ESparkEmitter';
	display.SpawnableObjects[1].SpawnAtDamagePercent = 100;
	display.SpawnableObjects[1].SpawnOnImpact = true;

	Super.PostBeginPlay();
}

defaultproperties
{
    bShatterable=True
    HitPoints=400
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_cafe_microwave01B',Percent=25.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_cafe_microwave02B',Percent=50.000000)
    DamagedMeshes(2)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_cafe_microwave03B',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnAtDamagePercent=25.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EGlassSmallParticle',SpawnAtDamagePercent=50.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EGlasseScreen',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_LittleWindowDestroyed'
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_cafe_microwave00B'
}