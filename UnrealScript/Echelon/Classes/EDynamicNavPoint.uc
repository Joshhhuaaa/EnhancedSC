//=============================================================================
// EDynamicNavPoint
//		Perhaps poorly named - really just a temporary object used for
//		circumventing navigation network and providing a reachable location
//=============================================================================


class EDynamicNavPoint extends NavigationPoint
	native;


//----------------------------------------[David Kalina - 2 May 2001]-----
// 
// Description
//		Code exists solely to make points visible when debugging nav points.
//		It checks the flag bDebugNavPoints in the EPlayerController
//
//------------------------------------------------------------------------

function PostBeginPlay()
{
	/*local EchelonGameInfo gameinfo;
		
	if ( Level != none && Level.Game != none ) 
	{
		gameinfo = EchelonGameInfo(Level.Game);

		if (gameinfo != none)
		{
			if ( gameinfo.pPlayer != none )
			{
				bHidden = !(gameinfo.pPlayer.bDebugNavPoints);
			}
		}
	}*/
}

defaultproperties
{
    bStatic=false
    bCollideWhenPlacing=false
    bCollideWorld=false
}