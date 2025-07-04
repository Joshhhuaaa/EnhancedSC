class EUmp extends ETwoHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=60
    MaxAmmo=60
    ClipAmmo=30
    ClipMaxAmmo=30
    RateOfFire=0.075000
    BaseDamage=100
    FireNoiseRadius=200
    FireSingleShotSound=Sound'Gun.Play_HKMP5SingleShot'
    FireAutomaticSound=Sound'Gun.Play_HKMP5InfiniteShot'
    FireAutomaticEndSound=Sound'Gun.StopGo_HKMP5ShotEnd'
    ReloadSound=Sound'Gun.Play_HKMP5Reload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=14.749500,Y=1.089200,Z=11.059700)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=44.000000,Y=0.000000,Z=11.000000)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.Mp5A4'
}