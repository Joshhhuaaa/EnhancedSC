class ESigSauerP228 extends EOneHandedWeapon;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    Ammo=45
    MaxAmmo=45
    ClipAmmo=15
    ClipMaxAmmo=155
    RateOfFire=0.187000
    BaseDamage=100
    FireNoiseRadius=400
    FireSingleShotSound=Sound'Gun.Play_BER9SingleShot'
    ReloadSound=Sound'Gun.Play_BER9Reload'
    EmptySound=Sound'GunCommon.Play_PistolEmpty'
    EjectedClass=Class'EShellCaseSmall'
    EjectedOffset=(X=7.655100,Y=0.811500,Z=9.310000)
    MuzzleOffset=(X=16.491980,Y=-0.000020,Z=8.905200)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.P228'
    CollisionRadius=6.000000
    CollisionHeight=6.000000
}