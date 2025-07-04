class EImpactWood extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ImpactWood
        Acceleration=(Z=-500.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.500000))
        StartSizeRange=(X=(Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.WallImpact.SFX_Wallwood'
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
        Name="ImpactWood"
    End Object
    Emitters(0)=SpriteEmitter'ImpactWood'
    bUnlit=false
}