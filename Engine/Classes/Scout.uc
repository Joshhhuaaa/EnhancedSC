//=============================================================================
// Scout used for path generation.
//=============================================================================
class Scout extends Pawn
	native;

var const float MaxLandingVelocity;

function PreBeginPlay()
{
	Destroy(); //scouts shouldn't exist during play
}

defaultproperties
{
    AccelRate=1.0000000
    CollisionRadius=52.0000000
    bCollideActors=false
    bCollideWorld=false
    bBlockPlayers=false
    bBlockActors=false
    bPathColliding=true
}