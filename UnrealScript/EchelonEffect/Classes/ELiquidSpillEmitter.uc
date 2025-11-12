class ELiquidSpillEmitter extends Emitter;

#exec OBJ LOAD FILE=..\Sounds\Water.uax

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetBase(Owner);
	PlaySound(Sound'Water.Play_barrilFuelLeak', SLOT_SFX);
}

state s_DyingSpill
{
	function Tick(float deltaTime)
	{
		Emitters[0].MaxAbsVelocity.X -= DeltaTime * 100;

		//Log(Emitters[0].MaxAbsVelocity.X);

		if (Emitters[0].MaxAbsVelocity.X <= 0)
		{
			PlaySound(Sound'Water.Stop_barrilFuelLeak', SLOT_SFX);
			Destroy();
		}
	}
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=LiquidParticle
        UseDirectionAs=PTDU_Up
        Acceleration=(Z=-1900.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        CoordinateSystem=PTCS_Relative
        MaxParticles=40
        UseSizeScale=True
        StartSizeRange=(Y=(Min=6.000000,Max=6.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.water.SFX_oilspark'
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=0.470000,Max=0.470000)
        StartVelocityRange=(X=(Min=200.000000,Max=200.000000))
        MaxAbsVelocity=(X=300.000000)
        Name="LiquidParticle"
    End Object
    Emitters(0)=SpriteEmitter'LiquidParticle'
}