class ELiquidElectricity extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter1
        StaticMesh=StaticMesh'EMeshSFX.weapon.Stiki_Bolt'
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=100
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=10.000000))
        SpinParticles=True
        StartSpinRange=(X=(Min=-20.000000,Max=20.000000))
        StartSizeRange=(X=(Min=0.001000),Y=(Min=0.001000),Z=(Min=0.001000,Max=2.000000))
        InitialParticlesPerSecond=10.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=0.001000,Max=0.100000)
        Name="MeshEmitter1"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.MeshEmitter1'
    bUnlit=false
}