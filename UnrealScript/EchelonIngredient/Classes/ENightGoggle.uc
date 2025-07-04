class ENightGoggle extends EAbstractGoggle;

function PostBeginPlay()
{
	Super.PostBeginPlay();

    HUDTex      = EchelonLevelInfo(Level).TICON.qi_ic_night;
    InventoryTex= EchelonLevelInfo(Level).TICON.inv_ic_nightvis;
    ItemName    = "InventoryItem";
	ItemVideoName = "nightgoggle.bik";
    Description = "NightGoggleDesc";
	HowToUseMe  = "NightGoggleHowToUseMe";
	RendType	= REN_NightVision;
}

