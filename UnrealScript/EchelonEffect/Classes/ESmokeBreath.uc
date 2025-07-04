class ESmokeBreath extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SmokeBreath
        Acceleration=(X=-30.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=44,G=44,R=44))
        ColorScale(1)=(RelativeTime=5.000000)
        FadeOutStartTime=0.200000
        FadeOut=True
        FadeInEndTime=0.010000
        MaxParticles=4
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=1.000000,Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.050000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.900000)
        StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=10.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=20.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=2.500000,Max=2.500000)
        StartVelocityRange=(Y=(Min=-18.000000,Max=-20.000000))
        Name="SmokeBreath"
    End Object
    Emitters(0)=SpriteEmitter'SmokeBreath'
}