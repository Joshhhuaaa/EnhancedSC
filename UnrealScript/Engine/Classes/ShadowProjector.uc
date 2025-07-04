//=============================================================================
// ShadowProjector.
//=============================================================================
class ShadowProjector extends Projector
	placeable
	native;

var ShadowBitmapMaterial	ShadowTexture;
var ShadowBitmapMaterial	ShadowTextOnActor;
var ShadowBitmapMaterial	ShadowTextOnStaticMesh;
var() array<name>	SPMustHaveStaticMeshList;
var() array<name>	SPMustHaveZoneInfoList;

// JFP: We may not require the following variables.
var byte					InitialLightBrightness;
var() byte					SPSpotHeight;
var() byte					SPSpotWidth;
var int						NbControllers;
var ELightType				InitialLightType;
var	bool					InitialUsesBeam;
var() bool					bProjectorEnable;
var() bool					bTreatAsStatic;
var() bool					bUseModulate2X;
var() bool					bUseStaticMeshListOnly;
var() bool					bDontUseEdgeColor;
var	  bool					ProjVisible;
var float					LastTimeChange;
var bool					CacheInvalidate;
var bool					ClipProjector;
var() int					AdjustNearestStaticMeshOffset;
var() int					FadeOutOffset;
var() float					ActorDisplayFarDistance;
var bool					Initialized;
var float					SquareOffsetDistanceNear;
var float					SquareOffsetDistanceFar;
var() bool					bEnableFadeOut;
//
//	PostBeginPlay
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	ShadowTexture = new class'ShadowBitmapMaterial';
	ShadowTexture.SpotTexture = ProjTexture;
	ShadowTexture.proj = self;
	ProjOnBSPTex   = ShadowTexture;
	ShadowTexture.bFirstFrame = true;	

	ShadowTextOnActor = new class'ShadowBitmapMaterial';
	ShadowTextOnActor.SpotTexture = ProjTexture;
	ShadowTextOnActor.proj = self;
	ProjOnActorTex   = ShadowTextOnActor;
	ShadowTextOnActor.bFirstFrame = true;

	ShadowTextOnStaticMesh = new class'ShadowBitmapMaterial';
	ShadowTextOnStaticMesh.SpotTexture = ProjTexture;
	ShadowTextOnStaticMesh.proj = self;
	ProjOnStaticMeshTex = ShadowTextOnStaticMesh;
	ShadowTextOnStaticMesh.bFirstFrame = true;

	if (bTreatAsStatic == false)
	{
  		bIsEchelonLight=false;
	}
}

//
//	UpdateShadow
//
function UpdateShadow()
{
    local vector	ShadowLocation;
    local Plane	    BoundingSphere;

    DetachProjector(true);
    
    //if(bProjectActor)
    //{
    //    SetCollision(false, false, false);
    //}

    ShadowTexture.Dirty				= true;
	ShadowTextOnActor.Dirty			= true;
	ShadowTextOnStaticMesh.Dirty	= true;

    AttachProjector();

    //if(bProjectActor)
    //{
    //    SetCollision(true, false, false);
    //}
}


//
//	Tick
//
function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

	// JFP: Do NOT call the UpdateShadow function when in shadow buffer mode, only for the projector mode.
	// 0 == shadow projector mode, 1 == shadow buffer mode
	if(Level.Game.PlayerC != None && Level.Game.PlayerC.ShadowMode == 0 )
	{
	    UpdateShadow();
	}
}


//
//	Touch
//
event Touch(Actor Other)
{
   if(Pawn(Other) == None)
   {
		AttachActor(Other);
   }
}


