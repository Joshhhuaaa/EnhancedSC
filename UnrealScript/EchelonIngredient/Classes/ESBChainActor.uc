class ESBChainActor extends ESBRopeActor native placeable;

#exec OBJ LOAD FILE=..\Sounds\Metal.uax

var(SBChain) StaticMesh linkMesh;
var(SBChain) bool MakesAINoise;

event CollidedBy(Actor Instigator)
{
	if ( !IsPlaying(Sound'Metal.Play_Random_ChainChink') )
		PlaySound(Sound'Metal.Play_Random_ChainChink', SLOT_SFX);

	if (MakesAINoise)
		MakeNoise( 500.0, NOISE_DoorOpening );
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum, class<DamageType> DamageType, optional int PillTag )
{
	Super.TakeDamage( Damage, EventInstigator, HitLocation, HitNormal, Momentum, DamageType, PillTag );

	if ( !IsPlaying(Sound'Metal.Play_Random_ChainChink') )
		PlaySound(Sound'Metal.Play_Random_ChainChink', SLOT_SFX);
}

