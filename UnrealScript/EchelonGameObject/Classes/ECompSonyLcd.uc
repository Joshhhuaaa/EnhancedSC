class ECompSonyLcd extends EGamePlayObjectLight;

#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

defaultproperties
{
    OffMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_CompSonyLcdBOff'
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_CompSonyLcdB',Percent=100.000000)
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EMirrorspark',SpawnAtDamagePercent=50.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.ElightDarkSmoke',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(2)=(SpawnClass=Class'EchelonEffect.EExplosionComputer',SpawnOffset=(Z=17.000000),SpawnAtDamagePercent=100.000000)
    SpawnableObjects(3)=(SpawnClass=Class'EchelonEffect.EGlasseScreen',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(4)=(SpawnClass=Class'EchelonEffect.ElightDarkSmoke',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(5)=(SpawnClass=Class'EchelonEffect.EExplosionComputer',SpawnOffset=(Z=17.000000),SpawnAtDamagePercent=100.000000)
    HitSound(0)=Sound'DestroyableObjet.Play_ScreenDestroyed'
    StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_CompSonyLcd'
    CollisionPrimitive=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_compsonyLCD_col'
    bStaticMeshCylColl=false
    bCPBlockPlayers=true
}