class EReconMapTibilisi extends ERecon;

function InitRecon()
{
	
    ReconType        = 2;
	ReconName        = "ReconNameMapTsi";
	ReconPicName     = Texture'HUD.RECON.rc_1_1_maptibilisi';
	ReconPreviewText = "ReconPTMapTsi";
	ReconText        = "";
	
	NbrOfCoord = 15;
		
	// Add manualy because of defined structure
	ReconDynMapArray.Length = ReconDynMapArray.Length + NbrOfCoord;
	
	// Map COORDinates for Tbilisi MAP
	ReconDynMapArray[0].x        = 355;
	ReconDynMapArray[0].y        = 120;
	ReconDynMapArray[0].RoomDesc = "ReconMapTsiRoom1";
		

	ReconDynMapArray[1].x = 338;
	ReconDynMapArray[1].y = 150;
	ReconDynMapArray[1].RoomDesc = "ReconMapTsiRoom2";

	ReconDynMapArray[2].x = 291;
	ReconDynMapArray[2].y = 147;
	ReconDynMapArray[2].RoomDesc = "ReconMapTsiRoom3";

	ReconDynMapArray[3].x = 307;
	ReconDynMapArray[3].y = 192;
	ReconDynMapArray[3].RoomDesc = "ReconMapTsiRoom4";

	ReconDynMapArray[4].x = 274;
	ReconDynMapArray[4].y = 221;
	ReconDynMapArray[4].RoomDesc = "ReconMapTsiRoom5";

	ReconDynMapArray[5].x = 323;
	ReconDynMapArray[5].y = 241;
	ReconDynMapArray[5].RoomDesc = "ReconMapTsiRoom6";

	ReconDynMapArray[6].x = 384;
	ReconDynMapArray[6].y = 247;
	ReconDynMapArray[6].RoomDesc = "ReconMapTsiRoom7";

	ReconDynMapArray[7].x = 411;
	ReconDynMapArray[7].y = 274;
	ReconDynMapArray[7].RoomDesc = "ReconMapTsiRoom8";

	ReconDynMapArray[8].x = 458;
	ReconDynMapArray[8].y = 240;
	ReconDynMapArray[8].RoomDesc = "ReconMapTsiRoom9";

	ReconDynMapArray[9].x = 355;
	ReconDynMapArray[9].y = 293;
	ReconDynMapArray[9].RoomDesc = "ReconMapTsiRoom10";

	ReconDynMapArray[10].x = 305;
	ReconDynMapArray[10].y = 265;
	ReconDynMapArray[10].RoomDesc = "ReconMapTsiRoom11";

	ReconDynMapArray[11].x = 255;
	ReconDynMapArray[11].y = 263;
	ReconDynMapArray[11].RoomDesc = "ReconMapTsiRoom12";

	ReconDynMapArray[12].x = 225;
	ReconDynMapArray[12].y = 238;
	ReconDynMapArray[12].RoomDesc = "ReconMapTsiRoom13";

	ReconDynMapArray[13].x = 179;
	ReconDynMapArray[13].y = 210;
	ReconDynMapArray[13].RoomDesc = "ReconMapTsiRoom14";

	ReconDynMapArray[14].x = 179;
	ReconDynMapArray[14].y = 270;
	ReconDynMapArray[14].RoomDesc = "ReconMapTsiRoom15";
}

