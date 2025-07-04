class EGlow extends Modifier
	native
	editinlinenew;

var() Material	GlowMaterial;
var() Color		GlowColorScale;
var() bool      bUnlit;

defaultproperties
{
    GlowColorScale=(R=255,G=255,B=255,A=255)
    bUnlit=true
}