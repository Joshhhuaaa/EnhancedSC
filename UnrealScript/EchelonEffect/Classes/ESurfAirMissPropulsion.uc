class ESurfAirMissPropulsion extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter13
        ProjectionNormal=(Z=0.000000)
        Acceleration=(X=-5000.000000,Z=-6000.000000)
        FadeOut=True
        MaxParticles=120
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.750000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.200000)
        StartSizeRange=(X=(Min=40.000000,Max=40.000000))
        UniformSize=True
        InitialParticlesPerSecond=100.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.ExplodeDoors'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.099000,Max=0.100000)
        StartVelocityRange=(X=(Min=-1000.000000,Max=-1000.000000))
        Name="SpriteEmitter13"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter13'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter14
        Acceleration=(Z=10.000000)
        FadeOutStartTime=1.000000
        FadeOut=True
        FadeInEndTime=1.000000
        FadeIn=True
        MaxParticles=40
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=10.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=50.000000,Max=75.000000))
        UniformSize=True
        InitialParticlesPerSecond=40.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.SFX_expsmoke'
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=-300.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-90.000000,Max=-100.000000))
        Name="SpriteEmitter14"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter14'
}