// JFP: Added for the projector trigger processing, when lights are shot or turned off.
//------------------------------------------------------------------------
// Description		
//		If we explicitely want to turn lights on/off
//------------------------------------------------------------------------
function TurnOff(EChangeType _Type, optional Pawn EventInstigator  )
{
	//Log(self@LightBrightness@InitialLightBrightness@InitialLightBrightness/NbControllers@LightBrightness-InitialLightBrightness/NbControllers);
	/*
	if( NbControllers > 1 && LightBrightness-InitialLightBrightness/NbControllers > 0 )
	{
		LightBrightness		= LightBrightness-InitialLightBrightness/NbControllers;
		LastTimeChange		= Level.TimeSeconds;
	}
	else if( LightType != LT_None )
	{
		LightType = LT_None;
		LastTimeChange	= Level.TimeSeconds;
	}

	UsesSpotLightBeam	= false;

	Instigator = EventInstigator;
	if( Owner.IsA('ESwitchObject') )
 		Level.AddChange(self, _Type);

	if( _Type == CHANGE_LightShotOut && Nbcontrollers <= 1 )	
		GotoState('s_Destrocuted');
	*/
	Log("Shadow projector: " $ self $" Turned OFF, owner is " $ owner $ ", nbControllers==" $ Nbcontrollers );

	InitialLightType = LightType;
	LightType = LT_None;
	LastTimeChange	= Level.TimeSeconds;
	RestoreInitialLightType=false;

	bProjectorEnable=false;
	if(Level.Game.PlayerC != None)
		Level.Game.PlayerC.LightmapTextureCache = 1;

	if( _Type == CHANGE_LightShotOut )
		GotoState('s_Destrocuted');
}

//------------------------------------------------------------------------
// Description		
//		If we explicitely want to turn lights on/off
//------------------------------------------------------------------------
function TurnOn(optional EChangeType _Type, optional Pawn EventInstigator)
{ 
	/*
	if( LightBrightness != InitialLightBrightness && NbControllers > 1 )
	{
		LightBrightness		= Min(LightBrightness+InitialLightBrightness/NbControllers, InitialLightBrightness);
		UsesSpotLightBeam	= InitialUsesBeam;
		LastTimeChange		= Level.TimeSeconds;
	}
	if( LightType != InitialLightType )
	{
		LightType = InitialLightType;
		LastTimeChange	= Level.TimeSeconds;
	}

    // Then add us again if we were initially off
	if((Owner.IsA('ESwitchObject')) && (Owner.InitialState == 's_Off') && (EventInstigator.bIsPlayerPawn))
    {
		Level.AddChange(self, _Type);
    }
	*/
    Log("Shadow projector: " $ self $" Turned ON, owner is " $ owner $ ", nbControllers==" $ Nbcontrollers $ ", going back to initial light type " $ InitialLightType );
	if (DisableIfOppositeShadowMode == false)
	{
		LightType = InitialLightType;
		LastTimeChange	= Level.TimeSeconds;
		bProjectorEnable=true;
	}
	RestoreInitialLightType=true;
	if(Level.Game.PlayerC != None)
		Level.Game.PlayerC.LightmapTextureCache = 1;
}

//------------------------------------------------------------------------
// Description		
//		Turns on and off lights
//------------------------------------------------------------------------
function Trigger( actor Other, pawn EventInstigator, optional name InTag )
{
	//log(self$" gets triggered by "@Other);
	switch( Other.GetStateName() )
	{
	case 's_On' :
		TurnOn(CHANGE_LightTurnedOff, EventInstigator);
		break;

	case 's_Off' :
		TurnOff(CHANGE_LightTurnedOff,EventInstigator);
		break;
	}
}


state s_Destrocuted
{
	Ignores Trigger, TurnOn, TurnOff;
}

// bStatic must be true for appropriate lighting. We might need to do something special for flashlights.
// We can easily derive from ShadowProjector and set the flag not static.

defaultproperties
{
    bProjectorEnable=true
    bTreatAsStatic=true
    bUseModulate2X=true
    MaterialBlendingOp=PB_Modulate
    FrameBufferBlendingOp=PB_Add
    MaxTraceDistance=400
    bIsEchelonLight=true
}