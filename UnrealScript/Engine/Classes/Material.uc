//=============================================================================
// Material: Abstract material class
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Material extends Object
	native
	editinlinenew
	hidecategories(Object)
	collapsecategories
	noexport;

#exec Texture Import File=Textures\DefaultTexture.pcx

var() editinlineuse Material FallbackMaterial;
var Texture EditorIcon;

var transient Object EditorLayout;
// ***********************************************************************************************
// * BEGIN UBI MODIF dchabot (4 f?vr. 2002)
// ***********************************************************************************************
var() ESurfaceType SurfaceType;
var() int		   bClimbable;
var() int		   bNoSplitJump;
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************

// ***********************************************************************************************
// * BEGIN UBI MODIF hallaire (31 mai 2002)
// ***********************************************************************************************
var(FootStep) bool bLeaveFootStep;
// ***********************************************************************************************
// * END UBI MODIF
// ***********************************************************************************************

var(Heat) bool bUseTextureAsHeat;
var(Heat) editinlineuse Material HeatMaterial;

defaultproperties
{
    FallbackMaterial=Texture'DefaultTexture'
}