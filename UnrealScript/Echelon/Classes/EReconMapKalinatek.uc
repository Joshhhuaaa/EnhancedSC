class EReconMapKalinatek extends ERecon;

function InitRecon()
{
	
    ReconType        = 2;
	ReconName        = "ReconNameMapKali";
	ReconPicName     = Texture'HUD.RECON.rc_2_2_mapkalinatek';
	ReconPreviewText = "ReconPTMapKali";
	ReconText        = "";
	
	NbrOfCoord = 6;
		
	// Add manualy because of defined structure
	ReconDynMapArray.Length = ReconDynMapArray.Length + NbrOfCoord;
		
	// Map COORDinates for Tbilisi MAP
	ReconDynMapArray[0].x = 175;
	ReconDynMapArray[0].y = 214;
	ReconDynMapArray[0].RoomDesc = "ReconMapKaliRoom1";
		
	ReconDynMapArray[1].x = 352;
	ReconDynMapArray[1].y = 184;
	ReconDynMapArray[1].RoomDesc = "ReconMapKaliRoom2";

	ReconDynMapArray[2].x = 430;
	ReconDynMapArray[2].y = 192;
	ReconDynMapArray[2].RoomDesc = "ReconMapKaliRoom3";

	ReconDynMapArray[3].x = 299;
	ReconDynMapArray[3].y = 287;
	ReconDynMapArray[3].RoomDesc = "ReconMapKaliRoom4";

	ReconDynMapArray[4].x = 434;
	ReconDynMapArray[4].y = 287;
	ReconDynMapArray[4].RoomDesc = "ReconMapKaliRoom5";

	ReconDynMapArray[5].x = 291;
	ReconDynMapArray[5].y = 121;
	ReconDynMapArray[5].RoomDesc = "ReconMapKaliRoom6";
}

