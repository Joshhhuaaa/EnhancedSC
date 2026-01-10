class EReconMap3_2Cooling extends ERecon;

function InitRecon()
{

    ReconType        = 2;
	ReconName        = "ReconNameMap3_2Cooling";
	ReconPicName     = Texture'HUD.RECON.rc_3_2_coolingroom';
	ReconPreviewText = "ReconPTMap3_2Cooling";
	ReconText        = "";

	NbrOfCoord = 2;

	// Add manualy because of defined structure
	ReconDynMapArray.Length = ReconDynMapArray.Length + NbrOfCoord;

	// Map COORDinates for Cooling Room MAP
	ReconDynMapArray[0].x        = 212;
	ReconDynMapArray[0].y        = 125;
	ReconDynMapArray[0].RoomDesc = "ReconMap3_2CoolingRoom1";


	ReconDynMapArray[1].x = 356;
	ReconDynMapArray[1].y = 209;
	ReconDynMapArray[1].RoomDesc = "ReconMap3_2CoolingRoom2";

}

