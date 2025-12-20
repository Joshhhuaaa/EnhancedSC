class EMirrorspark extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Mirrorspark
        ProjectionNormal=(Z=0.000000)
        Acceleration=(Z=-1000.000000)
        UseCollision=True
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        DampingFactorRange=(X=(Min=0.001000,Max=0.500000),Y=(Min=0.001000,Max=0.400000),Z=(Min=0.001000,Max=0.200000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Z=(Min=-35.000000,Max=35.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.001000,Max=-0.500000))
        StartSizeRange=(X=(Max=4.000000))
        UniformSize=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Window.SFX_BGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.000001,Max=10.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-5.000000,Max=250.000000),Z=(Min=-100.000000,Max=500.000000))
        VelocityLossRange=(Y=(Max=5.000000),Z=(Max=-1.000000))
        Name="Mirrorspark"
    End Object
    Emitters(0)=SpriteEmitter'Mirrorspark'
    bUnlit=False
}