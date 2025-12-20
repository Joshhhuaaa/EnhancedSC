class EMedKit extends EInventoryItem;

#exec OBJ LOAD FILE=..\Sounds\Interface.uax

var float	HealthPointRecover;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_medkit;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_medkit;
    ItemName     = "MedKit";
	ItemVideoName = "gd_medical_kit.bik";
    Description  = "MedKitDesc";
	HowToUseMe  = "MedKitHowToUseMe";
}

// Call use here to know when it comes fmr player selecting it
function Select(EInventory Inv)
{
	local int	HealthPoint;
	local EPlayerController Epc;
	Epc = EPlayerController(Controller);
	
	if (Epc.ePawn.Health == Epc.ePawn.InitialHealth)
	{
		Epc.SendTransmissionMessage(Localize("Transmission", "MedKitNotUsed", "Localization\\HUD"), TR_CONSOLE);
		EPawn(Controller.Pawn).FullInventory.SetPreviousConfig();
		return;
	}

	PlaySound(Sound'Interface.Play_FisherUseMedikit', SLOT_Interface);

	HealthPoint = Epc.ePawn.InitialHealth * HealthPointRecover;
	if (Epc.ePawn.InitialHealth - Epc.Pawn.Health < HealthPoint)
	{
		Epc.SendTransmissionMessage(Localize("Transmission", "MedKitUsed", "Localization\\HUD"), TR_CONSOLE);
		Epc.Pawn.Health = Epc.ePawn.InitialHealth;			
		Epc.playerStats.AddStat("MedkitUsed");
	}
	else
	{
		Epc.SendTransmissionMessage(Localize("Transmission", "MedKitUsed", "Localization\\HUD"), TR_CONSOLE);
		Epc.Pawn.Health += HealthPoint;
		Epc.playerStats.AddStat("MedkitUsed");
	}

	// Remove it from inventory
	Inv.RemoveItem(self,1);
	Destroy();
}

defaultproperties
{
    HealthPointRecover=0.250000
    MaxQuantity=5
    bEquipable=False
    StaticMesh=StaticMesh'EMeshIngredient.Item.MedKit'
    CollisionRadius=16.000000
    CollisionHeight=5.000000
    bBlockPlayers=True
}