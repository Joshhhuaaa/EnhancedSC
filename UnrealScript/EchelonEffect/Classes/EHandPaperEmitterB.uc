class EHandPaperEmitterB extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=handPaperB
        StaticMesh=StaticMesh'EGO_OBJ.CHI_ObjGO.GO_paperdispens_chi_PARTB'
        UseParticleColor=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        ExtentMultiplier=(Z=0.500000)
        DampingFactorRange=(X=(Min=0.010000,Max=0.500000),Y=(Min=0.010000,Max=0.500000),Z=(Min=0.100000,Max=0.500000))
        SpawnedVelocityScaleRange=(X=(Min=0.001000,Max=1.000000),Y=(Min=0.001000,Max=1.000000),Z=(Min=0.001000,Max=1.000000))
        UseSpawnedVelocityScale=True
        MaxParticles=1
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.500000,Max=0.500000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.010000,Max=1.000000),Y=(Min=0.010000,Max=1.000000),Z=(Min=0.010000,Max=1.000000))
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Regular
        LifetimeRange=(Min=100000.000000,Max=100000.000000)
        StartVelocityRange=(X=(Min=10.000000,Max=10.000000),Z=(Min=300.000000,Max=300.000000))
        Name="handPaperB"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.handPaperB'
}