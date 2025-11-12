class EOilDrum extends ELiquidContainer;

#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

//------------------------------------------------------------------------
// Description		
//		For now, destroy drum, could be replaced with destroyed mesh
//------------------------------------------------------------------------
/*function Destructed()
{
	//Log("Destructed");
	GotoState('s_Flying');

	Super.Destructed();
}
*/
function ProcessFlaskTrigger(Pawn EventInstigator)
{
	Super.TakeDamage(HitPoints, EventInstigator, Location, Vect(0,0,1), Vect(0,0,0), None);
}
/*
//------------------------------------------------------------------------
// Final life stage for the barrel
//------------------------------------------------------------------------
state s_Flying
{
	Ignores TakeDamage;

	function BeginState()
	{
		local int i;
		local int j;

		//Log("EOilDrum .. flying beginState");

		Super.BeginState();

		Velocity = Vect(0,0,1200);
		RotationRate.Pitch=40000;
		RotationRate.Yaw=25000;
		RotationRate.Roll=15000;
	}

	function Tick(float DeltaTime)
	{
		if (Velocity.Z < 0)
		{
			Disable('Tick');
			SetTimer(0.5,false);
		}
	}

	function Timer()
	{
		HitWall(Vect(0,0,0), None);
	}

}
*/

defaultproperties
{
    FlaskEmitterClass=Class'EchelonEffect.EFlaskEmitter'
    SpillTexture=Texture'ETexSFX.water.SFX_oilspark'
    FlaskTexture=Texture'ETexSFX.water.SFX_oil'
    IsFlammable=true
    iDirtynessFactor=5
    bPushable=true
    bExplodeWhenDestructed=true
    HitPoints=300
    ExplosionClass=Class'EchelonEffect.EDrumExplosionParticle'
    StaticMesh=StaticMesh'EMeshIngredient.Object.oildrum'
    DrawScale=0.800000
    CollisionRadius=28.000000
    CollisionHeight=46.000000
    bCollideWorld=true
    bBlockPlayers=true
    bBlockActors=true
}