class EGroza extends ETwoHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=60
    MaxAmmo=60
    ClipAmmo=20
    ClipMaxAmmo=20
    RateOfFire=0.085000
    BaseDamage=125
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_GROZSingleShot'
    FireAutomaticSound=Sound'Gun.Play_GROZInfiniteShot'
    FireAutomaticEndSound=Sound'Gun.StopGo_GROZShotEnd'
    ReloadSound=Sound'Gun.Play_GROZReload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=15.658600,Y=1.260000,Z=11.472100)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=74.000000,Y=0.000000,Z=9.000000)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.ak47'
}