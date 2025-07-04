class EM16A2 extends ETwoHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=90
    MaxAmmo=90
    ClipAmmo=30
    ClipMaxAmmo=30
    RateOfFire=0.072000
    BaseDamage=125
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_M16ASingleShot'
    ReloadSound=Sound'Gun.Play_M16AReload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=14.214500,Y=1.440600,Z=5.850100)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=73.386340,Y=-0.000020,Z=10.231730)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.M16A2'
}