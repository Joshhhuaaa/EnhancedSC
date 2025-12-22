// Joshua - The Concussion Grenade was a canceled gadget that never appeared in the final game.
// This is an attempted recreation of the gadget.
class EConcussionGrenade extends EInventoryItem;

#exec OBJ LOAD FILE=..\Sounds\Interface.uax

/*-----------------------------------------------------------------------------
    Function :      PostBeginPlay

    Description:    -
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
	Super.PostBeginPlay();

	// manage quantity
	if (Quantity == 1)
		SetStaticMesh(default.StaticMesh);
	else
		SetStaticMesh(StaticMesh'EMeshIngredient.weapon.ConcussionGrenade');
    
	HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_concussiongrenade;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_concussiongrenade;
    ItemName     = "ConcussionGrenade";
	ItemVideoName = "gd_grenade.bik";
    Description  = "ConcussionGrenadeDesc";
	HowToUseMe  = "ConcussionGrenadeHowToUseMe";
}

//---------------------------------------[David Kalina - 26 Nov 2001]-----
// 
// Description
//		Thrower wants to throw us at specified velocity.
//
//------------------------------------------------------------------------

function Throw(Controller Thrower, vector ThrowVelocity)
{
	Super.Throw(Thrower, ThrowVelocity);

	if (Thrower.bIsPlayer)
		Level.AddChange(self, CHANGE_Object);
}


state s_Flying
{
	function BeginState()
	{
		Super.BeginState();

		bPickable = false;
		SetTimer(ExplodeTimer, false);
	}
	
	function Timer()
	{
		local actor Victims;
		local float dist, damageScale, dam;
		local vector dir;

		// Play explosion sound
        PlaySound(Sound'FisherEquipement.Play_GasGrenadeExplosion', SLOT_SFX);
		AddSoundRequest(Sound'FisherEquipement.Stop_GasGrenadeExplosion', SLOT_SFX, 0.5f);

		// Make noise to alert NPCs
		MakeNoise(HitNoiseRadius, NOISE_Explosion);

		// Spawn visual effect if specified
		if (ExplosionClass != None)
			spawn(ExplosionClass, self);

		// Damage all actors in the explosion radius
		foreach CollidingActors(class 'Actor', Victims, ExplosionMaxRadius)
		{
			if (Victims != self && FastTraceBsp(Victims.Location))
			{
				dir = Victims.Location - Location;
				dist = FMax(1, VSize(dir));

				// Calculate damage scale based on distance (if ExplosionMinRadius is set)
				damageScale = 1;
				if (ExplosionMinRadius > 0 && dist > ExplosionMinRadius)
					damageScale = 1 - FMax(0, (dist - ExplosionMinRadius) / (ExplosionMaxRadius - ExplosionMinRadius));

				dir = dir / dist;

				// Handle pawns (NPCs and player)
				if (Victims.bIsPawn)
				{
					// Player gets standard crush damage, NPCs get stunned
					if (EPawn(Victims).bIsPlayerPawn)
					{
						dam = ExplosionDamage * damageScale;
						if (EchelonGameInfo(Level.Game).pPlayer.playerInfo.Difficulty > 0 && EchelonGameInfo(Level.Game).bScaleGadgetDamage)
							Victims.TakeDamage(dam * 1.5, Controller(Owner).Pawn, Location, dir, (damageScale * ExplosionMomentum * dir), class'Crushed', 0);
						else
							Victims.TakeDamage(dam, Controller(Owner).Pawn, Location, dir, (damageScale * ExplosionMomentum * dir), class'Crushed', 0);
					}
					else
					{
						// Stun NPCs (half of their health)
						Victims.TakeDamage(EPawn(Victims).InitialHealth / 2, Controller(Owner).Pawn, Location, dir, vect(0,0,0), class'EStunned', 0);
					}
				}
				// Handle gameplay objects (destructible objects)
				else if (EGameplayObject(Victims) != None && EGameplayObject(Victims).bDamageable)
				{
					dam = ExplosionDamage * damageScale;
					Victims.TakeDamage(dam, Controller(Owner).Pawn, Location, dir, (damageScale * ExplosionMomentum * dir), class'Crushed', 0);
				}
			}
		}

		// Destroy the grenade
		Destroy();
	}
}

/*
function Select(EInventory Inv)
{
	Super.Select(Inv);
	PlaySound(sound'Interface.Play_FisherEquipFragGrenade', SLOT_Interface);
}
*/

defaultproperties
{
    MaxQuantity=6
    HitNoiseRadius=750.000000
    bDamageable=True
    bExplodeWhenDestructed=False
    ExplosionClass=Class'EchelonEffect.EGrenadeExplosion'
    ExplosionDamage=50.000000
    ExplosionMinRadius=300.000000
    ExplosionMaxRadius=500.000000
    ExplodeTimer=2.000000
    StaticMesh=StaticMesh'EMeshIngredient.Item.ConcussionGrenade'
    DrawScale=0.500000
    CollisionRadius=4.000000
    CollisionHeight=4.000000
    bIsProjectile=True
    Mass=60.000000
}
