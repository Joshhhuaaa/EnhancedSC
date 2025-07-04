class EReconMapMinistry extends ERecon;

function InitRecon()
{
	
    ReconType        = 2;
	ReconName        = "ReconNameMapMin";
	ReconPicName     = Texture'HUD.RECON.rc_1_2_MinistryMap2';
	ReconPreviewText = "ReconPTMapMin";
	ReconText        = "";
	
	NbrOfCoord = 2;
		
	// Add manualy because of defined structure
	ReconDynMapArray.Length = ReconDynMapArray.Length + NbrOfCoord;
		
	// Map COORDinates for Tbilisi MAP
	ReconDynMapArray[0].x = 194;
	ReconDynMapArray[0].y = 159;
	ReconDynMapArray[0].RoomDesc = "ReconMapMinRoom1";
		

	ReconDynMapArray[1].x = 428;
	ReconDynMapArray[1].y = 147;
	ReconDynMapArray[1].RoomDesc = "ReconMapMinRoom2";
}

