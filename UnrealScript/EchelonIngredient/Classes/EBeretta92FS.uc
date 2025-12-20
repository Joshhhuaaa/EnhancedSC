class EBeretta92FS extends EOneHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=45
    MaxAmmo=45
    ClipAmmo=15
    ClipMaxAmmo=15
    RateOfFire=0.187000
    BaseDamage=100
    FireNoiseRadius=400
    FireSingleShotSound=Sound'Gun.Play_BER9SingleShot'
    ReloadSound=Sound'Gun.Play_BER9Reload'
    EmptySound=Sound'GunCommon.Play_PistolEmpty'
    EjectedClass=Class'EShellCaseSmall'
    EjectedOffset=(X=-0.483600,Y=0.659400,Z=7.945800)
    MuzzleOffset=(X=30.000000,Y=0.000000,Z=9.000000)
    PrePivot=(X=-3.000000,Y=0.000000,Z=0.000000) // Joshua - Added -3.0 offset to improve Beretta fit in hands.
    StaticMesh=StaticMesh'EMeshIngredient.weapon.beretta'
    CollisionRadius=6.000000
    CollisionHeight=6.000000
}