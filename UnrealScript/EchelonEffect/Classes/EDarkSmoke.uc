class EDarkSmoke extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=DarkSmoke
        Acceleration=(Z=-1.000000)
        FadeOutStartTime=0.500000
        FadeOut=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.025000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=350.000000,Max=400.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Darken
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        LifetimeRange=(Min=1.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Min=-25.000000,Max=150.000000))
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000),Z=(Max=0.100000))
        Name="DarkSmoke"
    End Object
    Emitters(0)=SpriteEmitter'DarkSmoke'
}