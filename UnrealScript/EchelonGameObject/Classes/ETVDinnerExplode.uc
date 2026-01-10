class ETVDinnerExplode extends EGameplayObject;

defaultproperties
{
    bShatterable=True
    HitPoints=200
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EMeshIngredient.Obj_Kalinatek.GO_TV_Dinnerb1',Percent=50.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EMeshIngredient.Obj_Kalinatek.GO_TV_Dinnerb2',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EMirrorspark',SpawnAtDamagePercent=50.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EExplosionComputer',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EGlasseScreen',SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_ScreenDestroyed'
    StaticMesh=StaticMesh'EMeshIngredient.Obj_Kalinatek.GO_TV_Dinner'
}