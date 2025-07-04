class EIceEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=IceEmitter
        StaticMesh=StaticMesh'EMeshSFX.snow.Ice_Fragment'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        ExtentMultiplier=(Z=-0.500000)
        DampingFactorRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
        SpawnedVelocityScaleRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=0.250000))
        MaxParticles=25
        SpinParticles=True
        RotationOffset=(Pitch=10,Yaw=10,Roll=10)
        SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        RotationNormal=(X=10.000000,Y=10.000000,Z=10.000000)
        StartSizeRange=(X=(Min=0.100000,Max=1.100000),Y=(Min=0.100000,Max=1.100000),Z=(Min=0.100000,Max=1.100000))
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=100.000000,Max=100.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=500.000000))
        Name="IceEmitter"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.IceEmitter'
}