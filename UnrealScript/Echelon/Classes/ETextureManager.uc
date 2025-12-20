class ETextureManager extends Actor
	abstract native;
/******************************************************************************
 
 Class:         ETextureManager

 Description:   -

 Reference:     -


******************************************************************************/

/*-----------------------------------------------------------------------------
                               E X E C ' S
-----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
                      T Y P E   D E F I N I T I O N S 
-----------------------------------------------------------------------------*/
struct EPos
{
	var float	X;
	var float	Y;
};

struct ETextureInfo
{
	var string	TextureName;
	var Texture	TextureOwner;
	var EPos	Origin;
	var EPos	Size;
};

/*-----------------------------------------------------------------------------
                   I N S T A N C E   V A R I A B L E S
-----------------------------------------------------------------------------*/
var() array<ETextureInfo> ArrayTexture;
var int pixel;

/*-----------------------------------------------------------------------------
                               C O D E 
-----------------------------------------------------------------------------*/

native(1305) final function DrawTileFromManager(ECanvas Canvas, int TextureIndex, float XL, float YL, float U, float V, float UL, float VL);
native(1306) final function GetTextureInfo(int TextureIndex, out Texture TexOwner, out float OriginX, out float OriginY, out float XL, out float YL);
native(1307) final function int GetWidth(int TextureIndex);
native(1308) final function int GetHeight(int TextureIndex);
native(1309) final function int GetOriginX(int TextureIndex);
native(1310) final function int GetOriginY(int TextureIndex);

/*-----------------------------------------------------------------------------
                       D E F A U L T   P R O P E R T I E S
-----------------------------------------------------------------------------*/

defaultproperties
{
    bHidden=True
}