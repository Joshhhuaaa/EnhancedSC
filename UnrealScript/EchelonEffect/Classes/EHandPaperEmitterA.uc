class EHandPaperEmitterA extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=handPaperA
        StaticMesh=StaticMesh'EGO_OBJ.CHI_ObjGO.GO_paperdispens_chi_PART'
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
        SpinsPerSecondRange=(X=(Min=-0.010000,Max=0.010000),Y=(Min=-0.010000,Max=0.010000),Z=(Min=-0.010000,Max=0.010000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.010000,Max=1.000000),Y=(Min=0.010000,Max=1.000000),Z=(Min=0.010000,Max=1.000000))
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Regular
        LifetimeRange=(Min=100000.000000,Max=100000.000000)
        StartVelocityRange=(Z=(Min=200.000000,Max=200.000000))
        Name="handPaperA"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.handPaperA'
}