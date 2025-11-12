class EGameplayObjectPattern extends EGameplayObject;

var() bool	bCanTakeDamage;

function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{
	// call normal Trigger
	Super.Trigger(Other, EventInstigator, InTag);
	// call Super.TakeDamage since the current one is disabled
	Super.TakeDamage(100, EventInstigator, vect(0,0,0), vect(0,0,0), vect(0,0,0), None);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, 
					 class<DamageType> DamageType, optional int PillTag)
{
	if (bCanTakeDamage)
		Super.TakeDamage(Damage, EventInstigator, HitLocation, HitNormal, Momentum, DamageType, PillTag);
}

defaultproperties
{
    ChangeListWhenDamaged=false
}