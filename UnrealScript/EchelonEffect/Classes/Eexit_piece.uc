class Eexit_piece extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=exit_piece
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.900000,Max=0.900000),Y=(Min=0.900000,Max=0.900000),Z=(Min=0.400000,Max=0.500000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.500000
        FadeOut=True
        MaxParticles=5
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-1000.000000,Max=1000.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
        StartSpinRange=(X=(Min=-1000.000000,Max=1000.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=0.300000,Max=2.000000))
        UniformSize=True
        InitialParticlesPerSecond=1500.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.bullet_impact.SFX_BPorcelain_White'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=1.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=-500.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-50.000000,Max=400.000000))
        Name="exit_piece"
    End Object
    Emitters(0)=SpriteEmitter'exit_piece'
    bUnlit=false
}