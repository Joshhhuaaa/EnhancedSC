class TerrainInfo extends Info
	noexport
	showcategories(Movement,Collision,Lighting,LightColor,Force)
	native
	placeable;

#exec Texture Import File=Textures\Terrain_info.pcx Name=S_TerrainInfo Mips=Off MASKED=1 NOCONSOLE
#exec Texture Import File=Textures\S_WhiteCircle.pcx Name=S_WhiteCircle Mips=Off MASKED=1 NOCONSOLE
#exec Texture Import File=Textures\Bad.pcx Name=TerrainBad Mips=Off NOCONSOLE
#exec Texture Import File=Textures\DecoPaint.pcx Name=DecoPaint Mips=Off NOCONSOLE

struct NormalPair
{
	var vector Normal1;
	var vector Normal2;
};

enum ETexMapAxis
{
	TEXMAPAXIS_XY,
	TEXMAPAXIS_XZ,
	TEXMAPAXIS_YZ,
};

enum ESortOrder
{
	SORT_NoSort,
	SORT_BackToFront,
	SORT_FrontToBack
};

struct TerrainLayer
{
	var() Texture	Texture;
	var() Texture	AlphaMap;
	var() float		UScale;
	var() float		VScale;
	var() float		UPan;
	var() float		VPan;
	var() ETexMapAxis TextureMapAxis;
	var() float		TextureRotation;
	var() Rotator	LayerRotation;
};

struct DecorationLayer
{
	var() int			ShowOnTerrain;
	var() Texture		ScaleMap;
	var() Texture		DensityMap;
	var() Texture		ColorMap;
	var() StaticMesh	StaticMesh;
	var() rangevector	ScaleMultiplier;
	var() range			FadeoutRadius;
	var() range			DensityMultiplier;
	var() int			MaxPerQuad;
	var() int			Seed;
	var() int			AlignToTerrain;
	var() ESortOrder	DrawOrder;
	var() int			ShowOnInvisibleTerrain;
};


struct DecoInfo
{
	var vector	Location;
	var rotator	Rotation;
	var vector	Scale;
	var vector	TempScale;
	var color	Color;
	var int		Distance;
};

struct DecoSectorInfo
{
	var array<DecoInfo>	DecoInfo;
	var vector			Location;
	var float			Radius;
};

struct DecorationLayerData
{
	var array<DecoSectorInfo> Sectors;
};


var() Texture					TerrainMap;
var() vector					TerrainScale;
var() TerrainLayer				Layers[32];
var() array<DecorationLayer>	DecoLayers;
var() bool						Inverted;

var	native const array<DecorationLayerData> DecoLayerData;
var native const array<TerrainSector>	Sectors;
var native const array<vector> Vertices;
var native const int HeightmapX;
var native const int HeightmapY;
var native const int SectorsX;
var native const int SectorsY;
var native const TerrainPrimitive Primitive;
var native const array<NormalPair> FaceNormals;
var native const vector ToWorld[4];
var native const vector ToHeightmap[4];
var native const array<int>	SelectedVertices;
var native const int ShowGrid;
var const array<int> QuadVisibilityBitmap;
var const array<int> EdgeTurnBitmap;

// OLD
var native const Texture OldTerrainMap;
var native const array<byte> OldHeightmap;

defaultproperties
{
    TerrainScale=(X=64.000000,Y=64.000000,Z=64.000000)
    bStatic=True
    bWorldGeometry=True
    Texture=Texture'S_TerrainInfo'
    bStaticLighting=True
}