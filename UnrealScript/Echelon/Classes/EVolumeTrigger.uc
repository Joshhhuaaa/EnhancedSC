class EVolumeTrigger extends Trigger;

var() Actor	AssociatedActor;	// Actor that's gonna be notified upon triggering self

var() bool	bLiquid,
			bFlammable;
var   int   iDirtynessFactor;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// By default, use Owner as AssociatedActor
	AssociatedActor = Owner;
	SetBase(AssociatedActor);
}

function Touch( actor Other )
{
	if( IsRelevant(Other) )
	{
		// notify associated actor
		if( AssociatedActor != None )
			AssociatedActor.Trigger(self, EPawn(Other));

		if( bTriggerOnceOnly )
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

//------------------------------------------------------------------------
// Description		
//		for shootable volume (oil barrel,etc...)
//------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag )
{
	if( TriggerType == TT_Shoot && AssociatedActor != None )
		AssociatedActor.Trigger(self, EventInstigator);
}

defaultproperties
{
    TriggerType=TT_PawnProximity
    RepeatTriggerTime=0.500000
}