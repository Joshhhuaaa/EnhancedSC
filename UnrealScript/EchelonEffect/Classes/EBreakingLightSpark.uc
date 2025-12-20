class EBreakingLightSpark extends Emitter;

defaultproperties
{
    Begin Object Class=SparkEmitter Name=LightSpark
        LineSegmentsRange=(Min=0.100000,Max=0.100000)
        TimeBetweenSegmentsRange=(Min=0.100000,Max=0.100000)
        Acceleration=(Z=-600.000000)
        MaxParticles=30
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-10.000000,Max=10.000000))
        StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
        InitialParticlesPerSecond=10000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.SFX_spark'
        LifetimeRange=(Min=0.100000,Max=3.000000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=-300.000000,Max=600.000000))
        Name="LightSpark"
    End Object
    Emitters(0)=SparkEmitter'LightSpark'
    Begin Object Class=SpriteEmitter Name=Glass
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.200000,Max=0.400000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=12
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=10.000000),Y=(Max=10.000000),Z=(Max=10.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=3.000000,Max=6.000000))
        UniformSize=True
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Window.SFX_BGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=600.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=200.000000))
        VelocityLossRange=(X=(Max=1.000000))
        Name="Glass"
    End Object
    Emitters(1)=SpriteEmitter'Glass'
    bUnlit=False
}