class EBReakerBoxMTown extends EGenerator;

var(Damage) float ShutDownPercent;

//------------------------------------------------------------------------
// Description		
//		Treatment upon take damage
//------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag )
{	
	Super(EGameplayObject).TakeDamage(Damage, EventInstigator, Hitlocation, HitNormal, Momentum, DamageType, PillTag);

	if( bDamageable )
	{					
        if(DamagePercent>=ShutDownPercent)
        {                    
          GotoState('s_Destructed');                   
        }
        
		Instigator = EventInstigator;
		Level.AddChange(self, CHANGE_BrokenObject);
	}	
}

state() s_Destructed
{    
	function BeginState()
	{
		TriggerAll();
	}	
}

defaultproperties
{
    ShutDownPercent=100.000000
    HitPoints=200
    DamagedMeshes(0)=(StaticMesh=StaticMesh'EMeshIngredient.Obj_MiningTown.BreackerBOXb1',Percent=50.000000)
    DamagedMeshes(1)=(StaticMesh=StaticMesh'EMeshIngredient.Obj_MiningTown.BreackerBOXb2',Percent=100.000000)
	// Joshua - It doesn't seem like this actor has spawnable objects
    //SpawnableObjects(0)=
    StaticMesh=StaticMesh'EMeshIngredient.Obj_MiningTown.BreackerBOX'
}