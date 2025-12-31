class ERingAirfoilRound extends ESecondaryAmmo;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

/*-----------------------------------------------------------------------------
    Function :      PostBeginPlay

    Description:    -
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
	Super.PostBeginPlay();
    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_ring_airfoil;
    HUDTexSD     = EchelonLevelInfo(Level).TICON.qi_ic_ring_airfoil_sd;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_ring_airfoil;
    ItemName     = "RingAirfoilRound";
	ItemVideoName = "gd_ring.bik";
    Description  = "RingAirfoilRoundDesc";
	HowToUseMe  = "RingAirfoilRoundHowToUseMe";

}

state s_Flying
{
	function BeginState()
	{
		Super.BeginState();

		// add to changed actor list
		if (Controller.bIsPlayer)
			Level.AddChange(self, CHANGE_Grenade);
	}

	function Bump(Actor Other, optional int Pill)
	{
		// don't hit shooter but can do damage on anything else ...
		if (Other == Controller.Pawn)
			return;

		PlaySound(Sound'FisherEquipement.Play_FN2000AirFoilRing', SLOT_SFX);

		if (Other.bIsPawn)
			Other.TakeDamage(EPawn(Other).InitialHealth / 2, Controller(Owner).Pawn, Location, Velocity, Velocity, class'EStunned', Pill);
		else
			Super.Bump(Other, Pill);

		Destroy();
	}
}

function Select(EInventory Inv)
{
	Super.Select(Inv);
	
	// Joshua - Don't play sound during silent restore (sorting)
	if (!Inv.bSilentRestore)
		PlaySound(Sound'Interface.Play_FisherEquipSpMunition', SLOT_Interface);
}

//------------------------------------------------------------------------
// Description		
//		Do treatment depending on light vars (50% of the visibility)
//------------------------------------------------------------------------
event VisibilityRating GetActorVisibility()
{
	return VIS_Invisible;
}

defaultproperties
{
    MaxQuantity=10
    ChangeListWhenThrown=False
    StaticMesh=StaticMesh'EMeshIngredient.weapon.FoamGrenade'
    CollisionRadius=4.000000
    CollisionHeight=4.000000
}