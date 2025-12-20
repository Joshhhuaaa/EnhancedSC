class FinalBlend extends Modifier
	native;

enum EFrameBufferBlending
{
	FB_Overwrite,
	FB_Modulate,
	FB_AlphaBlend,
	FB_AlphaModulate_MightNotFogCorrectly,
	FB_Translucent,
	FB_Darken,
	FB_Brighten,
	FB_Invisible,
};

var() EFrameBufferBlending FrameBufferBlending;
var() bool ZWrite;
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * yletourneau (28 Nov 2001)
// * Purpose : <Unspecified>
// ***********************************************************************************************
enum EZTest
{
	ZT_None,
	ZT_LessEqual,
	ZT_Equal
};

var() EZTest ZTest;
// ***********************************************************************************************
// * END UBI MODIF 
// * yletourneau (28 Nov 2001)
// ***********************************************************************************************
var() bool AlphaTest;
var() bool TwoSided;
var() byte AlphaRef;

defaultproperties
{
    ZWrite=True
    ZTest=ZT_LessEqual
}