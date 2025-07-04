class TexEnvMap extends TexModifier
	editinlinenew
	native;

var() enum ETexEnvMapType
{
	EM_WorldSpace,
	EM_CameraSpace,
} EnvMapType;

defaultproperties
{
    EnvMapType=EM_CameraSpace
    TexCoordCount=TCN_3DCoords
}