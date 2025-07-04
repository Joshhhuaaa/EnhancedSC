class EPaintingLamp extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=paintinglamp
        StaticMesh=StaticMesh'EMeshSFX.Item.paintinglampPARTS'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.001000,Max=0.250000),Y=(Min=0.001000,Max=0.250000),Z=(Min=0.001000,Max=0.250000))
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
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=250.000000,Max=500.000000))
        Name="paintinglamp"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.paintinglamp'
}