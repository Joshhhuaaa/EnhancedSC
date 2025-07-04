class EExplosion extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Explosion
        Acceleration=(Z=50.000000)
        FadeOutStartTime=0.900000
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.010000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=300.000000,Max=300.000000),Y=(Min=300.000000,Max=300.000000),Z=(Min=300.000000,Max=300.000000))
        UniformSize=True
        InitialParticlesPerSecond=20.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.ExplodeDoors'
        ThermalVisionFallbackDrawStyle=PTDS_AlphaBlend
        ThermalVisionFallbackTexture=Texture'ETexSFX.Fire.ExplodeDoors_TV'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=0.500000,Max=0.500000)
        StartVelocityRange=(X=(Min=-1700.000000,Max=1700.000000),Y=(Min=-1700.000000,Max=1700.000000),Z=(Max=700.000000))
        IsGlowing=True
        Name="Explosion"
    End Object
    Emitters(0)=SpriteEmitter'Explosion'
}