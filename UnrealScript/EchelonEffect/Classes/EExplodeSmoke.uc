class EExplodeSmoke extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ChoperExpldoeSmoke
        Acceleration=(Z=500.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=2.000000)
        FadeOut=True
        MaxParticles=25
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=5.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=50.000000,Max=250.000000))
        UniformSize=True
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Darken
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=5.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-5000.000000,Max=5000.000000),Y=(Min=-5000.000000,Max=5000.000000),Z=(Min=-1000.000000,Max=15000.000000))
        VelocityLossRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        Name="ChoperExpldoeSmoke"
    End Object
    Emitters(0)=SpriteEmitter'ChoperExpldoeSmoke'
}