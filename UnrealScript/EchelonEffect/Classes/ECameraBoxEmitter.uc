class ECameraBoxEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        Acceleration=(Z=2.000000)
        FadeOutStartTime=0.100000
        FadeOut=True
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=5
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.050000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.250000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000))
        UniformSize=True
        InitialParticlesPerSecond=2000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Darken
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        LifetimeRange=(Min=1.000000,Max=7.000000)
        StartVelocityRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Max=10.000000))
        Name="SpriteEmitter7"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter7'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        MaxParticles=1
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=25.000000,Max=25.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.Fire.SFX_WalMineEX'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.600000,Max=0.600000)
        StartVelocityRange=(X=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        IsGlowing=True
        Name="SpriteEmitter8"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter8'
    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=0.050000,Max=0.050000)
        TimeBeforeVisibleRange=(Min=0.050000,Max=0.050000)
        TimeBetweenSegmentsRange=(Min=0.001000,Max=0.075000)
        Acceleration=(Z=-980.000000)
        UseCollision=True
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=199,G=102,R=65))
        ColorScaleRepeats=2.000000
        MaxParticles=5
        UseRotationFrom=PTRS_Actor
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.SFX_spark'
        LifetimeRange=(Min=1.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=50.000000,Max=500.000000))
        IsGlowing=True
        Name="SparkEmitter1"
    End Object
    Emitters(2)=SparkEmitter'SparkEmitter1'
}