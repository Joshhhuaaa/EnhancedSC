class EHandGun extends EOneHandedWeapon;

#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

var EGameplayObject Slider;
var vector			SliderOffset;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Slider = spawn(class'EGameplayObject', self);
	Slider.SetBase(self);
	Slider.SetStaticMesh(StaticMesh'EMeshIngredient.Weapon.F7_baril');
	Slider.SetRelativeLocation(SliderOffset);
	Slider.SetCollision(false);
}

function Destroyed()
{
	if (Slider != None)
		Slider.Destroy();
	Super.Destroyed();
}

function Select(EInventory Inv)
{
	Super.Select(Inv);
	
	// Joshua - Don't play sound during silent restore (sorting)
	if (!Inv.bSilentRestore)
		PlaySound(Sound'Interface.Play_FisherEquipPistol', SLOT_Interface);
}

function bool CanAddThisItem(EInventoryItem ItemToAdd)
{
	return ItemToAdd == self;
}

function AddedToInventory()
{
	EPlayerController(Controller).HandGun = self;
	Super.AddedToInventory();

	// Joshua - PS2 FN7 Accuracy: Apply when picking up the weapon mid-mission
	if (EchelonGameInfo(Level.Game).bPS2FN7Accuracy)
	{
		AccuracyMovementModifier = 3.330000;
		AccuracyBase = 0.330000;
	}
}

function bool NotifyPickup(Controller Instigator)
{
	local EPlayerController Epc;
	
	Super.NotifyPickup(Instigator);

	// Set as Player HandGun
	Epc = EPlayerController(Controller);
	Epc.ePawn.FullInventory.SetSelectedItem(self);
	Epc.DoSheath();
	
	return false;
}

state s_Firing
{
	function BeginState()
	{
		Super.BeginState();

		// move slider
		Slider.SetRelativeLocation(SliderOffset - vect(5,0,0));
	}

	function EndState()
	{
		Super.EndState();
		
		if (ClipAmmo > 0)
			Slider.SetRelativeLocation(SliderOffset);
	}
}

state s_Reloading
{
	function EndState()
	{
		Super.EndState();
		
		if (Slider.RelativeLocation != SliderOffset)
			Slider.SetRelativeLocation(SliderOffset);
	}
}

defaultproperties
{
    SliderOffset=(X=5.139000,Y=0.000000,Z=6.578000)
    Category=CAT_GADGETS
    bPickable=True
}