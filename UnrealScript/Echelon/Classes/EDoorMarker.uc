//=============================================================================
// EDoorMarker
//
//		Used to mark the actual DoorMover's exact initial location.
//		Useful as an intermediary for navigation and for telling door to stay open when someone is navigating nearby.
//
//=============================================================================


class EDoorMarker extends NavigationPoint
	notplaceable
	native;


var bool bHasNoDoorPoints;	// true if no door points are connected to it, so AI can not utilize

var	EDoorMover Door;		// pointer to the door mover which we refer to





//---------------------------------------[David Kalina - 27 Nov 2001]-----
// 
// Description
//		Notification when a Pawn is entering our radius.
//		Send a message to the EAIController.
// 
//------------------------------------------------------------------------

function PawnEnteringRadius(ePawn TouchingPawn)
{
	if (bHasNoDoorPoints)
		return;

	if (!TouchingPawn.Controller.bIsPlayer)
	{
		// make sure Pawn is really ENTERING (heading in direction of Door) ..
		// plog(Level.TimeSeconds @ "door to pawn : " $ Normal(Door.myMarker.Location - TouchingPawn.Location) @ TouchingPawn $ ".velocity:  " $ Normal(TouchingPawn.Velocity));
		if (Normal(Door.myMarker.Location - TouchingPawn.Location) dot Normal(TouchingPawn.Velocity) > 0)
		{
			//plog("dotproduct:   "  $  Normal(Door.myMarker.Location - TouchingPawn.Location) dot Normal(TouchingPawn.Velocity) $ TouchingPawn $ " entering door radius.");
			EAIController(TouchingPawn.Controller).EnteringDoorRadius(Door);
		}
	}
}

//---------------------------------------[David Kalina - 27 Nov 2001]-----
// 
// Description
//		Notification when a Pawn is leaving our radius.
//		Send a message to the EAIController.
// 
//------------------------------------------------------------------------

function PawnLeavingRadius(ePawn LeavingPawn)
{
	if (bHasNoDoorPoints)
		return;

	// Joshua - Added third condition: Only clear SpecialMoveDoor in LeavingDoorRadius() when leaving the pawn's active SpecialMoveDoor
	if (LeavingPawn.Controller != none && !LeavingPawn.Controller.bIsPlayer && EAIController(LeavingPawn.Controller).SpecialMoveDoor == Door)
		EAIController(LeavingPawn.Controller).LeavingDoorRadius();
}

//---------------------------------------[David Kalina - 25 Nov 2001]-----
// 
// Description
//		Whenever a Pawn comes into our range, we send an impulse
//		to the Door to tell it to stay open for now.
//
//------------------------------------------------------------------------

auto state s_Untouched
{
	event Touch(Actor Other)
	{
		local Actor A;
		
		if (Other.bIsPawn /*&& !Other.bIsPlayerPawn*/)
		{			
			// EPawn is entering our radius
			PawnEnteringRadius(ePawn(Other));

			GotoState('s_Touched');
		}
	}
}



state s_Touched
{
	event Touch(Actor Other)
	{
		local Actor A;
		
		if (Other.bIsPawn)
		{			
			//plog("Touched by : " $ Other);
			
			// EPawn is entering our radius
			PawnEnteringRadius(ePawn(Other));
		}
	}

	Event UnTouch(Actor Other)
	{
		local Actor A;
		
		if (Other.bIsPawn)
		{
			//plog("Untouched by : " $ Other);
			PawnLeavingRadius(ePawn(Other));
		}

		foreach TouchingActors(class'Actor', A)
		{
			// discount Other if still in the Touching array
			if (A.bIsPawn && A != Other)
			{
				//plog("		TouchingActors Array includes : " $ A);
				return;
			}
		}
		
		GotoState('s_Untouched');
	}

	function Tick(float deltaTime)
	{
		local EPawn   EP;
        local bool    pawnOpen, playerOpen;
		local vector  dist2D;

		//plog("tick: "@ Door @ Door.IsOpened() @ !Door.bOpening @ !Door.bClosing);

		if (Door != none && Door.IsOpened() && !Door.bOpening && !Door.bClosing)
		{
			//plog("STAY OPEN DOOR!");
			
            // Force staying open if there is an Pawn touching the DoorMarker
 			foreach TouchingActors(class'EPawn', EP)
			{
				if (EP.bIsPlayerPawn)
				{
					dist2D = EP.Location - Location;
					dist2D.Z = 0.0;
					if (EP.Health > 0 &&
						VSize(dist2D) < 140.0)	// should be PlayerKeepOpenRadius
						playerOpen = true;
				}
                else
                {
					// Don't stay open for dead ppl
					if (!EP.bOrientOnSlope && (EP.GetStateName() != 's_Carry') && (EP.GetStateName() != 's_Grabbed'))
						pawnOpen = true;
                }
			}
			Door.StayOpen(Door, pawnOpen, playerOpen);
		}
	}
}

defaultproperties
{
    bAutoPlaced=True
    bDoNotUseAsHidePoint=True
    bStatic=False
    bCollideWhenPlacing=False
    CollisionRadius=200.000000
    bCollideActors=True
    bCollideWorld=False
    bIsNavMarker=True
}