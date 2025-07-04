class ElightDarkSmoke extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=lightDarkSmoke
        Acceleration=(Z=-1.000000)
        FadeOutStartTime=0.500000
        FadeOut=True
        FadeInEndTime=0.500000
        FadeIn=True
        MaxParticles=20
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.001000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=12.000000,Max=50.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Darken
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        InitialTimeRange=(Min=15.000000,Max=15.000000)
        LifetimeRange=(Min=1.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Max=50.000000))
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000),Z=(Max=0.100000))
        Name="lightDarkSmoke"
    End Object
    Emitters(0)=SpriteEmitter'lightDarkSmoke'
}