class EAquariumGlass extends ELiquidContainer;

var float hit_z;
var float hit_level;

// Get the HitLocation.Z and hit_level
function float GetHitLevel(vector hit_location)
{
	hit_z = hit_location.Z;
	hit_level = Super.GetHitLevel(hit_location);
	return hit_level;
}

defaultproperties
{
    hit_level=-1.000000
    SpillTexture=Texture'ETexSFX.water.SFX_Water_Jets'
    LiquidLevel=80.000000
    LiquidDrainSpeed=2.000000
    bShatterable=True
    HitPoints=200
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EEauAqua',SpawnOffset=(Z=-100.000000),SpawnAtDamagePercent=100.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.EGlasseAqua',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EAquariumWaterSpill',SpawnOffset=(Z=-162.000000),SpawnAtDamagePercent=100.000000)
    ExplosionSound=Sound'DestroyableObjet.Play_AquariumDestroyed'
    StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_Aquawindow'
    bStaticMeshCylColl=False
    bBlockNPCShot=True
    bBlockNPCVision=False
}