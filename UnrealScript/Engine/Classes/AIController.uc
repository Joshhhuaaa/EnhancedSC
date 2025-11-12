//=============================================================================
// AIController, the base class of AI.
//
// Controllers are non-physical actors that can be attached to a pawn to control 
// its actions.  AIControllers implement the artificial intelligence for the pawns they control.  
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class AIController extends Controller
	native;


event PreBeginPlay()
{
	Super.PreBeginPlay();
	if (bDeleteMe)
		return;

	if (Level.Game != None)
		Skill += Level.Game.Difficulty; 
	Skill = FClamp(Skill, 0, 3);
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();

	// by default destroy bots (let game re-create)
	if (bIsPlayer)
		Destroy();
}

	
/* DisplayDebug()
list important controller attributes on canvas
*/
function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local int i;
	local string T;

	Super.DisplayDebug(Canvas,YL, YPos);

	Canvas.DrawColor.B = 255;	

	/*** UBI MODIF : removing unnecessary debug shit

	Canvas.DrawText("      NAVIGATION MoveTarget "$GetItemName(String(MoveTarget))$" PendingMover "$PendingMover$" MoveTimer "$MoveTimer, false);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	
	Canvas.DrawText("      Destination "$Destination$" Focus "$GetItemName(string(Focus)), false);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	******************************************************/

	Canvas.DrawText("      NAVIGATION RouteGoal "$GetItemName(string(RouteGoal))$" RouteDist "$RouteDist, false);
	YPos += YL;
	Canvas.SetPos(4,YPos);

	for (i = 0; i < 16; i++)
	{
		if (RouteCache[i] == None)
		{
			if (i > 5)
				T = T$"--"$GetItemName(string(RouteCache[i - 1]));
			break;
		}
		else if (i < 5)
			T = T$GetItemName(string(RouteCache[i]))$"-";
	}

	Canvas.DrawText("RouteCache: "$T, false);
}


/* UpdateTactics() - called every 0.5 seconds if bAdvancedTactics is true and is 
performing a latent MoveToward() */
event UpdateTactics()
{
	if (bTacticalDir)
	{
		bTacticalDir = false;
		bNoTact = (FRand() < 0.3);
	}
	else
	{
		bTacticalDir = true;
		bNoTact = (FRand() < 0.3);
	}
}


/* PrepareForMove()
Give controller a chance to prepare for a move along the navigation network, from
Anchor (current node) to Goal, given the reachspec for that movement.

Called if the reachspec doesn't support the pawn's current configuration.
By default, the pawn will crouch when it hits an actual obstruction. However,
Pawns with complex behaviors for setting up their smaller collision may want
to call that behavior from here
*/
event PrepareForMove(NavigationPoint Goal, ReachSpec Path);

defaultproperties
{
    bCanOpenDoors=true
    bCanDoSpecial=true
    MinHitWall=-0.500000
}