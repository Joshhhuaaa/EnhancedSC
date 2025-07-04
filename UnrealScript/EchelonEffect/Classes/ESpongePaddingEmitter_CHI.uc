class ESpongePaddingEmitter_CHI extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=SpongePaddingEmitter_CHI
        StaticMesh=StaticMesh'EGO_OBJ.CHI_ObjGO.GO_Sponge_Padding_PART'
        RenderTwoSided=True
        Acceleration=(Z=-200.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.010000,Max=0.250000),Y=(Min=0.010000,Max=0.250000),Z=(Min=0.010000,Max=0.250000))
        SpawnedVelocityScaleRange=(X=(Min=0.100000,Max=1.000000),Y=(Min=0.100000,Max=1.000000),Z=(Min=0.100000,Max=1.000000))
        UseSpawnedVelocityScale=True
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        RotationOffset=(Pitch=10,Yaw=10,Roll=10)
        SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.100000,Max=1.000000),Y=(Min=0.100000,Max=1.000000),Z=(Min=0.100000,Max=1.000000))
        RotationNormal=(X=10.000000,Y=10.000000,Z=10.000000)
        StartSizeRange=(X=(Min=0.250000,Max=2.000000),Y=(Min=0.250000,Max=2.000000),Z=(Min=0.250000,Max=2.000000))
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=100000.000000,Max=100000.000000)
        StartVelocityRange=(X=(Min=-25.000000,Max=-75.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=50.000000,Max=200.000000))
        VelocityLossRange=(Z=(Max=2.000000))
        Name="SpongePaddingEmitter_CHI"
    End Object
    Emitters(0)=MeshEmitter'SpongePaddingEmitter_CHI'
}