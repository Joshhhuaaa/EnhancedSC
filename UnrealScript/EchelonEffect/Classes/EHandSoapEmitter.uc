class EHandSoapEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=handSoap
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.010000),Y=(Min=0.010000),Z=(Min=0.010000,Max=0.500000))
        SpawnedVelocityScaleRange=(X=(Min=0.010000,Max=1.000000),Y=(Min=0.010000,Max=1.000000),Z=(Min=0.010000,Max=1.000000))
        UseSpawnedVelocityScale=True
        UseColorScale=True
        ColorScale(0)=(RelativeTime=10.000000,Color=(B=255,G=255,R=255))
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=20
        ResetAfterChange=True
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        RotationOffset=(Pitch=10,Yaw=10,Roll=10)
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.010000,Max=1.000000),Y=(Min=0.010000,Max=1.000000),Z=(Min=0.010000,Max=1.000000))
        RotationNormal=(X=10.000000,Y=10.000000,Z=10.000000)
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=0.500000,Max=4.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.bullet_impact.SFX_BPorcelain_White'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=40.000000,Max=40.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=500.000000))
        Name="handSoap"
    End Object
    Emitters(0)=SpriteEmitter'handSoap'
}