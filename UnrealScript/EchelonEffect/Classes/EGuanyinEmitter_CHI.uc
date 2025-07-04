class EGuanyinEmitter_CHI extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter101
        StaticMesh=StaticMesh'EGO_OBJ.CHI_ObjGO.GO_Guanyin_Chi_PART'
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.100000,Max=0.500000),Y=(Min=0.100000,Max=0.500000),Z=(Max=0.500000))
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
        StartSizeRange=(X=(Min=0.100000,Max=0.750000),Y=(Min=0.100000,Max=0.750000),Z=(Min=0.100000,Max=0.750000))
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Regular
        LifetimeRange=(Min=100000.000000,Max=100000.000000)
        StartVelocityRange=(X=(Min=-25.000000,Max=-75.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-100.000000,Max=400.000000))
        Name="MeshEmitter101"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.MeshEmitter101'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter175
        Acceleration=(Z=-4.000000)
        UseColorScale=True
        ColorScale(0)=(RelativeTime=1.000000)
        ColorScale(1)=(RelativeTime=4.000000)
        FadeOutStartTime=10.000000
        FadeOut=True
        FadeInEndTime=10.000000
        FadeIn=True
        MaxParticles=4
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.010000,Max=0.010000),Y=(Min=-0.010000,Max=0.010000),Z=(Min=-0.010000,Max=0.010000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=2.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=20.000000,Max=40.000000),Y=(Min=20.000000,Max=40.000000),Z=(Min=20.000000,Max=40.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.Brown_Dust'
        LifetimeRange=(Min=20.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-40.000000,Max=20.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
        Name="SpriteEmitter175"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter175'
}