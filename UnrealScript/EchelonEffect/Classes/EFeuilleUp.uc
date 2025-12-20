class EFeuilleUp extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=FeuilleUp
        StaticMesh=StaticMesh'EMeshSFX.Item.FeuilleParticules'
        RenderTwoSided=True
        Acceleration=(Z=-300.000000)
        UseCollision=True
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=5
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.500000),Z=(Max=0.250000))
        DampRotation=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=30.000000,Max=60.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=500.000000,Max=1000.000000))
        VelocityLossRange=(Z=(Min=2.000000,Max=5.000000))
        Name="FeuilleUp"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.FeuilleUp'
    bUnlit=False
}