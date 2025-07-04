class EAk_47 extends ETwoHandedWeapon;

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
    EjectedOffset=(X=15.658600,Y=1.260000,Z=11.472100)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=61.711290,Y=-0.000020,Z=9.990690)
    MagazineMesh=StaticMesh'EMeshIngredient.weapon.AK47MAG'
    MagazineOffset=(X=15.031610,Y=0.000000,Z=7.971890)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.ak47'
}