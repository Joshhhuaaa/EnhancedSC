class EPawnFire extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=PawnFire0
        UseColorScale=True
        ColorScale(0)=(Color=(B=114,G=154,R=242))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=84,G=174,R=226))
        FadeOutStartTime=0.050000
        FadeOut=True
        FadeIn=True
        MaxParticles=25
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
        ThermalVisionFallbackDrawStyle=PTDS_AlphaBlend
        ThermalVisionFallbackTexture=Texture'ETexSFX.smoke.Brown_Dust_TV'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(Z=(Max=150.000000))
        IsGlowing=True
        Name="PawnFire0"
    End Object
    Emitters(0)=SpriteEmitter'PawnFire0'
}