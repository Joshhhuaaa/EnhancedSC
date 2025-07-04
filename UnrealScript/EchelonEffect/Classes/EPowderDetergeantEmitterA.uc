class EPowderDetergeantEmitterA extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=PowderDetergeantEmitterA0
        StaticMesh=StaticMesh'EMeshSFX.Item.Detergeant_poudrePART_01_01B'
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.700000,Max=0.200000),Y=(Min=0.700000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=1
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=100.000000,Max=100.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=300.000000,Max=400.000000))
        Name="PowderDetergeantEmitterA0"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.PowderDetergeantEmitterA0'
    bUnlit=false
}