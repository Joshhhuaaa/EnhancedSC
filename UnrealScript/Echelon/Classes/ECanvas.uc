class ECanvas extends Canvas 
	config // Joshua - Allowing SplinterCell.ini to change fonts
	native
	noexport;

const E_CLEAR_NONE = 0;
const E_CLEAR_CBUFFER = 1;
const E_CLEAR_ZBUFFER = 2;
const E_CLEAR_STENCIL = 4;
const E_CLEAR_ALL = 7;

enum EPortalTextureEffect
{
	E_None,
	E_Fuzzy_Anim,
	E_Fish_Eye_Lens,
};
enum EPortalTarget
{    
	CBUFFER,
	TEX_0,	
};

enum ETextAligned
{
    TXT_LEFT,
    TXT_RIGHT,
    TXT_CENTER
};

var color black;
var color white;
var color TextBlack;
var color TextGreen;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var Font ETextFontXbox; // Joshua - Xbox font support
var Font ETextFontGameCube; // Joshua - GameCube font support
var Font ETextFontPS2; // Joshua - PS2 font to be able to access the button icons

native(3000) final function BeginScene(int X, int Y, int Width, int Height,float RWidth, float RHeight, optional int ClearFlags);
native(3001) final function DrawPlayerPortal(PlayerController Player, optional int ClearFlags ,optional float blur_coef);
native(3002) final function DrawCameraPortal(vector CamLocation, rotator CamRotation, optional float FOV, optional int ClearFlags,optional float blur_coef);
native(3003) final function DrawScaleText(coerce string Text, float Scale, optional bool CR);
//native(3004) final function DrawTextZone(coerce string Text, float Scale, int Line1, int Line2, optional bool CR);
native(3005) final function SetRenderState(int State, bool Value);
native(3006) final function DrawActorPortal(actor Actor, vector CamLocation, rotator CamRotation, optional int FOV, optional int ClearFlags, optional bool WireFrame);
native(3007) final function CreateDepthMask(int X, int Y, int Width, int Height, texture clear_mask, byte alpha_ref, bool inv); 
native(3008) final function SetRenderTarget(EPortalTarget handle);
native(3009) final function DrawPortalTexture(EPortalTarget handle,int X, int Y, int Width,int Height, optional EPortalTextureEffect effect, optional float Anim);
native(1508) final function Draw3DLine(vector Start, vector End, optional Color DrawColor);
native(3013) final function int     GetNbStringLines(string Text, optional float scale);
native(3011) final function int     ViewportSizeX();
native(3012) final function int     ViewportSizeY();
native(1301) final function string  GetStringAtPos(string Text, int Pos, /*out int OldTextPos, */optional float scale);
native(1304) final function DrawLine(int x, int y, int width, int height, Color c, int alpha, ETextureManager t);
native(1311) final function DrawRectangle(int x, int y, int width, int height, int lineWidth, Color c, int alpha, ETextureManager t);
native(1319) final function DrawTextAligned(string szText, optional ETextAligned a, optional float scaleX, optional float scaleY);
native(1320) final function string LocalizeStr(string key);

// UnrealScript functions.
event Reset()
{
	Font        = Default.Font;
	SpaceX      = Default.SpaceX;
	SpaceY      = Default.SpaceY;
	OrgX        = Default.OrgX;
	OrgY        = Default.OrgY;
	CurX        = Default.CurX;
	CurY        = Default.CurY;
	Style       = Default.Style;
	DrawColor   = Default.DrawColor;
	CurYL       = Default.CurYL;
	bCenter     = false;
	bNoSmooth   = false;
	Z           = 1.0;
}

/*-----------------------------------------------------------------------------
     Function:      DrawTextRightAligned

     Description:   -
-----------------------------------------------------------------------------*/
function DrawTextRightAligned(String strText)
{
    local float fTextSizeX;
    local float fTextSizeY;
    
    // Calculate Text Size
    TextSize(strText, fTextSizeX, fTextSizeY);

    SetPos(CurX - fTextSizeX, CurY);

    DrawText(strText);
}

defaultproperties
{
    Black=(R=0,G=0,B=0,A=255)
    White=(R=255,G=255,B=255,A=255)
    TextBlack=(R=51,G=51,B=51,A=255)
    TextGreen=(R=77,G=77,B=77,A=255)
    MedFont=Font'Engine.SmallFont'
	//=============================================================================
	// Enhanced Variables
	//=============================================================================
	ETextFontXbox=Font'Engine.ETextFontXbox' // Joshua - Xbox font support
	ETextFontGameCube=Font'Engine.ETextFontGameCube' // Joshua - GameCube font support
	ETextFontPS2=Font'Engine.ETextFontPS2' // Joshua - PS2 font to be able to access the button icons
}