class EMK23 extends EOneHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=60
    MaxAmmo=60
    ClipAmmo=20
    ClipMaxAmmo=20
    RateOfFire=0.071000
    BaseDamage=100
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_VZ61SingleShot'
    FireAutomaticSound=Sound'Gun.Play_VZ61InfiniteShot'
    FireAutomaticEndSound=Sound'Gun.StopGo_VZ61ShotEnd'
    ReloadSound=Sound'Gun.Play_VZ61Reload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseSmall'
    EjectedOffset=(X=8.786400,Y=1.110400,Z=10.107300)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=21.556140,Y=0.000020,Z=9.812740)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.Mk23'
}