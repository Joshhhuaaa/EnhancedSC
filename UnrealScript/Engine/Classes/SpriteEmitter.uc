//=============================================================================
// Emitter: An Unreal Sprite Particle Emitter.
//=============================================================================
class SpriteEmitter extends ParticleEmitter
	native;


enum EParticleDirectionUsage
{
	PTDU_None,
	PTDU_Up,
	PTDU_Right,
	PTDU_Forward,
	PTDU_Normal,
	PTDU_UpAndNormal,
	PTDU_RightAndNormal
};


var (Sprite)		EParticleDirectionUsage		UseDirectionAs;
var (Sprite)		vector						ProjectionNormal;

var notextexport vector						RealProjectionNormal;

defaultproperties
{
    ProjectionNormal=(X=0.000000,Y=0.000000,Z=1.000000)
}