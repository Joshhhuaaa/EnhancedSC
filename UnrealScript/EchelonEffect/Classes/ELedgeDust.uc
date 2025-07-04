class ELedgeDust extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Dust0
        Acceleration=(Y=1.000000,Z=-1.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=20,G=30,R=40))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=80,G=80,R=80))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.750000
        FadeOut=True
        FadeInEndTime=0.250000
        FadeIn=True
        RespawnDeadParticles=False
        StartLocationRange=(Y=(Min=-5.000000,Max=5.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.001000,Max=0.010000))
        StartSpinRange=(X=(Min=1.000000,Max=5.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.300000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000))
        UniformSize=True
        InitialParticlesPerSecond=10.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=-1.500000,Max=-2.000000))
        VelocityLossRange=(Z=(Min=0.200000,Max=0.250000))
        Name="Dust0"
    End Object
    Emitters(0)=SpriteEmitter'Dust0'
    Begin Object Class=SpriteEmitter Name=Dust1
        UseColorScale=True
        ColorScale(0)=(RelativeTime=1.000000,Color=(B=59,G=59,R=59))
        ColorScale(1)=(RelativeTime=4.000000,Color=(B=25,G=25,R=25))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=2.000000
        FadeOut=True
        FadeInEndTime=0.500000
        FadeIn=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(Y=(Min=-5.000000,Max=5.000000),Z=(Min=1.000000,Max=1.000000))
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=4.000000)
        StartSizeRange=(X=(Max=2.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.SFX_Terre'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.500000,Max=1.000000)
        StartVelocityRange=(Y=(Min=1.000000,Max=5.000000),Z=(Min=-10.000000,Max=-15.000000))
        Name="Dust1"
    End Object
    Emitters(1)=SpriteEmitter'Dust1'
    bUnlit=false
}