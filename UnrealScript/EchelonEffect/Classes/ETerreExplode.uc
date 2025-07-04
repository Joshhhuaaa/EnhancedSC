class ETerreExplode extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=TerreExplode
        Acceleration=(Z=-980.000000)
        FadeOutStartTime=-1.000000
        FadeOut=True
        MaxParticles=20
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.001000,Max=-0.500000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=20.000000,Max=30.000000))
        UniformSize=True
        InitialParticlesPerSecond=20000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.SFX_Terre'
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=50.000000,Max=400.000000))
        VelocityLossRange=(X=(Max=5.000000),Y=(Max=5.000000),Z=(Max=1.000000))
        Name="TerreExplode"
    End Object
    Emitters(0)=SpriteEmitter'TerreExplode'
}