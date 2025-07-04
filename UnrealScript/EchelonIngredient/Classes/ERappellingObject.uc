class ERappellingObject extends EGameplayObject;

var()	float			RappellingHeight;
var		ERapelRopeActor	Rope;

defaultproperties
{
    RappellingHeight=2000.000000
    bDamageable=false
    StaticMesh=StaticMesh'EMeshIngredient.Object.VentExit'
    DrawScale=0.500000
    CollisionRadius=13.000000
    CollisionHeight=37.000000
    bBlockPlayers=true
    bBlockActors=true
    InteractionClass=Class'ERappellingInteraction'
    bDirectional=true
}