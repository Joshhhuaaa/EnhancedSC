class EVZ61Skorpion extends EOneHandedWeapon;

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
    EjectedOffset=(X=13.169200,Y=1.309800,Z=8.446100)
    MuzzleFlashClass=Class'EMuzzleFlash'
    MuzzleOffset=(X=25.649150,Y=0.000020,Z=10.110410)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.SubCZ61'
}