class EUS_exit extends EGameplayObjectLight; 

defaultproperties
{
    bDestroyWhenDestructed=False
    HitPoints=60
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_exitBRK')
    SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.Eexit_piece')
    StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_exitON'
    LightType=LT_Steady
    LightBrightness=255
    LightRadius=3
}