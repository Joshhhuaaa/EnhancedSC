class E9mmMakarovPMM extends EOneHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=36
    MaxAmmo=36
    ClipAmmo=12
    ClipMaxAmmo=12
    RateOfFire=0.187000
    BaseDamage=100
    FireNoiseRadius=2000
    FireSingleShotSound=Sound'Gun.Play_MAKASingleShot'
    ReloadSound=Sound'Gun.Play_MAKAReload'
    EmptySound=Sound'GunCommon.Play_PistolEmpty'
    EjectedClass=Class'EShellCaseSmall'
    EjectedOffset=(X=2.596400,Y=0.922100,Z=7.246100)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=14.481860,Y=0.000020,Z=7.974220)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.Makarov'
}