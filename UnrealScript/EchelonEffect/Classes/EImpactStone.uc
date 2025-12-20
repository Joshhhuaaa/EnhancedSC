class EImpactStone extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ImpactStone
        Acceleration=(Z=-500.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=5
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-5.000000,Max=5.000000))
        StartSizeRange=(X=(Min=0.250000,Max=2.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.WallImpact.SFX_WallBrick'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
        Name="ImpactStone"
    End Object
    Emitters(0)=SpriteEmitter'ImpactStone'
    bUnlit=False
}