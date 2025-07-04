class EIMIUzi extends EOneHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=64
    MaxAmmo=64
    ClipAmmo=32
    ClipMaxAmmo=32
    RateOfFire=0.100000
    BaseDamage=100
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_UZIISingleShot'
    FireAutomaticSound=Sound'Gun.Play_UZIIInfiniteShot'
    FireAutomaticEndSound=Sound'Gun.StopGo_UZIIShotEnd'
    ReloadSound=Sound'Gun.Play_UZIIReload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseSmall'
    EjectedOffset=(X=2.211600,Y=0.917700,Z=11.007300)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=29.607110,Y=0.000020,Z=9.459260)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.Uzi'
}