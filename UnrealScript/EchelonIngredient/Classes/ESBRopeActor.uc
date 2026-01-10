class ESBRopeActor extends ESoftBodyActor native placeable;

#exec OBJ LOAD FILE=..\textures\ETexIngredient.utx

var(SBRope) float		scaleU;
var(SBRope) float		lengthV;
var(SBRope) int			nbSeg;
var(SBRope) float		Length;
var(SBRope) float		Radius;
var			int			prevNbSeg;
var			float		prevLength;

defaultproperties
{
    scaleU=2.000000
    lengthV=2.000000
    nbSeg=10
    Length=10.000000
    Radius=0.750000
    prevNbSeg=10
    prevLength=10.000000
    windMin=(X=-50.000000,Y=-50.000000,Z=0.000000)
    windMax=(X=50.000000,Y=50.000000,Z=0.000000)
    windUScale=0.500000
    windVScale=0.500000
    windUPan=0.200000
    windVPan=0.110000
    nbNormalizeIter=8
    pillsTest=True
    Texture=Texture'ETexIngredient.Object.Rope'
    CollisionRadius=2.000000
}