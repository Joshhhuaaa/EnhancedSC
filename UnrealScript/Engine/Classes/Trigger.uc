//=============================================================================
// Trigger: senses things happening in its proximity and generates 
// sends Trigger/UnTrigger to actors whose names match 'EventName'.
//=============================================================================
class Trigger extends Triggers
	native;

#exec Texture Import File=Textures\Trigger.pcx Name=S_Trigger Mips=Off MASKED=1 NOCONSOLE

//-----------------------------------------------------------------------------
// Trigger variables.

// Trigger type.
var() enum ETriggerType
{
	TT_PlayerProximity,	// Trigger is activated by player proximity.
	TT_PawnProximity,	// Trigger is activated by any pawn's proximity
	TT_ClassProximity,	// Trigger is activated by actor of ClassProximityType only
	TT_AnyProximity,    // Trigger is activated by any actor in proximity.
	TT_Shoot,		    // Trigger is activated by player shooting it.
} TriggerType;

// Human readable triggering message.
var() localized string Message;

// Only trigger once and then go dormant.
var() bool bTriggerOnceOnly;

// For triggers that are activated/deactivated by other triggers.
var() bool bInitiallyActive;

var() class<actor> ClassProximityType;

var() float	RepeatTriggerTime; //if > 0, repeat trigger message at this interval is still touching other
var() float ReTriggerDelay; //minimum time before trigger can be triggered again
var	  float TriggerTime;
var() float DamageThreshold; //minimum damage to trigger if TT_Shoot

// AI vars
var	actor TriggerActor;	// actor that triggers this trigger
var actor TriggerActor2;

// store for reset

var bool bSavedInitialCollision;
var bool bSavedInitialActive;

//=============================================================================
// AI related functions

function PostBeginPlay()
{
	if ( !bInitiallyActive )
		FindTriggerActor();
	if ( TriggerType == TT_Shoot )
	{
		bHidden = false;
		SetDrawType(DT_None);
	}
		
	bSavedInitialActive = bInitiallyActive;
	bSavedInitialCollision = bCollideActors;
	Super.PostBeginPlay();
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();

	// collision, bInitiallyactive
	bInitiallyActive = bSavedInitialActive;
	SetCollision(bSavedInitialCollision, bBlockActors, bBlockPlayers );
}	


function FindTriggerActor()
{
	local Actor A;

	TriggerActor = None;
	TriggerActor2 = None;
	ForEach AllActors(class 'Actor', A)
		if ( A.Event == Tag)
		{
			if ( A.IsA('Counter') )
				return; //FIXME - handle counters
			if (TriggerActor == None)
				TriggerActor = A;
			else
			{
				TriggerActor2 = A;
				return;
			}
		}
}

function Actor SpecialHandling(Pawn Other)
{
	local int i;
	local Actor A;

	if ( bTriggerOnceOnly && !bCollideActors )
		return None;

	if ( (TriggerType == TT_PlayerProximity) && !Other.IsPlayerPawn() )
		return None;

	if ( !bInitiallyActive )
	{
		if ( TriggerActor == None )
			FindTriggerActor();
		if ( TriggerActor == None )
			return None;
		if ( (TriggerActor2 != None) 
			&& (VSize(TriggerActor2.Location - Other.Location) < VSize(TriggerActor.Location - Other.Location)) )
			return TriggerActor2;
		else
			return TriggerActor;
	}

	// can other trigger it right away?
	if ( IsRelevant(Other) )
	{
		ForEach TouchingActors(class'Actor', A)
			if ( A == Other )
				Touch(Other);
		return self;
	}

	return self;
}

// when trigger gets turned on, check its touch list

function CheckTouchList()
{
	local int i;
	local Actor A;

	ForEach TouchingActors(class'Actor', A)
		Touch(A);
}

//=============================================================================
// Trigger states.

// Trigger is always active.
state() NormalTrigger
{
}

// Other trigger toggles this trigger's activity.
state() OtherTriggerToggles
{
	function Trigger( actor Other, pawn EventInstigator, optional name InTag ) // UBI MODIF - Additional parameter
	{
		bInitiallyActive = !bInitiallyActive;
		if ( bInitiallyActive )
			CheckTouchList();
	}
}

// Other trigger turns this on.
state() OtherTriggerTurnsOn
{
	function Trigger( actor Other, pawn EventInstigator, optional name InTag ) // UBI MODIF - Additional parameter
	{
		local bool bWasActive;

		bWasActive = bInitiallyActive;
		bInitiallyActive = true;
		if ( !bWasActive )
			CheckTouchList();
	}
}

// Other trigger turns this off.
state() OtherTriggerTurnsOff
{
	function Trigger( actor Other, pawn EventInstigator, optional name InTag ) // UBI MODIF - Additional parameter
	{
		bInitiallyActive = false;
	}
}

//=============================================================================
// Trigger logic.

//
// See whether the other actor is relevant to this trigger.
//
function bool IsRelevant( actor Other )
{
	if( !bInitiallyActive )
		return false;
	switch( TriggerType )
	{
		case TT_PlayerProximity:
			return (Pawn(Other) != None) && Pawn(Other).IsPlayerPawn();
		case TT_PawnProximity:
			return (Pawn(Other) != None) && Pawn(Other).CanTrigger(self);
		case TT_ClassProximity:
			return ClassIsChildOf(Other.Class, ClassProximityType);
		case TT_AnyProximity:
			return true;
	}
}
//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	local int i;

	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		TriggerEvent(Event, Other, Other.Instigator);

		if ( (Pawn(Other) != None) && (Pawn(Other).Controller != None) )
		{
			for ( i=0;i<4;i++ )
				if ( Pawn(Other).Controller.GoalList[i] == self )
				{
					Pawn(Other).Controller.GoalList[i] = None;
					break;
				}
		}	
				
		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

function Timer()
{
	local bool bKeepTiming;
	local int i;
	local Actor A;

	bKeepTiming = false;

	ForEach TouchingActors(class'Actor', A)
		if ( IsRelevant(A) )
		{
			bKeepTiming = true;
			Touch(A);
		}

	if ( bKeepTiming )
		SetTimer(RepeatTriggerTime, false);
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector HitNormal, 
						Vector momentum, class<DamageType> damageType, optional int PillTag ) // UBI MODIF - Additional parameter
{
	if ( bInitiallyActive && (TriggerType == TT_Shoot) && (Damage >= DamageThreshold) && (instigatedBy != None) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		TriggerEvent(Event, instigatedBy, instigatedBy);

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
	}
}

//
// When something untouches the trigger.
//
function UnTouch( actor Other )
{
	if( IsRelevant( Other ) )
		UntriggerEvent(event, Other, Other.Instigator);
}

defaultproperties
{
    bInitiallyActive=true
    InitialState="NormalTrigger"
    Texture=Texture'S_Trigger'
}