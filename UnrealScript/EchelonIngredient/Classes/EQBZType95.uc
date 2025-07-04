class EQBZType95 extends ETwoHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=90
    MaxAmmo=90
    ClipAmmo=30
    ClipMaxAmmo=30
    RateOfFire=0.092000
    BaseDamage=125
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_QBZ9SingleShot'
    FireAutomaticSound=Sound'Gun.Play_QBZ9InfiniteShot'
    FireAutomaticEndSound=Sound'Gun.StopGo_QBZ9ShotEnd'
    ReloadSound=Sound'Gun.Play_QBZ9Reload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=-12.000000,Y=1.700000,Z=10.500000)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=49.672990,Y=0.000010,Z=9.107680)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.QBZType85'
}