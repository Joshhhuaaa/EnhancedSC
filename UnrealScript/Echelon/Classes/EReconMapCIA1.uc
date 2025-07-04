class EReconMapCIA1 extends ERecon;

function InitRecon()
{
	
    ReconType        = 2;
	ReconName        = "ReconNameMapCIA1";
	ReconPicName     = Texture'HUD.RECON.rc_2_1_CIA1';
	ReconPreviewText = "ReconPTMapCIA1";
	ReconText        = "";
	
	NbrOfCoord = 11;
		
	// Add manualy because of defined structure
	ReconDynMapArray.Length = ReconDynMapArray.Length + NbrOfCoord;
	
	// Map COORDinates for Tbilisi MAP
	ReconDynMapArray[0].x        = 94;
	ReconDynMapArray[0].y        = 207;
	ReconDynMapArray[0].RoomDesc = "ReconMapCIA1Room1";
		

	ReconDynMapArray[1].x = 135;
	ReconDynMapArray[1].y = 170;
	ReconDynMapArray[1].RoomDesc = "ReconMapCIA1Room2";

	ReconDynMapArray[2].x = 159;
	ReconDynMapArray[2].y = 212;
	ReconDynMapArray[2].RoomDesc = "ReconMapCIA1Room3";

	ReconDynMapArray[3].x = 225;
	ReconDynMapArray[3].y = 212;
	ReconDynMapArray[3].RoomDesc = "ReconMapCIA1Room4";

	ReconDynMapArray[4].x = 250;
	ReconDynMapArray[4].y = 193;
	ReconDynMapArray[4].RoomDesc = "ReconMapCIA1Room5";

	ReconDynMapArray[5].x = 296;
	ReconDynMapArray[5].y = 259;
	ReconDynMapArray[5].RoomDesc = "ReconMapCIA1Room6";

	ReconDynMapArray[6].x = 372;
	ReconDynMapArray[6].y = 261;
	ReconDynMapArray[6].RoomDesc = "ReconMapCIA1Room7";

	ReconDynMapArray[7].x = 339;
	ReconDynMapArray[7].y = 145;
	ReconDynMapArray[7].RoomDesc = "ReconMapCIA1Room8";

	ReconDynMapArray[8].x = 403;
	ReconDynMapArray[8].y = 174;
	ReconDynMapArray[8].RoomDesc = "ReconMapCIA1Room9";

	ReconDynMapArray[9].x = 477;
	ReconDynMapArray[9].y = 223;
	ReconDynMapArray[9].RoomDesc = "ReconMapCIA1Room10";

	ReconDynMapArray[10].x = 538;
	ReconDynMapArray[10].y = 245;
	ReconDynMapArray[10].RoomDesc = "ReconMapCIA1Room11";
}

