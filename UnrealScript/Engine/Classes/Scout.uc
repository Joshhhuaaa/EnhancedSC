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
    AccelRate=1.000000
    CollisionRadius=52.000000
    bCollideActors=False
    bCollideWorld=False
    bBlockPlayers=False
    bBlockActors=False
    bPathColliding=True
}