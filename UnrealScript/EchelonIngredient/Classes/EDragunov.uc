class EDragunov extends ESniperGun;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

defaultproperties
{
    FOVs(0)=45.000000
    FOVs(1)=14.000000
    FOVs(2)=2.000000
    Ammo=20
    MaxAmmo=20
    ClipAmmo=10
    ClipMaxAmmo=10
    RateOfFire=0.750000
    BaseDamage=300
    FireNoiseRadius=200
    FireSingleShotSound=Sound'Gun.Play_DRAGSingleShot'
    ReloadSound=Sound'Gun.Play_DRAGReload'
    EmptySound=Sound'GunCommon.Play_RifleEmpty'
    EjectedClass=Class'EShellCaseBig'
    EjectedOffset=(X=16.842300,Y=1.620400,Z=5.441800)
    MuzzleOffset=(X=110.000000,Y=0.000000,Z=9.000000)
    StaticMesh=StaticMesh'EMeshIngredient.weapon.dragunov'
}