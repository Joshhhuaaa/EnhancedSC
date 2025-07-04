class EGarbageBinEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=EGarbageCanEmitter0
        StaticMesh=StaticMesh'EGO_OBJ.Kola_ObjGO.GO_KolaVODKA2b'
        RenderTwoSided=True
        Acceleration=(X=10.000000,Z=-800.000000)
        UseCollision=True
        DampingFactorRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Min=0.100000,Max=0.250000))
        MaxParticles=1
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.001000,Max=0.200000),Y=(Min=0.001000,Max=0.150000),Z=(Min=0.001000,Max=0.250000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.010000,Max=0.250000),Y=(Min=0.100000,Max=0.200000),Z=(Min=0.100000,Max=0.300000))
        DrawStyle=PTDS_Regular
        InitialTimeRange=(Min=-50.000000,Max=-50.000000)
        LifetimeRange=(Min=0.100000,Max=0.100000)
        StartVelocityRange=(X=(Min=-25.000000,Max=-25.000000),Y=(Min=-100.000000,Max=-100.000000))
        Name="EGarbageCanEmitter0"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.EGarbageCanEmitter0'
    Begin Object Class=MeshEmitter Name=EGarbageCanEmitter1
        StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.GO_cancoke'
        Acceleration=(Z=-980.000000)
        UseCollision=True
        UseSpawnedVelocityScale=True
        MaxParticles=5
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        SpinParticles=True
        SpinCCWorCW=(X=1.000000,Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Max=4.000000),Y=(Max=4.000000),Z=(Max=4.000000))
        StartSpinRange=(X=(Min=1.000000,Max=10.000000),Y=(Min=1.000000,Max=10.000000),Z=(Min=1.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.250000,Max=0.500000),Y=(Min=0.250000,Max=0.500000),Z=(Min=0.250000,Max=0.500000))
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=100.000000,Max=1000.000000))
        Name="EGarbageCanEmitter1"
    End Object
    Emitters(1)=MeshEmitter'EchelonEffect.EGarbageCanEmitter1'
}