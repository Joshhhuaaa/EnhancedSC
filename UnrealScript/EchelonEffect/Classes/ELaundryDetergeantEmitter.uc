class ELaundryDetergeantEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=LaundryDetergeantEmitter
        StaticMesh=StaticMesh'EMeshSFX.Item.Detergeant_spray_01PART'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=1
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        DampRotation=True
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=100.000000,Max=100.000000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=100.000000))
        Name="LaundryDetergeantEmitter"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.LaundryDetergeantEmitter'
    bUnlit=False
}