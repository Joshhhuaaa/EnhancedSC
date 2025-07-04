class EActorBurn extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Fire0
        UseColorScale=True
        ColorScale(0)=(Color=(B=103,G=235,R=254))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=58,G=170,R=252))
        FadeOut=True
        FadeInEndTime=0.150000
        MaxParticles=15
        ResetAfterChange=True
        SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.750000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.200000)
        SizeScaleRepeats=6.000000
        StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
        UniformSize=True
        Texture=Texture'ETexSFX.smoke.Brown_Dust'
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=0.250000,Max=0.250000)
        StartVelocityRange=(Z=(Min=-50.000000,Max=-50.000000))
        GlowScale=(B=127,G=127,R=127,A=127)
        IsGlowing=True
        Name="Fire0"
    End Object
    Emitters(0)=SpriteEmitter'Fire0'
    Begin Object Class=SpriteEmitter Name=Fire1
        UseColorScale=True
        ColorScale(0)=(Color=(B=57,G=154,R=242))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=52,G=174,R=226))
        FadeOutStartTime=0.050000
        FadeOut=True
        FadeIn=True
        MaxParticles=75
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.050000),Y=(Min=-0.050000,Max=0.050000),Z=(Min=-0.050000,Max=0.050000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.200000,RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.050000)
        StartSizeRange=(X=(Min=100.000000,Max=100.000000),Y=(Min=100.000000,Max=100.000000),Z=(Min=100.000000,Max=100.000000))
        UniformSize=True
        Texture=Texture'ETexSFX.smoke.Brown_Dust'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(Z=(Max=150.000000))
        GlowScale=(B=127,G=127,R=127,A=127)
        IsGlowing=True
        Name="Fire1"
    End Object
    Emitters(1)=SpriteEmitter'Fire1'
}