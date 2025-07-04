class EDoorOpener extends EGameplayObject
	abstract
	native;

var	array<EDoorMover>	LinkedActors;		// Actors to be triggered (Light, DoorMover, EGameplayObject, etc ..)
var bool			bIsRetinalScanner;	// flags for quickly checking type of door opener
var bool			bIsKeypad;

//------------------------------------------------------------------------
// Description		
//		Since we may want more than one door for an opener (ex.: 2 sliding doors for a keypad)
//------------------------------------------------------------------------
function LinkActor( EDoorMover LinkedActor )
{
	LinkedActors[LinkedActors.Length] = LinkedActor;
}

//------------------------------------------------------------------------
// Description		
//		Triggers all actor in the list (from an opener)
//------------------------------------------------------------------------
function TriggerLinkedActors( Pawn PawnInstigator )
{
	local int i;
	for( i=0; i<LinkedActors.Length; i++ )
		LinkedActors[i].OpenerTrigger(self, PawnInstigator);
}

//------------------------------------------------------------------------
// Description		
//		Turn on/off interaction(s)
//------------------------------------------------------------------------
function ToggleInteraction( bool bOn )
{
	if( Interaction != None )
		Interaction.SetCollision(bOn);
}

defaultproperties
{
    bDamageable=false
}