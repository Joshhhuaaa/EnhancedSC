class ESprinklerWater extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SprinklerWater
        Acceleration=(Z=-400.000000)
        FadeOut=True
        FadeIn=True
        CoordinateSystem=PTCS_Relative
        MaxParticles=8
        AutoReset=True
        StartLocationRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.010000,Max=0.010000))
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.750000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=75.000000,Max=100.000000))
        UniformSize=True
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.water.WaterGicleur4'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        MinSquaredVelocity=1.000000
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        Name="SprinklerWater"
    End Object
    Emitters(0)=SpriteEmitter'SprinklerWater'
}