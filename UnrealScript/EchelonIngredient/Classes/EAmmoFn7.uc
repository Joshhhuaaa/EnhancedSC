class EAmmoFn7 extends EAmmo;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    ItemName = "AmmoFn7";
}

function EWeapon GetAmmoWeapon(EPlayerController Epc)
{
	return Epc.HandGun;
}

defaultproperties
{
    Ammo=20
    StaticMesh=StaticMesh'EMeshIngredient.Object.Bulletcase'
    CollisionRadius=4.000000
    CollisionHeight=5.000000
}