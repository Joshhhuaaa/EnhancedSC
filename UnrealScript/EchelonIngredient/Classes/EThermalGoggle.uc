class EThermalGoggle extends EAbstractGoggle;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	HUDTex      = EchelonLevelInfo(Level).TICON.qi_ic_thermal;
    InventoryTex= EchelonLevelInfo(Level).TICON.inv_ic_thermal;
    ItemName    = "ThermalGoggle";
	ItemVideoName = "thermalgoggle.bik";
    Description = "ThermalGoggleDesc";
	HowToUseMe  = "ThermalGoggleHowToUseMe";
	RendType	= REN_ThermalVision;
}

