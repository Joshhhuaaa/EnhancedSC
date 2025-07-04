class EFeatherEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=FeatherEmitter
        Acceleration=(Z=-2.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.100000),Y=(Min=0.100000),Z=(Min=0.100000))
        SpawnedVelocityScaleRange=(X=(Max=0.100000),Y=(Max=0.100000),Z=(Max=1.000000))
        UseSpawnedVelocityScale=True
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        RotationOffset=(Pitch=10,Yaw=10,Roll=10)
        SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000),Y=(Min=-0.200000,Max=0.200000),Z=(Min=-0.200000,Max=0.200000))
        StartSpinRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=0.100000),Y=(Max=0.100000),Z=(Max=0.100000))
        RotationNormal=(X=10.000000,Y=10.000000,Z=10.000000)
        StartSizeRange=(X=(Max=3.000000),Y=(Max=3.000000),Z=(Max=3.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.CHI_TexGO.feather'
        LifetimeRange=(Min=100.000000,Max=100.000000)
        StartVelocityRange=(X=(Min=-5.000000,Max=-5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Max=50.000000))
        VelocityLossRange=(Z=(Max=1.000000))
        Name="FeatherEmitter"
    End Object
    Emitters(0)=SpriteEmitter'FeatherEmitter'
}