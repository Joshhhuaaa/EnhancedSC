class EKnob extends EDoorOpener
	notplaceable;

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector HitNormal, 
						Vector momentum, class<DamageType> damageType, optional int PillTag );

defaultproperties
{
    StaticMesh=none
    bCollideActors=false
    InteractionClass=Class'EDoorInteraction'
}