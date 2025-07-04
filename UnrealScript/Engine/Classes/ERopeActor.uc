class ERopeActor extends Actor native;

var ERope Rope;
var float Radius;
var float scaleU;
var float lengthV;
var int   nbSeg;

defaultproperties
{
    bUnlit=true
    CollisionRadius=0.000000
    CollisionHeight=0.000000
    bIsRope=true
    bIsTouchable=false
    bIsNPCRelevant=false
    bIsPlayerRelevant=false
    bRenderLast=true
}