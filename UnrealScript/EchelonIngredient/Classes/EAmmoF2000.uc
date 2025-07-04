class EAmmoF2000 extends EAmmo;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    ItemName = "AmmoF2000";
}

function EWeapon GetAmmoWeapon(EPlayerController Epc)
{
	return Epc.MainGun;
}

defaultproperties
{
    Ammo=30
    StaticMesh=StaticMesh'EMeshIngredient.Object.BulletcaseF2000'
    CollisionRadius=5.000000
    CollisionHeight=8.500000
}