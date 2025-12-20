class ERopeActor extends Actor native;

var ERope Rope;
var float Radius;
var float scaleU;
var float lengthV;
var int   nbSeg;

defaultproperties
{
    bUnlit=True
    CollisionRadius=0.000000
    CollisionHeight=0.000000
    bIsRope=True
    bIsTouchable=False
    bIsNPCRelevant=False
    bIsPlayerRelevant=False
    bRenderLast=True
}