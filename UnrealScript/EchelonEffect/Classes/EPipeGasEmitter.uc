class EPipeGasEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=GasPipe
        Acceleration=(X=100.000000,Z=100.000000)
        UseCollision=True
        ExtentMultiplier=(X=50.000000,Y=50.000000,Z=50.000000)
        DampingFactorRange=(X=(Min=0.500000),Y=(Min=0.500000),Z=(Min=0.500000))
        UseColorScale=True
        ColorScale(0)=(Color=(B=179,G=205,R=206))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=21,G=21,R=21))
        FadeOutStartTime=0.500000
        FadeOut=True
        FadeInEndTime=0.500000
        FadeIn=True
        MaxParticles=50
        ResetAfterChange=True
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        Texture=Texture'ETexSFX.smoke.CO21'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=100.000000),Y=(Min=-2.000000,Max=2.000000))
        Name="GasPipe"
    End Object
    Emitters(0)=SpriteEmitter'GasPipe'
}