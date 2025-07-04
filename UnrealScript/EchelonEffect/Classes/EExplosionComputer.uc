class EExplosionComputer extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ExplosionComputer
        FadeOutStartTime=1.000000
        FadeOut=True
        MaxParticles=3
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.250000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=400.000000)
        SizeScale(2)=(RelativeTime=3.000000,RelativeSize=100.000000)
        StartSizeRange=(X=(Min=0.020000,Max=0.100000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.ExplodeDoors'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        InitialTimeRange=(Min=10.000000,Max=10.000000)
        LifetimeRange=(Min=0.400000,Max=0.500000)
        StartVelocityRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000))
        Name="ExplosionComputer"
    End Object
    Emitters(0)=SpriteEmitter'ExplosionComputer'
}