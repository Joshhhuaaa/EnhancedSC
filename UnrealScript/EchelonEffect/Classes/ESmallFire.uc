class ESmallFire extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=FireSmall
        Acceleration=(Z=20.000000)
        FadeOutStartTime=1.000000
        FadeOut=True
        FadeInEndTime=0.500000
        FadeIn=True
        RespawnDeadParticles=False
        StartLocationRange=(Z=(Max=5.000000))
        AddLocationFromOtherEmitter=-50
        StartLocationShape=PTLS_Sphere
        StartMassRange=(Min=50.000000,Max=50.000000)
        UseRotationFrom=PTRS_Normal
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=20.000000,Max=20.000000))
        UniformSize=True
        Texture=Texture'ETexSFX.Fire.FireSam'
        ThermalVisionFallbackDrawStyle=PTDS_AlphaBlend
        ThermalVisionFallbackTexture=Texture'ETexSFX.Fire.FireSam_TV'
        TextureUSubdivisions=5
        TextureVSubdivisions=5
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(Z=(Min=20.000000,Max=30.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=0.100000),Y=(Min=1.000000,Max=0.100000))
        Name="FireSmall"
    End Object
    Emitters(0)=SpriteEmitter'FireSmall'
}