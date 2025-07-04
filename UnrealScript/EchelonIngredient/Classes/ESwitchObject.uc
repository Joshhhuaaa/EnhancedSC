class ESwitchObject extends EGameplayObject;

var() Array<Actor>	TriggeredObjects;		// All Objects to be triggered by switch
var() bool			TriggerOnlyOnce;
var	  Pawn			mEventInstigator;

// adding retrigger delay functionnality, like on the basic Unreal trigger class.
var   float TriggerTime;
var() float ReTriggerDelay;

function PostBeginPlay()
{
	local int i;
	Super.PostBeginPlay();
	TriggerTime = Level.TimeSeconds;
	for ( i=0; i<TriggeredObjects.Length; i++ )
	{
		if( TriggeredObjects[i] != None )
			TriggeredObjects[i].SetOwner(self);
		else
			Log(self$" WARNING: Obsoletes actor refs in TriggeredObjects array at index:"$i);
	}
}

//------------------------------------------------------------------------
// Description		
//		Treatment upon take damage
//------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag )
{
	// A chance out of 2 to destroy it upon damage
	if( FRand() > 0.5 )
		Super.TakeDamage(Damage, EventInstigator, HitLocation, HitNormal, Momentum, DamageType, PillTag);
}

//------------------------------------------------------------------------
// Description		
//		Trigger all defined objects
//------------------------------------------------------------------------
function TriggerAll()
{
	local int i;

	for( i=0; i<TriggeredObjects.Length; i++ )
	{
		if( TriggeredObjects[i] != None )
			TriggeredObjects[i].Trigger(self, mEventInstigator);
	}
}

auto state() s_On
{
	function BeginState()
	{
		// For alarm stuff
		if( Alarm != None && mEventInstigator != None )
			Alarm.EnableAlarm(self, mEventInstigator.Controller);
     
		TriggerAll();
	}

	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		// retrigger delay validation
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		
		Super.Trigger(Other, EventInstigator, InTag);

		// If trigger only once, destroy interaction
		if( TriggerOnlyOnce )
			ResetInteraction();

		PlaySound(Sound'FisherFoley.Play_LightOnOff', SLOT_SFX);

		mEventInstigator = EventInstigator;
		GotoState('s_Off');
	}
}

state() s_Off
{
	function BeginState()
	{
		// For alarm stuff
		if( Alarm != None )
			Alarm.DisableAlarm(self);
	
		TriggerAll();
	}

	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		// retrigger delay validation
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}

		Super.Trigger(Other, EventInstigator, InTag);

		PlaySound(Sound'FisherFoley.Play_LightOnOff', SLOT_SFX);

		mEventInstigator = EventInstigator;
		GotoState('s_On');
	}
}

defaultproperties
{
    ReTriggerDelay=0.200000
    bDamageable=false
    bIsSwitchObject=true
    InteractionClass=Class'ETriggerInteraction'
}