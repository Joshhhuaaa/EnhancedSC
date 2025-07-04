//=============================================================================
// Canvas: A drawing canvas.
// This is a built-in Unreal class and it shouldn't be modified.
//
// Notes.
//   To determine size of a drawable object, set Style to STY_None,
//   remember CurX, draw the thing, then inspect CurX and CurYL.
//=============================================================================
class Canvas extends Object
	native
	noexport;

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * fschelling (23 mar 2002)
// ***********************************************************************************************
#exec Font IMPORT NAME=ETextFont        FILE="..\Textures\Font\txt_integration.pcx"
#exec Font IMPORT NAME=ETitleFont       FILE="..\Textures\Font\titre_regular_integration.pcx"
#exec Font IMPORT NAME=ETitleBoldFont   FILE="..\Textures\Font\titre_bold_integration.pcx"
#exec Font IMPORT NAME=EHUDFont         FILE="..\Textures\Font\txt_hud.pcx"
//#exec new TrueTypeFontFactory Name=Verdana FontName="Arial Unicode MS" Height=12 AntiAlias=1  CharactersPerPage=128 Path=g:\temp\ttt Wildcard=*.kor
#exec new TrueTypeFontFactory Name=Verdana FontName="Verdana" Height=12 AntiAlias=1 CharactersPerPage=64
#exec Font IMPORT NAME=EMissionFont     FILE="..\Textures\Font\txt_mission.pcx"

var Font ETextFont, ETitleFont, ETitleBoldFont, EHUDFont, Verdana, EMissionFont;
var bool bDrawTile;
// ***********************************************************************************************
// * END UBI MODIF 
// * fschelling (23 mar 2002)
// ***********************************************************************************************

// Modifiable properties.
var font    Font;            // Font for DrawText.
var float   SpaceX, SpaceY;  // Spacing for after Draw*.
var float   OrgX, OrgY;      // Origin for drawing.
var float   ClipX, ClipY;    // Bottom right clipping region.
var float   CurX, CurY;      // Current position for drawing.
var float   Z;               // Z location. 1=no screenflash, 2=yes screenflash.
var byte    Style;           // Drawing style STY_None means don't draw.
var float   CurYL;           // Largest Y size since DrawText.
var color   DrawColor;       // Color for drawing.
var bool    bCenter;         // Whether to center the text.
var bool    bNoSmooth;       // Don't bilinear filter.
var const int SizeX, SizeY;  // Zero-based actual dimensions.

// Stock fonts.
var font SmallFont;          // Small system font.
var font MedFont;           // Medium system font.

// Internal.
var const viewport Viewport;        // Viewport that owns the canvas.
var const int  padding_canvas;      // canvas.

// Bink video playback data.
var INT     m_hBink;
var BOOL    m_bPlaying;
var INT     m_iPosX;
var INT     m_iPosY;
var bool	m_bLoopVideo;
var int     m_bLoopAtLastFrame;
//clauzon texture rendering:
var transient Texture m_PlaybackTexture;
var transient Texture m_FullTexture1;
var transient Texture m_FullTexture2; 
var transient Texture m_CinematicTexture;

var INT		m_iVidWidth;
var INT		m_iVidHeight;
var INT		m_bPlayFullScreen;
var INT		m_bRequestVideoPlay;
var INT		m_bRequestVideoStop;
var string	m_VideoName;

// native functions.
native(464) final function StrLen( coerce string String, out float XL, out float YL );
native(465) final function DrawText( coerce string Text, optional bool CR);
native(466) final function DrawTile( material Mat, float XL, float YL, float U, float V, float UL, float VL );
native(467) final function DrawActor( Actor A, bool WireFrame, optional bool ClearZ, optional float DisplayFOV );
native(468) final function DrawTileClipped( Material Mat, float XL, float YL, float U, float V, float UL, float VL );
native(469) final function DrawTextClipped( coerce string Text, optional bool bCheckHotKey );

// ***********************************************************************************************
// * BEGIN UBI MODIF Adionne (29 Oct 2002)
// ***********************************************************************************************

//native(470) final function TextSize( coerce string String, out float XL, out float YL );
native(470) final function string TextSize( coerce string String, out float XL, out float YL , optional INT TotalWidth, optional INT SpaceWidth);
// ***********************************************************************************************
// * END UBI MODIF 
// ***********************************************************************************************




