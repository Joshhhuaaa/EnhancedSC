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
	// make sure not touching through wall
	if(Other.bIsPlayerPawn && Trace(HitNormal, HitLocation, Other.Location, Location, true, vect(0,0,0)) == Other)
	{
		ConsoleCommand("TRAVEL MAPNAME="$URL@"ITEMS="$bTravel);
		EPlayerController(EPawn(Other).Controller).playerStats.OnLevelChange(); // Joshua - For mission statistics, saves the mission time from the previous part
	}
}  

defaultproperties
{
    bTravel=true
    bHidden=true
    bCollideActors=true
}