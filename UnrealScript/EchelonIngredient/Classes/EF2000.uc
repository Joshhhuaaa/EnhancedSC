class EF2000 extends EMainGun;

var int numShellIn;
var int numShellToEject;
var float lastEjectTime;

const MAX_SHELL_IN = 3;
const EJECT_DELAY = 0.04;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

function PostBeginPlay()
{	
    Super.PostBeginPlay();

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_maingun;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_maingun;
    ItemName     = "FN2000";
	ItemVideoName = "gd_f2000.bik";
    Description  = "FN2000Desc";
	HowToUseMe  = "FN2000HowToUseMe";
}

function CheckShellCase()
{
	if(numShellToEject > 0 && (lastEjectTime + EJECT_DELAY < Level.TimeSeconds))
	{
		lastEjectTime = Level.TimeSeconds;
		numShellToEject--;
		Super.SpawnShellCase();
	}
}

function SpawnShellCase()
{
	if ( numShellIn == MAX_SHELL_IN )
	{
		numShellToEject = 1;
	}
	else
	{
		numShellIn++;
	}
}

function bool Reload()
{
	numShellToEject = numShellIn;
	numShellIn = 0;
	return Super.Reload();
}

function bool SwitchROF()
{
    local EPlayerController EPC;
    EPC = EPlayerController(Controller);

	// switch ROF
	if( !bSniperMode )
	{
		switch( eROFMode )
		{
			case ROF_Single : 
				if (EPC.bBurstFire)  // Joshua - Restoring burst fire from early Splinter Cell builds
					eROFMode = ROF_Burst;
				else
					eROFMode = ROF_Auto;
				break;
			case ROF_Burst : eROFMode = ROF_Auto; break;
			case ROF_Auto :	eROFMode = ROF_Single; break;
		}
	}

	return !bSniperMode;
}


function bool IsROFModeAvailable(ERateOfFireMode rof)
{
    local EPlayerController EPC;
    EPC = EPlayerController(Controller);

    switch( rof )
	{
        case ROF_Single:
            return true;
        case ROF_Burst:
            return EPC.bBurstFire; // Joshua - Restoring burst fire from early Splinter Cell builds
        case ROF_Auto:
            return true;
        default:
            return false;
    }
}

// Joshua - Validate ROF if burst fire was disabled while in-game
function ValidateROFMode()
{
    if(!EPlayerController(Controller).bBurstFire && eROFMode == ROF_Burst)
    {
        eROFMode = ROF_Auto;
    }
}

defaultproperties
{
    FOVs(0)=45.000000
    FOVs(1)=23.000000
    FOVs(2)=14.000000
    Ammo=60
    MaxAmmo=60
    ClipAmmo=30
    ClipMaxAmmo=30
    RateOfFire=0.072000
    BaseDamage=100
    FireNoiseRadius=800
    FireSingleShotSound=Sound'FisherEquipement.Play_FN2000SingleShot'
    FireAutomaticSound=Sound'FisherEquipement.Play_FN2000InfiniteShot'
    FireAutomaticEndSound=Sound'FisherEquipement.StopGo_FN2000ShotEnd'
    ReloadSound=Sound'FisherEquipement.Play_FN2000Reload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=22.000000,Y=2.502500,Z=9.000000)
    MuzzleOffset=(X=53.062000,Y=0.000000,Z=7.474790)
    MagazineMesh=StaticMesh'EMeshIngredient.weapon.F2000MAG'
    MagazineOffset=(X=-11.646000,Y=0.000010,Z=3.557610)
    RecoilStrength=1.000000
    RecoilAngle=0.250000
    RecoilFadeIn=20.000000
    RecoilFadeOut=6.000000
    UseAccuracy=true
    AccuracyMovementModifier=5.000000
    AccuracyReturnModifier=13.000000
    AccuracyBase=0.200000
    ObjectHudClass=Class'EF2000Reticle'
    StaticMesh=StaticMesh'EMeshIngredient.weapon.f2000'
}