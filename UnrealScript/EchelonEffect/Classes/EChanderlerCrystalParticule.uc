class EChanderlerCrystalParticule extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=ChanderlerCrystalParticule
        StaticMesh=StaticMesh'EMeshSFX.Item.ChanderlerCrystalParticule'
        Acceleration=(Z=-980.000000)
        UseCollision=True
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=5
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=250.000000,Max=500.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        Name="ChanderlerCrystalParticule"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.ChanderlerCrystalParticule'
    bUnlit=false
}