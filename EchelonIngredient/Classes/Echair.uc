class EChair extends EGameplayObject;

var()			bool				bTableChair;
var()			bool				bBed;

function BaseChange();

defaultproperties
{
    bTableChair=true
    bDamageable=false
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_WheelChair'
    CollisionRadius=25.0000000
    CollisionHeight=30.0000000
    bCollideWorld=true
    bBlockPlayers=true
    bBlockActors=true
    InteractionClass=Class'EChairInteraction'
    bPathColliding=true
}