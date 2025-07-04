class ECaisseEclats extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SFXCaisseEclats
        Acceleration=(Z=-350.000000)
        MaxParticles=25
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.010000,Max=-0.800000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=2.000000)
        StartSizeRange=(X=(Min=12.000000,Max=45.000000))
        UniformSize=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EGO_Tex.GenTexGO.SFX_Eclat_Bois2'
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-75.000000,Max=75.000000),Y=(Min=-75.000000,Max=75.000000),Z=(Min=100.000000,Max=200.000000))
        Name="SFXCaisseEclats"
    End Object
    Emitters(0)=SpriteEmitter'SFXCaisseEclats'
}