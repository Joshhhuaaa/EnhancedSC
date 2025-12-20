class EPowderDetergeantEmitter extends Emitter;

defaultproperties
{
    Emitters(0)=none
    Begin Object Class=SpriteEmitter Name=PowderDetergeantEmitter1
        Acceleration=(Z=-20.000000)
        ColorScale(0)=(RelativeTime=1.000000)
        ColorScale(1)=(RelativeTime=2.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=1.000000
        FadeOut=True
        FadeInEndTime=1.000000
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.010000,Max=0.010000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Max=2.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.snow.SFX_Snow_Push'
        LifetimeRange=(Min=1.000000)
        StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-5.000000,Max=40.000000))
        VelocityLossRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=2.000000,Max=4.000000))
        Name="PowderDetergeantEmitter1"
    End Object
    Emitters(1)=SpriteEmitter'PowderDetergeantEmitter1'
    bUnlit=False
}