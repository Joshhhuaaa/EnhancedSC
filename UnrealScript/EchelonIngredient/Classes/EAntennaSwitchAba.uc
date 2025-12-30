class EAntennaSwitchAba extends ESwitchObject;

// Joshua - Override TakeDamage to prevent damage until interaction starts
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag)
{
	if (bDamageable)
		Super.TakeDamage(Damage, EventInstigator, HitLocation, HitNormal, Momentum, DamageType, PillTag);
}

state s_On
{
	function Trigger(Actor Other, Pawn EventInstigator, optional name InTag)
	{
		if (Other.IsA('EPattern'))
		{
			if (Interaction != None)
				Interaction.SetCollision(!Interaction.bCollideActors);
			return;
		}

		Super.Trigger(Other, EventInstigator, InTag);
	}
}

state s_Off
{
	function Trigger(Actor Other, Pawn EventInstigator, optional name InTag)
	{
		if (Other.IsA('EPattern'))
		{
			if (Interaction != None)
				Interaction.SetCollision(!Interaction.bCollideActors);
			return;
		}

		Super.Trigger(Other, EventInstigator, InTag);
	}
}

defaultproperties
{
	// Joshua - New antenna switch interaction for Abattoir
	bDestroyWhenDestructed=False
	InteractionClass=Class'EAntennaSwitchAbaInteraction'
	SpawnableObjects(0)=(SpawnClass=Class'EchelonEffect.EWallSpark',SpawnAtDamagePercent=100.000000)
    SpawnableObjects(1)=(SpawnClass=Class'EchelonEffect.ElightDarkSmoke',SpawnAtDamagePercent=100.000000)
	HitSound(0)=Sound'DestroyableObjet.Play_CameraDestroyed'
}