native(480) final function DrawPortal( int X, int Y, int Width, int Height, actor CamActor, vector CamLocation, rotator CamRotation, optional int FOV, optional bool ClearZ );

// get the good native functions ID
native(481) final function VideoOpen(string Name, INT bDisplayDoubleSize, bool StopSound, optional bool bSurround );
native(482) final function VideoClose();
native(483) final function VideoPlay(INT iPosX, INT iPosY, INT bCentered);
native(484) final function VideoStop();
native(485) final function VideoGotoFrame( int iFrame );


// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * fschelling (19 mar 2002)
// * Purpose : 
// ***********************************************************************************************
native(1312) final function SetPos( float X, float Y );
native(1313) final function SetOrigin( float X, float Y );
native(1314) final function SetClip( float X, float Y );
native(1315) final function SetDrawColor(byte R, byte G, byte B, optional byte A);
// ***********************************************************************************************
// * END UBI MODIF 
// * fschelling (19 mar 2002)
// ***********************************************************************************************

function RequestVideoPlay(string VideoName)
{
	m_bRequestVideoPlay = 1;
	m_VideoName = VideoName;
}

function RequestVideoStop()
{
	m_bRequestVideoStop = 1;
}

// Hard coded values for Credits and Intro videos...
event CheckVideoRequest()
{
	if(m_bRequestVideoPlay != 0 && m_VideoName != "")
	{
		VideoOpen(m_VideoName, 0, true, true);
		VideoPlay(0, 0, 1);		
		m_bRequestVideoPlay = 0;
	}
	else if(m_bRequestVideoStop != 0)
	{
		VideoStop();
		m_bRequestVideoStop = 0;
	}
}

//clauzon, small utility to display the video texture on the screen.
event DisplayVideo(INT iPosX, INT iPosY, INT width, INT height)
{
	SetPos(iPosX,iPosY);
	DrawTile(m_PlaybackTexture, width, height, 0, 0, m_iVidWidth, m_iVidHeight);
}

//clauzon, to display full screen video using textures
event DisplayFullScreenVideo()
{
	local int videoPosY;
	videoPosY =  240 - (m_iVidHeight / 2);

	if(m_FullTexture1!=none && m_FullTexture2!=none)
	{
		//Draw the black stripes:
		SetPos(0,0);
		DrawTile(m_CinematicTexture,  640, 480, 0, 0, 16, 16);

		//Draw the video:
		SetPos(0 ,videoPosY);
		DrawTile(m_FullTexture1,  512, m_iVidHeight, 0, 0, 512, m_iVidHeight);

		SetPos(512 ,videoPosY);
		DrawTile(m_FullTexture2,  128, m_iVidHeight, 0, 0, 128, m_iVidHeight);	
	}
}


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

final function DrawPattern( texture Tex, float XL, float YL, float Scale )
{
	DrawTile( Tex, XL, YL, (CurX-OrgX)*Scale, (CurY-OrgY)*Scale, XL*Scale, YL*Scale );
}
final function DrawIcon( texture Tex, float Scale )
{
	if ( Tex != None )
		DrawTile( Tex, Tex.USize*Scale, Tex.VSize*Scale, 0, 0, Tex.USize, Tex.VSize );
}
final function DrawRect( texture Tex, float RectX, float RectY )
{
	DrawTile( Tex, RectX, RectY, 0, 0, Tex.USize, Tex.VSize );
}

static final function Color MakeColor(byte R, byte G, byte B, optional byte A)
{
	local Color C;
	
	C.R = R;
	C.G = G;
	C.B = B;
	if ( A == 0 )
		A = 255;
	C.A = A;
	return C;
}

defaultproperties
{
    ETextFont=Font'ETextFont'
    ETitleFont=Font'ETitleFont'
    ETitleBoldFont=Font'ETitleBoldFont'
    EHUDFont=Font'EHUDFont'
    Verdana=Font'Verdana'
    EMissionFont=Font'EMissionFont'
    bDrawTile=true
    Z=1.000000
    Style=1 // Joshua - Canvas.Style is a byte, not a proper ERenderStyle enum
    DrawColor=(R=127,G=127,B=127,A=255)
    SmallFont=Font'SmallFont'
    MedFont=Font'MediumFont'
}