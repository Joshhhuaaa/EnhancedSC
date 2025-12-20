class Projector extends Actor
	placeable
	native;

#exec Texture Import File=Textures\Proj_IconMasked.pcx Name=Proj_Icon Mips=Off MASKED=1

// Projector blending operation.

enum EProjectorBlending
{
	PB_None,
	PB_Modulate,
	PB_AlphaBlend,
	PB_Add,
    PB_Darken
};

var() EProjectorBlending	MaterialBlendingOp,		// The blending operation between the material being projected onto and ProjTexture.
							FrameBufferBlendingOp;	// The blending operation between the framebuffer and the result of the base material blend.

// public properties
var() Material	ProjTexture;
var() Material  ProjShadowTexture;
var	  Material	ProjOnBSPTex;
var   Material	ProjOnActorTex;
var   Material	ProjOnStaticMeshTex;
var(ShadowProjector) byte		SPSpotTextureIntensity;
var(ShadowProjector) byte		SPShadowIntensity;
var(ShadowProjector) byte		SPShadowBlurFactor;
var(ShadowProjector) byte		SPShadowTextureIntensity;
var() int		FOV;
var() int		MaxTraceDistance;
var() bool		bProjectCrossZone;
var() bool		bProjectBSP;
var() bool		bProjectTerrain;
var() bool		bProjectStaticMesh;
var() bool		bProjectActor;
var() bool		bLevelStatic;
var() bool		bClipBSP;
var() bool		bProjectOnUnlit;
var(ShadowProjector) bool bProjectorType2;
var() name		ProjectTag;
var() bool		bGradient;
var() Texture	GradientTexture;
var() bool		bProjectOnAlpha;
var() bool		bProjectOnParallelBSP;

var   int		DistanceToNearestStaticMesh;
var   bool		HashTableInitialized;

var(ShadowProjector) bool DisableDistanceCheck;

var const transient plane FrustumPlanes[6];
var const transient vector FrustumVertices[8];
var const transient vector LastPos;
var const transient rotator LastRot;
var const transient Box Box;
var const transient ProjectorRenderInfo RenderInfo;
var transient Matrix GradientMatrix;
var transient Matrix	SubTexMatrix;
var transient Matrix Matrix;
var transient Vector OldLocation;
var	transient Array<INT> NodeList;
var	transient Array<INT> StaticMeshList;

var bool				Invert;
var bool				IsMoved;
var	int					DecalX;
var	int					DecalY;
var	int					DecalWidth;
var	int					DecalHeight;
var int					InCurrentCamera;
var	float				DecalScale;

// functions
native function AttachProjector();
native function DetachProjector(optional bool Force);
native function AbandonProjector(optional float Lifetime);

native function AttachActor(Actor A);
native function DetachActor(Actor A);

event PostBeginPlay()
{
	AttachProjector();
	if (bLevelStatic)
	{
		AbandonProjector();
		Destroy();
	}
	if (bProjectActor)
	{
		SetCollision(True, False, False);
		// GotoState('ProjectActors');  //FIXME - state doesn't exist
	}
}

event Touch(Actor Other)
{
	//if (Other.bAcceptsProjectors && (ProjectTag == '' || Other.Tag == ProjectTag))
		AttachActor(Other);
}
event Untouch(Actor Other)
{
	DetachActor(Other);
}

defaultproperties
{
    SPShadowIntensity=84
    SPShadowBlurFactor=252
    MaxTraceDistance=1000
    bProjectBSP=True
    bProjectTerrain=True
    bProjectStaticMesh=True
    DistanceToNearestStaticMesh=1000000
    DisableDistanceCheck=True
    bHidden=True
    Texture=Texture'Proj_Icon'
    bIsProjector=True
    bDirectional=True
}