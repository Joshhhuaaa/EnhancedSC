class EA91 extends ETwoHandedWeapon;

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
    FireSingleShotSound=Sound'Gun.Play_A91ASingleShot'
    FireAutomaticSound=Sound'Gun.Play_A91AInfiniteShot'
    FireAutomaticEndSound=Sound'Gun.StopGo_A91AShotEnd'
    ReloadSound=Sound'Gun.Play_A91AReload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=15.658600,Y=1.260000,Z=11.472100)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=74.000000,Y=0.000000,Z=9.000000)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.ak47'
}