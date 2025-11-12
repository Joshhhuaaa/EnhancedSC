class EFn7 extends EHandGun;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

function PostBeginPlay()
{
    Super.PostBeginPlay();
    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_beretta;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_beretta;
    ItemName     = "FN7";
    ItemVideoName = "gd_fn702.bik";
    Description  = "FN7Desc";
    HowToUseMe  = "FN7HowToUseMe";
}

function bool SwitchROF()
{
	switch (eROFMode)
	{
		case ROF_Single : eROFMode = ROF_Single; return false;
	}
}

function bool IsROFModeAvailable(ERateOfFireMode rof)
{
    switch (rof)
	{
        case ROF_Single:
            return true;
        default:
            return false;
    }
}

// ----------------------------------------------------------------------
// state s_Inventory - Must keep this gun always Visible
// ----------------------------------------------------------------------
state s_Inventory
{
	function BeginState()
	{
		Super.BeginState();
		bHidden	= false;
	}
}

defaultproperties
{
    Ammo=40
    MaxAmmo=60
    ClipAmmo=20
    ClipMaxAmmo=20
    RateOfFire=0.187000
    BaseDamage=100
    FireNoiseRadius=400
    FireSingleShotSound=Sound'FisherEquipement.Play_FisherPistolSingleShot'
    ReloadSound=Sound'FisherEquipement.Play_FNPistolReload'
    EmptySound=Sound'GunCommon.Play_PistolEmpty'
    EjectedClass=Class'EShellCaseSmall'
    EjectedOffset=(X=2.425500,Y=0.763900,Z=7.027100)
    MuzzleOffset=(X=38.911000,Y=0.000000,Z=7.313000)
    MagazineMesh=StaticMesh'EMeshIngredient.weapon.F7MAG'
    MagazineOffset=(X=2.985000,Y=0.000000,Z=5.431000)
    RecoilStrength=1.000000
    RecoilAngle=10.000000
    RecoilStartAlpha=1.000000
    RecoilFadeOut=4.000000
    UseAccuracy=true
    AccuracyMovementModifier=5.000000
    AccuracyReturnModifier=10.000000
    AccuracyBase=0.500000
    ObjectHudClass=Class'EF2000Reticle'
    StaticMesh=StaticMesh'EMeshIngredient.weapon.F7'
    CollisionRadius=6.000000
    CollisionHeight=6.000000
}