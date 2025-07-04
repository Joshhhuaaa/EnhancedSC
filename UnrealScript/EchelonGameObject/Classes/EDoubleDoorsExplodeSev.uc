class EDoubleDoorsExplodeSev extends EGameplayObjectPattern;

function Trigger( actor Other, pawn EventInstigator, optional name InTag )
{
	Super.Trigger(Other, EventInstigator, InTag);
	SetCollision(false);
}

defaultproperties
{
    bExplodeWhenDestructed=true
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_DoorexplodeB',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EDoubleDoorsSevEmitter',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EDarkSmoke',SpawnAtDamagePercent=100.000000)
    ExplosionSound=Sound'DestroyableObjet.Play_DoorExplosion343'
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_doorexplode'
    bStaticMeshCylColl=false
    bBlockPlayers=true
    bBlockActors=true
}