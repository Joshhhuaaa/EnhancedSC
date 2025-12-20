class EChair extends EGameplayObject;

var()			bool				bTableChair;
var()			bool				bBed;

function BaseChange();

defaultproperties
{
    bTableChair=True
    bDamageable=False
    StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_WheelChair'
    CollisionRadius=25.000000
    CollisionHeight=30.000000
    bCollideWorld=True
    bBlockPlayers=True
    bBlockActors=True
    InteractionClass=Class'EChairInteraction'
    bPathColliding=True
}