class EBloodSplat extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter27
        Acceleration=(Z=-100.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.200000
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        UniformSize=True
        InitialParticlesPerSecond=160.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.blood.SFX_blood'
        LifetimeRange=(Max=2.000000)
        StartVelocityRange=(X=(Min=400.000000,Max=400.000000),Z=(Min=10.000000,Max=30.000000))
        VelocityLossRange=(X=(Min=20.000000,Max=30.000000))
        Name="SpriteEmitter27"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter27'
    bUnlit=False
}