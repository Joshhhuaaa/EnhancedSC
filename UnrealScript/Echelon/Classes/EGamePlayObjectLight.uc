class EGamePlayObjectLight extends EGamePlayObject
	native;

var			StaticMesh	OnMesh;
var()		StaticMesh	OffMesh;

var			ELightType	InitialLightType;
var			bool		InitialUsesBeam;
var			float		DesiredHeatIntensity;

//------------------------------------------------------------------------
// Description		
//
//------------------------------------------------------------------------
function PostBeginPlay()
{
	Super.PostBeginPlay();

	OnMesh			 = StaticMesh;
	InitialLightType = LightType;
	InitialUsesBeam	 = UsesSpotLightBeam;

	DesiredHeatIntensity = HeatIntensity;

	TurnOn();
}

function Tick(float DeltaTime)
{
	if (HeatIntensity == DesiredHeatIntensity)
		return;

	//Log(name$" * * Was["$HeatIntensity$"] to be ["$DesiredHeatIntensity$"]");
	// Adjust progressively HeatIntensity on lights
	if (HeatIntensity > DesiredHeatIntensity)
		HeatIntensity = FMax(DesiredHeatIntensity, HeatIntensity - DeltaTime);
	else
		HeatIntensity = FMin(DesiredHeatIntensity, HeatIntensity + DeltaTime);
	//Log(name$" Is["$HeatIntensity$"] to be ["$DesiredHeatIntensity$"]");
}

//------------------------------------------------------------------------
// Description		
//		Turns on and off lights
//------------------------------------------------------------------------
function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{    
	local name OtherStateName;

	if (!Other.IsA('ESwitchObject'))
		return;

	OtherStateName = Other.GetStateName();
	if (OtherStateName == 's_On' || OtherStateName == 's_Off')
	{
		if (OtherStateName == 's_On')
			TurnOn(CHANGE_LightTurnedOff, EventInstigator);		
		else
			TurnOff(CHANGE_LightTurnedOff, EventInstigator);

		Super.Trigger(Other, EventInstigator, InTag);
	}
	else if (OtherStateName == 's_Destructed')
	{ 
	    TurnOff(CHANGE_LightShotOut, EventInstigator);
	    GotoState('s_Destructed');
	}
	else
	{
		Super.Trigger(Other, EventInstigator, InTag);
	}	
}

//------------------------------------------------------------------------
// Description		
//		Turn off upon pickup
//------------------------------------------------------------------------
function bool NotifyPickup(Controller Instigator)
{
	TurnOff(CHANGE_LightTurnedOff, Instigator.Pawn);
	return Super.NotifyPickup(Instigator);
}

//------------------------------------------------------------------------
// Description		
//		If we explicitely want to turn lights on/off
//------------------------------------------------------------------------
function TurnOn(optional EChangeType _Type, optional pawn EventInstigator)
{
	// Get default maps HeatIntensity
	if (default.HeatIntensity != 0)
		DesiredHeatIntensity = default.HeatIntensity;
	else
		DesiredHeatIntensity = 0.8f;

	bGlowdisplay		= true;
	UsesSpotLightBeam	= InitialUsesBeam;
	
	if (OnMesh != None)
		SetStaticMesh(OnMesh);

	if (LightType != InitialLightType && DisableIfOppositeShadowMode == false)
	{       
		LightType		= InitialLightType;
		LastTimeChange	= Level.TimeSeconds;
	}

	RestoreInitialLightType = true;
	if (Level.Game.PlayerC != None)
		Level.Game.PlayerC.LightmapTextureCache = 1;

    // Take me off list
    RemoveChangedActor();

    // Then add us again if we were initially off
	if ((Owner != None) 
     && (Owner.IsA('ESwitchObject')) 
     && (Owner.InitialState == 's_Off') 
     && (EventInstigator != None) 
     && (EventInstigator.bIsPlayerPawn))
    {    
	    Instigator = EventInstigator;
        Level.AddChange(self, _Type);
    }
}

//------------------------------------------------------------------------
// Description		
//		If we explicitely want to turn lights on/off
//------------------------------------------------------------------------
function TurnOff(EChangeType _Type, optional pawn EventInstigator)
{
	DesiredHeatIntensity = 0;

	bGlowdisplay		= false;
	UsesSpotLightBeam	= false;

	if (OffMesh != None && _Type == CHANGE_LightTurnedOff)
		SetStaticMesh(OffMesh);

	if (LightType != LT_None)
	{
		LightType		= LT_None;				
		LastTimeChange	= Level.TimeSeconds;
	}


    // Take me off list
    RemoveChangedActor();

	Instigator = EventInstigator;

	RestoreInitialLightType = false;

	if (Level.Game.PlayerC != None)
		Level.Game.PlayerC.LightmapTextureCache = 1;

    // Then add us again if we were initially on
	if ((Owner != None) 
     && (Owner.IsA('ESwitchObject')) 
     && ((Owner.InitialState == 's_On') || (Owner.InitialState == '') || (Owner.InitialState == 's_Off')) 
     && (EventInstigator != None) 
     && (EventInstigator.bIsPlayerPawn))
    {    
	    Instigator = EventInstigator;
        Level.AddChange(self, _Type);
    }

	//for lights that are not linked to switchobject
	else if ((Owner == None) && (EventInstigator != None) && EventInstigator.bIsPlayerPawn)
	{
	    Instigator = EventInstigator;
        Level.AddChange(self, _Type);
	}
}

state s_Destructed 
{
	function BeginState()
	{
		Super.BeginState();
		Global.TurnOff(CHANGE_LightShotOut,Instigator);
	}

	// Can't interact with light object anymore
	function TurnOn(EChangeType _Type, optional pawn EventInstigator);
	function TurnOff(EChangeType _Type, optional pawn EventInstigator);
	
	function Trigger(actor Other, pawn EventInstigator, optional name InTag)
	{
		Super.Trigger(Other, EventInstigator, InTag);
	}
	
	function ProcessDamage(int Damage, class<DamageType> DamageType, Vector HitLocation, Vector HitNormal)
	{	
		Super.ProcessDamage(Damage, DamageType, HitLocation, HitNormal);
	}
	
}

defaultproperties
{
    bShatterable=True
    ExplosionNoiseRadius=400.000000
    bBlockNPCVision=False
    bIsEchelonLight=True
}