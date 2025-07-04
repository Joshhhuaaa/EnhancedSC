class EReconMap4_1 extends ERecon;

function InitRecon()
{
	
    ReconType        = 2;
	ReconName        = "ReconNameMapChine";
	ReconPicName     = Texture'HUD.RECON.rc_4_1map';
	ReconPreviewText = "ReconPTMapChine";
	ReconText        = "";
	
	NbrOfCoord = 7;
		
	// Add manualy because of defined structure
	ReconDynMapArray.Length = ReconDynMapArray.Length + NbrOfCoord;
		
	// Map COORDinates for Chinese embassy MAP
	ReconDynMapArray[0].x = 213;
	ReconDynMapArray[0].y = 209;
	ReconDynMapArray[0].RoomDesc = "ReconMapChineRoom1";
		
	ReconDynMapArray[1].x = 255;
	ReconDynMapArray[1].y = 194;
	ReconDynMapArray[1].RoomDesc = "ReconMapChineRoom2";

	ReconDynMapArray[2].x = 303;
	ReconDynMapArray[2].y = 178;
	ReconDynMapArray[2].RoomDesc = "ReconMapChineRoom3";

	ReconDynMapArray[3].x = 368;
	ReconDynMapArray[3].y = 265;
	ReconDynMapArray[3].RoomDesc = "ReconMapChineRoom4";

	ReconDynMapArray[4].x = 513;
	ReconDynMapArray[4].y = 159;
	ReconDynMapArray[4].RoomDesc = "ReconMapChineRoom5";

	ReconDynMapArray[5].x = 448;
	ReconDynMapArray[5].y = 146;
	ReconDynMapArray[5].RoomDesc = "ReconMapChineRoom6";

	ReconDynMapArray[6].x = 513;
	ReconDynMapArray[6].y = 118;
	ReconDynMapArray[6].RoomDesc = "ReconMapChineRoom7";
}

