class EToiletPaperEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=toiletPaper
        StaticMesh=StaticMesh'EGO_OBJ.CHI_ObjGO.GO_toiletpaper_PART'
        UseParticleColor=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.010000),Y=(Min=0.010000),Z=(Min=0.010000))
        SpawnedVelocityScaleRange=(X=(Min=0.010000,Max=1.000000),Y=(Min=0.010000,Max=1.000000),Z=(Min=0.010000,Max=1.000000))
        UseSpawnedVelocityScale=True
        MaxParticles=1
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(Y=(Min=-1.000000,Max=1.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.010000,Max=1.000000),Y=(Min=0.010000,Max=1.000000),Z=(Min=0.010000,Max=1.000000))
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Regular
        LifetimeRange=(Min=100000.000000,Max=100000.000000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=50.000000,Max=75.000000),Z=(Min=200.000000,Max=200.000000))
        Name="toiletPaper"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.toiletPaper'
}