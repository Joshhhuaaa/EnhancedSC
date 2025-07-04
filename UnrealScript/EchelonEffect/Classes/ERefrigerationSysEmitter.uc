class ERefrigerationSysEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=RefrigerationSystem
        Acceleration=(X=-100.000000,Z=50.000000)
        ExtentMultiplier=(X=50.000000,Y=50.000000,Z=50.000000)
        DampingFactorRange=(X=(Min=0.500000),Y=(Min=0.500000),Z=(Min=0.500000))
        UseColorScale=True
        ColorScale(0)=(Color=(B=239,G=239,R=231))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=21,G=21,R=21))
        FadeOutStartTime=0.500000
        FadeOut=True
        FadeInEndTime=0.500000
        FadeIn=True
        MaxParticles=200
        ResetAfterChange=True
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=25.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.smoke.CO21'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=-100.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
        Name="RefrigerationSystem"
    End Object
    Emitters(0)=SpriteEmitter'RefrigerationSystem'
}