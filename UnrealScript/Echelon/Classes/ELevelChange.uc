//
// Level Change
// When triggered causes change to level described in URL
//
class ELevelChange extends Actor placeable;

var() string URL;
var() bool   bTravel;

function Touch(actor Other)
{
	local vector HitNormal, HitLocation;
	// Make sure not touching through wall
	// Joshua - Bug fix: Added health check (used in EPattern's LevelChange function)
	if (Other.bIsPlayerPawn && Pawn(Other).Health > 0 && Trace(HitNormal, HitLocation, Other.Location, Location, true, vect(0,0,0)) == Other)
	{
		// Joshua - Bug fix: Don't travel if the player has reached alarm limit
		if (EchelonLevelInfo(Level).bIgnoreAlarmStage || EchelonLevelInfo(Level).AlarmStage != 4 ||
		  (EchelonGameInfo(Level.Game).bEliteMode && EchelonLevelInfo(Level).AlarmStage != 3))
		{
			ConsoleCommand("TRAVEL MAPNAME="$URL@"ITEMS="$bTravel);
			EPlayerController(EPawn(Other).Controller).playerStats.OnLevelChange(); // Joshua - For player statistics, saves the mission time from the previous part
		}
	}
}

defaultproperties
{
    bTravel=True
    bHidden=True
    bCollideActors=True
}