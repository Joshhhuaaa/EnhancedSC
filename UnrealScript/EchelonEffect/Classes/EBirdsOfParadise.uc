class EBirdsOfParadise extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=bidsofparadise
        StaticMesh=StaticMesh'EMeshSFX.Item.birdsofparadisePART'
        RenderTwoSided=True
        Acceleration=(Z=-100.000000)
        UseCollision=True
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        MaxParticles=2
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.500000),Y=(Max=0.250000),Z=(Max=0.250000))
        DampRotation=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        InitialTimeRange=(Min=-20.000000,Max=-20.000000)
        LifetimeRange=(Min=20.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=100.000000,Max=400.000000))
        VelocityLossRange=(Z=(Min=2.000000,Max=5.000000))
        Name="bidsofparadise"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.bidsofparadise'
}