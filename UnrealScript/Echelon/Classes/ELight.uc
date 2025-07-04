class ELight extends Light
	native;

#exec OBJ LOAD FILE=..\textures\ETexRenderer.utx 
#exec OBJ LOAD FILE=..\StaticMeshes\LightGenOBJ.usx

var ELightType	InitialLightType;
var byte		InitialLightBrightness;
var	bool		InitialUsesBeam;
var float		LastTimeChange;
var int			NbControllers;

function PreBeginPlay()
{
	Super.PreBeginPlay();

	InitialLightType		= LightType;
	InitialLightBrightness	= LightBrightness;
	InitialUsesBeam			= UsesSpotLightBeam;
}

//------------------------------------------------------------------------
// Description		
//		If go gets to be a controller, he will shut down light percent 
//------------------------------------------------------------------------
function SetController( EGameplayObject obj )
{
	SetOwner(obj);
	NbControllers++;
	//Log(self$" SetController"$obj@NbControllers);
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

//------------------------------------------------------------------------
// Description		
//		If we explicitely want to turn lights on/off
//------------------------------------------------------------------------
function TurnOn(optional EChangeType _Type, optional Pawn EventInstigator)
{ 
	if( LightBrightness != InitialLightBrightness && NbControllers > 1 )
	{
		LightBrightness		= Min(LightBrightness+InitialLightBrightness/NbControllers, InitialLightBrightness);
		UsesSpotLightBeam	= InitialUsesBeam;
		LastTimeChange		= Level.TimeSeconds;
	}
	if( LightType != InitialLightType && DisableIfOppositeShadowMode == false)
	{
		LightType = InitialLightType;
		LastTimeChange	= Level.TimeSeconds;
	}

    // Then add us again if we were initially off
	if((Owner.IsA('ESwitchObject')) && (Owner.InitialState == 's_Off') && (EventInstigator.bIsPlayerPawn))
    {
		Level.AddChange(self, _Type);
    }

    //log("Turning on"@self@lightbrightness@LightType);
	RestoreInitialLightType=true;
	if(Level.Game.PlayerC != None)
		Level.Game.PlayerC.LightmapTextureCache = 1;
}

//------------------------------------------------------------------------
// Description		
//		If we explicitely want to turn lights on/off
//------------------------------------------------------------------------
function TurnOff(EChangeType _Type, optional Pawn EventInstigator  )
{
	//Log(self@LightBrightness@InitialLightBrightness@InitialLightBrightness/NbControllers@LightBrightness-InitialLightBrightness/NbControllers);
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

	//Log(self$" Turned off"@LightBrightness@LightType);

	Instigator = EventInstigator;
	if( Owner.IsA('ESwitchObject') )
 		Level.AddChange(self, _Type);

	if( _Type == CHANGE_LightShotOut && Nbcontrollers <= 1 )
		GotoState('s_Destrocuted');

	RestoreInitialLightType=false;
	if(Level.Game.PlayerC != None)
		Level.Game.PlayerC.LightmapTextureCache = 1;
}

state s_Destrocuted
{
	Ignores Trigger, TurnOn, TurnOff;
}

defaultproperties
{
    bStatic=false
    VolumeLightMesh=StaticMesh'LightGenOBJ.LightCubebeam.lightcubebeamB'
    SpotProjectedMaterial=ELightBeamMaterial'ETexRenderer.Dev.SpotLightBeam_Default'
    bIsEchelonLight=true
}