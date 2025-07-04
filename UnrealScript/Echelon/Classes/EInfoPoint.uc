//=============================================================================
// EInfoPoint
//		
//		Marker class used by Level Designers to specify points of interest
//		for AI Non-Player Characters.
//
//		Can be used to specify a series of information:
//			bFocusPoint (look here during investigation)
//			bCoverPoint (take cover here when necessary)
//			bCornerPoint (placed on a corner, AI will use for strategic attacks)
//
//=============================================================================


class EInfoPoint extends Keypoint
	native
	notplaceable;



var			 bool		bLocked;

var(AI_Info) bool		bFocusPoint;
var(AI_Info) bool		bCoverPoint;
var(AI_Info) bool		bCornerPoint;

var(AI_Info) MoveFlags	ForcedWaitFlags;
var(AI_Info) float 		ForcedFocusTime;		// will attempt to make NPC use this focus point for this amount of time
var(AI_Info) float		FocusMaxDistance;		// max distance at which an NPC will take this point

var			 float		InternalFocusTimer,		// internal timer used to countdown until NPC should release its focus
						TimeStamp;				// set whenever locked so we don't keep looking at the same focus points	
					
	
	

var EInfoPoint NextInfoPoint;			// maintain list of AI info points in a map (not all Keypoints are included in this)


function PostBeginPlay()
{
	local EchelonLevelInfo ELevel;

	// add to front of info point list
	// todo : consider moving to preprocessing routine (path building, e.g.) -- probably not terribly important
	// the list is static, so as long as postbeginplay is only called once we should be okay.

	ELevel = EchelonLevelInfo(Level);

	if ( ELevel != none )
	{
		NextInfoPoint		 = ELevel.InfoPointList;
		ELevel.InfoPointList = self;
	}
	else
		log("WARNING : ELevel not valid in EInfoPoint PostBeginPlay.");
}

defaultproperties
{
    FocusMaxDistance=2000.000000
    bCollideWhenPlacing=true
}