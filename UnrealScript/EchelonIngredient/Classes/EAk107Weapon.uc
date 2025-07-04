class EAk107Weapon extends ETwoHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=90
    MaxAmmo=90
    ClipAmmo=30
    ClipMaxAmmo=30
    RateOfFire=0.100000
    BaseDamage=125
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_AK47SingleShot'
    FireAutomaticSound=Sound'Gun.Play_AK47InfiniteShot'
    FireAutomaticEndSound=Sound'Gun.StopGo_AK47ShotEnd'
    ReloadSound=Sound'Gun.Play_AK47Reload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=-5.000000,Y=1.000000,Z=12.000000)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=61.711290,Y=-0.000020,Z=9.990690)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.AK107'
}