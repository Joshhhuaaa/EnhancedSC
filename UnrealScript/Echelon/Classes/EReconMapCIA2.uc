class EReconMapCIA2 extends ERecon;

function InitRecon()
{

    ReconType        = 2;
	ReconName        = "ReconNameMapCIA2";
	ReconPicName     = Texture'HUD.RECON.rc_2_1_CIA2';
	ReconPreviewText = "ReconPTMapCIA2";
	ReconText        = "";

	NbrOfCoord = 4;

	// Add manualy because of defined structure
	ReconDynMapArray.Length = ReconDynMapArray.Length + NbrOfCoord;

	// Map COORDinates for Tbilisi MAP
	ReconDynMapArray[0].x        = 212;
	ReconDynMapArray[0].y        = 260;
	ReconDynMapArray[0].RoomDesc = "ReconMapCIA2Room1";


	ReconDynMapArray[1].x = 253;
	ReconDynMapArray[1].y = 210;
	ReconDynMapArray[1].RoomDesc = "ReconMapCIA2Room2";

	ReconDynMapArray[2].x = 304;
	ReconDynMapArray[2].y = 147;
	ReconDynMapArray[2].RoomDesc = "ReconMapCIA2Room3";

	ReconDynMapArray[3].x = 352;
	ReconDynMapArray[3].y = 260;
	ReconDynMapArray[3].RoomDesc = "ReconMapCIA2Room4";
}

