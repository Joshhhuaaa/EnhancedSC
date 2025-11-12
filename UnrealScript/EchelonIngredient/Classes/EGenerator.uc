class EGenerator extends ESwitchObject;

//------------------------------------------------------------------------
// Description		
//		Treatment upon take damage
//------------------------------------------------------------------------
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	local float HPState;

	if (bDamageable)
	{
		HitPoints -= Damage;
		// Check the percent of life left ..
		HPState = HitPoints / default.HitPoints;

		// the more the damage, the more, there's a chance for some objects to shut off
		if (FRand() > HPState)
		{

		}

		Instigator = EventInstigator;
		Level.AddChange(self, CHANGE_BrokenObject);
	}

	Super(EGameplayObject).TakeDamage(Damage, EventInstigator, Hitlocation, HitNormal, Momentum, DamageType, PillTag);
}

defaultproperties
{
    bDamageable=true
    StaticMesh=StaticMesh'EMeshIngredient.Object.Generator'
    CollisionRadius=115.000000
    CollisionHeight=66.000000
}