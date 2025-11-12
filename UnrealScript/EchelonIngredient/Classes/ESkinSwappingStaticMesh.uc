class ESkinSwappingStaticMesh extends StaticMeshActor;

#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx 

function Tick(float DeltaTime)
{
	local Material temp;
	
	temp = Skins[0];
	Skins[0] = Skins[1];
	Skins[1] = temp;
}

defaultproperties
{
    bStatic=false
    StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_aquarium'
    CollisionRadius=64.000000
    CollisionHeight=32.000000
}