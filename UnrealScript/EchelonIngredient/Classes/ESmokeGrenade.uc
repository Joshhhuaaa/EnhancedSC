class ESmokeGrenade extends ESecondaryAmmo;

var	ESmokeCloud		Smoke;
var bool bUsedUp;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_foamgrenade;
    HUDTexSD     = EchelonLevelInfo(Level).TICON.qi_ic_foamgrenade_sd;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_foamgrenade;
    ItemName     = "SmokeGrenade";
	ItemVideoName = "gd_smoke_grenade.bik";
    Description  = "SmokeGrenadeDesc";
	HowToUseMe  = "SmokeGrenadeHowToUseMe";
}

state s_Flying
{
	function BeginState()
	{
		Super.BeginState();

		// add to changed actor list
		if ( Controller.bIsPlayer )
			Level.AddChange(self, CHANGE_Grenade);
	}

	function StoppedMoving()
	{
		if( bUsedUp )
			return;

		bUsedUp = true;

		PlaySound(Sound'FisherEquipement.Play_GasGrenadeExplosion', SLOT_SFX);
		AddSoundRequest(Sound'FisherEquipement.Stop_GasGrenadeExplosion', SLOT_SFX, 4.0f);
		Smoke = spawn(class'ESmokeCloud', self,, Location+(vect(2,0,0)>>Rotation));

		SetTimer(0.2f, true);
	}

	function Timer()
	{
		local float ratio;
		local Epawn P;

		if( Smoke == None || Smoke.Emitters.Length == 0 || Smoke.Emitters[0].MaxParticles == 0 )
			return;

		ratio = float(Smoke.Emitters[0].LivingParticles) / Smoke.Emitters[0].MaxParticles;
		ForEach VisibleCollidingActors(class'EPawn', P, ratio*400.f)
		{
			P.TakeDamage(2, Controller.Pawn, P.Location, Vect(0,0,0), Vect(0,0,0), class'ESleepingGas');
		}
	}
}

function LostChild( Actor Other )
{
	if( Other == Smoke )
		GotoState('s_Dying');
}

defaultproperties
{
    MaxQuantity=6
    HitNoiseRadius=750.000000
    StaticMesh=StaticMesh'EMeshIngredient.weapon.FoamGrenade'
    CollisionRadius=4.000000
    CollisionHeight=4.000000
}